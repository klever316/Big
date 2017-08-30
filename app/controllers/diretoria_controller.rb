class DiretoriaController < ApplicationController
	
  def taxa
  	#conexão com o banco
		conn = BigDB.connection

		@total_julgados = conn.select_all "select sum(prtc_qtd_julgado_conhecimento) qtd_julgado_conhecimento FROM dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia WHERE orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017)"
		@total_pendentes = conn.select_all "select sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh FROM dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju ON orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia WHERE orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) AND pedi_num_mes IN (To_Char(SYSDATE,'MM')-1)"
		@total_baixados = conn.select_all "select sum(prtc_qtd_baixado_conhecimento) qtd_baixado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017)"

		#Julgados 2017
		consulta_taxa_2017 = conn.select_all "SELECT pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 taxa from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (2017) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai ORDER BY 1,2"
		@taxa_congestionamento_2017 = "["
		consulta_taxa_2017.each_with_index do |row, i|
			if(i != consulta_taxa_2017.length-1)
				@taxa_congestionamento_2017 += row["taxa"].to_s + ", "
			else
				@taxa_congestionamento_2017 += row["taxa"].to_s
			end
		end
		@taxa_congestionamento_2017 += "]"

		#Julgados 2016
		consulta_taxa_2016 = conn.select_all "SELECT pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 taxa from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (2016) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai ORDER BY 1,2"
		@teste_taxa = consulta_taxa_2016
		@taxa_congestionamento_2016 = "["
		consulta_taxa_2016.each_with_index do |row, i|
			if(i != consulta_taxa_2016.length-1)
				@taxa_congestionamento_2016 += row["taxa"].to_s + ", "
			else
				@taxa_congestionamento_2016 += row["taxa"].to_s
			end
		end
		@taxa_congestionamento_2016 += "]"

		#Julgados 2015
		consulta_taxa_2015 = conn.select_all "SELECT pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 taxa from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (2015) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai ORDER BY 1,2"
		@taxa_congestionamento_2015 = "["
		consulta_taxa_2015.each_with_index do |row, i|
			if(i != consulta_taxa_2015.length-1)
				@taxa_congestionamento_2015 += row["taxa"].to_s + ", "
			else
				@taxa_congestionamento_2015 += row["taxa"].to_s
			end
		end
		@taxa_congestionamento_2015 += "]"

  end

  def julgados
  	#conexão com o banco
		conn = BigDB.connection

		#Julgados 2017
		consulta_julgados_2017 = conn.select_all "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_julgado_conhecimento) qtd_julgado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes,  orju_dsc_unidade_pai  ORDER BY 1,2"
		@processos_julgados_2017 = "["
		consulta_julgados_2017.each_with_index do |row, i|
			if(i != consulta_julgados_2017.length-1)
				@processos_julgados_2017 += row["qtd_julgado_conhecimento"].to_s + ", "
			else
				@processos_julgados_2017 += row["qtd_julgado_conhecimento"].to_s
			end
		end
		@processos_julgados_2017 += "]"

		#Julgados 2016
		consulta_julgados_2016 = conn.select_all "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_julgado_conhecimento) qtd_julgado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2016) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes,  orju_dsc_unidade_pai  ORDER BY 1,2"
		@processos_julgados_2016 = "["
		consulta_julgados_2016.each_with_index do |row, i|
			if(i != consulta_julgados_2016.length-1)
				@processos_julgados_2016 += row["qtd_julgado_conhecimento"].to_s + ", "
			else
				@processos_julgados_2016 += row["qtd_julgado_conhecimento"].to_s
			end
		end
		@processos_julgados_2016 += "]"

		#Julgados 2015
		consulta_julgados_2015 = conn.select_all "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_julgado_conhecimento) qtd_julgado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2015) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes,  orju_dsc_unidade_pai  ORDER BY 1,2"
		@processos_julgados_2015 = "["
		consulta_julgados_2015.each_with_index do |row, i|
			if(i != consulta_julgados_2015.length-1)
				@processos_julgados_2015 += row["qtd_julgado_conhecimento"].to_s + ", "
			else
				@processos_julgados_2015 += row["qtd_julgado_conhecimento"].to_s
			end
		end
		@processos_julgados_2015 += "]"
  end

  def pendentes
  	#conexão com o banco
		conn = BigDB.connection

		#Pendentes 2017
		consulta_pendentes_2017 = conn.select_all "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"
		@testependentes = consulta_pendentes_2017
		@processos_pendentes_2017 = "["
		consulta_pendentes_2017.each_with_index do |row, i|
			if(i != consulta_pendentes_2017.length-1)
				@processos_pendentes_2017 += row["qtd_pendente_baixa_conh"].to_s + ", "
			else
				@processos_pendentes_2017 += row["qtd_pendente_baixa_conh"].to_s
			end
		end
		@processos_pendentes_2017 += "]"

		#Pendentes 2016
		consulta_pendentes_2016 = conn.select_all "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2016) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"
		@processos_pendentes_2016 = "["
		consulta_pendentes_2016.each_with_index do |row, i|
			if(i != consulta_pendentes_2016.length-1)
				@processos_pendentes_2016 += row["qtd_pendente_baixa_conh"].to_s + ", "
			else
				@processos_pendentes_2016 += row["qtd_pendente_baixa_conh"].to_s
			end
		end
		@processos_pendentes_2016 += "]"

		#Pendentes 2015
		consulta_pendentes_2015 = conn.select_all "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2015) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"
		@processos_pendentes_2015 = "["
		consulta_pendentes_2015.each_with_index do |row, i|
			if(i != consulta_pendentes_2015.length-1)
				@processos_pendentes_2015 += row["qtd_pendente_baixa_conh"].to_s + ", "
			else
				@processos_pendentes_2015 += row["qtd_pendente_baixa_conh"].to_s
			end
		end
		@processos_pendentes_2015 += "]"
  end

  def baixados
  	#conexão com o banco
  	conn = BigDB.connection

		#Baixados 2017
		consulta_baixados_2017 = conn.select_all "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_baixado_conhecimento) qtd_baixado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"
		@testebaixados = consulta_baixados_2017
		@processos_baixados_2017 = "["
		consulta_baixados_2017.each_with_index do |row, i|
			if(i != consulta_baixados_2017.length-1)
				@processos_baixados_2017 += row["qtd_baixado_conhecimento"].to_s + ", "
			else
				@processos_baixados_2017 += row["qtd_baixado_conhecimento"].to_s
			end
		end
		@processos_baixados_2017 += "]"

		#Baixados 2016
		consulta_baixados_2016 = conn.select_all "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_baixado_conhecimento) qtd_baixado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2016) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"
		@processos_baixados_2016 = "["
		consulta_baixados_2016.each_with_index do |row, i|
			if(i != consulta_baixados_2016.length-1)
				@processos_baixados_2016 += row["qtd_baixado_conhecimento"].to_s + ", "
			else
				@processos_baixados_2016 += row["qtd_baixado_conhecimento"].to_s
			end
		end
		@processos_baixados_2016 += "]"

		#Baixados 2015
		consulta_baixados_2015 = conn.select_all "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_baixado_conhecimento) qtd_baixado_conhecimento from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2015) group BY pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"
		@processos_baixados_2015 = "["
		consulta_baixados_2015.each_with_index do |row, i|
			if(i != consulta_baixados_2015.length-1)
				@processos_baixados_2015 += row["qtd_baixado_conhecimento"].to_s + ", "
			else
				@processos_baixados_2015 += row["qtd_baixado_conhecimento"].to_s
			end
		end
		@processos_baixados_2015 += "]"
  end
  
end
