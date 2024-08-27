class CreateRepositoryChecks < ActiveRecord::Migration[7.1]
  def change
    create_table :repository_checks do |t|
      t.references :repository, null: false, foreign_key: true
      t.string :aasm_state, null: false, default: 'created'
      t.string :commit_id
      t.boolean :passed, default: false
      t.json :check_data, default: {}

      t.timestamps
    end
  end
end
