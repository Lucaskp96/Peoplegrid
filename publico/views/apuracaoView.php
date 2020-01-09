<?= headerPublicView() ?>
<script src='<?= JS . "/pesquisador/algoritmos.js" ?>'></script>
<script src='<?= JS . "/pesquisador/simple_statistics.js" ?>'></script>
<script src='<?= JS . "/legenda.js" ?>'></script>
<link href="<?= CSS ?>/legenda.css" rel="stylesheet">
<link href="<?= CSS ?>/publico/apuracao.css" rel="stylesheet">



<div id="container_cabecalho" class="container-fluid" >
    <!--
    LOGOLABURB + DESCRICAO
    ===========================================
    -->
    <div id="" class="row-fluid"> 
        <div id="" class="row">
            <div class="col-xs-2" >
                <img id="img_laburb" src="../../../static/_img/logo-laburb.png" class="img-responsive" onclick="home()">
            </div>
            <div class="col-xs-10" >
                <div id="" class="text-left">
                    <h1 id=""><strong>Resultado Parcial </strong><small style="margin-left: 20px;"><?= $questionario->descricao; ?></small></h1>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="container_apuracao" class="container-fluid" >
    <div class="row">
        <div id="filtros" class="col-xs-2">
            
            <h2>Filtros</h2>
            <hr>
            <!-- Perguntas  -->
            <!-- ==================================================  -->
            <div class="dropdown">
                <button id='buttonSelectedPerguntas' class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Selecione a Pergunta
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                <?php

                    foreach ($questionarioPerguntas as $qp) {
                        echo 
                            '<li role="presentation">'.
                                '<a role="menuitem" tabindex="-1" onClick="selectedPerguntas('.$qp->id .',\''. $qp->descricao .'\');" >'. $qp->descricao .'</a>'
                                .'</li>';

                    }
                    ?>
                </ul>
            </div>
            
            
            <!-- Algoritmo de geração  -->
            <!-- ==================================================  -->
            <?
                $algoritmos = array();
                array_push($algoritmos, array(0,'Intervalos Naturais (Natural Breaks)'));
                array_push($algoritmos, array(1,'Intervalos iguais de valores'));
                array_push($algoritmos, array(2,'Quantidades iguais de células'));
            ?>

            <div class="dropdown">
                <button id='buttonSelectedAlgoritmos' class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Modo de classificação
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                <?php

                    foreach ($algoritmos as $a) {
                        echo 
                            '<li role="presentation">'.
                                '<a role="menuitem" tabindex="-1" onClick="selectedAlgoritmos('.$a[0] .',\''. $a[1] .'\');" >'. $a[1] .'</a>'
                            .'</li>';                    
                    }
                    ?>
                </ul>
            </div>
            
                        <!-- Classes  -->
            <!-- ==================================================  -->
            <?foreach ($questionario_cores as $value) { ?>
                    <script type="text/javascript">
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
                <? } ?>        

            <div class="dropdown">
                <button id='buttonSelectedClasses' class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Classes
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">

                <?php 

                    for($i = 0; $i < 10;$i++) {
                        echo '<li role="presentation"><a role="menuitem" tabindex="-1" onClick="selectedClasses('.($i+1).');"  >'.($i+1).'</a></li>';
                    }
                    ?>
                </ul>
            </div>
            
            <hr>
            <!-- Você Pensou Como  -->
            <!-- ==================================================  -->
            <div class="dropdown">
                <button id='buttonSelectedPensouComo' class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Perfil do Respondente
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" onClick="selectedPensouComo('-1','Perfil do Respondente');" >Perfil do Respondente</a>
                    </li>
                    <?php        
                        foreach ($pensouComo as $pc) {
                            echo 
                                '<li role="presentation">'.
                                    '<a role="menuitem" tabindex="-1" onClick="selectedPensouComo('.$pc->id .',\''. $pc->descricao .'\');" >'. $pc->descricao .'</a>'
                                .'</li>';
                    }
                    ?>
                </ul>
            </div>
            
            <!-- Nivel Escolar  -->
            <!-- ==================================================  -->
            <div class="dropdown">
                <button id='buttonSelectedNivelEscolaridade' class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Nível Escolar
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" onClick="selectedNivelEscolaridade('-1','Nível Escolaridade');" >Nível Escolaridade</a>
                    </li>
                    <?php        
                    foreach ($nivelEscolaridade as $ne) {
                        echo 
                            '<li role="presentation">'.
                                '<a role="menuitem" tabindex="-1" onClick="selectedNivelEscolaridade('.$ne->id .',\''. $ne->descricao .'\');" >'. $ne->descricao .'</a>'
                            .'</li>';
                    }
                    ?>
                </ul>
            </div>
            
            <!-- Renda Familiar  -->
            <!-- ==================================================  -->
            <div class="dropdown">
                <button id='buttonSelectedRendaFamiliar' class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Renda Familiar
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" onClick="selectedRendaFamiliar('-1','Renda Familiar');" >Renda Familiar</a>
                    </li>
                <?php        
                    foreach ($rendaFamiliar as $rf) {
                        echo 
                            '<li role="presentation">'.
                                '<a role="menuitem" tabindex="-1" onClick="selectedRendaFamiliar('.$rf->id .',\''. $rf->descricao .'\');" >'. $rf->descricao .'</a>'
                            .'</li>';

                    }
                    ?>
                </ul>
            </div>
            


            <!-- Gerar Resultado  -->
            <!-- ==================================================  -->
                    
            <div id="btnGerarResultado" class="btn btn-md btn-success" onclick="gerarResultado()"><i class="fa fa-area-chart fa-1x" style=" padding-right: 5px" ></i>Gerar Resultado</div>
            <div id="btnHome" class="btn btn-md btn-info" onclick="home()" style="margin-top: 10px !important"><i class="fa fa-backward fa-1x" style=" padding-right: 5px; " ></i>Voltar</div>
        </div>
        
        <div id="mapa" class="col-xs-10" >
            <div id="perguntasGrid">
                <?= form_MapWithMarker('div_map_6', 'marcador6', '', '', '', 'auto', 'auto', false, 1); ?>
                <?= form_hidden('txtQuestionarioId', $questionario->id); ?>
                <?= form_hidden('txtQuestionarioLink', $questionario->link); ?>
                <?= form_hidden('txtLat', $questionario->geo_lat); ?>
                <?= form_hidden('txtLng', $questionario->geo_lon); ?>
                <?= form_hidden('txtZoom', $questionario->zoom); ?>
                <?= form_hidden('txtPrecisao', $questionario->precisao); ?>
                <?= form_hidden('txtPontoSupLat', $questionario->ponto_sup_lat); ?>
                <?= form_hidden('txtPontoSupLng', $questionario->ponto_sup_lng); ?>
                <?= form_hidden('txtPontoInfLat', $questionario->ponto_inf_lat); ?>
                <?= form_hidden('txtPontoInfLng', $questionario->ponto_inf_lng); ?>
                <div id="legenda"></div>
            </div>
            
            <div id="info_tutorial_apuracao" class="resizable" class="col-xs-10">
                <button class="close" onclick="document.getElementById('info_tutorial_apuracao').style.display='none'" >X</button>
                <h4><br><br><center> <?=  lang('tutorialTitulo'); ?></center></h4>
                <h6><?= lang('tutorialIntroColaborar'); ?></h6>
                <h6><?= lang('tutorialFiltro'); ?></h6>
                <h6><?= lang('tutorialFiltroObs'); ?></h6>
                <h6><?= lang('tutorialDica'); ?></h6>
                <h6><?= lang('tutorialCuriosidade'); ?></h6>
            </div>
            
            <div id="interrogacao">
                <button onclick="document.getElementById('info_tutorial_apuracao').style.display='initial'" class="glyphicon glyphicon-question-sign" title="Abrir Tutorial" aria-hidden="true"></button>
            </div>
        </div>
    </div>
 </div>
<div id="container_rodape" class="container-fluid">
    <div id="row_rodape" class="row-fluid">
        <p> <?= lang('titulo') ?> © <?= date('Y') ?>
    </div>
</div>
<script>
    
      
    /*
     *
     *  CARREGAMENTO DA PAGINA
     *=======================================================================================
     *==========
     */
    var numClasses;
    var questaoCorrente = 1;
    var perguntas = <?php echo json_encode($questionarioPerguntas); ?>;
    var ferramenta = {id: 1, cor: '#ff0000'};
    var perguntasGrid = new Array();
    var rectArr = [];
    var NS, SS, precisao, pontoSupEsq, tamanho;
    var arraste = false;

    $(document).ready(function() {
        $('#div_map_6').css('min-height', '600px');
        $('#div_map_6').css('width', 'auto');
        marcador6.setMap(null);
        centralizarMapa($('#txtLat').val(), $('#txtLng').val(), $('#txtZoom').val());
        google.maps.event.trigger(div_map_6, 'resize');
        
        montarGrid();

        
        // pega o ponto superior e inferior
        pontoSupEsq = new google.maps.LatLng($('#txtPontoSupLat').val(), $('#txtPontoSupLng').val());
        // pega a precisão para gerar o tamanho da celula
        precisao = $('#txtPrecisao').val();
        // cria os pontos para gerar a distancia de cada célula
        NS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 90);
        SS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 180);
       
        $('#infoCelula').text("Cada Célula possui lado de " + calculaDistancia(NS, SS) + " m");
        $('#paletaCores').palette({
            length: 3,
            onSelect: function() {
                setCor($(this).find('.coloring').attr('id'));

            }
        });
        
        var centerControlDiv = document.createElement('div');
        centerControlDiv.index = 1; 
        centerControlDiv.style['padding-top'] = '10px';

        
        var controlUI = document.createElement('div');
        controlUI.style.backgroundColor = '#fff';
        controlUI.style.border = '2px solid #fff';
        controlUI.style.borderRadius = '3px';
        controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.1)';
        controlUI.style.cursor = 'pointer';
        controlUI.style.marginBottom = '22px';
        controlUI.style.textAlign = 'center';
       
        controlUI.title = 'Click to recenter the map';
        centerControlDiv.appendChild(controlUI);

        // Set CSS for the control interior
        var controlText = document.createElement('div');
        controlText.style.color = 'rgb(25,25,25)';
        controlText.style.fontFamily = 'Roboto';
        controlText.style.fontSize = '11px';
        controlText.style.lineHeight = '21px';
        controlText.style.paddingTop = '3px';
        controlText.style.paddingBottom = '3px';
        controlText.style.paddingLeft = '5px';
        controlText.style.paddingRight = '5px';
        controlText.innerHTML = 'Centralizar Mapa';
        controlUI.appendChild(controlText);
        // Setup the click event listeners: simply set the map to
        // Chicago
        google.maps.event.addDomListener(controlUI, 'click', function() {
            div_map_6.setZoom(parseInt($('#txtZoom').val()));
            
            var latlng = new google.maps.LatLng($('#txtLat').val(), $('#txtLng').val());
            div_map_6.setCenter(latlng);
            google.maps.event.trigger(div_map_6, 'resize');
            // setar o centro
        });
        div_map_6.controls[google.maps.ControlPosition.TOP_RIGHT].push(centerControlDiv);
        
        var filtros = ($('#filtros').width() - 5);
         
        $('#buttonSelectedPerguntas').css('min-width', filtros+"px");
        $('#buttonSelectedPerguntas').css('max-width', filtros+"px");
        $('#buttonSelectedAlgoritmos').css('min-width', filtros+"px");
        $('#buttonSelectedAlgoritmos').css('max-width', filtros+"px");
        $('#buttonSelectedPensouComo').css('min-width', filtros+"px");
        $('#buttonSelectedPensouComo').css('max-width', filtros+"px");
        $('#buttonSelectedRendaFamiliar').css('min-width', filtros+"px");
        $('#buttonSelectedRendaFamiliar').css('max-width', filtros+"px");
        $('#buttonSelectedNivelEscolaridade').css('min-width', filtros+"px");
        $('#buttonSelectedNivelEscolaridade').css('max-width', filtros+"px");
        $('#buttonSelectedClasses').css('min-width', filtros+"px");
        $('#buttonSelectedClasses').css('max-width', filtros+"px");
        $('#btnGerarResultado').css('min-width', filtros+"px");
        $('#btnGerarResultado').css('max-width', filtros+"px");
        $('#btnHome').css('min-width', filtros+"px");
        $('#btnHome').css('max-width', filtros+"px");
        $('#btnHome').css('margin-top', ($('#filtros').height()-15)+"px");
        div_map_6.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(document.getElementById('legenda'));
        
        resizeMap();
    });
    
    
    
    function home() {
        location.href = BASE_URL;
    }
    
    
    function resizeMap(){
        var tamTela;
        tamTela = $(window).height() -( $("#container_cabecalho").height()+$("#container_rodape").height());
        if(tamTela > 600){
            $('#div_map_6').css('width', 'auto');
            $("#div_map_6").height(tamTela);
            $('#filtros').height(tamTela);
        } else {
            $('#filtros').height(600);
        }
        

        google.maps.event.trigger(div_map_6, 'resize');
        
    }
    
    
    
    /*
     *  FUNCOES DOS CAMPOS DE FILTRO
     *===========================================
     */
    var pergunta, algoritmo,pensouComo,nivelEscolar,rendaFamiliar;
    
    function selectedPerguntas(id, descricao){
        $('#buttonSelectedPerguntas').html(descricao + '<span class="caret"></span>');
        pergunta = id;

        ga('send', 'event', 'apuracaoView', 'selectedPerguntas','pergunta',pergunta);
    }
    
    function selectedClasses(id){
        $('#buttonSelectedClasses').html(id + '<span class="caret"></span>');

        numClasses = id;

        ga('send', 'event', 'apuracaoView', 'selectedClasses','classes',numClasses);
    }
    
    function selectedAlgoritmos(id, descricao){
        $('#buttonSelectedAlgoritmos').html(descricao + '<span class="caret"></span>');
        algoritmo = id;
        
        ga('send', 'event', 'apuracaoView', 'selectedAlgoritmo','algoritmo',algoritmo);
    }
    
    function selectedPensouComo(id, descricao){
        $('#buttonSelectedPensouComo').html(descricao + '<span class="caret"></span>');
        pensouComo = id;

        ga('send', 'event', 'apuracaoView', 'selectedPensouComo','pensou',pensouComo);
    }
    
    function selectedNivelEscolaridade(id, descricao){
        $('#buttonSelectedNivelEscolaridade').html(descricao + '<span class="caret"></span>');
        nivelEscolar = id;

        ga('send', 'event', 'apuracaoView', 'selectedNivelEscolaridade','nivel',nivelEscolar);
    }
    
    function selectedRendaFamiliar(id, descricao){
        $('#buttonSelectedRendaFamiliar').html(descricao + '<span class="caret"></span>');
        rendaFamiliar = id;

        ga('send', 'event', 'apuracaoView', 'selectedRendaFamiliar','renda',rendaFamiliar);

    }
    
    function gerarResultado(){
        var t;
        if(pergunta == null){
            $('#aviso_botao_resultado').css('display','none') 
            $('#aviso_titulo').html('Perguntas');
            $('#aviso_mensagem').html('Selecione uma pergunta antes de gerar o resultado.');
            $('#aviso').modal('show');
            return false;
        }
        
        if(algoritmo == null){
            $('#aviso_botao_resultado').css('display','none')
            $('#aviso_titulo').html('Algoritmo');
            $('#aviso_mensagem').html('Selecione uma algoritmo antes de gerar o resultado.');
            $('#aviso').modal('show');
            return false;
        }
        
        if( numClasses == null){
            $('#aviso_botao_resultado').css('display','none')
            $('#aviso_titulo').html('Classes');
            $('#aviso_mensagem').html('Selecione o número de classes antes de gerar o resultado.');
            $('#aviso').modal('show');
            return false;
        }
        $.ajax({
                method:"post",
                url:"../getResultado", 
                data:{  
                        cmbQuestionarioPerguntas: pergunta,
                        cmbPensouComo: pensouComo,
                        cmbRendaFamiliar: nivelEscolar,
                        cmbNivelEscolaridade: rendaFamiliar,
                        cmbAlgoritmo: algoritmo,
                        type:"result"},
                success: 
                        function(data){
                            var total;
                            total = JSON.parse(data);
                            if (total.success.message !== undefined) {
                                
            
                                setLegenda(numClasses);
                                switch(algoritmo){
                                    case 0:                                        
                                        var rett = naturalBreaks(total.respostas, rectArr, numClasses, cores ); 
                                        gerarLegendaNaturalBreaks(numClasses, total.totalRespostas, rett['range']);                                  
                                        break;
                                    case 1:
                                        intervalar(total.respostas, rectArr, numClasses, cores );
                                        gerarLegenda(numClasses, total.totalRespostas);                                        
                                        break;
                                    case 2:
                                        classes(total.respostas, rectArr, numClasses, cores );
                                        gerarLegenda(numClasses, total.totalRespostas);
                                        break;
                                    default:
                                        messageBox("Selecione um Algoritmo");
                                }
                            }
                            
                            flagLeg =1;
                        }       
        });
        ga('send', 'event', 'apuracaoView', 'gerarResultado','algoritmo',algoritmo);
    }
    
   function setLegenda(numClasses){
        switch(numClasses){
            case 1:
                cores[0] = "d01b20";
                break;
            case 2:
                cores[0] = "397eb7";
                cores[1] = "d01b20";
                break;
            case 3:
                cores[0] = "397eb7";
                cores[1] = "ebf7c5";
                cores[2] = "d01b20";
                break;
            case 4:
                cores[0] = "397eb7";
                cores[1] = "c5e7d6";
                cores[2] = "facc76";
                cores[3] = "d01b20";
                break;
            case 5:
                cores[0] = "397eb7";
                cores[1] = "9dcde1";
                cores[2] = "ebf7c5";
                cores[3] = "facc76";
                cores[4] = "d01b20";
                break;
            case 6:
                cores[0] = "397eb7";
                cores[1] = "9dcde1";
                cores[2] = "ebf7c5";
                cores[3] = "facc76";
                cores[4] = "de622f";
                cores[5] = "d01b20";
                break;
            case 7:
                cores[0] = "397eb7";
                cores[1] = "63a3d3";
                cores[2] = "c5e7d6";
                cores[3] = "ebf7c5";
                cores[4] = "facc76";
                cores[5] = "de622f";
                cores[6] = "d01b20";
                break;
            case 8:
                cores[0] = "397eb7";
                cores[1] = "63a3d3";
                cores[2] = "9dcde1";
                cores[3] = "ebf7c5";
                cores[4] = "ffebaa";
                cores[5] = "facc76";
                cores[6] = "de622f";
                cores[7] = "d01b20";
                break;
            case 9:
                cores[0] = "397eb7";
                cores[1] = "63a3d3";
                cores[2] = "9dcde1";
                cores[3] = "c5e7d6";
                cores[4] = "ffebaa";
                cores[5] = "facc76";
                cores[6] = "ff9a54";
                cores[7] = "de622f";
                cores[8] = "d01b20";
                break;
            case 10:
                cores[0] = "397eb7";
                cores[1] = "63a3d3";
                cores[2] = "9dcde1";
                cores[3] = "c5e7d6";
                cores[4] = "ebf7c5";
                cores[5] = "ffebaa";
                cores[6] = "facc76";
                cores[7] = "ff9a54";
                cores[8] = "de622f";
                cores[9] = "d01b20";
                break;
            default:
                messageBox("Erro ao setar a legenda.");
        } 
       
   }
    
    
    /*
     *  FUNCOES INTERNAS DO MAPA
     *===========================================
     */
    
    
    
    
    /**
     * Cria a grid na tela para o usuário repondente
     * @returns {undefined}
     */
    function montarGrid() {

        var pontoSupEsq = new google.maps.LatLng($('#txtPontoSupLat').val(), $('#txtPontoSupLng').val());
        var precisao = $('#txtPrecisao').val();


        
        // calcula o tamanho da celula
        var NS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 90);
        var SS = google.maps.geometry.spherical.computeOffset(pontoSupEsq, precisao, 180);
        

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
                    map: div_map_6,
                    bounds: new google.maps.LatLngBounds(SW, NE),
                    clickable: true,
                    draggableCursor: 'help'
                    
                };
                
                rectangleGrid.setOptions(rectOptions);
                rectArr.push(rectangleGrid);
                //bindEvent(rectangleGrid, rectArr.length);

                var SW = google.maps.geometry.spherical.computeOffset(SW, precisao, 90);
                var NE = google.maps.geometry.spherical.computeOffset(NE, precisao, 90);
                
            }
        }
    }
    
    
    
    /**
     * Capta o centro do mapa para criar a grid
     * 
     * @param {type} $latitude
     * @param {type} $longitude
     * @param {type} $zoom
     * @returns {undefined}
     */
    function centralizarMapa($latitude, $longitude, $zoom) {
        var latlng = new google.maps.LatLng($latitude, $longitude);
        div_map_6.setCenter(latlng);
        div_map_6.setZoom(parseInt($zoom));
    }
    
    var altura = 0;
    var largura = 0;
    function calculaDistancia(bound1, bound2){
        var distancia = google.maps.geometry.spherical.computeDistanceBetween(
                    new google.maps.LatLng(bound1.lat(), bound1.lng()),
                    new google.maps.LatLng(bound1.lat(), bound2.lng()));
        return distancia.toFixed(0);
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
    
    

    ga('send', 'event', 'apuracaoView', 'pesquisaSelecionada',$('#txtQuestionarioLink').val());
</script>    