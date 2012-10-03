class PlayerGame
  include MongoMapper::EmbeddedDocument
 
  #player_id
#  key :player_id , ObjectId
  belongs_to :player
  key :sc,     Integer, :default => 0 #score
  key :l_t, Integer, default => 0 #last turn
  key :lt_d, Time #last_turn_date
  key :la_d, Time #last_alert_date
  key :lr_d, Time #last_reminder_date
  key :lcr_d, Time #last_chatter_received_date
  key :lv_d, Time #last_viewed_date
  key :w_n,    Integer, :default => 0 #win_num
  key :i_t, Boolean, :default => false #is_turn 
  key :i_w, Boolean, :default => false #is_winner
  key :a_e_g, Boolean, :default => false #alerted_to_end_of_game
  key :o,    Integer, :default => 0 #order
  key :t_l, Array #tray_letters

  def tray(p_id)
	if self.player_id == p_id
		return self.t_l
	end
  end
  
end