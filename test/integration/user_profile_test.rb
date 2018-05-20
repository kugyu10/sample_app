require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user = users(:admin)
  end
  
  test "プロファイル表示" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
   
  test "フォロー数とフォロワー数が正しい" do
    get user_path(@user)
    assert_select '#following', @user.following.count 
    assert_select '#followers', @user.followers.count 
  end
   
  
end
