class ParticipantController < ApplicationController
  before_action :set_participant

  def show
    @clouds = @participant.clouds.ordered
  end

  private

  def set_participant
    @participant = Participant.find_by!(access_token: params[:access_token])
  end
end
