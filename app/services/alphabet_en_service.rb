class AlphabetENService
	def self.get_random_vowels
		return ["A","E","I","O","U"].shuffle.first(2) 
	end

	def self.get_random_consonants
		return ["B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z"].shuffle.first(3) 
	end	
	
	def self.get_letter_distribution
		return ["A","A","A","A","A","A","A","A","B","B","C","C","D","D","D","D","E","E","E","E","E","E","E","E","E","E","E","E","F","F","G","G","H","H","H","H","I","I","I","I","I","I","I","I","J","K","L","L","L","L","M","M","N","N","N","N","N","N","O","O","O","O","O","O","O","O","P","P","Q","R","R","R","R","R","R","S","S","S","S","S","T","T","T","T","T","T","T","T","U","U","U","U","V","W","W","X","Y","Y","Z"] 
		
        #A - 8
		#B = 2
		#C = 2
		#D = 4
		#E = 12
		#F = 2
		#G = 2
		#H = 4
		#I = 8
		#J = 1
		#K = 1
		#L = 4
		#M = 2
		#N = 6
		#O = 8
		#P = 2
		#Q = 1
		#R = 6
		#S = 5
		#T = 9
		#U = 4
		#V = 1
		#W = 2
		#X = 1
		#Y = 2
		#Z = 1

	end
	
	def self.get_letter_value(letter)
		value = 1
		
		case letter.upcase
		when "A"
			value = 1
		when "B"
			value = 6
		when "C"
			value = 5
		when "D"
			value = 3
		when "E"
			value = 1
		when "F"
			value = 5
		when "G"
			value = 5
		when "H"
			value = 2
		when "I"
			value = 1
		when "J"
			value = 10
		when "K"
			value = 7
		when "L"
			value = 3
		when "M"
			value = 5
		when "N"
			value = 2
		when "O"
			value = 1
		when "P"
			value = 6			
		when "Q"
			value = 10
		when "R"
			value = 2
		when "S"
			value = 1
		when "T"
			value = 1
		when "U"
			value = 2
		when "V"
			value = 7
		when "W"
			value = 5
		when "X"
			value = 10
		when "Y"
			value = 6
		when "Z"
			value = 10	
		end
		
		return value
	end
	
end