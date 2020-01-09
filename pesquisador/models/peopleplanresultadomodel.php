<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package administrador
 * @subpackage questionario
 * @author fdloopes
 */
class PeopleplanResultadoModel extends Model {

    function __construct() {
        parent::__construct();
    }
    
    function getRespostasGridByQuestionarioPerguntaId(){
        
        
    }
    
        /**
     * Seleciona no DB todas as perguntas vinculadas ao questionário, 
     * inclusive a descrição.
     * @param type $questionarioId
     * @return type
     */
    function getQuestionarioPerguntasGridByQuestionarioId($questionarioId) {
        
        $this->db->select('qpp.id, p.descricao');
        $this->db->from('peopleplan.questionario_perguntas_multicriterio AS qpp');
        $this->db->join('peopleplan.perguntas AS p', 'p.id = qpp.pergunta_id');
        $this->db->where('qpp.questionario_id', $questionarioId);
        $this->db->order_by('qpp.ordem');
        $data = $this->db->get()->result();
        return $data;
    }
    
    
    function getResultadosPergunta($parametros){
        
        $retErro = $this->validaGerarResultado($parametros);
        if ($retErro) {
            return false;
        }
        
        $this->db->select('gr.grid');
        $this->db->from('peopleplan.respostas_multicriterio AS gr');
        $this->db->join('peopleplan.respostas AS r', "r.id = gr.resposta_id");
        $this->db->where('gr.questionario_pergunta_id', $parametros['cmbQuestionarioPerguntas']);
        
        if((@$parametros['cmbPensouComo'] != '') && (@$parametros['cmbPensouComo'] != '-1')){
            $this->db->where('r.pensou_como_id', $parametros['cmbPensouComo']);   
        }
        if((@$parametros['cmbRendaFamiliar'] != '') && (@$parametros['cmbRendaFamiliar'] != '-1')){
            $this->db->where('r.renda_familiar_id', $parametros['cmbRendaFamiliar']);
        }
        if((@$parametros['cmbNivelEscolaridade'] != '') && (@$parametros['cmbNivelEscolaridade'] != '-1')){
            $this->db->where('r.nivel_escolaridade_id', $parametros['cmbNivelEscolaridade']);
        }
        $data = $this->db->get()->result();
        
        $totalRespostas = count($data);
        
        $this->ajax->addAjaxData('respostas', $data);
        $this->ajax->addAjaxData('totalRespostas', $totalRespostas);
        
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        $this->db->trans_commit();
        return true;
    }
    
    function validaGerarResultado($parametros) {
        $this->validate->setData($parametros);        
        if($parametros['type'] === 'result'){
            $this->validate->validateField('cmbAlgoritmo', array('required'), 'Você não selecionou o algoritmo.');
        }
        $this->validate->validateField('cmbQuestionarioPerguntas', array('required'), 'Você não selecionou a pergunta.');
        
        return $this->validate->existsErrors();
    }
    
}