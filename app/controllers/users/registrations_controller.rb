# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  def new
    @user = User.new
  end

  def create
    # 1ページ目で入力した情報のバリデーションチェック
    @user = User.new(sign_up_params)
     unless @user.valid? # valid?メソッドを用いて、user.rbのバリデーションを実行
       render :new and return # render :new_addressを2回実行しないためにreturn使用
     end
    # 1ページ目で入力した情報をsessionに保持させること
    # attributesメソッド:インスタンスをオブジェクト型からハッシュ型に変換
    # session:複数回に渡るリクエストにおいて、前のページの状態を保持するために利用される
    session["devise.regist_data"] = {user: @user.attributes}
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    # 次の住所情報登録で使用するインスタンスを生成し、該当ページへ遷移すること
    @address = @user.build_address
    render :new_address
  end

  def create_address
    # 2ページ目で入力した住所情報のバリデーションチェック
    @user = User.new(session["devise.regist_data"]["user"])
    @address = Address.new(address_params)
      unless @address.valid? # valid?メソッドを用いて、address.rbのバリデーションを実行
        render :new_address and return
      end
    # バリデーションチェックが完了した情報とsessionで保持していた情報を合わせ、ユーザー情報として保存
    @user.build_address(@address.attributes)
    @user.save
    # sessionを削除する
    session["devise.regist_data"]["user"].clear
    # 新規登録後ログインをする
    sign_in(:user, @user)
  end

  private

  def address_params
    params.require(:address).permit(:postal_code, :address)
  end
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
