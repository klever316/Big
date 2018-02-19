require "Processos_Julgados"
require "Processos_Baixados"
require "Processos_Pendentes"
require "Processos_Taxa"
class JudicialController < ApplicationController

	def julgados
  		#Julgados dos ultimos 3 anos
  		if(Date.today.strftime("%m").to_i == 1) || (Date.today.strftime("%m").to_i == 2) && (Date.today.strftime("%d").to_i <= 15)
  			@processos_julgados = ProcessosJulgados.get_processos_julgados([Date.current.year-3,Date.current.year-2,Date.current.year-1])
  		else
  			@processos_julgados = ProcessosJulgados.get_processos_julgados([Date.current.year-2,Date.current.year-1,Date.current.year])
  		end
  		# Gráfico Julgados pro competência dos ultimos 3 anos - É feita uma verificação, no período dde janeiro até a metade de fevereiro são mostrados os dados dos três anos anteriores até contabilizar o ano atual, após essa data são mostrados os dados do ano atual e dos dois anos anteriores
  		if(Date.today.strftime("%m").to_i == 1) || (Date.today.strftime("%m").to_i == 2) && (Date.today.strftime("%d").to_i <= 15)
  			@result = params[:julgados]
			if !@result.nil?
				@competencias, @varas = ProcessosJulgados.get_processos_julgados_por_competencia(@result[:competencia],[Date.current.year-3,Date.current.year-2,Date.current.year-1])
			else
				@competencias, @varas = ProcessosJulgados.get_processos_julgados_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[Date.current.year-3,Date.current.year-2,Date.current.year-1])
			end
  		else
	  		@result = params[:julgados]
			if !@result.nil?
				@competencias, @varas = ProcessosJulgados.get_processos_julgados_por_competencia(@result[:competencia],[Date.current.year-2,Date.current.year-1,Date.current.year])
			else
				@competencias, @varas = ProcessosJulgados.get_processos_julgados_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[Date.current.year-2,Date.current.year-1,Date.current.year])
			end
  		end


	end

	def processos_julgados
		@chave_unidade = params[:column_key]
		@ano = params[:ano]
		@consulta_lista_processos = ProcessosJulgados.get_lista_processos_julgados(@chave_unidade, @ano)

		render :json => {array: @consulta_lista_processos}
	end

	def pendentes
		#Pendentes dos ultimos 3 anos
		if(Date.today.strftime("%m").to_i == 1) || (Date.today.strftime("%m").to_i == 2) && (Date.today.strftime("%d").to_i <= 15)
  			@processos_pendentes = ProcessosPendentes.get_processos_pendentes([Date.current.year-3,Date.current.year-2,Date.current.year-1])
  		else
  			@processos_pendentes = ProcessosPendentes.get_processos_pendentes([Date.current.year-2,Date.current.year-1,Date.current.year])
  		end

		# Gráfico Baixados pro competência dos ultimos 3 anos - É feita uma verificação, no período de janeiro até a metade de fevereiro são mostrados os dados dos três anos anteriores até contabilizar o ano atual, após essa data são mostrados os dados do ano atual e dos dois anos anteriores
		if(Date.today.strftime("%m").to_i == 1) || (Date.today.strftime("%m").to_i == 2) && (Date.today.strftime("%d").to_i <= 15)
  			@result = params[:pendentes]
			if !@result.nil?
				@competencias, @varas = ProcessosPendentes.get_processos_pendentes_por_competencia(@result[:competencia],[Date.current.year-3,Date.current.year-2,Date.current.year-1])
			else
				@competencias, @varas = ProcessosPendentes.get_processos_pendentes_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[Date.current.year-3,Date.current.year-2,Date.current.year-1])
			end
  		else
	  		@result = params[:pendentes]
			if !@result.nil?
				@competencias, @varas = ProcessosPendentes.get_processos_pendentes_por_competencia(@result[:competencia],[Date.current.year-2,Date.current.year-1,Date.current.year])
			else
				@competencias, @varas = ProcessosPendentes.get_processos_pendentes_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[Date.current.year-2,Date.current.year-1,Date.current.year])
			end
  		end

	end

	def processos_pendentes
		@chave_unidade = params[:column_key]
		@ano = params[:ano]
		@consulta_lista_processos = ProcessosPendentes.get_lista_processos_pendentes(@chave_unidade, @ano.to_i)		

		render :json => {array: @consulta_lista_processos}
	end

	def baixados
		#Baixados dos ultimos 3 anos
  		if(Date.today.strftime("%m").to_i == 1) || (Date.today.strftime("%m").to_i == 2) && (Date.today.strftime("%d").to_i <= 15)
  			@processos_baixados = ProcessosBaixados.get_processos_baixados([Date.current.year-3,Date.current.year-2,Date.current.year-1])
  		else
  			@processos_baixados = ProcessosBaixados.get_processos_baixados([Date.current.year-2,Date.current.year-1,Date.current.year])
  		end

  		# Gráfico Baixados pro competência dos ultimos 3 anos - É feita uma verificação, no período dde janeiro até a metade de fevereiro são mostrados os dados dos três anos anteriores até contabilizar o ano atual, após essa data são mostrados os dados do ano atual e dos dois anos anteriores
		if(Date.today.strftime("%m").to_i == 1) || (Date.today.strftime("%m").to_i == 2) && (Date.today.strftime("%d").to_i <= 15)
  			@result = params[:baixados]
			if !@result.nil?
				@competencias, @varas = ProcessosBaixados.get_processos_baixados_por_competencia(@result[:competencia],[Date.current.year-3,Date.current.year-2,Date.current.year-1])
			else
				@competencias, @varas = ProcessosBaixados.get_processos_baixados_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[Date.current.year-3,Date.current.year-2,Date.current.year-1])
			end
  		else
	  		@result = params[:baixados]
			if !@result.nil?
				@competencias, @varas = ProcessosBaixados.get_processos_baixados_por_competencia(@result[:competencia],[Date.current.year-2,Date.current.year-1,Date.current.year])
			else
				@competencias, @varas = ProcessosBaixados.get_processos_baixados_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[Date.current.year-2,Date.current.year-1,Date.current.year])
			end
  		end
	end

	def processos_baixados
		@chave_unidade = params[:column_key]
		@ano = params[:ano]
		@consulta_lista_processos = ProcessosBaixados.get_lista_processos_baixados(@chave_unidade, @ano)
		render :json => {array: @consulta_lista_processos}
	end

end