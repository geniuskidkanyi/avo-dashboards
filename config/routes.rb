Avo::Dashboards::Engine.routes.draw do
  resources :dashboards, only: [:show], path: "/" do
    resources :cards, only: [:show]
  end
end

Avo::Engine.routes.draw do
  resources :resources, only: [] do
    resources :cards, only: [:show], controller: "dashboards/cards"
  end
end
