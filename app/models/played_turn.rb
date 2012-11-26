 class PlayedTurn
  include MongoMapper::EmbeddedDocument
 
	key :player_id , ObjectId
	key :t, Integer #turn
	key :a, Integer, :default => 0 #action, see playerGame last_turn_action for options
	key :p, Integer, :default => 0 #points for this turn
end
 