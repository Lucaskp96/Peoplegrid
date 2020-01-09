<?= headerView() ?>

	<?=path_bread($path_bread);?>
        
	<?=begin_ToolBar(array('salvar', 'abrir', 'imprimir', 'pesquisar','novo','excluir'));?>
	<?=end_ToolBar();?>

<?= footerView() ?>