class Seguranca

	def self.lista_de_vitimas(dt_inicio, dt_final)
		conn = PG5DB.connection

		vitimas = conn.select_all "SELECT dtinicio, nome.nmPessoa as Nome, nuprocesso, v.nmvara, cdassuntoprinc, deassunto, tppr.deCompTipoParte
FROM
    saj.eggpaudiencia A
    JOIN saj.efpgprocesso P ON A.cdprocesso = P.cdprocesso AND a.cdforo = 1
    JOIN saj.efpgParte ppar  ON ppar.cdprocesso = A.cdprocesso
    JOIN saj.esajTipoParte tppr ON ppar.cdTipoParte = tppr.cdTipoParte AND tppr.deCompTipoParte IN ('Vítima','Vítima do Fato')
    JOIN saj.esajNome nome ON ppar.cdPessoa = nome.cdPessoa AND nome.tpnome = 'N'
    left JOIN saj.esajassunto Ass ON p.cdassuntoprinc = ass.cdassunto
    JOIN saj.esajvara v ON v.cdforo = p.cdforo AND p.cdvara = v.cdvara  AND v.cdvara IN (21,22,23,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,111,113,124,227)
WHERE dtinicio BETWEEN  to_date('#{dt_inicio}','dd/mm/yyyy') AND to_date('#{dt_final} 23:59:59','dd/mm/yyyy HH24:MI:SS')
ORDER BY dtinicio"

		@lista_vitimas = vitimas

		return @lista_vitimas
		
	end

	def self.controle_de_acesso(dt_inicio, dt_final)
		conn = PG5DB.connection

		controle = conn.select_all "SELECT DISTINCT dtinicio, nome.nmPessoa as Nome, nuprocesso, v.nmvara, cdassuntoprinc, deassunto, tppr.deCompTipoParte
FROM
    saj.eggpaudiencia A
    JOIN saj.efpgprocesso P ON A.cdprocesso = P.cdprocesso AND a.cdforo = 1  AND p.flarea = 2
    JOIN saj.efpgParte ppar  ON ppar.cdprocesso = A.cdprocesso
    JOIN saj.esajTipoParte tppr ON ppar.cdTipoParte = tppr.cdTipoParte AND tppr.deCompTipoParte NOT IN ('Vítima','Vítima do Fato','Deprecado','Juízo Deprecante','Juízo Deprecado','Defensor Público','Ministerio Publico','Autoridade Policial','Promotor')
    JOIN saj.esajNome nome ON ppar.cdPessoa = nome.cdPessoa AND nome.tpnome = 'N'
    left JOIN saj.esajassunto Ass ON p.cdassuntoprinc = ass.cdassunto
    JOIN saj.esajvara v ON v.cdforo = p.cdforo AND p.cdvara = v.cdvara AND v.cdvara IN (21,26,27,28,29,30,31,32,33,34,35,36,37,38,39,111,113)
WHERE dtinicio BETWEEN  to_date('#{dt_inicio}','dd/mm/yyyy') AND to_date('#{dt_final} 23:59:59','dd/mm/yyyy HH24:MI:SS')
ORDER BY  dtinicio"
		
	end

end	