class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.belongs_to :user, foreign_key: true
      t.string :token, null: false
      t.timestamps
    end
    add_index :sessions, :token, unique: true
  end
end
