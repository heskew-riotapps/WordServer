require 'mongo'

class GcmNotificationsController < ApplicationController
	respond_to :json
	
	
	def index
		@notifications = GcmNotification.all#({:last_name => 'Medical'})

		respond_to do |format|
		  format.html # index.html.erb
		  format.json { render json: @notifications }
		end
  end
 end
	