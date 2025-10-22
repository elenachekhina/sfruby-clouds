class CloudsController < ApplicationController
  def index
    @clouds = Cloud.picked.ordered
  end

  def show
    participant = Participant.friendly.find(params[:id])
    @picked_cloud = participant.clouds.find_by!(picked: true)
    @clouds = Cloud.picked.ordered

    render action: :index
  end
end
