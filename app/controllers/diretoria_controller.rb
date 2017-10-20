require "Processos_Julgados"
require "Processos_Baixados"
require "Processos_Pendentes"
require "Processos_Taxa"
class DiretoriaController < ApplicationController

	TOTAL_JULGADOS = "select sum(prtc_qtd_julgado_conhecimento) qtd_julgado_conhecimento FROM dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia WHERE orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017)"
	TOTAL_NOVOS = "SELECT Sum(6) as novos FROM (select pdrf.pedi_seq_chave, pdrf.pedi_sgl_mes_ano, orju.orju_dsc_segmento, orju.orju_bsq_chave_unidade, orju.orju_dsc_unidade, sum(prtc_qtd_pendente_baixa_conh) + sum(prtc_qtd_baixado_conhecimento) - nvl((select sum(prtc_qtd_pendente_baixa_conh) from dwfcb.pa_prtc_processo_taxa_cong prt1 where prt1.orju_seq_chave = prtc.orju_seq_chave and prt1.pedi_seq_chave_referencia = (select max(pdr1.pedi_seq_chave) from dwfcb.cd_pedi_periodo_diario pdr1 where pdr1.pedi_flg_mes_consolidado = '1' and pdr1.pedi_seq_chave < pdrf.pedi_seq_chave)), 0) prtc_qtd_novo_conh from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) group by pdrf.pedi_seq_chave, pdrf.pedi_sgl_mes_ano, prtc.orju_seq_chave, orju.orju_dsc_segmento, orju.orju_bsq_chave_unidade, orju.orju_dsc_unidade )"
	#SYSDATE,'MM' Mês automatico
	TOTAL_PENDENTES = "select sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh FROM dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju ON orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia WHERE orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) AND pedi_num_mes IN (To_Char(9)-1)"
	TOTAL_BAIXADOS = "select sum(prtc_qtd_baixado_conhecimento) qtd_baixado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017)"
	
	CONSULTA_TAXA_2017 = "SELECT pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 taxa from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (2017) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai ORDER BY 1,2"
	CONSULTA_TAXA_2016 = "SELECT pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 taxa from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (2016) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai ORDER BY 1,2"
	CONSULTA_TAXA_2015 = "SELECT pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 taxa from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (2015) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai ORDER BY 1,2"

	CONSULTA_JULGADOS_2017 = "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_julgado_conhecimento) qtd_julgado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes,  orju_dsc_unidade_pai  ORDER BY 1,2"
	CONSULTA_JULGADOS_2016 = "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_julgado_conhecimento) qtd_julgado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2016) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes,  orju_dsc_unidade_pai  ORDER BY 1,2"
	CONSULTA_JULGADOS_2015 = "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_julgado_conhecimento) qtd_julgado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2015) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes,  orju_dsc_unidade_pai  ORDER BY 1,2"

	CONSULTA_PENDENTES_2017 = "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"
	CONSULTA_PENDENTES_2016 = "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2016) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"
	CONSULTA_PENDENTES_2015 = "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2015) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"

	CONSULTA_BAIXADOS_2017 = "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_baixado_conhecimento) qtd_baixado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"
	CONSULTA_BAIXADOS_2016 = "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_baixado_conhecimento) qtd_baixado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2016) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"
	CONSULTA_BAIXADOS_2015 = "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_baixado_conhecimento) qtd_baixado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2015) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"

	def taxa

	  	@@total_julgados ||= execute_sql(TOTAL_JULGADOS)
	  	@total_julgados = @@total_julgados
	  	@@total_pendentes ||= execute_sql(TOTAL_PENDENTES)
	  	@total_pendentes = @@total_pendentes
	  	@@total_baixados ||= execute_sql(TOTAL_BAIXADOS)
	  	@total_baixados = @@total_baixados
	  	@@total_novos ||= execute_sql(TOTAL_NOVOS)
	  	@total_novos = @@total_novos
	  	
		#Julgados 2017
		@@consulta_taxa_2017 ||= execute_sql(CONSULTA_TAXA_2017)
		@taxa_congestionamento_2017 = "["
		@@consulta_taxa_2017.each_with_index do |row, i|
			if(i != @@consulta_taxa_2017.length-1)
				@taxa_congestionamento_2017 += row["taxa"].to_s + ", "
			else
				@taxa_congestionamento_2017 += row["taxa"].to_s
			end
		end
		@taxa_congestionamento_2017 += "]"

		#Julgados 2016
		@@consulta_taxa_2016 ||= execute_sql(CONSULTA_TAXA_2016)
		@taxa_congestionamento_2016 = "["
		@@consulta_taxa_2016.each_with_index do |row, i|
			if(i != @@consulta_taxa_2016.length-1)
				@taxa_congestionamento_2016 += row["taxa"].to_s + ", "
			else
				@taxa_congestionamento_2016 += row["taxa"].to_s
			end
		end
		@taxa_congestionamento_2016 += "]"

		#Julgados 2015
		@@consulta_taxa_2015 ||= execute_sql(CONSULTA_TAXA_2015)
		@taxa_congestionamento_2015 = "["
		@@consulta_taxa_2015.each_with_index do |row, i|
			if(i != @@consulta_taxa_2015.length-1)
				@taxa_congestionamento_2015 += row["taxa"].to_s + ", "
			else
				@taxa_congestionamento_2015 += row["taxa"].to_s
			end
		end
		@taxa_congestionamento_2015 += "]"

		@result = params[:taxa]

		if !@result.nil?
			puts @result[:competencia]
			@competencias, @varas = ProcessosTaxa.get_processos_taxa_por_competencia(@result[:competencia],[2017,2016,2015])
		else
			@competencias, @varas = ProcessosTaxa.get_processos_taxa_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[2017,2016,2015])
		end


	end

	def julgados

		#Julgados 2017
		@@consulta_julgados_2017 ||= execute_sql(CONSULTA_JULGADOS_2017)
		@processos_julgados_2017 = "["
		@@consulta_julgados_2017.each_with_index do |row, i|
			if(i != @@consulta_julgados_2017.length-1)
				@processos_julgados_2017 += row["qtd_julgado_conhecimento"].to_s + ", "
			else
				@processos_julgados_2017 += row["qtd_julgado_conhecimento"].to_s
			end
		end
		@processos_julgados_2017 += "]"

		#Julgados 2016
		@@consulta_julgados_2016 ||= execute_sql(CONSULTA_JULGADOS_2016)
		@processos_julgados_2016 = "["
		@@consulta_julgados_2016.each_with_index do |row, i|
			if(i != @@consulta_julgados_2016.length-1)
				@processos_julgados_2016 += row["qtd_julgado_conhecimento"].to_s + ", "
			else
				@processos_julgados_2016 += row["qtd_julgado_conhecimento"].to_s
			end
		end
		@processos_julgados_2016 += "]"

		#Julgados 2015
		@@consulta_julgados_2015 ||= execute_sql(CONSULTA_JULGADOS_2015)
		@processos_julgados_2015 = "["
		@@consulta_julgados_2015.each_with_index do |row, i|
			if(i != @@consulta_julgados_2015.length-1)
				@processos_julgados_2015 += row["qtd_julgado_conhecimento"].to_s + ", "
			else
				@processos_julgados_2015 += row["qtd_julgado_conhecimento"].to_s
			end
		end
		@processos_julgados_2015 += "]"

		#Julgados 2017 por competência
		@result = params[:julgados]
		if !@result.nil?
			@competencias, @varas = ProcessosJulgados.get_processos_julgados_por_competencia(@result[:competencia],[2017,2016,2015])
		else
			@competencias, @varas = ProcessosJulgados.get_processos_julgados_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[2017,2016,2015])
		end

	end

	def pendentes

		#Pendentes 2017
		@@consulta_pendentes_2017 ||= execute_sql(CONSULTA_PENDENTES_2017)
		@processos_pendentes_2017 = "["
		@@consulta_pendentes_2017.each_with_index do |row, i|
			if(i != @@consulta_pendentes_2017.length-1)
				@processos_pendentes_2017 += row["qtd_pendente_baixa_conh"].to_s + ", "
			else
				@processos_pendentes_2017 += row["qtd_pendente_baixa_conh"].to_s
			end
		end
		@processos_pendentes_2017 += "]"

		#Pendentes 2016
		@@consulta_pendentes_2016 ||= execute_sql(CONSULTA_PENDENTES_2016)
		@processos_pendentes_2016 = "["
		@@consulta_pendentes_2016.each_with_index do |row, i|
			if(i != @@consulta_pendentes_2016.length-1)
				@processos_pendentes_2016 += row["qtd_pendente_baixa_conh"].to_s + ", "
			else
				@processos_pendentes_2016 += row["qtd_pendente_baixa_conh"].to_s
			end
		end
		@processos_pendentes_2016 += "]"

		#Pendentes 2015
		@@consulta_pendentes_2015 ||= execute_sql(CONSULTA_PENDENTES_2015)
		@processos_pendentes_2015 = "["
		@@consulta_pendentes_2015.each_with_index do |row, i|
			if(i != @@consulta_pendentes_2015.length-1)
				@processos_pendentes_2015 += row["qtd_pendente_baixa_conh"].to_s + ", "
			else
				@processos_pendentes_2015 += row["qtd_pendente_baixa_conh"].to_s
			end
		end
		@processos_pendentes_2015 += "]"

		@result = params[:pendentes]

		if !@result.nil?
			@competencias, @varas = ProcessosPendentes.get_processos_pendentes_por_competencia(@result[:competencia],[2017,2016,2015])
		else
			@competencias, @varas = ProcessosPendentes.get_processos_pendentes_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[2017,2016,2015])
		end



	end

	def baixados

		#Baixados 2017
		@@consulta_baixados_2017 ||= execute_sql(CONSULTA_BAIXADOS_2017)
		@processos_baixados_2017 = "["
		@@consulta_baixados_2017.each_with_index do |row, i|
			if(i != @@consulta_baixados_2017.length-1)
				@processos_baixados_2017 += row["qtd_baixado_conhecimento"].to_s + ", "
			else
				@processos_baixados_2017 += row["qtd_baixado_conhecimento"].to_s
			end
		end
		@processos_baixados_2017 += "]"

		#Baixados 2016
		@@consulta_baixados_2016 ||= execute_sql(CONSULTA_BAIXADOS_2016)
		@processos_baixados_2016 = "["
		@@consulta_baixados_2016.each_with_index do |row, i|
			if(i != @@consulta_baixados_2016.length-1)
				@processos_baixados_2016 += row["qtd_baixado_conhecimento"].to_s + ", "
			else
				@processos_baixados_2016 += row["qtd_baixado_conhecimento"].to_s
			end
		end
		@processos_baixados_2016 += "]"

		#Baixados 2015
		@@consulta_baixados_2015 ||= execute_sql(CONSULTA_BAIXADOS_2015)
		@processos_baixados_2015 = "["
		@@consulta_baixados_2015.each_with_index do |row, i|
			if(i != @@consulta_baixados_2015.length-1)
				@processos_baixados_2015 += row["qtd_baixado_conhecimento"].to_s + ", "
			else
				@processos_baixados_2015 += row["qtd_baixado_conhecimento"].to_s
			end
		end
		@processos_baixados_2015 += "]"

		@result = params[:baixados]

		if !@result.nil?
			@competencias, @varas = ProcessosBaixados.get_processos_baixados_por_competencia(@result[:competencia],[2017,2016,2015])
		else
			@competencias, @varas = ProcessosBaixados.get_processos_baixados_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[2017,2016,2015])
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
