class PlayersController < ApplicationController
	 respond_to :json

	def new
		@player = Player.new
		
		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @player }	
		end
	end
  
  # GET /players/1
  # GET /players/1.json
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
		if @player.nil?
			format.html { render action: "edit" } #wrong
			format.json { render json: "not found", status: :not_found }
		else
			format.html # show.html.erb
			format.json { render json: @player }
		end
    end
  end
  
   def find
   logger.debug("pg inspect #{:params.inspect}")
   # @player = Player.find_by_n_n(params[:n_n]) #Player.where(n_n:/^{params[:n_n]}$/i ) #(##Player.find_by_n_n(params[:n_n])  #/^bar$/i regex can use index because it starts with ^
    @player = Player.where({n_n:/^#{params[:n_n]}$/i} ) #(##Player.find_by_n_n(params[:n_n])  #/^bar$/i regex can use index because it starts with ^
#
	# /^#{params[:q]}/ 
    respond_to do |format|
		if @player.nil? || @player.empty?
			format.html { render action: "edit" } #wrong
			format.json { render json: "not found", status: :not_found }
		else
			format.html # index.html.erb
			#format.json { render json: @players }
			#http://apidock.com/rails/ActiveRecord/Serialization/to_json
			format.json  { render :json => @player.first.to_json({
						:methods => :gravatar,
						:only => [:id, :fb, :f_n, :l_n, :n_n, :n_w] } )}
		end		 
    end
  end
  
  def find_all_by_fb
   logger.debug("find_all_by_fb inspect #{:params.inspect}")
   #pass big fat array of fb's into mongo
   @players = Player.all(:conditions => {'st' => 1, 'fb' => params[:fb]})    
    #@players = Player.find_all_by_fb(params[:fb])
	#@players = Player.where(:fb => params[:fb])
	
    respond_to do |format|
		if @players.nil?
			format.html { render action: "edit" } #wrong
			format.json { render json: "not found", status: :not_found }
		else
			format.html # index.html.erb
			#format.json { render json: @players }
			#http://apidock.com/rails/ActiveRecord/Serialization/to_json
			format.json  { render :json => @players.to_json({
						:only => [:id, :fb, :n_w] } )}
		end		 
    end
  end
  
  def index
    @players = Player.all#({:last_name => 'Medical'})

    respond_to do |format|
      format.html # index.html.erb
	  format.json { render json: @players }
    end
  end
  
  def create
  #####Player.delete_all 
	   
		@player, @unauthorized, @error = PlayerService.create params[:player]
		#@player.valid?
		 logger.info ("unauthorized inspect #{@unauthorized.inspect}")
		#logger.debug("player errors inspect #{@player.errors.inspect}")
		#logger.debug("player inspect #{@player.inspect}")
		#logger.debug("error inspect #{@error.inspect}")
		#logger.debug("unauthorized inspect #{@unauthorized.inspect}")
		if !params.has_key?(:c_g_d) || params[:c_g_d].blank?
			@player.completed_games_from_date = params[:c_g_d]
		else
			@player.completed_games_from_date = "10/6/2012"
		end
		
		if @unauthorized 
			render json: @error.to_json(), status: :unauthorized
		elsif @player.errors.empty?
			respond_with @player #rabl
		else
			render json: @player.errors, status: :unprocessable_entity
		end

	end
  
  def auth_via_token_____ #test only
  @error = Error.new
  @error.code = 0
	respond_to do |format|
				 
					format.json { render json: @error.to_json(), status: :ok }
				 
			end
  end
  
	def auth_via_token
		@player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
	
		Rails.logger.info("params #{params}")
		if @player.nil?
			not_found = true
			Rails.logger.info("authorization failed #{params[:a_t]}")		
		else
			if !params.has_key?(:c_g_d) || params[:c_g_d].blank?
				@player.completed_games_from_date = params[:c_g_d]
			else
				@player.completed_games_from_date = "10/6/2012"
			end
			
			@gcm_reg_id = ""
			if params.has_key?(:r_id) && !params[:r_id].blank?
				@gcm_reg_id = params[:r_id] 
				#Rails.logger.info ("email before #{params[:e_m]} after #{@email.inspect}")
			end
			
			@player.n_v = @player.n_v + 1
			
			Rails.logger.info ("generate_token a_t=#{params[:a_t]} reg=#{@gcm_reg_id}")
			#reset user's token, remove current token if token is over a week old
			#send the new token back to the client
			@player.generate_token(params[:a_t], @gcm_reg_id)
			
			if !@player.fb.blank?
			 	@player.save(:validate => false)
			else
			 	@player.save 
			end
			Rails.logger.info("auth_via_token @player.completed_games_from_date =#{@player.completed_games_from_date }")
		end
	
		
		if not_found 
			render json: "unauthorized", status: :unauthorized
		else
			respond_with @player
		end
	end
	
	def auth_via_token_with_game
		@player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
	
		Rails.logger.info("params #{params}")
		if @player.nil?
			not_found = true
			Rails.logger.info("authorization failed #{params[:a_t]}")		
		else
			if !params.has_key?(:c_g_d) || params[:c_g_d].blank?
				@player.completed_games_from_date = params[:c_g_d]
			else
				@player.completed_games_from_date = "10/6/2012"
			end
			
			@gcm_reg_id = ""
			if params.has_key?(:r_id) && !params[:r_id].blank?
				@gcm_reg_id = params[:r_id] 
				#Rails.logger.info ("email before #{params[:e_m]} after #{@email.inspect}")
			end
			#reset user's token, remove current token
			#send the new token back to the client
			@player.n_v = @player.n_v + 1
			
			@player.generate_token(params[:a_t], @gcm_reg_id)
			
			if !@player.fb.blank?
			 	@player.save(:validate => false)
			else
			 	@player.save 
			end
			
			#this method will return a single game along with the game lists
			@game = Game.find(params[:id])
			 
			if @game.nil?
				#Rails.logger.info("cannot find game")	
				#not_found = true		
			 
			else
				#make sure requesting user is part of the game
				if !@game.is_player_part_of_game? @player.id 
					unauthorized = true		
				else
					@game.strip_tray_tiles_from_non_context_user @player.id
					@game.a_t = params[:a_t]
					 
				end	
			end
			@player.game_ = @game
		end
	
		
		if not_found 
			render json: "unauthorized", status: :unauthorized
		else
			respond_with @player
		end
	end
	
	def get_via_token
		@player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
	
		Rails.logger.info("params #{params}")
		if @player.nil?
			not_found = true
			Rails.logger.info("authorization failed #{params[:a_t]}")		
		else
			@player.a_t = params[:a_t]
			if !params.has_key?(:c_g_d) || params[:c_g_d].blank?
				@player.completed_games_from_date = params[:c_g_d]
			else
				@player.completed_games_from_date = "10/6/2012"
			end
			#if registration id is passed in, check to see if it has changed, if so update it
			#this can happen because the client side does not send registration id right away
			#it might happen the next call to get the player's games
			if params.has_key?(:r_id) && !params[:r_id].blank?
				@gcm_reg_id = params[:r_id] 
				#Rails.logger.info ("email before #{params[:e_m]} after #{@email.inspect}")
				if @player.update_gcm_registration_id?(params[:a_t], params[:r_id])
					#player will be updated, boolean return not really needed for this method
				end
			end
			
			#update last device used
			@player.update_last_device_id(params[:a_t])
			
			if !@player.fb.blank?
				@player.save(:validate => false)
			else
				@player.save 
			end
			
			Rails.logger.info("get_via_token @player.completed_games_from_date =#{@player.completed_games_from_date }")
		end
	
		
		if not_found 
			render json: "unauthorized", status: :unauthorized
		else
			respond_with @player
		end
	end
	
	def game_list_check
		@player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
	
		datePassed = false
		Rails.logger.info("params #{params}")
		if @player.nil?
			not_found = true
			Rails.logger.info("authorization failed #{params[:a_t]}")		
		else
			@player.a_t = params[:a_t]
			if !params.has_key?(:c_g_d) || params[:c_g_d].blank?
				@player.completed_games_from_date = params[:c_g_d]
			else
				@player.completed_games_from_date = "10/6/2012"
			end
			if @player.l_rf_d.nil?
				datePassed = true
			elsif  params.has_key?(:l_rf_d) && !params[:l_rf_d].blank? && !params[:l_rf_d].nil?
				
				if @player.l_rf_d > Date.parse(params[:l_rf_d])
					datePassed = true
				end
			
			end
		
		end
	
		
		
		if not_found 
			render json: "unauthorized", status: :unauthorized
		elsif !datePassed
			render json: "not_found", status: :not_found 
		else
			respond_with @player
		end
	end
	
	def log_out
		player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
	
		unauthorized = false
		if player.nil?
			#unauthorized = true  ignore if player is not found...do nothing
			#this normally means the token became out of sync on the client
		else
			player.remove_token(params[:a_t])
			if !player.fb.blank?
				player.save(:validate => false)
			else
				player.save 
			end
		end
	
		respond_to do |format|
				if unauthorized #account for FB
					format.json { render json: "unauthorized", status: :unauthorized }
				else 
					#format.html { redirect_to player, notice: 'Post was successfully created.' }
					format.json  { render json: "ok",status: :ok}

				end
			end
	end
	
	def change_password 
		player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
		@error = Error.new
		
		if player.nil?
			@error.code = "6"
			unauthorized = true
		else
			player.password = params[:p_w]
			player.generate_token_only(params[:a_t])
			player.save
		end
	
		respond_to do |format|
				if unauthorized #account for FB
					format.json { render json: @error.to_json(), status: :unauthorized }
				else 
					if player.errors.empty?
						#format.html { redirect_to @player, notice: 'Post was successfully created.' }
						format.json  { render :json => player.to_json( 
							:only => [:id, :fb, :f_n, :l_n, :n_n, :n_w, :e_m],
							:methods => [:gravatar, :a_t]),status: :ok}
					else
						#format.html { render action: "new" }
						format.json { render json: player.errors, status: :unprocessable_entity }
					end
				end
			end
	end
	
	def clear_tokens___
		player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_id(params[:id]) #auth_token    #@player.valid?
	

		if player.nil?
			not_found = true
			Rails.logger.info("authorization failed #{params[:a_t]}")		
		else
			player.a_t_.clear 
			
			if !player.fb.blank?
				player.save(:validate => false)
			else
				player.save 
			end
			
		end
	
		respond_to do |format|
				if not_found #account for FB
					format.json { render json: "not_found", status: :not_found }
				else 
					if player.errors.empty?
						format.json { render json: "ok", status: :ok }
					else
						#format.html { render action: "new" }
						format.json { render json: player.errors, status: :unprocessable_entity }
					end
				end
			end
	end
	
	def get_games 
		player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
		@error = Error.new
		
		if player.nil?
			@error.code = "6"
			unauthorized = true
		else
			player.password = params[:p_w]
			#player.generate_token(params[:a_t])
			#if !player.fb.blank?
			#	player.save(:validate => false)
			#else
			#	player.save 
			#end
			player.a_t = params[:a_t]
			player.completed_games_from_date = params[:c_g_d]
		end
	
		respond_to do |format|
				if unauthorized #account for FB
					format.json { render json: @error.to_json(), status: :unauthorized }
				else 
					if player.errors.empty?
						#format.html { redirect_to @player, notice: 'Post was successfully created.' }
						format.json  { render :json => player.to_json( 
							:only => [:id, :fb, :f_n, :l_n, :n_n, :n_w, :e_m],
							:methods => [:gravatar, :a_t, :a_games, :c_games]),status: :ok}
					else
						#format.html { render action: "new" }
						format.json { render json: player.errors, status: :unprocessable_entity }
					end
				end
			end
	end
	
	
    def update_account  
	  
 		@player, @unauthorized, @error = PlayerService.update_account params 
	
		if @unauthorized 
			render json: @error.to_json(), status: :unauthorized
		elsif @player.errors.empty?
			respond_with @player #rabl
		else
			render json: @player.errors, status: :unprocessable_entity
		end
		#logger.debug("player errors inspect #{@player.errors.inspect}")
		#logger.debug("player inspect #{@player.inspect}")
		#logger.debug("error inspect #{@error.inspect}")
		#logger.debug("unauthorized inspect #{@unauthorized.inspect}")
		#respond_to do |format|
		#	if @unauthorized #account for FB
		#		format.json { render json: @error.to_json(), status: :unauthorized }
		#	else 
		#		if @player.errors.empty?
		#			#format.html { redirect_to @player, notice: 'Post was successfully created.' }
		#			format.json  { render :json => @player.to_json( :methods => [:gravatar, :a_t], :only => [:id, :fb, :f_n, :l_n, :n_n, :e_m]),status: :created}
		#			
		#		else
		#			#format.html { render action: "new" }
		#			#json error handling
		#			format.json { render json: @player.errors, status: :unprocessable_entity }
		#		end
		#	end
		#end
  end
	
	 def update_fb_account  
	  
 		@player, @unauthorized, @error = PlayerService.update_fb_account params 

		if @unauthorized 
			render json: @error.to_json(), status: :unauthorized
		elsif @player.errors.empty?
			respond_with @player #rabl
		else
			render json: @player.errors, status: :unprocessable_entity
		end
  end
	
	
	def update____
		@player = Player.find(params[:id])

		respond_to do |format|
			if @player.update_attributes(params[:player])
				format.html { redirect_to @player, notice: 'Person was successfully updated.' }
				format.json { render json: @player, status: :created, location: @player }
			else
				format.html { render action: "edit" }
				format.json { render json: @player.errors, status: :unprocessable_entity }
			end
		end
	end
	
	def gcm_register
		player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
		@error = Error.new
		
		#params[:r_id] -- registration id
		
		#to support multiple devices for one user
		#update registrationId associated with the auth_token
		#if another registrationID is associated
		
		if player.nil?
			@error.code = "6"
			unauthorized = true
		else
			player.update_or_add_gcm_registration_id(params[:a_t], params[:r_id])
			#player.generate_token(params[:a_t])
			if !player.fb.blank?
				player.save(:validate => false)
			else
				player.save 
			end
		end
	
		respond_to do |format|
			if unauthorized #account for FB
				format.json { render json: @error.to_json(), status: :unauthorized }
			else 
				if player.errors.empty?
					format.json  { render json: "ok",status: :ok}
				else
					#format.html { render action: "new" }
					format.json { render json: player.errors, status: :unprocessable_entity }
				end
			end
		end
	
	end
	
	def gcm_unregister
		player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
		@error = Error.new
		
		#params[:r_id] -- registration id
		
		#to support multiple devices for one user
		#update registrationId associated with the auth_token
		#if another registrationID is associated
		
		if player.nil?
			@error.code = "6"
			unauthorized = true
		else
			player.update_or_add_gcm_registration_id(params[:a_t], "")
			#player.generate_token(params[:a_t])
			if !player.fb.blank?
				player.save(:validate => false)
			else
				player.save 
			end
		end
	
		respond_to do |format|
			if unauthorized #account for FB
				format.json { render json: @error.to_json(), status: :unauthorized }
			else 
				if player.errors.empty?
					format.json  { render json: "ok",status: :ok}
				else
					#format.html { render action: "new" }
					format.json { render json: player.errors, status: :unprocessable_entity }
				end
			end
		end
	
	end
	def destroy
		@player = Player.find(params[:id])
		@player.delete
		
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
			format.html { redirect_to @player, notice: 'Post was successfully created.' }
			format.json { render json: @player, status: :created, location: @player }
		  else
			format.html { render action: "new" }
			#json error handling
			format.json { render json: @player.errors, status: :unprocessable_entity }
		  end
		end
	end
	
	def destroy_all
		Player.delete_all #this is temp
	end
	
end
