class Participant
  class HomesController < ApplicationController
    def show
      @clouds = @participant.clouds.ordered

      redirect_to new_participant_cloud_path(access_token: @participant.access_token) if @clouds.none?
    end
  end
end
