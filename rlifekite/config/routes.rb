Rlifekite::Application.routes.draw do
  get "sharedpurpose/create"

  resources :invites

  resources :assignments

  resources :comments

  resources :groups
  
  resources :home
  
  resources :notification
  
  resources :sharedpurposes
  
  resources :sharedpurposekites

  get "friend/create"

  get "friend/destroy"

  get "users/index"

  get "users/show"

  get "home/index"

  resources :kites
  
  devise_for :users
  resources :users, :only => [:index, :show, :edit]
  resources :friendships
    
  root :to => "home#index"
  match ':page' => 'home#show'
  # map.home ':page', :controller => 'home', :action => 'show', :page => /about|help|contact/
  # root :to => "users#show"
  # match '/' => "users#show", :as => :user_root
  
  resources :comments do
    member do
      put 'markHelpful'
      put 'unmarkHelpful'
    end
  end
  
  resources :kites do
    member do
      put 'complete'
      put 'promote'
      put 'demote'
    end
  end
  
  resources :invites do
    member do
      put 'accept'
    end
  end
  
  resources :notification do
    member do
      put 'markViewed'
    end
  end
  
  resources :sharedpurpose do
    member do
      put 'promote'
      put 'demote'
    end
  end
  
  resources :users do
    member do
      put 'update'
    end
  end
  
  match "/kites/:id/complete" => "kites#complete"
  match "/kites/:id/promote" => "kites#promote"
  match "/kites/:id/demote" => "kites#demote"
  match "/invites/:id/accept" => "invites#accept"
  match "/notifications/:id/markViewed" => "notification#markViewed"
  match "/sharedpurpose/:id/selectKite" => "sharedpurposes#selectKite"
  match "/sharedpurpose/:id/promote" => "sharedpurposes#promote"
  match "/sharedpurpose/:id/demote" => "sharedpurposes#demote"
  match "/sharedpurpose/:id/addKite" => "sharedpurposes#addKite"
  match "/sharedpurpose/:id/removeKite" => "sharedpurposes#removeKite"
  match "/groups/search" => "groups#search"
  match "/sharedpurposes/search" => "sharedpurposes#search"
  match "/comments/:id/markHelpful" => "comments#markHelpful"
  match "/comments/:id/unmarkHelpful" => "comments#unmarkHelpful"
  
  devise_scope :user do
    get "/login" => "devise/sessions#new"
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
