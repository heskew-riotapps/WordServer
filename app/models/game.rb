class Game
  include MongoMapper::Document
  safe # for mongo saves
  
  many :player_games #, :length => { :maximum => 2 }  
  many :played_words
  many :played_turns
#many :letters remaining vs played?#, :length => { :maximum => 2 }  
  many :played_tiles
   
  many :chatters
  #key :d_c, String #dup_check..  just in case same post is sent more than once
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
  key :ch_d, Time #last_chatter_date
  key :lp_d, Time #last_played_date
  
  #attr_accessor :a_t ##auth_token not stored, only used to return back through json to client
#  def self.active_by_player(player_id)
#    where(:st => 1, :player_games => {player_id => player_id, st => 1 )
#  end
#  Person.all(:conditions => {'addresses.city' => 'Chicago'})
  
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
  
  
	#after game is saved, loop through player games, removing tray tiles so they are not sent
	#out when they don't need to be...only the context user should receive tray tiles, to do otherwise
	#just wastes bandwidth...this is only for sending, NOT FOR SAVING
	#I did it this way because I couldn't figure out how to do it in controller in .to_json
	def strip_tray_tiles_from_non_context_user(content_player_id)
		self.player_games.each  do |value|
			if value.player_id != content_player_id
				value.t_l.clear 
			end
		end	
	end 	
		
	def is_player_part_of_game(context_player_id)
		ok = false
		self.player_games.each  do |value|
			if value.player_id == context_player_id
				ok = true 
			end
		end	
		return ok
	end 	

	def update_played_tile_by_board_position(board_position, letter, turn)
		found = false
		self.played_tiles.each  do |value|
			if value.player_id == board_position
				value.p = board_position
				value.l = letter
				value.t = turn
				found = true
			end
		end	
		if !found 
			played_tile = PlayedTile.new
			played_tile.p = board_position
			played_tile.l = letter
			played_tile.t = turn
			self.@played_tiles << played_tile
		end
	end 	


	#is it this player's turn?
	def isPlayerCurrentTurn(context_player_id, turn)
		ok = false
		self.player_games.each  do |value|
			if value.player_id == context_player_id && 
					turn == self.t &&
					value.i_t == true		
				ok = true 
			end
		end	
		return ok
	end
	
	#did this player start the game?
	def isPlayerStarter(context_player_id)
		ok = false
		self.player_games.each  do |value|
			if value.player_id == context_player_id && value.o == 1
				ok = true 
			end
		end	
		return ok
	end
  
  # Validations.
#  validates_presence_of :first_name, :last_name, :email 

end