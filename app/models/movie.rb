class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end #shortcut:array of strings 
end
