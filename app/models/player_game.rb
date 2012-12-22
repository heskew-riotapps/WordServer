class PlayerGame
  include MongoMapper::EmbeddedDocument
 
  #player_id
#  key :player_id , ObjectId
  belongs_to :player
  key :sc,     Integer, :default => 0 #score
  key :t_v, Integer, :default => 1 #tray version, used by GameState on client...incremented as the player takes a turn that affects the tray			
  #key :l_t_d, Time #last_turn_date
  key :la_d, Time #last_alert_date
  key :lr_d, Time #last_reminder_date
  key :lcr_d, Time #last_chatter_received_date
  #key :cpa_d, Time #completion_alert_date
  key :lv_d, Time #last_viewed_date
  key :w_n,    Integer, :default => 0 #win_num
  key :i_t, Boolean, :default => false #is_turn 
  #key :i_w, Boolean, :default => false #is_winner
  key :a_e_g, Boolean, :default => false #alerted_to_end_of_game
  key :o,    Integer, :default => 0 #order
  key :t_l, Array #tray_letters
  key :st,    Integer, :default => 1 #status
			#NO_TRANSLATION(0), (no action yet)
			#ACTIVE(1),
			#CANCELLED(2),
			#DECLINED(3),
			#WON(4),
			#LOST(5),
			#DRAW(6),
			#RESIGNED(7) //a temp status, will be changed to LOST after the game is over????
			#DECLINED_BY_INVITEES(8),

  def tray(p_id)
	if self.player_id == p_id
		return self.t_l
	end
  end
  
end