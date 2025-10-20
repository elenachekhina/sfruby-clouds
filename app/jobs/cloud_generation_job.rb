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

    nswf_detector = Cloud::NSFWDetector.new(cloud)

    if nswf_detector.check
      update_progress(:analyzed)
    else
      update_progress(:failed, failure_reason: "NSFW check failed")
    end
  rescue => err
    Rails.error.report(err, handled: true)
    update_progress(:failed, failure_reason: err.message)
  end

  def generate(_step)
    update_progress(:generating)

    card_generator = Cloud::CardGenerator.new(cloud)

    io = card_generator.generate

    cloud.generated_image.attach(io:, filename: "sfruby_cloud-#{cloud.participant.slug}.png", content_type: "image/png")
    update_progress(:generated)
  rescue => err
    Rails.error.report(err, handled: true)
    update_progress(:failed, failure_reason: err.message)
  end

  def update_progress(state, **)
    cloud.update!(state:, **)

    Turbo::StreamsChannel.broadcast_refresh_to(cloud)
  end
end
