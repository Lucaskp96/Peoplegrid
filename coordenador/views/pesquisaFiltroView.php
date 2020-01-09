<?= headerView() ?>

    <?=path_bread($path_bread);?>

    <?=begin_ToolBar(array('salvar', 'abrir', 'imprimir', 'novo'));?>
    <?=end_ToolBar();?>

    <?=begin_TabPanel();?>
        <?=begin_Tab(lang('pesquisaFiltro'));?>
        
                <?=form_label('lblDescricao', lang('pesquisaDescricao'), 100);?>
                <?=form_textField('txtDescricao','', 500, '');?> 
                <?=new_line()?>
                
                <?=form_label('lblAtivo', lang('pesquisaAtivaADM'), 100)?>
		<?=form_combo('cmbAtivoPeloAdm', $ativoPesq, @$ativoPesq, 100)?>
		<?=new_line()?>
                
                <?=form_label('lblAtivo', lang('pesquisaAtivaPESQ'), 100)?>
		<?=form_combo('cmbAtivoPeloPesq', $ativoAdm, @$ativoAdm, 100)?>
		<?=new_line()?>
                
                <?=form_label('lblNome', lang('pesquisaNomeUsuario'), 100);?>
                <?=form_textField('txtNome','', 500, '');?> 
                <?=new_line()?>

        <?=end_Tab();?>
    <?=end_TabPanel();?>

        <?=begin_JqGridPanel('gridPesquisas', 'auto', '', base_url().'coordenador/pesquisa/listaPesquisas/', array('sortname'=> 'nome', 'autowidth'=> true, 'toppager' => false, 'rowNum' => 15, 'pager'=> true, 'caption'=>lang('pesquisaListaPesquisas')));?>
        <?=addJqGridColumn('id', 'ID', 0, 'right', array('sortable'=>true, 'hidden'=> true));?>
        <?=addJqGridColumn('descricao', 'Descrição', 200, 'left', array('sortable'=>true));?>
        <?=addJqGridColumn('dt_inicio', 'Dt. Inicio', 30, 'center', array('sortable'=>true,'formatter'=>'date'));?>
        <?=addJqGridColumn('dt_fim', 'Dt. Fim', 30, 'center', array('sortable'=>true,'formatter'=>'date'));?>
        <?=addJqGridColumn('ativo_pelo_pesquisador', 'Ativo Pelo Pesquisador?', 40, 'center', array('sortable'=>true));?>
        <?=addJqGridColumn('ativo_pelo_adm', 'Ativo Pelo Administrador?', 40, 'center', array('sortable'=>true));?>
        <?=addJqGridColumn('nome', 'Usuário', 50, 'center', array('sortable'=>true));?>
        
    <?=end_JqGridPanel();?>

<?= footerView() ?>

<script type="text/javascript">
    
    function pesquisar(){
        gridPesquisas.addParam('nome', $("#txtNome").val());
        gridPesquisas.addParam('descricao', $("#txtDescricao").val());
        gridPesquisas.addParam('ativoPesq', $("#cmbAtivoPeloPesq").val());
        gridPesquisas.addParam('ativoAdm', $("#cmbAtivoPeloAdm").val());
        gridPesquisas.load();
    }

    function gridPesquisas_click(id){
        location.href = BASE_URL+'coordenador/pesquisa/editar/'+id;
    }
    
    
    function excluir(){
        if (getSelectedRows('gridPesquisas').length == 0) {
            messageErrorBox('<?= lang('nenhumRegistroSelecionado') ?>');
        } else {
            messageConfirm('<?= lang('excluirPesquisasAvisoPlural') ?>', excluirPesquisas);
        }
    }
    
    function excluirPesquisas(confirmaExclusao){
        if (confirmaExclusao) {
            var pesquisas = '';
            var pesquisasGrid = gridPesquisas.getSelectedRows();
            for (var i = 0; i < pesquisasGrid.length; i++) {
                if (pesquisas == '') {
                    pesquisas = pesquisasGrid[i];
                } else {
                    pesquisas += ',' + pesquisasGrid[i];
                }
            }
            $.post(BASE_URL+'coordenador/pesquisa/excluir/', {pesquisas: pesquisas},
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