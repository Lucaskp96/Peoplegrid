<?= headerView() ?>

    <?=path_bread($path_bread);?>
    
    <?=begin_ToolBar(array('salvar', 'abrir', 'imprimir'));?>
    <?=end_ToolBar();?>

    <?=begin_TabPanel();?>
            <?=begin_Tab(lang('pesquisadorFiltro'));?>

                <?=form_label('lblNome', lang('pesquisadorNome'), 80);?>
                <?=form_textField('txtNome','', 500, '');?> 
                <?=new_line()?>

                <?=form_label('lblLogin', lang('pesquisadorLogin'), 80);?>
                <?=form_textField('txtLogin','', 500, '');?>
                <?=new_line()?>
                
                <?=form_label('lblTipoUsuario', lang('pesquisadorTipoUsuario'), 80)?>
		<?=form_combo('cmbTipoUsuario', $tipoUsuarios, '', 150)?>
		<?=new_line()?>

            <?=end_Tab();?>
    <?=end_TabPanel();?>
        
    <?=begin_JqGridPanel('gridUsuarios', 'auto', '', base_url().'coordenador/pesquisador/listaUsuarios/', array('sortname'=> 'nome', 'autowidth'=> true, 'toppager' => false, 'rowNum' => 15, 'pager'=> true, 'caption'=>lang('pesquisadorListaUsuarios')));?>
        <?=addJqGridColumn('id', 'ID', 0, 'right', array('sortable'=>true, 'hidden'=> true));?>
        <?=addJqGridColumn('nome', 'Nome', 100, 'left', array('sortable'=>true));?>
        <?=addJqGridColumn('login', 'Login', 50, 'center', array('sortable'=>true));?>
        <?=addJqGridColumn('email', 'Email', 100, 'center', array('sortable'=>true));?>
        <?=addJqGridColumn('tipo_usuario', 'Tipo de Usuário', 50, 'center', array('sortable'=>true));?>
    <?=end_JqGridPanel();?>



<script type="text/javascript">
    
    function pesquisar(){
        gridUsuarios.addParam('nome', $("#txtNome").val());
        gridUsuarios.addParam('login', $("#txtLogin").val());
        gridUsuarios.addParam('tipo_usuario', $("#cmbTipoUsuario").val());
        gridUsuarios.load();
    }
    
    function gridUsuarios_click(id){
        location.href = BASE_URL+'coordenador/pesquisador/editar/'+id;
    }
    
    function novo(){
        location.href = BASE_URL+'coordenador/pesquisador/novo';
    }
    
    function excluir(){
        if (getSelectedRows('gridUsuarios').length == 0) {
            messageErrorBox('<?= lang('nenhumRegistroSelecionado') ?>');
        } else {
            messageConfirm('<?= lang('excluirRegistros') ?>', excluirUsuarios);
        }
    }
    
    function excluirUsuarios(confirmaExclusao){
        if (confirmaExclusao) {
            var usuarios = '';
            var usuariosGrid = gridUsuarios.getSelectedRows();
            for (var i = 0; i < usuariosGrid.length; i++) {
                if (usuarios == '') {
                    usuarios = usuariosGrid[i];
                } else {
                    usuarios += ',' + usuariosGrid[i];
                }
            }
            $.post(BASE_URL+'coordenador/pesquisador/excluir/', {id: usuarios},
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
