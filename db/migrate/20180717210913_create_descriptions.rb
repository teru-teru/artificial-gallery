class CreateDescriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :descriptions do |t|
      t.references :image, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
      
      t.index [:image_id, :tag_id], unique: true
    end
  end
end
