namespace :db do
  namespace :test do
    task :prepare do
      # Stub out for MongoDB
	  #MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
	  MongoMapper.database = "#cucumber-#{Rails.env}"
    end
  end
end

