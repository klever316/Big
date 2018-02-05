require "Processos_Julgados"
require "Processos_Baixados"
require "Processos_Pendentes"
require "Processos_Taxa"
class DiretoriaController < ApplicationController

	def taxa

	  	@total_julgados = ProcessosJulgados.get_total_julgados
	  	
	  	@total_pendentes = ProcessosPendentes.get_total_pendentes

	  	@total_baixados = ProcessosBaixados.get_total_baixados

	  	@total_novos = ProcessosTaxa.get_total_novos

	  	@metaatual, @metapassada, @metaretrasada = 0;
		if(Date.today.strftime("%m").to_i == 1) || (Date.today.strftime("%m").to_i == 2 && Date.today.strftime("%d").to_i <= 15)
			@metaatual = (MetasTaxa.find_by ano: Date.current.year-1).valor
			@metapassada = (MetasTaxa.find_by ano: Date.current.year-2).valor
			@metaretrasada = (MetasTaxa.find_by ano: Date.current.year-3).valor
		else
			@metaatual = (MetasTaxa.find_by ano: Date.current.year).valor
			@metapassada = (MetasTaxa.find_by ano: Date.current.year-1).valor
			@metaretrasada = (MetasTaxa.find_by ano: Date.current.year-2).valor
		end
	end

	def taxaGrafico
		@key = params[:cod_competencia]
		@dadosGrafico, @dadosTaxa = ProcessosTaxa.taxaVara(@key)
		@dias_uteis_ano = nil
		@qtd_dias_uteis = 0
		if(Date.today.strftime("%m").to_i == 1) || ((Date.today.strftime("%m").to_i == 2) && (Date.today.strftime("%d").to_i <= 15))
			@dias_uteis_ano = DiaUtil.where(ano: Date.today.year-1)
			(12..12).each do |mes|
				@dias_uteis_ano.each do |row|
					if(row[:mes_numero].to_i == mes)
						@qtd_dias_uteis += row[:qtd_dias_uteis]
					end
				end
			end
		else
			@dias_uteis_ano = DiaUtil.where(ano: Date.today.year)
			(Date.today.strftime("%m").to_i..12).each do |mes|
				@dias_uteis_ano.each do |row|
					if(row[:mes_numero].to_i == mes)
						@qtd_dias_uteis += row[:qtd_dias_uteis]
					end
				end
			end
		end
		render :json => {dados: @dadosGrafico, taxa: @dadosTaxa, qtd_dias_uteis: @qtd_dias_uteis}

	end

	def percentualJulgados

		@percentual_julgados_forum_por_ano, @percentual_julgados_forum_por_mes = ProcessosJulgados.get_percentual_julgados_forum([2015,2016,2017])

		@result = params[:julgados]
		if !@result.nil?
			@competencias_percentual, @varas_percentual = ProcessosJulgados.get_percentual_julgados(@result[:competencia],[2015,2016,2017])
		else
			@competencias_percentual, @varas_percentual = ProcessosJulgados.get_percentual_julgados(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[2015,2016,2017])
		end

	end

	def percentualJulgadosEmbargos
	end

	def percentualJulgadosApelacao
	end

	def percentualBaixados
		@percentual_baixados_forum_por_ano, @percentual_baixados_forum_por_mes = ProcessosBaixados.get_percentual_baixados_forum([2015,2016,2017])
		@result = params[:baixados]
		if !@result.nil?
			@competencias_percentual, @varas_percentual = ProcessosBaixados.get_percentual_baixados(@result[:competencia],[2015,2016,2017])
		else
			@competencias_percentual, @varas_percentual = ProcessosBaixados.get_percentual_baixados(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[2015,2016,2017])
		end

	end


	def processosDigitalizados
	end

end
