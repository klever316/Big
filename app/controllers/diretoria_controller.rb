class DiretoriaController < ApplicationController
  def taxa
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
  end

  def baixados
  end
  
end
