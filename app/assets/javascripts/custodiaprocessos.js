    function getCustodiaProcessos(processo) {
        var data = { processo_key : processo }
        $.ajax({
        url : "/custodia/dadosprocesso",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        type : "post",
        data : data,
        success: function(data, textStatus, jqXHR) { 
        	if(data.array.length > 0) {
                $("#corpo").empty();
                var html = "";
                html += '<table class="table datatable table-bordered dataTable no-footer" id="detalhe_processo" style="background-color: white">';
                html += '<thead>'
                html += '<tr>';
                html += '<th>Cód. Fluxo</th>';
                html += '<th>Cód. Fila</th>';
                html += '<th>Nome da Fila</th>';
                html += '<th>Nº do Processo</th>';
                html += '<th>Data de Entrada</th>';
                html += '<th>Data de Saída</th>';
                html += '<th>Horas na Fila</th>';
                html += '</tr>';
                html += '</thead>'
                html += '<tbody>'
                data.array.forEach(function(value){
                html += '<tr>';
                html += '<td>'+value.cdfluxotrabalho+'</td>';
                html += '<td>'+value.cdfila+'</td>';
                html += '<td>'+value.defila+'</td>';
                html += '<td>'+format(value.nuprocesso,'#######-##.####.#.##.####')+'</td>';
                var x = new Date(value.dtentrada);
                html += '<td>'+ x.toLocaleString('pt-BR', { timeZone: 'UTC' }) +'</td>';
                if(value.dtsaida == null){
                    html += '<td>'+ 'Aguardando' +'</td>'
                } else {
                    var y = new Date(value.dtsaida);
                    html += '<td>'+ y.toLocaleString('pt-BR', { timeZone: 'UTC' }) +'</td>';
                }
                html += '<td>'+value.horasfila+'</td>';
                html += '</tr>';
                }); 
                html += '</tbody>'
                html += '</table>'
 
                $(document).ready(function() {
                    var table_detalhe_processo = $('#detalhe_processo').DataTable({
                    	dom: "<'row'<'col-sm-12'B>>" + "<'row'<'col-sm-6'l><'col-sm-6'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>",
                        order: [[ 6, "des" ]],
                        buttons: [
                        {
                            extend: 'copyHtml5', 
                            title: "Detalhes do Processo"
                        },
                        {
                            extend: 'csv', 
                            title: "Detalhes do Processo",
                            filename: "Detalhes do Processo"  
                        },
                        {
                            extend: 'pdfHtml5', 
                            title: "Detalhes do Processo",
                            filename: "Detalhes do Processo" 
                        },
                        {
                            extend: 'print',
                            text: 'Imprimir',
                            className: "printChartButton",
                            title: "Detalhes do Processo",
                            exportOptions: {
                                modifier: {
                                    page: 'all'
                                }
                            }
                        }
                        ],
                        language: {
			                "sEmptyTable": "Nenhum registro encontrado",
			                "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
			                "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
			                "sInfoFiltered": "(Filtrados de _MAX_ registros)",
			                "sInfoPostFix": "",
			                "sInfoThousands": ".",
			                "sLengthMenu": "_MENU_ resultados por página",
			                "sLoadingRecords": "Carregando...",
			                "sProcessing": "Processando...",
			                "sZeroRecords": "Nenhum registro encontrado",
			                "sSearch": "Pesquisar",
			                "oPaginate": {
			                    "sNext": "Próximo",
			                    "sPrevious": "Anterior",
			                    "sFirst": "Primeiro",
			                    "sLast": "Último"
			                },
			                "oAria": {
			                    "sSortAscending": ": Ordenar colunas de forma ascendente",
			                    "sSortDescending": ": Ordenar colunas de forma descendente"
			                },
			                "buttons" :{
			                    "copy" : "Copiar"
			                }
			            }

                    });
                });
                $("#corpo").append(html);
                $('#titulo_processo').empty();
                $('#titulo_processo').append('Processo ' + format(data.array[0].nuprocesso, '#######-##.####.#.##.####'));
                $("#myModal").modal("show");
            } else {
                document.getElementById('processoinvalido').innerHTML = "<div class='alert alert-danger'>              <strong> Processo Inválido!</strong>            </div>";
            }


        }
        });

    }

function format(value, pattern) {
    var i = 0,
        v = value.toString();
    return pattern.replace(/#/g, _ => v[i++]);
    }