  class PlayedTile
  include MongoMapper::EmbeddedDocument
 
	key :player_id , ObjectId
	key :p,   Integer, :default => 0 #board_position
	key :l, Array #letters
	key :t,     Integer, :default => 0 #turn
  
  #figure this out...Array does not make sense when there is only one player
  #perhaps playerId is not needed
	def last 
	
         return self.l.count() > 0 ? self.l.substr(self.l.count - 1, self.l.count) : ""
 	end	

    def is_overlay?
        return self.l.count > 1 
 	end	
end
	 
 