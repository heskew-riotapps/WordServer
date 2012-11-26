  class PlayedTile
  include MongoMapper::EmbeddedDocument
 
	key :p,   Integer, :default => -1 #board_position
	key :l, Array #letters
	key :t, Array #turn
  
  #figure this out...Array does not make sense when there is only one player
  #perhaps playerId is not needed
	def l_ #return the last letter
		return self.l.last
        # return self.l.count() > 0 ? self.l.substr(self.l.count - 1, self.l.count) : ""
 	end	

	def t_ #return the last turn
		return self.t.last
        # return self.l.count() > 0 ? self.l.substr(self.l.count - 1, self.l.count) : ""
 	end	
	
    def is_overlay?
        return self.l.count > 1 
 	end	
end
	 
 