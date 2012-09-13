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
		
		Rails.logger.debug "params[:player_games]: #{params[:player_games].inspect}"
		
		@game.t = 1 #turn_num
		@game.r_v = AlphabetService.get_random_vowels #random_vowels
		@game.r_c = AlphabetService.get_random_consonants #random_consonants
		@game.r_l = AlphabetService.get_letter_distribution + @game.random_vowels + @game.random_consonants 
		@game.r_l.shuffle! #remaining_letters
		@game.cr_d = Time.now.utc  #create_date
		
		#if this count > 4, log an error and return
		if params[:player_games].count > 4
			Rails.logger.info("error: #{params[:player_games].count} players being requested for a game")
			#@game.errors.add(@, "invalid user being requested" + value['player_id'])
			return @game
		end
		
		Rails.logger.info("I18n.locale: #{I18n.locale}")
		Rails.logger.info("#myapp-#{Rails.env}")
		
		#if this count < 2, log an error and return
		if params[:player_games].count < 2
			Rails.logger.info("error: #{params[:player_games].count} player being requested for a game")
			#@game.errors.add(@, "invalid user being requested" + value['player_id'])
			return @game
		end
		Rails.logger.debug "params playerGames.count: #{params[:player_games].count}"
	
		currentPlayerIsInGame = false
		
		params[:player_games].each  do |value|
			#if index > 3 throw error
			#Rails.logger.debug("value inspect #{value.inspect}")
		 	player = Player.find_by_id(value['player_id'])
		#  v['contact_ids']
		  		Rails.logger.debug "player nickname: #{player.n_name}"
			if player.nil?
				Rails.logger.info("invalid user being requested " + value['player_id'])
				@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
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
				pg.player_order = value['player_order']
				pg.player_id = value['player_id']
				pg.tray_letters = @game.remaining_letters.slice!(0,7)
				
				#make sure that at least one player is the curent user (auth_token)
				if current_player.id == player.id
					currentPlayerIsInGame = true
					#"hello, %s.  Where is %s?" % ["John", "Mary"]
					pg.last_action_text =  I18n.t(:game_started_by_you) 
				else
					#this might not work for random games where name should not be shown
					pg.last_action_text =  I18n.t(:game_started_by_player) % current_player.get_abbreviated_name
				end
				
				Rails.logger.debug("pg inspect #{pg.inspect}")
				
				#add playerGame object to the game if it's not already there
				#make sure player_order is unique
				@game.player_games << pg

			end
		end

		#if  currentPlayerIsInGame is false, throw error
		if  !currentPlayerIsInGame
			@game.errors.add(value['player_id'], I18n.t(:error_authorized_user_not_in_game))
		end
		#@game.save
		Rails.logger.debug("random vowels #{@game.random_vowels.inspect}")
		Rails.logger.debug("random rconsonants #{@game.random_consonants.inspect}")
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

  
end
