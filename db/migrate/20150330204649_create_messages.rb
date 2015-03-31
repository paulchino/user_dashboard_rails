class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :message
      t.integer :to
      t.references :user, index: true

      t.timestamps
    end
  end
end
