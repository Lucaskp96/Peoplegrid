<?= headerView() ?>
    <?=path_bread($path_bread);?>
    <?=begin_ToolBar(array('novo','imprimir', 'abrir', 'pesquisar'));?>
	<?=addButtonToolBar('Nova Pergunta', 'novaPergunta()', 'btnNovaPergunta', 'ui-icon-document');?>
    <?=end_ToolBar();?>
    
    <?= warning("aviso", '', false); ?>

    <?=begin_TabPanel();?>
<!--
    Aba do Questionário
=====================================================================================
===================================================================================== 
-->
            <?=begin_Tab(lang('questionario'));?>
                    <?=begin_form('pesquisador/questionario/salvarQuestionario', 'formQuestionario');?>
                        <?=form_hidden('txtId', @$questionario->id);?>
                        <?=form_hidden('txtPessoaId', @$questionario->pessoa_id);?>
                        <?=form_hidden('txtAtivoPeloAdm', @$questionario->ativo_pelo_adm);?>
                        

                        <?=form_label('lblDescricao', lang('questionarioDescricao'), 100);?>
                        <?=form_textField('txtDescQuestionario', @$questionario->descricao, 500, '');?>
                        <?=new_line();?>

                        <?=form_label('lblDtIncio', lang('questionarioDtInicio'), 100);?>
                        <?=form_dateField('dtInicio', @$questionario->dt_inicio);?>
                        <?=new_line();?>

                        <?=form_label('lblDtFim', lang('questionarioDtFim'), 100);?>
                        <?=form_dateField('dtFim', @$questionario->dt_fim);?>
                        <?=new_line();?>
                        
                        


                <?=end_form();?>
            <?=end_Tab();?>

<!--
    Aba de Posicionamento da Cidade
=====================================================================================
===================================================================================== 
-->
            <?=begin_Tab("Local da Pesquisa");?>        
                <?=begin_form('pesquisador/questionario/salvarReferenciaMapa', 'formMapa');?>
                    <?=form_label('lblLong', 'Botões', 80);?>

                        <?=new_line();?>
                        <?= hr(); ?>
                        <?=form_hidden('txtIdQuestionarioReferencia', @$questionario->id);?>
                        <?=form_hidden('txtLat', @$questionario->geo_lat);?>
                        <?=form_hidden('txtLng', @$questionario->geo_lon);?>
                        <?=form_hidden('txtZoom', @$questionario->zoom);?>
                        <?=new_line()?>

                        <?=form_button('btnCentralizarMarcador', 'Centralizar Marcador', 'centralizarMarcador()')?>
                        <?=new_line()?>

                        <?=new_line();?>
                        <?= hr(); ?>
                        <?=new_line();?>

                        <?=form_label('lblLong', 'Mapa', 80);?>
                        <?=form_MapWithMarker('div_map_1','marcador1', '', '', @$questionario->zoom,'1000','600',  true, 1);?>
                
                <?=end_form();?>
            <?=end_Tab();?>

<!--
    Aba de Utilização da Grid
=====================================================================================
===================================================================================== 
-->
            <?=begin_Tab("Criar Grid");?>
                <?=begin_form('pesquisador/questionario/salvarGrid', 'formGrid');?>

                        <?=form_label('lblRetanguloAtivo2', 'Precisão', 100);?>
                        <div id="sliderPrecisao" style="width:600px;margin-top: 6px;float:left"></div>
                        <?=form_label('lbltamanhoCelula', 'Tamanho da célula: ', 200, array('id'=>'tamanhoCelula'));?> 
                        
                        <?=form_hidden('txtIdQuestionarioGrid', @$questionario->id);?>
                        <?=form_hidden('txtPrecisao', @$questionario->precisao);?>
                        <?=form_hidden('txtPontoSupLat', @$questionario->ponto_sup_lat);?>
                        <?=form_hidden('txtPontoSupLng', @$questionario->ponto_sup_lng);?>
                        <?=form_hidden('txtPontoInfLat', @$questionario->ponto_inf_lat);?>
                        <?=form_hidden('txtPontoInfLng', @$questionario->ponto_inf_lng);?>
                           
                        <?=new_line();?>
                        <?=new_line();?>
                        
                        <?=form_label('lblRetanguloAtivo', lang('retanguloAtivo'), 100, array('for'=>'chkRetanguloAtivo'));?>
                        <?=form_checkbox('chkRetanguloAtivo', 'chkRetanguloAtivo', 'S',true,'','','','','habilitarRetangulo()');?>
                        <?=new_line();?>
                        <?=new_line();?>
                        
                        <?=form_button('btnGerarGrid', 'Gerar Grid', 'setLatLng()', 200)?>
                        <?=form_button('btnResetarGrid', 'Resetar Grid', 'deletarGrid()', 200)?>
                        <?=form_button('btnResetarRetangulo', 'Resetar Retângulo', 'resetarRetangulo()', 200)?>
                        
                        
                        <?=new_line()?>
                        

                        <?=new_line();?>
                        <?= hr(); ?>
                        <?=new_line();?>

                        <?=form_label('lblLong', 'Mapa', 80);?>
                        <?=form_MapWithMarker('div_map_2','marcador2', '', '', '','1000','600' , false, 2);?>
                <?=end_form();?>
            <?=end_Tab();?>
<!--
    Aba de Perguntas
=====================================================================================
=====================================================================================		

-->
<!--
    Aba de Perguntas NOVA
=====================================================================================
===================================================================================== 
-->
            <?=begin_Tab(lang('questionarioPerguntasGrid'));?>
                <style>
                    #lista1, #lista2 {
                        border: 1px solid #eee;
                        width: 142px;
                        min-height: 20px;
                        list-style-type: none;
                        margin: 0;
                        padding: 5px 0 0 0;
                        float: left;
                        margin-right: 10px;
                    }
                    #lista1 li, #lista2 li {
                        margin: 0 5px 5px 5px;
                        padding: 5px;
                        font-size: 1.2em;
                        width: auto;
                    }
                </style>
                <h2 style="text-align: center"> <?= lang('questionarioPerguntasAviso')?></h2>
                    
                <?=new_line();?>
                <?= hr(); ?>
                <?=new_line()?>
                <?=begin_form('pesquisador/questionario/salvarPerguntasQuestionario', 'formPerguntas');?>
                    <?=form_hidden('txtPessoaId', @$questionario->pessoa_id);?>
                    <?=form_hidden('txtIdQuestionarioPerguntas', @$questionario->id);?>
                    <?=form_hidden('txtPerguntas','');?>
                    <?=form_hidden('txtFlag','0');?>
                    <?php
                    echo "<div>".
                            "<div  class= '#lista1' style=' width: 45%; float: left; margin-top: -14px;'>".
                                '<h2 style="text-align:center">'.  lang('questionarioPerguntasDisponiveis')  .'</h2>'.
                            "</div>".
                            "<div  class= '#lista2' style='width: 45%; float: right; margin-top: -14px;'>".
                                '<h2 style="text-align:center margin-left:-20px">' .lang('questionarioPerguntasPresentes'). '</h2>'.
                            "</div>".
                        "</div>".
                    '<div class="#lista1">'.
                    '<ul id="lista1" class="connectedSortable" style="cursor:move; width:45%; ">';
                    foreach($perguntas as $p){
                            echo '<li id="' . $p->id . '" class="ui-state-default" style="width:auto">'. $p->descricao .' </li>';
                    }
                        echo '</ul>'.
                    '</div>'.

                    '<div class="#lista2">'.

                    '<ul id="lista2" class="connectedSortable" style="cursor:move; width:45%;min-height:120px ">';
                        
                        if(isset($perguntasQuestionario)){
                            foreach($perguntasQuestionario as $pq){
                                echo '<li id="' . $pq->pergunta_grid_id . '" class="ui-state-highlight" style="width:auto; background:#ddd; font-weight:bold;color:#ff0084">'. $pq->descricao .' </li>';
                            }
                        }
                        echo '</ul>'.
                    '</div>';
                    ?>        

                <?=end_form();?>
            <?=end_Tab();?>
                
            <?=begin_Tab(lang('abaQuestionarioAtivo'));?>
                <?=begin_form('pesquisador/questionario/salvarQuestionarioAtivo', 'formQuestionarioAtivo');?>
                    <?=form_label('lblQuestionarioAtivo', lang('questionarioAtivo'), 100)?>
                    <?=form_hidden('txtIdAtivo', @$questionario->id);?>
                    <?=form_hidden('txtPessoaId', @$questionario->pessoa_id);?>
                    <?=form_hidden('txtAtivoPeloAdm', @$questionario->ativo_pelo_adm);?>

                    <?
                        $ativo = array();
                        array_push($ativo, array(0,'Não'));
                        array_push($ativo, array(1,'Sim'));

                        if(@$questionario->ativo_pelo_pesquisador === 'S'){
                            $ativoResp = 1;
                        } else {
                            $ativoResp = 0;
                        }
                    ?>

                    <?=form_combo('cmbAtivo', $ativo, @$ativoResp, 80,'')?>
                <?=end_form();?>
            <?=end_Tab();?>
                
	<?=end_TabPanel();?>


<script>
    var rectArr=[];
    var rectangle = null;
    var estadoInicialReferenciaMapa;
    var estadoInicialPerguntas;
    var estadoInicialGridMapa;
/**
 ****
 * Inicialização da página
 *=================================================================================================
 *=================================================================================================
 */ 
    function verificaAbas(){
        
        // verifica aba 1 (QUESTIONARIO)
        if ($('#txtId').val() === '') {
            $("#tab").tabs( "option", "disabled", [1, 2, 3, 4]);
            aviso.setMessageWarning('<?= lang('questionarioEtapa1') ?>');
            $("#btnNovaPergunta").hide();                        
        } else {
            
            if( ($("#txtAtivoPeloAdm").val() === 'N') || ( $("#cmbAtivo").val() === '0') ){
                
                // verifica aba 2 (REFERENCIA MAPA)
                if(($('#txtLat').val() === '') || ( $('#txtLng').val() === '') || ( $('#txtZoom').val() === '')){
                    $("#tab").tabs( "option", "disabled", [2, 3, 4]);
                    console.log("2, 3 e 4");
                    deletarGrid();
                    google.maps.event.trigger(div_map_2, 'resize');
                    $('#txtPrecisao').val('');
                    $('#txtPontoSupLng').val('');
                    $('#txtPontoSupLat').val('');
                    $('#txtPontoInfLat').val('');
                    $('#txtPontoInfLng').val('');
                } else {
                   // verifica a aba 3 (MONTAGEM DA GRID)
                   if(( $('#txtPrecisao').val() === '') || ($('#txtPontoSupLng').val() === '') || ( $('#txtPontoSupLat').val() == '')
                        || ($('#txtPontoInfLng').val() === '') || ( $('#txtPontoInfLat').val() === '')){
                        deletarGrid();
                        google.maps.event.trigger(div_map_2, 'resize');
                        $("#tab").tabs( "option", "disabled", [3, 4]);
                        console.log("3 e 4");
                    } else {
                        console.log("aqui");
                        $("#tab").tabs( "option", "disabled", []);
                    } 

                }
            } else {
                console.log("aqui no final");
                $("#tab").tabs( "option", "disabled", [1, 2, 3]);
            }
            
        }
    }


    $(document).ready(function(){
        verificaAbas();
        aviso.setMessageWarning('<?= lang('questionarioEtapa1') ?>');
        $("#btnNovaPergunta").hide();
        $("#ui-id-2").click(function(){         
            
            aviso.setMessageWarning('<?= lang('questionarioEtapa1') ?>');
            $("#btnNovaPergunta").hide();
        });
            
        $("#ui-id-3").click(function(){
            $("#btnNovaPergunta").hide();
            estadoInicialReferenciaMapa = $('#txtLat').val();
            $('#txtIdQuestionarioReferencia').val($('#txtId').val());
            aviso.setMessageWarning('<?= lang('questionarioEtapa2') ?>');
            google.maps.event.trigger(div_map_1, 'resize');
            centralizarMarcador();
            google.maps.event.trigger(div_map_1, 'resize');

        });
        
        $("#ui-id-4").click(function(){            
            $("#btnNovaPergunta").hide();
            $('#txtIdQuestionarioGrid').val($('#txtId').val());
            estadoInicialGridMapa = $('#txtPontoSupLng').val();
            console.log(estadoInicialGridMapa);
            aviso.setMessageWarning('<?= lang('questionarioEtapa3') ?>');
            centralizarMarcador();
            google.maps.event.trigger(div_map_2, 'resize');
            marcador2.setMap(null);
            div_map_2.setCenter(div_map_1.getCenter());
            validaZoom();
            div_map_2.setZoom(div_map_1.getZoom());
            google.maps.event.trigger(div_map_2, 'resize');
            inicializarAbaGrid();
            google.maps.event.trigger(div_map_2, 'resize');
            $(function() {
                var minMax = getMinMax();
                var NS, SS, precisao, pontoSupEsq;

                if($('#txtPrecisao').val() == ''){
                    $('#txtPrecisao').val(minMax.max);
                } else {
                    // pega o ponto superior e inferior
                    pontoSupEsq = new google.maps.LatLng($('#txtPontoSupLat').val(), $('#txtPontoSupLng').val());
                    // pega a precisão para gerar o tamanho da celula
                    precisao = $('#txtPrecisao').val();
                    // calcula o tamanho da celula
                    NS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 90);
                    SS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 180);
                    $('#tamanhoCelula').text("Tamanho da célula: "+ calculaDistancia(NS,SS) +" m");
                }
                $("#sliderPrecisao").slider({
                    
                    range: "min",
                    min: minMax.min,
                    max: minMax.max,
                    value: $('#txtPrecisao').val(),
                    step: 5,
                    slide: function( event, ui ) {
                        // pega o ponto superior e inferior
                        pontoSupEsq = new google.maps.LatLng($('#txtPontoSupLat').val(), $('#txtPontoSupLng').val());
                        // pega a precisão para gerar o tamanho da celula
                        //console.log(precisao);
                        $("#txtPrecisao").val(ui.value);
                        precisao = $("#txtPrecisao").val();
                        // calcula o tamanho da celula
                        NS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 90);
                        SS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 180);
                        $('#tamanhoCelula').text("Tamanho da célula: "+calculaDistancia(NS,SS)+" m");
                    }
                });
            });
        });
        $("#ui-id-5").click(function(){
          $("#btnNovaPergunta").show();
                $('#txtIdQuestionarioPerguntas').val($('#txtId').val());

                $(function() {
                    $( "#lista1, #lista2" ).sortable({
                        connectWith: ".connectedSortable"
                    }).disableSelection();
                });
                aviso.setMessageWarning('<?= lang('questionarioEtapa4') ?>');
                estadoInicialPerguntas = $( "#lista2" ).sortable( "toArray" );
                
        });
        $("#ui-id-6").click(function(){
            $('#txtIdAtivo').val($('#txtId').val());
            aviso.setMessageWarning('Esta aba ativa ou desativa o seu questionário.');                
        });
    });
    
    div_map_1.addEventListener( 'mousewheel', wheelEvent, true );
    div_map_1.addEventListener( 'DOMMouseScroll', wheelEvent, true );
    div_map_1.addEventListener('mouseover', mouseoverEvent, true);
    
    function wheelEvent(event) {
        $('#txtZoom').val(div_map_1.getZoom());
    }
    
    function mouseoverEvent(event){
        $('#txtZoom').val(div_map_1.getZoom());
    }
    
    function enableTabs($tab){      

        switch($tab){
            case 1:
                
                if(($('#txtLat').val() === '') || ( $('#txtLng').val() === '') || ( $('#txtZoom').val() === '')
                    || ( $('#txtPrecisao').val() === '') || ($('#txtPontoSupLng').val() === '') || ( $('#txtPontoSupLat').val() == '')
                    || ($('#txtPontoInfLng').val() === '') || ( $('#txtPontoInfLat').val() === '')){
                    $('#tab').tabs("option","disabled",[2, 3, 4]);
                    google.maps.event.trigger(div_map_1, 'resize');
                    google.maps.event.trigger(div_map_2, 'resize');
                } else {
                    $('#tab').tabs("option","disabled",[]);
                    google.maps.event.trigger(div_map_1, 'resize');
                    google.maps.event.trigger(div_map_2, 'resize');
                }
                verificaAbas();
                break;
            case 2:
                $('#tab').tabs("option","disabled",[3, 4]);
                google.maps.event.trigger(div_map_1, 'resize');
                google.maps.event.trigger(div_map_2, 'resize');
                break;
            case 3:
                $('#tab').tabs("option","disabled",[4]);
                
                google.maps.event.trigger(div_map_1, 'resize');
                google.maps.event.trigger(div_map_2, 'resize');
                break;
            
            case 4:
                $('#tab').tabs("option","disabled",[]);
                
                google.maps.event.trigger(div_map_1, 'resize');
                google.maps.event.trigger(div_map_2, 'resize');
                break;
            } 
    }
    
    function inicializarAbaGrid(){
        if( ($('#txtPrecisao').val() != '') &&
            ($('#txtPontoSupLat').val() != '') && ($('#txtPontoSupLng').val() != '') && 
            ($('#txtPontoInfLat').val() != '') && ($('#txtPontoInfLng').val() != '')) {
            
            if(rectArr.length !== 0){
                deletarGrid();
            }
            gerarGrid();

        } else {
            if(rectangle === null){
                criarRetangulo();
            } else {
                resetarRetangulo();
            }
        }
    }
    
    function novaPergunta(){
        
        location.href = BASE_URL+'pesquisador/pergunta/novo';
    }
    
/*
 *=================================================================================================
 *================================================================================================= 
 *=================================================================================================
 */
    
    /**
     ****
     * Aba Questionario
     * =============================================================================================
     * =============================================================================================
     */
    
    function novo(){
        location.href = BASE_URL+'pesquisador/questionario/novo';
    }
    
    function salvar(){
        switch($("#tab").tabs("option", "active")){
            case 0:
                formQuestionario_submit();
                break;
            case 1:
                centralizarMarcador();
                if(estadoInicialReferenciaMapa === ''){
                    salvarMapa(true);
                } else {                    
                    messageConfirm('<?= lang('avisoReferenciaMapa') ?>', salvarMapa);
                }
                break;
            case 2:
                 if(estadoInicialGridMapa === '') {
                    salvarGrid(true)
                } else {
                    messageConfirm('<?= lang('avisoGridMapa') ?>', salvarGrid);
                }
                
                break;
            case 3:
                
                $('#txtPerguntas').val($( "#lista2" ).sortable( "toArray" ));
                console.log($('#txtPerguntas').val());
                if(validaEstadoInicialPerguntas()){
                    messageConfirm('<?= lang('avisoPerguntas') ?>', salvarPerguntas);    
                } else {
                    $('#txtFlag').val('1');
                    salvarPerguntas(true);
                }
                
                break;
                
            case 4:
                formQuestionarioAtivo_submit();
                break;
        }
    }
    
        
    function excluir(){
        if ($('#txtId').val() == '') {
            messageErrorBox("<?= lang('nenhumRegistroSelecionado') ?>");
        } else {
            messageConfirm('<?= lang('excluirQuestionarioAviso') ?>', excluirQuestionario);
        }
    }

    function excluirQuestionario(confirmaExclusao){
        if (confirmaExclusao) {
            $.post(BASE_URL+'pesquisador/questionario/excluir', {questionarios: $("#txtId").val()},
            function(data){
                if (data.success) {
                    messageBox("<?= lang('registroExcluido') ?>", filtro);
                } else {
                    messageErrorBox("<?= lang('registroNaoExcluido') ?>");
                }
            });
        }
    }
    
    
    function validaEstadoInicialPerguntas(){
        var temp = $( "#lista2" ).sortable( "toArray" );
        if(estadoInicialPerguntas.length === 0){
            return false;
        } else {
            for(var i = 0; i < temp.length; i++){
                if($.inArray(estadoInicialPerguntas[i], temp) === -1){
                    return true;
                }   
            }
            return false;
        }        
    }
    
    function salvarMapa(confirmaSalvar){
        if(confirmaSalvar){
            formMapa_submit();    
        }
        
    }
    
    function formQuestionario_callback(data){
        if(data.error != undefined){
            messageErrorBox(data.error.message, data.error.field);
        } else {
            if (data.success != undefined) {
                $('#txtId').val(data.questionario.id);
                $('#txtAtivoPeloAdm').val(data.questionario.ativo_pelo_adm);
                messageBox(data.success.message, enableTabs(1));
                
            }
        }
    }
    
    function formQuestionarioAtivo_callback(data){
        if(data.error != undefined){
            messageErrorBox(data.error.message, data.error.field);
        } else {
            if (data.success != undefined) {
                $('#txtId').val(data.questionario.id);
                $('#txtAtivoPeloAdm').val(data.questionario.ativo_pelo_adm);
                if(data.questionario.ativo_pelo_pesquisador == 'S'){
                    messageBox(data.success.message, filtro);
                } else {
                    messageBox(data.success.message, enableTabs(1));
                    
                }
                                
            }
        }
    }
    
    function formMapa_callback(data){       
        
        if(data.error != undefined){
            messageErrorBox(data.error.message, data.error.field);
        } else {
            if (data.success != undefined) {
                messageBox(data.success.message, enableTabs(2));
                /*
                $('#txtPrecisao').val('0');
                $('#txtPontoSupLng').val('0');
                $('#txtPontoSupLat').val('0');
                $('#txtPontoInfLat').val('0');
                $('#txtPontoInfLng').val('0');
                */
                deletarGrid();
                resetarRetangulo();
            }
        }
    }


    
/*
 *=================================================================================================
 *================================================================================================= 
 *=================================================================================================
 */    
    
    
        
    /**
     ****
     * Aba Local da Pesquisa
     * =============================================================================================
     * =============================================================================================
     */
    
    function getZoom(){
        $('#txtZoom').val(div_map_1.getZoom());
    }
      
    function centralizar($latitude,$longitude){
        
        var latlng = new google.maps.LatLng($latitude, $longitude);
        div_map_1.setCenter(latlng);
    }
    
    function centralizarMarcador(){
        validaZoom();
        if(($('#txtLat').val() === '') && ($('#txtLng').val() === '')){
            $('#txtLat').val('-31.747578731227637');
            $('#txtLng').val('-52.32838670702267');
        }
        
        form_MapWithMarker_setPosicao($('#txtLat').val(), $('#txtLng').val());
    }
    
    function form_MapWithMarker_position(lat,longi){
            $('#txtLat').val(lat);
            $('#txtLng').val(longi);
            $('#txtZoom').val(div_map_1.getZoom());
            div_map_2.setCenter(div_map_1.getCenter());
            div_map_2.setZoom(div_map_1.getZoom());
    }
    
    function form_MapWithMarker_setPosicao($latitude, $longitude) {
        var latlng = new google.maps.LatLng($latitude, $longitude);
        window.marcador1.setPosition(latlng);
        div_map_1.setCenter(latlng);
    }    
    
    function validaZoom(){
        if($('#txtZoom').val() === ''){
            $('#txtZoom').val(12);
            div_map_1.setZoom(12);
        }
        if($('#txtZoom').val() > 18){
            messageErrorBox("<?= lang('questionarioZoomAlto') ?>");
            div_map_1.setZoom(18);
        }
        if($('#txtZoom').val() < 7){
            messageErrorBox("<?= lang('questionarioZoomBaixo') ?>");
            div_map_1.setZoom(7);
        }
        $('#txtZoom').val(div_map_1.getZoom());
    }
    
    
/*
 *=================================================================================================
 *================================================================================================= 
 *=================================================================================================
 */    
    
    
        
    /**
     ****
     * Aba Criar Grid
     * =============================================================================================
     * =============================================================================================
     */
    
    /**
     * Este metodo salva a grid criada
     * Funcionamento: Quando se gera a grid automaticamente a função cadastra 
     * os pontos de latitude e longitude da diagonal, portanto salvando o estado da grid.
     * 
     * @returns {undefined}
     */
    function salvarGrid(confirmaSalvar){
    
        if(confirmaSalvar){
            if(rectArr.length != 0){
                if(rectArr.length < 9){
                    messageErrorBox("<?= lang('questionarioMenosDeNoveCelulas') ?>");
                } else {


                    formGrid_submit();
                }

            } else {
                messageErrorBox("<?= lang('questionarioNaoGerouGrid') ?>");
                return 0;
            }
        }
    
        
    }
    

    
    /**
     * Este metodo retorna ao usuário o resultado do metodo salvar.
     * caso erro ele retorna uma mensagem.
     * caso verdadeiro ele retorna uma mensagem de sucesso.
     * @returns {undefined}
     */
    function formGrid_callback(data){
        console.log(data);
        if(data.error != undefined){
            messageErrorBox(data.error.message, data.error.field);
        } else {
            if (data.success != undefined) {
                messageBox(data.success.message, enableTabs(3));
            }
        }
        
    }
    
    function getMinMax(){

          var minMax;

          switch($('#txtZoom').val()){
              case '7':
                  minMax = {min: 10000, max: 200000}
                  return minMax;
                  break;
              case '8':
                  minMax = {min: 5000, max: 100000}
                  return minMax;
                  break;
              case '9':
                  minMax = {min: 3000, max: 50000}
                  return minMax;
                  break;
              case '10':
                  minMax = {min: 1500, max: 40000}
                  return minMax;
                  break;
              case '11':
                  minMax = {min: 200, max: 20000}
                  return minMax;
                  break;
              case '12':
                  minMax = {min: 150, max: 10000}
                  return minMax;
                  break;
              case '13':
                  minMax = {min: 125, max: 5000}
                  return minMax;
                  break;
              case '14':
                  minMax = {min: 100, max: 2500}
                  return minMax;
                  break;
              case '15':
                  minMax = {min: 50, max: 1250}
                  return minMax;
                  break;
              case '16':
                  minMax = {min: 25, max: 500}
                  return minMax;
                  break;
              case '17':
                  minMax = {min: 15, max: 400}
                  return minMax;
                  break;
              case '18':
                  minMax = {min: 10, max: 300}
                  return minMax;
                  break;
          }
          return false;
    }

    
    /**
     * Habilita a visibilidade do retangulo construtor de grid's
     * Esta função manupila o valor da checkbox:chkRetanguloAtivo]
     * @returns {Boolean}
     */
    function habilitarRetangulo(){
        
        if(rectangle === null){
            criarRetangulo();
        } else {
        
            if($('#chkRetanguloAtivo').val() ==  'S'){
                $('#chkRetanguloAtivo').val('N');
                $('#chkRetanguloAtivo').attr('checked', false);
               rectangle.setVisible(false);
            } else {
                $('#chkRetanguloAtivo').val('S');
                $('#chkRetanguloAtivo').attr('checked', true);
                rectangle.setVisible(true);
            }
        }
        
    }
    
    /**
     * Função verifica se o retangulo está ativado, em determinadas situações
     * é necessário que o retângulo esteja ativo, caso não esteja a função
     * retorna uma mensagem de aviso.
     * @returns {true OR false}
     */
    function validaRetangulo(){
        if($('#chkRetanguloAtivo').val() == 'N'){
            messageBox('<?= lang('questionarioNaoHabilitouRetangulo') ?>');
            return false;
        }
        return true;
    }
    
    /**
     * Este método tem a função e criar um retângulo dentro do mapa. 
     * SOBRE O RETÂNGULO:
     *  O retângulo é editavel e disponibiliza a delimitação da área que será 
     *  gerada a grid.
     *  Inicialmente conforme o zoom o retângulo terá um tamanho na disposição 
     *  do mapa, é necessário este controle porque dependendo do zoom o retângulo
     *  pode ou desaparecer da tela, por ser muito pequeno, ou ficar fora dos limites
     *  por ser muito grande.
     * 
     * @returns {undefined}
     */
    function criarRetangulo(){
        var pontoRetangulo;
        if(div_map_2.getZoom() > 16){
            pontoRetangulo = 0.0005;
        } else { 
            if(div_map_2.getZoom() > 14){
                pontoRetangulo = 0.005;
            } else {    
                if(div_map_2.getZoom() > 11){
                    pontoRetangulo = 0.01;
                } else {
                    if(div_map_2.getZoom() > 8) {
                        pontoRetangulo = 0.1;
                    } else {  
                        pontoRetangulo = 1;
                    }
                }
            }
        }
        var bounds;
        if( ($('#txtPontoSupLat').val() != '') && ($('#txtPontoSupLng').val() != '') && 
            ($('#txtPontoInfLat').val() != '') && ($('#txtPontoInfLng').val() != '')) {
            bounds = new google.maps.LatLngBounds(
                new google.maps.LatLng($('#txtPontoSupLat').val(), $('#txtPontoSupLng').val()),
                new google.maps.LatLng($('#txtPontoInfLat').val(), $('#txtPontoInfLng').val())
            );
        } else {
            bounds = new google.maps.LatLngBounds(
                new google.maps.LatLng(div_map_2.getCenter().lat(), div_map_2.getCenter().lng()),
                new google.maps.LatLng(div_map_2.getCenter().lat()+pontoRetangulo, div_map_2.getCenter().lng()+pontoRetangulo)
            );
        }
        
        // Define the rectangle and set its editable property to true.
        rectangle = new google.maps.Rectangle({
            bounds: bounds,
            editable: true,
            draggable: false
        });
        
        rectangle.setMap(div_map_2);
        google.maps.event.addListener(rectangle, 'bounds_changed',posicaoRetangulo); 
    }
    
    /**
     * Este método tem a função de resetar o retângulo dentro do mapa retornando
     * os valores referentes ao zoom.
     * 
     * @returns {undefined}
     */
    function resetarRetangulo(){
        var pontoRetangulo;
        if(div_map_2.getZoom() > 14){
            pontoRetangulo = 0.005;
        } else {    
            if(div_map_2.getZoom() > 11){
                pontoRetangulo = 0.01;
            } else {
                if(div_map_2.getZoom() > 8) {
                    pontoRetangulo = 0.1;
                } else {  
                    pontoRetangulo = 1;
                }
            }
        }
        var bounds = new google.maps.LatLngBounds(
            new google.maps.LatLng(div_map_2.getCenter().lat(), div_map_2.getCenter().lng()),
            new google.maps.LatLng(div_map_2.getCenter().lat()+pontoRetangulo, div_map_2.getCenter().lng()+pontoRetangulo)
        );
        rectangle.setBounds(bounds);
        rectangle.setMap(div_map_2);
        google.maps.event.addListener(rectangle, 'bounds_changed',posicaoRetangulo); 
    }
    
    /**
     * Este método tem a função de atualizar os valores de latitude e longitude
     * do retângulo, quando o usuário manipula para a criação da grid.
     * Conforme o evento de mudança da posição dos pontos de latitude e longitude
     * este metodo atualiza os pontos nos campos escondidos existentes no formulário.
     *   
     * @param {type} event
     * @returns {undefined}
     */
    function posicaoRetangulo(event){
        var ne = rectangle.getBounds().getNorthEast();
        var sw = rectangle.getBounds().getSouthWest();
        
        $('#txtPontoSupLat').val(ne.lat());
        $('#txtPontoSupLng').val(sw.lng());
        $('#txtPontoInfLat').val(sw.lat());
        $('#txtPontoInfLng').val(ne.lng());
        
    }
    
    /**
     * Este método tem a função de setar os pontos em 3 situações
     * Situação 1: 
     *  Se os valores do retângulo estão diferentes dos valores nos 
     *   campos de txt, ou seja, se o usuário modificou o tamanho da grid. esta 
     *   função atualiza os campos de txt antes de gerar a grid. 
     * 
     * Situação 2:
     *  Se os valores dos campos de txt estão em branco, ou seja, o usuário 
     *   ainda não criou a grid ele seta os valores para gera a grid. 
     * 
     * Situação 3: 
     *  Se o usuário muda somente a precisão e não muda os pontos, é uma situação 
     *   que necessita tratar diferente por causa da inversão dos pontos na criação
     *   da grid.
     *   Exemplo:
     *   ** O google maps disponibiliza a diagonal da forma tradicional como esta:
     *   
     *       |  /
     *       | /
     *       |/___
     * 
     * Porém para a montagem da grid é necessário inverter os pontos e criar uma
     * da seguinte forma:
     * 
     *       |\
     *       | \ 
     *       |__\__
     *      
     *        
     * @returns {Boolean}
     */
    function setLatLng(){
        var ne = rectangle.getBounds().getNorthEast();
        var sw = rectangle.getBounds().getSouthWest();
        
        if( ($('#txtPontoSupLat').val() != ne.lat()) && ($('#txtPontoSupLng').val() != ne.lng()) && 
            ($('#txtPontoInfLat').val() != sw.lat()) && ($('#txtPontoInfLng').val() != sw.lng())) {
            if(($('#txtPontoSupLat').val() === '')){
                $('#txtPontoSupLat').val(ne.lat());
                $('#txtPontoSupLng').val(sw.lng());
                $('#txtPontoInfLat').val(sw.lat());
                $('#txtPontoInfLng').val(ne.lng());
            }
        } else {
            $('#txtPontoSupLat').val(ne.lat());
            $('#txtPontoSupLng').val(sw.lng());
            $('#txtPontoInfLat').val(sw.lat());
            $('#txtPontoInfLng').val(ne.lng());
        }
        
        if(!validaRetangulo()){
            return false;
        }
        
        gerarGrid();
    }
    
    function gerarPrecisao(){

    }
    
    
    
    function calculaDistancia(bound1, bound2){
        var distancia = google.maps.geometry.spherical.computeDistanceBetween(
                new google.maps.LatLng(bound1.lat(), bound1.lng()),
                new google.maps.LatLng(bound1.lat(), bound2.lng()));
        return distancia.toFixed(0);
    }
    
    /**
     * Este método é responsável por criar a grid no mapa.
     * Utiliza os seguintes parâmetros internos vindos do formulário.
     * @precisao = #txtPrecisao
     * @pontoSupLat = #txtPontoSupLat
     * @pontoSupLng = #txtPontoSupLng
     * @pontoInfLat = #txtPontoInfLat
     * @pontoSupLng = #txtPontoInfLng
     * 
     * @returns {Boolean}
     */
    function gerarGrid () {
        console.log("gerando a grid");
        if(rectArr.length !== 0){
            deletarGrid();
        }
        
        
	var pontoSupEsq = new google.maps.LatLng($('#txtPontoSupLat').val(), $('#txtPontoSupLng').val());
        var precisao = $('#txtPrecisao').val();
        
        
        // calcula o tamanho da celula
	var NS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 90);
	var SS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 180);
        
        /*
        CALCULO DO TAMANHO DA CELULA
        var flightPlanCoordinates = [new google.maps.LatLng(NS.lat(), NS.lng()),
                                     new google.maps.LatLng(NS.lat(), SS.lng())];
        var flightPath = new google.maps.Polyline({
          path: flightPlanCoordinates,
          geodesic: true,
          strokeColor: '#FF0000',
          strokeOpacity: 1.0,
          strokeWeight: 2
        });
        flightPath.setMap(div_map_2);
        console.log("Tamanho: "+calculaDistancia(NS,SS)+" metros");
        */
       
       
        // faz o cálculo para saber quantos quadrados na proporção NS e SS,
        //  é possivel colocar dentro do retângulo definido pelo usuário.
        var largura = (Math.abs(($('#txtPontoSupLng').val() - ($('#txtPontoInfLng').val()))))/(NS.lng() - (SS.lng()));
        var altura = (Math.abs(($('#txtPontoSupLat').val() - ($('#txtPontoInfLat').val())))/(NS.lat() - (SS.lat())));
        largura = parseInt(largura);
        altura = parseInt(altura);
       
       
        for (var i = 0; i < altura; i++) {

            NE = google.maps.geometry.spherical.computeOffset(NS,i*precisao,180)
            SW = google.maps.geometry.spherical.computeOffset(SS,i*precisao,180)

            for (var a = 0; a < largura; a++) {
                var rectangleGrid = new google.maps.Rectangle();
                var rectOptions = {
                    strokeColor: "#231E24",
                    strokeOpacity: 0.5,
                    strokeWeight: 1,
                    fillColor: 'transparent',
                    fillOpacity: 0.00,
                    map: div_map_2,
                    bounds: new google.maps.LatLngBounds(SW,NE),
                    clickable:true
                };

                rectangleGrid.setOptions(rectOptions);
                rectArr.push(rectangleGrid);
                //bindEvent(rectangleGrid, rectArr.length);
                
                
                var SW = google.maps.geometry.spherical.computeOffset(SW,precisao,90);
                var NE = google.maps.geometry.spherical.computeOffset(NE,precisao,90);    
            }
        }
        if($('#chkRetanguloAtivo').val() ==  'S'){
            habilitarRetangulo();
        }
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
     * Este método é resposável pela ação de click no mapa ou seja, quando o 
     *   usuário for responder a pergunta na grid.
     *   Click = true  ==> Marca a célula clicada.
     *   Click = false ==> Desmarca a célula, caso ela esteja marcada.
     * 
     * @param {type} rectangle
     * @param {type} num
     * @returns {undefined}
     */
    function bindEvent(rectangle, num){
        google.maps.event.addListener(rectangle, 'click', function(event) {
            if(rectangle.get('fillColor') == 'transparent'){
                var opt = {
                    fillColor: 'red',
                    fillOpacity: 0.5
                };
            } else {
                var opt = {
                    fillColor: 'transparent',
                    fillOpacity: 0.00
                };   
            }
            rectangle.setOptions(opt);
        });
    }   
    
    /**
     ****
     * Aba Perguntas
     * =============================================================================================
     * =============================================================================================
     */
    
    function filtro(){
        location.href = BASE_URL+'pesquisador/questionario';
    }
    
    function salvarPerguntas(confirmaSalvar){
        if(confirmaSalvar){
            formPerguntas_submit();
        }
    }
    
    function formPerguntas_callback(data){
        
        if (data.error != undefined) {
            messageErrorBox(data.error.message, data.error.field);
        } else {
            if (data.success != undefined) {    
                messageBox(data.success.message, enableTabs(4));
            }
        }
    }
    
    function gridPerguntas_loadComplete(){
        var questionarioId = $('#txtId').val();
        $.post(BASE_URL+'pesquisador/questionario/listaQuestionarioPerguntas', {questionarioId: questionarioId},
        function(data){
            for (var i = 0; i < data.questionarioPerguntas.length; i++) {
                $("#gridPerguntas").jqGrid('setSelection', data.questionarioPerguntas[i].pergunta_grid_id);
            }
        }, 'json');
    }

/*
 *=================================================================================================
 *================================================================================================= 
 *=================================================================================================
 */ 

</script>

<?= footerView() ?>