class MovieController < ApplicationController
  def find
    # http://localhost:3000/movies?ids[]=1&ids[]=2&ids[]=3
    ids = params[:ids]

    sql = <<~SQL
      SELECT
        m.id AS movie_id,
        m.title AS movie_title,
        m.year AS movie_year,
        m.runtime AS movie_runtime,
        m.director AS movie_director,
        m.plot AS movie_plot,
        m.poster_url AS movie_poster_url,
        m.rating AS movie_rating,
        m.page_url AS movie_page_url,
        a.id AS actor_id,
        a.first_name AS actor_first_name,
        a.last_name AS actor_last_name
      FROM movies m
      LEFT JOIN movies_actors ma ON m.id = ma.movie_id
      LEFT JOIN actors a ON ma.actor_id = a.id
      WHERE m.id IN (:movie_ids);
    SQL
    query = ActiveRecord::Base.sanitize_sql([ sql, movie_ids: ids])
    data = ActiveRecord::Base.connection.execute(query)
    movies = []
    current_movie = nil
    data.each { |line|
      if !current_movie.nil? && current_movie[:id] != line['movie_id']
        movies << current_movie
        current_movie = nil
      end
      if current_movie.nil?
        current_movie = {
          id: line['movie_id'],
          title: line['movie_title'],
          year: line['movie_year'],
          runtime: line['movie_runtime'],
          director: line['movie_director'],
          plot: line['movie_plot'],
          poster_url: line['movie_poster_url'],
          rating: line['movie_rating'],
          page_url: line['movie_page_url'],
          actors: [],
        }
      end
      current_movie[:actors] << {
        id: line['actor_id'],
        first_name: line['actor_first_name'],
        last_name: line['actor_last_name'],
      }
    }
    if !current_movie.nil?
      movies << current_movie
    end
    render :json => movies, status: :ok
  end
end