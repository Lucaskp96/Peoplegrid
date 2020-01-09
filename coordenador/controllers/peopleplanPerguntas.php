<?php

class PeopleplanPerguntas extends Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('../../gerenciador/models/ProgramaModel', 'programaModel');
        $this->load->model('PeopleplanPerguntasModel', 'perguntasModel');
        
    }

    function index() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $this->load->view('peopleplanPerguntasFiltroView', $data);
    }

    function listaPerguntas() {
        $this->perguntasModel->getPerguntas($_GET);
    }

    
    function editar($idPergunta){
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $data['pergunta'] = $this->perguntasModel->getPergunta($idPergunta);
        $this->load->view('peopleplanPerguntasView', $data);
    }
    
    function salvar() {
        $ret = $this->perguntasModel->alterar($_POST);
        
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->perguntasModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }
    
    function excluir() {
        $isSUccess = $this->perguntasModel->excluir($_POST['id']);

        if ($isSUccess) {
            $this->ajax->addAjaxData('success', 'true');
        } else {
            $this->ajax->addAjaxData('success', 'false');
        }
        $this->ajax->returnAjax();
    }
}
