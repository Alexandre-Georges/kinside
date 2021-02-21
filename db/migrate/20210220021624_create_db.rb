class CreateDb < ActiveRecord::Migration[6.1]
  def up
    sql = <<~SQL
      CREATE TABLE movies (
        id INTEGER PRIMARY KEY,
        title VARCHAR,
        year INTEGER,
        runtime VARCHAR,
        director VARCHAR,
        plot VARCHAR,
        poster_url VARCHAR,
        rating VARCHAR,
        page_url VARCHAR
      );
    SQL
    ActiveRecord::Base.connection.execute(sql)

    sql = <<~SQL
      CREATE TABLE actors (
        id VARCHAR PRIMARY KEY,
        first_name VARCHAR,
        last_name VARCHAR
      );
    SQL
    ActiveRecord::Base.connection.execute(sql)

    sql = <<~SQL
      CREATE TABLE genres (
        id VARCHAR PRIMARY KEY,
        label VARCHAR
      );
    SQL
    ActiveRecord::Base.connection.execute(sql)

    sql = <<~SQL
      CREATE TABLE movies_actors (
        movie_id VARCHAR,
        actor_id VARCHAR,
        FOREIGN KEY (movie_id) REFERENCES movies(id),
        FOREIGN KEY (actor_id) REFERENCES actors(id)
      );
    SQL
    ActiveRecord::Base.connection.execute(sql)

    sql = <<~SQL
      CREATE TABLE movies_genres (
        movie_id VARCHAR,
        genre_id VARCHAR,
        FOREIGN KEY (movie_id) REFERENCES movies(id),
        FOREIGN KEY (genre_id) REFERENCES genres(id)
      );
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    ActiveRecord::Base.connection.execute('DROP TABLE movies_genres')
    ActiveRecord::Base.connection.execute('DROP TABLE movies_actors')
    ActiveRecord::Base.connection.execute('DROP TABLE movies')
    ActiveRecord::Base.connection.execute('DROP TABLE genres')
    ActiveRecord::Base.connection.execute('DROP TABLE actors')
  end
end
