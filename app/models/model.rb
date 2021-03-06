class Model < ApplicationRecord
  enum team: {
   'Atlanta Hawks': 0,
   'Boston Celtics': 1,
   'Brooklyn Nets': 2,
   'Charlotte Hornets': 3,
   'Chicago Bulls': 4,
   'Cleveland Cavaliers': 5,
   'Dallas Mavericks': 6,
   'Denver Nuggets': 7,
   'Detroit Pistons': 8,
   'Golden State Warriors': 9,
   'Houston Rockets': 10,
   'Indiana Pacers': 11,
   'Los Angeles Clippers': 12,
   'Los Angeles Lakers': 13,
   'Memphis Grizzlies': 14,
   'Miami Heat': 15,
   'Minnesota Timberwolves': 16,
   'Milwaukee Bucks': 17,
   'New Orleans Pelicans': 18,
   'New York Knicks': 19,
   'Oklahoma City Thunder': 20,
   'Orlando Magic': 21,
   'Philadelphia 76ers': 22,
   'Phoenix Suns': 23,
   'Portland Trail Blazers': 24,
   'Sacramento Kings': 25,
   'San Antonio Spurs': 26,
   'Toronto Raptors': 27,
   'Utah Jazz': 28,
   'Washington Wizards': 29
  }
  validates :ref,
            :name,
            :description,
            :discount,
            :team,
            :price,
            :deal_price,
            :category_id,
            presence: true
  has_many :products
  belongs_to :category
end
