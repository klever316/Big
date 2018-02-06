class CrimeOrganizadoController < ApplicationController
  def painel_crime
  	conn = PG5DB.connection
    
  	painel = conn.select_all "SELECT p.cdforo, nmforo, p.cdsituacaoprocesso, desituacaoprocesso,  Count(DISTINCT nuprocesso) AS Total
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
    @lista_painel = painel
    reus = conn.select_all "SELECT p.cdforo, nmforo, Count(DISTINCT nmpessoa) AS TotalReus
FROM
    SAJ.EAIPHISTORICOPARTE HP INNER JOIN SAJ.EFPGPROCESSO P ON HP.cdProcesso = P.cdProcesso
    INNER JOIN saj.esajsitprocesso S ON p.cdsituacaoprocesso = S.cdsituacaoprocesso
    INNER JOIN saj.esajforo F ON f.cdforo = p.cdforo
    INNER JOIN SAJ.ESAJNOME N ON N.cdPessoa = HP.cdPessoa AND N.tpNome = 'N'
WHERE
    hp.decomplemento LIKE '%12.850%'
    OR hp.decomplemento LIKE '%12850%'
GROUP BY p.cdforo, nmforo"

    @lista_reus = reus

  end

  def detalheprocessos
    
    det_processo = params[:det_processo_key]
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
   render :json => {array: det_processo_consulta}

  end 

  def detalhesituacao

    det_situacao = params[:det_situacao_key]
    cod_foro = params[:cod_foro_key]
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
    render :json => {array: det_situacao_consulta}

  end

  def detalhereus

    det_reus = params[:det_reus_key]
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
    render :json => {array: det_reus_consulta}

  end 

end
