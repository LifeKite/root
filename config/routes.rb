Rlifekite::Application.routes.draw do
  get "followings/new"

  get "followings/index"

  get "followings/destroy"

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

  # resources :kites
  
  # devise_for :users
  resources :users, :only => [:index, :show, :edit]
  resources :friendships
  
  root :to => redirect('/splash/index.html')  
  # root :to => "home#index"
  # 
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
    collection do
      get :personalIndex
      get :newFromSource
    end
    member do
      put 'complete'
      put 'promote'
      put 'demote'
      put 'follow'
      put 'unfollow'
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
      put 'ForcePasswordReset'
      post 'GetKites'
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
  match "/kites/:id/follow" => "kites#Follow"
  match "/kites/:id/unfollow" => "kites#Unfollow"
  
  devise_scope :user do
    get "/login" => "devise/sessions#new"
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  match ':page' => 'home#show'
end
