<?php

class Pesquisador extends Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('../../gerenciador/models/ProgramaModel', 'programaModel');
        $this->load->model('../../gerenciador/models/GrupoAcessoModel', 'grupoAcessoModel');
        $this->load->model('PesquisadorModel', 'pesquisadorModel');
        $this->load->model('../../gerenciador/models/UsuarioModel', 'usuarioModel');
    }
    
    
    function index() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $data['tipoUsuarios'] = $this->grupoAcessoModel->getGruposAcessosCombo();
        
        $this->load->view('pesquisadorFiltroView', $data);
    }
    
    function listaUsuarios(){
         $this->pesquisadorModel->getUsuarios($_GET);
    }
    
    function editar($usuario_id) {
        $data['pesquisador'] = $this->pesquisadorModel->getUsuario($usuario_id);
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']) . ' / Editar / ' . $data['pesquisador']->nome;
        $data['tipoUsuarios'] = $this->grupoAcessoModel->getGruposAcessosCombo();
        $this->load->view('pesquisadorView', $data);
    }
    
    function salvar() {
       // $this->auth->check_logged('gerenciador/' . $this->router->class, $this->router->method);

        if ($_POST['txtId'] == '') {
            $ret = $this->pesquisadorModel->incluir($_POST);
        } else {
            $ret = $this->pesquisadorModel->alterar($_POST);
        }
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->pesquisadorModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }

    
    function novo() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']) . ' / Novo';
        $data['tipoUsuarios'] = $this->grupoAcessoModel->getGruposAcessosCombo();
        $this->load->view('pesquisadorView', $data);
    }
    
    
    function excluir() {
        $isSUccess = $this->pesquisadorModel->excluir($_POST['id']);

        if ($isSUccess) {
            $this->ajax->addAjaxData('success', 'true');
        } else {
            $this->ajax->addAjaxData('success', 'false');
        }
        $this->ajax->returnAjax();
    }
}