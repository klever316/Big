require "Custodia"

class CustodiaController < ApplicationController

    def custodiafila

        @lista_filas = Custodia.filas_da_custodia

    end

    def custodiaprocessos

        cdfila = params[:cdfila]

        @lista_processos = Custodia.processos_da_custodia(cdfila)

    end

    def dadosprocesso

        processo = params[:processo_key]

        @det_processo = Custodia.detalhe_do_processo(processo)

        render :json => {array: @det_processo}

    end

end
