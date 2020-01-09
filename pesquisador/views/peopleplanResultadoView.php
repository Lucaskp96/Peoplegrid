x<?= headerView() ?>
<link href="<?= CSS ?>/pesquisador/cores.css" rel="stylesheet">
<link href="<?= CSS ?>/legenda.css" rel="stylesheet">
<script src='<?= JS . "/legenda.js" ?>'></script>
<script src='<?= JS . "/pesquisador/algoritmos.js" ?>'></script>
<script src='<?= JS . "/pesquisador/simple_statistics.js" ?>'></script>
<!--https://github.com/chrisveness/geodesy -->
<script src='<?= JS . "/pesquisador/geodesy/vector3d.js" ?>'></script>
<script src='<?= JS . "/pesquisador/geodesy/latlon-ellipsoidal.js" ?>'></script>
<script src='<?= JS . "/pesquisador/geodesy/latlon-vincenty.js" ?>'></script>
<script src='<?= JS . "/pesquisador/geodesy/utm.js" ?>'></script>
<?=path_bread($path_bread);?>

    <?=begin_ToolBar(array('novo','imprimir', 'excluir', 'abrir', 'pesquisar','salvar'));?>
	<?=addButtonToolBar(lang('gerarResultado'), 'gerarResultado()', 'btnGerarResultado', 'ui-icon-document');?>
        <?=addButtonToolBar(lang('exportarSIG'), 'exportar()', 'btnExportar', 'ui-icon-document');?>
        <?=addButtonToolBar(lang('salvarCores'), 'salvarCores()', 'btnSalvarCores', 'ui-icon-document');?>
    <?=end_ToolBar();?>
    <?= warning("aviso", '', false); ?>
    <?=begin_TabPanel();?>
        <?=begin_Tab(lang('questionarioApuracao'));?>
            <?=begin_form('pesquisador/peopleplanResultado/gerarResultado', 'formResultado');?>
                <?=form_hidden('type', 'result');?>
                <!-- pega-se o ponto_sup_lat e ponto_sup_lng, pq o geo_lat e geo_lng são referentes ao centro do mapa -->
                <?= form_hidden('txtPontoSupLat', $questionario->ponto_sup_lat); ?>
                <?= form_hidden('txtPontoSupLng', $questionario->ponto_sup_lng); ?>
                <?=form_label('lblQuestionarioPerguntas', lang('questionarioPerguntas'), 80)?>
                <?=form_combo('cmbQuestionarioPerguntas', $questionarioPerguntas, @$questionarioPerguntas->id, 800, array('align: center'))?>
                <?=new_line()?>
                <?=new_line()?>
                
                <?=form_label('lblNivelEscolaridade', lang('nivelEscolaridade'), 80)?>
                <?=form_combo('cmbNivelEscolaridade', $nivelEscolaridade, @$nivelEscolaridade->id, 200)?>


                <?=form_label('lblRendaFamiliar', lang('rendaFamiliar'), 80)?>
                <?=form_combo('cmbRendaFamiliar', $rendaFamiliar, @$rendaFamiliar->id, 200)?>


                <?=form_label('lblPensouComo', lang('pensouComo'), 80)?>
                <?=form_combo('cmbPensouComo', $pensouComo, @$pensouComo->id, 200)?>

                <?=new_line()?>
                <?=new_line()?>
                
                <?=form_label('lblAlgoritmo', lang('algoritmoClassificacao'), 80)?>
                <?
                        $algortimos = array();
                        array_push($algortimos, array(0,'Intervalos Naturais (Natural Breaks)'));
                        array_push($algortimos, array(1,'Quantidades Iguais'));
                        array_push($algortimos, array(2,'Intervalos Iguais'));
                ?>
                <?=form_combo('cmbAlgoritmo', $algortimos, '', 300)?>
                <?=new_line()?>
                <?=new_line()?>
                <?=new_line()?>
                


                <?=new_line();?>
                <?=new_line();?>
                <?= hr(); ?>
                <?=new_line()?>
                <?=new_line();?>
                <?=new_line();?>


                <?=form_label('lblRetanguloAtivo2', 'Número de Classes', 100);?>
                <div id="sliderClasses" style="width:204px;margin: 6px 10px 0px 0px;float:left"></div>
                <?=form_label('lbltamanhoCelula', ' 2', 200, array('id'=>'numberClasses'));?> 
                <?=new_line()?>


                <?=new_line()?>
                <?=new_line()?>

                
                
            <?=end_form();?>
        <?=end_Tab();?>



        <?=begin_Tab('Cores');?>
            <?=begin_form('pesquisador/peopleplanResultado/salvarCores', 'formCores');?>             
                   <div id="pickers">
                    <div>
                        <?=form_label('lblPensouComo', "Classe 1", 60)?><?=form_label('lblPensouComo', "#", 1)?>
                        <input type="text" class="my_picker" id="picker_1"></input>
                        <?=new_line()?>
                    </div>

                    <div>
                        <?=form_label('lblPensouComo', "Classe 2", 60)?><?=form_label('lblPensouComo', "#", 1)?>
                        <input type="text" class="my_picker" id="picker_2"></input>
                        <?=new_line()?>
                    </div>

                    <div>
                        <?=form_label('lblPensouComo', "Classe 3", 60)?><?=form_label('lblPensouComo', "#", 1)?>
                        <input type="text" class="my_picker" id="picker_3"></input>
                        <?=new_line()?>
                    </div>


                    <div>
                        <?=form_label('lblPensouComo', "Classe 4", 60)?><?=form_label('lblPensouComo', "#", 1)?>
                        <input type="text" class="my_picker" id="picker_4"></input>
                        <?=new_line()?>
                    </div>


                    <div>
                        <?=form_label('lblPensouComo', "Classe 5", 60)?><?=form_label('lblPensouComo', "#", 1)?>
                        <input type="text" class="my_picker" id="picker_5"></input>
                        <?=new_line()?>
                    </div>


                    <div>
                        <?=form_label('lblPensouComo', "Classe 6", 60)?><?=form_label('lblPensouComo', "#", 1)?>
                        <input type="text" class="my_picker" id="picker_6"></input>
                        <?=new_line()?>
                    </div>


                    <div>
                        <?=form_label('lblPensouComo', "Classe 7", 60)?><?=form_label('lblPensouComo', "#", 1)?>
                        <input type="text" class="my_picker" id="picker_7"></input>
                        <?=new_line()?>
                    </div>


                    <div>
                        <?=form_label('lblPensouComo', "Classe 8", 60)?><?=form_label('lblPensouComo', "#", 1)?>
                        <input type="text" class="my_picker" id="picker_8"></input>
                        <?=new_line()?>
                    </div>


                    <div>
                        <?=form_label('lblPensouComo', "Classe 9", 60)?><?=form_label('lblPensouComo', "#", 1)?>
                        <input type="text" class="my_picker" id="picker_9"></input>
                        <?=new_line()?>
                    </div>


                    <div>
                        <?=form_label('lblPensouComo', "Classe 10", 60)?><?=form_label('lblPensouComo', "#", 1)?>
                        <input type="text" class="my_picker" id="picker_10"></input>
                        <?=new_line()?>
                    </div>
                </div>
                <script>
                    var cores = [];
                    cores[0] = "003cff";
                    cores[1] = "4f7fe8";
                    cores[2] = "79c0d4";
                    cores[3] = "45f5b7";
                    cores[4] = "23ff0f";
                    cores[5] = "8cff00";
                    cores[6] = "fffb00";
                    cores[7] = "ffc400";
                    cores[8] = "fa7528";
                    cores[9] = "d40000";
                </script>
                
                <?foreach ($questionario_cores as $value) { ?>
                    <script type="text/javascript">
                        cores[0] = "<?=$value['cor_1']?>";
                        cores[1] = "<?=$value['cor_2']?>";
                        cores[2] = "<?=$value['cor_3']?>";
                        cores[3] = "<?=$value['cor_4']?>";
                        cores[4] = "<?=$value['cor_5']?>";
                        cores[5] = "<?=$value['cor_6']?>";
                        cores[6] = "<?=$value['cor_7']?>";
                        cores[7] = "<?=$value['cor_8']?>";
                        cores[8] = "<?=$value['cor_9']?>";
                        cores[9] = "<?=$value['cor_10']?>";
                    </script>
                <? } ?>                
                       
            <?=end_form();?>
        <?=end_Tab();?>
                    
        <?=begin_Tab(lang('questionarioResultado'));?>
            <?= form_hidden('txtLat', $questionario->geo_lat); ?>
            <?= form_hidden('txtLng', $questionario->geo_lon); ?>
            <?= form_hidden('txtZoom', $questionario->zoom); ?>
            <?= form_hidden('txtQuestionarioId', $questionario->id); ?>
            <?= form_hidden('txtPrecisao', $questionario->precisao); ?>
            <?= form_hidden('txtPontoSupLat', $questionario->ponto_sup_lat); ?>
            <?= form_hidden('txtPontoSupLng', $questionario->ponto_sup_lng); ?>
            <?= form_hidden('txtPontoInfLat', $questionario->ponto_inf_lat); ?>
            <?= form_hidden('txtPontoInfLng', $questionario->ponto_inf_lng); ?>
            <?= form_MapWithMarker('div_map_3','marcador3', $questionario->geo_lat, $questionario->geo_lon, @$questionario->zoom,'1000','600' , true, 3);?> 
            <div id="legenda">
            </div>
        <?=end_Tab();?>
    <?=end_TabPanel();?>


<script>
    var rectArr = [];  
    var defaultClassesNumber = 2;
    var cores_id = "<?=@$questionario_cores[0]['id']?>";
    var numClasses;
    showColors(defaultClassesNumber);
    
    $(document).ready(function() {
        aviso.setMessageWarning('<?= lang('resultadoEtapa1') ?>');
        $("#btnSalvarCores").hide();
        $("#btnGerarResultado").show();        
        $("#btnExportar").show();
        
        /**
         * Inicialização da tab 1 (APURACAO)
         * ============================================ 
         */
        $("#ui-id-2").click(function(){
            aviso.setMessageWarning('<?= lang('resultadoEtapa1') ?>');
            $("#btnGerarResultado").show();
            $("#btnSalvarCores").hide();
            $("#btnExportar").show();
        });
        
        /**
         * Inicialização da tab 2 (CORES)
         * ============================================ 
         */
        $("#ui-id-3").click(function(){
            aviso.setMessageWarning('<?= lang('resultadoEtapa2') ?>');
            $("#btnGerarResultado").hide();
            $("#btnSalvarCores").show();
            $("#btnExportar").hide();
        });
        
        /**
         * Inicialização da tab 3 (RESULTADO)
         * ============================================ 
         */
        $("#ui-id-4").click(function(){
            aviso.setMessageWarning('<?= lang('resultadoEtapa3') ?>');
            $("#btnGerarResultado").hide();
            $("#btnSalvarCores").hide();
            $("#btnExportar").hide();
            $('#div_map_3').css('height', '600px');
            $('#div_map_3').css('width', 'auto');
            google.maps.event.trigger(div_map_3, 'resize');
            form_MapWithMarker_setPosicao($('#txtLat').val(), $('#txtLng').val());
            marcador3.setMap(null);
            deletarGrid();
            if(rectArr.length == 0){
                montarGrid();
            } 
            google.maps.event.trigger(div_map_3, 'resize');
        });
        
        div_map_3.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(document.getElementById('legenda'));
       
        if(numClasses === undefined ){
            numClasses = defaultClassesNumber;
        }
        
    });
    
    
    function exportar(){
        var respostasExportar = [];
        var flag = false;
        deletarGrid();
        montarGrid();        
        var p1 = new LatLon($('#txtPontoSupLat').val(), $('#txtPontoSupLng').val());
        
        $.ajax({
            url:BASE_URL+"/pesquisador/peopleplanResultado/gerarResultado/",
            dataType: "json",
            type:'post',
            data:{
                cmbNivelEscolaridade: $('#cmbNivelEscolaridade').val(),
                cmbRendaFamiliar: $("#cmbRendaFamiliar").val(),
                cmbPensouComo: $("#cmbPensouComo").val(),
                cmbQuestionarioPerguntas: $("#cmbQuestionarioPerguntas").val(),
                type: "export"
            },
            success : 
                function(data){
                    if(data.error != undefined){
                        messageErrorBox(data.error.message, data.error.field);
                    } else {
                        respostasExportar = somatorioCelular(data.respostas);
                        $.ajax({
                            url:BASE_URL+"/pesquisador/peopleplanResultado/exportar/",
                            dataType: "json",
                            type:'post',
                            data:{
                                    distancia: distancia,
                                    altura: altura,
                                    largura: largura,
                                    respostas: respostasExportar,
                                    utmx:p1.toUtm().easting,
                                    utmy:p1.toUtm().northing,
                                    zone:p1.toUtm().zone
                            },
                            success : function(data1){
                                
                                    download(data1.nameFile, data1.content);
                                    
                            },
                            error: function(xhr,ajaxOptions,thrownError){
                                    messageErrorBox("Houve uma falha, tente novamente!");
                            }
                        });    
                    }
            },
            error: 
                function(xhr,ajaxOptions,thrownError){
                    messageErrorBox("Erro");
            }
        });
    }
    
    function download(filename, text) {
        var pom = document.createElement('a');
        pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
        pom.setAttribute('download', filename);

        if (document.createEvent) {
            var event = document.createEvent('MouseEvents');
            event.initEvent('click', true, true);
            pom.dispatchEvent(event);
        } else {
            pom.click();
        }
    }
    
    
    /*
     * 
     * GRID E MAPA
     *=======================================================================================
     *==========  
     */
    
    function form_MapWithMarker_setPosicao($latitude, $longitude) {
        var latlng = new google.maps.LatLng($latitude, $longitude);
        window.marcador3.setPosition(latlng);
        div_map_3.setCenter(latlng);
    }    
    
    /**
    * Cria a grid na tela para o usuário repondente
    * @returns {undefined}
    */
    var largura;
    var altura;
    function montarGrid() {

            var pontoSupEsq = new google.maps.LatLng($('#txtPontoSupLat').val(), $('#txtPontoSupLng').val());
            var precisao = $('#txtPrecisao').val();


            // calcula o tamanho da celula
            var NS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 90);
            var SS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 180);

            calculaDistancia(NS, SS);

            // faz o cálculo para saber quantos quadrados na proporção NS e SS,
            //  é possivel colocar dentro do retângulo definido pelo usuário.
            largura = (Math.abs(($('#txtPontoSupLng').val() - ($('#txtPontoInfLng').val())))) / (NS.lng() - (SS.lng()));
            altura = (Math.abs(($('#txtPontoSupLat').val() - ($('#txtPontoInfLat').val()))) / (NS.lat() - (SS.lat())));
            largura = parseInt(largura);
            altura = parseInt(altura);
            

            for (var i = 0; i < altura; i++) {

                    NE = google.maps.geometry.spherical.computeOffset(NS, i * precisao, 180)
                    SW = google.maps.geometry.spherical.computeOffset(SS, i * precisao, 180)

                    for (var a = 0; a < largura; a++) {
                            var rectangleGrid = new google.maps.Rectangle();
                            var rectOptions = {
                                    strokeColor: "#231E24",
                                    strokeOpacity: 0.5,
                                    strokeWeight: 1,
                                    fillColor: 'transparent',
                                    fillOpacity: 0.00,
                                    map: div_map_3,
                                    bounds: new google.maps.LatLngBounds(SW, NE),
                                    clickable: true
                            };

                            rectangleGrid.setOptions(rectOptions);
                            rectArr.push(rectangleGrid);


                            var SW = google.maps.geometry.spherical.computeOffset(SW, precisao, 90);
                            var NE = google.maps.geometry.spherical.computeOffset(NE, precisao, 90);
                    }
            }
    }
    
    var altura;
    var largura;
    var distancia;
    function calculaDistancia(bound1, bound2){
        distancia = google.maps.geometry.spherical.computeDistanceBetween(
                new google.maps.LatLng(bound1.lat(), bound1.lng()),
                new google.maps.LatLng(bound1.lat(), bound2.lng()));
        return distancia = distancia.toFixed(0);
    }
    
        
    /**
     * Este método tem a função de deletar a grid caso for acionado
     * Tecnicamente ele limpa o array que guarda cada célula da grid. 
     * @returns {undefined}
     */
    function deletarGrid(){       
        while(rectArr.length != 0){
            rectArr.pop().setMap(null);            
        }
    }
    /**
    * limpa a grid caso ela esteja marcada
    * @returns {undefined}
    */
    function limparGrid() {
            for (var i = 0; i < rectArr.length; i++) {
                    if (rectArr[i].get('fillColor') != 'transparent') {
                            var opt = {
                                    fillColor: 'transparent',
                                    fillOpacity: 0.00
                            };
                            rectArr[i].setOptions(opt);
                    }
            }
    }
    
    function gerarResultado(){        
        formResultado_submit();       
    }
    
    function formResultado_callback(data){
        if(data.error != undefined){
                messageErrorBox(data.error.message, data.error.field);
        } else {

            if (data.success != undefined) {
                limparGrid();                
                $("#tab").tabs("option", "active", 2);
                $("#btnGerarResultado").hide();
                $("#btnSalvarCores").hide();
                $('#div_map_3').css('height', '600px');
                $('#div_map_3').css('width', 'auto');
                google.maps.event.trigger(div_map_3, 'resize');
                form_MapWithMarker_setPosicao($('#txtLat').val(), $('#txtLng').val());
                marcador3.setMap(null);
                if(rectArr.length == 0){
                    montarGrid();
                }
                google.maps.event.trigger(div_map_3, 'resize');
                setLegenda(numClasses);
                //console.log(data);
                flagLeg = 1;
                switch($("#cmbAlgoritmo").val()){                    
                    case "0":
                        var rett = naturalBreaks(data.respostas, rectArr, numClasses, cores ); 
                        gerarLegendaNaturalBreaks(numClasses, data.totalRespostas, rett['range']);
                        break;
                    case "1":
                        classes(data.respostas, rectArr, numClasses, cores );
                        gerarLegenda(numClasses,  data.totalRespostas);
                        break;
                    case "2":
                        intervalar(data.respostas, rectArr, numClasses, cores );
                        gerarLegenda(numClasses, data.totalRespostas);
                        break;
                    default:
                        
                }
                
            }          
                 
        }
    }

    
    
    /*
     *=======================================================================================
     *==========  
     */
     
    /*
     * 
     * CORES
     *=======================================================================================
     *==========  
     */
	$("#sliderClasses").slider({
		range: "max",
		min: 1,
		max: 10,
		value: defaultClassesNumber,
		step: 1,
		slide: function( event, ui ) {
			showColors(ui.value);
                        numClasses = ui.value;
			$('#numberClasses').html(' '+ui.value);
		}
	});
        
        function showColors(classes){
            divs = $('#pickers div');
            $.each($('#pickers input'), function( index, value ) {
                $(value).html('');
                if(index < classes){
                    $(value).colpick({
                        layout:'hex',
                        color: cores[index],
                        submit:0,
                        colorScheme:'dark',
                        onChange:function(hsb,hex,rgb,el,bySetColor) {
                            $(el).css('border-color','#'+hex);
                            // Fill the text box just if the color was set using the picker, and not the colpickSetColor function.
                            if(!bySetColor) $(el).val(hex);
                        }
                    }).keyup(function(){
                        $(this).colpickSetColor(this.value);
                       // console.log("aqui");
                    });

                    $(value).css('border-right','20px solid #'+cores[index]);
                    $(divs[index]).css('display','');
                } else {
                        $(divs[index]).css('display','none');
                }
            });
	}

        function salvarCores(){
		cores_to_save = [];
		$.each($('#pickers input'), function( index, value ) {
			cor_hex = rgb2hex($(value).css('border-right-color'));
			if(cor_hex === "000000"){
				cores_to_save[index] = cores[index];
			}else{
				cores_to_save[index] = cor_hex;
			}
		});
		//console.log(cores_to_save);
		$.ajax({
			url:BASE_URL+"/pesquisador/peopleplanResultado/salvarCores/",
			dataType: "json",
			data:{
				id: cores_id,
				questionario_id: '<?=$questionario->id?>',
				cor_1: cores_to_save[0],
				cor_2: cores_to_save[1],
				cor_3: cores_to_save[2],
				cor_4: cores_to_save[3],
				cor_5: cores_to_save[4],
				cor_6: cores_to_save[5],
				cor_7: cores_to_save[6],
				cor_8: cores_to_save[7],
				cor_9: cores_to_save[8],
				cor_10: cores_to_save[9],
			},
			success : function(data){                                
                                cores_id = data.id;
                                //console.log(cores_id);
                                messageBox("<?=lang('registroGravado');?>");
			},
			error: function(xhr,ajaxOptions,thrownError){
				//console.log(xhr);
                                messageErrorBox("Error");
			}
		});
	}
        
        function rgb2hex(rgb){
            rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
            return "" +
             ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
             ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
             ("0" + parseInt(rgb[3],10).toString(16)).slice(-2);
	}
        
    function setLegenda(numClasses){
        switch(numClasses){
            case 1:
                cores[0] = '<?=$value['cor_1']?>';
                break;
            case 2:
                cores[0] = '<?=$value['cor_1']?>';
                cores[1] = '<?=$value['cor_10']?>';
                break;
            case 3:
                cores[0] = '<?=$value['cor_1']?>';
                cores[1] = '<?=$value['cor_5']?>';
                cores[2] = '<?=$value['cor_10']?>';
                break;
            case 4:
                cores[0] = '<?=$value['cor_1']?>';
                cores[1] = '<?=$value['cor_4']?>';
                cores[2] = '<?=$value['cor_6']?>';
                cores[3] = '<?=$value['cor_10']?>';
                break;
            case 5:
                cores[0] = '<?=$value['cor_1']?>';
                cores[1] = '<?=$value['cor_3']?>';
                cores[2] = '<?=$value['cor_5']?>';
                cores[3] = '<?=$value['cor_7']?>';
                cores[4] = '<?=$value['cor_10']?>';
                break;
            case 6:
                cores[0] = '<?=$value['cor_1']?>';
                cores[1] = '<?=$value['cor_3']?>';
                cores[2] = '<?=$value['cor_5']?>';
                cores[3] = '<?=$value['cor_7']?>';
                cores[4] = '<?=$value['cor_9']?>';
                cores[5] = '<?=$value['cor_10']?>';
                break;
            case 7:
                cores[0] = '<?=$value['cor_1']?>';
                cores[1] = '<?=$value['cor_2']?>';
                cores[2] = '<?=$value['cor_3']?>';
                cores[3] = '<?=$value['cor_5']?>';
                cores[4] = '<?=$value['cor_7']?>';
                cores[5] = '<?=$value['cor_9']?>';
                cores[6] = '<?=$value['cor_10']?>';
                break;
            case 8:
                cores[0] = '<?=$value['cor_1']?>';
                cores[1] = '<?=$value['cor_2']?>';
                cores[2] = '<?=$value['cor_3']?>';
                cores[3] = '<?=$value['cor_5']?>';
                cores[4] = '<?=$value['cor_6']?>';
                cores[5] = '<?=$value['cor_7']?>';
                cores[6] = '<?=$value['cor_9']?>';
                cores[7] = '<?=$value['cor_10']?>';
                break;
            case 9:
                cores[0] = '<?=$value['cor_1']?>';
                cores[1] = '<?=$value['cor_2']?>';
                cores[2] = '<?=$value['cor_3']?>';
                cores[3] = '<?=$value['cor_5']?>';
                cores[4] = '<?=$value['cor_6']?>';
                cores[5] = '<?=$value['cor_7']?>';
                cores[6] = '<?=$value['cor_8']?>';
                cores[7] = '<?=$value['cor_9']?>';
                cores[8] = '<?=$value['cor_10']?>';
                break;
            case 10:
                cores[0] = '<?=$value['cor_1']?>';
                cores[1] = '<?=$value['cor_2']?>';
                cores[2] = '<?=$value['cor_3']?>';
                cores[3] = '<?=$value['cor_4']?>';
                cores[4] = '<?=$value['cor_5']?>';
                cores[5] = '<?=$value['cor_6']?>';
                cores[6] = '<?=$value['cor_7']?>';
                cores[7] = '<?=$value['cor_8']?>';
                cores[8] = '<?=$value['cor_9']?>';
                cores[9] = '<?=$value['cor_10']?>';
                break;
            default:
                messageBox("Erro ao setar a legenda.");
        } 
       
   }
    /*
     *=======================================================================================
     *==========  
     */

     
     
     
     
     
    
</script>    

<?= footerView() ?>