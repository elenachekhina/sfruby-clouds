class CloudGenerationJob < ApplicationJob
  include ActiveJob::Continuable

  def perform(cloud)
    @cloud = cloud

    step :moderate, isolated: true
    step :generate, isolated: true unless cloud.failed?
  end

  private

  attr_reader :cloud

  def moderate(_step)
    update_progress(:analyzing)

    nswf_detector = NSFWDetector.new(cloud.image.blob)

    if nswf_detector.check
      update_progress(:analyzed)
    else
      update_progress(:failed, failure_reason: "NSFW check failed")
    end
  end

  def generate(_step)
    update_progress(:generating)
    sleep 2
    update_progress(:failed, failure_reason: "Not yet implemented")
  end

  def update_progress(state, **)
    cloud.update!(state:, **)

    Turbo::StreamsChannel.broadcast_refresh_to(cloud)
  end
end
