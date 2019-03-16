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
      let(:subject) { post '/users', params: @valid_user }

      it "response with 302" do
        subject

        expect(response).to have_http_status(302)
      end

      it "redirect to edit_user_path with flash[:notice]" do
        subject

        expect(flash[:notice]).to be_present
        expect(response).to redirect_to edit_user_path(User.first.id)
      end

      it "has correct user name" do
        subject

        expect(User.first.name).to eq("user")
      end

      it "create user" do
        expect{subject}.to change{User.count}.from(0).to(1)
      end

      it "send welcome email" do
        delivered = ActionMailer::Base.deliveries

        expect { subject }.to change { delivered.count }.by(1)

        expect(delivered.last.to.first).to eq(User.first.email)
        expect(delivered.last.subject).to eq("Welcome")
      end
    end

    context "when email invalid" do
      let(:subject) { post '/users', params: @invalid_email }

      it "response with 200" do
        subject

        expect(response).to have_http_status(200)
      end

      it "renders new with flash[:error]" do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
      end
    end

    context "when password invalid" do
      let(:subject) { post '/users', params: @invalid_password }

      it "response with 200" do
        subject

        expect(response).to have_http_status(200)
      end

      it "renders new with flash[:error]" do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
      end
    end

    context "when password does not match with confirmation" do
      let(:subject) { post '/users', params: @invalid_confirmation }

      it "response with 200" do
        subject

        expect(response).to have_http_status(200)
      end

      it "renders new with flash[:error]" do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "PUT /users/:id" do
    before(:each) do
      @user = create(:user)
      @valid_name = { user: attributes_for(:valid_name) }
      @invalid_name = { user: attributes_for(:invalid_name) }
    end

    context "when username is valid" do
      let(:subject) { put "/users/#{ @user.id }", params: @valid_name }

      it "redirect to edit_user_path with flash[:notice]" do
        subject

        expect(flash[:notice]).to be_present
        expect(response).to redirect_to edit_user_path(@user.id)
      end

      it "updates user name" do
        subject

        @user.reload

        expect(@user.name).to eq("username")
      end
    end

    context "when username is invalid" do
      let(:subject) { put "/users/#{ @user.id }", params: @invalid_name }

      it "redirect to edit_user_path with flash[:error]" do
        subject

        expect(flash[:error]).to be_present
        expect(response).to redirect_to edit_user_path(@user.id)
      end

      it "does not update user name" do
        subject

        @user.reload

        expect(@user.name).to_not eq("name")
        expect(@user.name).to_not eq("user")
      end
    end
  end
end
