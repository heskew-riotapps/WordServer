class GamesController < ApplicationController
	def new
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

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def create
	#create the letters from the hopper...create the 
    @game = GameService.create params[:game]
    #@player.valid?
	respond_to do |format|
			if @unauthorized #account for FB
				format.json { render json: "unauthorized", status: :unauthorized }
			else 
				if @game.errors.empty?
					format.html { redirect_to @game, notice: 'Post was successfully created.' }
				format.json { render json: @game, status: :created, location: @game }
				#format.json  { render :json => @game.to_json( :only => [:id, :f_name, :l_name, :nickname, :auth_token])}
					
				else
					format.html { render action: "new" }
					#json error handling
					format.json { render json: @game.errors, status: :unprocessable_entity }
				end
			end
	end
  end
  
end
