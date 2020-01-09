<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package administrador
 * @subpackage questionario
 * @author agpeil
 */
class QuestionarioPerguntasModel extends Model {

    function __construct() {
        parent::__construct();
    }
    
    
    /**
     * Seleciona no DB todas as perguntas vinculadas ao questionário, 
     * inclusive a descrição.
     * @param type $questionarioId
     * @return type
     */
    function getQuestionarioPerguntasGridByQuestionarioId($questionarioId) {
        
        $this->db->select('qpg.id, qpg.questionario_id, qpg.pergunta_grid_id, qpg.ordem, p.descricao, p.obrigatoria');
        $this->db->from('peoplegrid.questionario_perguntas_grid AS qpg');
        $this->db->join('peoplegrid.perguntas_grid AS p', 'p.id = qpg.pergunta_grid_id');
        $this->db->where('qpg.questionario_id', $questionarioId);
        $this->db->order_by('qpg.ordem');
        $data = $this->db->get()->result();
        return $data;
    }
    
    
    function getPerguntasDisponiveis($questionarioId){

        $sql = "SELECT pg.id, pg.descricao FROM peoplegrid.perguntas_grid  AS pg
                WHERE pg.pessoa_id = ". getUsuarioSession()->pessoa_id .
                "    EXCEPT
                SELECT qpg.pergunta_grid_id, pg.descricao FROM peoplegrid.questionario_perguntas_grid AS qpg
                JOIN peoplegrid.perguntas_grid AS pg ON pg.id = qpg.pergunta_grid_id
                WHERE qpg.questionario_id = ". $questionarioId;
        $data = $this->db->query($sql)->result();
        return $data;
    }
    

    function getPerguntasDisponiveisAdmin($questionarioId, $pessoa_id){

        $sql = "SELECT pg.id, pg.descricao FROM peoplegrid.perguntas_grid  AS pg
                WHERE pg.pessoa_id = ". $pessoa_id .
                "    EXCEPT
                SELECT qpg.pergunta_grid_id, pg.descricao FROM peoplegrid.questionario_perguntas_grid AS qpg
                JOIN peoplegrid.perguntas_grid AS pg ON pg.id = qpg.pergunta_grid_id
                WHERE qpg.questionario_id = ". $questionarioId;
        $data = $this->db->query($sql)->result();
        return $data;
    }
}