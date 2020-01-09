<?= headerView() ?>

	<?=path_bread($path_bread);?>
        
	<?=begin_ToolBar(array('salvar', 'abrir', 'imprimir','novo'));?>
	<?=end_ToolBar();?>

	<?=begin_TabPanel();?>
		<?=begin_Tab(lang('perguntasFiltro'));?>
                    <?=form_label('lblPergunta', lang('perguntasDescricao'), 100);?>
                    <?=form_textField('txtPergunta','', 500, '');?>
                    
                    <?=new_line();?>
                    
                    <?=form_label('lblPergunta', lang('perguntasNomeUsuario'), 100);?>
                    <?=form_textField('txtNome','', 500, '');?>

                <?=end_Tab();?>            
                
	<?=end_TabPanel();?>
        
    <?=begin_JqGridPanel('gridPerguntas', 'auto', '', base_url().'coordenador/peopleplanPerguntas/listaPerguntas/', array('sortname'=> 'descricao', 'autowidth'=> true, 'toppager' => false, 'rowNum' => 15, 'pager'=> true, 'caption'=>lang('listaPerguntas')));?>
        <?=addJqGridColumn('id', 'ID', 0, 'right', array('sortable'=>true, 'hidden'=> true));?>
        <?=addJqGridColumn('descricao', 'Descrição', 300, 'left', array('sortable'=>true));?>
        <?=addJqGridColumn('nome', 'Nome do Usuário', 100, 'center', array('sortable'=>true));?>
        <?=addJqGridColumn('obrigatoria', 'Obrigatória', 40, 'center', array('sortable'=>true));?>
    <?=end_JqGridPanel();?>

<script type="text/javascript">
    
    function pesquisar(){
        gridPerguntas.addParam('descricao', $("#txtPergunta").val());
        gridPerguntas.addParam('nome', $("#txtNome").val());
        gridPerguntas.load();
    }
    
    function gridPerguntas_click(id){
        location.href = BASE_URL+'coordenador/peopleplanPerguntas/editar/'+id;
    }
    
    function excluir(){
        if (getSelectedRows('gridPerguntas').length == 0) {
            messageErrorBox('<?= lang('nenhumRegistroSelecionado') ?>');
        } else {
            messageConfirm('<?= lang('excluirPerguntaAviso') ?>', excluirPerguntas);
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
            $.post(BASE_URL+'coordenador/peopleplanPerguntas/excluir/', {id: perguntas},
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
