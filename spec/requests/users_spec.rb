require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    before(:each) do
      @valid_user = { user: attributes_for(:user) }
      @invalid_email = { user: attributes_for(:invalid_email) }
      @invalid_password = { user: attributes_for(:invalid_password) }
      @invalid_confirmation = { user: attributes_for(:invalid_confirmation) }
    end

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

  describe "PUT /users/:id" do
    before(:each) do
      @valid_name = { user: attributes_for(:valid_name) }
      @invalid_name = { user: attributes_for(:invalid_name) }
    end

    context "when username is valid" do
      before(:each) do
        @user = create(:user)
        put "/users/#{ @user.id }", params: @valid_name
      end

      it "redirect to edit_user_path with flash[:notice]" do
        expect(flash[:notice]).to be_present
        expect(response).to redirect_to edit_user_path(@user.id)
      end

      it "updates user name" do
        @user.reload

        expect(@user.name).to eq("username")
      end
    end

    context "when username is invalid" do
      before(:each) do
        @user = create(:user)
        put "/users/#{ @user.id }", params: @invalid_name
      end

      it "redirect to edit_user_path with flash[:error]" do
        expect(flash[:error]).to be_present
        expect(response).to redirect_to edit_user_path(@user.id)
      end

      it "does not update user name" do
        @user.reload

        expect(@user.name).to_not eq("name")
        expect(@user.name).to_not eq("user")
      end
    end
  end
end
