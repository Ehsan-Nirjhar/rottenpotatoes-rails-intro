class Movie < ActiveRecord::Base
    @all_ratings = ['G','PG','PG-13','R']   ###create variables for ratings
    def self.all_ratings
        @all_ratings
    end
end
