require 'rails_helper'

RSpec.describe "ResetPasswords", type: :request do
  let(:user) { create(:user) }
  let(:correct_email) { user.email }
  let(:incorrect_email) { "incorrect#{ user.email }" }
  let(:user_params) {
    {
      user: {
        password: "new_password",
        password_confirmation: "new_password"
      }
    }
  }

  describe "POST /reset_passwords" do
    context "with correct email" do
      let(:subject) do
				post "/reset_passwords", params: { email: correct_email }
			end

      it "update user's reset_password_token" do
				origin_token = user.reset_password_token
        subject

				user.reload

        expect(user.reset_password_token).to_not eq(origin_token)
      end
    end

		context "with incorrect email" do
			let(:subject) do
				post "/reset_passwords", params: { email: incorrect_email }
			end

			it "does not update user's reset_password_token" do
				origin_token = user.reset_password_token
				subject

				user.reload

				expect(user.reset_password_token).to eq(origin_token)
			end

			it "render new with flash[:error]" do
        expect(subject).to render_template(:new)
        expect(flash[:error]).to be_present
      end
		end
  end

  describe "PUT /reset_passwords/:token" do
    let(:incorrect_token) { "incorrect_token" }
    before(:each) do
      post "/reset_passwords", params: { email: correct_email }
      user.reload
    end

    let(:subject) do
      put "/reset_passwords/#{ incorrect_token }", params: user_params
    end

    context "with correct token" do
      it "redirect back to root path with flash[:notice]" do
        expect(subject).to redirect_to(root_path)
        expect(flash[:notice]).to be_present
      end
    end

    context "with incorrect token" do
      it "redirect to root_path with flash[:error]" do
        expect(subject).to redirect_to(root_url)
        expect(flash[:error]).to eq("Token is invalid or has expired.")
      end
    end

    context "with expired token" do
      before do
        user.reset_token_expired_at = Time.now - 10.hours
        user.save(validate: false)
      end

      it "redirect to root_path with flash[:error]" do
        expect(subject).to redirect_to(root_url)
        expect(flash[:error]).to eq("Token is invalid or has expired.")
      end
    end

    context "with incorrect password length" do
      before do
        user_params[:user][:password] = "pwd"
        user_params[:user][:password_confirmation] = "pwd"
      end

      it "redirect to root_path with flash[:error]" do
        expect(subject).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end

    context "when password confirmation does not match" do
      before do
        user_params[:user][:password] = "password"
        user_params[:user][:password_confirmation] = "pwd"
      end

      it "redirect to root_path with flash[:error]" do
        expect(subject).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end

    context "when submit with empty password" do
      before do
        user_params[:user][:password] = ""
        user_params[:user][:password_confirmation] = "password"
      end

      it "redirect to root_path with flash[:error]" do
        expect(subject).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
  end
end
