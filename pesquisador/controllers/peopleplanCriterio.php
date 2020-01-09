<?php

class PeopleplanCriterio extends Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('../../gerenciador/models/ProgramaModel', 'programaModel');
        $this->load->model('PeopleplanPerguntaModel', 'peopleplanPerguntaModel');
    }

    function index() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $this->load->view('peopleplanPerguntaFiltroView', $data);
    }

    function novo() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']) . ' / Novo';
        $this->load->view('peopleplanPerguntaView', $data);
    }

    function listaPerguntas() {
        $this->peopleplanPerguntaModel->getPerguntas($_GET);
    }


    function editar($idPergunta){
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $data['pergunta'] = $this->peopleplanPerguntaModel->getPergunta($idPergunta);
        $this->load->view('peopleplanPerguntaView', $data);
    }

    function salvar() {
        if ($_POST['txtId'] == '') {
            $ret = $this->peopleplanPerguntaModel->incluir($_POST);
        } else {
            $ret = $this->peopleplanPerguntaModel->alterar($_POST);
        }
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->peopleplanPerguntaModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }

    function excluir() {
        $isSUccess = $this->peopleplanPerguntaModel->excluir($_POST['id']);

        if ($isSUccess) {
            $this->ajax->addAjaxData('success', 'true');
        } else {
            $this->ajax->addAjaxData('success', 'false');
        }
        $this->ajax->returnAjax();
    }
}
