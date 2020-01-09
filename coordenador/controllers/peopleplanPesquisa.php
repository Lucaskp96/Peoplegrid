<?php

class PeopleplanPesquisa extends Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('../../gerenciador/models/ProgramaModel', 'programaModel');
        $this->load->model('../../pesquisador/models/PeopleplanQuestionarioPerguntasModel', 'questionarioPerguntasModel');
        $this->load->model('PeopleplanPesquisaModel', 'pesquisaModel');
    }
    
    
    function index() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $data['ativoAdm'] = array (array ("S", 'SIM'), array ("N", 'NÃO'));
        $data['ativoPesq'] = array (array ("S", 'SIM'), array ("N", 'NÃO'));
        $this->load->view('peopleplanPesquisaFiltroView', $data);
    }


    function listaPesquisas() {
       $this->pesquisaModel->getPesquisas($_GET);
    }
    
    function editar($questionario_id) {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']) . ' / Editar';
        $data['questionario'] = $this->pesquisaModel->getPesquisa($questionario_id);
        $data['perguntas'] = $this->questionarioPerguntasModel->getPerguntasDisponiveisAdmin($questionario_id, $data['questionario']->pessoa_id);
        $data['perguntasQuestionario'] = $this->questionarioPerguntasModel->getQuestionarioPerguntasGridByQuestionarioId($questionario_id);
        $this->load->view('peopleplanPesquisaView', $data);
    }
    
    function salvar() {
        
        $ret = $this->pesquisaModel->alterar($_POST);
        
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->pesquisaModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }
    
    function excluir(){
        $isSucess = $this->pesquisaModel->excluir($_POST['pesquisas']);

        if ($isSucess) {
            $this->ajax->addAjaxData('success', true);
        } else {
            $this->ajax->addAjaxData('success', false);
        }
        $this->ajax->returnAjax();
    }
    
    
    function listaPerguntas(){
        $this->PerguntaModel->getPerguntas($_GET);    
    }
    
    function listaQuestionarioPerguntas() {
        if($_POST['questionarioId'] != ''){
            $this->ajax->addAjaxData('questionarioPerguntas', $this->peopleplanQuestionarioModel->getQuestionarioPerguntasGrid($_POST['questionarioId']));
            $this->ajax->returnAjax();
        } else {
            $this->ajax->addAjaxData(NULL);
            $this->ajax->returnAjax();
        }
        
    }
    
    
    
}