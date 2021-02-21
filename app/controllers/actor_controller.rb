class ActorController < ApplicationController
  def find
    # http://localhost:3000/actors?ids[]=1&ids[]=2&ids[]=3
    ids = params[:ids]

    sql = <<~SQL
      SELECT a.*
      FROM actors a
      WHERE a.id IN (:ids);
    SQL
    query = ActiveRecord::Base.sanitize_sql([ sql, ids: ids])
    data = ActiveRecord::Base.connection.execute(query)

    actors = []
    data.each { |line|
      actors << {
        id: line['id'],
        first_name: line['first_name'],
        last_name: line['last_name'],
        co_actors: fetch_co_actors(line['id'])
      }
    }

    render :json => actors, status: :ok
  end

  private
  def fetch_co_actors(actor_id)
    sql = <<~SQL
      WITH movies_for_actor AS (
        SELECT m.id
        FROM movies m
        JOIN movies_actors ma ON ma.movie_id = m.id
        WHERE ma.actor_id = :id
      )
      SELECT COUNT(a.id) AS co_actor_count, a.id, a.first_name, a.last_name
        FROM actors a
        JOIN movies_actors ma ON ma.actor_id = a.id
        WHERE ma.movie_id IN (SELECT id FROM movies_for_actor)
        AND a.id <> :id
        GROUP BY a.id
        ORDER BY co_actor_count DESC
        LIMIT 5;
    SQL
    query = ActiveRecord::Base.sanitize_sql([ sql, id: actor_id])
    ActiveRecord::Base.connection.execute(query)
  end
end