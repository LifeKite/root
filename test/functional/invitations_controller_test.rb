require 'test_helper'

class InvitesControllerTest < ActionController::TestCase
  setup do
    @Invite = Invites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:Invites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create Invite" do
    assert_difference('Invite.count') do
      post :create, :Invite => @Invite.attributes
    end

    assert_redirected_to Invite_path(assigns(:Invite))
  end

  test "should show Invite" do
    get :show, :id => @Invite.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @Invite.to_param
    assert_response :success
  end

  test "should update Invite" do
    put :update, :id => @Invite.to_param, :Invite => @Invite.attributes
    assert_redirected_to Invite_path(assigns(:Invite))
  end

  test "should destroy Invite" do
    assert_difference('Invite.count', -1) do
      delete :destroy, :id => @Invite.to_param
    end

    assert_redirected_to Invites_path
  end
end
