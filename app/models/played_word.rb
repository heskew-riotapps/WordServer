class PlayedWord
  include MongoMapper::EmbeddedDocument

  key :w,     String #word
  key :player_id , ObjectId
  key :t,     Integer, :default => 0 #turn_num
  key :p, Integer, :default => 0 #points_scored
  key :p_d, Time #played_date
end