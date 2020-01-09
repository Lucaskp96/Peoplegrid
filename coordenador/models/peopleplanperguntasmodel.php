<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package administrador
 * @subpackage questionario
 * @author agpeil
 */
class PeopleplanPerguntasModel extends Model {

    function __construct() {
        parent::__construct();
    }
    

    /**
     * @return Array com perguntas dependendo do filtro
     * @param type $parametros
     * 
     */
    function getPerguntas($parametros) {
        $this->db->select("pp.id, pp.descricao, (CASE WHEN pp.obrigatoria = 'S' THEN 'Sim' ELSE 'Não' END) as obrigatoria, p.nome");
        $this->db->from('peopleplan.perguntas as pp');
        $this->db->join('pessoas as p', 'p.id = pp.pessoa_id');
            
        if(@$parametros['nome'] != ''){
            $this->db->likeName('p.nome', $parametros['nome']);
        }
        if(@$parametros['descricao'] != ''){
            $this->db->likeName('pp.descricao', $parametros['descricao']);
        }
        logLastSQL();
        $this->db->sendToGrid();
    }
    
        /**
     * @return Array com perguntas dependendo do filtro
     * @param type $parametros
     * 
     */
    function getPerguntasForArray() {
        $this->db->select("p.id, p.descricao, (CASE WHEN p.obrigatoria = 'S' THEN 'Sim' ELSE 'Não' END) as obrigatoria");
        $this->db->from('peopleplan.perguntas as p');
        $this->db->where('p.pessoa_id', getUsuarioSession()->pessoa_id);
        $data = $this->db->get()->result();
        return $data;
    }

    function getPergunta($id) {
        $this->db->select('pp.id, pp.descricao, pp.obrigatoria, pp.pessoa_id, pp.dt_cadastro, p.nome');
        $this->db->from('peopleplan.perguntas as pp');
        $this->db->join('pessoas as p', 'p.id = pp.pessoa_id');
        $this->db->where('pp.id', $id);
        return $this->db->get()->row();   
    }

    function alterar($pergunta) {
        $retErro = $this->validaPergunta($pergunta);
        if ($retErro) {
            return false;
        }
        $this->db->set('descricao', $pergunta['txtDescricao']);
        $this->db->set('obrigatoria', 'S');
        $this->db->where('id', $pergunta['txtId']);
        $this->db->update('peopleplan.perguntas');
        $this->ajax->addAjaxData('peopleplan.perguntas', $this->getPergunta($pergunta['txtId']));

        return true;        
    }

    
    function validaPergunta($data) {
        $this->validate->setData($data);
        $this->validate->validateField('txtDescricao', array('required'), lang('descricaoNaoInformada'));
        return $this->validate->existsErrors();
    }
    
    function getQuestionarioPerguntasGrid($perguntaId) {
        $this->db->where('pergunta_id', $perguntaId);
        return $this->db->get('peopleplan.questionario_perguntas_multicriterio')->result();
    }
    
    function getRespostasByQuestionarioPerguntaGridId($idPerguntaQuestionario) {
        $this->db->where('questionario_pergunta_id', $idPerguntaQuestionario);
        return $this->db->get('peopleplan.respostas_multicriterio')->result();
    }
    
    function excluir($id) {
        $this->db->trans_begin();

        $aPerguntas = explode(',', $id);
        $idPerguntas = array();
        for ($i = 0; $i < count($aPerguntas); $i++) {
            if ($aPerguntas[$i] != 'undefined') {
                array_push($idPerguntas, $aPerguntas[$i]);
            }
        }
        
        // percorre todos os questionarios
        $this->db->trans_begin();
        foreach ($idPerguntas as $idP) {
            //logVar($idP);
            $idQuestionarioPerguntas = $this->getQuestionarioPerguntasGrid($idP);
            // percorre todas as perguntas
            foreach ($idQuestionarioPerguntas as $pergunta) {
                
                // deleta as respostas referente a $pergunta
                logVar($pergunta->id);
                $this->db->where('questionario_pergunta_id', $pergunta->id);
                $this->db->delete('peopleplan.respostas_multicriterio');

                $this->db->where('id', $pergunta->id);
                $this->db->delete('peopleplan.questionario_perguntas_multicriterio');
            }

            $this->db->where('id', $idP);
            $this->db->delete('peopleplan.perguntas');
        }
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }
        $this->db->trans_commit();
        
        return true;
    }
    
}
