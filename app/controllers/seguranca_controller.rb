require "Seguranca"
class SegurancaController < ApplicationController
  def salavitima

  end

  def salavitimaretorno
  	dt_inicio = params[:dt_inicio_key]

  	dt_final = params[:dt_final_key]

  	@lista_vitimas = Seguranca.lista_de_vitimas(dt_inicio, dt_final)

  	render :json => {lista_vitimas: @lista_vitimas}
  end

  def controleacesso

  	dt_inicio = params[:dt_inicio_key]

  	dt_final = params[:dt_final_key]

  	#@lista_controle = Seguranca.controle_de_acesso(dt_inicio, dt_final)

  end
end
