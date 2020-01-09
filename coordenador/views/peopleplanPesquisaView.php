<?= headerView() ?>
    <?=path_bread($path_bread);?>

   <?=begin_ToolBar(array('imprimir', 'abrir', 'ajuda', 'pesquisar', 'novo'));?>
    <?=end_ToolBar();?>

    <?=begin_TabPanel();?>
        <?=begin_Tab(lang('pesquisaPesquisa'));?>
            <?=begin_form('coordenador/peopleplanPesquisa/salvar', 'formPesquisa');?>
                <?=form_hidden('txtId', @$questionario->id);?>
                <?=form_hidden('txtPessoaId', @$questionario->pessoa_id);?>
                <?=form_hidden('txtPrecisao', @$questionario->precisao);?>
                <?=form_hidden('txtPontoSupLat', @$questionario->ponto_sup_lat);?>
                <?=form_hidden('txtPontoSupLng', @$questionario->ponto_sup_lng);?>
                <?=form_hidden('txtPontoInfLat', @$questionario->ponto_inf_lat);?>
                <?=form_hidden('txtPontoInfLng', @$questionario->ponto_inf_lng);?>
                <?=form_hidden('txtZoom', @$questionario->zoom);?>


                <?=form_label('lblDescricao', lang('pesquisaDescricao'), 100);?>
                <?=form_textField('txtDescricao', @$questionario->descricao, 500, '');?>
                <?=new_line();?>

                <?=form_label('lblDtIncio', lang('pesquisaDtInicio'), 100);?>
                <?=form_dateField('dtInicio', @$questionario->dt_inicio);?>
                <?=new_line();?>

                <?=form_label('lblDtFim', lang('pesquisaDtFim'), 100);?>
                <?=form_dateField('dtFim', @$questionario->dt_fim);?>
                <?=new_line();?>
                
                <?=form_label('lblPesquisaAtivaADM', lang('pesquisaAtivaADM'), 193, array('for'=>'chkPesquisaAtivaADM'));?>
                <?=form_checkbox('chkPesquisaAtivaADM', 'chkPesquisaAtivaADM', 'S', (@$questionario->ativo_pelo_adm == 'S'));?>
                <?=new_line();?>
                <?=new_line();?>

                <?=form_label('lblPesquisaAtivaPESQ', lang('pesquisaAtivaPESQ'), 193, array('for'=>'chkPesquisaAtivaPESQ'));?>
                <?=form_checkbox('chkPesquisaAtivaPESQ', 'chkPesquisaAtivaPESQ', 'S', (@$questionario->ativo_pelo_pesquisador == 'S'),'', true);?>
                <?=new_line();?>
                <?=new_line();?>

                <?=form_label('lblNome', lang('pesquisaNomeUsuario'), 100);?>
                <?=form_textField('txtNome', @$questionario->nome, 500, '','','',true);?>
                <?=new_line();?>
                <?=new_line();?>

                <?= hr(); ?>
                
                <?=new_line();?>
                <?=new_line();?>
                <?=form_label('lblMapa', 'Mapa', 100);?>
                <?=form_MapWithMarker('div_map_5', 'marcador5', $questionario->geo_lat, $questionario->geo_lon, $questionario->zoom, '1000', '600', false, 2);?>
                <?=new_line();?>

            <?=end_form();?>
        <?=end_Tab();?>
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
                <?=begin_form('pesquisador/peopleplanQuestionario/salvarPerguntasQuestionario', 'formPerguntas');?>
                    <?=form_hidden('txtPessoaId', @$questionario->pessoa_id);?>
                    <?=form_hidden('txtIdQuestionarioPerguntas', @$questionario->id);?>
                    <?=form_hidden('txtPerguntas','');?>
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
                                echo '<li id="' . $pq->pergunta_id . '" class="ui-state-highlight" style="width:auto; background:#ddd; font-weight:bold;color:#ff0084">'. $pq->descricao .' </li>';
                            }
                        }
                        echo '</ul>'.
                    '</div>';
                    ?>        

                <?=end_form();?>
            <?=end_Tab();?>	

    <?=end_TabPanel();?>


<script>

    var rectArr=[];
    var rectangle = null;


    /**
     ****
     * Inicialização do sistema
     * =============================================================================================
     * =============================================================================================
     */

    $(document).ready(function(){
        google.maps.event.trigger(div_map_5, 'resize');
        gerarGrid();
        google.maps.event.trigger(div_map_5, 'resize');
        div_map_5.setZoom(parseInt($('#txtZoom').val()));
        marcador5.setMap(null);
        google.maps.event.trigger(div_map_5, 'resize');
        
        $("#ui-id-2").click(function(){
            google.maps.event.trigger(div_map_5, 'resize');
            gerarGrid();
            google.maps.event.trigger(div_map_5, 'resize');
            div_map_5.setZoom(parseInt($('#txtZoom').val()));
            marcador5.setMap(null);
            google.maps.event.trigger(div_map_5, 'resize');

        });

        $("#ui-id-3").click(function(){
                $("#btnNovaPergunta").show();
                $('#txtIdQuestionarioPerguntas').val($('#txtId').val());
                /*
                $(function() {
                    $( "#lista1, #lista2" ).sortable({
                        connectWith: ".connectedSortable"
                    }).disableSelection();

                });
                */
        });
    });
    
    function filtro(){
        location.href = BASE_URL+'coordenador/peopleplanPesquisa';
    }
    
    function salvar(){
        
        switch($("#tab").tabs("option", "active")){
            case 0:
                if($('#chkPesquisaAtivaADM').is(':checked') == false){
                    $('#chkPesquisaAtivaADM').attr('checked', true);
                    $('#chkPesquisaAtivaADM').val('N');
                } else {
                    $('#chkPesquisaAtivaADM').attr('checked', true);
                    $('#chkPesquisaAtivaADM').val('S');
                }

                formPesquisa_submit();
                break;
            case 1:
                $('#txtPerguntas').val($( "#lista2" ).sortable( "toArray" ));
                formPerguntas_submit();
                break;
        }
    }
    
    
    
    /**
     ****
     * Aba Questionario
     * =============================================================================================
     * =============================================================================================
     */
    
    function formPesquisa_callback(data){
        
        console.log(data);
        
        if (data.error != undefined) {
            messageErrorBox(data.error.message, data.error.field);
        } else {
            if (data.success != undefined) {
                messageBox(data.success.message, filtro);
            }
        }
    }
    
    function excluir(){
        if ($('#txtId').val() == '') {
            messageErrorBox("<?= lang('nenhumRegistroSelecionado') ?>");
        } else {
            messageConfirm('<?= lang('excluirPesquisasAviso') ?>', excluirPesquisa);
        }
    }

    function excluirPesquisa(confirmaExclusao){
        if (confirmaExclusao) {
            $.post(BASE_URL+'coordenador/peopleplanPesquisa/excluir', {pesquisas: $("#txtId").val()},
            function(data){
                if (data.success) {
                    messageBox("<?= lang('registroExcluido') ?>", filtro);
                } else {
                    messageErrorBox("<?= lang('registroNaoExcluido') ?>");
                }
            });
        }
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
                    map: div_map_5,
                    bounds: new google.maps.LatLngBounds(SW,NE),
                    clickable:true
                };

                rectangleGrid.setOptions(rectOptions);
                rectArr.push(rectangleGrid);                
                
                var SW = google.maps.geometry.spherical.computeOffset(SW,precisao,90);
                var NE = google.maps.geometry.spherical.computeOffset(NE,precisao,90);    
            }
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
     ****
     * Aba Perguntas
     * =============================================================================================
     * =============================================================================================
     */
    

    function formPerguntas_callback(data){
        
        if (data.error != undefined) {
            messageErrorBox(data.error.message, data.error.field);
        } else {
            if (data.success != undefined) {    
                messageBox(data.success.message, filtro);
            }
        }
    }
    
    function gridPerguntas_loadComplete(){
        var questionarioId = $('#txtId').val();
        $.post(BASE_URL+'coordenador/peopleplanPesquisa/listaQuestionarioPerguntas', {questionarioId: questionarioId},
        function(data){
            for (var i = 0; i < data.questionarioPerguntas.length; i++) {
                $("#gridPerguntas").jqGrid('setSelection', data.questionarioPerguntas[i].pergunta_grid_id);
            }
        }, 'json');
    }


</script>

        
<?= footerView() ?>



