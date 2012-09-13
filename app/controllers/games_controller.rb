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
	#authenticate requesting player
	player = Player.find_by_a_t(params[:a_t]) #auth_token
	
	@game = Game.new
	
	if player.nil?
		Rails.logger.info("unauthorized request to start game")	
		@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])		
	else
		@game = GameService.create( player, params[:game])
	
		#reset user's token
		player.generate_token(:a_t)
		#player.save  temp, add this back
		
		@game.a_t = player.a_t #auth_token
	end
	
    #@player.valid?
	respond_to do |format|
			if @unauthorized #account for FB
				format.json { render json: "unauthorized", status: :unauthorized }
			else 
				if @game.errors.empty?
					format.html { redirect_to @game, notice: 'Post was successfully created.' }
					
					#http://apidock.com/rails/ActiveRecord/Serialization/to_json
				#format.json { render json: @game, status: :created, location: @game }
					

				format.json  { render :json => @game.to_json( :include => { :player_games => {
												 :include => :player  } } ),status: :created }
				 
				 #)}
				#	 konata.to_json(:include => { :posts => {,
                #                 :include => { :comments => {
                #                               :only => :body } },
                #                 :only => :title } })
				else
					format.html { render action: "new" }
					#json error handling
					format.json { render json: @game.errors, status: :unprocessable_entity }
				end
			end
	end
  end
  
end
