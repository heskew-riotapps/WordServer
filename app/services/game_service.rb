class GameService 
	def self.create(current_player, params) 
	#from 2 to 4 players will be sent in.
	#validate that the player sending in the request
	#is one of the players and has the first play order
	
	#add dup check
	#create x number of playerGames
	#load hopper
	#verify players
	#create player opponents record
	#sharding with mongo??
	#validate that all player id's are different
		@game = Game.new
		
		nowDate = Time.now.utc
		
		Rails.logger.debug "params[:player_games]: #{params[:player_games].inspect}"
		
		#check for already posted game, duplicate check
		#if Game.where( :d_c => auth_token).count > 0
		#	Rails.logger.info("error: duplicate check failed, game already created")
		#	@game.errors.add(:d_c, I18n.t(:error_game_already_created))
		#	return @game
		#end
		
		@game.t = 1 #turn_num
		#@game.d_c = auth_token
		@game.st = 1
		@game.r_v = AlphabetService.get_random_vowels #random_vowels
		@game.r_c = AlphabetService.get_random_consonants #random_consonants
		@game.r_l = AlphabetService.get_letter_distribution + @game.r_v + @game.r_c 
		@game.r_l.shuffle! #remaining_letters
		@game.r_l.shuffle! #remaining_letters shuffled again?? is this needed
		@game.cr_d = nowDate  #create_date
		@game.lp_d = nowDate
		
			#add a PlayedTurn record
		played_turn = PlayedTurn.new
		played_turn.player_id = current_player.id
		played_turn.t = 0 #turn_num (zero represents the starting of the game)
		played_turn.a = 8 #last turn action - started the game
		played_turn.p = 0 #points
		played_turn.p_d = nowDate #played_date
		@game.played_turns << played_turn
		
		#if this count > 4, log an error and return
		if params[:player_games].count > 4
			Rails.logger.info("error: #{params[:player_games].count} players being requested for a game")
			@game.errors.add(:player_games, I18n.t(:error_too_many_players_requested))
			return @game
		end
		
		#Rails.logger.info("I18n.locale: #{I18n.locale}")
		#Rails.logger.info("#myapp-#{Rails.env}")
		
		#if this count < 2, log an error and return
		if params[:player_games].count < 2
			Rails.logger.info("error: #{params[:player_games].count} player being requested for a game")
			@game.errors.add(:player_games, I18n.t(:error_too_few_players_requested))
			return @game
		end
		#Rails.logger.debug "params playerGames.count: #{params[:player_games].count}"
	
		currentPlayerIsInGame = false
		
		params[:player_games].each  do |value|
			#if index > 3 throw error
			#Rails.logger.debug("value inspect #{value.inspect}")
			
			#if there is no player_id but there is a fb, save player in invited status if 
			#player is not already in system
			if value['player_id'].blank? and !value['fb'].blank?
				player = Player.find_by_fb(value['fb'])
					if player.nil?
						player = Player.new
						player.fb = value['fb']
						player.f_n = value['f_n']
						player.l_n = value['l_n']
						player.st = 2 #invited
						player.password = ""
						player.n_v = 0
						player.n_w = -1
						
						player.save(:validate => false)
					end
			else
				player = Player.find_by_id(value['player_id'])
			end	
			
		  		#Rails.logger.debug "player nickname: #{player.n_n}"
			if player.nil?
				Rails.logger.info("invalid user being requested " + value['player_id'])
				@game.errors.add(:player_games, I18n.t(:error_invalid_player_requested))
				return @game	
		 	else
				#if params[:player_order] = 1
				#validate that user owns this session, starting user should always have first turn
				#let's relax this rule.  not sure there need to be a check here
				#if value['player_order'] = 1
				#	if player.auth_token != params[:auth_token]
				#		@game.errors.add(value['player_id'],  "unauthenticated user is starting the game")
				#		return @game
				#	end	
				#end
				
				
				#make sure that all players are unique and sort order is unique
				#create playerGame object
				pg = PlayerGame.new
				pg.o = value['o'] #order
				#pg.player_id = value['player_id']
				pg.player = player
				pg.t_l = @game.r_l.slice!(0,7) #tray_letters
				
				#make sure that at least one player is the curent user (auth_token)
				if current_player.id == player.id
					currentPlayerIsInGame = true
				end
				
				 
				if pg.o == 1
					#make sure that current player is first in order
					if player.id != current_player.id
						Rails.logger.info("error_context_player_must_start_game " + player.id)
						@game.errors.add(:player_games, I18n.t(:error_context_player_must_start_game))
					end
					pg.i_t = true #is_turn
				#	pg.l_t = 0 #last turn number
				#	pg.l_t_a = 8 #last turn action - started the game
				#	pg.l_t_p = 0 #last turn points 
				#	pg.l_t_d = nowDate
					pg.st = 1 #status - active
				else
					pg.i_t = false #is_turn				
				#	pg.l_t = -1
				#	pg.l_t_a = 0 #no action yet 
				#	pg.l_t_p = 0 #last turn points
					pg.st = 1 #status - active
				end
				#	#"hello, %s.  Where is %s?" % ["John", "Mary"]
				#	pg.last_action_text =  I18n.t(:game_started_by_you) 
				#else
				#	#this might not work for random games where name should not be shown
				#	pg.last_action_text =  I18n.t(:game_started_by_player) % current_player.get_abbreviated_name
				#end
				
				#Rails.logger.debug("pg inspect #{pg.inspect}")
				
				#add playerGame object to the game if it's not already there
				#make sure player_order is unique
				#if pg.o == 1
				@game.player_games << pg
				#end
			end
		end

		#if  currentPlayerIsInGame is false, throw error
		if  !currentPlayerIsInGame
			@game.errors.add(:player_games, I18n.t(:error_authorized_player_not_in_game))
		end
		
		@game.save
		@game.strip_tray_tiles_from_non_context_user current_player.id
		
		
		#Rails.logger.debug("random vowels #{@game.r_v.inspect}")
		#Rails.logger.debug("random rconsonants #{@game.r_c.inspect}")
		Rails.logger.debug("game inspect #{@game.inspect}")
		
		#@game.save
	#	@game.player_games.each_with_index  do |value, index|
	#		#if index > 3 throw error
	#		player = Player.find_by_id(value.player_id)
		  
	#		if player.nil?
	#			@game.errors.add(value.player_id, "invalid user being requested" + value.player_id)
	#			return @game	
	#		else
		  #if params[:player_order] = 1
		  #validate that user owns this session somehow params[:player][:auth_token]
		  #@game.errors.add(:player_id, "unauthenticated user is starting the game")
		  #return @game
			#@game.add playerGame

	#		end
	#	end
	
		return @game
		
	end

  
  def self.cancel(current_player, game) 
	#update game status to cancelled (2)
	#ensure the starting player canceled the game in turn 1, that is the only time cancel is allowed
	#update player game status of the cancelling player to cancelled
	#save game
	
	
	#Rails.logger.info("game cancel start #{game.inspect}")
	@game = game
	
	#Rails.logger.info("game cancel assignment #{@game.inspect}")
	@unauthorized = false
	@ok = false
	
	if !@game.isPlayerStarter?(current_player.id)
		#Rails.logger.info("isPlayerStarter failed")
		@unauthorized = true
	elsif @game.t != 1 
		#Rails.logger.info("t failed")
		@unauthorized = true
	else
		@game.player_games.each  do |value|
		#Rails.logger.info("loop check #{value.player.id} - #{current_player.id}")
			if value.player.id == current_player.id
				#Rails.logger.info("loop check match")
				value.st = 2 #status - cancelled
			end
			#Rails.logger.info("game before status set #{value.inspect}")
		end	
		#Rails.logger.info("game before status set #{@game.inspect}")
		@game.st = 2
		#Rails.logger.info("game after status set #{@game.inspect}")
		@game.save
		#Rails.logger.info("game after save #{@game.inspect}")
	end

	return @game, @unauthorized 
  end

def self.decline(current_player, game) 
	#update game status to cancelled (2)
	#ensure the starting player canceled the game in turn 1, that is the only time cancel is allowed
	#update player game status of the cancelling player to cancelled
	#save game
	
	
	#Rails.logger.info("game cancel start #{game.inspect}")
	@game = game
	numActivePlayers = @game.numActivePlayers
	#Rails.logger.info("game cancel assignment #{@game.inspect}")
	@unauthorized = false
	@ok = false
	nowDate = Time.now.utc
	
	if @game.isPlayerStarter?(current_player.id)
		#Rails.logger.info("isPlayerStarter failed")
		@unauthorized = true
	elsif @game.st != 1 #game is not active
		#Rails.logger.info("t failed")
		@unauthorized = true
	elsif !@game.isPlayerCurrentTurn?(current_player.id) #make sure something weird didn't happen and turns match but players don't		#Rails.logger.info("t failed")
		
		Rails.logger.info("decline isPlayerCurrentTurn failed")
		@game.errors.add(:t, I18n.t(:error_game_play_not_context_players_turn))
		#	return @game
		@unauthorized = true
	elsif @game.t == 1		#probably not needed because of the if not isStarter check 
		@unauthorized = true
	elsif ((numActivePlayers == 2 && @game.t != 2) || #make sure the player declined in his/her first turn
		   (numActivePlayers == 3 && @game.t > 3) ||
		   (numActivePlayers == 4 && @game.t > 4))
		#Rails.logger.info("t failed")
		@unauthorized = true
	else

		@game.player_games.each  do |value|
		#Rails.logger.info("loop check #{value.player.id} - #{current_player.id}")
			if value.player.id == current_player.id
				#Rails.logger.info("loop check match")
				value.st = 3 #status - cancelled
			end
			#Rails.logger.info("game before status set #{value.inspect}")
		end	
		#add a PlayedTurn record
		played_turn = PlayedTurn.new
		played_turn.player_id = current_player.id
		played_turn.t = @game.t #turn_num
		played_turn.a = 13 #DECLINED(13); action
		played_turn.p = 0 #points
		played_turn.p_d = nowDate #played_date
		@game.played_turns << played_turn
		
		if numActivePlayers == 2 
			#game is over and there is no winner 
			@game.st = 4 #declined 
		else
			@game.st = 1  # active --just to be sure 
			
			#increment the official turn counter
			@game.t = @game.t + 1
			@game.assignNextPlayerToTurn(current_player.id)
		
		end 	
		#Rails.logger.info("game after status set #{@game.inspect}")
		@game.save
		#Rails.logger.info("game after save #{@game.inspect}")
	end

	return @game, @unauthorized 
  end
  
  def self.resign(current_player, game) 
	#update game status to cancelled (2)
	#ensure the starting player canceled the game in turn 1, that is the only time cancel is allowed
	#update player game status of the cancelling player to cancelled
	#save game
	
	
	#Rails.logger.info("game cancel start #{game.inspect}")
	@game = game
	numActivePlayers = @game.numActivePlayers
	nowDate = Time.now.utc
	#Rails.logger.info("game cancel assignment #{@game.inspect}")
	@unauthorized = false
	@ok = false
	player_game = @game.player_games.select {|v| v.player.id == current_player.id} #getContextPlayerGame(current_player.id)

	if @game.isPlayerStarter?(current_player.id)
		#Rails.logger.info("isPlayerStarter failed")
		@unauthorized = true
	elsif @game.st != 1 #game is not active
		#Rails.logger.info("t failed")
		@unauthorized = true
	elsif !@game.isPlayerCurrentTurn?(current_player.id) #make sure something weird didn't happen and turns match but players don't		#Rails.logger.info("t failed")
		
		Rails.logger.info("decline isPlayerCurrentTurn failed")
		@game.errors.add(:t, I18n.t(:error_game_play_not_context_players_turn))
		#	return @game
		@unauthorized = true
	elsif @game.t == 1		#probably not needed because of the if not isStarter check 
		@unauthorized = true
	elsif ((numActivePlayers == 2 && @game.t <= 2) || #make sure the player resigns after his/her first turn
		   (numActivePlayers == 3 && @game.t <= 3) ||
		   (numActivePlayers == 4 && @game.t <= 4))
		#Rails.logger.info("t failed")
		@unauthorized = true
	else
		player_game[0].st =  7 #RESIGNED(7),

		#add a PlayedTurn record
		played_turn = PlayedTurn.new
		played_turn.player_id = current_player.id
		played_turn.t = @game.t #turn_num
		played_turn.a = 11 #RESIGNED(11)
		played_turn.p = 0 #points
		played_turn.p_d = nowDate #played_date
		@game.played_turns << played_turn
		@game.t = @game.t + 1
		Rails.logger.info("resigning game - #{@game.id} numActivePlayers=#{numActivePlayers}")
		
		if numActivePlayers == 2 
			#game is over, the last person resigned
			Rails.logger.info("resigning - finishing game now")
			#on the off-chance player resigned even though sh/she had more points 
			#if resigning player had more points than winning player, assign resignee points + 1 to winner
			if @game.getHighestScore == player_game[0].sc
				self.player_games.each  do |value|
					if value.st == 1 && value.player.id != current_player.id 
						value.sc =  player_game[0].sc + 1
					end	
				end	
			end 
			@game.assignWinner
			@game.st = 3 
			@game.co_d = nowDate
		else
			@game.st = 1  # active --just to be sure 
			
			#increment the official turn counter
			@game.t = @game.t + 1
			@game.assignNextPlayerToTurn(current_player.id)
		
		end 	
		#Rails.logger.info("game after status set #{@game.inspect}")
		@game.save
		#Rails.logger.info("game after save #{@game.inspect}")
	end

	return @game, @unauthorized 
  end
  
  def self.play(current_player, game, params) 
	@game = game
	
	#Rails.logger.info("game cancel assignment #{@game.inspect}")
	@unauthorized = false
	@ok = false
	nowDate = Time.now.utc
	
	if !@game.is_player_part_of_game?(current_player.id)
		Rails.logger.info("is_player_part_of_game failed")
		@unauthorized = true
	elsif @game.t != params[:t] #make sure turn is the same as the server's turn
		Rails.logger.info("turn check failed")
		@game.errors.add(:t, I18n.t(:error_game_play_out_of_turn))
		#	return @game
		@unauthorized = true
	elsif !@game.isPlayerCurrentTurn?(current_player.id) #make sure something weird didn't happen and turns match but players don't		#Rails.logger.info("t failed")
		
		Rails.logger.info("isPlayerCurrentTurn failed")
		@game.errors.add(:t, I18n.t(:error_game_play_not_context_players_turn))
		#	return @game
		@unauthorized = true
	else
		#add a new PlayedWord for each incoming word...at some point add a server side word validation check
		params[:played_words].each  do |value|
			played_word = PlayedWord.new
			played_word.w = value['w'] 
			played_word.p = value['p']
			played_word.t = @game.t
			played_word.p_d = nowDate
			played_word.player_id = current_player.id
			@game.played_words << played_word
		end	
		
		player_game = @game.player_games.select {|v| v.player.id == current_player.id} #getContextPlayerGame(current_player.id)
		if player_game[0].st != 1 
			@game.errors.add(:t, I18n.t(:error_game_play_player_not_active_in_game))
			return @game, @unauthorized 
		end
		played_tiles_count = params[:played_tiles].length
		prev_tray_letter_count = player_game[0].t_l.length
		#save played tiles and remove them from players tray letters
		params[:played_tiles].each  do |value|
			@game.update_played_tile_by_board_position(value['p'], value['l'], @game.t)
			
			#remove played letters from players tray
			#magic to delete first letter that matches
			#http://stackoverflow.com/questions/4595305/delete-first-instance-of-matching-element-from-array
			player_game[0].t_l.delete_at(player_game[0].t_l.index(value['l']) || player_game[0].t_l.length)
		end	
		
		#make sure the proper number of letters were removed from the tray letters in the loop above
		if prev_tray_letter_count - played_tiles_count != player_game[0].t_l.length
			@game.errors.add(:t, I18n.t(:error_game_play_tray_tiles_out_of_sync))
			return @game, @unauthorized 
		end
		
		i = 0
		
		#add letters from hopper into players tray to make up for played letters that were removed
		if @game.r_l.count > 0
			while i < played_tiles_count  do
			
			   #pull letter off the front of the hopper	
			   hopper_letter = @game.r_l.shift
			   
			   #if that letter existed (we might be close to the end of the hopper) add it to the players tray
			   if !hopper_letter.nil?
				  player_game[0].t_l.push(hopper_letter)
			   end
			   i +=1
			end
		end
		
		#add a PlayedTurn record
		played_turn = PlayedTurn.new
		played_turn.player_id = current_player.id
		played_turn.t = @game.t #turn_num
		played_turn.a = 9 #WORDS_PLAYED(9), action
		played_turn.p = params[:p] #points
		played_turn.p_d = nowDate #played_date
		@game.played_turns << played_turn
		
		#set last played date...this will be used as the sort for game list on client
		@game.lp_d = nowDate

		#add score to players score
		player_game[0].sc = player_game[0].sc + params[:p]
		Rails.logger.info("new score #{player_game[0].sc}")
		
		#add 1 to players tray version
		player_game[0].t_v = player_game[0].t_v + 1
		 
 
		#refill tray
		
		if @game.r_l.count == 0 && player_game[0].t_l.length == 0 #no letters in hopper and player's tray is empty
			#game is over...determine who has won
	 			
			#send notifications
			#update statuses
			#make sure last alert dates are set properly
			#calculate bonuses for context player
			player_game[0].sc = player_game[0].sc + @game.getBonusScore(current_player.id)
			
			#determine winner
			@game.assignWinner
			@game.st = 3  # completed
			@game.co_d = nowDate
			#player_game[0].cpa_d = nowDate #completion alert date
		else
			#game is still in progress
			#remove the letters that were just played and replace them with letters from the hopper
			#send notifications
			@game.st = 1  # active --just to be sure 
			
			#increment the official turn counter
			@game.t = @game.t + 1
			@game.assignNextPlayerToTurn(current_player.id)
			
		end
		
		#Rails.logger.info("game before status set #{@game.inspect}")
		
		#Rails.logger.info("game after status set #{@game.inspect}")
		@game.save
		
		if @game.st == 3
			#send notifications as needed
		end
		#Rails.logger.info("game after save #{@game.inspect}")
	end
	
	
	
	return @game, @unauthorized 
  end
  
  def self.skip(current_player, game, params) 

	#Rails.logger.info("game cancel start #{game.inspect}")
	@game = game
	
	#Rails.logger.info("game cancel assignment #{@game.inspect}")
	@unauthorized = false
	@ok = false
	nowDate = Time.now.utc
	
	if !@game.is_player_part_of_game?(current_player.id)
		Rails.logger.info("is_player_part_of_game failed")
		@unauthorized = true
	elsif @game.st != 1 #make sure game is active
		Rails.logger.info("turn check failed")
		@game.errors.add(:t, I18n.t(:error_game_play_game_over))
		#	return @game
		@unauthorized = true
	elsif @game.t != params[:t] #make sure turn is the same as the server's turn
		Rails.logger.info("turn check failed")
		@game.errors.add(:t, I18n.t(:error_game_play_out_of_turn))
		#	return @game
		@unauthorized = true
	elsif !@game.isPlayerCurrentTurn?(current_player.id) #make sure something weird didn't happen and turns match but players don't		#Rails.logger.info("t failed")
		
		Rails.logger.info("isPlayerCurrentTurn failed")
		@game.errors.add(:t, I18n.t(:error_game_play_not_context_players_turn))
		#	return @game
		@unauthorized = true
	else
		
		#add a PlayedTurn record
		played_turn = PlayedTurn.new
		played_turn.player_id = current_player.id
		played_turn.t = @game.t #turn_num
		played_turn.a = 10 #TURN_SKIPPED(10),, action
		played_turn.p = 0 #points
		played_turn.p_d = nowDate #played_date
		@game.played_turns << played_turn

			#ONE_LETTER_SWAPPED(1),
			#TWO_LETTERS_SWAPPED(2),
			#THREE_LETTERS_SWAPPED(3),
			#FOUR_LETTERS_SWAPPED(4),
			#FIVE_LETTERS_SWAPPED(5),
			#SIX_LETTERS_SWAPPED(6),
			#SEVEN_LETTERS_SWAPPED(7),
 
		#refill tray
		#to do..has every active player has skipped twice in a row???
		#if so game is over, determine the winner, etc
		@game.lp_d = nowDate
		
		if @game.getNumConsecutiveSkips >= (@game.numActivePlayers * 2)
		Rails.logger.info("consecutive skips =#{@game.getNumConsecutiveSkips}")
		
			#game is over...determine who has won
			#determine winner
			#send notifications
			#update statuses
			#make sure last alert dates are set properly
			#update opponent stats as needed
			@game.assignWinner
			@game.st = 3  # completed
			@game.co_d = nowDate
		else
			#game is still in progress
			#remove the letters that were just played and replace them with letters from the hopper
			#send notifications
			@game.st = 1  # active --just to be sure 
			
			#increment the official turn counter
			@game.t = @game.t + 1
			@game.assignNextPlayerToTurn(current_player.id)
			
		end
		
		#Rails.logger.info("game before status set #{@game.inspect}")
		
		#Rails.logger.info("game after status set #{@game.inspect}")
		@game.save
		
		if @game.st == 3
			#send notifications as needed
		end
		
		#Rails.logger.info("game after save #{@game.inspect}")
	end
	
	return @game, @unauthorized 
end	
	
	
def self.swap(current_player, game, params) 

	#Rails.logger.info("game cancel start #{game.inspect}")
	@game = game
	
	#Rails.logger.info("game cancel assignment #{@game.inspect}")
	@unauthorized = false
	@ok = false
	nowDate = Time.now.utc
	
	if !@game.is_player_part_of_game?(current_player.id)
		Rails.logger.info("is_player_part_of_game failed")
		@unauthorized = true
	elsif @game.st != 1 #make sure game is active
		Rails.logger.info("error_game_play_game_over failed")
		@game.errors.add(:t, I18n.t(:error_game_play_game_over))
		#	return @game
		@unauthorized = true
	elsif @game.t != params[:t] #make sure turn is the same as the server's turn
		Rails.logger.info("turn check failed")
		@game.errors.add(:t, I18n.t(:error_game_play_out_of_turn))
		#	return @game
		@unauthorized = true
	elsif @game.left < 1 #make sure the hopper has letters 
		Rails.logger.info("error_game_play_hopper_is_empty failed")
		@game.errors.add(:t, I18n.t(:error_game_play_hopper_is_empty))
		#	return @game
		@unauthorized = true
	elsif !@game.isPlayerCurrentTurn?(current_player.id) #make sure something weird didn't happen and turns match but players don't		#Rails.logger.info("t failed")
		
		Rails.logger.info("isPlayerCurrentTurn failed")
		@game.errors.add(:t, I18n.t(:error_game_play_not_context_players_turn))

		@unauthorized = true
	elsif params[:s_l].nil? || params[:s_l].blank? || params[:s_l].count == 0 	
		Rails.logger.info("error_game_play_no_swapped_letters failed")
		@game.errors.add(:t, I18n.t(:error_game_play_no_swapped_letters))
		@unauthorized = true
	elsif params[:s_l].count > @game.left  	
		Rails.logger.info("error_game_play_too_few_letters_in_hopper failed")
		@game.errors.add(:t, I18n.t(:error_game_play_too_few_letters_in_hopper))
		@unauthorized = true
	else

		#add a PlayedTurn record
		played_turn = PlayedTurn.new
		played_turn.player_id = current_player.id
		played_turn.t = @game.t #turn_num
		played_turn.a = params[:s_l].length #action
		played_turn.p = 0 #points
		played_turn.p_d = nowDate #played_date
		@game.played_turns << played_turn

		#ONE_LETTER_SWAPPED(1),
		#TWO_LETTERS_SWAPPED(2),
		#THREE_LETTERS_SWAPPED(3),
		#FOUR_LETTERS_SWAPPED(4),
		#FIVE_LETTERS_SWAPPED(5),
		#SIX_LETTERS_SWAPPED(6),
		#SEVEN_LETTERS_SWAPPED(7),
		
		player_game = @game.player_games.select {|v| v.player.id == current_player.id} #getContextPlayerGame(current_player.id)
		if player_game[0].st != 1 
			@game.errors.add(:t, I18n.t(:error_game_play_player_not_active_in_game))
			return @game, @unauthorized 
		end
		swapped_letters_count = params[:s_l].length
		prev_tray_letter_count = player_game[0].t_l.length
		#save played tiles and remove them from players tray letters
		params[:s_l].each  do |value|
			#remove played letters from players tray
			#magic to delete first letter that matches
			#http://stackoverflow.com/questions/4595305/delete-first-instance-of-matching-element-from-array
			player_game[0].t_l.delete_at(player_game[0].t_l.index(value) || player_game[0].t_l.length)
			
			#add this letter back to the hopper
			@game.r_l << value 
		end	
		
		#make sure the proper number of letters were removed from the tray letters in the loop above
		if prev_tray_letter_count - swapped_letters_count != player_game[0].t_l.length
			@game.errors.add(:t, I18n.t(:error_game_play_tray_tiles_out_of_sync))
			return @game, @unauthorized 
		end
		
		
		#shuffle letters again before pulling letters back out
		@game.r_l.shuffle! #remaining_letters
		@game.r_l.shuffle! #remaining_letters shuffled again?? is this needed
		
		i = 0
		
		#add letters from hopper into players tray to make up for played letters that were removed
		while i < swapped_letters_count  do
		
		   #pull letter off the front of the hopper	
		   hopper_letter = @game.r_l.shift
		   
		   #if that letter existed (we might be close to the end of the hopper) add it to the players tray
		   if !hopper_letter.nil?
			  player_game[0].t_l.push(hopper_letter)
		   end
		   i +=1
		end
		
 
		#refill tray
		#to do..has every active player has skipped twice in a row???
		#if so game is over, determine the winner, etc
		
	 
		#game is still in progress
		#remove the letters that were just played and replace them with letters from the hopper
		#send notifications
		@game.lp_d = nowDate
		
		#increment the official turn counter
		@game.t = @game.t + 1
		@game.assignNextPlayerToTurn(current_player.id)

		#Rails.logger.info("game before status set #{@game.inspect}")
		
		#Rails.logger.info("game after status set #{@game.inspect}")
		@game.save
		
		if @game.st == 3
			#send notifications as needed
		end
		#Rails.logger.info("game after save #{@game.inspect}")
	end
	
	return @game, @unauthorized 
  end
  
  def self.chat(current_player, game, params) 

	Rails.logger.info("game cancel chat #{game.inspect}")
	@game = game
	
	#Rails.logger.info("game cancel assignment #{@game.inspect}")
	@unauthorized = false
	@ok = false
	nowDate = Time.now.utc
	
	if !@game.is_player_part_of_game?(current_player.id)
		Rails.logger.info("is_player_part_of_game failed")
		@unauthorized = true
	elsif @game.st == 2
		Rails.logger.info("no chat allowed in cancelled games")
		@game.errors.add(:st, I18n.t(:error_game_play_game_over))
		#	return @game
		@unauthorized = true
	
	elsif @game.st == 3 && ((nowDate - @game.co_d) / 1.hour).round > 8 #make sure game is active or has only been completed for less than 8 hours
		Rails.logger.info("game play is over for this game")
		@game.errors.add(:st, I18n.t(:error_game_play_game_over))
		#	return @game
		@unauthorized = true
	else
		#if game has been over for 8 hours, don't accept chat
		#add a Chat record
		chat = Chat.new
		chat.player_id = current_player.id
		chat.t = params[:t] #chat text
		chat.ch_d = nowDate #played_date
		@game.chats << chat 

		# belongs_to :game
		#  key :t,     String
		#  key :player_id , ObjectId
		# key :ch_d, Time
  
		@game.ch_d = nowDate
		
    	#Rails.logger.info("game before status set #{@game.inspect}")
		
		#Rails.logger.info("game after status set #{@game.inspect}")
		@game.save

		#Rails.logger.info("game after save #{@game.inspect}")
	end
	
	return @game, @unauthorized 
end	
end
