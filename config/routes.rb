Pinchlist::Application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resources :list_proxies, only: [:index, :update]
    resources :lists, only: [:create, :update] do
      resources :tasks, :only => [:index, :create, :update]
    end
  end

  get "about" => "pages#about"
  get "terms" => "pages#legal"
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
    resource :lock, :only => [:update]
  end

  namespace :public do
    get "lists/:id/:slug" => "lists#show", as: :list
  end

  resources :tasks, :only => [:update]
  resource :subscription, :except => [:edit]
  resource :resubscription, :only => [:create]

  namespace :admin do
    resource :dashboard
    resources :users
  end
end
