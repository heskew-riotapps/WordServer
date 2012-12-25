class Player
  include MongoMapper::Document
  include ActiveModel::SecurePassword 
  #include ActiveModel::Serialization
  has_secure_password
  safe # for mongo saves
 
  validates :password, :presence => true,
                     :on => :create
					# :if => :password_required
  # validates_presence_of :password, :on => :create, :if => :password_required
	#validates_presence_of :password_digest, :on => :create, :if => :password_required
   #attr_accessible :email, :nickname, :password

     
 # short field names!!!!!!!
  #many :player_games
  #key :a_t, String #auth_token
  many :opponents
  key :a_t_, Array #auth_token array allows same user to login from multiple devices
  key :fb,  String
  key :e_m,      String #email
  key :f_n,       String# first_name, :format => /\A[\w\.\_\-\+]+\z/
  key :l_n,       String# last_name, :format => /\A[\w\.\_\-\+]+\z/
  key :cr_d, Time #create_date

  key :n_n,       String# nickname, :format => /\A[\w\.\-\+]+\z/
  key :n_w,     Integer, :default => 0 #num_wins
  key :password, String
  key :password_digest, String 
  key :n_l, Integer, :default => 0 #num_losses
  key :n_d, Integer, :default => 0 #num_draws
  key :n_a_g, Integer, :default => 0 #num_active_games
  key :n_c_g, Integer, :default => 0 #num_completed_games
  key :n_v, Integer, :default => 0  #num_visits
  key :st, Integer, :default => 0  #1 = active, 2 = invited

  #this should record the words (turn number)
  key :h_s_t_s, Integer, :default => 0 #highest_single_turn_score
  key :h_s_t_s_turn_num, Integer, :default => 0 #highest_single_turn_score_turn_num
  key :h_s_t_s_game_id , ObjectId   #highest_single_turn_score_game_id

  
  key :h_s_g_s, Integer, :default => 0  #highest_single_game_score
  key :h_s_g_s_game_id , ObjectId 	#highest_single_game_score_game_id
  
  key :l_w_m, Integer, :default => 0 # largest_win_margin
  key :l_w_m_game_id , ObjectId  #largest_win_margin_game_id
  
  attr_accessor :completed_games_from_date  
  #key :completed_games_from_date 
  
   #many :games do
   # def active
   #   where(:st => 1)
   # end
  #end

   def password_required
    return false
    #self.fb.blank? || self.fb.empty?
	#!self.fb || !self.fb.empty?
  end

# def update_totals(is_win, is_loss, is_draw)
#	if is_win == true
#		self.n_w += 1
#	end
#	if is_loss == true
#		self.n_l += 1
#	end
#	if is_draw == true
#		self.n_d += 1
#	end
# end
  
  def update_opponent(opponent_id, is_win, is_loss, is_draw)
	    opponent = self.opponents.select {|v| v.player_id == opponent_id}  

		#is_win, is_loss, is_draw represent the opponents outcome in relation to the player for a specific game
		if opponent[0].nil?
			o = Opponent.new
			o.player_id = opponent_id
			o.n_g = 1
			if is_win == true
				o.n_w = 1
			end
			if is_loss == true
				o.n_l = 1
			end
			if is_draw == true
				o.n_d = 1
			end
			self.opponents << o
		else	
			opponent[0].n_g += 1
			if is_win == true
				opponent[0].n_w += 1
			end
			if is_loss == true
				opponent[0].n_l += 1
			end
			if is_draw == true
				opponent[0].n_d += 1
			end
		end	
  end
 
  
  def a_games #active games method
  #Rails.logger.debug("player class, entering a_game")
	#return Game.all(:conditions => {'player_games' => {'player_id' => self.id}}, :sort => {'lp_d' => -1})   
 	#return Game.find( {player_games: {st : 1, player_id : self.id}}).sort({lp_d : -1})   
 
 
  #db.collection.find( { type : 'city', value : 'Washington 
#D.C.' } ).sort( { relevance : -1 } ) 


  ##return Game.all(:conditions => {'player_games' => {'st' => 1, 'player_id' => self.id}}, :sort => {:lp_d => -1})   
 
   #db.recipes.find( { "ingredients" : { "name" : "butter", "qty" : "1 lb" } } );
 #db.games.find( { "player_games" : { "st" : 1, "player_id" : self.id } } );
	#return Game.find( {"player_games" => { "st" => 1} } ) 
   
   #return Game.all( :conditions => {"player_games" => { "player_games.st" => 1, "player_games.player_id" => self.id } } );
   
    #return Game.all(:conditions => {'player_games.st' => 1, 'player_games.player_id' => self.id}, :sort => {'lp_d' => -1})  
 
 
 #return Game.all(:conditions => {'st' => 1, 'player_game.player_id' => self.id}, :sort => {'lp_d' => -1})  
  
    return Game.where('player_games' => { '$elemMatch' => {'st' => 1, 'player_id' => self.id}}).sort(:'lp_d'.desc)  
 
   #return Game.all(:conditions => {'st' => 1, 'player_games.player_id' => self.id}, :sort => {'lp_d' => -1})  

   #Game.find({$and: [{"subdoc.group": {$not: {$in: ["c"]}}}, {"subdoc.role": 5}]});
   
    # return Game.where( 
	#	{$all: [{'player_games.st': 1, 'player_games.player_id': self.id}]}).sort({'lp_d': -1})   
     
	 
	 #return Game.all(:player_game => { $and => [{:player_id => self.id}, {:st => 1 }]}) 
	
	
		#db.blogpost.find({ 'tag' : { $all : [ 'tag1', 'tag2' ] }}); //2
     ##return Game.all(:conditions => {'player_games.st' => 1, 'player_games.player_id' => self.id}, :sort => {'lp_d' => -1})   
     #return Game.find({'player_games.st' : '1', 'player_games.player_id' : self.id}).sort({'lp_d' : -1})   
 

  #return Game.all(:conditions => {'st' => 1, 'player_game.player_id' => self.id})  
	#  return Game.all(:conditions => {'st' => 1, 'player_game.player_id' => self.id}, :order  => {'lp_d' => -1})   
	#return Game.where(:st => 1, :player_game => (:player_id => self.id)).sort( { :lp_d : -1 } )
	#this is stupid and ugly but i'm shrinking the collections object here in order to minimize json transport 
	#return Game.all(:conditions => {'st' => 1, 'player_game.player_id' => self.id})  
	#return Game.where(:st => 1, :player_game (:player_id => self.id)).sort( { lp_d : -1 } )  
	#{ "author.name" : "joe" }
	#Patient.where(:updated_at.gte => 3.days.ago).sort(:updated_at.desc)
  end
 
 def c_games  #completed games as of data X method, no parameter passed since this is needed in to_json. hacky but it works
	if self.completed_games_from_date.nil?
		self.completed_games_from_date	= "10/06/2012"
	end
	#{ field: { $in: [<value1>, <value2>, ... <valueN> ] } }
	#			:$or => [{'player_game.st' => 4}, {'player_game.st' => 5}, {'player_game.st' => 6}, {'player_game.st' => 7}],

	#return Game.all(:conditions => {"co_d.gt" => {"$gt" => Time.parse(self.completed_games_from_date)}, 'st' => 3, 'player_game.player_id' => self.id}, :sort => {'co_d' => -1}, :limit => 10)
	
	 return Game.where("co_d" => {"$gt" => Time.parse(self.completed_games_from_date)}, 
	 		'player_games' => { '$elemMatch' => {'st' => {'$in' => [ 4 , 5, 6, 7, 8]}, 'player_id' => self.id}}).sort(:'co_d'.desc).limit(10)   
	
	#return Game.where('player_games' => { '$elemMatch' => {'st' => {'$in' => [ 4 , 5, 6, 7, 8]}, 'player_id' => self.id}}).sort(:'co_d'.desc).limit(10)  

	
	#return Game.where("co_d.gt" => {"$gt" => Time.parse(self.completed_games_from_date)}, 
#		#'player_game.st' => {$in: [ 4 , 5, 6, 7]},
#			'player_game.player_id' => self.id, 
#			:sort => {'co_d' => -1}, :limit => 10)
 # 
#  	return Game.all(:conditions => {"co_d.gt" => {"$gt" => Time.parse(self.completed_games_from_date)}, 
#			#'player_game.st' => {$in: [ 4 , 5, 6, 7]},
#			'player_game.player_id' => self.id}, 
#			:sort => {'co_d' => -1}, :limit => 10)
  
	#return Game.find(:conditions => {:co_d.gt => {"$gt" => Time.parse(self.completed_games_from_date)}, 'st' => 2, 'player_game.player_id' => self.id})
 #  :started_on => {"$gte" => whatev}
  #.sort(:last_name).limit(10)
  end
 
  def gravatar 
    if !self.fb.nil? && !self.fb.empty? 
		return ""
	end

	return Digest::MD5::hexdigest(self.e_m)	
  end
  
	def generate_token(token_to_replace)
		#begin
		#	self[column] = SecureRandom.urlsafe_base64
		#end while Player.exists?(column => self[column])
		begin
			token = SecureRandom.urlsafe_base64
		end while Player.exists?(:a_t_ => token)

		if token_to_replace == "1"
			#do nothing, do not remove any existing tokens
		elsif token_to_replace == "0"  
			#coming from player create so make sure all token are cleared
			self.a_t_.clear
		else
			#delete old token
			self.a_t_.delete_if {|x| x == token_to_replace } 		
		end
		
		#add new token
		self.a_t_.unshift(token) #add it to front
				
		return token
	end

	def a_t
		return self.a_t_[0]
	end
	
	def generate_password
		self.password = ('a'..'z').to_a.shuffle[0,8].join
	end
	
	def remove_token(token)
		self.a_t_.delete_if {|x| x == token } 		
	end
	
	#def authenticate_with_new_token(password)
	def auth(password)
		return self.authenticate(password)
		#if self.authenticate(password)
		#	self.generate_token(:a_t)
		#	true
		#else 
		#	false
		#end	

	end
	
	def get_abbreviated_name
		if !self.f_n.blank?
			return self.f_n + " " + self.l_n.first(1) + "."
		else 
			return self.n_n
		end
	end
 
  # Validations.
  validates_presence_of  :e_m 
end