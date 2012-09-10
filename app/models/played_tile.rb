  class PlayedTile
  include MongoMapper::EmbeddedDocument
 
	key :player_id , ObjectId
	key :board_position,     Integer, :default => 0
	key :letters, String
	key :turn,     Integer, :default => 0
  
  
	def get_last_played_letter 
         return self.letter.length > 0 ? self.letters.substr(self.letter.length - 1, self.letter.length) : ""
 	end	

    def is_overlay?
        return self.letters.length > 1 
 	end	
end
	 
 