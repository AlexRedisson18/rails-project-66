class ChangeRepoGithubIdTypeToInteger < ActiveRecord::Migration[7.1]
  def up
    change_column :repositories, :github_id, :integer
  end

  def down
    change_column :repositories, :github_id, :string
  end
end
