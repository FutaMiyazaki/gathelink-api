class Api::V1::LinksController < ApplicationController
  def index
    links = Link.all
    render json: links.as_json
  end

  def create
    link = Link.new(link_params)
    if link.save
      render json: link.as_json
    else
      render json: { data: link.errors }
    end
  end

  def update
    link = Link.find(params[:id])
    if link.update(link_params)
      render json: link.as_json
    else
      render json: { data: link.errors }
    end
  end

  def destroy
    link = Link.find(params[:id])
    link.destroy
  end

  private

  def link_params
    params.require(:link).permit(:url, :title)
  end
end
