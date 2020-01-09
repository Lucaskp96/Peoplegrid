<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package administrador
 * @subpackage questionario
 * @author fdloopes
 */
class PeopleplanQuestionarioPerguntasModel extends Model {

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
        
        $this->db->select('qpp.id, qpp.questionario_id, qpp.pergunta_id, qpp.ordem, p.descricao, p.obrigatoria, p.peso');
        $this->db->from('peopleplan.questionario_perguntas_multicriterio AS qpp');
        $this->db->join('peopleplan.perguntas AS p', 'p.id = qpp.pergunta_id');
        $this->db->where('qpp.questionario_id', $questionarioId);
        $this->db->order_by('qpp.ordem');
        $data = $this->db->get()->result();
        return $data;
    }
    
    
    function getPerguntasDisponiveis($questionarioId){

        $sql = "SELECT pg.id, pg.descricao, pg.peso FROM peopleplan.perguntas  AS pg
                WHERE pg.pessoa_id = ". getUsuarioSession()->pessoa_id .
                "    EXCEPT
                SELECT qpg.pergunta_id, pg.descricao, pg.peso FROM peopleplan.questionario_perguntas_multicriterio AS qpg
                JOIN peopleplan.perguntas AS pg ON pg.id = qpg.pergunta_id
                WHERE qpg.questionario_id = ". $questionarioId;
        $data = $this->db->query($sql)->result();
        return $data;
    }
    

    function getPerguntasDisponiveisAdmin($questionarioId, $pessoa_id){

        $sql = "SELECT pg.id, pg.descricao FROM peopleplan.perguntas  AS pg
                WHERE pg.pessoa_id = ". $pessoa_id .
                "    EXCEPT
                SELECT qpg.pergunta_id, pg.descricao FROM peopleplan.questionario_perguntas_multicriterio AS qpg
                JOIN peopleplan.perguntas AS pg ON pg.id = qpg.pergunta_id
                WHERE qpg.questionario_id = ". $questionarioId;
        $data = $this->db->query($sql)->result();
        return $data;
    }
}