class AlertsController < ApplicationController
	 respond_to :json

def create
	#authenticate requesting player
	player = PlayerService.findPlayer(params[:a_t]) #Player.find_by_a_t_(params[:a_t]) #auth_token
	logger.debug("alert before create #{params.inspect}")
	@alert = Alert.new
	unauthorized = false
	
	nowDate = Time.now.utc
	if params.has_key?(:a_d) && !params[:a_d].blank?
		@alert.a_d = params[:a_d]
	end
	if !params.has_key?(:t) || params[:t].blank?
		@alert.errors.add(:t, I18n.t(:error_alert_requires_text))
	else
		@alert.t = params[:t]
		@alert.st = 1
		@alert.cr_d = nowDate
		@alert.save
	end
 logger.debug("alert after create #{@alert.inspect}")
	if unauthorized 
		render json: "unauthorized", status: :unauthorized
	elsif @alert.errors.empty?
		render json: @alert, status: :ok
	else	
		render json: @alert.errors, status: :unprocessable_entity
	end  
  
  end
  
 
	
end
