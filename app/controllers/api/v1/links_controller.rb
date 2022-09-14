class Api::V1::LinksController < ApplicationController
  before_action :authenticate_api_v1_user!, only: %i[create update destroy]

  def index
    links = Link.all
    render status: 200, json: { status: 200, data: links }
  end

  def create
    if api_v1_user_signed_in?
      link = current_api_v1_user.links.build(link_params)
      if link.save
        render status: 200, json: { status: 200, data: link }
      else
        render status: 400, json: { status: 400, data: link.errors }
      end
    else
      render json: { message: "ログインしてください" }
    end
  end

  def update
    link = Link.find(params[:id])
    if link.update(link_params)
      render status: 200, json: { status: 200, data: link }
    else
      render status: 404, json: { status: 404, data: link.errors, message: "更新に失敗しました" }
    end
  end

  def destroy
    link = Link.find(params[:id])
    if current_api_v1_user.id == link.user_id
      link.destroy
      render status: 200, json: { status: 200, message: "削除に成功しました" }
    else
      render status: 404, json: { status: 404, message: "削除に失敗しました" }
    end
  end

  private

  def link_params
    params.require(:link).permit(:url, :title)
  end
end
