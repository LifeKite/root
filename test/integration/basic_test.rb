require 'test_helper'

class BasicTest < ActionDispatch::IntegrationTest

  fixtures :users, :kites
  
  test "login and create kite" do
    get "/users/sign_in"
    assert_response :success
    
    post_via_redirect "/users/sign_in", :username => users(:one).username, :password => users(:one).password
    assert_equal '/welcome', path
    
    get '/kites/new'
    assert_response :success
    
    post_via_redirect "/kites/create", :kite => kites(:one)
    assert_response :success
    
    get "/kites/randomSample"
    assert_response :success
    
    post "/kites/destroy/1"
    assert_response :success
    
    post "/users/sign_out"
    
  end

end
