class AddSlugsToParticipants < ActiveRecord::Migration[8.1]
  def change
    add_column :participants, :slug, :string
    add_index :participants, :slug, unique: true
  end
end
