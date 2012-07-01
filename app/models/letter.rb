class Letter
	include MongoMapper::Document
 	
	key :value, String, :length => 1, :format => /[A-Z]/
    
	before_validation :make_upper 

	private
	def make_upper
		self.value = value.nil? ? nil : value.upcase
	end
end

