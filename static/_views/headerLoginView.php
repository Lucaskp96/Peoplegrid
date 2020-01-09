<?php header("Content-Type: text/html; charset=UTF-8", true); ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
        <title><?= lang('titulo'); ?></title>
        <?= $this->load->view('../../static/_views/headerScripts'); ?>
        <link href="<?= CSS ?>/autenticacao/login.css" rel="stylesheet">
        <link href='http://fonts.googleapis.com/css?family=Ek+Mukta:200,300,400,500,600,700,800' rel='stylesheet' type='text/css'>
    </head>
    <?php flush(); ?>
    <!--[if lt IE 7 ]> <body class="ui-widget-content ie ie6" style="border: none !important; margin: 0px;"> <![endif]-->
    <!--[if (gt IE 9)|!(IE)]><!--> <body class="ui-widget-content" style="border: none !important; margin: 0px; font-family: Ek Mukta"> <!--<![endif]-->
        <div class="ui-layout-north ui-widget-content">
            <div id="carregando" class="ui-state-active ui-widget ui-state-default ui-corner-all">
                Carregando <img src="<?= IMG; ?>/ajax-loader.gif" style="margin-right: 5px; margin-left: 2px;" width="16px" height="11px"/>
            </div>
            <div id="cabecalho_img" class="logo"><!-- --></div>
            <h1 id="cabecalho_desc" class="ui-widget-content">
                <?= lang("sigla") ?>
            </h1>
        </div>
    <span style="clear:both;"><!-- --></span>
    <div class="ui-layout-center ui-widget-content" style="background: none !important; overflow: hidden !important; border: none !important">
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-40280251-4', 'auto');
      ga('send', 'pageview');

    </script>