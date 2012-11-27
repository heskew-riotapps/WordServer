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
		char = letter.upcase

		if char == "A" return 1
		if char == "B" return 6
		if char == "C" return 5
		if char == "D" return 3
		if char == "E" return 1
		if char == "F" return 5
		if char == "G" return 5
		if char == "H" return 2
		if char == "I" return 1
		if char == "J" return 10
		if char == "K" return 7
		if char == "L" return 3
		if char == "M" return 5
		if char == "N" return 2
		if char == "O" return 1
		if char == "P" return 6
		if char == "Q" return 10
		if char == "R" return 2
		if char == "S" return 1
		if char == "T" return 1
		if char == "U" return 2
		if char == "V" return 7
		if char == "W" return 5
		if char == "X" return 10
		if char == "Y" return 6
		if char == "Z" return 10
	end
	
end