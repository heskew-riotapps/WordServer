class AlphabetENService
	def self.get_random_vowels
		return ["A","E","I","O","U"].shuffle.first(2) 
	end


end