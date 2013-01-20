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
  key :ch_d, Time #last_chat_date
  key :lp_d, Time #last_played_date
    timestamps!
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
		win_status = 4 #WON(4)
		if winners.size > 1
			#if more than one player has the high score its a draw between those players
			win_status = 6 #DRAW(6)
		end

		self.player_games.each  do |value|
			if value.st == 1 && value.sc == score 
				value.st = win_status
			elsif value.st == 1 || value.st == 7 #active or resigned, do not flip the status of cancels or declines
				value.st = 5 #LOST(5)
			end
		end	
	end
	
	def update_players_after_completion
		#loop through each player_game and update the player and player opponent combination based on whether the player
		#won or lost or tied, them loop through each opponent for each player
		
		nowDate = Time.now.utc
		
		self.player_games.each  do |value|
			#if opponent or player did not win, don't update the player/opponent win loss stats, just num games
			#WON(4),
			#LOST(5),
			#DRAW(6),
			#RESIGNED(7)
			# Rails.logger.info("update_players_after_completion main loop #{value.player.id} - #{value.st}")
			 
			 #value.player.n_w += 1
			value.player.n_c_g += 1
			value.player.l_rf_d = nowDate
			if value.st == 4
				value.player.n_w += 1
			end					
			if value.st == 5 || value.st == 7
				value.player.n_l += 1
			end
			if value.st == 6
				value.player.n_d += 1
			end	
			
			#this player won
			#update opponent record for each opponent that did not decline
			self.player_games.each  do |inner|
			# Rails.logger.info("update_players_after_completion inner loop #{inner.player.id} - #{inner.st}")
			
				if inner.player_id != value.player_id
					#this inner loop has to take into account some derived logic since there can be more than 2 players
					is_win = false  
					is_loss = false
					is_draw = false  
					#if the outer player won or the outer player drew and the inner player lost or conceded,
					#the outer player is winner against inner player
					if value.st == 4 || (value.st == 6 && (value.st == 5 || value.st == 7))
						is_win = true
					end	
					#this is the scenario that the outer player lost and the inner player won or drew
					#this counts as a lost for outer player
					if (value.st == 5 || value.st == 7) && (inner.st == 4 || inner.st == 6)
						is_loss = true
					end
					#if both player drew, count as a draw
					if value.st == 6 && inner.st == 6
						is_draw = true
					end	
					#if both players lost, determine who had the most points, count as win for highest points, 
					#count as loss for player with fewer points, if they tied, its a draw 
					#since this is a multi-player game
					if (value.st == 5 || value.st == 7) && (inner.st == 5 || inner.st == 7)
						if value.sc > inner.sc
							is_win = true
						elsif value.sc < inner.sc
							is_loss = true
						else
							is_draw = true
						end
					end
					 Rails.logger.info("update_players_after_completion inner loop #{inner.player.id} - isWin=#{is_win} - isLoss=#{is_loss} - isDraw=#{is_draw}")
					value.player.update_opponent(inner.player_id, is_win, is_loss, is_draw)
					
				end
			end
			 
			if !value.player.fb.blank?
			 	value.player.save(:validate => false)
			else
			 	value.player.save 
			end
			#value.player.save
		end	
	
	end
	
	def update_players_last_refresh_date
		#this can be refactored to only save players in combination
		#with other saves
		nowDate = Time.now.utc
		
		self.player_games.each  do |value|
			if value.st == 1
				value.player.l_rf_d = nowDate
				
				if !value.player.fb.blank?
					value.player.save(:validate => false)
				else
					value.player.save 
				end
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
	
	def send_notification_to_active_opponents(current_player_id, msg_notification)
		#get active players (not current player)  
		active_players = self.player_games.select {|v| v.st == 1 && v.player.id != current_player_id }

		active_players.each  do |value|
			#get player's last device used to send to that particular device
			self.send_to_cloud_notifiers(value.player, msg_notification)	
		end	
	end
	
	def send_notification_to_all_opponents(current_player_id, msg_notification)
		#get active players (not current player)  
		players = self.player_games.select {|v| (v.st == 4 ||  v.st == 5 || v.st == 6 || v.st == 7) && v.player.id != current_player_id }

		players.each  do |value|
			#get player's last device used to send to that particular device
			self.send_to_cloud_notifiers(value.player, msg_notification)	
		end	
	end

	def send_to_cloud_notifiers(player, msg_notification)
		device = player.get_last_device
		#only send if player is active and has not turned off notifications
		if player.st == 1 && player.r_g_n #receive_game_notifications
			#is this an android device? (i_a = isAndroid) (this method will eventually route to iOS as well)	
			if !device.nil? && device.is_android
				self.send_gcm_notification(player, device, msg_notification)			
			end
			#iOS, windows phone call will be here
		end
	end
	
	def send_gcm_notification(player, device, msg_notification)
		#is registrationID populated? (!device.r_id.empty?)
		#make sure device has not been unregistered with gcm (!device.i_ur)
		if !device.r_id.empty?  && !device.i_ur			
			notification = GcmNotification.new
			notification.player = player
			notification.r_id = device.r_id
			notification.data = {:id => self.id.to_s(),:msg => msg_notification} 
			#notification.save
			GoogleNotifierService.send_notification(notification)
		end	
	end	
	
	def send_end_game_notification_to_opponents(current_player)
		winner = self.player_games.select {|v| v.st == 4}
		draws = self.player_games.select {|v| v.st == 6}
		
		is_winner = winner.count > 0
		
		non_declined_players = self.player_games.select {|v| v.st == 4 ||  v.st == 5 || v.st == 6 || v.st == 7}

		#WON(4),
		#LOST(5),
		#DRAW(6),
		#RESIGNED(7)
		
		#never send to current_player
		
		if is_winner #as opposed to a draw
			if non_declined_players.count == 2
				if winner[0].player.id == current_player.id
					#current player was the winner in a 2 player game,
					#so send out message like this to other player:
					# "Jimmy won!"
					msg_notification = I18n.t(:notification_x_won) % { :player => current_player.get_name }  
					self.send_notification_to_all_opponents(current_player.id, msg_notification)
				else
					#send out notification like this:
					#"You won the game with Sally!"
					msg_notification = I18n.t(:notification_you_won_1_opponent) % { :player => current_player.get_name }  
					self.send_notification_to_all_opponents(current_player.id, msg_notification)	
				end
			else
				#more than 2 players
				if winner[0].player.id == current_player.id
					#current player was the winner in a 3+ player game, all non-current players are the losers
					#and can get the same message
					msg_notification = I18n.t(:notification_x_won) % { :player => current_player.get_name }  
					self.send_notification_to_all_opponents(current_player.id, msg_notification)
				else
					non_declined_players.each  do |value|
						#tell the losers (except current player) that the winner won
						if value.player_id != winner[0].player.id && value.player_id != current_player.id  
							msg_notification = I18n.t(:notification_x_won) % { :player => current_player.get_name }
							self.send_to_cloud_notifiers(value.player, msg_notification)
						end
					end
					
					#tell winner that she won 
					self.send_to_cloud_notifiers(winner[0], I18n.t(:notification_you_won))		
				end
			end		
		elsif draws.count > 1
			#it was a draw
			if non_declined_players.count == 2 #2 player game
				msg_notification = I18n.t(:notification_draw_1_opponent) % { :player => current_player.get_name }
				self.send_notification_to_all_opponents(current_player.id, msg_notification)
			else
				#more than 2 players
				if draws.count == 2
					msg_notification = I18n.t(:notification_draw_2_players)  
				elsif draws.count == 3
					msg_notification = I18n.t(:notification_draw_3_players) 
				else
					msg_notification = I18n.t(:notification_draw_4_players) 
				end
				self.send_notification_to_all_opponents(current_player.id, msg_notification)
			end
			
		end	
	end
	
	def send_create_game_notification_to_opponents(current_player)
		#should only be sent after the starting player takes his first turn, to ensure game does
		#not get cancelled after this notification goes out
		opponents = self.player_games.select {|v| v.st == 1 && v.player.id != current_player.id}
	
		if opponents.count == 1 
			msg_notification = I18n.t(:notification_created_game_1_opponent) % { :player => current_player.get_name }
			self.send_to_cloud_notifiers(opponents[0].player, msg_notification)
		elsif opponents.count == 2 
			#send first opponent her notification
			msg_notification = I18n.t(:notification_created_game_2_opponents) % { :player1 => current_player.get_name, :player2 => opponents[1].player.get_name }
			self.send_to_cloud_notifiers(opponents[0].player, msg_notification)
			#send second opponent his notification
			msg_notification = I18n.t(:notification_created_game_2_opponents) % { :player1 => current_player.get_name, :player2 => opponents[0].player.get_name }
			self.send_to_cloud_notifiers(opponents[1].player, msg_notification)
		elsif opponents.count == 3	
			#send first opponent her notification
			msg_notification = I18n.t(:notification_created_game_3_opponents) % { :player1 => current_player.get_name, :player2 => opponents[1].player.get_name, :player3 => opponents[2].player.get_name }
			self.send_to_cloud_notifiers(opponents[0].player, msg_notification)
			#send second opponent her notification
			msg_notification = I18n.t(:notification_created_game_3_opponents) % { :player1 => current_player.get_name, :player2 => opponents[0].player.get_name, :player3 => opponents[2].player.get_name }
			self.send_to_cloud_notifiers(opponents[1].player, msg_notification)
			#send third opponent her notification
			msg_notification = I18n.t(:notification_created_game_3_opponents) % { :player1 => current_player.get_name, :player2 => opponents[0].player.get_name, :player3 => opponents[1].player.get_name }
			self.send_to_cloud_notifiers(opponents[2].player, msg_notification)
		end	
	end
  # Validations.
#  validates_presence_of :first_name, :last_name, :email 

end