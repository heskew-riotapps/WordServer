class PlayerGame
  include MongoMapper::EmbeddedDocument
 
 #player_id
  key :player_id , ObjectId
  key :sc,     Integer, :default => 0 #score
  key :l_t_d, Time #last_turn_date
  key :l_a_d, Time #last_alert_date
  key :l_r_d, Time #last_reminder_date
  key :l_c_r_d, Time #last_chatter_received_date
  key :l_v_d, Time #last_viewed_date
  key :w_n,    Integer, :default => 0 #win_num
  key :i_t, Boolean, :default => false #is_turn 
  key :i_w, Boolean, :default => false #is_winner
  key :a_e_g, Boolean, :default => false #alerted_to_end_of_game
  key :o,    Integer, :default => 0 #order
  key :t_l, Array #tray_letters

  
end