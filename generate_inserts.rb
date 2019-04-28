require 'csv'
require 'securerandom'

csv = CSV.parse(File.read('movies.csv'), headers: true)

csv.each do |row|
  columns = row.to_s.split(',')

  row_number = columns[0].to_i
  color = columns[1]
  director_name = columns[2]
  num_critic_for_reviews = columns[3]
  duration = columns[4]
  director_facebook_likes = columns[5]
  actor_3_facebook_likes = columns[6]
  actor_2_name = columns[7]
  actor_1_facebook_likes = columns[8]
  gross = columns[9]
  genre = columns[10].split('|').first
  actor_1_name = columns[11]
  movie_title = columns[12]
  num_voted_users = columns[13]
  cast_total_facebook_likes = columns[14]
  actor_3_name = columns[15]
  plot_keywords = columns[16].split('|')
  num_user_for_reviews = columns[17]
  language = columns[18]
  country = columns[19]
  content_rating = columns[20]
  budget = columns[21]
  title_year = columns[22]
  actor_2_facebook_likes = columns[23]
  imdb_score = columns[24]
  movie_facebook_likes = columns[25].split(' ').first

  puts "INSERT INTO dim_movie VALUES (#{row_number}, '#{movie_title}', #{duration}, '#{color}', '#{content_rating}');"
  puts "INSERT INTO dim_cast VALUES (#{row_number});"
  puts "INSERT INTO dim_actor VALUES (#{row_number}, #{actor_1_facebook_likes}, '#{actor_1_name}');"
  puts "INSERT INTO dim_actor VALUES (#{row_number + 1}, #{actor_2_facebook_likes}, '#{actor_2_name}');"
  puts "INSERT INTO dim_actor VALUES (#{row_number + 2}, #{actor_3_facebook_likes}, '#{actor_3_name}');"
  
  # bridge_cast
  puts "INSERT INTO bridge_cast VALUES (#{row_number}, #{row_number});"
  puts "INSERT INTO bridge_cast VALUES (#{row_number}, #{row_number + 1});"
  puts "INSERT INTO bridge_cast VALUES (#{row_number}, #{row_number + 2});"

  puts "INSERT INTO dim_year VALUES (#{row_number}, #{title_year});"
  puts "INSERT INTO dim_country VALUES (#{row_number}, '#{country}', '#{language}');"
  puts "INSERT INTO dim_genre VALUES (#{row_number}, '#{genre}');"
  puts "INSERT INTO dim_director VALUES (#{row_number}, '#{director_name}', #{director_facebook_likes});"
  puts "INSERT INTO dim_likes VALUES (#{row_number}, #{movie_facebook_likes}, #{cast_total_facebook_likes});"
  puts "INSERT INTO dim_imdb VALUES (#{row_number}, #{num_voted_users}, #{num_user_for_reviews}, #{num_critic_for_reviews}, #{imdb_score});"
  puts "INSERT INTO dim_keywords VALUES (#{row_number});"

  # inserindo cada keyword separadamente
  plot_keywords.each do |keyword|
    random_id = SecureRandom.random_number(999999)
    puts "INSERT INTO dim_keyword VALUES (#{random_id}, '#{keyword}');"
    
    # bridge_keywords
    puts "INSERT INTO bridge_keywords VALUES (#{row_number}, #{random_id});"
  end

  # fato
  puts "INSERT INTO fato VALUES (#{row_number}, #{budget}, #{gross}, #{gross.to_i - budget.to_i}, #{row_number}, #{row_number}, #{row_number}, #{row_number}, #{row_number}, #{row_number}, #{row_number}, #{row_number}, #{row_number});"
end