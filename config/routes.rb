require "resque_web"

Rails.application.routes.draw do
  mount ResqueWeb::Engine => "/resque_web"

  devise_for :users
  root to: "home#index"

  get "overview" => "home#overview"
  post "overview" => "home#overview"
  post "import" => "home#import"
  post "import_status" => "home#import_status"
  get "recurring" => "home#recurring"
  get "onetime" => "home#onetime"
  get "affiliate" => "home#affiliate"
  get "prospectus" => "home#prospectus"
  get "chart_data" => "home#chart_data"

  get "reset_metrics" => "home#reset_metrics"
end