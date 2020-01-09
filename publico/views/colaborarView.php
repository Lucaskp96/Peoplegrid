<?= headerPublicView() ?>

<!--
LOGO_LABURB + PERGUNTAS
===========================================
-->
    <!--
    LOGOLABURB + PREGUNTAS+BOTOES
    ===========================================
    -->

    <div id="row_perguntas" class="row-fluid" style="background-color: #dbdbdb;"> 

            <div class="col-xs-2" >
                <img id="img_laburb" src="../../../static/_img/logo-laburb.png" class="img-responsive" onclick="home()">
            </div>
            <div class="col-xs-10">
                <div id="perguntas_descricao" class="row">
                    <div class=" col-xs-1" >
                        <div id="btnAnterior" class="btn" onclick="anteriorPergunta()"> <i class="fa fa-chevron-circle-left fa-5x"> </i></div>
                    </div>
                    <div id="contagemClass" class="col-xs-3 text-center">
                        <strong><h1 id="contagem"></h1></strong>
                    </div>
                    <div id="perguntaClass" class=" col-xs-7">
                        <h3 id="pergunta"></h3>
                    </div>
                    <div class=" col-xs-1" style="margin-left:-30px">
                        <div id="btnProximo" class="btn" onclick="proximaPergunta()"> <i class="fa fa-chevron-circle-right fa-5x"> </i>  </div>
                        <div id="btnEnviar" class="btn btn-md btn-success" onclick="enviar()" style="padding-right:5px"><i class="fa fa-check fa-1x" > Enviar</i></div>
                    </div>   
                </div>
            </div>
    </div>


<!--
FERRAMENTAS + GRID
===========================================
-->

<div id="row_ferramentas_mapa" class="row-fluid">
    
    <div id="ferramentas" class="col-xs-2">
        <ul id="ul_ferramentas" class="nav">
            <li id="labelFerramentas">
                <span>
                    <p id="lblFerramentas">Ferramentas</p>
                </span>
            </li>
            <div id="linha"></div>
            <li>
                <a id="pincel" onclick="lapis()" title="Selecione o Lápis para demarcar a área na grid." >
                    <img src="<?= IMG ?>/pencils/pencil_1.png" class="img-responsive" width="45px">
                </a>
            </li>
            
            <li>
                <a id="pincel" onclick="cinco()" title="Selecione o Lápis para demarcar a área na grid." >
                    <img src="<?= IMG ?>/pencils/pencil_5.png" class="img-responsive" width="45px">           
                </a>
            </li>
            <li>
                <a id="pincel" onclick="nove()" title="Selecione o Lápis para demarcar a área na grid." >
                    <img src="<?= IMG ?>/pencils/pencil_9.png" class="img-responsive" width="45px">
                    
                </a>
            </li>
            
            <li style="display: none;">
                <a id="pincel" onclick="brush()" title="Selecione o pincel para demarcar a área na grid. Dê um click e arraste para pintar, com outro click você para." style="padding-left: 25px;">
                    <i id="iconesFerramentas" class="fa fa-paint-brush fa-2x"></i>
                    
                </a>
            </li>
            
            <li style="margin-bottom: -10px">
                <p id="descFerramentasCores">Intensidades</p>
                <div id="cores">
                    <input id="paletaCores">
                </div>
            </li>
            <li id="li_borracha">
                <a id="borracha" onclick="borracha()" title="Utilize a borracha para apagar células pintadas incorretamente.">
                    <i id="iconesFerramentas" class="fa fa-eraser fa-2x"></i>
                    <p id="descFerramentasBorracha">Borracha</p>
                </a>
            </li>
            <li id="li_limpar">
                <a id="limpar" onclick="return checkLimparGrid()" title="Clique aqui para limpar a grid.">
                    
                    <i id="iconesFerramentas" class="fa fa-trash-o fa-2x"></i>
                    <p id="descFerramentasLimpar">Limpar Mapa</p>
                </a>
            </li>
            
        </ul>                

        <div id="linha" ></div>

        <ul id="ul_informacoes" class="nav">
            <li id="labelFerramentas">
                <p id="lblInformacoes">Informações</p>
            </li>
            <li id="info">
                <p id="infoCelula" class="text-justify"><p> 
            </li>
            <li id="info">
                <p id="infoCores" class="text-justify">Cada cor representa um nível de importância, demarque as areas no mapa conforme as prioridades acima.<p> 
            </li>

        </ul>
        <div id="linha" ></div>
        <div id="div_abreFecha" class="pull-right" style="margin-top: 15px">
            <a id="abreFechaFerramentas" onclick="abreFechaFerramentas()">
                <i id="iconeAbreFecha" class="fa fa-angle-double-left fa-2x" style="color:#272727;"></i>
            </a>
        </div>
    </div>
    
    <div id="mapa" class="col-xs-10" >
        <div id="perguntasGrid">
            <?= form_MapWithMarker('div_map_3', 'marcador3', '', '', '', 'auto', 'auto', false, 1); ?>
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

        </div>

        <div id="perguntasObjetivas">
            <div class="control-group col-lg-4">
                <label id="descPerguntObjetiva" class="control-label h4"><?= lang('formNivelEscolaridade') ?></label>
                <div style="padding-top:10px"></div>
                <div class='controls'>
                    <?php
                    foreach ($filtroNivelEscolaridade as $ne) {
                        echo '<div id="itemPerguntasObjetivas" class="radio col-lg-offset-1">
                                                <input type="radio" name="nivelEscolaridade" id="nivelEscolaridade" value="' . $ne->id . '">' .
                        $ne->descricao .
                        '</div>';
                    }
                    ?>                
                </div>
            </div>
            <div class="control-group col-lg-4">
                <label id="descPerguntObjetiva" class="control-label h4"><?= lang('formRendaFamiliar') ?></label>
                <div style="padding-top:10px"></div>
                <div class='controls'>
                    <?php
                    foreach ($filtroRendaFamiliar as $rf) {
                        if ($rf)
                            echo '<div id="itemPerguntasObjetivas" class="radio col-lg-offset-1">
                                                <input type="radio" name="rendaFamiliar" id="rendaFamiliar" value="' . $rf->id . '">' .
                            $rf->descricao
                            . '</div>';
                    }
                    ?>                                    
                </div> 
            </div>

            <div class="control-group col-lg-4">
                <label id="descPerguntObjetiva" class="control-label h4"><?= lang('formPensouComo') ?></label>
                <div style="padding-top:10px"></div>
                <div class='controls'>
                    <?php
                    foreach ($filtroPensouComo as $pc) {
                        echo '<div id="itemPerguntasObjetivas" class="radio col-lg-offset-1">
                                                <input type="radio" name="pensouComo" id="pensouComo" value="' . $pc->id . '">' .
                        $pc->descricao
                        . '</div>';
                    }
                    ?>                              
                </div> 
            </div>

            <?= form_hidden("txtPerguntasGrid"); ?>


        </div>
        
        
        <div id="info_tutorial" class="resizable" class="col-xs-10">
            <button class="close" onclick="document.getElementById('info_tutorial').style.display='none'" >X</button>
            <h4><br><br><center> <?=  lang('tutorialTitulo'); ?></center></h4>
            <h6><?= lang('tutorialIntro'); ?></h6>
            <h6><?= lang('tutorial1'); ?></h6>
            <h6><?= lang('tutorial2'); ?></h6>
            <h6><?= lang('vermelho'); ?></h6>
            <h6><?= lang('laranja'); ?></h6>
            <h6><?= lang('amarelo'); ?></h6>
            <h6><?= lang('tutorial3'); ?></h6>
            <h6><?= lang('tutorial4'); ?></h6>
            <h6><?= lang('tutorialDica'); ?></h6>
            <h6><?= lang('tutorialCuriosidade'); ?></h6>
            
        </div>
            
        <div id="interrogacao">
            <button onclick="document.getElementById('info_tutorial').style.display='initial'" class="glyphicon glyphicon-question-sign" title="Abrir Tutorial" aria-hidden="true"></button>
        </div>
        
        
    </div>
</div>

<br style="clear:both;" />
<div id="container_rodape" class="container-fluid">
    <div id="row_rodape" class="row-fluid">
        <p> <?= lang('titulo') ?> © <?= date('Y') ?>
    </div>
</div>
</div>

<section id="success">
    <div class="container">
        <div class="well well-lg">
            <h1 class="col-lg-2"><img src="<?= BASE_URL ?>static/_img/success.png"></h1>
            <h3 class="col-lg-offset-2">Pronto!</h3>
            <h4 class="col-lg-offset-2"> Suas respostas foram computadas com sucesso. </h4>
            <div id="btnEnviar" class="btn pull-right btn-success col-lg-offset-2" onclick="home()">Feito!</div>
            <br>
            <br>
            <br>
        </div>
    </div>
</section>

<section id="fail">
    <div class="container">
        <div class="well well-lg">
            <h1 class="col-lg-2"><img src="<?= BASE_URL ?>static/_img/fail.png"></h1>
            <h3 class="col-lg-offset-2">Falha!</h3>
            <h4 class="col-lg-offset-2">Parece que houve algum erro, tente novamente.</h4>
            <div id="btnFalha" class="btn pull-right btn-danger col-lg-offset-2" onclick="home()"> Voltar!</div>
            <br>
            <br>
            <br>
        </div>
    </div>
</section>


<script>

    function home() {
        location.href = BASE_URL;
    }
    
    function abreFechaFerramentas(){
        
        if(document.getElementById("ferramentas").className === 'col-xs-2'){
            $(this).children().toggleClass('active');
            $('#menux').toggleClass('active');
            $('#ferramentas').removeClass('col-xs-2');
            $('#ferramentas').addClass('col-xs-1');
            $('#mapa').removeClass('col-xs-10');
            $('#mapa').addClass('col-xs-11');
            $('#iconeAbreFecha').removeClass('fa-angle-double-left');
            $('#iconeAbreFecha').addClass('fa-angle-double-right');
            $('#lblFerramentas').text(' ');
            $('#descFerramentasPincel').hide();
            $('#descFerramentasBorracha').hide();
            $('#descFerramentasLimpar').hide();
            $('#descCoresAlta').text('');
            $('#descCoresMedia').text('');
            $('#descCoresBaixa').text('');
            $('#lblInformacoes').hide();
            $('#infoCelula').hide();
            $('#infoCores').hide();
            $('#ff0000').css('margin-top', '10px');
            $('#ff0000').css('margin-bottom', '10px');
            $('#ff0000').css('margin-right', '30px');
            $('#ffa500').css('margin-top', '10px');
            $('#ffa500').css('margin-bottom', '10px');
            $('#ffa500').css('margin-right', '30px');
            $('#ffff00').css('margin-top', '10px');
            $('#ffff00').css('margin-bottom', '10px');
            $('#ffff00').css('margin-right', '30px');
            ga('send', 'event', 'colaborarView', 'MenuLateralFechando');
        } else{
            $(this).children().toggleClass('active');
            $('#pincel').css('margin-left', '0px');
            $('#borracha').css('margin-left', '0px');
            $('#limpar').css('margin-left', '0px');
            $('#menux').toggleClass('active');
            $('#ferramentas').removeClass('col-xs-1');
            $('#ferramentas').addClass('col-xs-2');
            $('#mapa').addClass('col-xs-10');
            $('#mapa').removeClass('col-xs-11');
            $('#iconeAbreFecha').removeClass('fa-angle-double-right');
            $('#iconeAbreFecha').addClass('fa-angle-double-left');
            $('#lblFerramentas').text('Ferramentas');
            $('#descFerramentasPincel').show();
            $('#descFerramentasBorracha').show();
            $('#descFerramentasLimpar').show();
            $('#descFerramentasCores').show();
            $('#descCoresAlta').text("Alta");
            $('#descCoresMedia').text("Média");
            $('#descCoresBaixa').text("Baixa");
            $('#lblInformacoes').show();
            $('#infoCelula').show();
            $('#infoCores').show();
            $('#pincel').css('margin-bottom', '0px');        
            $('#ff0000').css('margin-top', '0px');
            $('#ff0000').css('margin-bottom', '0px');
            $('#ff0000').css('margin-right', '5px');
            $('#ffa500').css('margin-top', '0px');
            $('#ffa500').css('margin-bottom', '0px');
            $('#ffa500').css('margin-right', '5px');
            $('#ffff00').css('margin-top', '0px');
            $('#ffff00').css('margin-bottom', '0px');
            $('#ffff00').css('margin-right', '5px');
            ga('send', 'event', 'colaborarView', 'MenuLateralAbrindo');
        }

}
    
    /*
     *
     *  CARREGAMENTO DA PAGINA
     *=======================================================================================
     *==========
     */
    var cabecalho = $("#row_perguntas").height();
    var questaoCorrente = 1;
    var perguntas = <?php echo json_encode($questionarioPerguntas); ?>;
    var ferramenta = {id: 1, cor: '#ff0000'};
    var perguntasGrid = new Array();
    var rectArr = [];
    var NS, SS, precisao, pontoSupEsq, tamanho;
    var arraste = false;
    
    $(document).ready(function() {
        marcador3.setMap(null);
        centralizarMapa($('#txtLat').val(), $('#txtLng').val(), $('#txtZoom').val())
        google.maps.event.trigger(div_map_3, 'resize');
        montarGrid();
        $('#div_map_3').css('min-height', '600px');
        $('#div_map_3').css('width', 'auto');

        $('#body').css('margin-right','0px');

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
            div_map_3.setZoom(parseInt($('#txtZoom').val()));
            
            var latlng = new google.maps.LatLng($('#txtLat').val(), $('#txtLng').val());
            div_map_3.setCenter(latlng);
            google.maps.event.trigger(div_map_3, 'resize');
            // setar o centro
        });
        div_map_3.controls[google.maps.ControlPosition.TOP_RIGHT].push(centerControlDiv);
        
        resizeMap();
    });
    
    function resizeMap(){
        var tamTela;
        
        if($("#perguntas_descricao").height() > $("#row_perguntas").height()) {
            $("#row_perguntas").height($("#perguntas_descricao").height());
        } else {
            $("#row_perguntas").height(cabecalho);
        }
        console.log(cabecalho);
        console.log($("#row_perguntas").height());
        console.log($("#perguntas_descricao").height());
        console.log($("#container_rodape").height());
        
        tamTela = $(window).height() -(  $("#row_perguntas").height() + $("#container_rodape").height());    
        console.log(tamTela);
        
        if(tamTela > 600){
            $("#div_map_3").height(tamTela);
            $('#ferramentas').height(tamTela);
        }
        
    }
    
    
    /*
     * Inicializa a pagina do questionario
     * Carrega os dados e monta a estrutura de perguntas
     * @returns {undefined}
     */
    function init() {
        $("#perguntasObjetivas").hide();
        $("#perguntasGrid").show();
        $('#btnAnterior').hide();
        $('#success').hide();
        $('#fail').hide();
        $('#btnEnviar').hide();
        $("#contagem").html(perguntas[questaoCorrente - 1].ordem + " de " + perguntas.length);
        $("#pergunta").html(perguntas[questaoCorrente - 1].descricao);
    }

    this.init();
    /*
     *=======================================================================================
     *==========  
     */



    /*
     * 
     * GRID E MAPA
     *=======================================================================================
     *==========  
     */
    var altura = 0;
    var largura = 0;
    function calculaDistancia(bound1, bound2){
        var distancia = google.maps.geometry.spherical.computeDistanceBetween(
                new google.maps.LatLng(bound1.lat(), bound1.lng()),
                new google.maps.LatLng(bound1.lat(), bound2.lng()));
        return distancia.toFixed(0);
    }

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
                    map: div_map_3,
                    bounds: new google.maps.LatLngBounds(SW, NE),
                    clickable: true,
                    draggableCursor: 'help'
                };
                
                rectangleGrid.setOptions(rectOptions);
                rectArr.push(rectangleGrid);
                bindEvent(rectangleGrid, rectArr.length);


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
        div_map_3.setCenter(latlng);
        div_map_3.setZoom(parseInt($zoom));

        ga('send', 'event', 'colaborarView', 'centralizarMapa',1);
        
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

        ga('send', 'event', 'colaborarView', 'limpar');
    }
    
    function checkLimparGrid(){
        if  (confirm("Você tem certeza de que quer apagar sua marcação na grid?")){  
            return limparGrid();
        } else {   
            return false;
        }
    }
    
    function setCor(cor) {
        console.log(ferramenta);
        ferramenta.cor = "#"+cor;
        console.log(ferramenta);
    }

    function lapis() {
        
        ferramenta.id = 1;

        ga('send', 'event', 'colaborarView', 'lapis_1');
    }
    
    function cinco(){
        
        ferramenta.id = 5;

        ga('send', 'event', 'colaborarView', 'lapis_5');      
    }
    
    function brush(){
        
        ferramenta.id = 3;

        ga('send', 'event', 'colaborarView', 'brush');
    }
    
    function nove(){
        
        ferramenta.id = 9; 

        ga('send', 'event', 'colaborarView', 'lapis_9');       
    }
    
    function borracha() {
        
        ferramenta.id = 2;

        ga('send', 'event', 'colaborarView', 'borracha');
    }

    /**
     * Função que controla o evento de click da grid
     * @returns {true or false}
     */
    function bindEvent(rectangle, num) {
        
        google.maps.event.addListener(rectangle, 'mouseover', function(event) {
           // console.log(arraste);
            if(arraste){
                
                var opt = {
                    fillColor: ferramenta.cor,
                    fillOpacity: 0.5
                };
                rectangle.setOptions(opt);
            }  
        });
        
        google.maps.event.addListener(rectangle, 'click', function(event) {
            var id = num;
            // console.log(largura);
            // console.log(altura);
        switch(ferramenta.id){
            case 1:
                var opt = {
                    fillColor: ferramenta.cor,
                    fillOpacity: 0.5
                };
                rectangle.setOptions(opt);
                break;
            case 2:
                var opt = {
                     fillColor: 'transparent',
                     fillOpacity: 0.00
                };
                rectangle.setOptions(opt);
                break;
            case 3:
                //console.log(arraste);
                if(arraste){
                    arraste = false;
                } else {
                    arraste = true;
                }
                //console.log(arraste);
                break;
            case 5:
                var opt = {
                    fillColor: ferramenta.cor,
                    fillOpacity: 0.5
                };
                
                if((num%largura) == 0){
                    console.log("direita");
                    if(num == largura){
                        console.log("superior");
                        rectangle.setOptions(opt);
                        rectArr[id-2].setOptions(opt);          // anterior
                        rectArr[id+largura-1].setOptions(opt);  // inferior
                    } else {
                        if(num == rectArr.length){
                            rectangle.setOptions(opt);
                            rectArr[id-2].setOptions(opt);          // anterior
                            rectArr[id-largura-1].setOptions(opt);  // superior
                            
                        } else {
                            console.log("todos que ficam no meio");
                            rectangle.setOptions(opt);
                            rectArr[id-2].setOptions(opt);          // anterior
                            rectArr[id-largura-1].setOptions(opt);  // superior
                            rectArr[id+largura-1].setOptions(opt);  // inferior
                        }
                        
                    }
                } else {
                    if((num%largura) == 1){
                        console.log("esquerda");
                        if(num-1 == 0){
                            console.log("superior");
                            rectangle.setOptions(opt);
                            rectArr[id].setOptions(opt);            // proximo
                            rectArr[id+largura-1].setOptions(opt);  // inferior
                        } else {
                            if((rectArr.length-largura) == num-1){
                                console.log("inferior");
                                rectangle.setOptions(opt);
                                rectArr[id].setOptions(opt);            // proximo
                                rectArr[id-largura-1].setOptions(opt);  // superior
                            } else {
                                console.log("todos que ficam no meio");
                                rectangle.setOptions(opt);
                                rectArr[id].setOptions(opt);            // proximo
                                rectArr[id-largura-1].setOptions(opt);  // superior
                                rectArr[id+largura-1].setOptions(opt);  // inferior
                            }
                            
                        }
                    } else {
                        if(id <= largura){
                            console.log("em cima");
                            rectangle.setOptions(opt);
                            rectArr[id-2].setOptions(opt);          // anterior
                            rectArr[id].setOptions(opt);            // proximo
                            rectArr[id+largura-1].setOptions(opt);  // inferior
                        } else {
                            if((rectArr.length - largura) <= num ){
                                console.log("em baixo");
                                rectangle.setOptions(opt);
                                rectArr[id-2].setOptions(opt);          // anterior
                                rectArr[id].setOptions(opt);            // proximo
                                rectArr[id-largura-1].setOptions(opt);  // superior
                            } else {
                                rectangle.setOptions(opt);
                                rectArr[id-2].setOptions(opt);
                                rectArr[id].setOptions(opt);
                                rectArr[id-largura-1].setOptions(opt);
                                rectArr[id+largura-1].setOptions(opt);
                                
                            } 
                            
                        }
                        
                    }
                    
                }
                
                
                break;
            case 9:
                var opt = {
                    fillColor: ferramenta.cor,
                    fillOpacity: 0.5
                };
                if((num%largura) == 0){
                    console.log("direita");
                    if(num == largura){
                        console.log("superior");
                        rectangle.setOptions(opt);
                        rectArr[id-2].setOptions(opt);          // anterior
                        rectArr[id+largura-2].setOptions(opt);  // inferior anterior
                        rectArr[id+largura-1].setOptions(opt);  // inferior
                    } else {
                        if(num == rectArr.length){
                            console.log("inferior");
                            rectangle.setOptions(opt);
                            rectArr[id-2].setOptions(opt);          // anterior
                            rectArr[id-largura-1].setOptions(opt);  // superior
                            rectArr[id-largura-2].setOptions(opt);  // superior anterior
                            
                        } else {
                            console.log("todos que ficam no meio");
                             rectangle.setOptions(opt);
                                rectArr[id-2].setOptions(opt);          // anterior
                                rectArr[id-largura-1].setOptions(opt);  // superior
                                rectArr[id-largura-2].setOptions(opt);  // superior anterior
                                rectArr[id+largura-2].setOptions(opt);  // inferior anterior
                                rectArr[id+largura-1].setOptions(opt);  // inferior
                        }
                        
                    }
                } else {
                    if((num%largura) == 1){
                        console.log("esquerda");
                        if(num-1 == 0){
                            console.log("superior");
                            rectangle.setOptions(opt);
                            rectArr[id].setOptions(opt);            // proximo
                            rectArr[id+largura].setOptions(opt);    // inferior proximo
                            rectArr[id+largura-1].setOptions(opt);  // inferior
                        } else {
                            if((rectArr.length-largura) == num-1){
                                console.log("inferior");
                                rectangle.setOptions(opt);
                                rectArr[id].setOptions(opt);            // proximo
                                rectArr[id-largura-1].setOptions(opt);  // superior
                                rectArr[id-largura].setOptions(opt);    // superior proximo
                            } else {
                                console.log("todos que ficam no meio");
                                rectangle.setOptions(opt);
                                rectArr[id].setOptions(opt);            // proximo
                                rectArr[id-largura-1].setOptions(opt);  // superior
                                rectArr[id-largura].setOptions(opt);    // superior proximo
                                rectArr[id+largura].setOptions(opt);    // inferior proximo
                                rectArr[id+largura-1].setOptions(opt);  // inferior
                            }
                            
                        }
                    } else {
                        if(id <= largura){
                            console.log("em cima");
                            rectangle.setOptions(opt);
                            rectArr[id-2].setOptions(opt);          // anterior
                            rectArr[id].setOptions(opt);            // proximo
                            rectArr[id+largura-2].setOptions(opt);  // inferior anterior
                            rectArr[id+largura].setOptions(opt);    // inferior proximo
                            rectArr[id+largura-1].setOptions(opt);  // inferior
                        } else {
                            if((rectArr.length - largura) <= num ){
                                console.log("em baixo");
                                rectangle.setOptions(opt);
                                rectArr[id-2].setOptions(opt);          // anterior
                                rectArr[id].setOptions(opt);            // proximo
                                rectArr[id-largura-1].setOptions(opt);  // superior
                                rectArr[id-largura-2].setOptions(opt);  // superior anterior
                                rectArr[id-largura].setOptions(opt);    // superior proximo
                            } else {
                                rectangle.setOptions(opt);
                                rectArr[id-2].setOptions(opt);          // anterior
                                rectArr[id].setOptions(opt);            // proximo
                                rectArr[id-largura-1].setOptions(opt);  // superior
                                rectArr[id-largura-2].setOptions(opt);  // superior anterior
                                rectArr[id-largura].setOptions(opt);    // superior proximo
                                rectArr[id+largura-2].setOptions(opt);  // inferior anterior
                                rectArr[id+largura].setOptions(opt);    // inferior proximo
                                rectArr[id+largura-1].setOptions(opt);  // inferior
                            } 
                            
                        }
                        
                    }
                }
                
                break;
        }
            
            
           // console.log(rectangle);
            
           // rectangle.setOptions(opt);
        });
    }
    /*
     *=======================================================================================
     *==========  
     */

    /*
     *  METODOS DO QUESTIONARIO
     *=======================================================================================
     *==========  
     */


    /**
     * Passa para a proxima pergunta
     * @returns {undefined}
     */
    function proximaPergunta() {
        resizeMap();
        salvarDados();
        questaoCorrente++;
        manipulaFormulario();
        ga('send', 'event', 'colaborarView', 'proximaPergunta');
    }

    /**
     * Retorna para a pergunta anterior
     * @returns {undefined}
     */
    function anteriorPergunta() {

        salvarDados();
        questaoCorrente--;
        manipulaFormulario();
                resizeMap();
        ga('send', 'event', 'colaborarView', 'anteriorPergunta');
    }

    /*
     * 
     * @returns {undefined}
     */
    function manipulaFormulario() {

        if (questaoCorrente === 1) {
            $('#btnAnterior').hide();
        } else {
            $('#btnAnterior').show();
        }

        if (questaoCorrente <= perguntas.length) {
            $('#btnProximo').show()
            $("#perguntasObjetivas").hide();
            $("#perguntasGrid").show();
            $("#contagem").html(perguntas[questaoCorrente - 1].ordem + " de " + perguntas.length)
            $("#pergunta").html(perguntas[questaoCorrente - 1].descricao);
            $("#ferramentas").show();
            $('#btnEnviar').hide();
            $("#info_tutorial").show();
            $("#interrogacao").show();
        } else {
            $("#perguntasGrid").hide();
            $("#contagem").html("<h3>Perguntas Objetivas</h3>");
            $("#pergunta").html("<small> Uma forma de filtrar os resultados da nossa pesquisa é você identificando determinados pontos.<br>Suas respostas serão sempre anônimas.</small>");
            $("#info_tutorial").hide();
            $("#interrogacao").hide();            
            $("#perguntasObjetivas").show();
            $('#btnProximo').hide();
            $('#btnEnviar').show();
        }
        preencheGrid();
    }

    /*
     * Salva os dados no vetor para manipulação
     * @returns {undefined}
     */
    function salvarDados() {
        var aux;
        var rect;

        if ((questaoCorrente - 1) === perguntas.length) {
            perguntasGrid[questaoCorrente - 1] = {
                perguntaQuestionarioId: perguntas[questaoCorrente - 2].id,
                respostaGrid: []
            };
            aux = questaoCorrente - 2;
        } else {
            perguntasGrid[questaoCorrente - 1] = {
                perguntaQuestionarioId: perguntas[questaoCorrente - 1].id,
                respostaGrid: []
            };
            aux = questaoCorrente - 1;
        }

        for (var i = 0; i < rectArr.length; i++) {
            if (rectArr[i].get('fillColor') !== 'transparent') {
                rect = {
                    idCelula: i,
                    cor: rectArr[i].get('fillColor'),
                    pontoSupEsq: {lat: rectArr[i].getBounds().getSouthWest().lat(),
                        lng: rectArr[i].getBounds().getNorthEast().lng()},
                    pontoInfDir: {lat: rectArr[i].getBounds().getNorthEast().lat(),
                        lng: rectArr[i].getBounds().getSouthWest().lng()}
                };
                perguntasGrid[aux].respostaGrid.push(rect);
            }
        }

    }

    /*
     * Preenche a grid conforme a situação,
     * caso ja tenha algo salvo mantem 
     * caso nao tenha nada limpa a grid 
     * @returns {undefined}
     */
    function preencheGrid() {
        if (typeof perguntasGrid[questaoCorrente - 1] !== 'undefined') {
            limparGrid();
            var aux = [];
            aux = perguntasGrid[questaoCorrente - 1].respostaGrid;
            if (aux.length !== 0) {

                for (var i = 0; i < aux.length; i++) {
                    var opt = {
                        fillColor: aux[i].cor,
                        fillOpacity: 0.5
                    };
                    rectArr[aux[i].idCelula].setOptions(opt);
                }
            }
        } else {
            limparGrid();
        }
    }

    /**
     * Envia o fomulario com todas as respostas para o banco de dados
     * retorna - sucesso (true);
     *         - falha   (false);
     * 
     * @returns {true or false}
     */
    function enviar() {
        $("#txtPerguntasGrid").val(JSON.stringify(perguntasGrid));

        if ($('input[name=nivelEscolaridade]:checked').val() === undefined) {
            $('#aviso_titulo').html('Questionario Incompleto.');
            $('#aviso_mensagem').html('Você não demarcou a pergunta referente ao <b>Nível de Escolaridade</b>.');
            $('#aviso').modal('show');
            $('#aviso_botao_resultado').hide();
            return 0;
        } else {
            if ($('input[name=rendaFamiliar]:checked').val() === undefined) {
                $('#aviso_titulo').html('Questionário Incompleto.');
                $('#aviso_mensagem').html('Você não demarcou a pergunta referente a<b> Renda Familiar</b>.');
                $('#aviso').modal('show');
                $('#aviso_botao_resultado').hide();
                return 0;
            } else {
                if ($('input[name=pensouComo]:checked').val() === undefined) {
                    $('#aviso_titulo').html('Questionário Incompleto.');
                    $('#aviso_mensagem').html('Você não demarcou a pergunta referente a <b>Como Você Pensou</b> ao responder o questionário.');
                    $('#aviso').modal('show');
                    $('#aviso_botao_resultado').hide();
                    return 0;
                }
            }
        }


        $.post(BASE_URL + 'publico/home/salvar',
                {
                    nivelEscolaridade: $('input[name=nivelEscolaridade]:checked').val(),
                    pensouComo: $('input[name=pensouComo]:checked').val(),
                    rendaFamiliar: $('input[name=rendaFamiliar]:checked').val(),
                    txtPerguntasGrid: $("#txtPerguntasGrid").val()
                },
        function(data) {
            var result = JSON.parse(data);
            if (result.success.message === 'success') {
                $("#perguntasObjetivas").hide();
                $("#perguntasGrid").hide();
                $('#aviso_titulo').html('Questionário respondido com sucesso');
                $('#aviso_mensagem').html('Sua resposta foi computada com sucesso, obrigado pela sua colaboração!');
                $("#icone").removeClass('fa fa-info-circle fa-3x');
                $("#icone").addClass('fa fa-check-circle-o fa-3x');
                $("#icone").css('color', 'green');
                $('#aviso').modal('show');
                $('#aviso_botao').click(function() {
                    ga('send', 'event', 'colaborarView', 'enviado_voltando');
                    location.href = BASE_URL;
                });
                $('#aviso_botao_resultado').show();
                $('#aviso_botao_resultado').click(function() {
                    ga('send', 'event', 'colaborarView', 'enviado_apuracao');
                    location.href = BASE_URL+"publico/home/apuracao/"+ $('#txtQuestionarioLink').val();
                    
                });
            } else {
                $("#perguntasObjetivas").hide();
                $("#perguntasGrid").hide();
                // ==============
                $('#aviso_titulo').html('Erro ao enviar o questionário.');
                $('#aviso_mensagem').html('Houve uma falha, tente novamente.');
                $("#icone").removeClass('fa fa-info-circle fa-3x');
                $("#icone").addClass('fa fa-remove fa-3x');
                $('#aviso').modal('show');

            }

        });
        ga('send', 'event', 'colaborarView', 'enviado');

    }



    /*
     *=======================================================================================
     *==========  
     */


     ga('send', 'event', 'colaborarView', 'pesquisaSelecionada', $('#txtQuestionarioLink').val());

</script>