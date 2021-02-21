Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/init", to: "setup#init"
  get "/movies", to: "movie#find"
  get "/actors", to: "actor#find"
end
