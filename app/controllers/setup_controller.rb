class SetupController < ApplicationController
  def init
    ActiveRecord::Base.connection.execute('DELETE FROM movies_actors')
    ActiveRecord::Base.connection.execute('DELETE FROM movies_genres')
    ActiveRecord::Base.connection.execute('DELETE FROM movies')
    ActiveRecord::Base.connection.execute('DELETE FROM actors')
    ActiveRecord::Base.connection.execute('DELETE FROM genres')

    actors_data = CallApi::new.call('https://0zrzc6qbtj.execute-api.us-east-1.amazonaws.com/kinside/actors')

    actors_data.each { |actor|
      sql = <<~SQL
        INSERT INTO actors (id, first_name, last_name) VALUES (:id, :first_name, :last_name)
      SQL
      query = ActiveRecord::Base.sanitize_sql(
        [
          sql,
          id: actor['id'],
          first_name: actor['first_name'],
          last_name: actor['last_name'],
        ]
      )
      ActiveRecord::Base.connection.execute(query)
    }

    movies_data = CallApi::new.call('https://0zrzc6qbtj.execute-api.us-east-1.amazonaws.com/kinside/movies')
    movies_data.each { |movie|
      sql = <<~SQL
        INSERT INTO movies
          (id, title, year, runtime, director, plot, poster_url, rating, page_url)
        VALUES
          (:id, :title, :year, :runtime, :director, :plot, :poster_url, :rating, :page_url)
      SQL
      query = ActiveRecord::Base.sanitize_sql(
        [
          sql,
          id: movie['id'],
          title: movie['title'],
          year: movie['year'].to_i,
          runtime: movie['runtime'].to_i,
          director: movie['director'],
          plot: movie['plot'],
          poster_url: movie['posterUrl'],
          rating: movie['rating'].to_f,
          page_url: movie['pageUrl'],
        ]
      )
      ActiveRecord::Base.connection.execute(query)

      movie_genres = movie['genres'].map { |genre_label|
        genre_id = genre_label.downcase
        sql = <<~SQL
          INSERT INTO genres (id, label) VALUES (:id, :label) ON CONFLICT DO NOTHING
        SQL
        ActiveRecord::Base.connection.execute(ActiveRecord::Base.sanitize_sql([ sql, id: genre_id, label: genre_label ]))

        sql = <<-SQL
          INSERT INTO movies_genres (genre_id, movie_id) VALUES (:genre_id, :movie_id)
        SQL
        ActiveRecord::Base.connection.execute(ActiveRecord::Base.sanitize_sql([ sql, genre_id: genre_id, movie_id: movie['id']]))
      }
      movie_actors = movie['actorIds'].map { |actor_id|
        # Some keys are inconsistent with the actors endpoint...
        begin
          sql = <<-SQL
            INSERT INTO movies_actors (actor_id, movie_id) VALUES (:actor_id, :movie_id)
          SQL
          ActiveRecord::Base.connection.execute(ActiveRecord::Base.sanitize_sql([ sql, actor_id: actor_id, movie_id: movie['id'] ]))
        rescue ActiveRecord::InvalidForeignKey
          print("Inconsistent key: actor_id #{actor_id}, movie_id #{movie['id']}")
        end
      }
    }

    render :json => 'ok', status: :ok
  end
end