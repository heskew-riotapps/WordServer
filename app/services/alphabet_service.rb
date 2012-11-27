class AlphabetService
	#determine which culture is in context and call appropriate class
	def self.get_random_vowels
		return AlphabetENService.get_random_vowels	
	end

	def self.get_random_consonants
		return AlphabetENService.get_random_consonants 
	end	
	
	def self.get_letter_distribution
		return AlphabetENService.get_letter_distribution
	end
	
	def self.get_letter_value(letter)
		return AlphabetENService.get_letter_value(letter)
	end
	
end