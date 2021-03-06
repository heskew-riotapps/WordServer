class Opponent
  include MongoMapper::EmbeddedDocument
  plugin MongoMapper::Plugins::IdentityMap
 
  belongs_to :player #this represents the opponent
  key :n_g,     Integer, :default => 0 #num_games
  key :n_w,     Integer, :default => 0 #num_wins
  key :n_l, Integer, :default => 0 #num_losses
  key :n_d, Integer, :default => 0 #num_draws
  key :h_s_t_s, Integer, :default => 0 #highest_single_turn_score
  key :h_s_t_s_turn_num, Integer, :default => 0 #highest_single_turn_score_turn_num
  key :h_s_t_s_game_id , ObjectId   #highest_single_turn_score_game_id
  key :h_s_g_s, Integer, :default => 0  #highest_single_game_score
  key :h_s_g_s_game_id , ObjectId 	#highest_single_game_score_game_id
  key :l_w_m, Integer, :default => 0 # largest_win_margin
  key :l_w_m_game_id , ObjectId  #largest_win_margin_game_id
  key :st, Integer, :default => 1 #status, 1 = opponent but not completed game yet, 2 = opponent with completed game
  
  #keep top ten (or top 5) of these stats
  
end