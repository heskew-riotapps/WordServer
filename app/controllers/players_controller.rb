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
  #####Player.delete_all 
	@player = PlayerService.create params[:player]
    #@player.valid?
	respond_to do |format|
			if @unauthorized #account for FB
				format.json { render json: "unauthorized", status: :unauthorized }
			else 
				if @player.errors.empty?
					format.html { redirect_to @player, notice: 'Post was successfully created.' }
				#format.json { render json: @player, status: :created, location: @player }
				#http://apidock.com/rails/ActiveRecord/Serialization/to_json
				format.json  { render :json => @player.to_json( :only => [:id, :f_n, :l_n, :n_n, :a_t]),status: :created}
					
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
	
	def destroy_all
		Player.delete_all #this is temp
	end
	
end
