<?= headerView() ?>

	<?=path_bread($path_bread);?>
        
	<?=begin_ToolBar(array('salvar', 'abrir', 'imprimir'));?>
	<?=end_ToolBar();?>

	<?=begin_TabPanel();?>
		<?=begin_Tab(lang('pesquisadorQuestionarioFiltro'));?>
                    <?=form_label('lblDescricao', lang('questionarioDescricao'), 80);?>
                    <?=form_textField('txtDescricao','', 500, '');?>
                <?=end_Tab();?>
	<?=end_TabPanel();?>
        
    <?=begin_JqGridPanel('gridQuestionarios', 'auto', '', base_url().'pesquisador/questionario/listaQuestionarios/', array('sortname'=> 'descricao', 'autowidth'=> true, 'toppager' => false, 'rowNum' => 15, 'pager'=> true, 'caption'=>lang('pesquisadorListaQuestionarios')));?>
        <?=addJqGridColumn('id', 'ID', 0, 'right', array('sortable'=>true, 'hidden'=> true));?>
        <?=addJqGridColumn('descricao', 'Descrição', 300, 'left', array('sortable'=>true));?>
        <?=addJqGridColumn('dt_inicio', 'Dt. Inicio', 30, 'center', array('sortable'=>true,'formatter'=>'date'));?>
        <?=addJqGridColumn('dt_fim', 'Dt. Fim', 30, 'center', array('sortable'=>true,'formatter'=>'date'));?>
        <?=addJqGridColumn('ativo_pelo_adm', 'Ativo pelo Administrador?', 50, 'center', array('sortable'=>true));?>
        <?=addJqGridColumn('ativo_pelo_pesquisador', 'Ativo pelo Pesquisador?', 50, 'center', array('sortable'=>true));?>
    <?=end_JqGridPanel();?>

<script type="text/javascript">

    function novo(){
        location.href = BASE_URL+'pesquisador/questionario/novo';
    }
    function pesquisar(){
        gridQuestionarios.addParam('descricao', $("#txtDescricao").val());
        gridQuestionarios.load();
    }

    function gridQuestionarios_click(id){
        location.href = BASE_URL+'pesquisador/questionario/editar/'+id;
    }
    
    function excluir(){
        if (getSelectedRows('gridQuestionarios').length == 0) {
            messageErrorBox('<?= lang('nenhumRegistroSelecionado') ?>');
        } else {
            messageConfirm('<?= lang('excluirQuestionarioAvisoPlural') ?>', excluirQuestionarios);
        }
    }
    
    function excluirQuestionarios(confirmaExclusao){
        if (confirmaExclusao) {
            var questionarios = '';
            var questionariosGrid = gridQuestionarios.getSelectedRows();
            for (var i = 0; i < questionariosGrid.length; i++) {
                if (questionarios == '') {
                    questionarios = questionariosGrid[i];
                } else {
                    questionarios += ',' + questionariosGrid[i];
                }
            }
            $.post(BASE_URL+'pesquisador/questionario/excluir/', {questionarios: questionarios},
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
