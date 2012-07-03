class Player
  include MongoMapper::Document
  include ActiveModel::Serialization

 # short field names!!!!!!!
  
  key :first_name,     String
  key :last_name,       String
  key :email,      String
  key :nickname,       String
  key :num_wins,     Integer, :default => 0
  key :num_losses, Integer, :default => 0
  key :num_draws, Integer, :default => 0
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
  
  def enable_api!
    self.generate_api_key!
  end
 
  def disable_api!
    self.update_attribute(:api_key, "")
  end
 
  def api_is_enabled?
    !self.api_key.empty?
  end
 
  protected
 
    def secure_digest(*args)
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end
 
    def generate_api_key!
      self.update_attribute(:api_key, secure_digest(Time.now, (1..10).map{ rand.to_s }))
    end
 
  # Validations.
  validates_presence_of  :email 
end