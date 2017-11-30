require "Processos_Julgados"
require "Processos_Baixados"
require "Processos_Pendentes"
require "Processos_Taxa"
class JudicialController < ApplicationController

	def julgados
  		#Julgados 2017,2016 e 2015
  		@processos_julgados = ProcessosJulgados.get_processos_julgados([2015,2016,2017])
		#Julgados 2017 por competência
		@result = params[:julgados]
		if !@result.nil?
			@competencias, @varas = ProcessosJulgados.get_processos_julgados_por_competencia(@result[:competencia],[2015,2016,2017])
		else
			@competencias, @varas = ProcessosJulgados.get_processos_julgados_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[2015,2016,2017])
		end
	end

	def processos_julgados
		conn = BigDB.connection
		@column_key = params[:column_key]
		@ano = params[:ano]
		@consulta_lista_processos = conn.select_all  "select pedi_num_ano, ORJU_BSQ_CHAVE_UNIDADE, orju_dsc_unidade, PROC_DSC_PROCESSO_FORMATADO, SIPR_DSC_SITUACAO_PROCESSO, PROC_DAT_PROTOCOLO from dwfcb.pf_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia join dwfcb.pd_proc_processo proc on proc.proc_seq_chave =  prtc.proc_seq_chave join dwfcb.pd_sipr_situacao_processo sit on sit.sipr_seq_chave  = prtc.sipr_seq_chave	 where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (#{@ano}) and orju_bsq_chave_unidade like '#{@column_key}' and PRTC_QTD_JULGADO_CONHECIMENTO = 1"

		render :json => {array: @consulta_lista_processos}
	end

	def pendentes
		#Pendentes 2017, 2016, 2015
		@processos_pendentes = ProcessosPendentes.get_processos_pendentes([2015,2016,2017])

		@result = params[:pendentes]

		if !@result.nil?
			@competencias, @varas = ProcessosPendentes.get_processos_pendentes_por_competencia(@result[:competencia],[2015,2016,2017])
		else
			@competencias, @varas = ProcessosPendentes.get_processos_pendentes_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[2015,2016,2017])
		end
	end

	def processos_pendentes
		conn = BigDB.connection
		@column_key = params[:column_key]
		@ano = params[:ano]
		@consulta_lista_processos = conn.select_all  "select pedi_num_ano, ORJU_BSQ_CHAVE_UNIDADE, orju_dsc_unidade, PROC_DSC_PROCESSO_FORMATADO, SIPR_DSC_SITUACAO_PROCESSO, PROC_DAT_PROTOCOLO from dwfcb.pf_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia  join dwfcb.pd_proc_processo proc on proc.proc_seq_chave =  prtc.proc_seq_chave join dwfcb.pd_sipr_situacao_processo sit on sit.sipr_seq_chave  = prtc.sipr_seq_chave  where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (#{@ano}) and pedi_num_mes IN (To_Char(SYSDATE,'MM')-1) and orju_bsq_chave_unidade like '#{@column_key}' and PRTC_QTD_PENDENTE_BAIXA_CONH = 1" 
		puts @consulta_lista_processos.first
		render :json => {array: @consulta_lista_processos}
	end

	def baixados
		#Baixados 2017, 2016, 2015
		@processos_baixados = ProcessosBaixados.get_processos_baixados([2015,2016,2017])

		@result = params[:baixados]

		if !@result.nil?
			@competencias, @varas = ProcessosBaixados.get_processos_baixados_por_competencia(@result[:competencia],[2015,2016,2017])
		else
			@competencias, @varas = ProcessosBaixados.get_processos_baixados_por_competencia(["familia","civel","criminal","fazenda_publica","juri","infancia","sucessoes","exec_penais","exec_fiscais","falencia","registros_publicos","toxico","auditoria_militar","penas_alternativas","transito"],[2015,2016,2017])
		end	
	end

	def processos_baixados
		conn = BigDB.connection
		@column_key = params[:column_key]
		@ano = params[:ano]
		@consulta_lista_processos = conn.select_all  "select pedi_num_ano, ORJU_BSQ_CHAVE_UNIDADE, orju_dsc_unidade, PROC_DSC_PROCESSO_FORMATADO, SIPR_DSC_SITUACAO_PROCESSO, PROC_DAT_PROTOCOLO from dwfcb.pf_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia join dwfcb.pd_proc_processo proc on proc.proc_seq_chave =  prtc.proc_seq_chave join dwfcb.pd_sipr_situacao_processo sit on sit.sipr_seq_chave  = prtc.sipr_seq_chave	 where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (#{@ano}) and orju_bsq_chave_unidade like '#{@column_key}' and PRTC_QTD_BAIXADO_CONHECIMENTO = 1"
		render :json => {array: @consulta_lista_processos}
	end

end
