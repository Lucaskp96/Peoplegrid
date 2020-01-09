<?php

class PeopleplanQuestionario extends Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('../../gerenciador/models/ProgramaModel', 'programaModel');
        $this->load->model('peopleplanQuestionarioModel', 'peopleplanQuestionarioModel');
        $this->load->model('peopleplanPerguntaModel', 'peopleplanPerguntaModel');
        $this->load->model('peopleplanQuestionarioPerguntasModel', 'peopleplanQuestionarioPerguntasModel');
        $this->load->model('../../gerenciador/models/ConfiguracaoModel', 'configuracaoModel');
        $this->load->model('../../gerenciador/models/EmailModel', 'emailModel');
        
    }

    function index() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $this->load->view('peopleplanQuestionarioFiltroView', $data);
    }

    function listaQuestionarios() {
        $this->peopleplanQuestionarioModel->getQuestionarios($_GET);
    }
    
    function listaPerguntas(){
        $this->peopleplanPerguntaModel->getPerguntas($_GET);    
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

    function novo() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']) . ' / Novo';
        $data['ativo'] = array (array ("S", 'SIM'), array ("N", 'NÃO'));
        $data['perguntas'] = $this->peopleplanPerguntaModel->getPerguntasForArray($_GET);
        $this->load->view('peopleplanQuestionarioView', $data);
    }
    
    function editar($idQuestionario){
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $data['questionario'] = $this->peopleplanQuestionarioModel->getQuestionario($idQuestionario);
        $data['perguntas'] = $this->peopleplanQuestionarioPerguntasModel->getPerguntasDisponiveis($idQuestionario);
        $data['perguntasQuestionario'] = $this->peopleplanQuestionarioPerguntasModel->getQuestionarioPerguntasGridByQuestionarioId($idQuestionario);
        $this->load->view('peopleplanQuestionarioView', $data);
    }
    
    function excluir(){
        $isSucess = $this->peopleplanQuestionarioModel->excluir($_POST['questionarios']);

        if ($isSucess) {
            $this->ajax->addAjaxData('success', true);
        } else {
            $this->ajax->addAjaxData('success', false);
        }
        $this->ajax->returnAjax();
    }
    
    function salvarQuestionario() {
        if ($_POST['txtId'] == '') {
            $ret = $this->peopleplanQuestionarioModel->incluir($_POST);
            
            //$email = $this->configuracaoModel->getEmail();
            //$emailAdministrador = $this->configuracaoModel->getEmailAdministrador();
            //$emailAdministrador2 = $this->configuracaoModel->getEmailAdministrador2();
            //$senha = $this->configuracaoModel->getSenha();

            //$this->emailModel->notificaAdministradorDoSistema($email,$senha,$emailAdministrador,"Nova pesquisa", "Olá administrador, foi criado mais uma nova pesquisa no <b>PeopleGrid</b> por um dos colaboradores do projeto.");
            //$this->emailModel->notificaAdministradorDoSistema($email,$senha,$emailAdministrador2,"Nova pesquisa", "Olá administrador, foi criado mais uma nova pesquisa no <b>PeopleGrid</b> por um dos colaboradores do projeto.");
        } else {
            $ret = $this->peopleplanQuestionarioModel->alterar($_POST);
        }
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->peopleplanQuestionarioModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }
    
    function salvarReferenciaMapa(){
        if ($this->peopleplanQuestionarioModel->verificaReferenciaMapa($_POST['txtIdQuestionarioReferencia'])) {
            $ret = $this->peopleplanQuestionarioModel->incluirReferenciaMapa($_POST);
        } else {
            $this->peopleplanQuestionarioModel->excluirMapaAntigo($_POST['txtIdQuestionarioReferencia']);
            $this->peopleplanQuestionarioModel->limpaReferenciaMapa($_POST['txtIdQuestionarioReferencia']);
            $ret = $this->peopleplanQuestionarioModel->incluirReferenciaMapa($_POST);
        }
        
        $this->ajax->addAjaxData('perguntas', $this->peopleplanQuestionarioPerguntasModel->getPerguntasDisponiveis($_POST['txtIdQuestionarioReferencia']));
        $this->ajax->addAjaxData('perguntasQuestionario', $this->peopleplanQuestionarioPerguntasModel->getQuestionarioPerguntasGridByQuestionarioId($_POST['txtIdQuestionarioReferencia']));
        
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->peopleplanQuestionarioModel->validate->getError());
        }
        $this->ajax->returnAjax();        
    }
    
    function salvarGrid(){
        
        if ($this->peopleplanQuestionarioModel->verificaReferenciaGrid($_POST['txtIdQuestionarioGrid'])) {
            $ret = $this->peopleplanQuestionarioModel->incluirGrid($_POST);
        } else {            
            $this->peopleplanQuestionarioModel->excluirMapaAntigo($_POST['txtIdQuestionarioGrid']);
            $this->peopleplanQuestionarioModel->limpaReferenciaGrid($_POST['txtIdQuestionarioGrid']);
            $ret = $this->peopleplanQuestionarioModel->incluirGrid($_POST);        
        }
         
        $this->ajax->addAjaxData('perguntas', $this->peopleplanQuestionarioPerguntasModel->getPerguntasDisponiveis($_POST['txtIdQuestionarioGrid']));
        $this->ajax->addAjaxData('perguntasQuestionario', $this->peopleplanQuestionarioPerguntasModel->getQuestionarioPerguntasGridByQuestionarioId($_POST['txtIdQuestionarioGrid']));
        
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->peopleplanQuestionarioModel->validate->getError());
        }
        $this->ajax->returnAjax();
        
    }

    
    function salvarPerguntasQuestionario(){
        
        $ret = $this->peopleplanQuestionarioModel->incluirPerguntasQuestionario($_POST);
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->peopleplanQuestionarioModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }

    function salvarPesosQuestionario(){
        
    }
    
    function salvarQuestionarioAtivo(){
        
        $ret = $this->peopleplanQuestionarioModel->alterarAtivoPesquisador($_POST);
        
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->ajaxMessage('error', "Aconteceu algum erro, tente novamente!");
        }
        $this->ajax->returnAjax();        
    }
    
}
