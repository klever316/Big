class Custodia

	def self.filas_da_custodia
		conn = PG5DB.connection

        filas = conn.select_all "SELECT
        h.cdfila, ft.defila, (SELECT Count(1) FROM saj.ewflhistobjeto H1 WHERE h.cdfila = h1.cdfila AND h.cdfluxotrabalho = h1.cdfluxotrabalho AND h1.dtsaida IS null) AS processos, (SELECT Count(1) FROM   saj.ewflhistobjeto H3 JOIN SAJ.EFPGPROCESSO P ON P.CDOBJETO = H3.CDOBJETO JOIN saj.ewflfilatrabalho FT ON H3.cdfila = Ft.cdfila WHERE h3.cdfluxotrabalho = h.cdfluxotrabalho AND h.cdfila = h3.cdfila AND dtsaida IS NULL AND Trunc(24*(SYSDATE - dtentrada)) > 23) AS Estouro
  FROM
        (SELECT DISTINCT cdfluxotrabalho, cdfila FROM saj.ewflhistobjeto WHERE dtsaida IS null) H
        JOIN saj.ewflfilatrabalho FT ON H.cdfila = Ft.cdfila AND h.cdfila NOT IN (425,207,9052,9106)
  WHERE
        cdfluxotrabalho = 1860
  ORDER BY 4"

    	@lista_filas = filas

    	return @lista_filas
		
	end

	def self.processos_da_custodia(cdfila)
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

        return @lista_processos
		
	end

	def self.detalhe_do_processo(nuprocesso)

		conn = PG5DB.connection
        processo = conn.select_all "SELECT
      cdfluxotrabalho, h.cdfila, ft.defila, nuprocesso, dtentrada, dtsaida, trunc(24 * (Nvl(dtsaida,SYSDATE) - dtentrada)) as horasFila
FROM
      saj.ewflhistobjeto H JOIN SAJ.EFPGPROCESSO P ON P.CDOBJETO = H.CDOBJETO
      JOIN saj.ewflfilatrabalho FT ON H.cdfila = Ft.cdfila
WHERE
      cdfluxotrabalho = 1860
      AND nuprocesso = #{nuprocesso}
      AND h.cdfila NOT IN (425,207,9052,9106)
ORDER BY dtentrada"

		@det_processo = processo

		return @det_processo
		
	end

end	