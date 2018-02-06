function carregarProcessosPendentesTaxa(data_ajax,key,name){
                                $("#corpo2").empty();
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
                                html += '<td>' + x.getDate() + "/" + (x.getMonth() + 1) + "/" + x.getFullYear() +'</td>';
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
                                        title: "PROCESSOS JULGADOS DA " + key + " NO ANO DE " + name
                                    },
                                    {
                                        extend: 'csv', 
                                        title: "PROCESSOS JULGADOS DA " + key + " NO ANO DE " + name,
                                        filename: "JULGADOS - " + key + " - " + name
                                    },
                                    {
                                        extend: 'pdfHtml5', 
                                        title: "PROCESSOS JULGADOS DA " + key + " NO ANO DE " + name,
                                        filename: "JULGADOS - " + key + " - " + name
                                    },
                                    {
                                        extend: 'print',
                                        text: 'Imprimir',
                                        className: "printChartButton",
                                        title: "PROCESSOS JULGADOS DA " + key + " NO ANO DE " + name,
                                        exportOptions: {
                                            modifier: {
                                                search: 'applied'
                                            }
                                        }
                                    }
                                ],
                                    columnDefs : [{"width": "20%", "targets": 0 },
                                                    {"width": "40%", "targets": 1 },
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
                                        },
                                        "select": {
                                            rows: {
                                                _: "%d linhas selecionadas",
                                                0: "",
                                                1: "1 linha selecionada"
                                            }
                                        }
                                    }
                              });
                            });
                            $("#corpo2").append(html);
                            $('#modal_titulo_processos_pendentes').empty();
                            $('#modal_titulo_processos_pendentes').append('PROCESSOS PENDENTES DA ' + key + ' NO ANO DE ' + name);
                            $("#myModal2").modal("show");
};

function mostrarProcessosPendentesNaTaxa(){
        var data = { };
        if( (new Date().getMonth()+1 == 1) || (new Date().getMonth()+1 == 2 && new Date().getDate() <= 15 ) ){
            data = {column_key : document.getElementById('combo_vara').value , ano : new Date().getFullYear()-1}
        } else {
            data = {column_key : document.getElementById('combo_vara').value , ano : new Date().getFullYear()}
        }

        $.ajax({
            url : "/judicial/pendentes/processos",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type : "post",
            data : data,
            success: function(data, textStatus, jqXHR) {
                $('.modal-backdrop').remove();
                if( (new Date().getMonth()+1 == 1) || (new Date().getMonth()+1 == 2 && new Date().getDate() <= 15 ) ){
                    carregarProcessosPendentesTaxa(data.array, data.array[0].orju_dsc_unidade, new Date().getFullYear()-1);
                } else {
                    carregarProcessosPendentesTaxa(data.array, data.array[0].orju_dsc_unidade, new Date().getFullYear());
                }
                 
            },
        });
};

function mostrarGraficoTaxa(value,metaAtual){
    if (document.getElementById('vazio') != null){
        document.getElementById('vazio').id = "container";
    } 
    var data = { cod_competencia: document.getElementById('combo_vara').value };    
    $.ajax({
        url : "/diretoria/taxaGrafico",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        type : "post",
        data : data,
        success: function(data, textStatus, jqXHR) {
            $('.modal-backdrop').remove();
                chart2 = Highcharts.chart('container', {
                    chart: {
                        type: 'column',
                        zoomType: 'xy',
                        height: 400
                    },
                    title: {
                        text: 'Taxa de Congestionamento da ' + value
                    },
                    subtitle: {
                        text: 'Relatório da Taxa de Congestionamento da '+ value
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
                        crosshair: true,
                        title: {
                            text: 'Taxa (%)'
                        },
                        plotLines: [{
                            color: 'red',
                            dashStyle: 'solid',
                            value: metaAtual,
                            width: 2,
                            zIndex: 5,
                            label: {
                                text: 'Meta: '+ metaAtual +'%',
                                rotation: -90,
                                y: 25,
                                x: -3,
                                style: {
                                    color: 'blue',
                                    fontWeight: 'bold'
                                }
                            }
                        }],
                        max: 100

                    },
                    legend: {
                        enabled: true
                    },
                    plotOptions: {
                        series: {
                            cursor: 'pointer',
                            borderWidth: 0,
                            dataLabels: {
                                enabled: false,
                                format: '{point.y:.0f}'
                            },
                            events: {
                                    click: function () {
                                        //alert(event.point.series.userOptions.name +' clicked\n');
                                        if( (new Date().getMonth()+1 == 1) || (new Date().getMonth()+1 == 2 && new Date().getDate() <= 15 ) ){
                                            mostrarDetalhesTaxa(data.taxa,value,new Date().getFullYear()-1,data.qtd_dias_uteis, metaAtual);
                                        } else {
                                            mostrarDetalhesTaxa(data.taxa,value,new Date().getFullYear(),data.qtd_dias_uteis, metaAtual);
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
                        '<td style="padding:0"><b>{point.y:.4f} %</b></td></tr>',
                    useHTML: true
                },
                series: data.dados
            });
                if (document.getElementById('metas') == null){
                    var html = '';
                    if((new Date().getMonth()+1 == 1) || (new Date().getMonth()+1 == 2 && new Date().getDate() <= 15)){
                        html = '<div id="metas"><div class="radio radio-inline radio-success"> <input type="radio" name="radio" id="meta_2017" value="option1" onclick="metaSelecao()"> <label for="meta_2017"> Meta ' + (new Date().getFullYear()-1) + '</label> </div> <div class="radio radio-inline radio-success"> <input type="radio" name="radio" id="meta_2016" value="option1" onclick="metaSelecao()"> <label for="meta_2016"> Meta ' +(new Date().getFullYear()-2)+ '</label></div><div class="radio radio-inline radio-success"><input type="radio" name="radio" id="meta_2015" value="option1" onclick="metaSelecao()"> <label for="meta_2015"> Meta '+(new Date().getFullYear()-3)+' </label> </div></div>'; 
                    } else {
                        html = '<div id="metas"><div class="radio radio-inline radio-success"> <input type="radio" name="radio" id="meta_2017" value="option1" onclick="metaSelecao()"> <label for="meta_2017"> Meta ' + new Date().getFullYear() + '</label> </div> <div class="radio radio-inline radio-success"> <input type="radio" name="radio" id="meta_2016" value="option1" onclick="metaSelecao()"> <label for="meta_2016"> Meta ' +(new Date().getFullYear()-1)+ '</label></div><div class="radio radio-inline radio-success"><input type="radio" name="radio" id="meta_2015" value="option1" onclick="metaSelecao()"> <label for="meta_2015"> Meta '+(new Date().getFullYear()-2)+' </label> </div></div>'; 
                        }
                     
                    $("#radios_meta").append(html);
                } 
        }
    });
};

function addOptionsInFilter(val, label, select) {
  var option = document.createElement('option');
  option.value = val;
  option.label = label;
  option.innerHTML = val;
  select.appendChild(option);
};

function addVarasNosFiltros(){
    var combo_competencia = document.getElementById('combo_competencia')
    var combo_vara = document.getElementById('combo_vara'); 

combo_competencia.onchange = function (e) {
  var val = e.target.value;
  document.getElementById('button_taxa').disabled = false;
  combo_vara.innerHTML = '';
  if(val == "0"){
    addOptionsInFilter("0","Selecione um item acima", combo_vara);
  }
  if(val == "1"){
    addOptionsInFilter("648","1ª Vara de Família", combo_vara);
    addOptionsInFilter("649","2ª Vara de Família", combo_vara);
    addOptionsInFilter("650","3ª Vara de Família", combo_vara);
    addOptionsInFilter("651","4ª Vara de Família", combo_vara);
    addOptionsInFilter("652","5ª Vara de Família", combo_vara);
    addOptionsInFilter("653","6ª Vara de Família", combo_vara);
    addOptionsInFilter("654","7ª Vara de Família", combo_vara);
    addOptionsInFilter("655","8ª Vara de Família", combo_vara);
    addOptionsInFilter("656","9ª Vara de Família", combo_vara);
    addOptionsInFilter("657","10ª Vara de Família", combo_vara);
    addOptionsInFilter("658","11ª Vara de Família", combo_vara);
    addOptionsInFilter("659","12ª Vara de Família", combo_vara);
    addOptionsInFilter("660","13ª Vara de Família", combo_vara);
    addOptionsInFilter("661","14ª Vara de Família", combo_vara);
    addOptionsInFilter("662","15ª Vara de Família", combo_vara);
    addOptionsInFilter("663","16ª Vara de Família", combo_vara);
    addOptionsInFilter("776","17ª Vara de Família", combo_vara);
    addOptionsInFilter("777","18ª Vara de Família", combo_vara);
  }
  if(val == "2"){
    addOptionsInFilter("615","1ª Vara Cível", combo_vara);
    addOptionsInFilter("616","2ª Vara Cível", combo_vara);
    addOptionsInFilter("617","3ª Vara Cível", combo_vara);
    addOptionsInFilter("618","4ª Vara Cível", combo_vara);
    addOptionsInFilter("619","5ª Vara Cível", combo_vara);
    addOptionsInFilter("620","6ª Vara Cível", combo_vara);
    addOptionsInFilter("621","7ª Vara Cível", combo_vara);
    addOptionsInFilter("622","8ª Vara Cível", combo_vara);
    addOptionsInFilter("623","9ª Vara Cível", combo_vara);
    addOptionsInFilter("625","10ª Vara Cível", combo_vara);
    addOptionsInFilter("626","11ª Vara Cível", combo_vara);
    addOptionsInFilter("627","12ª Vara Cível", combo_vara);
    addOptionsInFilter("628","13ª Vara Cível", combo_vara);
    addOptionsInFilter("629","14ª Vara Cível", combo_vara);
    addOptionsInFilter("630","15ª Vara Cível", combo_vara);
    addOptionsInFilter("631","16ª Vara Cível", combo_vara);
    addOptionsInFilter("632","17ª Vara Cível", combo_vara);
    addOptionsInFilter("633","18ª Vara Cível", combo_vara);
    addOptionsInFilter("634","19ª Vara Cível", combo_vara);
    addOptionsInFilter("635","20ª Vara Cível", combo_vara);
    addOptionsInFilter("636","21ª Vara Cível", combo_vara);
    addOptionsInFilter("637","22ª Vara Cível", combo_vara);
    addOptionsInFilter("638","23ª Vara Cível", combo_vara);
    addOptionsInFilter("639","24ª Vara Cível", combo_vara);
    addOptionsInFilter("640","25ª Vara Cível", combo_vara);
    addOptionsInFilter("641","26ª Vara Cível", combo_vara);
    addOptionsInFilter("642","27ª Vara Cível", combo_vara);
    addOptionsInFilter("643","28ª Vara Cível", combo_vara);
    addOptionsInFilter("644","29ª Vara Cível", combo_vara);
    addOptionsInFilter("645","30ª Vara Cível", combo_vara);
    addOptionsInFilter("8609","31ª Vara Cível", combo_vara);
    addOptionsInFilter("8610","32ª Vara Cível", combo_vara);
    addOptionsInFilter("8592","33ª Vara Cível", combo_vara);
    addOptionsInFilter("8594","34ª Vara Cível", combo_vara);
    addOptionsInFilter("8596","35ª Vara Cível", combo_vara);
    addOptionsInFilter("8598","36ª Vara Cível", combo_vara);
    addOptionsInFilter("8600","37ª Vara Cível", combo_vara);
    addOptionsInFilter("8602","38ª Vara Cível", combo_vara);
    addOptionsInFilter("8604","39ª Vara Cível", combo_vara);
  }
  if(val == "3"){
    addOptionsInFilter("574","1ª Vara Criminal", combo_vara);
    addOptionsInFilter("575","2ª Vara Criminal", combo_vara);
    addOptionsInFilter("576","3ª Vara Criminal", combo_vara);
    addOptionsInFilter("577","4ª Vara Criminal", combo_vara);
    addOptionsInFilter("578","5ª Vara Criminal", combo_vara);
    addOptionsInFilter("579","6ª Vara Criminal", combo_vara);
    addOptionsInFilter("580","7ª Vara Criminal", combo_vara);
    addOptionsInFilter("581","8ª Vara Criminal", combo_vara);
    addOptionsInFilter("582","9ª Vara Criminal", combo_vara);
    addOptionsInFilter("492","10ª Vara Criminal", combo_vara);
    addOptionsInFilter("583","11ª Vara Criminal", combo_vara);
    addOptionsInFilter("584","12ª Vara Criminal", combo_vara);
    addOptionsInFilter("585","13ª Vara Criminal", combo_vara);
    addOptionsInFilter("586","14ª Vara Criminal", combo_vara);
    addOptionsInFilter("587","15ª Vara Criminal", combo_vara);
    addOptionsInFilter("2571","16ª Vara Criminal", combo_vara);
    addOptionsInFilter("2572","17ª Vara Criminal", combo_vara);
    addOptionsInFilter("2573","18ª Vara Criminal", combo_vara);
  }
  if(val == "4"){
    addOptionsInFilter("605","1ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("604","2ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("606","3ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("607","4ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("2568","5ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("2569","6ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("2570","7ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("8351","8ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("8352","9ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("8579","10ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("8590","11ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("8580","12ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("8581","13ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("8582","14ª Vara da Fazenda Pública", combo_vara);
    addOptionsInFilter("8583","15ª Vara da Fazenda Pública", combo_vara);
  }
  if(val == "5"){
    addOptionsInFilter("588","1ª Vara do Júri", combo_vara);
    addOptionsInFilter("589","2ª Vara do Júri", combo_vara);
    addOptionsInFilter("590","3ª Vara do Júri", combo_vara);
    addOptionsInFilter("591","4ª Vara do Júri", combo_vara);
    addOptionsInFilter("592","5ª Vara do Júri", combo_vara);
  }
  if(val == "6"){
    addOptionsInFilter("570","1ª Vara da Infância e Juventude", combo_vara);
    addOptionsInFilter("571","2ª Vara da Infância e Juventude", combo_vara);
    addOptionsInFilter("572","3ª Vara da Infância e Juventude", combo_vara);
    addOptionsInFilter("573","4ª Vara da Infância e Juventude", combo_vara);
    addOptionsInFilter("774","5ª Vara da Infância e Juventude", combo_vara);
  }
  if(val == "7"){
    addOptionsInFilter("664","1ª Vara de Sucessões", combo_vara);
    addOptionsInFilter("665","2ª Vara de Sucessões", combo_vara);
    addOptionsInFilter("666","3ª Vara de Sucessões", combo_vara);
    addOptionsInFilter("667","4ª Vara de Sucessões", combo_vara);
    addOptionsInFilter("668","5ª Vara de Sucessões", combo_vara);
  }
  if(val == "8"){
    addOptionsInFilter("8540","1ª Vara de Execução Penal", combo_vara);
    addOptionsInFilter("8541","2ª Vara de Execução Penal", combo_vara);
    addOptionsInFilter("8542","3ª Vara de Execução Penal", combo_vara);
  }
  if(val == "9"){
    addOptionsInFilter("608","1ª Vara de Execuções Fiscais", combo_vara);
    addOptionsInFilter("609","2ª Vara de Execuções Fiscais", combo_vara);
    addOptionsInFilter("610","3ª Vara de Execuções Fiscais", combo_vara);
    addOptionsInFilter("611","4ª Vara de Execuções Fiscais", combo_vara);
    addOptionsInFilter("612","5ª Vara de Execuções Fiscais", combo_vara);
    addOptionsInFilter("8361","6ª Vara de Execuções Fiscais", combo_vara);
  }
  if(val == "10"){
    addOptionsInFilter("8353","1ª Vara de Falência", combo_vara);
    addOptionsInFilter("8354","2ª Vara de Falência", combo_vara);
  }
  if(val == "11"){
    addOptionsInFilter("613","1ª Vara de Registros Públicos", combo_vara);
    addOptionsInFilter("614","2ª Vara de Registros Públicos", combo_vara);
  }
  if(val == "12"){
    addOptionsInFilter("598","1ª Vara de Tóxico", combo_vara);
    addOptionsInFilter("599","2ª Vara de Tóxico", combo_vara);
    addOptionsInFilter("8545","3ª Vara de Tóxico", combo_vara);
  }
  if(val == "13"){
    addOptionsInFilter("603","Vara Única de Auditoria Militar", combo_vara);
  }
  if(val == "14"){
    addOptionsInFilter("6535","Vara Única de Penas Alternativas", combo_vara);
  }
  if(val == "15"){
    addOptionsInFilter("8360","Vara Única de Trânsito", combo_vara);
  }
};
};

function mostrarPopoverTaxa(){
      $(document).on('mouseover', '#popover_taxa', function(){
    $("#popover_taxa").popover('show');
});
  $(document).on('mouseout', '#popover_taxa', function(){
    $('.popover').remove();
});
  $(document).on('mouseover', '#popover_pendentes', function(){
    $("#popover_pendentes").popover('show');
});
  $(document).on('mouseout', '#popover_pendentes', function(){
    $('.popover').remove();
});
$(document).on('mouseover', '#popover_meta', function(){
    $("#popover_meta").popover('show');
});
  $(document).on('mouseout', '#popover_meta', function(){
    $('.popover').remove();
}); 
$(document).on('mouseover', '#popover_meta_ano', function(){
    $("#popover_meta_ano").popover('show');
});
  $(document).on('mouseout', '#popover_meta_ano', function(){
    $('.popover').remove();
}); 
$(document).on('mouseover', '#popover_meta_dia', function(){
    $("#popover_meta_dia").popover('show');
});
  $(document).on('mouseout', '#popover_meta_dia', function(){
    $('.popover').remove();
});

 $(document).on('mouseover', '#question', function(){
     $("#question").popover('show');
 });
  $(document).on('mouseout', '#question', function(){
    $('.popover').remove();
});     
};

function formatarNumeroInteiro(nr) {
  return String(nr)
    .split('').reverse().join('').split(/(\d{3})/).filter(Boolean)
    .join('.').split('').reverse().join('');
};

function mostrarDetalhesTaxa(data_ajax,vara,ano, dias_uteis, metaAtual){
    $("#corpo").empty();
    var html = "";

            html = '<table class="table datatable table-bordered table-hover " width="100%">';
            html += '<tbody>';
            html += '<tr>';
            html += '<td class="col-md-4"> <b><div style="z-index: 9999;" id="popover_taxa" data-toggle="popover" data-content="Taxa de Congestionamento atual " >Taxa ('+ ano +'):</div> </b></td>';
            html += '<td class="col-md-8">'+ parseFloat(data_ajax[data_ajax.length-1].taxa*100).toFixed(2) +'%</td>';
            html += '</tr>';
            html += '<tr>';
            html += '<td>'+ '<b><div style="z-index: 9999;" id="popover_pendentes" data-toggle="popover" data-content="Processos Pendentes atuais ">Processos Pendentes: </div></b>' +'</td>';
            html += '<td style="vertical-align: middle !important;"><a href="#" onclick="mostrarProcessosPendentesNaTaxa()">'+formatarNumeroInteiro(data_ajax[data_ajax.length-1].pendentes)+' Processos</a> </td>';
            html += '</tr>';
            html += '<tr>';
            html += '<td> '+ '<b><div style="z-index: 9999;" id="popover_meta" data-toggle="popover" data-content="Meta definida pelo CNJ conforme portaria.">Meta ('+ano+'): </div></b>' +'</td>';
            html += '<td>'+ metaAtual.toFixed(2) +'%' +'</td>';
            html += '</tr>';
            var meta = data_ajax[data_ajax.length-1].pendentes - (data_ajax[data_ajax.length-1].pendentes * 0.54 / data_ajax[data_ajax.length-1].taxa);
            if(meta > 0){
                html += '<tr>';
                html += '<td>'+ '<b><div style="z-index: 9999;" id="popover_meta_ano" data-toggle="popover" data-content="Quantidade de processos necessários à serem baixados até o final do ano para atingir a meta"> Processos para atingir a meta ('+ ano +'): </div> </b>' +'</td>';
                html += '<td style="vertical-align: middle !important;">'+ formatarNumeroInteiro(meta.toFixed(0)) +' Processos</td>';
                html += '</tr>';
                var qtd_dias_uteis = meta / dias_uteis
                if(meta >= dias_uteis){
                    html += '<tr>';
                    html += '<td>'+ '<b><div style="z-index: 9999;" id="popover_meta_dia" data-toggle="popover" data-content="Quantidade de processos necessários à serem baixados por dia para atingir a meta"> Processos para atingir a meta ('+ ano +'): </div> </b>' +'</td>';
                    html += '<td style="vertical-align: middle !important;">'+ formatarNumeroInteiro(qtd_dias_uteis.toFixed(0)) +' Processos por dia</td>';
                    html += '</tr>';
                }
            } else {
                html += '<tr>';
                html += '<td>'+ '<b><div style="z-index: 9999;" id="popover_meta_ano" data-toggle="popover" data-content="Quantidade de processos necessários à serem baixados até o final do ano para atingir a meta"> Processos para atingir a meta ('+ ano +'): </div> </b>' +'</td>';
                html += '<td style="vertical-align: middle !important;">'+'Meta Atingida.'+'</td>';
                html += '</tr>';
            }

    $("#corpo").append(html);
    $('#modal_titulo_processos_julgados').empty();
    $('#modal_titulo_processos_julgados').append('TAXA DE CONGESTIONAMENTO DO MÊS ATUAL<br/> ' + vara);
    $("#myModal").modal("show");
};
