class ProcessosTaxa

	def self.get_processos_taxa_por_competencia(vara, ano)

		conn = BigDB.connection
		@@consulta_taxa_por_competencia ||= conn.select_all "SELECT pedi_num_ano, ORJU_DSC_UNIDADE, (sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento))*100 as taxa from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') and (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0 AND pedi_num_ano IN (#{ano.join(',')}) group BY pedi_num_ano, orju_dsc_unidade_pai, ORJU_DSC_UNIDADE ORDER BY 1,2"
		@competencias = Array.new
		@total_competencias = Hash.new
		@count_competencias = Hash.new
		#Pegar o Valor Total de Processos julgados por competências e armazena no Hash abaixo
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
		#Armazena o total de Varas
		@count_competencias = { count_familia: 0,
								count_juri: 0,
								count_criminal: 0,
								count_civel: 0,
								count_fazenda: 0,
								count_infancia: 0,
								count_execucoes_penais: 0,
								count_execucoes_fiscais: 0,
								count_falencia: 0,
								count_registros_publicos: 0,
								count_sucessoes: 0,
								count_toxico: 0,
								count_auditoria_militar: 0,
								count_penas_alternativas: 0,
								count_transito: 0 }
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
				@@consulta_taxa_por_competencia.each_with_index do |row, i|
					if(a == row["pedi_num_ano"])
						if row["orju_dsc_unidade"].to_s.include? "VARA DE FAMILIA DA COMARCA DE FORTALEZA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_familia] += row["taxa"].to_f
							@count_competencias[:count_familia] += 1
							@varas_familia += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DO JURI DA COMARCA"
							if !row["orju_dsc_unidade"].to_s.include? "6ª VARA DO JURI"
								x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
								@total_competencias[:total_juri] += row["taxa"].to_f
								@count_competencias[:count_juri] += 1
								@varas_juri += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
							end	
						elsif row["orju_dsc_unidade"].to_s.include? "VARA CRIMINAL DA COMARCA DE FORTALEZA"
							if !row["orju_dsc_unidade"].to_s.include? "19ª VARA CRIMINAL DA COMARCA DE FORTALEZA"
								x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
								@total_competencias[:total_criminal] += row["taxa"].to_f
								@count_competencias[:count_criminal] += 1
								@varas_criminais += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
							end	
						elsif row["orju_dsc_unidade"].to_s.include? "VARA CÍVEL DA COMARCA DE FORTALEZA"
							if !row["orju_dsc_unidade"].to_s.include? "VARA CÍVEL DA COMARCA DE FORTALEZA-INATIVA"
								x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
								@total_competencias[:total_civel] += row["taxa"].to_f
								@count_competencias[:count_civel] += 1
								@varas_civeis += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
							end
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DA FAZENDA PÚBLICA DA COMARCA DE FORTALEZA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_fazenda] += row["taxa"].to_f
							@count_competencias[:count_fazenda] += 1
							@varas_fazenda += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DA INFÂNCIA E JUVENTUDE DA COMARCA DE FORTALEZA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_infancia] += row["taxa"].to_f
							@count_competencias[:count_infancia] += 1
							@varas_infancia += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUÇÃO PENAL DA COMARCA DE FORTALEZA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_execucoes_penais] += row["taxa"].to_f
							@count_competencias[:count_execucoes_penais] += 1
							@varas_execucoes_penais += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUÇÕES FISCAIS E DE CRIMES CONTRA A ORDEM TRIBUTÁRIA DA COMARCA DE FORTALEZA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_execucoes_fiscais] += row["taxa"].to_f
							@count_competencias[:count_execucoes_fiscais] += 1
							@varas_execucoes_fiscais += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE RECUPERAÇÃO DE EMPRESAS E FALÊNCIAS"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_falencia] += row["taxa"].to_f
							@count_competencias[:count_falencia] += 1
							@varas_falencia += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE REGISTROS PÚBLICOS DA COMARCA DE FORTALEZA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_registros_publicos] += row["taxa"].to_f
							@count_competencias[:count_registros_publicos] += 1
							@varas_registros_publicos += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE SUCESSÕES DA COMARCA DE FORTALEZA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_sucessoes] += row["taxa"].to_f
							@count_competencias[:count_sucessoes] += 1
							@varas_sucessoes += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DELITOS/TRAFICO SUBST. ENTORPECENTES COMARCA DE FORTALEZA"
							x = row["orju_dsc_unidade"].gsub(" DA COMARCA DE FORTALEZA", "")
							@total_competencias[:total_toxico] += row["taxa"].to_f
							@count_competencias[:count_toxico] += 1
							@varas_toxico += [{name: "#{x}", y: row['taxa'].to_f, key: "#{row["orju_dsc_unidade"]}"}]
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DA AUDITORIA MILITAR DA COMARCA DE FORTALEZA"
							@total_competencias[:total_auditoria_militar] += row["taxa"].to_f
							@count_competencias[:count_auditoria_militar] += 1
						elsif row["orju_dsc_unidade"].to_s.include? "VARA DE EXECUÇÕES DE PENAS ALTERNATIVAS DE FORTALEZA"
							@total_competencias[:total_penas_alternativas] += row["taxa"].to_f
							@count_competencias[:count_penas_alternativas] += 1
						elsif row["orju_dsc_unidade"].to_s.include? "VARA ÚNICA DE TRÂNSITO DA COMARCA DE FORTALEZA"
							@total_competencias[:total_transito] += row["taxa"].to_f
							@count_competencias[:count_transito] += 1
						end
					end
				end

				@varas_familia.push(@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift,@varas_familia.shift)
				@varas_civeis.push(@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(0),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(1),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2),@varas_civeis.delete_at(2))
				@varas_fazenda.push(@varas_fazenda.shift,@varas_fazenda.shift,@varas_fazenda.shift,@varas_fazenda.shift,@varas_fazenda.shift,@varas_fazenda.shift)
				@varas_criminais.push(@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift,@varas_criminais.shift)
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
				@total_competencias[:total_familia] = @total_competencias[:total_familia]/@count_competencias[:count_familia]
				@total_competencias[:total_juri] = @total_competencias[:total_juri]/@count_competencias[:count_juri]
				@total_competencias[:total_criminal] = @total_competencias[:total_criminal]/@count_competencias[:count_criminal]
				@total_competencias[:total_civel] = @total_competencias[:total_civel]/@count_competencias[:count_civel]
				@total_competencias[:total_fazenda] = @total_competencias[:total_fazenda]/@count_competencias[:count_fazenda]
				@total_competencias[:total_infancia] = @total_competencias[:total_infancia]/@count_competencias[:count_infancia]
				@total_competencias[:total_execucoes_penais] = @total_competencias[:total_execucoes_penais]/@count_competencias[:count_execucoes_penais]
				@total_competencias[:total_execucoes_fiscais] = @total_competencias[:total_execucoes_fiscais]/@count_competencias[:count_execucoes_fiscais]
				@total_competencias[:total_falencia] = @total_competencias[:total_falencia]/@count_competencias[:count_falencia]
				@total_competencias[:total_registros_publicos] = @total_competencias[:total_registros_publicos]/@count_competencias[:count_registros_publicos]
				@total_competencias[:total_sucessoes] = @total_competencias[:total_sucessoes]/@count_competencias[:count_sucessoes]
				@total_competencias[:total_toxico] = @total_competencias[:total_toxico]/@count_competencias[:count_toxico]
				@total_competencias[:total_auditoria_militar] = @total_competencias[:total_auditoria_militar]/@count_competencias[:count_auditoria_militar]
				@total_competencias[:total_penas_alternativas] = @total_competencias[:total_penas_alternativas]/@count_competencias[:count_penas_alternativas]
				@total_competencias[:total_transito] = @total_competencias[:total_transito]/@count_competencias[:count_transito]

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
					@competencias[@count_insercao][:data] << {name: "Auditoria Militar", y: @total_competencias[:total_auditoria_militar], drilldown: "auditoriamiliar_#{a}", key: "VARA DA AUDITORIA MILITAR DA COMARCA DE FORTALEZA"} if vara.include? "auditoria_militar"
					@competencias[@count_insercao][:data] << {name: "Penas Alternativas", y: @total_competencias[:total_penas_alternativas], drilldown: "penasalternativas_#{a}", key: "VARA DE EXECUÇÕES DE PENAS ALTERNATIVAS DE FORTALEZA"} if vara.include? "penas_alternativas"
					@competencias[@count_insercao][:data] << {name: "Trânsito", y: @total_competencias[:total_transito], drilldown: "transito_#{a}", key: "VARA ÚNICA DE TRÂNSITO DA COMARCA DE FORTALEZA"} if vara.include? "transito"
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
					@count_competencias = { count_familia: 0,
											count_juri: 0,
											count_criminal: 0,
											count_civel: 0,
											count_fazenda: 0,
											count_infancia: 0,
											count_execucoes_penais: 0,
											count_execucoes_fiscais: 0,
											count_falencia: 0,
											count_registros_publicos: 0,
											count_sucessoes: 0,
											count_toxico: 0,
											count_auditoria_militar: 0,
											count_penas_alternativas: 0,
											count_transito: 0 }
					end
					return @competencias, @varas
				end

	def self.taxaVara(cod, ano)
		conn = BigDB.connection
		@consulta_taxa_vara = conn.select_all "select pedi_seq_chave, pedi_num_ano, pedi_dsc_mes, orju_bsq_chave_unidade, orju_dsc_unidade, sum(prtc_qtd_pendente_baixa_conh) as pendentes, sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) as total,
       		sum(prtc_qtd_pendente_baixa_conh)/sum(prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) taxa
		from (select pdrf.pedi_seq_chave, pdrf.pedi_num_ano, pdrf.pedi_dsc_mes, orju.orju_dsc_segmento, 
             copr.copr_dsc_competencia, orju.orju_bsq_chave_unidade, orju.orju_dsc_unidade,
             sum(prtc.prtc_qtd_pendente_baixa_conh) prtc_qtd_pendente_baixa_conh,
             (select sum(prtc_qtd_julgado_conhecimento) 
              from dwfcb.pa_prtc_processo_taxa_cong ptc1
              where ptc1.copr_seq_chave = prtc.copr_seq_chave
                and ptc1.orju_seq_chave = prtc.orju_seq_chave
                and ptc1.pedi_seq_chave_referencia in (select pedi_seq_chave from dwfcb.cd_pedi_periodo_diario pdr1
                                                       where pdr1.pedi_num_ano = pdrf.pedi_num_ano
                                                         and pdr1.pedi_flg_mes_consolidado = '1'
                                                         and pdr1.pedi_seq_chave <= pdrf.pedi_seq_chave)) prtc_qtd_julgado_conhecimento, 
             (select sum(prtc_qtd_baixado_conhecimento) 
              from dwfcb.pa_prtc_processo_taxa_cong ptc1
              where ptc1.copr_seq_chave = prtc.copr_seq_chave
                and ptc1.orju_seq_chave = prtc.orju_seq_chave
                and ptc1.pedi_seq_chave_referencia in (select pedi_seq_chave from dwfcb.cd_pedi_periodo_diario pdr1
                                                       where pdr1.pedi_num_ano = pdrf.pedi_num_ano
                                                         and pdr1.pedi_flg_mes_consolidado = '1'
                                                         and pdr1.pedi_seq_chave <= pdrf.pedi_seq_chave)) prtc_qtd_baixado_conhecimento
      from dwfcb.pa_prtc_processo_taxa_cong prtc
           join dwfcb.pd_copr_competencia_processo copr on copr.copr_seq_chave = prtc.copr_seq_chave
           join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave
           join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia
      where prtc.pedi_seq_chave_referencia in (select pdr1.pedi_seq_chave from dwfcb.cd_pedi_periodo_diario pdr1
                                               where pdr1.pedi_flg_mes_consolidado = '1')
        and orju.orju_bsq_chave_segmento in ('1G', 'JFP')
        and orju.orju_bsq_chave_unidade = #{cod}
        and pedi_num_ano IN (#{ano.join(',')})
      group by pdrf.pedi_seq_chave, pdrf.pedi_bsq_chave, pdrf.pedi_num_ano, pdrf.pedi_num_ano, pdrf.pedi_dsc_mes, 
               prtc.copr_seq_chave, copr.copr_dsc_competencia, prtc.orju_seq_chave, 
               orju.orju_dsc_segmento, orju.orju_bsq_chave_unidade, orju.orju_dsc_unidade)
		where (prtc_qtd_pendente_baixa_conh + prtc_qtd_baixado_conhecimento) > 0
		group by pedi_seq_chave, orju_bsq_chave_unidade, orju_dsc_unidade, pedi_num_ano, pedi_dsc_mes
		order by 1, 2"
		@anoAtual = Array.new
		@anoPassado = Array.new
		@anoRetrasado = Array.new
		@consulta_taxa_vara.each do |row|
			if row["pedi_num_ano"] == ano[0]
				@anoAtual << row["taxa"].to_f * 100
			elsif row["pedi_num_ano"] == ano[1]
				@anoPassado << row["taxa"].to_f * 100
			elsif	row["pedi_num_ano"] == ano[2]
				@anoRetrasado << row["taxa"].to_f * 100
			end
		end
		@serie = [{
				name: ano[0],
				data: @anoAtual,
				color: '#8CD19E'
			},{
				name: ano[1],
				data: @anoPassado,
				color: '#8dd7e0'
			},{
				name: ano[2],
				data: @anoRetrasado,
				color: '#db6a29'
			}]
			return @serie, @consulta_taxa_vara
	end

	def self.get_total_novos
		conn = BigDB.connection
		@@total_novos = conn.select_all("SELECT Sum(6) as novos FROM (select pdrf.pedi_seq_chave, pdrf.pedi_sgl_mes_ano, orju.orju_dsc_segmento, orju.orju_bsq_chave_unidade, orju.orju_dsc_unidade, sum(prtc_qtd_pendente_baixa_conh) + sum(prtc_qtd_baixado_conhecimento) - nvl((select sum(prtc_qtd_pendente_baixa_conh) from dwfcb.pa_prtc_processo_taxa_cong prt1 where prt1.orju_seq_chave = prtc.orju_seq_chave and prt1.pedi_seq_chave_referencia = (select max(pdr1.pedi_seq_chave) from dwfcb.cd_pedi_periodo_diario pdr1 where pdr1.pedi_flg_mes_consolidado = '1' and pdr1.pedi_seq_chave < pdrf.pedi_seq_chave)), 0) prtc_qtd_novo_conh from dwfcb.pa_prtc_processo_taxa_cong prtc join dwfcb.pd_orju_orgao_julgador orju on orju.orju_seq_chave = prtc.orju_seq_chave join dwfcb.cd_pedi_periodo_diario pdrf on pdrf.pedi_seq_chave = prtc.pedi_seq_chave_referencia where orju.orju_bsq_chave_segmento in ('1G', 'JFP') AND pedi_num_ano IN (2017) group by pdrf.pedi_seq_chave, pdrf.pedi_sgl_mes_ano, prtc.orju_seq_chave, orju.orju_dsc_segmento, orju.orju_bsq_chave_unidade, orju.orju_dsc_unidade )")
		@total_novos = @@total_novos
		return @total_novos
	end
			
end		
