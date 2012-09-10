  class TrayTile
  include MongoMapper::EmbeddedDocument
 
	key :tray_position,     Integer, :default => 0
	key :letter, String
  
	def get_last_played_letter 
         return self.letter.length > 0 ? self.letters.substr(self.letter.length - 1, self.letter.length) : ""
 	end	

end
	 
 