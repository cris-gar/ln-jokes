# frozen_string_literal: true

module Authentication
  class SessionsController < ActionController::Base

    def auth
      context = Secp256k1::Context.create
      pub_key = Secp256k1::PublicKey.from_data(Secp256k1::Util.hex_to_bin(params[:key]))
      sig = Secp256k1::Signature.from_der_encoded(Secp256k1::Util.hex_to_bin(params[:sig]))
      verify = context.verify(sig, pub_key, Secp256k1::Util.hex_to_bin(params[:k1]))
      response =
        if verify
          if User.exists?(pub_key: params[:key])
            user = User.find_by(pub_key: params[:key])
            user.k1s << params[:k1]
            user.save
          else
            user = User.new(username: params[:key], pub_key: params[:key])
            user.k1s << params[:k1]
            user.save
          end
          { "status": "ok" }
        else
          {"status": "ERROR", "reason": "error details..."}
        end

      render json: response
    end

    def login
      k1 = params[:k1]
      user = User.find_by("k1s @> ARRAY[?]::varchar[]", [k1])
      response =
        if user.present?
          session[:user_id] = user.id
          { json: { user_id: user.id, url: root_path } }
        else
          { json: { errors: 'user not found' }, status: 400 }
        end
      render response
    end

    def destroy
      session.delete(:user_id)

      redirect_to root_path
    end
  end
end
