Myapp::Application.routes.draw do

  devise_for :users

  # Main Pages 
  get "home/index"

  # Judicial Pages
  match "judicial/julgados" => "judicial#julgados", via: [:get, :post]
  match "judicial/pendentes" => "judicial#pendentes", via: [:get, :post]
  match "judicial/baixados" => "judicial#baixados", via: [:get, :post]

  # Administrativa
  get "administrar/pessoas"
  get "administrar/patrimonio"

  # Coman
  get "coman/coman_fortaleza"
  get "coman/coman_maracanau"
  get "coman/coman_juizado_da_mulher"

  # Diretoria
  match "diretoria/taxa" => "diretoria#taxa", via: [:get, :post]
  match "diretoria/percentualJulgados" => "diretoria#percentualJulgados", via: [:get, :post]
  match "diretoria/percentualJulgadosEmbargos" => "diretoria#percentualJulgadosEmbargos", via: [:get, :post]
  match "diretoria/percentualJulgadosApelacao" => "diretoria#percentualJulgadosApelacao", via: [:get, :post]
  match "diretoria/processosDigitalizados" => "diretoria#processosDigitalizados", via: [:get, :post]
  match "diretoria/percentualBaixados" => "diretoria#percentualBaixados", via: [:get, :post]
  post "diretoria/taxaGrafico"

  post "judicial/julgados/processos" => "judicial#processos_julgados"
  post "judicial/baixados/processos" => "judicial#processos_baixados"
  post "judicial/pendentes/processos" => "judicial#processos_pendentes"

  # Custódia
  match  "custodia/custodiafila", via: [:get, :post]
  get "custodia/custodiaprocessos"
  post "custodia/dadosprocesso"

  # Crime Organizado
  match  "crime_organizado/painel_crime", via: [:get, :post]
  post "crime_organizado/detalheprocessos"
  post "crime_organizado/detalhesituacao"
  post "crime_organizado/detalhereus"

  # Segurança
  get 'seguranca/salavitima'
  get 'seguranca/controleacesso'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'home#index'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
