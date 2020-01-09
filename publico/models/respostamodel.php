<?php

/**
 * Classe responsável por inserir as respostas dos usuários no banco de dados
 * @package publico
 * @subpackage filtro
 * @author agpeil
 */
class RespostaModel extends Model {

    function __construct() {
        parent::__construct();
    }

    function incluir($resposta) {
        
        $retErro = $this->validaResposta($resposta);
        if ($retErro) {
            return false;
        }
        $this->db->trans_begin();
            $this->db->set('nivel_escolaridade_id', $resposta['nivelEscolaridade']);
            $this->db->set('renda_familiar_id', $resposta['rendaFamiliar']);
            $this->db->set('pensou_como_id', $resposta['pensouComo']);
            $this->db->insert('peoplegrid.respostas');
        $this->db->trans_complete();

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        // decodifica as resposta em json para fazer o foreach e percorrer todas as perguntas
        $perguntas = json_decode($resposta['txtPerguntasGrid']);

        // pega a referencia da resposta do usuário para colocar como chave estrangeira nas linhas de cada pergunta
        $resposta_id = $this->getResposta($this->db->insert_id('peoplegrid.respostas', 'id'))->id;

        // insere todas as perguntas no db
        foreach ($perguntas as $p) {
            $resposta_grid = json_encode($p->respostaGrid);
            if ($this->incluirRespostaGrid($p->perguntaQuestionarioId, $resposta_grid, $resposta_id) === FALSE) {
                $this->db->trans_rollback();
                return false;
            }
        }
        
        return true;
    }

    function incluirRespostaGrid($questionarioPerguntaGridId, $respostaGrid, $respostaId) {
        $this->db->trans_begin();
            $this->db->set('questionario_pergunta_grid_id', $questionarioPerguntaGridId);
            $this->db->set('grid', $respostaGrid);
            $this->db->set('resposta_id', $respostaId);
            $this->db->insert('peoplegrid.grid_respostas');
        $this->db->trans_complete();

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }
        return true;
    }

    function getResposta($id) {
        $this->db->where('id', $id);
        return $this->db->get('peoplegrid.respostas')->row();
    }

    function validaResposta($data) {

        $this->validate->setData($data);
        $this->validate->validateField('nivelEscolaridade', array('required'), 'Você não marcou a pergunta sobre o Nível de Escolaridade.');
        $this->validate->validateField('rendaFamiliar', array('required'), 'Você não marcou a pergunta sobre a Renda Familiar.');
        $this->validate->validateField('pensouComo', array('required'), 'Você não marcou a pergunta sobre Como Você Pensou para responder este questionário.');
        return $this->validate->existsErrors();
    }
         

}
