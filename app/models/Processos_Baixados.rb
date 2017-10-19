class ProcessosBaixados

	def self.get_processos_baixados_por_competencia(vara, ano)

		conn = BigDB.connection
		@@consulta_baixados_por_competencia ||= conn.select_all "select pedi_num_ano, ORJU_DSC_UNIDADE, sum(prtc_qtd_baixado_conhecimento) as baixados from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (#{ano.join(',')}) group by pedi_num_ano, orju_dsc_unidade_pai, ORJU_DSC_UNIDADE ORDER BY 1,2"
		@competencias = Array.new
		@total_competencias = Hash.new
		#Pegar o Valor Total de Processos Baixados por competências e armazena no Hash abaixo
		@total_competencias = { total_familia: 0,
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
								total_transito: 0 }
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
			@@consulta_baixados_por_competencia.each_with_index do |row, i|
				if(a == row["pedi_num_ano"])
					if row["orju_dsc_unidade"].to_s.include? "VARA DE FAMILIA DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_familia] += row["baixados"]
						@varas_familia += [["#{x}".gsub!("?","ª"),row['baixados']]]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DO JURI DA COMARCA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						if !row["orju_dsc_unidade"].to_s.include? "6? VARA DO JURI"
							@total_competencias[:total_juri] += row["baixados"]
							@varas_juri += [["#{x}".gsub!("?","ª"),row['baixados']]]
						end
					elsif row["orju_dsc_unidade"].to_s.include? "VARA CRIMINAL DA COMARCA DE FORTALEZA"
						if !row["orju_dsc_unidade"].to_s.include? "19? VARA CRIMINAL DA COMARCA DE FORTALEZA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_criminal] += row["baixados"]
							@varas_criminais += [["#{x}".gsub!("?","ª"),row['baixados']]]
						end
					elsif row["orju_dsc_unidade"].to_s.include? "VARA CIVEL DA COMARCA DE FORTALEZA"
						if !row["orju_dsc_unidade"].to_s.include? "VARA CIVEL DA COMARCA DE FORTALEZA-INATIVA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_civel] += row["baixados"]
							@varas_civeis += [["#{x}".gsub!("?","ª"),row['baixados']]]
						end
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DA FAZENDA PUBLICA DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_fazenda] += row["baixados"]
						@varas_fazenda += [["#{x}".gsub!("?","ª"),row['baixados']]]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DA INFANCIA E JUVENTUDE DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_infancia] += row["baixados"]
						@varas_infancia += [["#{x}".gsub!("?","ª"),row['baixados']]]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUC?O PENAL DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						x.sub!("?","ª")
						@total_competencias[:total_execucoes_penais] += row["baixados"]
						@varas_execucoes_penais += [["#{x}".sub!("?","Ã"),row['baixados']]]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUC?ES FISCAIS E DE CRIMES CONTRA A ORDEM TRIBUTARIA DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						x.sub!("?","ª")
						@total_competencias[:total_execucoes_fiscais] += row["baixados"]
						@varas_execucoes_fiscais += [["#{x}".sub!("?","Õ"),row['baixados']]]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE RECUPERAC?O DE EMPRESAS E FALENCIAS"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						x.sub!("?","ª")
						@total_competencias[:total_falencia] += row["baixados"]
						@varas_falencia += [["#{x}".sub!("?","Ã"),row['baixados']]]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE REGISTROS PUBLICOS DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_registros_publicos] += row["baixados"]
						@varas_registros_publicos += [["#{x}".gsub!("?","ª"),row['baixados']]]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE SUCESS?ES DA COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						x.sub!("?","ª")
						@total_competencias[:total_sucessoes] += row["baixados"]
						@varas_sucessoes += [["#{x}".sub!("?","Õ"),row['baixados']]]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DELITOS/TRAFICO SUBST. ENTORPECENTES COMARCA DE FORTALEZA"
						x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
						@total_competencias[:total_toxico] += row["baixados"]
						@varas_toxico += [["#{x}".gsub!("?","ª"),row['baixados']]]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DA AUDITORIA MILITAR DA COMARCA DE FORTALEZA"
						@total_competencias[:total_auditoria_militar] += row["baixados"]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUC?ES DE PENAS ALTERNATIVAS DE FORTALEZA"
						@total_competencias[:total_penas_alternativas] += row["baixados"]
					elsif row["orju_dsc_unidade"].to_s.include? "VARA UNICA DE TRANSITO DA COMARCA DE FORTALEZA"
						@total_competencias[:total_transito] += row["baixados"]
					end
				end
			end
			@varas_familia.push(@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift)
			@varas_civeis.push(@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2))
			@varas_criminais.push(@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift)
			@varas_fazenda.push(@varas_fazenda.shift,@varas_fazenda.shift,@varas_fazenda.shift,@varas_fazenda.shift,@varas_fazenda.shift,@varas_fazenda.shift)

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
			 @competencias += [{
			 		name: "#{a}", data: Array.new
			 		}]
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
					@competencias[@count_insercao][:data] << {name: "Auditoria Militar", y: @total_competencias[:total_auditoria_militar], drilldown: "auditoriamiliar_#{a}"} if vara.include? "auditoria_militar"
					@competencias[@count_insercao][:data] << {name: "Penas Alternativas", y: @total_competencias[:total_penas_alternativas], drilldown: "penasalternativas_#{a}"} if vara.include? "penas_alternativas"
					@competencias[@count_insercao][:data] << {name: "Trânsito", y: @total_competencias[:total_transito], drilldown: "transito_#{a}"} if vara.include? "transito"
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
		end		
