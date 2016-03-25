class Router
  def initialize(request)
    @request = request
  end

  def route
   raise "You need to override this method by adding an array of get,post,put,delete routes."
  end

  protected # No need to edit these, but feel free to read them to see how they work

  def root(controller, action)
    [
      get('/', controller, action)
    ]
  end

  def api_resource(name, controller)
    [
      post("/#{name}",       controller, :create),
      delete("/#{name}/:id", controller, :destroy),
      put("/#{name}/:id",    controller, :update),
      get("/#{name}/:id",    controller, :show),
      get("/#{name}",        controller, :index),
    ]
  end

  def resource(name, controller)
    [
      post("/#{name}",            controller, :create),
      post("/#{name}/:id/delete", controller, :destroy), #will be DELETE in rails
      post("/#{name}/:id",        controller, :update), #will be PUT in Rails

      get("/#{name}/:id/edit",    controller, :edit),
      get("/#{name}/new",         controller, :new),
      get("/#{name}/:id",         controller, :show),
      get("/#{name}",             controller, :index),
    ]
  end

  def get(url_str, resource, action)
    return unless get? && route_match?(url_str)
    execute(url_str, resource, action)
  end

  def post(url_str, resource, action)
    return unless post? && route_match?(url_str)
    execute(url_str, resource, action)
  end

  def put(url_str, resource, action)
    return unless put? && route_match?(url_str)
    execute(url_str, resource, action)
  end

  def delete(url_str, resource, action)
    return unless delete? && route_match?(url_str)
    execute(url_str, resource, action)
  end

  def execute(url_str, resource, action)
    fill_params(url_str)
    send_to_controller(resource, action)
  end

  def get?
    @request[:method] == "GET"
  end

  def put?
    @request[:method] == "PUT"
  end

  def post?
    @request[:method] == "POST"
  end

  def delete?
    @request[:method] == "DELETE"
  end

  def fill_params(url)
    params = Hash[url[1..-1]
              .split('/')
              .zip(@request[:paths])
              .select { |key, value| key[0] == ":" }
              .map { |key, value| [key[1..-1].to_sym, value] }]
    @request[:params].merge!(params)
  end

  def send_to_controller(resource, action)
    @request[:params].merge!({
      controller_name: resource.to_s,
      action_name: action
    })
    resource.new(@request).send(action)
  end

  def route_match?(url_path)
    @request[:route] =~ Regexp.new("^#{replace_dynamic_segments(url_path)}$")
  end

  def replace_dynamic_segments(str, depth = 0)
    return str if depth > 10
    return str unless str.include?(':')
    dynamic_segment_re = /
      (?:
         (?:
          :.+\/([^:]+)
         )
         |
         (?:
           :.+(.+)$
         )
         |
         (?:
          :.+
         )
      )
    /xi
    updated_str = str.gsub(dynamic_segment_re) do
      first_match = Regexp.last_match[1]
      if first_match.nil?
        "(.+)"
      else
        "(.+)/#{first_match}"
      end
    end
    replace_dynamic_segments(updated_str, depth += 1)
  end
end

