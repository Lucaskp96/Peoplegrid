<?= headerPublicView() ?>
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
                    <li><a href="<?= base_url() ?>publico/home/"><b> <?=  lang('equipePeopleGrid'); ?></b></a></li>
                    <li><a href="<?= base_url() ?>publico/home/equipe"><?=  lang('equipeEquipe'); ?></a></li>  
                </ul>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="<?= base_url() ?>dashboard"><strong> <?=  lang('equipeAreaRestrita'); ?> <i class="glyphicon glyphicon-log-in"></i></strong></a></li>
            </ul>
        </div>
    </div>
</nav>
<section id="sobre" class="intro-section">
    <div class="container" >

        <div class="page-header" style="margin-top: 55px;">
            <h1 id="titulo_cabecalho" class="h1"> <?=  lang('equipeEquipe'); ?> </h1>
            <p id="desc_cabecalho" class="lead">
              <?=  lang('equipeDescricaoCabecalho'); ?>
        </div>


        <h2 id="integrantes" style='padding-bottom:25px'><?=  lang('equipeIntegrantes'); ?></h2>


        <div class="row" style='padding-bottom: 25px'>    
            <div class="col-xs-2">
                <img src="<?= base_url() ?>static/_img/equipe/mauricio.jpg" alt="Polidori" class="img-thumbnail">
            </div>
            <div id="desc_integrantes" class="col-xs-4">
                <h4><p><b><?=  lang('equipeMauricio'); ?></b></p></h4>
                <p><?=  lang('equipeLocal'); ?></p>
                <p><?=  lang('equipeProfessor'); ?></p>
                <h5><p><?= lang('emailMauricio'); ?></p></h5>
            </div>   
            <div class="col-xs-2">
                <img src="<?= base_url() ?>static/_img/equipe/otavio.jpg" alt="Otávio" class="img-thumbnail">
            </div>
            <div id="desc_integrantes" class="col-xs-4">

                <h4><p><b><?=  lang('equipeOtavio'); ?></b></p></h4>
                <p><?=  lang('equipeLocal'); ?></p>
                <p><?=  lang('equipeProfessor'); ?></p>
                <h5><p><?= lang('emailOtavio'); ?></p></h5>
            </div>
        </div>

        <div class="row"  style='padding-bottom: 25px'>    
            <div class="col-xs-2">
                <img src="<?= base_url() ?>static/_img/equipe/andre.jpg" alt="Peil" class="img-thumbnail">
            </div>

            <div id="desc_integrantes" class="col-xs-4">
                <h4><p><b><?=  lang('equipeAndre'); ?></b></p></h4>
                <p><?=  lang('equipeLocal'); ?></p>
                <p><?=  lang('equipeEstudante'); ?></p>
                <h5><p><?= lang('emailAndre'); ?></p></h5>
            </div>

            <div class="col-xs-2">
                <img src="<?= base_url() ?>static/_img/equipe/glauco.jpg" alt="Glauco" class="img-thumbnail">
            </div>
            <div id="desc_integrantes" class="col-xs-4">
                <h4><p><b><?=  lang('equipeGlauco'); ?></b></p></h4>
                <p><?=  lang('equipeLocal'); ?></p>
                <p><?=  lang('equipeEstudante'); ?></p>
                <h5><p><?= lang('emailGlauco'); ?></p></h5>

            </div>
        </div>
        <div class="row"    style='padding-bottom: 25px'>
            <div class="col-xs-2">
                <img src="<?= base_url() ?>static/_img/equipe/miguel.jpg" alt="Miguel" class="img-thumbnail">
            </div>
            
            <div id="desc_integrantes" class="col-xs-4">
                <h4><p><b><?=  lang('equipeMiguel'); ?></b></p></h4>
                <p><?=  lang('equipeLocal'); ?></p>
                <p><?=  lang('equipeEstudante2'); ?></p>
                <h5><p><?= lang('emailMiguel'); ?></p></h5>
            </div>
            
        </div>
    </div>
</section>

<script>
/*    
    function linkedin($id) {

        switch ($id) {
            case 1:
                // Maurico
                window.location.href = "";
                break;
            case 2:
                // Otávio
                window.location.href = "";
            case 3:
                // Peil
                window.location.href = "https://www.linkedin.com/profile/view?id=129238399&trk=nav_responsive_tab_profile";
                break;
            case 4:
                // Glauco
                window.location.href = "";
                break;

        }
    }

    function plus($id) {

        switch ($id) {
            case 1:
                // Mauricio
                window.location.href = "";
                break;
            case 2:
                // Otávio
                window.location.href = "";
            case 3:
                // Peil
                window.location.href = "";
                break;
            case 4:
                // Glauco
                window.location.href = "";
                break;
            case 5:
                // Miguel
                window.location.href = "https://plus.google.com/u/0/116887370616586373749"
        }
    }

    function git($id) {

        switch ($id) {
            case 1:
                // Mauricio
                window.location.href = "";
                break;
            case 2:
                // Otávio
                window.location.href = "";
            case 3:
                // Peil
                window.location.href = "https://github.com/andreguipeil";
                break;
            case 4:
                // Glauco
                window.location.href = "https://github.com/glaucomunsberg";
                break;

        }
    }


*/
</script>
<?= footerPublicView() ?>