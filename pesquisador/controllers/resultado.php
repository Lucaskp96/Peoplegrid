<?php

class Resultado extends Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('../../gerenciador/models/ProgramaModel', 'programaModel');
        $this->load->model('../../publico/models/FiltroModel', 'filtroModel');
        $this->load->model('ResultadoModel', 'resultadoModel');
        $this->load->model('QuestionarioModel', 'questionarioModel');
        $this->load->model('QuestionarioPerguntasModel', 'questionarioPerguntasModel');
        $this->load->model('QuestionarioCoresModel', 'questionarioCoresModel');
    }

    function index() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $this->load->view('resultadoFiltroView', $data);
    }
    
    function listaQuestionarios() {
       $this->questionarioModel->getQuestionariosResultados($_GET);
    }
    
    function visualizar($id){
        $data['questionario'] = $this->questionarioModel->getQuestionario($id);
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']) . ' / '. $data['questionario']->descricao;
        $data['questionarioPerguntas'] = $this->resultadoModel->getQuestionarioPerguntasGridByQuestionarioId($id);
        $data['pensouComo'] = $this->filtroModel->getPensouComo();
        $data['nivelEscolaridade'] = $this->filtroModel->getNivelEscolaridade();
        $data['rendaFamiliar'] = $this->filtroModel->getRendaFamiliar();
        $data['questionario_cores'] = $this->questionarioCoresModel->getCoresByQuestionarioCombo($id);
        $this->load->view('resultadoView', $data);
        
    }
    
    function gerarResultado(){
    
        $ret = $this->resultadoModel->getResultadosPergunta($_POST);
        if ($ret) {
            $this->ajax->ajaxMessage('success', 'true');
        } else {
            $this->ajax->addAjaxData('error', $this->questionarioModel->validate->getError());
        }
        $this->ajax->returnAjax();
    }

    function salvarCores(){
        
        if($_GET['id'] != ''){
            $ret = $this->questionarioCoresModel->atualizarCores($_GET);
        }else{
            $ret = $this->questionarioCoresModel->incluirCores($_GET);
        }
        
        print json_encode($ret);
    }
    
    
    function exportar(){
        $nrows = $_POST['altura'];
        $ncols = $_POST['largura'];
        $cellSize = $_POST['distancia'];
        $respostas = $_POST['respostas'];
        $utmx = $_POST['utmx'];
        $utmy = $_POST['utmy'];
        $zone = $_POST['zone'];
        $i = 0;
        $data = "";
        $header = 'ncols         '.$ncols."\n"
                . 'nrows         '.$nrows."\n"
                . 'xllcorner     '.$utmx."\n"
                . 'yllcorner     '.$utmy."\n"
                . 'cellsize      '.$cellSize."\n"
                . 'NODATA_value  -9999'."\n";
        
        foreach($respostas as $r){            
            if($i < $ncols){
                if($i === 0){
                    $data = $data."".$r; 
                    $i++;
                } else {
                    $data = $data." ".$r; 
                    $i++;    
                }
                
            } else {
                $data = $data."\n";
                $data = $data.$r;
                $i = 1;
            }
        }
        $content = $header.$data;
        $today = date("y-m-d-H-i-s");

        $this->ajax->addAjaxData('nameFile', "peoplegrid-".$today);
        $this->ajax->addAjaxData('content', $content);
        $this->ajax->returnAjax();
    }   
}