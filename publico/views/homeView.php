<?= headerPublicView() ?>
<!--<script src='<?= JS . "/scrolling-nav.js" ?>'></script>
 _--> 
<!-- SESSÃO MENU SUPERIOR
================================================== -->
<!--  -->
<nav id="nav_cabecalho" class="navbar navbar-collapse navbar-fixed-top" role="navigation">
    <div class="container">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
            </button>
            <div class="navbar-header ">
                <img class="img-responsive" src="<?= base_url() ?>/static/_img/peoplegrid-simbolo-provisorio.png" height="48px" width="48px"></img>
            </div>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <ul class="nav navbar-nav">
                    <li><a class="page-scroll" href="#sobre"><b><?=  lang('homePeopleGrid'); ?></b></a></li>
                    <li><a class="page-scroll" href="#questionarios"><?=  lang('homeQuestionarios'); ?></a></li>
                    <li><a class="page-scroll" href="#apoiadores"><?=  lang('homeApoiadores'); ?></a></li>
                    <li><a href="<?= base_url() ?>publico/home/equipe"><?=  lang('homeEquipe'); ?></a></li>                    
                </ul>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="<?= base_url() ?>dashboard"><strong> <?=  lang('homeAreaRestrita'); ?> <i class="glyphicon glyphicon-log-in"></i></strong></a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Intro Section -->

<section id="sobre" class="intro-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div id="myCarousel" class="carousel slide" style="margin-top: 30px">
                    <!-- Indicators -->
                    <ol class="carousel-indicators">
                        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                        <li data-target="#myCarousel" data-slide-to="1"></li>
                    </ol>
                    <div class="carousel-inner">
                        <div class="item active">
                            <img src="<?= base_url(); ?>static/_img/carousel/carousel-1.jpg" alt="First slide">
                            <div class="container">
                                <div class="carousel-caption">
                                    <div align="right">
                                        <h2><?=  lang('homeLegendaCarousel1'); ?></h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <img src="<?= base_url(); ?>static/_img/carousel/carousel-2.jpg" alt="Second slide">
                            <div class="container">
                                <div class="carousel-caption">
                                    <div align="right">
                                        <h2><?=  lang('homeLegendaCarousel2'); ?></h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <a class="left carousel-control" href="#myCarousel" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
                    <a class="right carousel-control" href="#myCarousel" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
                </div>

                <div class='row' style="margin-bottom: 60px; margin-top: 60px; margin-left: 8px; margin-right: 8px; font-size:20px" >
                    <div class="textarea text-justify">
                        <p><?=  lang('homeSobre1'); ?> 
                            <b style="font-size:30px"><?=  lang('homeSobre2'); ?></b> 
                            <?=  lang('homeSobre3'); ?>
                            <b style="font-size:30px"> <?=  lang('homeSobre4'); ?> </b>
                            <?=  lang('homeSobre5'); ?>
                        </p>
                        </div>
                </div>
                
                <h5><center><i><?=  lang('homeListaQuestionarios'); ?></i></center></h5>
                <a id="elevador" class="btn btn-circle page-scroll center-block" href="#questionarios" style="margin-bottom: 550px"> 
                    <i class="fa fa-angle-double-down animated fa-5x">
                    </i>            
                </a>
            </div>
        </div>
    </div>
</section>

<!-- questionarios Section -->
<section id="questionarios" class="about-section">
    <div class="container">
        <div class="row">

            <!-- Sessão para questionários do PeopleGrid -->
            <div class="col-lg-12">
                <div id="header_listaQuestionarios" class="page-header">
                    <h1 style="font-weight: 200;"><?= lang('homeTituloQuestionarios'); ?></h1>
                    <h2 style="font-weight: 200;"><?= lang('homePeopleGridQuestionarios'); ?></h2>
                </div>

                <div id="div_listaQuestionarios">  
                    <div class="col-lg-12">
                        <form method="post" id="theForm" action="publico/home/colaborar">
                            <input type="hidden" id="questionarioId" name="questionarioId" value="value">
                        </form>
                        <table id="listaQuestionarios" class="table table-striped table-bordered table-hover" cellspacing="0" width="100%" style="font-family: Ek Mukta">
                            <thead>
                                <tr>
                                    <th id="descricao"><?= lang('homeTabelaDesc'); ?></th>
                                    <th id="dt_inicio"><?= lang('homeTabelaInicio'); ?></th>
                                    <th id="dt_fim"> <?= lang('homeTabelaFim'); ?></th>
                                    <th id="dt_fim"> <?= lang('homeTabelaResultado'); ?></th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                foreach ($questionarios as $q) {
                                    echo '<tr id="' . $q->link . '">'
                                    . '<td>' . $q->descricao . ' </td>'
                                    . '<td>' . $q->dt_inicio . ' </td>'
                                    . '<td>' . $q->dt_fim . '</td>'
                                    . '<td><a href="'.  base_url()."publico/home/apuracao/".$q->link.'"> Ver Resultado</a></td>'
                                    . '</tr>';
                                }
                                ?>                
                            </tbody>
                            
                        </table>
                        
                    </div>
                    
                </div>
            </div>
        </div>    
            <!-- Sessão para questionários do PeoplePlan -->
            <div class="row">
                <div id="header_listaQuestionarios" class="page-header">
                    <h2 style="font-weight: 200;"><?= lang('homePeoplePlanQuestionarios'); ?></h2>
                </div>

                <div id="div_listaQuestionariosPeopleplan">  
                    <div class="col-lg-12">
                        <form method="post" id="theForm" action="publico/peopleplanhome/colaborar">
                            <input type="hidden" id="questionarioId" name="questionarioId" value="value">
                        </form>
                        <table id="listaQuestionariosPeopleplan" class="table table-striped table-bordered table-hover" cellspacing="0" width="100%" style="font-family: Ek Mukta">
                            <thead>
                                <tr>
                                    <th id="descricao"><?= lang('homeTabelaDesc'); ?></th>
                                    <th id="dt_inicio"><?= lang('homeTabelaInicio'); ?></th>
                                    <th id="dt_fim"> <?= lang('homeTabelaFim'); ?></th>
                                    <th id="dt_fim"> <?= lang('homeTabelaResultado'); ?></th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                foreach ($questionariosPeopleplan as $qp) {
                                    echo '<tr id="' . $qp->link . '">'
                                    . '<td>' . $qp->descricao . ' </td>'
                                    . '<td>' . $qp->dt_inicio . ' </td>'
                                    . '<td>' . $qp->dt_fim . '</td>'
                                    . '<td><a href="'.  base_url()."publico/peopleplanhome/apuracao/".$qp->link.'"> Ver Resultado</a></td>'
                                    . '</tr>';
                                }
                                ?>                
                            </tbody>
                            
                        </table>
                        
                    </div>
                    
                </div>
            
            </div>
           
            
        </div>
    </div>
    
</section>





<!-- apoiadores Section -->
<section id="apoiadores" class="services-section">
    <div class="container">
        <div id="header_apoiadores" class="row">
            <div class="col-sm-4">
                <img class="img-circle center-block" src="<?= base_url() ?>static/_img/horizonte-logo-150x150.png" alt="Horizonte4Zeros" style="width: 150px; height: 150px;">
                <h2 class="text-center"><?= lang('homeHorizonte'); ?></h2>
                <p class="text-justify"><?= lang('homeHorizonteDesc'); ?></p>
                    <a class="btn btn-link" href="http://horizonte4zeros.ufpel.edu.br" role="button"><?= lang('homeLerMais'); ?></a>
                </p>
            </div>
            <div class="col-sm-4">
                <img class="img-circle center-block" src="<?= base_url() ?>static/_img/laburb-logo-150x150.png" alt="LabUrb" style="width: 150px; height: 150px;">
                <h2 class="text-center"><?= lang('homeLabUrb'); ?></h2>
                <p class="text-justify"><?= lang('homeLabUrbDesc'); ?></p>
                    <a class="btn btn-link" href="http://wp.ufpel.edu.br/laburb/" role="button"><?= lang('homeLerMais'); ?></a>
                </p>
            </div><!-- /.col-lg-4 -->
            <!-- /.col-lg-4 -->
            <div class="col-sm-4">
                <img class="img-circle center-block" src="<?= base_url() ?>static/_img/ufpel-logo-150x150.png" alt="UFPel" style="width: 150px; height: 150px;">
                <h2 class="text-center"><?= lang('homeUFPel'); ?></h2>
                <p class="text-justify"><?= lang('homeUFPelDesc'); ?></p>
                    <a class="btn btn-link" href="http://www.ufpel.edu.br/" role="button"><?= lang('homeLerMais'); ?></a>
                </p>
            </div><!-- /.col-lg-4 -->
        </div>
    </div>
</section>
<style type="text/css">
    tr{
        cursor: pointer;
    }
</style>
<script>
    
    function verResultado(link){
        console.log(link);
    }
    
    
    ga('send', 'event', 'homeView', 'visitada');
    $(document).ready(function() {
        $('#listaQuestionarios').dataTable();
        $('#listaQuestionarios_wrapper').css('font-size', '16px');
        $('#listaQuestionarios_filter').addClass('pull-right');
        $('#listaQuestionarios_filter label input').css('margin-left', '10px');
        $('#listaQuestionarios_filter label input').css('width', '300px');
        $('#listaQuestionarios_length label select').css('margin-left', '10px');
        $('#listaQuestionarios_length label select').css('margin-right', '10px');
        $('#listaQuestionarios_paginate').addClass('pull-right');
    });

    var rows = document.getElementById("listaQuestionarios").rows;
    if (rows != 0) {
        for (var i = 0; i < rows.length; i++) {
            rows[i].onclick = function() {
                if(this.id != ''){
                    acessaQuestionario(this.id);    
                }                
            };
        }
    }
    
    $(document).ready(function() {
        $('#listaQuestionariosPeopleplan').dataTable();
        $('#listaQuestionariosPeopleplan_wrapper').css('font-size', '16px');
        $('#listaQuestionariosPeopleplan_filter').addClass('pull-right');
        $('#listaQuestionariosPeopleplan_filter label input').css('margin-left', '10px');
        $('#listaQuestionariosPeopleplan_filter label input').css('width', '300px');
        $('#listaQuestionariosPeopleplan_length label select').css('margin-left', '10px');
        $('#listaQuestionariosPeopleplan_length label select').css('margin-right', '10px');
        $('#listaQuestionariosPeopleplan_paginate').addClass('pull-right');
    });

    var rows = document.getElementById("listaQuestionariosPeopleplan").rows;
    if (rows != 0) {
        for (var i = 0; i < rows.length; i++) {
            rows[i].onclick = function() {
                if(this.id != ''){
                    acessaQuestionarioPeopleplan(this.id);    
                }                
            };
        }
    }
   
    
    function acessaQuestionario(id) {
        
        ga('send', 'event', 'homeView', 'pesquisaSelecionada', String(id));
        

        location.href = BASE_URL+'publico/home/colaborar/'+id;
        /*
        $('#questionarioId').val(id);
        document.getElementById('theForm').submit();
        */
       
       
    }
    
    function acessaQuestionarioPeopleplan(id) {
        
        ga('send', 'event', 'homeView', 'pesquisaSelecionada', String(id));
        

        location.href = BASE_URL+'publico/peopleplanhome/colaborar/'+id;
        /*
        $('#questionarioId').val(id);
        document.getElementById('theForm').submit();
        */
       
       
    }


    function pesquisar() {
        if ($('#txtPesquisar').val() != '') {
            console.log($('#txtPesquisar').val());
        }
    }



</script>
<?= footerPublicView() ?>
