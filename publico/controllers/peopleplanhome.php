<?php

class PeopleplanHome extends Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('../../gerenciador/models/ProgramaModel', 'programaModel');
        $this->load->model('../../pesquisador/models/PeopleplanQuestionarioModel', 'questionarioModel');
        $this->load->model('../../pesquisador/models/PeopleplanQuestionarioPerguntasModel', 'questionarioPerguntasModel');
        $this->load->model('../../pesquisador/models/PeopleplanResultadoModel', 'resultadoModel');
        $this->load->model('../../pesquisador/models/PeopleplanQuestionarioCoresModel', 'questionarioCoresModel');
        $this->load->model('PeopleplanFiltroModel', 'filtroModel');
        $this->load->model('PeopleplanRespostaModel', 'respostaModel');
    }
    
    function colaborar($link){
       $data['questionario'] = $questionario = $this->questionarioModel->getQuestionarioByLink($link);
       $data['filtroPensouComo'] = $this->filtroModel->getPensouComo();
       $data['filtroRendaFamiliar'] = $this->filtroModel->getRendaFamiliar();
       $data['filtroNivelEscolaridade'] = $this->filtroModel->getNivelEscolaridade();
       $data['questionarioPerguntas'] = $this->questionarioPerguntasModel->getQuestionarioPerguntasGridByQuestionarioId($questionario->id);
       $this->load->view('peopleplanColaborarView', $data);
    }
    
   function apuracao($link){
        $data['questionario'] = $questionario = $this->questionarioModel->getQuestionarioByLink($link);
        $data['questionarioPerguntas'] = $this->resultadoModel->getQuestionarioPerguntasGridByQuestionarioId($questionario->id);
        $data['pensouComo'] = $this->filtroModel->getPensouComo();
        $data['nivelEscolaridade'] = $this->filtroModel->getNivelEscolaridade();
        $data['rendaFamiliar'] = $this->filtroModel->getRendaFamiliar();
        $data['questionario_cores']=$this->questionarioCoresModel->getCoresByQuestionarioCombo($questionario->id);
                logVar($data['questionario_cores']);
        $this->load->view('apuracaoView', $data);
        
    }
    
    function getResultado(){
        $ret = $this->resultadoModel->getResultadosPergunta($_POST);
        if ($ret) {
            $this->ajax->ajaxMessage('success', 'true');
        } else {
            $this->ajax->addAjaxData('error', $this->questionarioModel->validate->getError());
        }
        $this->ajax->returnAjax();
        
    }
    
    function salvar(){
        $ret = $this->respostaModel->incluir($_POST);
        if ($ret) {
            $this->ajax->ajaxMessage('success', 'success');
        } else {
            $this->ajax->addAjaxData('error', $this->respostaModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }
    
    function equipe(){
        $this->load->view('equipeView');
        
    }
}
