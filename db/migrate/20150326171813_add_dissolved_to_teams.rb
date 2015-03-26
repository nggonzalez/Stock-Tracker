class AddDissolvedToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :dissolved, :boolean, :default => false
  end
end
