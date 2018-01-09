class CreateMetasTaxas < ActiveRecord::Migration[5.1]
  def change
    create_table :metas_taxas do |t|
      t.integer :ano
      t.float :valor

      t.timestamps
    end
  end
end
