require 'rails_helper'

RSpec.describe "Users", type: :request do
  before(:each) do
    @valid_user = { user: attributes_for(:user) }
    @invalid_email = { user: attributes_for(:invalid_email) }
    @invalid_password = { user: attributes_for(:invalid_password) }
    @invalid_confirmation = { user: attributes_for(:invalid_confirmation) }
  end

  describe "POST /users" do
    context "when valid user" do
      before(:each) do
        post '/users', params: @valid_user
        @user = User.first
      end

      it "response with 302" do
        expect(response).to have_http_status(302)
      end

      it "redirect to edit_user_path with flash[:notice]" do
        expect(flash[:notice]).to be_present
        expect(response).to redirect_to edit_user_path(@user.id)
      end

      it "has correct user name" do
        expect(@user.name).to eq("user")
      end
    end

    context "when email invalid" do
      before(:each) do
        post '/users', params: @invalid_email
      end

      it "response with 200" do
        expect(response).to have_http_status(200)
      end

      it "renders new with flash[:error]" do
        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
      end
    end

    context "when password invalid" do
      before(:each) do
        post '/users', params: @invalid_password
      end

      it "response with 200" do
        expect(response).to have_http_status(200)
      end

      it "renders new with flash[:error]" do
        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
      end
    end

    context "when password does not match with confirmation" do
      before(:each) do
        post '/users', params: @invalid_confirmation
      end

      it "response with 200" do
        expect(response).to have_http_status(200)
      end

      it "renders new with flash[:error]" do
        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
      end
    end
  end
end
