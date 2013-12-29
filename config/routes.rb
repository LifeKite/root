Rlifekite::Application.routes.draw do
  get "kite_post/create"

  get "kite_post/edit"

  get "kite_post/delete"

  get "followings/new"

  get "followings/index"

  get "followings/destroy"

  get "sharedpurpose/create"

  resources :invites

  resources :assignments

  resources :comments

  resources :groups
  
  resources :home
  
  resources :notifications
  
  resources :sharedpurposes
  
  resources :sharedpurposekites

  get "friend/create"

  get "friend/destroy"

  #get "users/index"

  #get "users/show"

  get "home/index"

  # resources :kites
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  #resources :users, :only => [:index, :show, :edit]
  resources :friendships
  
  # root :to => redirect('/splash/index.html')  
  # root :to => "home#index"
  # 
  # map.home ':page', :controller => 'home', :action => 'show', :page => /about|help|contact/
  root :to => "kites#index"
  # match '/' => "users#show", :as => :user_root
  
  resources :comments do
    member do
      put 'markHelpful'
      put 'unmarkHelpful'
    end
  end
  
  resources :users do
      member do
        put 'update'
        post 'GetKites'
        put 'invite'
        get 'showInvite'
      end
    end
  
  resources :kites do
    collection do
      get :personalIndex
      get :newFromSource
      get :mySupportIndex
      get :hashIndex
      get :userPublicKitesIndex
      get :kite_general_search
    end
    member do
      put 'complete'
      put 'promote'
      put 'demote'
      put 'Follow'
      put 'Unfollow'
      put 'ShareKiteToSocialMedia'
      put 'Join'
      put 'Unjoin'
    end
  end
  
  resources :invites do
    member do
      put 'accept'
    end
  end
  
    
  resources :sharedpurpose do
    member do
      put 'promote'
      put 'demote'
    end
  end
  
  resources :follwings do
    collection do
      get :autocomplete_user_name
    end
  end
  
  resources :kite_posts
  
  #match "/kites/:id/complete" => "kites#complete"
  #match "/kites/:id/promote" => "kites#promote"
  #match "/kites/:id/demote" => "kites#demote"
  #match "/invites/:id/accept" => "invites#accept"
  #match "/notifications/:id/markViewed" => "notification#markViewed"
  #match "/sharedpurpose/:id/selectKite" => "sharedpurposes#selectKite"
  #match "/sharedpurpose/:id/promote" => "sharedpurposes#promote"
  #match "/sharedpurpose/:id/demote" => "sharedpurposes#demote"
  #match "/sharedpurpose/:id/addKite" => "sharedpurposes#addKite"
  #match "/sharedpurpose/:id/removeKite" => "sharedpurposes#removeKite"
  #match "/groups/search" => "groups#search"
  #match "/sharedpurposes/search" => "sharedpurposes#search"
  #match "/comments/:id/markHelpful" => "comments#markHelpful"
  #match "/comments/:id/unmarkHelpful" => "comments#unmarkHelpful"
  #match "/kites/:id/follow" => "kites#Follow"
  #match "/kites/:id/unfollow" => "kites#Unfollow"
  #match "/kites/:id/ShareKiteToSocialMedia" => "kites#ShareKiteToSocialMedia"
  
  devise_scope :user do
    get "/login" => "devise/sessions#new"
  end

  
  
  #match ':page' => 'kites#index'
end
