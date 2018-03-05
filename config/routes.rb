Rails.application.routes.draw do
  post '/products' => 'products#slackcallback'
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/' => 'products#home'
  post 'sendtoslack' => 'products#sendtoslack'

end
