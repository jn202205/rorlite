# Ruby on Rails Lite
Very simple app built on a limited implementation of ActiveRecord and Rails

* Features
  1. SQLObject
    * assocation methods: `#has_many`, `#belongs_to`, `#has_many_through`, #has_one_through
    * querying methods: `::all`, `::find`, `::where`, `::find_by`
  2. ControllerBase
    * `#render`, `#redirect_to`
  3. Session - allows storage of information in cookies
  4. Flash - temporary storage for rendering information only on next page load or render
  5. Router class handles defining routes similar to using Rails config/routes.rb
    * example -- bin/server.rb
      ```ruby
      router = Router.new
      router.draw do
        root to: "houses#index"
        resources :houses, only: [:index, :show, :new, :create]
        # more routes
        # get
      end
      ```
  6. RouteHelpers available in views and controllers
  ```ruby
  <%= link_to 'Cats', cats_path %>
  <%= link_to 'My Cat', cat_path(cat.id) %>
  ```

* To run
```
git clone https://github.com/jn202205/rorlite.git
cd rorlite
bundle install
ruby bin/server.rb
```
