class PlayersController < ApplicationController
	def new
		@player = Player.new
		
		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @player }	
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
		#create default nickname if they dont fill it in
		@existing = Player.find_by_email(params[:player][:email])
		if @existing.nil?
		
			@player = Player.create({
			  :nickname => params[:player][:nickname],
			  :email => params[:player][:email]
			})

			@ok = @player.save
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
	
	def update
		@player = Player.find(params[:id])

		respond_to do |format|
			if @person.update_attributes(params[:person])
				format.html { redirect_to @player, notice: 'Person was successfully updated.' }
				format.json { head :no_content }
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
