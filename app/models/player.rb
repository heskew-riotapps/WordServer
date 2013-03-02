class Player
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap
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
  many :devices
  many :gcm_notifications

  key :lp_d_id, String #last played device, used for notification for gcm
  #key :a_t_, Array #auth_token array allows same user to login from multiple devices
  key :fb,  String
  key :e_m,      String #email
  key :f_n,       String# first_name, :format => /\A[\w\.\_\-\+]+\z/
  key :l_n,       String# last_name, :format => /\A[\w\.\_\-\+]+\z/
  key :cr_d, Time #create_date
  key :l_rf_d, Time #, :default => Date.new("10/06/2012") #last refresh date
  
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
  key :r_g_n, Boolean, :default => true  #receive game notifications
  
  #this should record the words (turn number)
  key :h_s_t_s, Integer, :default => 0 #highest_single_turn_score
  key :h_s_t_s_turn_num, Integer, :default => 0 #highest_single_turn_score_turn_num
  key :h_s_t_s_game_id , ObjectId   #highest_single_turn_score_game_id

  
  key :h_s_g_s, Integer, :default => 0  #highest_single_game_score
  key :h_s_g_s_game_id , ObjectId 	#highest_single_game_score_game_id
  
  key :l_w_m, Integer, :default => 0 # largest_win_margin
  key :l_w_m_game_id , ObjectId  #largest_win_margin_game_id
  
  key :o_n_i_a, Boolean, :default => false #option-no interstitial ads
  
  timestamps!
  attr_accessor :completed_games_from_date 
  attr_accessor :last_alert_date    
  attr_accessor :a_t 
  attr_accessor :game_
  attr_accessor :data_
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

	def get_name
		name = "player x" 
		if !self.f_n.nil? && !self.f_n.empty?
			name = self.f_n
		elsif !self.n_n.nil? && !self.n_n.empty?
			name = self.n_n
		end
		name
	end
	
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
 
 def add_opponent(opponent_id)
		opponent = self.opponents.select {|v| v.player_id == opponent_id}  

		#only add opponent if he does not exist
		if opponent[0].nil?
			Rails.logger.info("add_opponent inner loop playerid=#{self.id} opponent=#{opponent_id}")
			o = Opponent.new
			o.player_id = opponent_id
			o.n_g = 1
			o.st = 1
			self.opponents << o
			
			true
		else
			false
		end	

  end
  
  def generate_auth_json
  data = { :id => self.id, :fb => self.fb, :f_n => self.f_n, :l_n => self.l_n,
		 :n_n => self.n_n, :n_w => self.n_w, :e_m => self.e_m, :gravatar => self.gravatar,
		 :a_t => self.a_t, :o_n_i_a => self.o_n_i_a, :l_rf_d => self.l_rf_d}
  Rails.logger.debug("data=#{data.inspect}")
   #self.data_ = data
   
   alerts = self.alert_latest
	if alerts != nil
		#Rails.logger.debug("alerts=#{alerts.inspect}")

		 data_alert = { :alerts => [{ :ti => alerts.ti, :t => alerts.t, :id => alerts.id }] }
		#Rails.logger.debug("data_alert=#{data_alert.inspect}")
		 data = data.merge(data_alert)
	end
   
    opps = []
   	self.opponents.each  do |value|
		o = { :n_g => value.n_g, :st => value.st, 
				:player => {
					:id => value.player.id,
					:fb => value.player.fb,
					:f_n => value.player.f_n,
					:l_n => value.player.l_n,
					:n_n => value.player.n_n,
					:gravatar => value.player.gravatar,
					:n_w => value.player.n_w
				}
			}
		opps << o	
	end
	
	data_opponents = { :opps => opps }
	data = data.merge(data_opponents)
	 
	active_games = [] 
	a_games = Game.where('player_games' => { '$elemMatch' => {'st' => 1, 'player_id' => self.id}}).sort(:'lp_d'.desc).all    
	#active_games = self.get_active_games
	
	#i = 1
	#count = a_games.count
	#Rails.logger.debug("get_active_games=#{a_games.count} #{a_games.inspect}")
	a_games.each  do |value|
		#Rails.logger.debug("active game=#{i} #{value.inspect}")
		#create a game hash
		game = { :id => value.id, :cr_d => value.cr_d, :ch_d => value.ch_d, :t => value.t,
				 :l_t_a => value.l_t_a, :l_t_d => value.l_t_d, :l_t_p => value.l_t_p, :l_t_pl => value.l_t_pl  
				}
				
		#create an array to hold the player game hashes		
		player_games = []		
		
		#load the player game hashes into the array
		value.player_games.each do |pg|
			player_game = { :sc => pg.sc, :i_t => pg.i_t, :st => pg.st, :player_id => pg.player_id }
			player_games << player_game 
		end	
		
		#pull the array of player game hashes into an outer hash
		data_player_games = { :player_games => player_games }
		
		#merge this newly created hash into the game hash
		game = game.merge(data_player_games)
		
		#create array of hashes for played words
		played_words = []
		last_turn_words = value.l_t_w
		#load the array with played word hashes
		last_turn_words.each do |pw|
			played_word = { :w => pw.w, :t => pw.t, :player_id => pw.player_id, :p_d => pw.p_d }
			played_words << played_word
		end	
		
		#pull the array of played word hashes into an outer hash
		data_played_words = { :played_words => played_words }
		
		#merge this newly created hash into the game hash
		game = game.merge(data_played_words)
		
		#add this game hash to the game array 
		active_games << game	
	 
	end
	 
	#pull the array of game hashes into an outer hash
	data_active_games = { :a_games => active_games }
	
	#add the active games hash to the main hash
	data = data.merge(data_active_games)

	
	completed_games = [] 
	c_games = self.get_completed_games    
	#active_games = self.get_active_games
	
	#i = 1
	#count = a_games.count
	#Rails.logger.debug("get_active_games=#{a_games.count} #{a_games.inspect}")
	c_games.each  do |value|
		#Rails.logger.debug("active game=#{i} #{value.inspect}")
		#create a game hash
		game = { :id => value.id, 
				:cr_d => value.cr_d, 
				:ch_d => value.ch_d,
				:co_d => value.co_d,
				:lp_d => value.lp_d,				 
				:t => value.t,
				:st => value.st,
				:l_t_a => value.l_t_a, 
				:l_t_d => value.l_t_d, 
				:l_t_p => value.l_t_p, 
				:l_t_pl => value.l_t_pl,
				:r_v => value.r_v,
				:r_c => value.r_c
				}
		
		#create an array to hold the player game hashes		
		player_games = []		
		
		#load the player game hashes into the array
		value.player_games.each do |pg|
			player_game = { :sc => pg.sc, :st => pg.st, :player_id => pg.player_id }
			player_games << player_game 
		end	

		#pull the array of player game hashes into an outer hash
		data_player_games = { :player_games => player_games }
		
		#merge this newly created hash into the game hash
		game = game.merge(data_player_games)
		
		#add this game hash to the game array 
		completed_games << game	
	 
	end
	 
	#pull the array of game hashes into an outer hash
	data_completed_games = { :c_games => completed_games }
	
	#add the active games hash to the main hash
	data = data.merge(data_completed_games)
	 Rails.logger.debug("data=#{data.inspect}")
   
   return data
  
=begin


 child :c_games => :c_games do
  attribute :id, :cr_d, :co_d, :lp_d, :ch_d, :t, :st, :l_t_a,:l_t, :l_t_p, :l_t_d, :l_t_pl, :r_v, :r_c
  child :player_games do
    attribute :sc, :st, :player_id  
  end
  
end

=end
  end
  
 
  
  def get_active_games #active games method
  #Rails.logger.debug("player class, entering a_game")

    return Game.where('player_games' => { '$elemMatch' => {'st' => 1, 'player_id' => self.id}}).sort(:'lp_d'.desc).all  
 
  end
  
  def a_games #active games method
  #Rails.logger.debug("player class, entering a_game")

    return Game.where('player_games' => { '$elemMatch' => {'st' => 1, 'player_id' => self.id}}).sort(:'lp_d'.desc)    
 
  end
 
  def c_games2  #completed games as of data X method, no parameter passed since this is needed in to_json. hacky but it works
	s = "[
'50f462be3768fd0002000005',
'50f4448bda4c25000200009a',
'512a64f0da3b1e0002000168',
'511c6efb8b9dd3000200031f',
'5126cfbfac1e360002001cf0',
'5126c340ac1e360002001c2b',
'512451203f22c500020001c8',
'5124501e3f22c50002000115',
'51244eef3f22c500020000c2',
'51230a88d712a7000200012f']"
	arr = eval(s)
	
	return Game.all(:conditions => {'id' => arr}) 
	# return Game.where( 
	# 		'player_games' => { '$elemMatch' => {'st' => {'$in' => [ 4 , 5, 6, 7, 8]}, 'player_id' => self.id}},
#			"co_d" => {"$gt" => Time.parse(self.completed_games_from_date)}
#			).sort(:'co_d'.desc).limit(10)   

  end
 
  def get_completed_games  #completed games as of data X method, no parameter passed since this is needed in to_json. hacky but it works
	Rails.logger.debug("player c_games completed_games_from_date=#{self.completed_games_from_date}")
	if self.completed_games_from_date.nil?
		self.completed_games_from_date	= "10/06/2012"
	end
	# Rails.logger.debug("player c_games completed_games_from_date=#{self.completed_games_from_date}")
	 return Game.where( 
	 		'player_games' => { '$elemMatch' => {'st' => {'$in' => [ 4 , 5, 6, 7, 8]}, 'player_id' => self.id}},
			"co_d" => {"$gt" => Time.parse(self.completed_games_from_date)}
			).sort(:'co_d'.desc).limit(10).all   

  end
 
 def c_games  #completed games as of data X method, no parameter passed since this is needed in to_json. hacky but it works
	Rails.logger.debug("player c_games completed_games_from_date=#{self.completed_games_from_date}")
	if self.completed_games_from_date.nil?
		self.completed_games_from_date	= "10/06/2012"
	end
	 Rails.logger.debug("player c_games completed_games_from_date=#{self.completed_games_from_date}")
	 return Game.where( 
	 		'player_games' => { '$elemMatch' => {'st' => {'$in' => [ 4 , 5, 6, 7, 8]}, 'player_id' => self.id}},
			"co_d" => {"$gt" => Time.parse(self.completed_games_from_date)}
			).sort(:'co_d'.desc).limit(10)   

  end
  
   def alert  #alerts as of data X method, no parameter passed since this is needed in rabl. hacky but it works
	Rails.logger.debug("player alerts last_alert_date=#{self.last_alert_date}")
	nowDate = Time.now.utc
	if self.last_alert_date.nil?
		self.last_alert_date	= "10/06/2012"
	end
	 Rails.logger.debug("player alerts last_alert_date=#{self.last_alert_date}")
	 return  Alert.where("st" => 1,
			"a_d" => {"$lte" => nowDate},
			"$or" => [{"e_d" => {"$gte" => nowDate}}, {"e_d" => nil}], 
			"a_d" => {"$gt" => Time.parse(self.last_alert_date)}
			).sort(:'a_d'.desc).limit(1)
	 
  end

   def alert_latest  #alerts as of data X method, no parameter passed since this is needed in rabl. hacky but it works
	Rails.logger.debug("player alerts last_alert_date=#{self.last_alert_date}")
	nowDate = Time.now.utc
	if self.last_alert_date.nil?
		self.last_alert_date	= "10/06/2012"
	end
	 Rails.logger.debug("player alerts last_alert_date=#{self.last_alert_date}")
	 return  Alert.where("st" => 1,
			"a_d" => {"$lte" => nowDate},
			"$or" => [{"e_d" => {"$gte" => nowDate}}, {"e_d" => nil}], 
			"a_d" => {"$gt" => Time.parse(self.last_alert_date)}
			).sort(:'a_d'.desc).limit(1).first   
	 
  end
  
  def gravatar 
    if !self.fb.nil? && !self.fb.empty? 
		return ""
	end

	return Digest::MD5::hexdigest(self.e_m)	
  end
  
	def update_last_device_id(token)
		devices = self.devices.select {|v| v.a_t == token} 
		if devices.count > 0  
			self.lp_d_id = devices[0].id #last played device
		end
	end
	
	def generate_token_only(token_to_replace)
		begin
			token = SecureRandom.urlsafe_base64
		end while Player.exists?('devices.a_t' => token) #(:devices => {:a_t => token})
	
		devices = self.devices.select {|v| v.a_t == token_to_replace} 
		if devices.count == 0  
			device = Device.new	
			device.a_t = token
			self.devices << device
			self.lp_d_id = device.id #last played device
		else
			devices[0].a_t = token
			self.lp_d_id = devices[0].id #last played device
		end
		
		self.a_t = token
		token
	end
  
	def generate_token(token_to_replace, gcm_registration_id)
		begin
			token = SecureRandom.urlsafe_base64
		end while Player.exists?('devices.a_t' => token) #(:devices => {:a_t => token})
	
		nowDate = Time.now.utc
		 Rails.logger.info ("generate_token ---")

		#just check to see if another token is not already associated with this registration Id
		if !gcm_registration_id.empty?
			#find by registrationId
			Rails.logger.info ("generate_token --- !gcm_registration_id.empty? count=#{self.devices.count}")
			self.devices.delete_if {|v| v.a_t != token_to_replace && v.r_id == gcm_registration_id}
			Rails.logger.info ("generate_token --- after delete_if count=#{self.devices.count}")

		end

		devices = self.devices.select {|v| v.a_t == token_to_replace} 
		if devices.count == 0  
			device = Device.new	
			device.a_t = token
			device.a_t_d = nowDate
			device.r_id = gcm_registration_id
			self.devices << device
			self.lp_d_id = device.id #last played device
			Rails.logger.info ("generate_token --- device not found")
		else
		#only update token if it is at least a week old or empty
			if devices[0].a_t_d.nil?
				devices[0].a_t_d = "10/06/2012" #Date.new("10/06/2012") # hack, a better rails dev than me can fix this
			end
			if (devices[0].a_t.empty? || ((nowDate - devices[0].a_t_d) / 3600).round > 144)
				if !devices[0].a_t_d.nil? 		
					Rails.logger.debug("auth token being updated for player=#{self.id} hours=#{((nowDate - devices[0].a_t_d) / 3600).round}")
				else
					Rails.logger.debug("auth token date is nil")
				
				end
				devices[0].a_t = token
				devices[0].a_t_d = nowDate
			else
				#dont change token
				token = devices[0].a_t 
				
				 Rails.logger.debug("auth token not changed for player=#{self.id} token=#{token}")
			end
			devices[0].r_id = gcm_registration_id
			self.lp_d_id = devices[0].id #last played device
		end
		
		self.a_t = token
		
		token
	end
	
	def generate_new_player_token(gcm_registration_id)
		begin
			token = SecureRandom.urlsafe_base64
		end while Player.exists?('devices.a_t' => token) #(:devices => {:a_t => token})
	
		#self.devices.
		
		nowDate = Time.now.utc
		
		device = Device.new	
		device.a_t = token
		device.a_t_d = nowDate
		device.r_id = gcm_registration_id
		self.devices << device 
		self.lp_d_id = device.id #last played device
		
		self.a_t = token
		token
	end
	
	def generate_token_for_gcm_registration_id(gcm_registration_id)
		begin
			token = SecureRandom.urlsafe_base64
		end while Player.exists?('devices.a_t' => token) #(:devices => {:a_t => token})
	
		nowDate = Time.now.utc
		#find by registrationId
		#this might need to be refactored to better handle multi-device
		#especially if one device has a blank reg id
		devices = self.devices.select {|v| v.r_id == gcm_registration_id} 
		if devices.count == 0  
			device = Device.new	
			device.a_t = token
			device.r_id = gcm_registration_id
			device.a_t_d = nowDate
			device.l_r_d = nowDate
			self.devices << device
			self.lp_d_id = device.id #last played device
		else
			devices[0].a_t = token
			devices[0].a_t_d = nowDate
			devices[0].r_id = gcm_registration_id
			self.lp_d_id = devices[0].id #last played device
		end
	
#		if !gcm_registration_id.empty?
#			#find by registrationId
#			devices = self.devices.select {|v| v.r_id == gcm_registration_id} 
#			
#			if devices.count == 0  
#				device = Device.new	
#				device.a_t = token
#				device.r_id = gcm_registration_id
#				self.devices << device
#			else
#				devices[0].a_t = token
#				devices[0].r_id = gcm_registration_id
#			end
#		else
#			device = Device.new	
#			device.a_t = token
#			device.r_id = ""
#			self.devices << device
#		end
		
		self.a_t = token
		token
	end
	
	def update_or_add_gcm_registration_id(token, gcm_registration_id)
		devices = self.devices.select {|v| v.a_t == token} #getContextPlayerGame(current_player.id)
		
		nowDate = Time.now.utc
		if devices.count == 0  
			device = Device.new	
			device.a_t = token
			device.l_r_d = nowDate
			device.a_t_d = nowDate
			#device.i_a = true
			devices[0].r_id = gcm_registration_id
			self.devices << device
		else
			#device.i_a = true
			devices[0].r_id = gcm_registration_id
			devide.l_r_d = nowDate
		end
	end
	
	def update_gcm_registration_id?(token, gcm_registration_id)
		devices = self.devices.select {|v| v.a_t == token} #getContextPlayerGame(current_player.id)
		nowDate = Time.now.utc
		if devices.count == 0  
			device = Device.new	
			device.a_t = token
			device.l_r_d = nowDate
			device.a_t_d = nowDate
			#device.i_a = true
			devices[0].r_id = gcm_registration_id
			self.devices << device
			
			true
		else
			false
		end
	end
	#def a_t
	#	#return self.a_t_[0]
	#	return self.devices[0].a_t_
	#end
	
	def get_last_device
		device = nil
	Rails.logger.info( "player.get_last_device self.lp_d_id= #{self.lp_d_id}")	
		if !self.lp_d_id.nil?
			devices = self.devices.select {|v| v.id == BSON::ObjectId(self.lp_d_id)} 
Rails.logger.info( "player.get_last_device devices= #{devices.inspect}")		
			if devices.count > 0  
				device = devices[0]
			end
		end
		device
	end
	
	def generate_password
		self.password = ('a'..'z').to_a.shuffle[0,8].join
	end
	
	def remove_token(token)
		#self.a_t_.delete_if {|x| x == token } 

		self.devices.delete_if {|x| x.a_t == token }		
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
  def a_games2 #active games method
  s = "[
'5126d153ac1e360002001d3a',
'5126d522ac1e360002001dab',
'511f9ef4f31f9e000200006b',
'5126dc26ac1e360002001e63',
'5126b4caac1e360002001bb5',
'511d1ef70b642200020001f5',
'5126aec3ac1e360002001b71',
'512453133f22c500020002ff',
'51074af3d178fc00020000f6',
'50dd9cb83045310002000009',
'512bd09734f54f0002000149',
'5120e269b7a0ea0002000037',
'5126c6b3ac1e360002001c85',
'512b6a4b5e0af600020000c1',
'512b69d95e0af600020000ad',
'50f4598835fc6c0002000014',
'50f853df408061000200000f',
'512a6150da3b1e00020000d9',
'51276a1274bdc300020000c3',
'511d1ee40b642200020001de',
'511d1eae0b642200020001c5',
'50fb76eb865f540002000107',
'50fd7299b6221900020002d0',
'51184aa42334330002000dbb',
'50f4ce837769d60002000169',
'510fc102c73d3a00020000be',
'510f14b8a07a6c000200007f',
'50ed80236f1381000200004a',
'50f0160948f4b70002000029',
'50e8cf365d2a2a000200001c',
'50e7bbf48eed9f0002000096',
'50e7a1ef8eed9f0002000013',
'50e7a2658eed9f000200001b',
'50e3b166faa9780002000006',
'50df99f408f8070002000024',
'50df337e7c6cd10002000018']"
	arr = eval(s)
	
	return Game.all(:conditions => {'id' => arr})
  end
  # Validations.
  validates_presence_of  :e_m 
end