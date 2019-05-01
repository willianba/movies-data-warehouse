require 'csv'

csv = CSV.parse(File.read('movies.csv'), headers: true)

distinct_movie_titles = []
distinct_actor_names = []
distinct_country_names = []
distinct_genres = []
distinct_director_names = []
distinct_keywords = []

index_actor = -1
index_keyword = -1
csv.each do |row|
  columns = row.to_s.split(',')
  index = columns[0].to_i
  color = columns[1]
  director_name = columns[2].gsub("'", "`")
  num_critic_for_reviews = columns[3]
  duration = columns[4]
  director_facebook_likes = columns[5]
  actor_3_facebook_likes = columns[6]
  actor_2_name = columns[7].gsub("'", "`")
  actor_1_facebook_likes = columns[8]
  gross = columns[9]
  genre = columns[10].split('|').first
  subgenre = columns[10].split('|')[1]
  actor_1_name = columns[11].gsub("'", "`")
  movie_title = columns[12].gsub("'", "`")
  num_voted_users = columns[13]
  cast_total_facebook_likes = columns[14]
  actor_3_name = columns[15].gsub("'", "`")
  plot_keywords = columns[16].split('|').each { |k| k.gsub!("'", "`") }
  num_user_for_reviews = columns[17]
  language = columns[18]
  country = columns[19]
  content_rating = columns[20]
  budget = columns[21]
  title_year = columns[22]
  actor_2_facebook_likes = columns[23]
  imdb_score = columns[24]
  movie_facebook_likes = columns[25].split(' ').first

  movie = { id: index, content: movie_title }
  if index == 0 || distinct_movie_titles.select { |h| h[:content] == movie[:content] }.empty?
    puts "INSERT INTO dim_movie VALUES (#{index}, '#{movie_title[0...-1]}', #{duration}, '#{color}', '#{content_rating}');"
    distinct_movie_titles.push(movie)
  end

  puts "INSERT INTO dim_cast VALUES (#{index});"
  
  actor_1 = { id: index_actor += 1, content: actor_1_name }
  if index == 0 || distinct_actor_names.select { |h| h[:content] == actor_1[:content] }.empty?
    puts "INSERT INTO dim_actor VALUES (#{index_actor}, #{actor_1_facebook_likes}, '#{actor_1_name}');"
    puts "INSERT INTO bridge_cast VALUES (#{index}, #{index_actor});"
    distinct_actor_names.push(actor_1)
  end
  
  actor_2 = { id: index_actor += 1, content: actor_2_name }
  if index == 0 || distinct_actor_names.select { |h| h[:content] == actor_2[:content] }.empty?
    puts "INSERT INTO dim_actor VALUES (#{index_actor}, #{actor_2_facebook_likes}, '#{actor_2_name}');"
    puts "INSERT INTO bridge_cast VALUES (#{index}, #{index_actor});"
    distinct_actor_names.push(actor_2)
  end
  
  actor_3 = { id: index_actor += 1, content: actor_3_name }
  if index == 0 || distinct_actor_names.select { |h| h[:content] == actor_3[:content] }.empty?
    puts "INSERT INTO dim_actor VALUES (#{index_actor}, #{actor_3_facebook_likes}, '#{actor_3_name}');"
    puts "INSERT INTO bridge_cast VALUES (#{index}, #{index_actor});"
    distinct_actor_names.push(actor_3)
  end

  puts "INSERT INTO dim_year VALUES (#{index}, #{title_year});"

  country_hash = { id: index, content: country }
  if index == 0 || distinct_country_names.select { |h| h[:content] == country_hash[:content] }.empty?
    puts "INSERT INTO dim_country VALUES (#{index}, '#{country}', '#{language}');"
    distinct_country_names.push(country_hash)
  end

  genre_hash = { id: index, main: genre, sub: subgenre }
  if index == 0 || distinct_genres.select { |h| h[:main] == genre_hash[:main] && h[:sub] == genre_hash[:sub] }.empty?
      puts "INSERT INTO dim_genre VALUES (#{index}, '#{genre}', '#{subgenre}');"
      distinct_genres.push(genre_hash)
  end

  director = { id: index, content: director_name }
  if index == 0 || distinct_director_names.select { |h| h[:content] == director[:content] }.empty?
    puts "INSERT INTO dim_director VALUES (#{index}, '#{director_name}', #{director_facebook_likes});"
    distinct_director_names.push(director)
  end

  puts "INSERT INTO dim_likes VALUES (#{index}, #{movie_facebook_likes}, #{cast_total_facebook_likes});"
  puts "INSERT INTO dim_imdb VALUES (#{index}, #{num_voted_users}, #{num_user_for_reviews}, #{num_critic_for_reviews}, #{imdb_score});"
  puts "INSERT INTO dim_keywords VALUES (#{index});"

  plot_keywords.each do |keyword|
    keyword_hash = { id: index_keyword += 1, content: keyword }
    next unless distinct_keywords.select { |k| k[:content] == keyword_hash[:content] }.empty?
    puts "INSERT INTO dim_keyword VALUES (#{index_keyword}, '#{keyword}');"
    puts "INSERT INTO bridge_keywords VALUES (#{index}, #{index_keyword});"
    distinct_keywords.push(keyword_hash)
  end

  movie_id = movie[:id]
  country_id = country_hash[:id]
  genre_id = genre_hash[:id]
  director_id = director[:id]

  unless index == 0
    movie_id = distinct_movie_titles.select { |h| h[:content] == movie[:content] }.first[:id]
    country_id = distinct_country_names.select { |h| h[:content] == country_hash[:content] }.first[:id]
    genre_id = distinct_genres.select { |h| h[:main] == genre_hash[:main] && h[:sub] == genre_hash[:sub] }.first[:id]
    director_id = distinct_director_names.select { |h| h[:content] == director[:content] }.first[:id]
  end

  puts "INSERT INTO fato VALUES (#{index}, #{budget}, #{gross}, #{gross.to_i - budget.to_i}, #{movie_id}, #{index}, #{index}, #{country_id}, #{genre_id}, #{index}, #{index}, #{director_id}, #{index});"
end