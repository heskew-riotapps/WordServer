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
		#@existing = Player.find_by_email(params[:email])
		#if @existing.nil?
		
			@player = Player.create({
			  :nickname => params[:player][:nickname],
			  :email => params[:player][:email]
			})

			#@player.save
		#end
		respond_to do |format|
		  if @player.save
			format.html { redirect_to @player, notice: 'Post was successfully created.' }
			format.json { render json: @player, status: :created, location: @player }
		  else
			format.html { render action: "new" }
			format.json { render json: @player.errors, status: :unprocessable_entity }
		  end
		end
	end
end
