class Chat
  include MongoMapper::EmbeddedDocument

  belongs_to :game
  key :t,     String
  key :player_id , ObjectId
  key :ch_d, Time
end