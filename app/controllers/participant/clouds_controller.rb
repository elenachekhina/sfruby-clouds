class Participant
  class CloudsController < ApplicationController
    def new
      redirect_to participant_home_path(access_token: @participant.access_token) unless @participant.cloud_generations_remained?
    end

    def create
      return head 401 unless @participant.cloud_generations_remained?

      blob = ActiveStorage::Blob.find_signed(params[:cloud][:blob_signed_id])
      return head 422 unless blob

      cloud = @participant.clouds.create do
        it.image.attach(blob)
      end

      CloudGenerationJob.perform_later(cloud)

      redirect_to participant_cloud_path(access_token: @participant.access_token, id: cloud.id)
    end

    # This action is used to pick the image to show in the gallery
    def update
      picked_cloud = @participant.clouds.find(params[:id])

      ::Cloud.transaction do
        @participant.clouds.update_all(picked: false)
        picked_cloud.update_column(:picked, true)
      end

      redirect_to participant_home_path(access_token: @participant.access_token)
    end

    def show
      @cloud = @participant.clouds.find(params[:id])
    end
  end
end
