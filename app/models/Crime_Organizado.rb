class CrimeOrganizado

    def self.processos_por_foro
        conn = PG5DB.connection
        
        @@painel ||= conn.select_all "SELECT p.cdforo, nmforo, p.cdsituacaoprocesso, desituacaoprocesso,  Count(DISTINCT nuprocesso) AS Total
    FROM
        SAJ.EAIPHISTORICOPARTE HP INNER JOIN SAJ.EFPGPROCESSO P ON HP.cdProcesso = P.cdProcesso
        INNER JOIN saj.esajsitprocesso S ON p.cdsituacaoprocesso = S.cdsituacaoprocesso
        INNER JOIN saj.esajforo F ON f.cdforo = p.cdforo
        INNER JOIN SAJ.ESAJNOME N ON N.cdPessoa = HP.cdPessoa AND N.tpNome = 'N'
    WHERE
        hp.decomplemento LIKE '%12.850%'
        OR hp.decomplemento LIKE '%12850%'
    GROUP BY nmforo, p.cdsituacaoprocesso, desituacaoprocesso, p.cdforo
    ORDER BY cdforo"
        @lista_painel = @@painel

        return @lista_painel
        
    end

    def self.processos_por_reus
        conn = PG5DB.connection

        @@reus ||= conn.select_all "SELECT p.cdforo, nmforo, Count(DISTINCT nmpessoa) AS TotalReus
    FROM
        SAJ.EAIPHISTORICOPARTE HP INNER JOIN SAJ.EFPGPROCESSO P ON HP.cdProcesso = P.cdProcesso
        INNER JOIN saj.esajsitprocesso S ON p.cdsituacaoprocesso = S.cdsituacaoprocesso
        INNER JOIN saj.esajforo F ON f.cdforo = p.cdforo
        INNER JOIN SAJ.ESAJNOME N ON N.cdPessoa = HP.cdPessoa AND N.tpNome = 'N'
    WHERE
        hp.decomplemento LIKE '%12.850%'
        OR hp.decomplemento LIKE '%12850%'
    GROUP BY p.cdforo, nmforo"

    return @lista_reus = @@reus 
        
    end

    def self.detalhes_processos_por_foro(det_processo)

        conn = PG5DB.connection
        det_processo_consulta = conn.select_all "SELECT DISTINCT
       HP.cdProcesso,
       N.nmPessoa,
       P.nuProcesso,
       S.desituacaoprocesso,
       f.nmforo
    from
        SAJ.EAIPHISTORICOPARTE HP INNER JOIN SAJ.EFPGPROCESSO P ON HP.cdProcesso = P.cdProcesso
        INNER JOIN saj.esajsitprocesso S ON p.cdsituacaoprocesso = S.cdsituacaoprocesso
        INNER JOIN saj.esajforo F ON f.cdforo = p.cdforo
        INNER JOIN SAJ.ESAJNOME N ON N.cdPessoa = HP.cdPessoa AND N.tpNome = 'N'
    WHERE
        (hp.decomplemento LIKE '%12.850%'
        OR hp.decomplemento LIKE '%12850%')
        and p.cdforo = #{det_processo}
    ORDER BY nmPessoa"

    @det_processo = det_processo_consulta

    return @det_processo

    end    

    def self.detalhes_processos_por_reu(det_situacao, cod_foro)
        conn = PG5DB.connection
        det_situacao_consulta = conn.select_all "SELECT DISTINCT
       HP.cdProcesso,
       N.nmPessoa,
       P.nuProcesso,
       S.cdsituacaoprocesso,
       S.desituacaoprocesso,
       f.cdforo,
       f.nmforo
    from
        SAJ.EAIPHISTORICOPARTE HP INNER JOIN SAJ.EFPGPROCESSO P ON HP.cdProcesso = P.cdProcesso
        INNER JOIN saj.esajsitprocesso S ON p.cdsituacaoprocesso = S.cdsituacaoprocesso
        INNER JOIN saj.esajforo F ON f.cdforo = p.cdforo
        INNER JOIN SAJ.ESAJNOME N ON N.cdPessoa = HP.cdPessoa AND N.tpNome = 'N'
    WHERE
        (hp.decomplemento LIKE '%12.850%'
        OR hp.decomplemento LIKE '%12850%')
        and s.cdsituacaoprocesso = '#{det_situacao}'
        and f.cdforo = '#{cod_foro}'
    ORDER BY nmPessoa"

        @det_processo = det_situacao_consulta

        return @det_processo
        
    end

    def self.quantidade_reus_por_foro(det_reus)
        conn = PG5DB.connection
        det_reus_consulta = conn.select_all "SELECT DISTINCT
       HP.cdProcesso,
       N.nmPessoa,
       P.nuProcesso,
       S.cdsituacaoprocesso,
       S.desituacaoprocesso,
       f.nmforo
    from
        SAJ.EAIPHISTORICOPARTE HP INNER JOIN SAJ.EFPGPROCESSO P ON HP.cdProcesso = P.cdProcesso
        INNER JOIN saj.esajsitprocesso S ON p.cdsituacaoprocesso = S.cdsituacaoprocesso
        INNER JOIN saj.esajforo F ON f.cdforo = p.cdforo
        INNER JOIN SAJ.ESAJNOME N ON N.cdPessoa = HP.cdPessoa AND N.tpNome = 'N'
    WHERE
        (hp.decomplemento LIKE '%12.850%'
        OR hp.decomplemento LIKE '%12850%')   
        and p.cdforo = '#{det_reus}'
    ORDER BY nmPessoa"

        @det_reus = det_reus_consulta

        return @det_reus
        
    end

end