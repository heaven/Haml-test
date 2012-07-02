Store::Application.routes.draw do
  root :to => "books#index"
  resources :books
end

#== Route Map
# Generated on 02 Jul 2012 15:54
#
#     books GET    /books(.:format)          {:action=>"index", :controller=>"books"}
#           POST   /books(.:format)          {:action=>"create", :controller=>"books"}
#  new_book GET    /books/new(.:format)      {:action=>"new", :controller=>"books"}
# edit_book GET    /books/:id/edit(.:format) {:action=>"edit", :controller=>"books"}
#      book GET    /books/:id(.:format)      {:action=>"show", :controller=>"books"}
#           PUT    /books/:id(.:format)      {:action=>"update", :controller=>"books"}
#           DELETE /books/:id(.:format)      {:action=>"destroy", :controller=>"books"}
