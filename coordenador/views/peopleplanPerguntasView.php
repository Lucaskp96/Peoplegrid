<?= headerView() ?>
    <?=path_bread($path_bread);?>

    <?=begin_ToolBar(array('imprimir', 'abrir', 'ajuda', 'pesquisar', 'novo'));?>
    <?=end_ToolBar();?>

    <?=begin_TabPanel();?>
        <?=begin_Tab(lang('perguntasTab'));?>
            <?=begin_form('coordenador/peopleplanPerguntas/salvar', 'formPergunta');?>
                <?=form_hidden('txtId', @$pergunta->id);?>

                <?=form_label('lblPergunta', lang('perguntasDescricao'), 120);?>
                <?=form_textField('txtDescricao', @$pergunta->descricao, 500, '');?>
                <?=new_line();?>

                <?=form_label('lblPergunta', lang('perguntasNomeUsuario'), 120);?>
                <?=form_textField('txtNomeUsuario', @$pergunta->nome, 500, '','','',true);?>
                <?=new_line();?>


                <?=form_label('lblPerguntaObrigatoria', lang('perguntasObrigatoria'), 120, array('for'=>'chkPerguntaObrigatoria'));?>
		<?=form_checkbox('chkPerguntaObrigatoria', 'chkPerguntaObrigatoria', 'S', TRUE,'', TRUE);?>
                <?=new_line();?>

            <?=end_form();?>
        <?=end_Tab();?>
    <?=end_TabPanel();?>

<script type="text/javascript">

    function init(){
        
    }
    
    function filtro(){
        location.href = BASE_URL+'coordenador/peopleplanPerguntas';
    }
    
    function salvar(){
        formPergunta_submit();
    }
    
    function formPergunta_callback(data){
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
            messageConfirm('<?= lang('excluirPerguntaAviso') ?>', excluirPergunta);
        }
    }

    function excluirPergunta(confirmaExclusao){
        if (confirmaExclusao) {
            $.post(BASE_URL+'coordenador/peopleplanPerguntas/excluir', {id: $("#txtId").val()},
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
