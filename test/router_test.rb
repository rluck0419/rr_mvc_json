require 'test_helper'
require 'router'

module T
  class Router
    def initialize(request)
      @real_router = ::Router.new(T.empty_request(request))
    end
    def method_missing(*args)
      @real_router.send(*args)
    end
  end

  def T.empty_request(hsh)
    {
      method: 'GET',
      route: '',
      paths: [],
      query: '',
      format: '',
      params: {},
    }.merge(hsh)
  end
end

class RouterTest < Minitest::Test

  def test_fill_params_root
    r = T::Router.new(paths: ['/'])
    assert_equal({}, r.fill_params('/'))
  end

  def test_fill_params_empty
    r = T::Router.new(paths: ['users'])
    assert_equal({}, r.fill_params('users'))
  end

  def test_fill_params_simple
    r = T::Router.new(paths: ['users', '1'])
    assert_equal({ id: "1" }, r.fill_params('users/:id'))
  end

  def test_fill_params_complex
    r = T::Router.new(paths: ['users', '1', 'posts', '18', 'comments', 'foo-bar'])
    assert_equal(
      { user_id: "1",
        post_id: "18",
        title: "foo-bar"
      },
       r.fill_params('users/:user_id/posts/:post_id/comments/:title')
    )
  end

  def test_route_match_simple
    r = T::Router.new(route: '/users')
    assert r.route_match?('/users')
    refute r.route_match?('/foobar')
  end

  def test_route_match
    r = T::Router.new(route: '/users/1')
    assert r.route_match?('/users/:id')
    assert r.route_match?('/users/:user_id')
    refute r.route_match?('/users/new')
    refute r.route_match?('/users/show')
    refute r.route_match?('/users/profile')
    refute r.route_match?('/users/:id/profile')
  end

  def test_route_match_complex
    r = T::Router.new(route: '/users/1/posts/4')
    assert r.route_match?('/users/:id/posts/:post_id')
    assert r.route_match?('/users/:foo/posts/:bar')
    refute r.route_match?('/blog/:id/posts/:post_id')
  end

  def con(route)
    r = Router.new({})
    r.send(:replace_dynamic_segments, route)
  end

  def test_converts_ids
    assert_equal('/(.+)', con('/:a'))
    assert_equal('/(.+)', con('/:id'))
    assert_equal('/users/(.+)', con('/users/:id'))
    assert_equal('/users/(.+)/edit', con('/users/:id/edit'))
  end

  def test_converts_names
    assert_equal('/(.+)', con('/:name'))
    assert_equal('/users/(.+)', con('/users/:name'))
    assert_equal('/users/(.+)/edit', con('/users/:name/edit'))
  end

  def test_multiple_dynamic_segments
    assert_equal('/users/(.+)/edit/(.+)', con('/users/:name/edit/:id'))
  end

  def test_rails_level_dynamic_segments
    skip # A Regexp exercise for someone else 😉
    assert_equal('/(.+)/(.+)/(.+)', con('/:resource/:id/:action'))
  end
end
