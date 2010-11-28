Pinchlist::Application.routes.draw do
  get "pages/about"

  get "pages/legal"

  get "pages/help"
  
  get "home/index"

  devise_for :users, :controller => { :registrations => "registrations" }
  root :to => "dashboards#show"
  match 'dashboard', :to => 'dashboards#show', :as => :dashboard
  resources :lists, :only => [:show, :create, :update, :destroy] do
    resources :tasks, :only => [:create, :update], :shallow => true
  end

  resources :tasks, :only => [:update]

  namespace :admin do
    resources :users
  end
end
