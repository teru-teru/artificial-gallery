class AddLanguageToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :language, :string
  end
end
