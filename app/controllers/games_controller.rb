require 'mongo'

class GamesController < ApplicationController
	respond_to :json
	
	def clear_all
		Game.delete_all
	end
	
	def new_____
		Game.delete_all
		game = Game.new
		game.test = "test"
#		game.letters = [Letter.new(:value => 'S'),Letter.new(:value => 'O')] 
		game.letters << Letter.new(:value => 'l') 
		game.letters << Letter.new(:value => 'K')
		game.letters << Letter.new(:value => ')') 		
		game.save
#		game = Game.create({
#		  :test => 'Sam'
#		  })

		
		
		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @post }
			 #format.json  { render :json => @things.to_json(:include => { :photos => { :only => [:id, :url] } }) }
		end
	end

  def index
     @games = Game.all 
	#@games = Game.find(:conditions => {'st' => 1, 'player_game.player_id' => params[:id]}, :sort => {'lp_d' => -1})

    respond_to do |format|
      format.html #index.html.erb
	  format.json { render json: @games }
    end
  end
  
  def show____
    #@games = Game.all
	@games = Game.all(:conditions => {'st' => 1, 'player_games.player_id' => BSON::ObjectId.from_string(params[:id])}, :sort => {'lp_d' => -1})
	
	#@games = Game.all(:conditions => {'st' => 1, :player_games => {:player => {:id => BSON::ObjectId.from_string(params[:id])}}})
#User.where('alerts.name' => params[:name], :id => current_user.id).first
    respond_to do |format|
      format.html # index.html.erb
	  format.json { render json: @games }
    end
  end
  #Game.all(:conditions => {'st' => 1, 'player_game.player_id' => self.id}, :sort => {'lp_d' => -1})
  
   def get
		player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
		logger.debug("game before create #{params.inspect}")
	   

		if player.nil?
			Rails.logger.info("unauthorized request to get game")	
		#	@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
			unauthorized = true		
		else
			 @game = Game.find(params[:id])
			 
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			 
			else
				#make sure requesting user is part of the game
				if !@game.is_player_part_of_game? player.id 
					unauthorized = true		
				else
					@game.strip_tray_tiles_from_non_context_user player.id

					#reset user's token
					#player.generate_token(:a_t)
					#send the new token back to the client
					
					@game.a_t = params[:a_t]
					#@game.a_t = player.generate_token(params[:a_t])
					logger.debug("game after create #{@game.inspect}")
					 
					#if !player.fb.blank?
					#	player.save(:validate => false)
					#else
					#	player.save 
					#end
				end	
			end
		end
		logger.debug("game  #{@game.inspect}")
		if unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			respond_with @game
		else
			render json: @player.errors, status: :unprocessable_entity
		end
  end
  def get_
		player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
		logger.debug("game before create #{params.inspect}")
	   

		if player.nil?
			Rails.logger.info("unauthorized request to get game")	
		#	@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
			unauthorized = true		
		else
			 @game = Game.find(params[:id])
			 
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			 
			else
				#make sure requesting user is part of the game
				if !@game.is_player_part_of_game? player.id 
					unauthorized = true		
				else
					@game.strip_tray_tiles_from_non_context_user player.id

					#reset user's token
					#player.generate_token(:a_t)
					#send the new token back to the client
					
					@game.a_t = params[:a_t]
					#@game.a_t = player.generate_token(params[:a_t])
					logger.debug("game after create #{@game.inspect}")
					data_ = @game.serialize_game 
					#if !player.fb.blank?
					#	player.save(:validate => false)
					#else
					#	player.save 
					#end
				end	
			end
		end
		logger.debug("game  #{@game.inspect}")
		if unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			render json: data_, status: :ok 
		else
			render json: @player.errors, status: :unprocessable_entity
		end
  end
  def refresh
		player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
		logger.debug("game before refresh #{params.inspect}")
	   
		no_changes = true
		if player.nil?
			Rails.logger.info("refresh unauthorized request to get game")	
		#	@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
			unauthorized = true		
		else
			 @game = Game.find(params[:id])
			 
			if @game.nil?
				Rails.logger.info(" refresh cannot find game")	
				not_found = true		
			 
			else
				#make sure requesting user is part of the game
				if !@game.is_player_part_of_game? player.id 
					unauthorized = true		
				else
					#only send update if turn from client is less that turn from server
					#or if game is over
					if (@game.t > params[:t] || @game.st == 3)
						no_changes = false

						@game.strip_tray_tiles_from_non_context_user player.id

						#reset user's token
						#player.generate_token(:a_t)
						#send the new token back to the client
						
						@game.a_t = params[:a_t]
						#@game.a_t = player.generate_token(params[:a_t])
						logger.debug("game after create #{@game.inspect}")
						 
						#if !player.fb.blank?
						#	player.save(:validate => false)
						#else
						#	player.save 
						#end
					end
				end	
			end
		end
		logger.debug("game  #{@game.inspect}")
		if unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif no_changes
			render json: "no_change", status: :accepted
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			respond_with @game
		else
			render json: @player.errors, status: :unprocessable_entity
		end
  end
  def refresh_
		player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
		logger.debug("game before refresh #{params.inspect}")
	   
		no_changes = true
		if player.nil?
			Rails.logger.info("refresh unauthorized request to get game")	
		#	@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
			unauthorized = true		
		else
			 @game = Game.find(params[:id])
			 
			if @game.nil?
				Rails.logger.info(" refresh cannot find game")	
				not_found = true		
			 
			else
				#make sure requesting user is part of the game
				if !@game.is_player_part_of_game? player.id 
					unauthorized = true		
				else
					#only send update if turn from client is less that turn from server
					#or if game is over
					if (@game.t > params[:t] || @game.st == 3)
						no_changes = false

						@game.strip_tray_tiles_from_non_context_user player.id

						#reset user's token
						#player.generate_token(:a_t)
						#send the new token back to the client
						
						@game.a_t = params[:a_t]
						#@game.a_t = player.generate_token(params[:a_t])
						#logger.debug("game after create #{@game.inspect}")
						data_ = @game.serialize_game
						#if !player.fb.blank?
						#	player.save(:validate => false)
						#else
						#	player.save 
						#end
					end
				end	
			end
		end
		logger.debug("game  #{@game.inspect}")
		if unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif no_changes
			render json: "no_change", status: :accepted
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			render json: data_, status: :ok
		else
			render json: @player.errors, status: :unprocessable_entity
		end
  end
  def create
	#authenticate requesting player
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	logger.debug("game before create #{params.inspect}")
	@game = Game.new
	
	if player.nil?
		Rails.logger.info("unauthorized request to start game")	
	#	@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
		unauthorized = true		
	else
		@game = GameService.create(player, params[:game])
	
		#if @game.errors.empty?
			#reset user's token
			#player.generate_token(:a_t)
			#send the new token back to the client
			
		#	@game.a_t = player.generate_token(params[:a_t])
		#	logger.debug("game after create #{@game.inspect}")
		#	#player.save  temp, add this back
		#	if !player.fb.blank?
		#			player.save(:validate => false)
		#	else
		#		player.save 
		#	end
		#end	
		############@game.a_t = player.a_t #auth_token
	end
	
	if unauthorized 
		render json: "unauthorized", status: :unauthorized
	elsif @game.errors.empty?
		respond_with @game
	else
		render json: @player.errors, status: :unprocessable_entity
	end
  
  end
   def create_
	#authenticate requesting player
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	logger.debug("game before create #{params.inspect}")
	@game = Game.new
	
	if player.nil?
		Rails.logger.info("unauthorized request to start game")	
	#	@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
		unauthorized = true		
	else
		@game = GameService.create(player, params[:game])
		data_ = @game.serialize_game
		#if @game.errors.empty?
			#reset user's token
			#player.generate_token(:a_t)
			#send the new token back to the client
			
		#	@game.a_t = player.generate_token(params[:a_t])
		#	logger.debug("game after create #{@game.inspect}")
		#	#player.save  temp, add this back
		#	if !player.fb.blank?
		#			player.save(:validate => false)
		#	else
		#		player.save 
		#	end
		#end	
		############@game.a_t = player.a_t #auth_token
	end
	
	if unauthorized 
		render json: "unauthorized", status: :unauthorized
	elsif @game.errors.empty?
		render json: data_, status: :ok 
	else
		render json: @player.errors, status: :unprocessable_entity
	end
  
  end
   def cancel
		@player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
		#logger.debug("game before cancel #{params.inspect}")
	   

		if @player.nil?
			Rails.logger.info("unauthorized request to cancel game")	
		#	@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
			unauthorized = true		
		else
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			 
			else
				@game, @unauthorized = GameService.cancel(@player, @game)
				@player.a_t = params[:a_t]
				if !params.has_key?(:c_g_d) || params[:c_g_d].blank?
					@player.completed_games_from_date = params[:c_g_d]
				else
					@player.completed_games_from_date = "10/6/2012"
				end
				#Rails.logger.info("game post  #{@game.inspect}")
				if @game.errors.empty?
					#reset user's token
					#player.generate_token(:a_t)
					#send the new token back to the client
			
					#player.save  temp, add this back
					#if !@player.fb.blank?
					#	@player.save(:validate => false)
					#else
					#	@player.save 
					#end
				end	
			end	
		end
		
		 #logger.debug("game errors  #{@game.inspect}")
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			respond_with @player
		else
			render json: "error", status: :unprocessable_entity
		end
  end
  
   def decline
		@player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
		#logger.debug("game before cancel #{params.inspect}")
	   

		if @player.nil?
			Rails.logger.info("unauthorized request to cancel game")	
		#	@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
			unauthorized = true		
		else
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			 
			else
				@game, @unauthorized = GameService.decline(@player, @game)
				@player.a_t = params[:a_t]
				#Rails.logger.info("game post  #{@game.inspect}")
			end	
		end
		
		 #logger.debug("game errors  #{@game.inspect}")
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			respond_with @player
		else
			render json: "error", status: :unprocessable_entity
		end
  end
  
  def resign
		@player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
		#logger.debug("game before cancel #{params.inspect}")
	   

		if @player.nil?
			Rails.logger.info("unauthorized request to cancel game")	
		#	@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
			unauthorized = true		
		else
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			 
			else
				@game, @unauthorized = GameService.resign(@player, @game)
				@player.a_t = params[:a_t]
				#Rails.logger.info("game post  #{@game.inspect}")
			end	
		end
		
		 #logger.debug("game errors  #{@game.inspect}")
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			respond_with @player
		else
			render json: "error", status: :unprocessable_entity
		end
  end
  
  def get_active_games____
#authenticate requesting player
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	
	if player.nil?
		unauthorized = true		
	else
		games = Game.all(:conditions => {'st' => 1, 'player_game.player_id' => player.id}) # Game.active_by_player(player.id)
	
		#reset user's token
		#player.generate_token(:a_t)
		#send the new token back to the client
		#@game.a_t = player.generate_token(params[:a_t_])
		#player.save  temp, add this back
		#if !player.fb.blank?
		#		player.save(:validate => false)
		#else
		#	player.save 
		#end
		
		#loop through each game removing excess data
		games.each  do |value|
			value.strip_tray_tiles_from_non_context_user player.id
		
		end
		#@game.a_t = player.a_t #auth_token
	end
	
	
	respond_to do |format|
			if unauthorized #account for FB
				format.json { render json: "unauthorized", status: :unauthorized }
			else 
			 

				format.json  { render :json => games.to_json( 
												:only => [:id, :t, :lp_d, :id], 
												:include => { :player_games => {
												  :only => [:o, :i_t, :sc, :id, :t_l, :l_t, :lt_d],  
												 :include => {:player => 
																{:only => [:fb, :f_n, :l_n, :n_n, :id, :n_w] } }
												} } ),status: :ok }
				 
				 
			end
	end
  
  end
  
  
  def play
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	
	if player.nil?
		unauthorized = true		
	else
		if
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			else
				@game, @unauthorized = GameService.play(player, @game, params)
				@game.strip_tray_tiles_from_non_context_user player.id
			end	
		end
		if !@game.errors.empty?
			logger.info("game play  #{@game.inspect}")
			logger.info("game errors  #{@game.errors}")
		end		
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			respond_with @game  ###return differently if game is this turn completed the game??
		else
			render json: "error", status: :unprocessable_entity
		end
	end
  end
  
  def play_
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	
	if player.nil?
		unauthorized = true		
	else
		if
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			else
				@game, @unauthorized = GameService.play(player, @game, params)
				@game.strip_tray_tiles_from_non_context_user player.id
				data_ = @game.serialize_game
			end	

		end
		if !@game.errors.empty?
			logger.info("game play  #{@game.inspect}")
			logger.info("game errors  #{@game.errors}")
		end		
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			render json: data_, status: :ok  ###return differently if game is this turn completed the game??
		else
			render json: "error", status: :unprocessable_entity
		end
	end
  end
  def skip
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	
	if player.nil?
		unauthorized = true		
	else
		if
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			else
				@game, @unauthorized = GameService.skip(player, @game, params)
				@game.strip_tray_tiles_from_non_context_user player.id
			end	
		end
		
		logger.debug("game skip  #{@game.inspect}")
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			respond_with @game  ###return differently if game is this turn completed the game??
		else
			render json: "error", status: :unprocessable_entity
		end
	end
  end
  def skip_
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	
	if player.nil?
		unauthorized = true		
	else
		if
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			else
				@game, @unauthorized = GameService.skip(player, @game, params)
				@game.strip_tray_tiles_from_non_context_user player.id
				data_ = @game.serialize_game
			end	
			
		end
		
		logger.debug("game skip  #{@game.inspect}")
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			render json: data_, status: :ok  ###return differently if game is this turn completed the game??
		else
			render json: "error", status: :unprocessable_entity
		end
	end
  end
  def swap
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	
	if player.nil?
		unauthorized = true		
	else
		if
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			else
				@game, @unauthorized = GameService.swap(player, @game, params)
				@game.strip_tray_tiles_from_non_context_user player.id
				
			end	
		end
		
		logger.debug("game swap  #{@game.inspect}")
 
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			respond_with @game  ###return differently if game is this turn completed the game??
		else
			render json: "error", status: :unprocessable_entity
		end
	end
  end
  def swap_
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	
	if player.nil?
		unauthorized = true		
	else
		if
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			else
				@game, @unauthorized = GameService.swap(player, @game, params)
				@game.strip_tray_tiles_from_non_context_user player.id
				data_ = @game.serialize_game
			end	
		end
		
		logger.debug("game swap  #{@game.inspect}")
 
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			render json: data_, status: :ok   ###return differently if game is this turn completed the game??
		else
			render json: "error", status: :unprocessable_entity
		end
	end
  end
  def chat
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	
	if player.nil?
		Rails.logger.info("chat - played not found  #{params.inspect}")	
		unauthorized = true		
	else
		if
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			else
				@game, @unauthorized = GameService.chat(player, @game, params)
				@game.strip_tray_tiles_from_non_context_user player.id
			end	
		end
		
		logger.debug("game info  #{@game.inspect}")
 
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			respond_with @game  ###return differently if game is this turn completed the game??
		else
			render json: "error", status: :unprocessable_entity
		end
	end
  end
   def chat_
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	
	if player.nil?
		Rails.logger.info("chat - played not found  #{params.inspect}")	
		unauthorized = true		
	else
		if
			@game = Game.find(params[:id])
			 #Rails.logger.info("game pre  #{@game.inspect}")	
			if @game.nil?
				Rails.logger.info("cannot find game")	
				not_found = true		
			else
				@game, @unauthorized = GameService.chat(player, @game, params)
				@game.strip_tray_tiles_from_non_context_user player.id
				data_ = @game.serialize_game
			end	
		end
		
		logger.debug("game info  #{@game.inspect}")
 
		if @unauthorized 
			render json: "unauthorized", status: :unauthorized
		elsif not_found 
			render json: "not_found", status: :not_found 
		elsif @game.errors.empty?
			render json: data_, status: :ok  ###return differently if game is this turn completed the game??
		else
			render json: "error", status: :unprocessable_entity
		end
	end
  end
  
  def destroy
		@game = Game.find(params[:id])
		@ok = @game.delete
		
		#@existing = Player.find_by_id(params[:player][:id])
		#if @existing.nil?
		#
		#	@player = Player.create({
		#	  :nickname => params[:player][:nickname],
		#	  :email => params[:player][:email]
		#	})
		#
		#	@ok = @player.delete
		#end

		respond_to do |format|
		  if @ok
			format.html { redirect_to @game, notice: 'Post was successfully created.' }
			format.json { render json: "ok", status: :ok}
		  else
			format.html { render action: "new" }
			#json error handling
			format.json { render json: @game.errors, status: :unprocessable_entity }
		  end
		end
	end
	def destroy_all
		Game.delete_all #this is temp
	end
end
