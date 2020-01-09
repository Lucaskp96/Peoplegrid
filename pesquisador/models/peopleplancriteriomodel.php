<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package administrador
 * @subpackage questionario
 * @author fdloopes
 */
class PeopleplanCriterioModel extends Model {

    function __construct() {
        parent::__construct();
    }


    /**
     * @return Array com criterios dependendo do filtro
     * @param type $parametros
     *
     */
    function getCriterios($parametros) {
        $this->db->select("c.id, c.descricao,(CASE WHEN c.obrigatorio = 'S' THEN 'Sim' ELSE 'Não' END) as obrigatorio");
        $this->db->from('peopleplan.criterios as c');
        $this->db->where('c.pessoa_id', getUsuarioSession()->pessoa_id);
        $this->db->likeName('c.descricao', @$parametros['descricao']);
        $this->db->sendToGrid();
    }

        /**
     * @return Array com criterios dependendo do filtro
     * @param type $parametros
     *
     */
    function getCriteriosForArray() {
        $this->db->select("c.id, c.descricao, c.peso,(CASE WHEN c.obrigatorio = 'S' THEN 'Sim' ELSE 'Não' END) as obrigatorio");
        $this->db->from('peopleplan.criterios as c');
        $this->db->where('c.pessoa_id', getUsuarioSession()->pessoa_id);
        $data = $this->db->get()->result();
        return $data;
    }

    function getCriterio($id) {
        $this->db->select('id, descricao, obrigatorio, pessoa_id, dt_cadastro');
        $this->db->where('id', $id);
        return $this->db->get('peopleplan.criterios')->row();
    }

    function incluir($criterio) {
        $retErro = $this->validaCriterio($criterio);
        if ($retErro) {
            return false;
        }

        $dados = array('pessoa_id' => getUsuarioSession()->pessoa_id,
            'descricao' => $criterio['txtDescricao'],
            'obrigatorio' => 'S',
            'dt_cadastro' => 'now()');
        $this->db->insert('peopleplan.criterios', $dados);
        logLastSQL();
        $this->ajax->addAjaxData('criterio', $this->getCriterio($this->db->insert_id('peopleplan.criterios','id')));

        return true;

         // Insere na tabela de questionario_pesos
        /*$id = $this->db->insert_id('peopleplan.perguntas','id');
        $pesos = array('dt_cadastro' => 'now()','pergunta_id' => $id);
        $this->db->insert('peopleplan.questionario_pesos_perguntas', $pesos);
        logLastSQL();*/
    }

    function alterar($criterio) {
        $retErro = $this->validaCriterio($criterio);
        if ($retErro) {
            return false;
        }
        $this->db->set('descricao', $criterio['txtDescricao']);
        $this->db->set('obrigatorio', 'S');
        $this->db->where('id', $criterio['txtId']);
        $this->db->update('peopleplan.criterios');
        $this->ajax->addAjaxData('peopleplan.criterios', $this->getCriterio($criterio['txtId']));

        return true;

    }


    function validaCriterio($data) {
        $this->validate->setData($data);
        $this->validate->validateField('txtDescricao', array('required'), lang('descricaoNaoInformada'));
        return $this->validate->existsErrors();
    }

    function getQuestionarioPergunta($criterioId) {
        $this->db->where('pergunta_id', $criterioId);
        return $this->db->get('peopleplan.questionario_perguntas_multicriterio')->result();
    }

    function getRespostasByQuestionarioPerguntaId($idPerguntaQuestionario) {
        $this->db->where('questionario_pergunta_id', $idPerguntaQuestionario);
        return $this->db->get('peopleplan.respostas_multicriterio')->result();
    }

    function excluir($id) {
        $this->db->trans_begin();

        $aCriterios = explode(',', $id);
        $idCriterios = array();
        for ($i = 0; $i < count($aCriterios); $i++) {
            if ($aCriterios[$i] != 'undefined') {
                array_push($idCriterios, $aCriterios[$i]);
            }
        }

        // percorre todas as perguntas
        $this->db->trans_begin();
        foreach ($idCriterios as $idC) {
            //logVar($idC);
            $idPerguntasCriterios = $this->getQuestionarioPerguntas($idC);
            // percorre todos os criterios
           //logVar($idPerguntasCriterios);
            $buffer = array();
            foreach ($idPerguntasCriterios as $criterio) {
                logVar($criterio);
                $respostas = $this->getRespostasByQuestionarioPerguntaId($criterio->id);
                logVar($respostas);
                // percorre todas as respostas dos critérios
                foreach ($respostas as $resposta) {
                    array_push($buffer, $resposta->resposta_id);
                }

                // deleta as respostas referente a $criterio
                $this->db->where('questionario_pergunta_id', $criterio->id);
                $this->db->delete('peopleplan.respostas_multicriterio');

                $this->db->where('id', $criterio->id);
                $this->db->delete('peopleplan.questionario_perguntas_multicriterio');
            }
            foreach ($buffer as $b) {
                $this->db->where('id', $b);
                $this->db->delete('peopleplan.respostas');
            }

            $this->db->where('id', $idC);
            $this->db->delete('peopleplan.criterios');
        }
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }
        $this->db->trans_commit();


        /*
        $this->db->where_in('p.id', $aExcluirPerguntas);
        $this->db->delete('peoplegrid.perguntas_grid as p');
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        $this->db->trans_commit();*/
        return true;
    }

}
