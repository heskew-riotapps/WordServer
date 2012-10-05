class Chatter
  include MongoMapper::EmbeddedDocument

  key :text,     String
  key :player_id , ObjectId
  key :game_id , ObjectId
  key :chatter_date, Time
end