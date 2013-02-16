class Alert
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap

  key :ti, String, :default => "" #title  
  key :t, String #text
  key :cr_d, Time #create_date
  key :st, Integer, :default => 1  #1 = active, 2 = inactive
  key :a_d, Time #activate_date 
  key :e_d, Time #expiration_date 
end