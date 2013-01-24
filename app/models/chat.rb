class Chat
  include MongoMapper::EmbeddedDocument
  plugin MongoMapper::Plugins::IdentityMap

  belongs_to :game
  key :t,     String  #text
  key :player_id , ObjectId
  key :ch_d, Time #chat date
end