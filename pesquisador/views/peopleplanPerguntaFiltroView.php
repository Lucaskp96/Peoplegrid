<?= headerView() ?>

	<?=path_bread($path_bread);?>

	<?=begin_ToolBar(array('salvar', 'abrir', 'imprimir'));?>
	<?=end_ToolBar();?>

	<?=begin_TabPanel();?>
		<?=begin_Tab(lang('perguntaFiltro'));?>
                    <?=form_label('lblPergunta', lang('perguntaDescricao'), 80);?>
                    <?=form_textField('txtPergunta','', 500, '');?>
                <?=end_Tab();?>
	<?=end_TabPanel();?>

    <?=begin_JqGridPanel('gridPerguntas', 'auto', '', base_url().'pesquisador/peopleplanCriterio/listaPerguntas/', array('sortname'=> 'descricao', 'autowidth'=> true, 'toppager' => false, 'rowNum' => 15, 'pager'=> true, 'caption'=>lang('listaCriterios')));?>
        <?=addJqGridColumn('id', 'ID', 0, 'right', array('sortable'=>true, 'hidden'=> true));?>
        <?=addJqGridColumn('descricao', 'Descrição', 300, 'left', array('sortable'=>true));?>

        <?=addJqGridColumn('obrigatoria', 'Obrigatória', 40, 'center', array('sortable'=>true));?>
    <?=end_JqGridPanel();?>

<script type="text/javascript">

    function novo(){
        location.href = BASE_URL+'pesquisador/peopleplanCriterio/novo';
    }

    function pesquisar(){
        gridPerguntas.addParam('descricao', $("#txtPergunta").val());
        gridPerguntas.load();
    }

    function gridPerguntas_click(id){
        location.href = BASE_URL+'pesquisador/peopleplanCriterio/editar/'+id;
    }

    function excluir(){
        if (getSelectedRows('gridPerguntas').length == 0) {
            messageErrorBox('<?= lang('nenhumRegistroSelecionado') ?>');
        } else {
            messageConfirm('<?= lang('excluirRegistros') ?>', excluirPerguntas);
        }
    }

    function excluirPerguntas(confirmaExclusao){
        if (confirmaExclusao) {
            var perguntas = '';
            var perguntasGrid = gridPerguntas.getSelectedRows();
            for (var i = 0; i < perguntasGrid.length; i++) {
                if (perguntas == '') {
                    perguntas = perguntasGrid[i];
                } else {
                    perguntas += ',' + perguntasGrid[i];
                }
            }
            $.post(BASE_URL+'pesquisador/peopleplanCriterio/excluir/', {id: perguntas},
            function(data){
                if (data.success) {
                    messageBox("<?= lang('registroExcluido') ?>", pesquisar);
                } else {
                    messageErrorBox("<?= lang('registroNaoExcluido') ?>");
                }
            });
        }
    }

</script>

<?= footerView() ?>
