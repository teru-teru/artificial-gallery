class CreateCaptions < ActiveRecord::Migration[5.0]
  def change
    create_table :captions do |t|
      t.string :text
      t.integer :confidence
      t.references :image, foreign_key: true

      t.timestamps
    end
  end
end
