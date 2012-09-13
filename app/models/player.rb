class Player
  include MongoMapper::Document
  include ActiveModel::SecurePassword 
  #include ActiveModel::Serialization
  has_secure_password
 
 validates :password, :presence => true,
                     :on => :create
					# :if => :password_required
  # validates_presence_of :password, :on => :create, :if => :password_required
	#validates_presence_of :password_digest, :on => :create, :if => :password_required
   #attr_accessible :email, :nickname, :password

   
 # short field names!!!!!!!
  many :player_games
  key :a_t, String #auth_token
  key :fb,  String
  key :e_m,      String #email
  key :f_n,       String# first_name, :format => /\A[\w\.\_\-\+]+\z/
  key :l_n,       String# last_name, :format => /\A[\w\.\_\-\+]+\z/
   

  key :n_n,       String# nickname, :format => /\A[\w\.\-\+]+\z/
  key :n_w,     Integer, :default => 0 #num_wins
  key :password, String
  key :password_digest, String 
  key :n_l, Integer, :default => 0 #num_losses
  key :n_d, Integer, :default => 0 #num_draws
  key :n_a_g, Integer, :default => 0 #num_active_games
  key :n_v, Integer, :default => 0  #num_visits

  #this should record the words (turn number)
  key :h_s_t_s, Integer, :default => 0 #highest_single_turn_score
  key :h_s_t_s_turn_num, Integer, :default => 0 #highest_single_turn_score_turn_num
  key :h_s_t_s_game_id , ObjectId   #highest_single_turn_score_game_id

  
  key :h_s_g_s, Integer, :default => 0  #highest_single_game_score
  key :h_s_g_s_game_id , ObjectId 	#highest_single_game_score_game_id
  
  key :l_w_m, Integer, :default => 0 # largest_win_margin
  key :l_w_m_game_id , ObjectId  #largest_win_margin_game_id

   def password_required
    return false
    #self.fb.blank? || self.fb.empty?
	#!self.fb || !self.fb.empty?
  end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while Player.exists?(column => self[column])
	end

	def authenticate_with_new_token(password)
		if self.authenticate(password)
			self.generate_token(:a_t)
			true
		else 
			false
		end	

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