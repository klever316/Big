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
	            html += '<table class="table datatable table-bordered dataTable no-footer", style="background-color: white">';
	            html += '<tr>';
	            html += '<th>Cód. Fluxo</th>';
	            html += '<th>Cód. Fila</th>';
	            html += '<th>Nome da Fila</th>';
	            html += '<th>Nº do Processo</th>';
	            html += '<th>Data de Entrada</th>';
	            html += '<th>Data de Saída</th>';
	            html += '<th>Horas na Fila</th>';
	            html += '</tr>';
	            data.array.forEach(function(value){
	            html += '<tr>';
	            html += '<td>'+value.cdfluxotrabalho+'</td>';
	            html += '<td>'+value.cdfila+'</td>';
	            html += '<td>'+value.defila+'</td>';
	            html += '<td>'+format(value.nuprocesso,'#######-##.####.#.##.####')+'</td>';
	            var x = new Date(value.dtentrada);
	            html += '<td>'+ x.toLocaleString('pt-BR', { timeZone: 'UTC' }) +'</td>';
	            if(value.dtsaida == null){
	            	html += '<td>'+ 'Nulo' +'</td>'
	            } else {
	            	var y = new Date(value.dtsaida);
	            	html += '<td>'+ y.toLocaleString('pt-BR', { timeZone: 'UTC' }) +'</td>';
	            }
	            html += '<td>'+value.horasfila+'</td>';
	            html += '</tr>';
	            }); 
	            html += '</table>'
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