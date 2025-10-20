class CloudsController < ApplicationController
  def index
    @clouds = Cloud.picked.ordered.limit(50)
  end

  def show
    participant = Participant.friendly.find(params[:id])
    @picked_cloud = participant.clouds.find_by!(picked: true)
    @clouds = Cloud.picked.ordered.limit(50)

    render action: :index
  end
end
