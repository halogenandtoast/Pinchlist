Pinchlist::Application.routes.draw do
  root to: "home#index"
  namespace :api, defaults: { format: 'json' } do
    resources :lists, only: [:create, :update, :destroy] do
      resources :tasks, :only => [:index, :create, :update, :destroy]
    end
    resources :shares, only: [:create, :destroy]
  end

  get "about" => "pages#about"
  get "terms" => "pages#legal"
  get "help" => "pages#help"

  devise_for :users, :controllers => { :registrations => "registrations" }
  resource :account, only: [:edit, :update]
  resources :users, only: [:update]

  devise_scope :user do
    root to: "dashboards#show", as: :dashboard_root
  end


  post "/stripe/invoice" => "invoices#create"

  get 'dashboard', to: 'dashboards#show', as: :dashboard
  resources :lists, :only => [:show, :create, :update, :destroy] do
    resources :tasks, :only => [:create, :update], :shallow => true
    resource :proxy, :controller => :list_proxies, :only => [:update, :destroy]
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
