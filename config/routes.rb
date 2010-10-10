Pinchlist::Application.routes.draw do
  devise_for :users
  root :to => "home#index"
  match 'dashboard', :to => 'dashboards#show', :as => :dashboard
end
