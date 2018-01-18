class CustodiaController < ApplicationController
    def custodiafila
        conn = PG5DB.connection

        results = conn.select_all("SELECT cdfluxotrabalho, h.cdfila, ft.defila, 
        nuprocesso, dtentrada, dtsaida FROM saj.ewflhistobjeto H JOIN SAJ.EFPGPROCESSO 
        P ON P.CDOBJETO = H.CDOBJETO JOIN saj.ewflfilatrabalho FT ON H.cdfila = Ft.cdfila
        WHERE cdfluxotrabalho = 1860 AND nuprocesso = '01973384420178060001'
        AND h.cdfila NOT IN (425,207) ORDER BY dtentrada")

        @processo_custodia = results

        filas = conn.select_all "SELECT
        h.cdfila, ft.defila, (SELECT Count(1) FROM saj.ewflhistobjeto H1 WHERE h.cdfila = h1.cdfila AND h.cdfluxotrabalho = h1.cdfluxotrabalho AND h1.dtsaida IS null) AS processos, (SELECT Count(1) FROM   saj.ewflhistobjeto H3 JOIN SAJ.EFPGPROCESSO P ON P.CDOBJETO = H3.CDOBJETO JOIN saj.ewflfilatrabalho FT ON H3.cdfila = Ft.cdfila WHERE h3.cdfluxotrabalho = h.cdfluxotrabalho AND h.cdfila = h3.cdfila AND dtsaida IS NULL AND Trunc(24*(SYSDATE - dtentrada)) > 23) AS Estouro
  FROM
        (SELECT DISTINCT cdfluxotrabalho, cdfila FROM saj.ewflhistobjeto WHERE dtsaida IS null) H
        JOIN saj.ewflfilatrabalho FT ON H.cdfila = Ft.cdfila AND h.cdfila NOT IN (425,207,9052,9106)
  WHERE
        cdfluxotrabalho = 1860
  ORDER BY 4"

    @lista_filas = filas

    end

    def custodiaprocessos
        cdfila = params[:cdfila]

        conn = PG5DB.connection

        processos = conn.select_all "SELECT
        nuprocesso, dtentrada, defila, Trunc(24*(SYSDATE - dtentrada)) AS horas
  FROM
        saj.ewflhistobjeto H JOIN SAJ.EFPGPROCESSO P ON P.CDOBJETO = H.CDOBJETO
        JOIN saj.ewflfilatrabalho FT ON H.cdfila = Ft.cdfila
  WHERE
        cdfluxotrabalho = 1860
        AND h.cdfila = #{cdfila}
        AND dtsaida IS null
  ORDER BY dtentrada"
        @lista_processos = processos
    end

    def dadosprocesso

        processo = params[:processo_key]

        conn = PG5DB.connection
        processo = conn.select_all "SELECT
        cdfluxotrabalho, h.cdfila, ft.defila, nuprocesso, dtentrada, dtsaida, Trunc(Nvl(dtsaida,SYSDATE)- dtentrada) * 24 AS horasFila
  FROM
        saj.ewflhistobjeto H JOIN SAJ.EFPGPROCESSO P ON P.CDOBJETO = H.CDOBJETO
        JOIN saj.ewflfilatrabalho FT ON H.cdfila = Ft.cdfila
  WHERE
        cdfluxotrabalho = 1860
        AND nuprocesso = #{processo}
        AND h.cdfila NOT IN (425,207,9052,9106)
  ORDER BY dtentrada"

        render :json => {array: processo}

    end

end
