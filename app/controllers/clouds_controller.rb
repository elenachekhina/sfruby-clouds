class CloudsController < ApplicationController
  def index
    @clouds = Cloud.picked.ordered
    @clouds = @clouds.where("id < ?", params[:cursor]) if params[:cursor].present?
    @clouds = @clouds.limit(20).to_a

    @next_cursor = @clouds.last.id if @clouds.size >= 20

    if turbo_frame_request?
      render partial: "more_clouds"
    else
      @total_clouds = Cloud.picked.count
    end
  end

  def show
    participant = Participant.friendly.find(params[:id])
    @picked_cloud = participant.clouds.find_by!(picked: true)
    @clouds = Cloud.picked.ordered

    render action: :index
  end
end
