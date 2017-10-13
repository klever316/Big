class ProcessosJulgados

	def get_processos_julgados_por_competencia(ano)

		conn = BigDB.connection
		@@consulta_julgados_por_competencia ||= conn.select_all "select pedi_num_ano, ORJU_DSC_UNIDADE, sum(prtc_qtd_julgado_conhecimento) as julgados from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (#{ano.join(',')}) group by pedi_num_ano, orju_dsc_unidade_pai, ORJU_DSC_UNIDADE ORDER BY 1,2"
		@competencias = Array.new
		@total_competencias = Hash.new
		@total_competencias = {total_familia: 0,total_juri: 0, total_criminal: 0, total_civel: 0, total_fazenda: 0,
			total_infancia: 0, total_execucoes_penais: 0, total_execucoes_fiscais: 0, total_falencia: 0,
			total_registros_publicos: 0, total_sucessoes: 0, total_toxico: 0, total_auditoria_militar: 0, total_penas_alternativas: 0, total_transito: 0}
			ano.each do |a|
				@@consulta_julgados_por_competencia.each_with_index do |row, i|
					if(a == row["pedi_num_ano"])
						if row["orju_dsc_unidade"].to_s.include? "VARA DE FAMILIA DA COMARCA DE FORTALEZA"
							@total_competencias[:total_familia] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DO JURI DA COMARCA"
							@total_competencias[:total_juri] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA CRIMINAL DA COMARCA DE FORTALEZA"
							@total_competencias[:total_criminal] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA CIVEL DA COMARCA DE FORTALEZA"
							@total_competencias[:total_civel] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DA FAZENDA PUBLICA DA COMARCA DE FORTALEZA"
							@total_competencias[:total_fazenda] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DA INFANCIA E JUVENTUDE DA COMARCA DE FORTALEZA"
							@total_competencias[:total_infancia] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUC?O PENAL DA COMARCA DE FORTALEZA"
							@total_competencias[:total_execucoes_penais] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUC?ES FISCAIS E DE CRIMES CONTRA A ORDEM TRIBUTARIA DA COMARCA DE FORTALEZA"
							@total_competencias[:total_execucoes_fiscais] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE RECUPERAC?O DE EMPRESAS E FALENCIAS"
							@total_competencias[:total_falencia] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE REGISTROS PUBLICOS DA COMARCA DE FORTALEZA"
							@total_competencias[:total_registros_publicos] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE SUCESS?ES DA COMARCA DE FORTALEZA"
							@total_competencias[:total_sucessoes] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DELITOS/TRAFICO SUBST. ENTORPECENTES COMARCA DE FORTALEZA"
							@total_competencias[:total_toxico] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DA AUDITORIA MILITAR DA COMARCA DE FORTALEZA"
							@total_competencias[:total_auditoria_militar] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUC?ES DE PENAS ALTERNATIVAS DE FORTALEZA"
							@total_competencias[:total_penas_alternativas] += row["julgados"]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA UNICA DE TRANSITO DA COMARCA DE FORTALEZA"
							@total_competencias[:total_transito] += row["julgados"]
						end
					end
				end
				@competencias += [{
					name: "#{a}", data: 
					[
						{name: "Família", y: @total_competencias[:total_familia], drilldown: "familia_#{a}"},
						{name: "Cível", y: @total_competencias[:total_civel], drilldown: "civel_#{a}"},
						{name: "Criminal", y: @total_competencias[:total_criminal], drilldown: "criminal_#{a}"},
						{name: "Fazenda Pública", y: @total_competencias[:total_fazenda], drilldown: "fazenda_#{a}"},
						{name: "Júri", y: @total_competencias[:total_juri], drilldown: "juri_#{a}"},
						{name: "Infância e Juventude", y: @total_competencias[:total_infancia], drilldown: "infancia_#{a}"},
						{name: "Sucessões", y: @total_competencias[:total_sucessoes], drilldown: "sucessoes_#{a}"},
						{name: "Execuções Penais", y: @total_competencias[:total_execucoes_penais], drilldown: "execucoespenais_#{a}"},
						{name: "Execuções Fiscais", y: @total_competencias[:total_execucoes_fiscais], drilldown: "execucoesfiscais_#{a}"},
						{name: "Falências", y: @total_competencias[:total_falencia], drilldown: "falencia_#{a}"},
						{name: "Registros Públicos", y: @total_competencias[:total_registros_publicos], drilldown: "registrospublicos_#{a}"},
						{name: "Tóxico", y: @total_competencias[:total_toxico], drilldown: "toxico_#{a}"},
						{name: "Auditoria Militar", y: @total_competencias[:total_auditoria_militar], drilldown: "auditoriamiliar_#{a}"},
						{name: "Penas Alternativas", y: @total_competencias[:total_penas_alternativas], drilldown: "penasalternativas_#{a}"},
						{name: "Trânsito", y: @total_competencias[:total_transito], drilldown: "transito_#{a}"}
					]
					}]
					@total_competencias = {total_familia: 0,total_juri: 0, total_criminal: 0, total_civel: 0, total_fazenda: 0,
						total_infancia: 0, total_execucoes_penais: 0, total_execucoes_fiscais: 0, total_falencia: 0,
						total_registros_publicos: 0, total_sucessoes: 0, total_toxico: 0, total_auditoria_militar: 0, total_penas_alternativas: 0, total_transito: 0}
					end

					@competencias
				end

			end