Rails.application.routes.draw do
  resources :projects, only: [ :create ]  # 新規作成のみ
  resources :users, only: [ :show, :edit, :update ]
  root "home#top"  # ホームページに遷移

  get "projectmembers/index"
  get "projectmembers/create"
  get "tasks/index" => "tasks#index"
  get "projects/index" => "projects#index"

  # get "start", to: "projects#new"
  # post "projects/create", to: "projects#create"
  post "/start", to: "projects#create"

  get "search" => "home#search" # ユーザー検索のrouting
  post "add_member", to: "projectmembers#add_member"


  get "users/index" => "users#index"
  get "signup" => "users#new"
  post "users/create", to: "users#create"
  get "users/:id" => "users#show"
  get "login", to: "users#login_form"
  post "/login", to: "users#login"
  get "show/:user_id", to: "users#show"
  get "users/search", to: "users#search" # ユーザー検索


  post "/logout", to: "users#logout"




  get "/:project_id", to: "home#top"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
