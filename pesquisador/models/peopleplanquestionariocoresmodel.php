<?php

class PeopleplanQuestionarioCoresModel extends Model {

    function __construct() {
        parent::__construct();
    }

    function getCoresByQuestionario($id) {
        $this->db->where('questionario_id', $id);
        return $this->db->get('peopleplan.questionario_cores')->row();
    }
    
    function getCoresByQuestionarioCombo($id) {
        $this->db->where('questionario_id', $id);
        return $this->db->get('peopleplan.questionario_cores')->result_array();
    }

    function incluirCores($params){
    	$dados = array(
            'questionario_id' => $params['questionario_id'],
            'cor_1' => $params['cor_1'],
            'cor_2' => $params['cor_2'],
            'cor_3' => $params['cor_3'],
            'cor_4' => $params['cor_4'],
            'cor_5' => $params['cor_5'],
            'cor_6' => $params['cor_6'],
            'cor_7' => $params['cor_7'],
            'cor_8' => $params['cor_8'],
            'cor_9' => $params['cor_9'],
            'cor_10' => $params['cor_10']);
        $this->db->insert('peopleplan.questionario_cores', $dados);
        
        
        
        return $this->getLastColorInsert($params['questionario_id']);
        
    }

    function atualizarCores($params){
    	$this->db->set('cor_1', $params['cor_1']);
    	$this->db->set('cor_2', $params['cor_2']);
    	$this->db->set('cor_3', $params['cor_3']);
    	$this->db->set('cor_4', $params['cor_4']);
    	$this->db->set('cor_5', $params['cor_5']);
    	$this->db->set('cor_6', $params['cor_6']);
    	$this->db->set('cor_7', $params['cor_7']);
    	$this->db->set('cor_8', $params['cor_8']);
    	$this->db->set('cor_9', $params['cor_9']);
    	$this->db->set('cor_10', $params['cor_10']);
    	$this->db->where('id', $params['id']);
    	$this->db->update('peoplegrid.questionario_cores');

    	return $this->getLastColorInsert($params['questionario_id']);;
    }
    
    function getLastColorInsert($questionario_id){
        $this->db->where('questionario_id',$questionario_id);
        return $this->db->get('peopleplan.questionario_cores')->row();
    }
}

?>