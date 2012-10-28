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
		match "/players/clear_tokens/" => "players#clear_tokens"
		match "/players/find_all_by_fb/" => "players#find_all_by_fb"
		match "/players/get_games/" => "players#get_games"
		match "/games/cancel/" => "games#cancel"
		match "/games/get/" => "games#get"
		match "/players/update_fb_account/" => "players#update_fb_account"
		match "/players/update_account/" => "players#update_account"
		match "/players/change_password/" => "players#change_password"
		match "/players/destroy_all/" => "players#destroy_all"
		match "/players/destroy" => "players#destroy"
		match "/games/destroy" => "games#destroy"
		match "/players/find/" => "players#find"
		match "/players/auth_via_token/" => "players#auth_via_token"
		match "/players/log_out/" => "players#log_out"
		
		resources :players, :games, :home, :rest
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
