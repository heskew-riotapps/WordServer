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
	player = Player.find_by_a_t_(params[:a_t]) #auth_token
logger.debug("game before create #{params.inspect}")
	@game = Game.new
	
	if player.nil?
		Rails.logger.info("unauthorized request to start game")	
	#	@game.errors.add(value['player_id'], "invalid user being requested" + value['player_id'])
		unauthorized = true		
	else
		@game = GameService.create(player, params[:game])
	
		#reset user's token
		#player.generate_token(:a_t)
		#send the new token back to the client
		
		@game.a_t = player.generate_token(params[:a_t])
		logger.debug("game after create #{@game.inspect}")
		#player.save  temp, add this back
		if !player.fb.blank?
				player.save(:validate => false)
		else
			player.save 
		end
		
		#@game.a_t = player.a_t #auth_token
	end
	
    #@player.valid?
	respond_to do |format|
			if unauthorized #account for FB
				format.json { render json: "unauthorized", status: :unauthorized }
			else 
				if @game.errors.empty?
					format.html { redirect_to @game, notice: 'Post was successfully created.' }
					
					#http://apidock.com/rails/ActiveRecord/Serialization/to_json
				#format.json { render json: @game, status: :created, location: @game }
					

				format.json  { render :json => @game.to_json( 
										:only => [:cr_d, :a_t, :t, :id],
										:method => [:left] },										
										:include => { :player_games => {
										  :only => [:o, :i_t, :sc, :id, :n_w, :t_l],  
											:include => {:player => 
												{:only => [:f_n, :l_n, :n_n, :id, :n_w],
												 :method => [:gravatar] } }
										} } ),status: :created }
				 
				 #)}
				#	 konata.to_json(:include => { :posts => { 
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
  
  def get_active_games
#authenticate requesting player
	player = Player.find_by_a_t_(params[:a_t]) #auth_token
	
	if player.nil?
		unauthorized = true		
	else
		games = Game.all(:conditions => {'st' => 1, 'player_game.player_id' => player.id}) # Game.active_by_player(player.id)
	
		#reset user's token
		#player.generate_token(:a_t)
		#send the new token back to the client
		#@game.a_t = player.generate_token(params[:a_t_])
		#player.save  temp, add this back
		if !player.fb.blank?
				player.save(:validate => false)
		else
			player.save 
		end
		
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
  
end
