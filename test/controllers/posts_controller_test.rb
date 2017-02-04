require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  #incase you are wondering why I do not need a posts#new get/:success test here, the new function for posts should only
  #let you through to the page if you are logged in. This requires the work of an integration test
end
