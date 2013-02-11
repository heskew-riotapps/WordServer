Word::Application.routes.draw do
  #resources :people

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  
  # config/routes.rb
	scope "(:locale)", :locale => /en|es/ do
		match "/facebook/android/" => "facebook#android"
		match "/players/shuffle/" => "players#shuffle"
		match "/players/gcm_register/" => "players#gcm_register"
		match "/players/gcm_unregister/" => "players#gcm_unregister"
		match "/players/clear_tokens/" => "players#clear_tokens"
		match "/players/find_all_by_fb/" => "players#find_all_by_fb" 
		match "/players/game_list_check/" => "players#game_list_check"
		match "/players/get_games/" => "players#get_games"
		match "/games/cancel/" => "games#cancel"
		match "/games/clear_all/" => "games#clear_all"
		match "/games/get/" => "games#get"
		match "/games/refresh/" => "games#refresh"  
		match "/games/play/" => "games#play"
		match "/games/swap/" => "games#swap"
		match "/games/skip/" => "games#skip"
		match "/games/chat/" => "games#chat"
		match "/games/resign/" => "games#resign"
		match "/games/decline/" => "games#decline"
		match "/players/update_fb_account/" => "players#update_fb_account"
		match "/players/update_account/" => "players#update_account"
		match "/players/change_password/" => "players#change_password"
		match "/players/destroy_all/" => "players#destroy_all"
		match "/players/destroy" => "players#destroy"
		match "/games/destroy" => "games#destroy"
		match "/games/destroy_all____" => "games#destroy_all"
		match "/players/find/" => "players#find"
		match "/players/auth_via_token/" => "players#auth_via_token"
		match "/players/auth_via_token_with_game/" => "players#auth_via_token_with_game"
		match "/players/get_via_token/" => "players#get_via_token"
		match "/players/log_out/" => "players#log_out"
		
		resources :players, :games, :home, :rest, :gcm_notifications
	end
	
	
	#		resources :players do
	#		collection do
	#			get 'search'
	#		end
	#	end
   # resources :players, :games, :home, :rest
#    resources :games
#	resources :home
#	resources :home, :member => { :login => :get }
	match "login" => "home#login"
 
  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
