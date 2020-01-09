<?= headerView() ?>

	<?=begin_ToolBar(array('imprimir', 'abrir', 'ajuda', 'pesquisar','novo','excluir'));?>
	<?=end_ToolBar();?>

	<?=begin_TabPanel('tabConf');?>
		<?=begin_Tab('Configuração');?>
			<?=begin_form('gerenciador/configuracao/salvar','formConfiguracao');?>
				
                            <?=form_hidden('txtCodigo', @$configuracao->id);?>

                            <?=form_label('lblNome', 'Nome do Perfil', 150);?>
                            <?=form_textField('txtNome', $configuracao->nome_perfil, 300, '','','',true);?>
                            <?=new_line();?>

                            <?=form_label('lblNome', 'Email de envio', 150);?>
                            <?=form_textField('email', $configuracao->email, 300, '');?>
                            <?=new_line();?>

                            <?=form_label('lblNome', 'Senha do email', 150);?>
                            <?=form_textField('senha', $configuracao->senha, 300, '');?>
                            <?=new_line();?>

                            <?=form_label('lblNome', 'Email do administrador', 150);?>
                            <?=form_textField('email_administrador', $configuracao->email_administrador, 300, '');?>
                            <?=new_line();?>

                            <?=form_label('lblNome', 'Email do administrador 2', 150);?>
                            <?=form_textField('email_administrador_2', $configuracao->email_administrador_2, 300, '');?>
                            <?=new_line();?>

			<?=end_form();?>
		<?=end_Tab();?>
	<?=end_TabPanel()?>

<script type="text/javascript">

    function salvar(){
        formConfiguracao_submit();
    }
    
    function formConfiguracao_callback(data){
        console.log(data);
        if (data.error != undefined) {
            messageErrorBox(data.error.message, data.error.field);
        } else {
            messageBox(data.success.message, atualizaFiltro);
        }
    }

    function atualizaFiltro(){
        location.reload();
    }
</script>

<?= footerView() ?>
