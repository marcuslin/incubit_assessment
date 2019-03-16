require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }
  let(:valid_info) { { email: user.email, password: "password" } }
  let(:invalid_email) { { email: "invalid#{ user.email }", password: "password" } }
  let(:invalid_pwd) { { email: user.email, password: "pass" } }

  describe "POST /sessions" do
    context "when sign in with correct info" do
      let(:subject) { post "/sessions", params: valid_info }

      it "sign in user" do
        subject

        expect(session[:user]).to eq(user.id)
      end

      it "redirect to edit user" do
        expect(subject).to redirect_to edit_user_path(user.id)
      end

      it "has sign in notification" do
        subject

        expect(flash[:notice]).to be_present
      end
    end

    context "when sign in with incorrect email" do
      let(:subject) { post "/sessions", params: invalid_email }

      it "does not sign in user" do
        subject

        expect(session[:user]).to be_nil
      end

      it "render new session page" do
        expect(subject).to render_template(:new)
      end

      it "has error message" do
        subject

        expect(flash[:error]).to be_present
      end
    end

    context "when sign in with incorrect password" do
      let(:subject) { post "/sessions", params: invalid_pwd }

      it "does not sign in user" do
        subject

        expect(session[:user]).to be_nil
      end

      it "render new session page" do
        expect(subject).to render_template(:new)
      end

      it "has error message" do
        subject

        expect(flash[:error]).to be_present
      end
    end

    describe "DELETE /session/:id" do
      before { post "/sessions", params: valid_info }
      let(:subject) { delete "/sessions/:id" }

      it "assign nil to session[:user]" do
        expect { subject }.to change { session[:user] }.from(user.id).to(nil)
      end

      it "redirect to root_path after logout" do
        expect(subject).to redirect_to root_path
      end
    end
  end
end
