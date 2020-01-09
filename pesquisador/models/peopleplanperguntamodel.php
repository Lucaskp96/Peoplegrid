<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package administrador
 * @subpackage questionario
 * @author fdloopes
 */
class PeopleplanPerguntaModel extends Model {

    function __construct() {
        parent::__construct();
    }


    /**
     * @return Array com perguntas dependendo do filtro
     * @param type $parametros
     *
     */
    function getPerguntas($parametros) {
        $this->db->select("c.id, c.descricao,(CASE WHEN c.obrigatorio = 'S' THEN 'Sim' ELSE 'Não' END) as obrigatorio");
        $this->db->from('peopleplan.criterios as c');
        $this->db->where('c.pessoa_id', getUsuarioSession()->pessoa_id);
        $this->db->likeName('c.descricao', @$parametros['descricao']);
        $this->db->sendToGrid();
    }

        /**
     * @return Array com perguntas dependendo do filtro
     * @param type $parametros
     *
     */
    function getPerguntasForArray() {
        $this->db->select("p.id, p.descricao, p.peso,(CASE WHEN p.obrigatoria = 'S' THEN 'Sim' ELSE 'Não' END) as obrigatoria");
        $this->db->from('peopleplan.perguntas as p');
        $this->db->where('p.pessoa_id', getUsuarioSession()->pessoa_id);
        $data = $this->db->get()->result();
        return $data;
    }

    function getPergunta($id) {
        $this->db->select('id, descricao, obrigatorio, pessoa_id, dt_cadastro');
        $this->db->where('id', $id);
        return $this->db->get('peopleplan.criterios')->row();
    }

    function incluir($pergunta) {
        $retErro = $this->validaPergunta($pergunta);
        if ($retErro) {
            return false;
        }

        $dados = array('pessoa_id' => getUsuarioSession()->pessoa_id,
            'descricao' => $pergunta['txtDescricao'],
            'obrigatorio' => 'S',
            'dt_cadastro' => 'now()');
        $this->db->insert('peopleplan.criterios', $dados);
        logLastSQL();
        $this->ajax->addAjaxData('pergunta', $this->getPergunta($this->db->insert_id('peopleplan.criterios','id')));

        return true;

         // Insere na tabela de questionario_pesos
        /*$id = $this->db->insert_id('peopleplan.perguntas','id');
        $pesos = array('dt_cadastro' => 'now()','pergunta_id' => $id);
        $this->db->insert('peopleplan.questionario_pesos_perguntas', $pesos);
        logLastSQL();*/
    }

    function alterar($pergunta) {
        $retErro = $this->validaPergunta($pergunta);
        if ($retErro) {
            return false;
        }
        $this->db->set('descricao', $pergunta['txtDescricao']);
        $this->db->set('obrigatorio', 'S');
        $this->db->where('id', $pergunta['txtId']);
        $this->db->update('peopleplan.criterios');
        $this->ajax->addAjaxData('peopleplan.criterios', $this->getPergunta($pergunta['txtId']));

        return true;

    }


    function validaPergunta($data) {
        $this->validate->setData($data);
        $this->validate->validateField('txtDescricao', array('required'), lang('descricaoNaoInformada'));
        return $this->validate->existsErrors();
    }

    function getQuestionarioPerguntas($perguntaId) {
        $this->db->where('pergunta_id', $perguntaId);
        return $this->db->get('peopleplan.questionario_perguntas_multicriterio')->result();
    }

    function getRespostasByQuestionarioPerguntaId($idPerguntaQuestionario) {
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
            $idQuestionarioPerguntas = $this->getQuestionarioPerguntas($idP);
            // percorre todas as perguntas
           //logVar($idQuestionarioPerguntas);
            $buffer = array();
            foreach ($idQuestionarioPerguntas as $pergunta) {
                logVar($pergunta);
                $respostas = $this->getRespostasByQuestionarioPerguntaId($pergunta->id);
                logVar($respostas);
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

            $this->db->where('id', $idP);
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
