class GameService 
	def self.create(params) 
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
		
		#if this count > 4, log an error and return
		if params[:player_games].count > 4
			Rails.logger.info("error: #{params[:player_games].count} players being requested for a game")
			#@game.errors.add(@, "invalid user being requested" + value['player_id'])
			return @game
		end
		
		#if this count < 2, log an error and return
		if params[:player_games].count < 2
			Rails.logger.info("error: #{params[:player_games].count} player being requested for a game")
			#@game.errors.add(@, "invalid user being requested" + value['player_id'])
			return @game
		end
		Rails.logger.debug "params playerGames.count: #{params[:player_games].count}"
 
 
		params[:player_games].each  do |value|
			#if index > 3 throw error
			#Rails.logger.debug("value inspect #{value.inspect}")
		 	player = Player.find_by_id(value['player_id'])
		#  v['contact_ids']
		  		Rails.logger.debug "player nickname: #{player.nickname}"
			if player.nil?
				Rails.logger.info("invalid user being requested " + value['player_id'])
				@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
				return @game	
		 	else
		  #if params[:player_order] = 1
		  #validate that user owns this session somehow params[:player][:auth_token]
		  #@game.errors.add(:player_id, "unauthenticated user is starting the game")
		  #return @game
			#@game.add playerGame
			
				#create playerGame object
				pg = PlayerGame.new
				pg.player_order = value['player_order']
				pg.player_id = value['player_id']
				
				Rails.logger.debug("pg inspect #{pg.inspect}")
				
				#add playerGame object to the game if it's not already there
				#make sure player_order is unique
				@game.player_games << pg

			end
		end
		@game.turn_num = 1
		#@game.save
		Rails.logger.debug("random vowels #{AlphabetENService.get_random_vowels.inspect}")
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
