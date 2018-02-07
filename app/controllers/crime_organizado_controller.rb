require "Crime_Organizado"

class CrimeOrganizadoController < ApplicationController
  def painel_crime

  	@lista_painel = CrimeOrganizado.processos_por_foro
    @lista_reus = CrimeOrganizado.processos_por_reus
    

  end

  def detalheprocessos
    
    det_processo = params[:det_processo_key]

    @det_processo_consulta = CrimeOrganizado.detalhes_processos_por_foro(det_processo)
    
   render :json => {array: @det_processo_consulta}

  end 

  def detalhesituacao

    det_situacao = params[:det_situacao_key]
    cod_foro = params[:cod_foro_key]

    @det_situacao_consulta = CrimeOrganizado.detalhes_processos_por_reu(det_situacao, cod_foro)
    
    render :json => {array: @det_situacao_consulta}

  end

  def detalhereus

    det_reus = params[:det_reus_key]
    
    @det_reus_consulta = CrimeOrganizado.quantidade_reus_por_foro(det_reus)

    render :json => {array: @det_reus_consulta}

  end 

end
