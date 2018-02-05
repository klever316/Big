function listaProcessosBaixados(data_ajax,key,name){
    $("#corpo").empty();
    var html = '<table class="table datatable table-striped table-bordered" width="100%" id="table_processos">';
    html += '<thead>';
    html += '<tr>';
    html += '<th>Nº do Processo</th>';
    html += '<th>Vara</th>';
    html += '<th>Sit. do Processo</th>';
    html += '<th>Data do Protocolo</th>';
    html += '</tr>';
    html += '</thead>';
    html += '<tbody>';
    data_ajax.forEach(function(value){
        html += '<tr>';
        html += '<td>'+ value.proc_dsc_processo_formatado+'</td>';
        html += '<td>'+ value.orju_dsc_unidade +'</td>';
        html += '<td>'+ value.sipr_dsc_situacao_processo +'</td>';
        x = new Date(value.proc_dat_protocolo);
        html += '<td>' + x.getDate() + "/" + (x.getMonth()+1) + "/" + x.getFullYear() +'</td>';
        html += '</tr>';
        html += '</tr>';
    });
    html += '</tbody>';
    html += '</table>';
    $(document).ready(function() {
      $("#table_processos").dataTable({
        dom: "<'row'<'col-sm-12'B>>" + "<'row'<'col-sm-6'l><'col-sm-6'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>",
        autoWidth : false,
        order: [[ 3, "asc" ]],
        select: true,
        buttons: [
        {
            extend: 'copyHtml5', 
            title: "PROCESSOS BAIXADOS DA " + key + " NO ANO DE " + name
        },
        {
            extend: 'csv', 
            title: "PROCESSOS BAIXADOS DA " + key + " NO ANO DE " + name,
            filename: "BAIXADOS - " + key + " - " + name
        },
        {
            extend: 'pdfHtml5', 
            title: "PROCESSOS BAIXADOS DA " + key + " NO ANO DE " + name,
            filename: "BAIXADOS - " + key + " - " + name
        },
        {
            extend: 'print',
            text: 'Imprimir',
            className: "printChartButton",
            title: "PROCESSOS BAIXADOS DA " + key + " NO ANO DE " + name,
            exportOptions: {
                modifier: {
                    page: 'all'
                }
            }
        }
        ],
        columnDefs : [{"width": "22%", "targets": 0 },
        {"width": "38%", "targets": 1 },
        {"width": "20%", "targets": 2 },
        {"type": "order-data", "width": "20%", "targets": 3 },
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
    $('#modal_titulo_processos_baixados').empty();
    $('#modal_titulo_processos_baixados').append('PROCESSOS BAIXADOS DA ' + key + ' NO ANO DE ' + name);
    $("#myModal").modal("show");
};

function carregarGraficoBaixadosPorCompetencia(data_competencia, data_varas){

    chart = Highcharts.chart('container2', {
        chart: {
            type: 'column',
            zoomType: 'xy'
        },
        title: {
            text: 'Processos Baixados Por Competência'
        },
        subtitle: {
            text: 'Relatório de Processos Baixados Por Competência'
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            title: {
                text: 'Pendentes (n)'
            }

        },
        legend: {
            enabled: true
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: false,
                    format: '{point.y:.0f}'
                },
                point: {
                    events: {
                        click: function () {
                            var data_ajax;
                            //console.log(this.options)
                            var options = this;
                            console.log(options);
                            var data = { column_key : options.options.key , ano : options.series.name};
                            $.ajax({
                                url : "/judicial/baixados/processos",
                                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                                type : "post",
                                data : data,
                                success: function(data, textStatus, jqXHR) {
                                    $('.modal-backdrop').remove();
                                    listaProcessosBaixados(data.array, data.array[0].orju_dsc_unidade, options.series.name);
                                },
                            });
                        }
                    }
                }                
            }
        },

        credits: {
          enabled: false
      },

      tooltip: {
        headerFormat: '<span style="font-size:10px"><b>{point.key}</b></span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}:&nbsp; </td>' +
        '<td style="padding:0"><b>{point.y:.0f} processos</b></td></tr>',
        useHTML: true
    },

    series: data_competencia,
    drilldown: {
        series: data_varas
    }
});
    $('#width').on('input', function () {
        chart.setSize(this.value, false, false);
    });

};

function carregarGraficoBaixadosComarcaFortaleza(processos_baixados){
    Highcharts.chart('container', {
        chart: {
            type: 'column'
        },
        title: {
            text: 'Processos Baixados'
        },
        subtitle: {
            text: 'Relatório de Processos Baixados nos últimos 3 anos'
        },
        xAxis: {
            categories: [
            'Janeiro',
            'Fevereiro',
            'Março',
            'Abril',
            'Maio',
            'Junho',
            'Julho',
            'Agosto',
            'Setembro',
            'Outubro',
            'Novembro',
            'Dezembro'
            ],
            crosshair: true
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Baixados (n)'
            }
        },
        tooltip: {
            headerFormat: '<span style="font-size:12px">{point.key}</span><table>',
            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>{point.y:.0f} processos</b></td></tr>',
            footerFormat: '</table>',
            shared: true,
            useHTML: true
        },
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0
            }
        },

        credits: {
          enabled: false
      },

      series: processos_baixados
  });
};