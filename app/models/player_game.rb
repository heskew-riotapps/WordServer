class PlayerGame
  include MongoMapper::EmbeddedDocument
 
 #player_id
  key :player_id , ObjectId
  key :score,     Integer, :default => 0
  key :last_turn_date, Time
  key :last_alert_date, Time
  key :last_reminder_date, Time
  key :last_chatter_received_date, Time
  key :last_viewed_date, Time
  key :win_num,    Integer, :default => 0
  key :is_turn, Boolean, :default => false 
  key :is_winner, Boolean, :default => false 
  key :has_been_alerted_to_end_of_game, Boolean, :default => false 
  key :player_order,    Integer, :default => 0
  many :tray_tiles
  
  
end