class CreateJokes < ActiveRecord::Migration[7.0]
  def change
    create_table :jokes do |t|
      t.text :text

      t.timestamps
    end
  end
end
