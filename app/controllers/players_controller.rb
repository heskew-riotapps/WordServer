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
   logger.debug("pg inspect #{:params.inspect}")
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
		@player = Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
	
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
			#reset user's token, remove current token
			#send the new token back to the client
			@player.n_v = @player.n_v + 1
			
			@player.generate_token(params[:a_t])
			
			if !@player.fb.blank?
			 	@player.save(:validate => false)
			else
			 	@player.save 
			end
			
		end
	
		
		if not_found 
			render json: "unauthorized", status: :unauthorized
		else
			respond_with @player
		end
	end
	
	def get_via_token
		@player = Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
	
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
			
		end
	
		
		if not_found 
			render json: "unauthorized", status: :unauthorized
		else
			respond_with @player
		end
	end
	
	def log_out
		player = Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
	
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
		player = Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
		@error = Error.new
		
		if player.nil?
			@error.code = "6"
			unauthorized = true
		else
			player.password = params[:p_w]
			player.generate_token(params[:a_t])
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
	
	def clear_tokens
		player = Player.find_by_id(params[:id]) #auth_token    #@player.valid?
	

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
		player = Player.find_by_a_t_(params[:a_t]) #auth_token    #@player.valid?
		@error = Error.new
		
		if player.nil?
			@error.code = "6"
			unauthorized = true
		else
			player.password = params[:p_w]
			player.generate_token(params[:a_t])
			if !player.fb.blank?
				player.save(:validate => false)
			else
				player.save 
			end
			
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
