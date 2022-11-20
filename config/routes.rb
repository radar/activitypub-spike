Rails.application.routes.draw do
  root to: "timeline#index"
  post "/:actor/outbox" => "actors#outbox"

  get "/sign_in", to: "sessions#new"
  post "/sessions", to: "sessions#create"
end
