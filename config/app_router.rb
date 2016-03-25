class AppRouter < Router
  # Routes are parsed from top down, so make sure they follow this style
  # /resource/:id/action
  # /resource/:id
  # /resource
  # If you don't use that order, it will be like the if statements in fizzbuzz
  # syntax:
    # get(<route_string>, <controller_name_constant>, <action_name_symbol)
  #
    # put('/tweets/:id/edit', TweetsController, :edit)
  # This route would be for putting an update for the tweet where :id is the number in the URL
  #
  # Put your routes in this array using the get, post, put, delete methods found in the parent Router class. (remember order matters)

  def route
    [
      post('/tweets', TweetsController, :create),
      get('/tweets/new', TweetsController, :new),
      get('/tweets/:id', TweetsController, :show),
      get('/tweets', TweetsController, :index),
      get('/not_here', TweetsController, :not_here), # This is to demo the new redirect_to method

      get('/assets/:type/:name', AssetsController, :handle),
      root(TweetsController, :index)
    ].flatten.find(&:itself)
  end
end
