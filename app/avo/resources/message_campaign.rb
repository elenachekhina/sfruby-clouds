class Avo::Resources::MessageCampaign < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :name, as: :text
    field :subject, as: :text
    field :body, as: :easy_mde
    field :sent_messages_count, as: :number
    field :opened_messages_count, as: :number
    field :bounced_messages_count, as: :number
  end
end
