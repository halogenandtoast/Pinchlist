Pinchlist::Application.routes.draw do

  get "pages/about"
  get "pages/legal"
  get "pages/help"
  get "home/index"

  devise_for :users, :controller => { :registrations => "registrations" }
  root :to => "dashboards#show"
  match 'dashboard', :to => 'dashboards#show', :as => :dashboard
  resources :lists, :only => [:create, :update, :destroy] do
    resources :tasks, :only => [:create, :update], :shallow => true
    resource :proxy, :controller => :list_proxies, :only => [:update, :destroy]
    resource :archive, :controller => :list_proxies, :only => [:show]
    resource :share, :only => [:create, :destroy]
  end

  resources :tasks, :only => [:update]
  resources :subscriptions, :only => [:new, :create]

  namespace :admin do
    resources :users
  end
end
