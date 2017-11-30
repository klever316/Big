class ProcessosPendentes

	def self.get_processos_pendentes_por_competencia(vara,ano)

		conn = BigDB.connection
		@@consulta_pendentes_por_competencia ||= conn.select_all "select pedi_num_ano, orju_dsc_unidade_pai, orju_bsq_chave_unidade, ORJU_DSC_UNIDADE, sum(prtc_qtd_pendente_baixa_conh) as pendentes from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (#{ano.join(',')}) AND pedi_num_mes IN (To_Char(SYSDATE,'MM')-1) group by pedi_num_ano, orju_dsc_unidade_pai, orju_bsq_chave_unidade, ORJU_DSC_UNIDADE order by 1, 2"
		@competencias = Array.new
		@total_competencias = Hash.new
		#Pegar o Valor Total de Processos julgados por competências e armazena no Hash abaixo
		@total_competencias = {total_familia: 0,
								total_juri: 0,
								total_criminal: 0,
								total_civel: 0,
								total_fazenda: 0,
								total_infancia: 0,
								total_execucoes_penais: 0,
								total_execucoes_fiscais: 0,
								total_falencia: 0,
								total_registros_publicos: 0,
								total_sucessoes: 0,
								total_toxico: 0,
								total_auditoria_militar: 0,
								total_penas_alternativas: 0,
								total_transito: 0}

		#Pega os valores por vara e armazena nos respectivos arrays abaixo
		@varas_familia = Array.new
		@varas_criminais = Array.new
		@varas_civeis = Array.new
		@varas_fazenda = Array.new
		@varas_juri = Array.new
		@varas_infancia = Array.new
		@varas_sucessoes = Array.new
		@varas_execucoes_penais = Array.new
		@varas_execucoes_fiscais = Array.new
		@varas_falencia = Array.new
		@varas_registros_publicos = Array.new
		@varas_toxico = Array.new
		#Pega os Valores dos Arrays das varas e armazena no Array Abaixo
		@varas = Array.new
		@count_insercao = 0

		ano.each do |a|
			@@consulta_pendentes_por_competencia.each_with_index do |row, i|
				if(a == row["pedi_num_ano"])
					if row["orju_dsc_unidade"].to_s.include? "VARA DE FAMILIA DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_familia] += row["pendentes"]
						@varas_familia += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DO JURI DA COMARCA"
						if !row["orju_dsc_unidade"].to_s.include? "6ª VARA DO JURI"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")								
							@total_competencias[:total_juri] += row["pendentes"]
							@varas_juri += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
						end
					elsif row["orju_dsc_unidade"].to_s.include? "VARA CRIMINAL DA COMARCA DE FORTALEZA"
						if !row["orju_dsc_unidade"].to_s.include? "19ª VARA CRIMINAL DA COMARCA DE FORTALEZA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_criminal] += row["pendentes"]
							@varas_criminais += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
						end
					elsif row["orju_dsc_unidade"].to_s.include? "VARA CÍVEL DA COMARCA DE FORTALEZA"
						if !row["orju_dsc_unidade"].to_s.include? "VARA CÍVEL DA COMARCA DE FORTALEZA-INATIVA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_civel] += row["pendentes"]
							@varas_civeis += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
						end
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DA FAZENDA PÚBLICA DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_fazenda] += row["pendentes"]
						@varas_fazenda += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DA INFÂNCIA E JUVENTUDE DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_infancia] += row["pendentes"]
						@varas_infancia += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUÇÃO PENAL DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_execucoes_penais] += row["pendentes"]
						@varas_execucoes_penais += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUÇÕES FISCAIS E DE CRIMES CONTRA A ORDEM TRIBUTÁRIA DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_execucoes_fiscais] += row["pendentes"]
						@varas_execucoes_fiscais += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE RECUPERAÇÃO DE EMPRESAS E FALÊNCIAS"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_falencia] += row["pendentes"]
						@varas_falencia += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE REGISTROS PÚBLICOS DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_registros_publicos] += row["pendentes"]
						@varas_registros_publicos += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE SUCESSÕES DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_sucessoes] += row["pendentes"]
						@varas_sucessoes += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DELITOS/TRAFICO SUBST. ENTORPECENTES COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_toxico] += row["pendentes"]
						@varas_toxico += [{ name: "#{x}", y: row['pendentes'], key: "#{row["orju_bsq_chave_unidade"]}"}]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DA AUDITORIA MILITAR DA COMARCA DE FORTALEZA"
						@total_competencias[:total_auditoria_militar] += row["pendentes"]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUÇÕES DE PENAS ALTERNATIVAS DE FORTALEZA"
						@total_competencias[:total_penas_alternativas] += row["pendentes"]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA ÚNICA DE TRÂNSITO DA COMARCA DE FORTALEZA"
						@total_competencias[:total_transito] += row["pendentes"]
					end
				end
			end
			@varas_criminais.insert(9, @varas_criminais.delete_at(0))
			@varas_civeis.insert(10, @varas_civeis.delete_at(0))
			@varas_civeis.insert(21, @varas_civeis.delete_at(0))
			@varas_civeis.insert(0, @varas_civeis.delete_at(9))
			@varas_civeis.insert(1, @varas_civeis.delete_at(21))
			@varas_civeis.insert(30, @varas_civeis.delete_at(37))
			@varas_civeis.insert(31, @varas_civeis.delete_at(38))
			@varas_fazenda.insert(1, @varas_fazenda.delete_at(0))
			@varas_fazenda.insert(10,@varas_fazenda.delete_at(14))

			@varas += [{name: "#{a}", id: "familia_#{a}", data: @varas_familia},
						{name: "#{a}", id: "criminal_#{a}", data: @varas_criminais},
						{name: "#{a}", id: "civel_#{a}", data: @varas_civeis},
						{name: "#{a}", id: "fazenda_#{a}", data: @varas_fazenda},
						{name: "#{a}", id: "juri_#{a}", data: @varas_juri},
						{name: "#{a}", id: "infancia_#{a}", data: @varas_infancia},
						{name: "#{a}", id: "sucessoes_#{a}", data: @varas_sucessoes},
						{name: "#{a}", id: "execucoespenais_#{a}", data: @varas_execucoes_penais},
						{name: "#{a}", id: "execucoesfiscais_#{a}", data: @varas_execucoes_fiscais}, 
						{name: "#{a}", id: "falencia_#{a}", data: @varas_falencia},
						{name: "#{a}", id: "registrospublicos_#{a}", data: @varas_registros_publicos},
						{name: "#{a}", id: "toxico_#{a}", data: @varas_toxico}]

				if(@count_insercao==0)
					@competencias += [{
					name: "#{a}", data: Array.new, color: "#8CD19E"
					}]
				elsif(@count_insercao==1) 
					@competencias += [{
					name: "#{a}", data: Array.new, color: "#8dd7e0"
					}]
				elsif(@count_insercao==2) 
					@competencias += [{
					name: "#{a}", data: Array.new, color: "#db6a29"
					}]
				end
				
				@competencias[@count_insercao][:data] << {name: "Família", y: @total_competencias[:total_familia], drilldown: "familia_#{a}"} if vara.include? "familia"
				@competencias[@count_insercao][:data] << {name: "Cível", y: @total_competencias[:total_civel], drilldown: "civel_#{a}"} if vara.include? "civel"
				@competencias[@count_insercao][:data] << {name: "Criminal", y: @total_competencias[:total_criminal], drilldown: "criminal_#{a}"} if vara.include? "criminal"
				@competencias[@count_insercao][:data] << {name: "Fazenda Pública", y: @total_competencias[:total_fazenda], drilldown: "fazenda_#{a}"} if vara.include? "fazenda_publica"
				@competencias[@count_insercao][:data] << {name: "Júri", y: @total_competencias[:total_juri], drilldown: "juri_#{a}"} if vara.include? "juri"
				@competencias[@count_insercao][:data] << {name: "Infância e Juventude", y: @total_competencias[:total_infancia], drilldown: "infancia_#{a}"} if vara.include? "infancia"
				@competencias[@count_insercao][:data] << {name: "Sucessões", y: @total_competencias[:total_sucessoes], drilldown: "sucessoes_#{a}"} if vara.include? "sucessoes"
				@competencias[@count_insercao][:data] << {name: "Execuções Penais", y: @total_competencias[:total_execucoes_penais], drilldown: "execucoespenais_#{a}"} if vara.include? "exec_penais"
				@competencias[@count_insercao][:data] << {name: "Execuções Fiscais", y: @total_competencias[:total_execucoes_fiscais], drilldown: "execucoesfiscais_#{a}"} if vara.include? "exec_fiscais"
				@competencias[@count_insercao][:data] << {name: "Falências", y: @total_competencias[:total_falencia], drilldown: "falencia_#{a}"} if vara.include? "falencia"
				@competencias[@count_insercao][:data] << {name: "Registros Públicos", y: @total_competencias[:total_registros_publicos], drilldown: "registrospublicos_#{a}"} if vara.include? "registros_publicos"
				@competencias[@count_insercao][:data] << {name: "Tóxico", y: @total_competencias[:total_toxico], drilldown: "toxico_#{a}"} if vara.include? "toxico"
				@competencias[@count_insercao][:data] << {name: "Auditoria Militar", y: @total_competencias[:total_auditoria_militar], drilldown: "auditoriamiliar_#{a}", key: "603"} if vara.include? "auditoria_militar"
				@competencias[@count_insercao][:data] << {name: "Penas Alternativas", y: @total_competencias[:total_penas_alternativas], drilldown: "penasalternativas_#{a}", key: "6535"} if vara.include? "penas_alternativas"
				@competencias[@count_insercao][:data] << {name: "Trânsito", y: @total_competencias[:total_transito], drilldown: "transito_#{a}", key: "8360"} if vara.include? "transito"
				@count_insercao += 1
				
				@varas_familia = []
				@varas_criminais = []
				@varas_civeis = []
				@varas_fazenda = []
				@varas_juri = []
				@varas_infancia = []
				@varas_sucessoes = []
				@varas_execucoes_penais = []
				@varas_execucoes_fiscais = []
				@varas_falencia = []
				@varas_registros_publicos = []
				@varas_toxico = []
				@total_competencias = {total_familia: 0,
										total_juri: 0,
										total_criminal: 0,
										total_civel: 0,
										total_fazenda: 0,
										total_infancia: 0,
										total_execucoes_penais: 0,
										total_execucoes_fiscais: 0,
										total_falencia: 0,
										total_registros_publicos: 0,
										total_sucessoes: 0,
										total_toxico: 0,
										total_auditoria_militar: 0,
										total_penas_alternativas: 0,
										total_transito: 0}
		end
		return @competencias, @varas
	end
	def self.get_processos_pendentes(ano)
		conn = BigDB.connection
		@@consulta_pendentes ||= conn.select_all "select pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai, sum(prtc_qtd_pendente_baixa_conh) qtd_pendente_baixa_conh from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (#{ano.join(',')}) group by pedi_num_ano, pedi_num_mes, pedi_dsc_mes, orju_dsc_unidade_pai order by 1, 2"

		@processos_pendentes = Hash.new
		@processos_pendentes_ano = Array.new
		ano.each do |a|
			@@consulta_pendentes.each_with_index do |row,i|
				if(a==row["pedi_num_ano"])
					@processos_pendentes_ano << row["qtd_pendente_baixa_conh"].to_i
				end
			end
			@processos_pendentes["#{a}"] = @processos_pendentes_ano
			@processos_pendentes_ano = []
		end
		return @processos_pendentes
	end

end