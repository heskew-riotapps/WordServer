class PlayersController < ApplicationController
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
    @player = Player.find_by_n_n(params[:n_n])

    respond_to do |format|
		if @player.nil?
			format.html { render action: "edit" } #wrong
			format.json { render json: "not found", status: :not_found }
		else
			format.html # index.html.erb
			#format.json { render json: @players }
			#http://apidock.com/rails/ActiveRecord/Serialization/to_json
			format.json  { render :json => @player.to_json({
						:methods => :gravatar,
						:only => [:id, :f_n, :l_n, :n_n, :n_w] } )}
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
	
	logger.debug("error inspect #{@error.inspect}")
	logger.debug("unauthorized inspect #{@unauthorized.inspect}")
	respond_to do |format|
			if @unauthorized #account for FB
				format.json { render json: @error.to_json(), status: :unauthorized }
			else 
				if @player.errors.empty?
					format.html { redirect_to @player, notice: 'Post was successfully created.' }
				#format.json { render json: @player, status: :created, location: @player }
				#http://apidock.com/rails/ActiveRecord/Serialization/to_json
				format.json  { render :json => @player.to_json( :methods => :gravatar, :only => [:id, :f_n, :l_n, :n_n, :a_t[0]]),status: :created}
					
				else
					#format.html { render action: "new" }
					#json error handling
					format.json { render json: @player.errors, status: :unprocessable_entity }
				end
			end
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
		player = Player.find_by_a_t(params[:a_t]) #auth_token    #@player.valid?
	
		if player.nil?
			unauthorized = true
			Rails.logger.info("unauthorization failed #{params[:a_t]}")		
		else
			#reset user's token, remove current token
			#send the new token back to the client
			player.n_v = player.n_v + 1
			player.generate_token(params[:a_t])
			player.save
		end
	
		respond_to do |format|
				if unauthorized #account for FB
					format.json { render json: "unauthorized", status: :unauthorized }
				else 
					if player.errors.empty?
						#format.html { redirect_to @player, notice: 'Post was successfully created.' }
						format.json  { render :json => player.to_json( 
							:only => [:id, :f_n, :l_n, :n_n, :n_w],
							:methods => :a__t),status: :ok}
					else
						#format.html { render action: "new" }
						format.json { render json: player.errors, status: :unprocessable_entity }
					end
				end
			end
	end
	
	def log_out
		player = Player.find_by_a_t(params[:a_t]) #auth_token    #@player.valid?
	
		if player.nil?
			unauthorized = true
		else
			player.remove_token(params[:a_t])
			player.save
		end
	
		respond_to do |format|
				if unauthorized #account for FB
					format.json { render json: "unauthorized", status: :unauthorized }
				else 
					if player.errors.empty?
						#format.html { redirect_to player, notice: 'Post was successfully created.' }
						format.json  { render json: "ok",status: :ok}
					else
						#format.html { render action: "new" }
						format.json { render json: player.errors, status: :unprocessable_entity }
					end
				end
			end
	end
	
	
	def update
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
		@player.destroy
		
		@existing = Player.find_by_id(params[:player][:id])
		if @existing.nil?
		
			@player = Player.create({
			  :nickname => params[:player][:nickname],
			  :email => params[:player][:email]
			})

			@ok = @player.delete
		end

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
