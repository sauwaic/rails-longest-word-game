class InterfaceController < ApplicationController
  require 'open-uri'
  require 'json'

  def game
    @grid = generate_grid
    @start_time = Time.now
  end

  def score
    attempt = params[:attempt]
    grid = params[:grid]
    start_time = params[:start_time]
    puts params
    end_time = Time.now
    @results = run_game(attempt, grid, start_time, end_time)
  end

  def generate_grid
    grid = []
    10.times do
      grid << ("A".."Z").to_a.sample
    end
    return grid
  end

  def run_game(attempt, grid, start_time, end_time)
  # Turning input into hash
  attempt_hash = Hash.new(0)
  attempt_array = attempt.upcase.chars
  attempt_array.each do |characters|
    attempt_hash[characters.to_sym] += 1
  end

  # Turning grid into hash
  grid_array = grid.chars
  grid_hash = Hash.new(0)
  grid_array.each do |characters|
    grid_hash[characters.to_sym] += 1
  end

  url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=6fffab07-147d-4db9-b23b-29e0883f098a&input=#{attempt}"
  trans_serialized = open(url).read
  trans = JSON.parse(trans_serialized)

  result = {}
  result[:translation] = trans["outputs"][0]["output"]
  result[:message] = "well done"

  breach = []
  attempt_hash.keys.each do |letter|
    breach << (grid_hash[letter] < attempt_hash[letter])
  end
  # Not in the grid
  if breach.include?(true)
    result[:message] = "not in the grid"
    result[:score] = 0
  # English word
  elsif attempt == result[:translation]
    result[:translation] = nil
    result[:message] = "not an english word"
    result[:score] = 0
  else
    start_time = Time.parse(start_time)
    time_score = (start_time - end_time)/10000000
    result[:score] = (attempt.size * 10) + time_score
  end

    return result
      # TODO: runs the game and return detailed hash of result
  end


end
