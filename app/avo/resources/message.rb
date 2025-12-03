class Avo::Resources::Message < Avo::BaseResource
  self.title = -> { "Message ##{record.id} - #{record.message_campaign.name}" }
  self.includes = [:delivery, :participant, :message_campaign]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :participant, as: :belongs_to, readonly: true
    field :delivery, as: :has_one
    field :message_campaign, as: :belongs_to, readonly: true
    field :status, as: :select, enum: ::Delivery.statuses, readonly: true
    field :bounce_type
    field :created_at, as: :date_time, readonly: true
    field :opened_at, as: :date_time, readonly: true
    field :bounced_at, as: :date_time, readonly: true
  end
end
