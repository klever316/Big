function sala_vitima(dt_inicio, dt_final) {
	if(dt_inicio == "" || dt_final == ""){
		$("#dt_invalida").empty();
        $.notify("Data Inválida", "error");
	} else {
		var data = { dt_inicio_key : dt_inicio, dt_final_key : dt_final  }
        $.ajax({
        url : "/seguranca/salavitimaretorno",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        type : "post",
        data : data,
        success: function(data, textStatus, jqXHR) { 
        	$('.modal-backdrop').remove();
        	if(data.lista_vitimas.length > 0) {
                $("#tabela").empty();
                var html = "";
                html += '<table class="table datatable table-bordered dataTable no-footer" id="detalhe_processo" style="background-color: white">';
                html += '<thead>'
                html += '<tr>';
                html += '<th>Data de Início</th>';
                html += '<th>Nome da Parte</th>';
                html += '<th>Vara</th>';
                html += '<th>Nº do Processo</th>';
                html += '<th>Assunto</th>';
                html += '<th>Tipo</th>';
                html += '</tr>';
                html += '</thead>'
                html += '<tbody>'
                data.lista_vitimas.forEach(function(value){
                html += '<tr>';
                var x = new Date(value.dtinicio);
                html += '<td>'+ x.toLocaleString('pt-BR', { timeZone: 'UTC' }) +'</td>';
                html += '<td>'+value.nome+'</td>';
                html += '<td>'+value.nmvara+'</td>';
                html += '<td>'+format(value.nuprocesso,'#######-##.####.#.##.####')+'</td>';
                html += '<td>'+ value.deassunto +'</td>'
                html += '<td>'+value.decomptipoparte+'</td>';
                html += '</tr>';
                }); 
                html += '</tbody>';
                html += '</table>';
                $("#tabela").append(html);
                $(document).ready(function() {
                	var table_detalhe_processo = $('#detalhe_processo').DataTable({
                		dom: "<'row'<'col-sm-12'B>>" + "<'row'<'col-sm-6'l><'col-sm-6'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>",
                		buttons: [
                        {
                            extend: 'copyHtml5', 
                            title: "Relatório de Vítimas"
                            
                        },
                        {
                            extend: 'csv', 
                            title: "Relatório de Vítimas",
                            filename: "Relatorio de Vitimas"  
                        },
                        {
                            extend: 'pdfHtml5', 
                            title: "Relatório de Vítimas",
                            filename: "Relatorio de Vitimas" 
                        },
                        {
                            extend: 'print',
                            text: 'Imprimir',
                            className: "printChartButton",
                            title: "Relatório de Vítimas",
                            exportOptions: {
                                modifier: {
                                    page: 'all'
                                }
                            }
                        }
                        ],
                        columnDefs : [{"width": "15%", "targets": 0 },
				        {"width": "25%", "targets": 1 },
				        {"width": "15%", "targets": 2 },
				        {"width": "20%", "targets": 3 },
				        {"width": "15%", "targets": 4 },
				        {"width": "10%", "targets": 5 },
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
            }
        }
    });
	}

};

function controle_acesso(dt_inicio, dt_final) {
    if(dt_inicio == "" || dt_final == ""){
        $("#dt_invalida").empty();
        $.notify("Data Inválida", "error");
    } else {
        var data = { dt_inicio_key : dt_inicio, dt_final_key : dt_final  }
        $.ajax({
        url : "/seguranca/controleacessoretorno",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        type : "post",
        data : data,
        success: function(data, textStatus, jqXHR) { 
            $('.modal-backdrop').remove();
            if(data.lista_controle.length > 0) {
                $("#tabela").empty();
                var html = "";
                html += '<table class="table datatable table-bordered dataTable no-footer" id="detalhe_processo" style="background-color: white">';
                html += '<thead>'
                html += '<tr>';
                html += '<th>Data de Início</th>';
                html += '<th>Nome da Parte</th>';
                html += '<th>Vara</th>';
                html += '<th>Nº do Processo</th>';
                html += '<th>Tipo</th>';
                html += '</tr>';
                html += '</thead>'
                html += '<tbody>'
                data.lista_controle.forEach(function(value){
                html += '<tr>';
                var x = new Date(value.dtinicio);
                html += '<td>'+ x.toLocaleString('pt-BR', { timeZone: 'UTC' }) +'</td>';
                html += '<td>'+value.nome+'</td>';
                html += '<td>'+value.nmvara+'</td>';
                html += '<td>'+format(value.nuprocesso,'#######-##.####.#.##.####')+'</td>';
                html += '<td>'+value.decomptipoparte+'</td>';
                html += '</tr>';
                }); 
                html += '</tbody>';
                html += '</table>';
                $("#tabela").append(html);
                $(document).ready(function() {
                    var table_detalhe_processo = $('#detalhe_processo').DataTable({
                        dom: "<'row'<'col-sm-12'B>>" + "<'row'<'col-sm-6'l><'col-sm-6'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>",
                        buttons: [
                        {
                            extend: 'copyHtml5', 
                            title: "Relatório Controle de Acesso"
                        },
                        {
                            extend: 'csv', 
                            title: "Relatório Controle de Acesso",
                            filename: "Relatorio Controle de Acesso"  
                        },
                        {
                            extend: 'pdfHtml5', 
                            title: "Relatório Controle de Acesso",
                            filename: "Relatorio Controle de Acesso" 
                        },
                        {
                            extend: 'print',
                            text: 'Imprimir',
                            className: "printChartButton",
                            title: "Relatório Controle de Acesso",
                            exportOptions: {
                                modifier: {
                                    page: 'all'
                                }
                            }
                        }
                        ],
                        columnDefs : [{"width": "18%", "targets": 0 },
                        {"width": "30%", "targets": 1 },
                        {"width": "22%", "targets": 2 },
                        {"width": "20%", "targets": 3 },
                        {"width": "10%", "targets": 4 },
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
            }
        }
    });
    }

};