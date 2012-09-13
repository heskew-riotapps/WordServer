class Game
  include MongoMapper::Document
  
  many :player_games #, :length => { :maximum => 2 }  
  many :played_words
#many :letters remaining vs played?#, :length => { :maximum => 2 }  
  many :played_tiles
  
  many :chatters
  key :d_c, String #dup_check..  just in case same post is sent more than once
  key :r_l, Array  #remaining letters
  key :p_l, Array #played_letters
  key :r_v, Array #random_vowels
  key :r_c, Array #random_consonants
  key :t,    Integer, :default => 0 #turn
  key :a_t, String ##auth_token not stored, only used to return back through json to client
  
  key :n_c_s, Integer, :default => 0 #num_consecutive_skips
  #key :num_words_played, Integer, :default => 0
  key :co_d, Time #completion_date
  key :cr_d, Time #create_date
  key :st, Integer #status
  
  def left
	return self.r_l.count
  end
  
  def generate_hopper_letters(culture_code)
		if self.authenticate(password)
			self.generate_token(:auth_token)
			true
		else 
			false
		end	
	end
  
  
  
  
  # Validations.
#  validates_presence_of :first_name, :last_name, :email 

end