<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package administrador
 * @subpackage questionario
 * @author agpeil
 */
class PeopleplanPesquisaModel extends Model {

    function __construct() {
        parent::__construct();
    }

        /**
     * Busca todos os questionarios vinculados ao usuário da sessao
     * 
     * @param type $parametros [id]
     */
    function getPesquisas($parametros) {
        $this->db->select("q.id, q.descricao, q.dt_inicio, q.dt_fim,"
                . " (CASE WHEN q.ativo_pelo_adm = 'S' THEN 'Sim' ELSE 'Não' END) as ativo_pelo_adm,"
                . " (CASE WHEN q.ativo_pelo_pesquisador = 'S' THEN 'Sim' ELSE 'Não' END) as ativo_pelo_pesquisador,"
                . "p.nome");
        $this->db->from('peopleplan.questionarios as q');
        $this->db->join('pessoas as p', 'p.id = q.pessoa_id');
        
        if(@$parametros['ativoAdm'] != ''){
            $this->db->where('q.ativo_pelo_adm', @$parametros['ativoAdm']);    
        }
        if(@$parametros['ativoPesq'] != ''){
            $this->db->where('q.ativo_pelo_pesquisador', @$parametros['ativoPesq']);    
        }
        if(@$parametros['nome'] != ''){
            $this->db->likeName('p.nome', $parametros['nome']);
        }
        if(@$parametros['descricao'] != ''){
            $this->db->likeName('q.descricao', @$parametros['descricao']);
        }
        
        $this->db->sendToGrid();
        
    }
    
    function getPesquisa($id){
        $this->db->select('q.id, q.descricao, q.geo_lat, q.geo_lon, q.zoom, '
                        . 'q.ativo_pelo_pesquisador, q.ativo_pelo_adm, q.dt_inicio, q.dt_fim,'
                        . 'q.ponto_sup_lat, q.ponto_sup_lng, q.ponto_inf_lat, q.ponto_inf_lng, q.precisao, q.pessoa_id, p.nome');
        $this->db->from('peopleplan.questionarios as q');
        $this->db->join('pessoas as p', 'p.id = q.pessoa_id');
        $this->db->where('q.id ', $id);
        return $this->db->get()->row();
        logLastSQL();
    }
    
    
    function alterar($questionario){
        
        $this->db->trans_begin();
            $this->db->set('descricao', $questionario['txtDescricao']);
            $this->db->setDate('dt_inicio', $questionario['dtInicio']);
            $this->db->setDate('dt_fim', $questionario['dtFim']);
            $this->db->set('ativo_pelo_adm', $questionario['chkPesquisaAtivaADM']);        
            $this->db->where('id', $questionario['txtId']);
            $this->db->update('peopleplan.questionarios as q');
        $this->db->trans_complete();
        
        $this->ajax->addAjaxData('pesquisas', $this->getPesquisa($questionario['txtId']));
        
        return true;
    }
    
    /**
     * Exclui um questionário
     * Processo:
     * - Salva o Id das respostas
     * - Exclui registros de respostas de grid vinculadas a este questionario
     * - Exclui registros das respotas vinculadas a este questionario
     * - Exclui registros de perguntas vinculadas a este questionario
     * - Exclui o questionario propriamente dito 
     * 
     * @param type $ids
     */
    function excluir($ids) {
        $aQuestionarios = explode(',', $ids);
        $idQuestionarios = array();
        for ($i = 0; $i < count($aQuestionarios); $i++) {
            if ($aQuestionarios[$i] != 'undefined') {
                array_push($idQuestionarios, $aQuestionarios[$i]);
            }
        }

        // percorre todos os questionarios
        $this->db->trans_begin();
        foreach ($idQuestionarios as $idQ) {
            $idQuestionarioPerguntas = $this->getQuestionarioPerguntasGrid($idQ);
            // percorre todas as perguntas
            $buffer = array();
            foreach ($idQuestionarioPerguntas as $pergunta) {

                $respostas = $this->getRespostasByQuestionarioPerguntaGridId($pergunta->id);
                // percorre todas as respostas das perguntas
                foreach ($respostas as $resposta) {
                    array_push($buffer, $resposta->resposta_id);
                }

                // deleta as respostas referente a $pergunta
                $this->db->where('questionario_pergunta_id', $pergunta->id);
                $this->db->delete('peopleplan.respostas_multicriterio');

                $this->db->where('id', $pergunta->id);
                $this->db->delete('peopleplan.questionario_perguntas_multicriterio');
            }

            foreach ($buffer as $b) {
                $this->db->where('id', $b);
                $this->db->delete('peopleplan.respostas');
            }
            
            
            $this->db->where('questionario_id', $idQ);
            $this->db->delete('peopleplan.questionario_cores');

            $this->db->where('id', $idQ);
            $this->db->delete('peopleplan.questionarios');
        }
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }
        $this->db->trans_commit();
        return true;
    }

    function getRespostasByQuestionarioPerguntaGridId($idPerguntaQuestionario) {
        $this->db->where('questionario_pergunta_id', $idPerguntaQuestionario);
        return $this->db->get('peopleplan.respostas_multicriterio')->result();
    }

    function getQuestionarioPerguntasGrid($questionarioId) {
        $this->db->where('questionario_id', $questionarioId);
        return $this->db->get('peopleplan.questionario_perguntas_multicriterio')->result();
    }
    
    
    
}