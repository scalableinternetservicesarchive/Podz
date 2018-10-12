Rails.application.routes.draw do
  resources :categories
  resources :items
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get  '/about',   to: 'static_pages#about'
  get  '/new',   to: 'items#new'
  get  '/items',   to: 'items#index'
  get  'signup', to: 'users#new'
  post 'signup', to: 'users#create'
end
