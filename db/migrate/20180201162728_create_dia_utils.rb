class CreateDiaUtils < ActiveRecord::Migration[5.1]
  def change
    create_table :dia_utils do |t|
      t.integer :ano
      t.integer :mes_numero
      t.string :mes_nome
      t.integer :qtd_dias_uteis

      t.timestamps
    end
  end
end
