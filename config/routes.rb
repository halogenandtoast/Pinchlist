Pinchlist::Application.routes.draw do
  get "about" => "pages#about"
  get "legal" => "pages#legal"
  get "help" => "pages#help"

  devise_for :users, :controllers => { :registrations => "registrations" }
  resource :account, only: [:edit, :update]
  resources :users, only: [:update]
  root :to => "home#index"

  post "/stripe/invoice" => "invoices#create"

  match 'dashboard', :to => 'dashboards#show', :as => :dashboard
  resources :lists, :only => [:create, :update, :destroy] do
    resources :tasks, :only => [:create, :update], :shallow => true
    resource :proxy, :controller => :list_proxies, :only => [:update, :destroy]
    resource :archive, :controller => :list_proxies, :only => [:show]
    resource :share, :only => [:create, :destroy]
  end

  namespace :public do
    resources :lists, :only => [:show]
  end

  resources :tasks, :only => [:update]
  resource :subscription, :except => [:edit]
  resource :resubscription, :only => [:create]

  namespace :admin do
    resources :users
  end
end
