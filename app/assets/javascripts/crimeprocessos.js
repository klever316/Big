    function getCrimeProcessos(cd_foro) {
		var data = { det_processo_key : cd_foro }
		$.ajax({
		url : "/crime_organizado/detalheprocessos",
		beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
		type : "post",
		data : data,
		success: function(data, textStatus, jqXHR) {
            $('.modal-backdrop').remove();
			if (data.array.length > 0) {
				$("#corpo").empty();
				var html = "";
				html += '<table class="table datatable table-bordered dataTable no-footer" id="detalhe_processo" style="background-color: white">';
				html += '<thead>'
                html += '<tr>';
                html += '<th>Pessoa</th>';
                html += '<th>N° do Processo</th>';
                html += '<th>Situação do Processo</th>';
                html += '<th>Foro</th>';
                html += '</tr>';
                html += '</thead>'
                html += '<tbody>'
                data.array.forEach(function(value){
                html += '<tr>';
                html += '<td>'+value.nmpessoa+'</td>';
                html += '<td>'+format(value.nuprocesso,'#######-##.####.#.##.####')+'</td>';
                html += '<td>'+value.desituacaoprocesso+'</td>';
                html += '<td>'+value.nmforo+'</td>';
                html += '</tr>';	
				});	
				html += '</tbody>'
                html += '</table>'

                $(document).ready(function() {
                	var table_detalhe_processo = $('#detalhe_processo').DataTable({
                		dom: "<'row'<'col-sm-12'B>>" + "<'row'<'col-sm-6'l><'col-sm-6'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>",
                		order: [[ 0, "asc" ]],
                        buttons: [
                        {
                            extend: 'copyHtml5', 
                            title: ('Detalhes dos Processos  ' + data.array[0].nmforo),
                        },
                        {
                            extend: 'csv', 
                            title: ('Detalhes dos Processos ' + data.array[0].nmforo),
                            filename: ('Detalhes dos Processos  ' + data.array[0].nmforo)  
                        },
                        {
                            extend: 'pdfHtml5', 
                            title: ('Detalhes dos Processos  ' + data.array[0].nmforo),
                            filename: ('Detalhes dos Processos  ' + data.array[0].nmforo)  
                        },
                        {
                            extend: 'print',
                            text: 'Imprimir',
                            className: "printChartButton",
                            title: ('Detalhes dos Processos  ' + data.array[0].nmforo),
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
                $('#detalhe_foro').empty();
                $('#detalhe_foro').append('Lista de Processos ' + data.array[0].nmforo);
                $("#myModal").modal("show");
            } else {
                document.getElementById('foroinvalido').innerHTML = "<div class='alert alert-danger'>    <strong> Foro Inválido!</strong>    </div>";
            }   

            }
        });

    } 

function getCrimeDetalhes(cd_situacao) {
		var data = { det_situacao_key : cd_situacao }
		$.ajax({
		url : "/crime_organizado/detalhesituacao",
		beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
		type : "post",
		data : data,
		success: function(data, textStatus, jqXHR) {
            $('.modal-backdrop').remove();
			if (data.array.length > 0) {
				$("#corpo").empty();
				var html = "";
				html += '<table class="table datatable table-bordered dataTable no-footer" id="detalhe_processo" style="background-color: white">';
				html += '<thead>'
                html += '<tr>';
                html += '<th>Pessoa</th>';
                html += '<th>N° do Processo</th>';
                html += '<th>Situação do Processo</th>';
                html += '<th>Foro</th>';
                html += '</tr>';
                html += '</thead>'
                html += '<tbody>'
                data.array.forEach(function(value){
                html += '<tr>';
                html += '<td>'+value.nmpessoa+'</td>';
                html += '<td>'+format(value.nuprocesso,'#######-##.####.#.##.####')+'</td>';
                html += '<td>'+value.desituacaoprocesso+'</td>';
                html += '<td>'+value.nmforo+'</td>';
                html += '</tr>';	
				});	
				html += '</tbody>'
                html += '</table>'

                $(document).ready(function() {
                	var table_detalhe_processo = $('#detalhe_processo').DataTable({
                		dom: "<'row'<'col-sm-12'B>>" + "<'row'<'col-sm-6'l><'col-sm-6'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>",
                		order: [[ 0, "asc" ]],
                        buttons: [
                        {
                            extend: 'copyHtml5', 
                            title: ('Detalhes dos Processos - ' + data.array[0].desituacaoprocesso)
                        },
                        {
                            extend: 'csv', 
                            title: ('Detalhes dos Processos - ' + data.array[0].desituacaoprocesso),
                            filename: ('Detalhes dos Processos - ' + data.array[0].desituacaoprocesso) 
                        },
                        {
                            extend: 'pdfHtml5', 
                            title: ('Detalhes dos Processos - ' + data.array[0].desituacaoprocesso),
                            filename: ('Detalhes dos Processos - ' + data.array[0].desituacaoprocesso) 
                        },
                        {
                            extend: 'print',
                            text: 'Imprimir',
                            className: "printChartButton",
                            title: ('Detalhes dos Processos - ' + data.array[0].desituacaoprocesso),
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
                $('#detalhe_foro').empty();
                $('#detalhe_foro').append('Lista de Processos - ' + data.array[0].desituacaoprocesso);
                $("#myModal").modal("show");
            } else {
                document.getElementById('foroinvalido').innerHTML = "<div class='alert alert-danger'>    <strong> Foro Inválido!</strong>    </div>";
            }   

            }
        });

    } 
