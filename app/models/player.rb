class Player
  include MongoMapper::Document
  include ActiveModel::SecurePassword 
  #include ActiveModel::Serialization
  has_secure_password

   validates_presence_of :password, :on => :create, :if => :password_required
	validates_presence_of :password_digest, :on => :create, :if => :password_required
   #attr_accessible :email, :nickname, :password

   
 # short field names!!!!!!!
  key :auth_token, String
  key :fb,  String
  key :email,      String
  key :f_name,       String#, :format => /\A[\w\.\_\-\+]+\z/
  key :l_name,       String#, :format => /\A[\w\.\_\-\+]+\z/
  key :password_confirmation, String

  key :nickname,       String#, :format => /\A[\w\.\-\+]+\z/
  key :n_w,     Integer, :default => 0 #num_wins
  key :password_digest, String 
  key :n_l, Integer, :default => 0 #num_losses
  key :n_d, Integer, :default => 0 #num_draws
  key :num_active_games, Integer, :default => 0
  key :num_visits, Integer, :default => 0

  key :highest_single_turn_score, Integer, :default => 0
  key :highest_single_turn_score_player_id , ObjectId
  key :highest_single_turn_score_game_id , ObjectId

  
  key :highest_single_game_score, Integer, :default => 0 
  key :highest_single_turn_score_player_id , ObjectId  
  key :highest_single_turn_score_game_id , ObjectId
  
  key :largest_win_margin, Integer, :default => 0
  key :largest_win_margin_player_id , ObjectId
  key :largest_win_margin_game_id , ObjectId

   def password_required
    self.fb.blank? || self.fb.empty?
	#!self.fb || !self.fb.empty?
  end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while Player.exists?(column => self[column])
	end

	def authenticate_with_new_token(password)
		if self.authenticate(password)
			self.generate_token(:auth_token)
			true
		else 
			false
		end	

	end
 
  # Validations.
  validates_presence_of  :email 
end