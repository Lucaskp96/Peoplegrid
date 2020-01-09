<?= $this->load->view("../../static/_views/headerLoginView"); ?>


<div id="margem">
    <div id="div_descricao" >										
        <ul id="lista">	 		
            <h1 id="desc_titulo"><?= lang('loginTitulo') ?></h1>
            <ul style="padding-right: 0px;">
                <li id="sem_item">						 		
                    <p id="desc_peoplegrid" >					 			
                        <?= lang('loginDesc1') ?>
                    </p>					 			
                    <p id="desc_peoplegrid" >
                        <?= lang('loginDesc2') ?>
                    </p>
                    <br/>
                    <p id="desc_peoplegrid" >
                        <b><?= lang('loginConhecaProjeto') ?> </b> 
                        <a href="<?= base_url(); ?>" target="_blank"><?= lang('loginBitBucket') ?> </a>
                    </p>                    
                    <p id="desc_peoplegrid" >
                        <b><?= lang('loginEquipeIdealizadora') ?> </b>
                        <a href="<?= base_url() ?>publico/home/equipe" target="_blank"> <?= lang('loginEquipe') ?></a>
                    </p>
                    
                </li>						 	
            </ul>				 		

            <br/>

            <h2><?= lang('loginPesquisador') ?></h2>
            <ul>
                <li id="sem_item">
                    <p id="desc_peoplegrid"><?= lang('loginDescEmail') ?></p>
                    <p id="desc_peoplegrid"><?= lang('loginEmail') ?></p>
                </li>
                <input id="btnVoltar" name="btnVoltar" onclick="voltar()" type="submit"  value="<?= lang('voltar'); ?>" style="margin-top: 20px;"/>
            </ul>
            
        </ul>
        <?= new_line(); ?>
        <div style="height: 200px; float: left;"><!--class="description-cobalto" --></div>
    </div>
</div>

<div id="margem">
    <div style="float: right; padding: 2px 2px 0px 2px; margin:30px; width:360">
        <?= begin_TabPanel(); ?>
        <?= begin_Tab(lang('acessoSistema')); ?>
        <?= begin_form('autenticacao/login/entrar', 'formLogin'); ?>
        <?= form_label('lblEmail', lang('login'), 60); ?>
        <?= form_textField('txtEmail', '', 240); ?>
        <?= new_line(); ?>
        <?= form_label('lblSenha', lang('usuarioSenha'), 60); ?>
        <?= form_textField('txtSenha', '', 240, '', '', array('type' => 'password')); ?>
        <?= new_line(); ?>
        <input id="btnEntrar" name="btnEntrar" type="submit" value="<?= lang('entrar'); ?>" style="margin-bottom: 0px;"/>
        <?= end_form(); ?>
        <?= end_Tab(); ?>
        <?= end_TabPanel(); ?>
        <span style="float: right;"><!-- Versão do manager aqui --></span>
        <!--  <img class="img-responsive" src="<?= base_url() ?>/static/_img/img-login.png" height="auto" width="auto"/> -->   
    </div>
</div>

<script type="text/javascript">
    function init() {
        $("#btnEntrar").bind('click', entrar);
        $('#txtEmail').focus();
    }
    
    function voltar(){
        ga('send', 'event', 'loginView', 'visitada','voltar');
        location.href = BASE_URL;
    }
    
    function entrar() {
        $("#btnEntrar").blur();
        formLogin_submit();
        ga('send', 'event', 'loginView', 'visitada','entrar');
    }

    function formLogin_callback(data) {
        if (data.error != undefined) {
            messageErrorBox(data.error.message, data.error.field);
        } else {
            if (data.success != undefined) {
                location.href = BASE_URL + 'dashboard';
            }
        }
    }
    ga('send', 'event', 'loginView', 'visitada');
</script>

<?= $this->load->view("../../static/_views/footerLoginView"); ?>
