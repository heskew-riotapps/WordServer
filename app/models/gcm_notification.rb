class GcmNotification
	include MongoMapper::Document
	safe # for mongo saves
 
	belongs_to :player
   key :r_id, String, :null => false #
   key :collapse_key, String
   key :data, String #text???
   key :delay_while_idle, Boolean, :default => true
   key :sent_at, Time
   key :time_to_live, Integer, :default => 0 #345600 #4 days
   key :st, Integer, :default => 1 #status
   key :e, String #error

   
   timestamps!
  
  #include ::ActionView::Helpers::TextHelper
  #extend ::ActionView::Helpers::TextHelper
  #serialize :data

  belongs_to :device, :class_name => 'Gcm::Device'
  validates_presence_of :collapse_key if :time_to_live?

end