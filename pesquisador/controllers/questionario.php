<?php

class Questionario extends Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('../../gerenciador/models/ProgramaModel', 'programaModel');
        $this->load->model('QuestionarioModel', 'questionarioModel');
        $this->load->model('PerguntaModel', 'perguntaModel');
        $this->load->model('QuestionarioPerguntasModel', 'questionarioPerguntasModel');
        $this->load->model('../../gerenciador/models/ConfiguracaoModel', 'configuracaoModel');
        $this->load->model('../../gerenciador/models/EmailModel', 'emailModel');
        
    }

    function index() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $this->load->view('questionarioFiltroView', $data);
    }

    function listaQuestionarios() {
        $this->questionarioModel->getQuestionarios($_GET);
    }
    
    function listaPerguntas(){
        $this->PerguntaModel->getPerguntas($_GET);    
    }
    
    function listaQuestionarioPerguntas() {
        if($_POST['questionarioId'] != ''){
            $this->ajax->addAjaxData('questionarioPerguntas', $this->questionarioModel->getQuestionarioPerguntasGrid($_POST['questionarioId']));
            $this->ajax->returnAjax();
        } else {
            $this->ajax->addAjaxData(NULL);
            $this->ajax->returnAjax();
        }
        
    }

    function novo() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']) . ' / Novo';
        $data['ativo'] = array (array ("S", 'SIM'), array ("N", 'NÃO'));
        $data['perguntas'] = $this->perguntaModel->getPerguntasForArray($_GET);
        $this->load->view('questionarioView', $data);
    }
    
    function editar($idQuestionario){
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $data['questionario'] = $this->questionarioModel->getQuestionario($idQuestionario);
        $data['perguntas'] = $this->questionarioPerguntasModel->getPerguntasDisponiveis($idQuestionario);
        $data['perguntasQuestionario'] = $this->questionarioPerguntasModel->getQuestionarioPerguntasGridByQuestionarioId($idQuestionario);
        $this->load->view('questionarioView', $data);
    }
    
    function excluir(){
        $isSucess = $this->questionarioModel->excluir($_POST['questionarios']);

        if ($isSucess) {
            $this->ajax->addAjaxData('success', true);
        } else {
            $this->ajax->addAjaxData('success', false);
        }
        $this->ajax->returnAjax();
    }
    
    function salvarQuestionario() {
        if ($_POST['txtId'] == '') {
            $ret = $this->questionarioModel->incluir($_POST);
            
            //$email = $this->configuracaoModel->getEmail();
            //$emailAdministrador = $this->configuracaoModel->getEmailAdministrador();
            //$emailAdministrador2 = $this->configuracaoModel->getEmailAdministrador2();
            //$senha = $this->configuracaoModel->getSenha();

            //$this->emailModel->notificaAdministradorDoSistema($email,$senha,$emailAdministrador,"Nova pesquisa", "Olá administrador, foi criado mais uma nova pesquisa no <b>PeopleGrid</b> por um dos colaboradores do projeto.");
            //$this->emailModel->notificaAdministradorDoSistema($email,$senha,$emailAdministrador2,"Nova pesquisa", "Olá administrador, foi criado mais uma nova pesquisa no <b>PeopleGrid</b> por um dos colaboradores do projeto.");
        } else {
            $ret = $this->questionarioModel->alterar($_POST);
        }
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->questionarioModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }
    
    function salvarReferenciaMapa(){
        if ($this->questionarioModel->verificaReferenciaMapa($_POST['txtIdQuestionarioReferencia'])) {
            $ret = $this->questionarioModel->incluirReferenciaMapa($_POST);
        } else {
            $this->questionarioModel->excluirMapaAntigo($_POST['txtIdQuestionarioReferencia']);
            $this->questionarioModel->limpaReferenciaMapa($_POST['txtIdQuestionarioReferencia']);
            $ret = $this->questionarioModel->incluirReferenciaMapa($_POST);
        }
        
        $this->ajax->addAjaxData('perguntas', $this->questionarioPerguntasModel->getPerguntasDisponiveis($_POST['txtIdQuestionarioReferencia']));
        $this->ajax->addAjaxData('perguntasQuestionario', $this->questionarioPerguntasModel->getQuestionarioPerguntasGridByQuestionarioId($_POST['txtIdQuestionarioReferencia']));
        
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->questionarioModel->validate->getError());
        }
        $this->ajax->returnAjax();        
    }
    
    function salvarGrid(){
        
        if ($this->questionarioModel->verificaReferenciaGrid($_POST['txtIdQuestionarioGrid'])) {
            $ret = $this->questionarioModel->incluirGrid($_POST);
        } else {            
            $this->questionarioModel->excluirMapaAntigo($_POST['txtIdQuestionarioGrid']);
            $this->questionarioModel->limpaReferenciaGrid($_POST['txtIdQuestionarioGrid']);
            $ret = $this->questionarioModel->incluirGrid($_POST);        
        }
         
        $this->ajax->addAjaxData('perguntas', $this->questionarioPerguntasModel->getPerguntasDisponiveis($_POST['txtIdQuestionarioGrid']));
        $this->ajax->addAjaxData('perguntasQuestionario', $this->questionarioPerguntasModel->getQuestionarioPerguntasGridByQuestionarioId($_POST['txtIdQuestionarioGrid']));
        
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->questionarioModel->validate->getError());
        }
        $this->ajax->returnAjax();
        
    }

    
    function salvarPerguntasQuestionario(){
        
        $ret = $this->questionarioModel->incluirPerguntasQuestionario($_POST);
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->addAjaxData('error', $this->questionarioModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }
    
    function salvarQuestionarioAtivo(){
        
        $ret = $this->questionarioModel->alterarAtivoPesquisador($_POST);
        
        if ($ret) {
            $this->ajax->ajaxMessage('success', lang('registroGravado'));
        } else {
            $this->ajax->ajaxMessage('error', "Aconteceu algum erro, tente novamente!");
        }
        $this->ajax->returnAjax();        
    }
    
}
