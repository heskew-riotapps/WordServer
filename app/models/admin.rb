class Admin
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap
 include ActiveModel::SecurePassword 
 
  has_secure_password
  
 
end