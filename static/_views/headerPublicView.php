<!doctype html>
<html lang="pt-BR" xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!-- Image Background Page Header -->
    <!-- Note: The background image is set within the business-casual.css file. -->

        <link rel="shortcut icon" href="<?= IMG ?>/favicon.ico">
        <script src='<?= JS . "/jquery-1.9.2.min.js" ?>'></script>
        <script src='<?= JS . "/jquery-ui-1.9.2.custom.min.js" ?>'></script>
        <script src='<?= JS . "/bootstrap.min.js" ?>'></script>
        <script src='<?= JS . "/jquery.maskedinput.min.js" ?>'></script>
        <script src='<?= JS . "/jquery.dataTables.min.js" ?>'></script>
        <script src='<?= JS . "/dataTables.bootstrap.js" ?>'></script>
        <script src='<?= JS . "/palette.js" ?>'></script>
        <script src='<?= JS . "/json2.js" ?>'></script>
        <script src='<?= JS . "/jquery.easing.min.js" ?>'></script>
        
        <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3.8&libraries=geometry&sensor=false&key=AIzaSyDOys_iLMENByufaj3kT4zg5XwpcQ8Bwyc"></script>
        <link href= '<?= CSS ?>/smoothness/jquery-ui-1.9.2.custom.min.css' rel="stylesheet">
        <link href= '<?= CSS ?>/bootstrap.min.css' rel="stylesheet">
        <link href= '<?= CSS ?>/bootstrap-theme.min.css' rel="stylesheet">
        <link href="<?= CSS ?>/font-awesome.min.css" rel="stylesheet">
        <link href="<?= CSS ?>/publico/colaborar.css" rel="stylesheet">
        <link href="<?= CSS ?>/publico/home.css" rel="stylesheet">
        <link href="<?= CSS ?>/publico/equipe.css" rel="stylesheet">
        <link href="<?= CSS ?>/scrolling-nav.css" rel="stylesheet">
        <link href='http://fonts.googleapis.com/css?family=Ek+Mukta:200,300,400,500,600,700,800' rel='stylesheet' type='text/css'>
        
        <meta name="viewport" content="width=device-width">
        <meta name="description" content="">
        <meta name="keywords" content="">
        <meta name="author" content="">
        

        <title><?=lang('titulo');?></title>
        <script>
            var BASE_URL = '<?= BASE_URL ?>';
            var CSS = '<?= CSS ?>';
            var IMG = '<?= IMG ?>';
            var JS = '<?= JS ?>';
        </script>
    </head>
    <body id="body" data-twttr-rendered="true" style='font-family: "Ek Mukta"!important;'>
        <script>
          (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
          })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

          ga('create', 'UA-40280251-4', 'auto');
          ga('send', 'pageview');

        </script>
        <div  id="aviso" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="aviso_titulo">Modal title</h4>
                    </div>
                    <div class="modal-body" style="margin-top: 10px;margin-bottom: 10px;padding-top: 10px;padding-bottom: 40px">
                        <div class="col-lg-1"><i id="icone" class="fa fa-info-circle fa-3x"></i></div><div class="col-lg-11" style="margin-top: 10px"><p id="aviso_mensagem"> One fine body&hellip;</p></div>
                    </div>
                    <div class="modal-footer">
                        <button id="aviso_botao" type="button" class="btn btn-default" data-dismiss="modal" aria-hidden="true">Certo</button>
                        <button id="aviso_botao_resultado" type="button" class="btn btn-default" data-dismiss="modal" aria-hidden="true">Ver Resultado</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div>






