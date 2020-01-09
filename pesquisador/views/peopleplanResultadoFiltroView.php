<?= headerView() ?>
    <?=path_bread($path_bread);?>
        
	<?=begin_ToolBar(array('salvar', 'abrir', 'imprimir', 'novo', 'excluir'));?>
	<?=end_ToolBar();?>

	<?=begin_TabPanel();?>
		<?=begin_Tab(lang('pesquisadorQuestionarioFiltro'));?>
                    <?=form_label('lblDescricao', lang('questionarioDescricao'), 80);?>
                    <?=form_textField('txtDescricao','', 500, '');?>
                <?=end_Tab();?>
	<?=end_TabPanel();?>
        
        <?=begin_JqGridPanel('gridQuestionariosResultados', 'auto', '', base_url().'pesquisador/peopleplanResultado/listaQuestionarios/', array('sortname'=> 'descricao', 'autowidth'=> true, 'toppager' => false, 'rowNum' => 15, 'pager'=> true, 'caption'=>lang('pesquisadorListaQuestionarios')));?>
            <?=addJqGridColumn('id', 'ID', 0, 'right', array('sortable'=>true, 'hidden'=> true));?>
            <?=addJqGridColumn('descricao', 'Descrição', 300, 'left', array('sortable'=>true));?>
            <?=addJqGridColumn('dt_inicio', 'Dt. Inicio', 30, 'center', array('sortable'=>true,'formatter'=>'date'));?>
            <?=addJqGridColumn('dt_fim', 'Dt. Fim', 30, 'center', array('sortable'=>true,'formatter'=>'date'));?>
            
        <?=end_JqGridPanel();?>    

<script>
    function pesquisar(){
        gridQuestionariosResultados.addParam('descricao', $("#txtDescricao").val());
        gridQuestionariosResultados.load();
    }
    
    function gridQuestionariosResultados_click(id){
        location.href = BASE_URL+'pesquisador/peopleplanResultado/visualizar/'+id;
    }
</script>
<?= footerView() ?>