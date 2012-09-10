class Game
  include MongoMapper::Document
  
  many :player_games #, :length => { :maximum => 2 }  
  many :played_words
#many :letters remaining vs played?#, :length => { :maximum => 2 }  
  many :played_tiles
  
  many :chatters
  key :dup_check, String #just in case same post is sent more than once
  key :remaining_letters, Array
  key :played_letters, Array
  key :random_vowels, Array #, format => /[A,E,I,O,U]/
  key :random_consonants, Array #, format => /[B,C,D,F,G,H,J,K,L,M,N,P,Q,R,S,T,V,W,X,Y,Z]/
  key :turn_num,    Integer, :default => 0
  
  key :num_consecutive_skips, Integer, :default => 0
  key :num_words_played, Integer, :default => 0
  key :completion_date, Time
  key :last_action_popup_title, String
  key :last_action_popup_text, String
  key :last_action_alert_text, String
  key :status, Integer
  
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