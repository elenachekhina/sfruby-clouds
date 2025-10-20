class ApplicationJob < ActiveJob::Base
  queue_as :default
  discard_on ActiveJob::DeserializationError
end
