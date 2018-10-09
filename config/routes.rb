Rails.application.routes.draw do
  resources :items
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get  '/about',   to: 'static_pages#about'
  get  '/new',   to: 'items#new'
  get  '/items',   to: 'items#index'
end
