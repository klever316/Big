class CustodiaController < ApplicationController
    def custodiafila
        conn = PG5DB.connection

        results = conn.select_all("SELECT cdfluxotrabalho, h.cdfila, ft.defila, 
        nuprocesso, dtentrada, dtsaida FROM saj.ewflhistobjeto H JOIN SAJ.EFPGPROCESSO 
        P ON P.CDOBJETO = H.CDOBJETO JOIN saj.ewflfilatrabalho FT ON H.cdfila = Ft.cdfila
        WHERE cdfluxotrabalho = 1860 AND nuprocesso = '01973384420178060001'
        AND h.cdfila NOT IN (425,207) ORDER BY dtentrada")

        @processo_custodia = results
    end
end
