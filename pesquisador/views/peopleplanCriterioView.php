<?= headerView() ?>
    <?=path_bread($path_bread);?>

    <?=begin_ToolBar(array('imprimir', 'abrir', 'ajuda', 'pesquisar'));?>
    <?=end_ToolBar();?>

    <?=begin_TabPanel();?>
        <?=begin_Tab(lang('criteriosTab'));?>
            <?=begin_form('pesquisador/peopleplanCriterio/salvar', 'formCriterio');?>
                <?=form_hidden('txtId', @$criterio->id);?>

                <?=form_label('lblCriterio', lang('criterioDescricao'), 120);?>
                <?=form_textField('txtDescricao', @$criterio->descricao, 500, '');?>
                <?=new_line();?>

                <!-- Trecho responsável por pegar formulario dos pesos
                <?=form_label('lblPerguntaPeso', lang('perguntaPeso'), 120);?>
                <?=form_range('txtPonderador','txtPonderador', @$pergunta->peso, 1, 10);?>
                <?=new_line();?>
                -->

                <?=form_label('lblCriterioObrigatorio', lang('criterioObrigatorio'), 120, array('for'=>'chkCriterioObrigatorio'));?>
		<?=form_checkbox('chkCriterioObrigatorio', 'chkCriterioObrigatorio', 'S', TRUE,'', TRUE);?>
                <?=new_line();?>

            <?=end_form();?>
        <?=end_Tab();?>
    <?=end_TabPanel();?>

<script type="text/javascript">

    function init(){

    }

    function novo(){
        location.href = BASE_URL+'pesquisador/peopleplanCriterio/novo';
    }

    function filtro(){
        location.href = BASE_URL+'pesquisador/peopleplanCriterio';
    }

    function salvar(){
        formCriterio_submit();
    }

    function formCriterio_callback(data){
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
            messageConfirm('<?= lang('excluirRegistros') ?>', excluirCriterio);
        }
    }

    function excluirCriterio(confirmaExclusao){
        if (confirmaExclusao) {
            $.post(BASE_URL+'pesquisador/peopleplanCriterio/excluir', {id: $("#txtId").val()},
            function(data){
                if (data.success) {
                    messageBox("<?= lang('registroExcluido') ?>", novo);
                } else {
                    messageErrorBox("<?= lang('registroNaoExcluido') ?>");
                }
            });
        }
    }


</script>

<?= footerView() ?>
