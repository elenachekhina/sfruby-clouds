class Participant
  class ApplicationController < ::ApplicationController
    before_action :set_participant

    private

    def set_participant
      @participant = ::Participant.find_by!(access_token: params[:access_token])
    end
  end
end
