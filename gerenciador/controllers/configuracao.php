<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Configuracao extends Controller {
    
    function __construct() {
        parent::__construct();
        $this->load->model('configuracaomodel', 'configuracaoModel');
        
    }

    public function index(){
        $perfil = $this->configuracaoModel->getPerfil(1);
        $data['configuracao'] = $perfil[0];        
        $this->load->view('configuracaoView',$data);
    }
   
    public function salvar(){
        if ($_POST['txtCodigo'] == '') {
            $ret = false;
        } else {
            $this->configuracaoModel->atualizarPerfil($_POST);
            $ret = true;
        }
        if ($ret != false) {
            $this->ajax->ajaxMessage('success', 'Gravado com sucesso!');
        } else {
            $this->ajax->ajaxMessage('error', 'Erro ao salvar');
        }
        $this->ajax->returnAjax();
    }
}
?>