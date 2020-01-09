<?php

class Pergunta extends Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('../../gerenciador/models/ProgramaModel', 'programaModel');
        $this->load->model('PerguntaModel', 'perguntaModel');
        
    }

    function index() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $this->load->view('perguntaFiltroView', $data);
    }

    function novo() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']) . ' / Novo';
        $this->load->view('perguntaView', $data);
    }

    function listaPerguntas() {
        $this->perguntaModel->getPerguntas($_GET);
    }

    
    function editar($idPergunta){
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $data['pergunta'] = $this->perguntaModel->getPergunta($idPergunta);
        $this->load->view('perguntaView', $data);
    }
    
    function salvar() {
        if ($_POST['txtId'] == '') {
            $ret = $this->perguntaModel->incluir($_POST);
        } else {
            $ret = $this->perguntaModel->alterar($_POST);
        }
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->perguntaModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }
    
    function excluir() {
        $isSUccess = $this->perguntaModel->excluir($_POST['id']);

        if ($isSUccess) {
            $this->ajax->addAjaxData('success', 'true');
        } else {
            $this->ajax->addAjaxData('success', 'false');
        }
        $this->ajax->returnAjax();
    }
}
