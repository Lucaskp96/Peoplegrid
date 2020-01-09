<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package administrador
 * @subpackage questionario
 * @author agpeil
 */
class PerguntasModel extends Model {

    function __construct() {
        parent::__construct();
    }
    

    /**
     * @return Array com perguntas dependendo do filtro
     * @param type $parametros
     * 
     */
    function getPerguntas($parametros) {
        $this->db->select("pg.id, pg.descricao, (CASE WHEN pg.obrigatoria = 'S' THEN 'Sim' ELSE 'Não' END) as obrigatoria, p.nome");
        $this->db->from('peoplegrid.perguntas_grid as pg');
        $this->db->join('pessoas as p', 'p.id = pg.pessoa_id');
            
        if(@$parametros['nome'] != ''){
            $this->db->likeName('p.nome', $parametros['nome']);
        }
        if(@$parametros['descricao'] != ''){
            $this->db->likeName('pg.descricao', $parametros['descricao']);
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
        $this->db->from('peoplegrid.perguntas_grid as p');
        $this->db->where('p.pessoa_id', getUsuarioSession()->pessoa_id);
        $data = $this->db->get()->result();
        return $data;
    }

    function getPergunta($id) {
        $this->db->select('pg.id, pg.descricao, pg.obrigatoria, pg.pessoa_id, pg.dt_cadastro, p.nome');
        $this->db->from('peoplegrid.perguntas_grid as pg');
        $this->db->join('pessoas as p', 'p.id = pg.pessoa_id');
        $this->db->where('pg.id', $id);
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
        $this->db->update('peoplegrid.perguntas_grid');
        $this->ajax->addAjaxData('peoplegrid.perguntas_grid', $this->getPergunta($pergunta['txtId']));

        return true;        
    }

    
    function validaPergunta($data) {
        $this->validate->setData($data);
        $this->validate->validateField('txtDescricao', array('required'), lang('descricaoNaoInformada'));
        return $this->validate->existsErrors();
    }
    
    function getQuestionarioPerguntasGrid($perguntaId) {
        $this->db->where('pergunta_grid_id', $perguntaId);
        return $this->db->get('peoplegrid.questionario_perguntas_grid')->result();
    }
    
    function getRespostasByQuestionarioPerguntaGridId($idPerguntaQuestionario) {
        $this->db->where('questionario_pergunta_grid_id', $idPerguntaQuestionario);
        return $this->db->get('peoplegrid.grid_respostas')->result();
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
                $this->db->where('questionario_pergunta_grid_id', $pergunta->id);
                $this->db->delete('peoplegrid.grid_respostas');

                $this->db->where('id', $pergunta->id);
                $this->db->delete('peoplegrid.questionario_perguntas_grid');
            }

            $this->db->where('id', $idP);
            $this->db->delete('peoplegrid.perguntas_grid');
        }
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }
        $this->db->trans_commit();
        
        return true;
    }
    
}
