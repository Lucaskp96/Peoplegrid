<?= headerView() ?>

	<?=path_bread($path_bread);?>

	<?=begin_ToolBar(array('salvar', 'abrir', 'imprimir'));?>
	<?=end_ToolBar();?>

	<?=begin_TabPanel();?>
		<?=begin_Tab(lang('criterioFiltro'));?>
                    <?=form_label('lblCriterio', lang('criterioDescricao'), 80);?>
                    <?=form_textField('txtCriterio','', 500, '');?>
                <?=end_Tab();?>
	<?=end_TabPanel();?>

    <?=begin_JqGridPanel('gridCriterios', 'auto', '', base_url().'pesquisador/peopleplanCriterio/listaCriterios/', array('sortname'=> 'descricao', 'autowidth'=> true, 'toppager' => false, 'rowNum' => 15, 'pager'=> true, 'caption'=>lang('listaCriterios')));?>
        <?=addJqGridColumn('id', 'ID', 0, 'right', array('sortable'=>true, 'hidden'=> true));?>
        <?=addJqGridColumn('descricao', 'Descrição', 300, 'left', array('sortable'=>true));?>

        <?=addJqGridColumn('obrigatorio', 'Obrigatório', 40, 'center', array('sortable'=>true));?>
    <?=end_JqGridPanel();?>

<script type="text/javascript">

    function novo(){
        location.href = BASE_URL+'pesquisador/peopleplanCriterio/novo';
    }

    function pesquisar(){
        gridCriterios.addParam('descricao', $("#txtCriterio").val());
        gridCriterios.load();
    }

    function gridCriterios_click(id){
        location.href = BASE_URL+'pesquisador/peopleplanCriterio/editar/'+id;
    }

    function excluir(){
        if (getSelectedRows('gridCriterios').length == 0) {
            messageErrorBox('<?= lang('nenhumRegistroSelecionado') ?>');
        } else {
            messageConfirm('<?= lang('excluirRegistros') ?>', excluirCriterios);
        }
    }

    function excluirCriterios(confirmaExclusao){
        if (confirmaExclusao) {
            var criterios = '';
            var criteriosGrid = gridCriterios.getSelectedRows();
            for (var i = 0; i < criteriosGrid.length; i++) {
                if (criterios == '') {
                    criterios = criteriosGrid[i];
                } else {
                    criterios += ',' + criteriosGrid[i];
                }
            }
            $.post(BASE_URL+'pesquisador/peopleplanCriterio/excluir/', {id: criterios},
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
