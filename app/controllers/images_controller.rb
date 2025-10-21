class ImagesController < ApplicationController
  include ActiveStorage::Streaming

  def show
    participant = Participant.friendly.find(params[:cloud_id])
    cloud = participant.clouds.find_by!(picked: true)

    if stale?(cloud)
      send_blob_stream(cloud.generated_image.blob)
    end
  end
end
