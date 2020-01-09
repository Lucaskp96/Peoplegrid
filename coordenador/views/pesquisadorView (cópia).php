<?= headerView() ?>
    <?=path_bread($path_bread);?>

    <?=begin_ToolBar(array('imprimir', 'abrir', 'ajuda', 'pesquisar'));?>
    <?=end_ToolBar();?>

    <?=begin_TabPanel();?>
        <?=begin_Tab(lang('pesquisadorUsuario'));?>
            <?=begin_form('coordenador/pesquisador/salvar', 'formPesquisador');?>
                <?=form_hidden('txtId', @$pesquisador->id);?>

                <?=form_label('lblNome', lang('pesquisadorNome'), 100);?>
                <?=form_textField('txtNome', @$pesquisador->nome, 400, '');?>
                <?=new_line();?>
                
                <?=form_label('lblSexo', lang('usuarioSexo'), 100);?>
                <?=form_radio('chkMasculino', 'chksexo', 'M', (@$pesquisador->sexo == 'M' || @$pesquisador->sexo == '' ? true : false));?>
                <?=form_label('lblSexoMasculino', lang('usuarioSexoMasculino'), 80, array('for'=>'chkMasculino'));?>
                <?=form_radio('chkFeminino', 'chksexo', 'F', (@$pesquisador->sexo == 'F' ? true : false));?>
                <?=form_label('lblSexoFeminino', lang('usuarioSexoFeminino'), 80, array('for'=>'chkFeminino'));?>
                <?=new_line();?>

                <?=form_label('lblDtNascimento', lang('usuarioDtNascimento'), 100);?>
                <?=form_dateField('dtNascimento', @$pesquisador->dt_nascimento);?>
                <?=new_line();?>
                
                <?=form_label('lblEmail', lang('pesquisadorEmail'), 100);?>
                <?=form_textField('txtEmail', @$pesquisador->email, 400, '');?>
                <?=new_line();?>

                <?=form_label('lblTelefone', lang('pesquisadorTelefone'), 100);?>
                <?=form_textField('txtTelefone', @$pesquisador->telefone, 200, '');?>
                <?=new_line();?>

                <?=new_line();?>
                <?= hr(); ?>
                <?=new_line();?>
                <?=new_line();?>

                <?=form_label('lblLogin', lang('pesquisadorLogin'), 100);?>
                <?=form_textField('txtLogin', @$pesquisador->login, 200, '');?>
                <?=new_line();?>

                <?=form_label('lblSenha', lang('pesquisadorSenha'), 100);?>
                <?=form_textField('txtSenha', @$pesquisador->senha, 200, '');?>
                <?=new_line();?>

                <?=form_label('lblTipoUsuario', lang('pesquisadorTipoUsuario'), 100)?>
		<?=form_combo('cmbTipoUsuario', $tipoUsuarios, @$pesquisador->tipo_usuario_id, 150)?>
		<?=new_line()?>


            <?=end_form();?>
        <?=end_Tab();?>
    <?=end_TabPanel();?>

<script type="text/javascript">

    $(document).ready(function(){
        $('#txtTelefone').mask('(99) 9999-9999');

    });

    function novo(){
        location.href = BASE_URL+'coordenador/pesquisador/novo';
    }
    
    function filtro(){
        location.href = BASE_URL+'coordenador/pesquisador';
    }
    
    function salvar(){
        formPesquisador_submit();
    }
    
    function formPesquisador_callback(data){
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
            messageConfirm('<?= lang('excluirRegistros') ?>', excluirPergunta);
        }
    }

    function excluirPergunta(confirmaExclusao){
        if (confirmaExclusao) {
            $.post(BASE_URL+'coordenador/pesquisador/excluir', {id: $("#txtId").val()},
            function(data){
                if (data.success) {
                    messageBox("<?= lang('registroExcluido') ?>", filtro);
                } else {
                    messageErrorBox("<?= lang('registroNaoExcluido') ?>");
                }
            });
        }
    }


</script>

<?= footerView() ?>
