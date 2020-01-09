<?php

class PerguntaDinamica extends Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('../../gerenciador/models/ProgramaModel', 'programaModel');
        $this->load->model('PerguntaDinamicaModel', 'perguntaDinamicaModel');
    }

    function index() {
        $data['path_bread'] = $this->programaModel->pathBread($_SERVER['REQUEST_URI']);
        $this->load->view('perguntaDinamicaFiltroView', $data);
    }
    
    
}



?>