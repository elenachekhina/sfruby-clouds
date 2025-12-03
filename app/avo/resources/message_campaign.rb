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
    field :sent_messages_count, as: :number, only_on: %i[show index], readonly: true
    field :opened_messages_count, as: :custom_progress_bar, max: :sent_messages_count, display_value: true, only_on: %i[show index], readonly: true
    field :bounced_messages_count, as: :custom_progress_bar, max: :sent_messages_count, display_value: true, only_on: %i[show index], readonly: true
  end
end
