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
  
  
  def index
    @players = Player.all#({:last_name => 'Medical'})

    respond_to do |format|
      format.html # index.html.erb
	  format.json { render json: @players }
    end
  end
  
  def create
	@player = PlayerService.create params[:player]
    #@player.valid?
	respond_to do |format|
			if @unauthorized #account for FB
				format.json { render json: "unauthorized", status: :unauthorized }
			else 
				if @player.errors.empty?
					format.html { redirect_to @player, notice: 'Post was successfully created.' }
					format.json { render json: @player, status: :created, location: @player }
					
#		 format.json  { render :json => @things.to_json(:include => { :photos => { :only => [:id, :url] } }) }
					
				else
					format.html { render action: "new" }
					#json error handling
					format.json { render json: @player.errors, status: :unprocessable_entity }
				end
			end
		end
  end
  
  def create_123
		#create default nickname if they dont fill it in
		@player = Player.find_by_email(params[:player][:email])
		if @player.nil?
			@player = Player.find_by_nickname(params[:player][:nickname])
			if @player.nil?
				@player = Player.create({
					:nickname => params[:player][:nickname],
					:email => params[:player][:email],
					:f_name => params[:player][:f_name],
					:l_name => params[:player][:l_name],
					:password => params[:player][:password]
				})
				@player.generate_token(:auth_token)
				@ok = @player.save
			else
				#validate password here
				if @player.authenticate_with_new_token(params[:password])
					#@player.generate_session_token
					@ok = @player.update_attributes(params[:player])
				else
					@unauthorized = true
				end
			end
			
		else
			#player has been found...check password now.
			#if password fails, send login failed error to client
			#error codes via http or just error strings??
			if @player.authenticate_with_new_token(params[:password])
				#@player.generate_session_token
				@ok = @player.update_attributes(params[:player])
			else
				@unauthorized = true
			end	
		end
		respond_to do |format|
			if @unauthorized #account for FB
				format.json { render json: "unauthorized", status: :unauthorized }
			else 
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
	
end
