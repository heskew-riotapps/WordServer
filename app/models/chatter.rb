class Chatter
  include MongoMapper::EmbeddedDocument

  belongs_to :game
  key :text,     String
  key :player_id , ObjectId
  key :game_id , ObjectId
  key :chatter_date, Time
end