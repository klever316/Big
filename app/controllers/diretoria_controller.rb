require "Processos_Julgados"
require "Processos_Baixados"
require "Processos_Pendentes"
require "Processos_Taxa"
class DiretoriaController < ApplicationController

	TOTAL_JULGADOS = "select sum(prtc_qtd_julgado_conhecimento) qtd_julgado_conhecimento FROM dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia WHERE orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017)"
	TOTAL_NOVOS = "SELECT Sum(6) as novos FROM (select pdrf.pedi_seq_chave, pdrf.pedi_sgl_mes_ano, orju.orju_dsc_segmento, orju.orju_bsq_chave_unidade, orju.orju_dsc_unidade, sum(prtc_qtd_pendente_baixa_conh) + sum(prtc_qtd_baixado_conhecimento) - nvl((select sum(prtc_qtd_pendente_baixa_conh) from dwfcb.pa_prtc_processo_taxa_cong prt1 where prt1.orju_seq_chave = prtc.orju_seq_chave and prt1.pedi_seq_chave_referencia = (select max(pdr1.pedi_seq_chave) from dwfcb.cd_pedi_periodo_diario pdr1 where pdr1.pedi_flg_mes_consolidado = '1' and pdr1.pedi_seq_chave < pdrf.pedi_seq_chave)), 0) prtc_qtd_novo_conh from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) group by pdrf.pedi_seq_chave, pdrf.pedi_sgl_mes_ano, prtc.orju_seq_chave, orju.orju_dsc_segmento, orju.orju_bsq_chave_unidade, orju.orju_dsc_unidade )"
	#SYSDATE,'MM' Mês automatico
	TOTAL_PENDENTES = 
	TOTAL_BAIXADOS = "select sum(prtc_qtd_baixado_conhecimento) qtd_baixado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017)"
	
	CONSULTA_TAXA_2017 = "SELECT pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 taxa from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (2017) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai ORDER BY 1,2"
	CONSULTA_TAXA_2016 = "SELECT pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 taxa from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (2016) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai ORDER BY 1,2"
	CONSULTA_TAXA_2015 = "SELECT pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 taxa from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (2015) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai ORDER BY 1,2"

	def taxa

	  	@@total_julgados ||= execute_sql(TOTAL_JULGADOS)
	  	@total_julgados = @@total_julgados
	  	@@total_pendentes = nil
	  	if Date.today.strftime("%d").to_i <= 15
	  		@@total_pendentes ||= execute_sql("select sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh FROM dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju ON orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia WHERE orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) AND pedi_num_mes IN (To_Char(SYSDATE,'MM')-2)")
	  	else
	  		@@total_pendentes ||= execute_sql("select sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh FROM dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju ON orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia WHERE orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) AND pedi_num_mes IN (To_Char(SYSDATE,'MM')-1)")
	  	end

	  	@total_pendentes = @@total_pendentes

	  	@@total_baixados ||= execute_sql(TOTAL_BAIXADOS)
	  	@total_baixados = @@total_baixados
	  	@@total_novos ||= execute_sql(TOTAL_NOVOS)
	  	@total_novos = @@total_novos

		@metas_taxa = {meta_2015: 61.6, meta_2016: 57.7, meta_2017: 54, meta_2018: 40.5, meta_2019: 44.9, meta_2020: 39.5}

	end

	def metaProcessosPorDia
		conn = BigDB.connection
		@column_key = params[:column_key]
		@ano = params[:ano]
		@consulta_lista_processos = conn.select_all "SELECT pedi_num_ano, ORJU_DSC_UNIDADE, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 as taxa, sum(prtc_qtd_pendente_baixa_conh) as pendente, sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) as total from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (#{@ano}) group BY pedi_num_ano, orju_dsc_unidade_pai, ORJU_DSC_UNIDADE ORDER BY 1,2"
		@dias_uteis_ano = [{ano: 2017, mes_nome: "Janeiro", mes_numero: 1, dias_uteis: 22},
							{ano: 2017, mes_nome: "Fevereiro", mes_numero: 2, dias_uteis: 17},
							{ano: 2017, mes_nome: "Março", mes_numero: 3, dias_uteis: 23},
							{ano: 2017, mes_nome: "Abril", mes_numero: 4, dias_uteis: 20},
							{ano: 2017, mes_nome: "Maio", mes_numero: 5, dias_uteis: 18},
							{ano: 2017, mes_nome: "Junho", mes_numero: 6, dias_uteis: 21},
							{ano: 2017, mes_nome: "Julho", mes_numero: 7, dias_uteis: 20},
							{ano: 2017, mes_nome: "Agosto", mes_numero: 8, dias_uteis: 19},
							{ano: 2017, mes_nome: "Setembro", mes_numero: 9, dias_uteis: 22},
							{ano: 2017, mes_nome: "Outubro", mes_numero: 10, dias_uteis: 20},
							{ano: 2017, mes_nome: "Novembro", mes_numero: 11, dias_uteis: 20},
							{ano: 2017, mes_nome: "Dezembr", mes_numero: 12, dias_uteis: 12}]
		@qtd_dias_uteis = 0
		(Date.today.strftime("%m").to_i..12).each do |mes|
			@dias_uteis_ano.each do |row|
				if(row[:mes_numero].to_i == mes)
					@qtd_dias_uteis += row[:dias_uteis]
				end
			end
		end
		render :json => {array: @consulta_lista_processos, qtd_dias_uteis: @qtd_dias_uteis}

	end

	def taxaGrafico

		@key = params[:cod_competencia]
		@dadosGrafico, @dadosTaxa = ProcessosTaxa.taxaVara(@key)
		@dias_uteis_ano = [{ano: 2017, mes_nome: "Janeiro", mes_numero: 1, dias_uteis: 22},
							{ano: 2017, mes_nome: "Fevereiro", mes_numero: 2, dias_uteis: 17},
							{ano: 2017, mes_nome: "Março", mes_numero: 3, dias_uteis: 23},
							{ano: 2017, mes_nome: "Abril", mes_numero: 4, dias_uteis: 20},
							{ano: 2017, mes_nome: "Maio", mes_numero: 5, dias_uteis: 18},
							{ano: 2017, mes_nome: "Junho", mes_numero: 6, dias_uteis: 21},
							{ano: 2017, mes_nome: "Julho", mes_numero: 7, dias_uteis: 20},
							{ano: 2017, mes_nome: "Agosto", mes_numero: 8, dias_uteis: 19},
							{ano: 2017, mes_nome: "Setembro", mes_numero: 9, dias_uteis: 22},
							{ano: 2017, mes_nome: "Outubro", mes_numero: 10, dias_uteis: 20},
							{ano: 2017, mes_nome: "Novembro", mes_numero: 11, dias_uteis: 20},
							{ano: 2017, mes_nome: "Dezembr", mes_numero: 12, dias_uteis: 12}]
		@qtd_dias_uteis = 0
		(Date.today.strftime("%m").to_i..12).each do |mes|
			@dias_uteis_ano.each do |row|
				if(row[:mes_numero].to_i == mes)
					@qtd_dias_uteis += row[:dias_uteis]
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

		#Pendentes 2017, 2016, 2015
		@processos_pendentes = ProcessosPendentes.get_processos_pendentes([2015,2016,2017])

		@result = params[:pendentes]

		if !@result.nil?
			@competencias, @varas = ProcessosPendentes.get_processos_pendentes_por_competencia(@result[:competencia],[2017,2016,2015])
		else
			@competencias, @varas = ProcessosPendentes.get_processos_pendentes_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[2017,2016,2015])
		end



	end

	def execute_sql(sql)
  		#Conexão com o banco
  		conn = BigDB.connection
  		
  		results = conn.select_all(sql)
  		if results.present?
  			return results
  		else
  			return nil
  		end
  	end

  end
