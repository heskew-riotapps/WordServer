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
  attr_accessor :a_t 
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

    return Game.where('player_games' => { '$elemMatch' => {'st' => 1, 'player_id' => self.id}}).sort(:'lp_d'.desc)  
 
  end
 
 def c_games  #completed games as of data X method, no parameter passed since this is needed in to_json. hacky but it works
	if self.completed_games_from_date.nil?
		self.completed_games_from_date	= "10/06/2012"
	end
	 
	 return Game.where("co_d" => {"$gt" => Time.parse(self.completed_games_from_date)}, 
	 		'player_games' => { '$elemMatch' => {'st' => {'$in' => [ 4 , 5, 6, 7, 8]}, 'player_id' => self.id}}).sort(:'co_d'.desc).limit(10)   
	
	 
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
			devices[0].a_t = 
			self.lp_d_id = devices[0].id #last played device
		end
		
		self.a_t = token
		token
	end
  
	def generate_token(token_to_replace, gcm_registration_id)
		begin
			token = SecureRandom.urlsafe_base64
		end while Player.exists?('devices.a_t' => token) #(:devices => {:a_t => token})
	
		#just check to see if another token is not already associated with this registration Id
		if !gcm_registration_id.empty?
			#find by registrationId
			self.devices.delete_if {|v| v.a_t != token && v.r_id == gcm_registration_id}
		end

		devices = self.devices.select {|v| v.a_t == token_to_replace} 
		if devices.count == 0  
			device = Device.new	
			device.a_t = token
			device.r_id = gcm_registration_id
			self.devices << device
			self.lp_d_id = device.id #last played device
		else
			devices[0].a_t = token
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
	
		self.devices.clear
		
		device = Device.new	
		device.a_t = token
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
	
		#find by registrationId
		#this might need to be refactored to better handle multi-device
		#especially if one device has a blank reg id
		devices = self.devices.select {|v| v.r_id == gcm_registration_id} 
		if devices.count == 0  
			device = Device.new	
			device.a_t = token
			device.r_id = gcm_registration_id
			self.devices << device
			self.lp_d_id = device.id #last played device
		else
			devices[0].a_t = token
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
		if devices.count == 0  
			device = Device.new	
			device.a_t = token
			device.l_r_d = Time.now.utc
			device.i_a = true
			devices[0].r_id = gcm_registration_id
			self.devices << device
		else
			device.i_a = true
			devices[0].r_id = gcm_registration_id
			devide.l_r_d = Time.now.utc
		end
	end
	
	def update_gcm_registration_id?(token, gcm_registration_id)
		devices = self.devices.select {|v| v.a_t == token} #getContextPlayerGame(current_player.id)
		if devices.count == 0  
			device = Device.new	
			device.a_t = token
			device.l_r_d = Time.now.utc
			device.i_a = true
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
 
  # Validations.
  validates_presence_of  :e_m 
end