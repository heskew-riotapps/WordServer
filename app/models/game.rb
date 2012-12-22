class Game
  include MongoMapper::Document
  safe # for mongo saves
  
  many :player_games #, :length => { :maximum => 2 }  
  many :played_words
  many :played_turns
#many :letters remaining vs played?#, :length => { :maximum => 2 }  
  many :played_tiles
   
  many :chats
  #key :d_c, String #dup_check..  just in case same post is sent more than once
  key :r_l, Array  #remaining letters
  #key :p_l, Array #played_letters  #don't think we need this, played tiles should be enough
  key :r_v, Array #random_vowels
  key :r_c, Array #random_consonants
  key :t,    Integer, :default => 0 #turn
  key :a_t, String ##auth_token not stored, only used to return back through json to client
  
  key :n_c_s, Integer, :default => 0 #num_consecutive_skips
  #key :num_words_played, Integer, :default => 0
  key :co_d, Time #completion_date
  key :cr_d, Time #create_date
  key :st, Integer #status
	#1 -> active
	#2 -> cancelled
	#3 -> completed
	#4 -> completed
  key :ch_d, Time #last_chatter_date
  key :lp_d, Time #last_played_date
  
  #attr_accessor :a_t ##auth_token not stored, only used to return back through json to client
#  def self.active_by_player(player_id)
#    where(:st => 1, :player_games => {player_id => player_id, st => 1 )
#  end
#  Person.all(:conditions => {'addresses.city' => 'Chicago'})
  
  def l_t_a #last turn action
	return self.played_turns.last.a
  end

  def l_t_pl #last turn playerId
	return self.played_turns.last.player_id
  end
  
   def l_t_p #last turn points
	return self.played_turns.last.p
  end
  
  def l_t_d #last turn date
	return self.played_turns.last.p_d
  end
  
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

	#only send latest words when possible, do not save this
	def strip_excess_words(content_player_id)
		self.played_words.each  do |value|
			if value.t != self.t - 1 
				value.t_l.clear 
			end
		end	
	end 	
		
	def is_player_part_of_game?(context_player_id)
		ok = false
		self.player_games.each  do |value|
			if value.player_id == context_player_id
				ok = true
				break
			end
		end	
		ok
	end 	

	def update_played_tile_by_board_position(board_position, letter, turn)
		found = false
	
		self.played_tiles.each  do |value|
			if value.p == board_position
				#add latest letter and turn placed on this board position
				value.l << letter
				value.t << turn
				found = true
			end
		end	
		if !found 
			played_tile = PlayedTile.new
			played_tile.p = board_position
			played_tile.l << letter
			played_tile.t << turn
			self.played_tiles << played_tile
		end
	end 	


	#is it this player's turn?
	def isPlayerCurrentTurn?(context_player_id)
		ok = false
		self.player_games.each  do |value|
		 Rails.logger.info("isPlayerCurrentTurn check #{value.player.id} - #{context_player_id} isTurn #{value.i_t}")
			if value.player_id == context_player_id && 
					value.i_t == true		
				ok = true
				break
			end
		end	
		ok
	end
	
	#did this player start the game?
	def isPlayerStarter?(context_player_id)
		ok = false
		self.player_games.each  do |value|
			if value.player_id == context_player_id && value.o == 1
				ok = true
				break
			end
		end	
		ok
	end
  
	def numActivePlayers
		count = 0
		self.player_games.each  do |value|
			if value.st == 1 
				count += 1
			end
		end
		count
	end
  
	def assignStatusToRemainingActivePlayers(status)
		self.player_games.each  do |value|
			if value.st == 1
				value.st = status
			end
		end		
	end
  
  	def assignNextPlayerToTurn(context_player_id)
		order = self.getContextPlayerGame(context_player_id).o
		
		Rails.logger.info("assignNextPlayerToTurn order #{order}")
		
		player_game = nil
		
		if order == 1
			player_game = self.getActivePlayerGameByOrder(2)
			if player_game.nil?
				player_game = self.getActivePlayerGameByOrder(3)
			end
			if player_game.nil?
				player_game = self.getActivePlayerGameByOrder(4)
			end
		end
		
		if order == 2
			player_game = self.getActivePlayerGameByOrder(3)
			if player_game.nil?
				player_game = self.getActivePlayerGameByOrder(4)
			end
			if player_game.nil?
				player_game = self.getActivePlayerGameByOrder(1)
			end
		end

		if order == 3
			player_game = self.getActivePlayerGameByOrder(4)
			if player_game.nil?
				player_game = self.getActivePlayerGameByOrder(1)
			end
			if player_game.nil?
				player_game = self.getActivePlayerGameByOrder(2)
			end
		end

		if order == 4
			player_game = self.getActivePlayerGameByOrder(1)
			if player_game.nil?
				player_game = self.getActivePlayerGameByOrder(2)
			end
			if player_game.nil?
				player_game = self.getActivePlayerGameByOrder(3)
			end
		end
		
		self.player_games.each  do |value|
			value.i_t = false
		end

		player_game.i_t = true #is_turn
		
		Rails.logger.info("assignNextPlayerToTurn playerId#{player_game.player_id}")
		
	end
	
	def getActivePlayerGameByOrder(order)
	    pg = nil
		self.player_games.each  do |value|
			if value.o == order && value.st == 1  
				pg = value
				break
			end
		end	
		pg
	end
	
	def assignWinner 
	#how to account for ties?
		score = self.getHighestScore
		winners = self.player_games.select {|v| v.sc == score && v.st == 1}
		win_status = 1 #WON(4)
		if winners.size > 1
			#if more than one player has the high score its a draw between those players
			win_status = 6 #DRAW(6)
			
			#update player add to NumWins

		end

		self.player_games.each  do |value|
			if value.st == 1 && value.sc == score 
				value.st = win_status
			elsif value.st == 1 || value.st == 7 #active or resigned, do not flip the status of cancels or declines
				value.st = 5 #LOST(5)
				
				#update player add to NumLosses
			end
		end	
	end
	
	def getHighestScore 
		score = 0
		pg = nil
		self.player_games.each  do |value|
			if value.st == 1  
				if value.sc > score
					score = value.sc
				end
			end
		end	
		score
	end
	
	def getBonusScore(context_player_id) 
		bonus = 0
		#only calculate bonus from active players, not resigns or declines
		pg = nil
		self.player_games.each  do |value|
			if value.player_id != context_player_id 
				#loop through all letter in players tray and add values together
				value.t_l.each do |letter|
					bonus = bonus + AlphabetService.get_letter_value(letter)
				end
			end
		end	
		bonus
	end
	
	def getContextPlayerGame(context_player_id)
		pg = nil
		self.player_games.each  do |value|
			if value.player_id == context_player_id 
				pg = value
			end
		end	
		pg
	end
	
	def getNumConsecutiveSkips
		#loop through played turns backwards 
		i = 0
		self.played_turns.reverse_each  do |value|
			if value.a == 10 #skipped 
				i = i + 1
			else
				break
			end
		end	
		i
	end
	
  # Validations.
#  validates_presence_of :first_name, :last_name, :email 

end