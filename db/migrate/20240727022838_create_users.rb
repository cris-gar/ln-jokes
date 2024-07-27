class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :pub_key
      t.string :k1s, array: true, default: []

      t.timestamps
    end
  end
end
