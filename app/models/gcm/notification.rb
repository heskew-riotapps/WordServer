class Gcm::Notification
	include MongoMapper::Document
	safe # for mongo saves
	set_collection_name "gcm_notifications"
  #self.table_name = "gcm_notifications"

   belongs_to :player
   key :device_id, Integer, :null => false
   key :collapse_key, String
   key :data, String #text???
   key :delay_while_idle, Boolean
   key :sent_at, Time
   key :time_to_live, Integer
   key :st, int
   timestamps!
  
  include ::ActionView::Helpers::TextHelper
  extend ::ActionView::Helpers::TextHelper
  #serialize :data

  belongs_to :device, :class_name => 'Gcm::Device'
  validates_presence_of :collapse_key if :time_to_live?

  class << self
    # Opens a connection to the Google GCM server and attempts to batch deliver
    # an Array of notifications.
    #
    # This method expects an Array of Gcm::Notifications. If no parameter is passed
    # in then it will use the following:
    #   Gcm::Notification.all(:conditions => {:sent_at => nil})
    #
    # As each Gcm::Notification is sent the <tt>sent_at</tt> column will be timestamped,
    # so as to not be sent again.
    #
    # This can be run from the following Rake task:
    #   $ rake gcm:notifications:deliver
    #
    # Below is sample successful response as received from Google servers when the format is JSON
    #
    # response: 200;
    # {:message=>"{\"multicast_id\":6085691036338669615,\"success\":1,\"failure\":0,\"canonical_ids\":0,\"results\":[{\"message_id\":\"0:1349723376618187%d702725e98d39af3\"}]}", :code=>200}
    #
    #
    def send_notifications(notifications = Gcm::Notification.all(:conditions => {:sent_at => nil}, :joins => :device, :readonly => false))

      if configatron.gcm_on_rails.delivery_format and configatron.gcm_on_rails.delivery_format == 'plain_text'
        format = "plain_text"
      else
        format = "json"
      end

      unless notifications.nil? || notifications.empty?
        api_key = Gcm::Connection.open
        if api_key
          notifications.each do |notification|

            logger.info "notification = #{notification.inspect}"
            response = Gcm::Connection.send_notification(notification, api_key, format)
            logger.info "response = #{response.inspect}"

            if response[:code] == 200
              if response[:message].nil?
                # TODO - Making this assumption might not be right. HTTP status code 200 does not really signify success
                # if Gcm servers returned nil for the message
                error = "success"
              elsif format == "json"
                error = ""
                message_data = JSON.parse response[:message]
                success = message_data['success']
                error = message_data['results'][0]['error']  if success == 0
              elsif format == "plain_text"   #format is plain text
                message_data = response[:message]
                error = response[:message].split('=')[1]
              end


              case error
                when "MissingRegistration"
                  ex = Gcm::Errors::MissingRegistration.new(response[:message])
                  logger.warn("GCM MissingRegistration Error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
                 # notification.device.destroy
                when "InvalidRegistration"
                  ex = Gcm::Errors::InvalidRegistration.new(response[:message])
                  logger.warn("GCM InvalidRegistration Error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
                 # notification.device.destroy
                when "MismatchedSenderId"
                  ex = Gcm::Errors::MismatchSenderId.new(response[:message])
                  logger.warn("GCM MismatchSenderId Error=#{ex.message}")
                when "NotRegistered"
                  ex = Gcm::Errors::NotRegistered.new(response[:message])
                  logger.warn("GCM NotRegistered error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
                  #notification.device.destroy
                when "MessageTooBig"
                  ex = Gcm::Errors::MessageTooBig.new(response[:message])
                  logger.warn("GCM MessageTooBig Error=#{ex.message}")
                else
                  notification.sent_at = Time.now
                  notification.save!
              end
            elsif response[:code] == 401
			logger.warn("GCM InvalidAuthToken error")
              #raise Gcm::Errors::InvalidAuthToken.new(message_data)
            elsif response[:code] == 503
				logger.warn("GCM ServiceUnavailable error")
              #raise Gcm::Errors::ServiceUnavailable.new(message_data)
            elsif response[:code] == 500
				logger.warn("GCM InternalServerError error")
              #raise Gcm::Errors::InternalServerError.new(message_data)
            end

          end
        end
      end
    end
	
	 def send_notifications(notification)

      if configatron.gcm_on_rails.delivery_format and configatron.gcm_on_rails.delivery_format == 'plain_text'
        format = "plain_text"
      else
        format = "json"
      end

		api_key = GoogleNotifierService.open #Gcm::Connection.open

		logger.info "notification = #{notification.inspect}"
		response = GoogleNotifierService.send_notification(notification, api_key, format)
		logger.info "response = #{response.inspect}"

		if response[:code] == 200
		  if response[:message].nil?
			# TODO - Making this assumption might not be right. HTTP status code 200 does not really signify success
			# if Gcm servers returned nil for the message
			error = "success"
		  elsif format == "json"
			error = ""
			message_data = JSON.parse response[:message]
			success = message_data['success']
			error = message_data['results'][0]['error']  if success == 0
		  elsif format == "plain_text"   #format is plain text
			message_data = response[:message]
			error = response[:message].split('=')[1]
		  end


		  case error
			when "MissingRegistration"
			  ex = Gcm::Errors::MissingRegistration.new(response[:message])
			  logger.warn("GCM error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
			  notification.device.destroy
			when "InvalidRegistration"
			  ex = Gcm::Errors::InvalidRegistration.new(response[:message])
			  logger.warn("#{ex.message}, destroying gcm_device with id #{notification.device.id}")
			  notification.device.destroy
			when "MismatchedSenderId"
			  ex = Gcm::Errors::MismatchSenderId.new(response[:message])
			  logger.warn(ex.message)
			when "NotRegistered"
			  ex = Gcm::Errors::NotRegistered.new(response[:message])
			  logger.warn("#{ex.message}, destroying gcm_device with id #{notification.device.id}")
			  notification.device.destroy
			when "MessageTooBig"
			  ex = Gcm::Errors::MessageTooBig.new(response[:message])
			  logger.warn(ex.message)
			else
			  notification.sent_at = Time.now
			  notification.save!
		  end
		elsif response[:code] == 401
		  raise Gcm::Errors::InvalidAuthToken.new(message_data)
		elsif response[:code] == 503
		  raise Gcm::Errors::ServiceUnavailable.new(message_data)
		elsif response[:code] == 500
		  raise Gcm::Errors::InternalServerError.new(message_data)
		end

       
      
    end
  end
end