class PlayedWord
  include MongoMapper::EmbeddedDocument

  key :word,     String
  key :player_id , ObjectId
  key :turn_num,     Integer, :default => 0
  key :points_scored, Integer, :default => 0
  key :played_date, Time
end