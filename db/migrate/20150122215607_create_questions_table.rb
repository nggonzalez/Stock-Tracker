class CreateQuestionsTable < ActiveRecord::Migration
  def change
    create_table :questions_tables do |t|
      t.text :question, null:false
      t.text :answer, null:false
    end
  end
end
