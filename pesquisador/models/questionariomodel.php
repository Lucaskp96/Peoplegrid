<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package administrador
 * @subpackage questionario
 * @author agpeil
 */
class QuestionarioModel extends Model {

    function __construct() {
        parent::__construct();
    }

    /**
     * Busca todos os questionarios a disposição do respondente
     * 
     * @param type $parametros [id]
     */
    function getQuestionariosHome() {
        
        // verifica se o questionario possui perguntas
        $this->db->select('questionario_id');
        $this->db->from('peoplegrid.questionario_perguntas_grid as qpg');
        $this->db->groupby('qpg.questionario_id');
        $questionarios = $this->db->get()->result();
        
        $buffer = array();
        foreach ($questionarios as $q){
            array_push($buffer, $q->questionario_id);
        }

        $this->db->select("q.id, q.descricao, q.dt_inicio, q.dt_fim, q.link");
        $this->db->from('peoplegrid.questionarios as q');
        $this->db->where('q.dt_inicio <=', 'now()');
        $this->db->where('q.dt_fim >=', 'now()');
        $this->db->where('q.ativo_pelo_adm =', 'S');
        $this->db->where('q.ativo_pelo_pesquisador =', 'S');
        $this->db->where('q.ativo_pelo_pesquisador =', 'S');
        if(!empty($buffer)){
            $this->db->where_in('q.id', $buffer);
            $data = $this->db->get()->result();
        
            foreach ($data as $dt) {
                $dt->dt_inicio = implode("/", array_reverse(explode("-", $dt->dt_inicio)));
                $dt->dt_fim = implode("/", array_reverse(explode("-", $dt->dt_fim)));
            }
        } else {
            $data = $this->db->get()->result();
        }

        return $data;
    }
    
       /**
     * Busca todos os questionarios a disposição do respondente
     * 
     * @param type $parametros [id]
     */
    function getQuestionariosHomePeopleplan() {
        
        // verifica se o questionario possui perguntas
        $this->db->select('questionario_id');
        $this->db->from('peopleplan.questionario_perguntas_multicriterio as qpp');
        $this->db->groupby('qpp.questionario_id');
        $questionariosPeopleplan = $this->db->get()->result();
        
        $buffer = array();
        foreach ($questionariosPeopleplan as $qp){
            array_push($buffer, $qp->questionario_id);
        }

        $this->db->select("qp.id, qp.descricao, qp.dt_inicio, qp.dt_fim, qp.link");
        $this->db->from('peopleplan.questionarios as qp');
        $this->db->where('qp.dt_inicio <=', 'now()');
        $this->db->where('qp.dt_fim >=', 'now()');
        $this->db->where('qp.ativo_pelo_adm =', 'S');
        $this->db->where('qp.ativo_pelo_pesquisador =', 'S');
        $this->db->where('qp.ativo_pelo_pesquisador =', 'S');
        if(!empty($bufferp)){
            $this->db->where_in('qp.id', $buffer);
            $data = $this->db->get()->result();
        
            foreach ($data as $dt) {
                $dt->dt_inicio = implode("/", array_reverse(explode("-", $dt->dt_inicio)));
                $dt->dt_fim = implode("/", array_reverse(explode("-", $dt->dt_fim)));
            }
        } else {
            $data = $this->db->get()->result();
        }

        return $data;
    }

    /**
     * Busca todos os questionarios vinculados ao usuário da sessao
     * 
     * @param type $parametros [id]
     */
    function getQuestionarios($parametros) {
        $this->db->select("q.id, q.descricao, q.dt_inicio, q.dt_fim, "
                . "(CASE WHEN q.ativo_pelo_adm = 'S' THEN 'Sim' ELSE 'Não' END) as ativo_pelo_adm,"
                . "(CASE WHEN q.ativo_pelo_pesquisador = 'S' THEN 'Sim' ELSE 'Não' END) as ativo_pelo_pesquisador");
        $this->db->from('peoplegrid.questionarios as q');
        $this->db->where('pessoa_id', getUsuarioSession()->pessoa_id);
        $this->db->likeName('q.descricao', @$parametros['descricao']);
        $this->db->sendToGrid();
    }

    /**
     * Busca todos os questionarios vinculados ao usuário da sessao
     * 
     * @param type $parametros [id]
     */
    function getQuestionariosResultados($parametros) {
        $this->db->select("q.id, q.descricao, q.dt_inicio, q.dt_fim, (CASE WHEN q.ativo_pelo_pesquisador = 'S' THEN 'Sim' ELSE 'Não' END) as ativo");
        $this->db->from('peoplegrid.questionarios as q');
        $this->db->where('pessoa_id', getUsuarioSession()->pessoa_id);
        $this->db->likeName('q.descricao', @$parametros['descricao']);
        $this->db->sendToGrid();
    }
    
    
    /**
     * Busca o questionário conforme o id vindo de parametro
     * 
     * @param type $id
     * @return row
     */
    function getQuestionarioByLink($link) {
        $this->db->select('*');
        $this->db->from('peoplegrid.questionarios as q');
        $this->db->where('q.link', $link);
        $data = $this->db->get()->row();
        return $data;
    }
    
    /**
     * Busca o questionário conforme o id vindo de parametro
     * 
     * @param type $id
     * @return row
     */
    function getQuestionario($id) {
        $this->db->select('*');
        $this->db->from('peoplegrid.questionarios as q');
        $this->db->where('q.id', $id);
        $data = $this->db->get()->row();
        return $data;
    }

    /**
     * Inclui dados referentes a aba 1 onde salva a descricao do mapa
     * 
     * @param type $questionario
     * @return boolean
     */
    function incluir($questionario) {
        //logVar("aqui no incluir");

        if ($this->validaQuestionario($questionario)) {
            return false;
        }
/*
        if($questionario['cmbAtivo'] === '1'){
            $questionario['cmbAtivo'] = 'S';
        } else {
            $questionario['cmbAtivo'] = 'N';
        }
  */      
        $this->db->trans_begin();
            $this->db->set('descricao', $questionario['txtDescQuestionario']);
            $this->db->set('tipo_mapa', 'SAT');
            $this->db->setDate('dt_inicio', $questionario['dtInicio']);
            $this->db->setDate('dt_fim', $questionario['dtFim']);
            $this->db->set('ativo_pelo_pesquisador', 'N');
            $this->db->set('ativo_pelo_adm', 'S');
            $this->db->set('pessoa_id', getUsuarioSession()->pessoa_id);
        $this->db->insert('peoplegrid.questionarios');
        $this->db->trans_complete();

        $id = $this->db->insert_id('peoplegrid.questionarios', 'id');

        $r = hash('adler32', $id, false);
        
        $this->db->trans_begin();
            $this->db->set('link', $r);
            $this->db->where('id', $id);
            $this->db->update('peoplegrid.questionarios as q');
        $this->db->trans_complete();
        
        $dados = array(
            'questionario_id' => $id,
            'cor_1' => "2C7BB6",
            'cor_2' => "64A4CC",
            'cor_3' => "9CCEE3",
            'cor_4' => "C7E5DB",
            'cor_5' => "ECF6C8",
            'cor_6' => "FEEDAA",
            'cor_7' => "FDC980",
            'cor_8' => "F89D59",
            'cor_9' => "E75B35",
            'cor_10' => "D7191C");
        //logVar("aqui antes das cores");
        $this->db->trans_begin();
            $this->db->insert('peoplegrid.questionario_cores', $dados);
        $this->db->trans_complete();
        //logVar("depois das cores");
        $this->ajax->addAjaxData('questionario', $this->getQuestionario($id));
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        $this->db->trans_commit();
        return true;
    }

    /**
     * Inclui dados referentes a aba 2 onde salva a referencia do mapa
     * 
     * @param type $questionario
     * @return boolean
     */
    function incluirReferenciaMapa($questionario) {
        $retErro = $this->validaLocalQuestionario($questionario);
        if ($retErro) {
            return false;
        }
        
        $this->db->trans_begin();
            $this->db->set('geo_lat', $questionario['txtLat']);
            $this->db->set('geo_lon', $questionario['txtLng']);
            $this->db->set('zoom', $questionario['txtZoom']);
            $this->db->where('id', $questionario['txtIdQuestionarioReferencia']);
            $this->db->update('peoplegrid.questionarios as q');
        $this->db->trans_complete();
        $this->ajax->addAjaxData('questionario', $this->getQuestionario($questionario['txtIdQuestionarioReferencia']));
        return true;
    }
    
    function limpaReferenciaMapa($id){
        // se caso já estiver um mapa cadastrado ele limpa as referencias anteriores
        // e deṕois preenche com as novas;
        $this->db->trans_begin();
            $this->db->set('geo_lat', NULL);
            $this->db->set('geo_lon', NULL);
            $this->db->set('zoom', NULL);
            $this->db->set('ponto_sup_lat', NULL);
            $this->db->set('ponto_sup_lng', NULL);
            $this->db->set('ponto_inf_lat', NULL);
            $this->db->set('ponto_inf_lng', NULL);
            $this->db->set('precisao', NULL);
            $this->db->where('id', $id);
            $this->db->update('peoplegrid.questionarios as q');
        $this->db->trans_complete();
        
    }
    
    function verificaReferenciaMapa($id){
        $this->db->select('q.geo_lat, q.geo_lon, q.zoom');
        $this->db->from('peoplegrid.questionarios as q');
        $this->db->where('q.id', $id);
        $data = $this->db->get()->row();
        
        if(($data->geo_lat != '') || ($data->geo_lat != '') || ($data->zoom != '')) {
            return false;
        } else {
            return true;
        }
        
    }
    
    /**
     * Inclui dados referentes a aba 3 onde salva as referencias da grid
     * 
     * @param type $questionario
     * @return boolean
     */
    function incluirGrid($questionario) {
        $retErro = $this->validaGridQuestionario($questionario);
        if ($retErro) {
            return false;
        }
        
        // se caso já estiver um mapa cadastrado ele limpa as referencias anteriores
        // e deṕois preenche com as novas;
        $this->db->trans_begin();
            $this->db->set('ponto_sup_lat', NULL);
            $this->db->set('ponto_sup_lng', NULL);
            $this->db->set('ponto_inf_lat', NULL);
            $this->db->set('ponto_inf_lng', NULL);
            $this->db->set('precisao', NULL);
            $this->db->where('id', $questionario['txtIdQuestionarioGrid']);
            $this->db->update('peoplegrid.questionarios as q');
        $this->db->trans_complete();
        
        $this->db->trans_begin();
        $this->db->set('ponto_sup_lat', $questionario['txtPontoSupLat']);
        $this->db->set('ponto_sup_lng', $questionario['txtPontoSupLng']);
        $this->db->set('ponto_inf_lat', $questionario['txtPontoInfLat']);
        $this->db->set('ponto_inf_lng', $questionario['txtPontoInfLng']);
        $this->db->set('precisao', $questionario['txtPrecisao']);
        $this->db->where('id', $questionario['txtIdQuestionarioGrid']);
        $this->db->update('peoplegrid.questionarios as q');
        $this->db->trans_complete();
        $this->ajax->addAjaxData('questionario', $this->getQuestionario($questionario['txtIdQuestionarioGrid']));
        return true;
    }
    
    function limpaReferenciaGrid($id){
        // se caso já estiver um mapa cadastrado ele limpa as referencias anteriores
        // e deṕois preenche com as novas;
        $this->db->trans_begin();
            $this->db->set('ponto_sup_lat', NULL);
            $this->db->set('ponto_sup_lng', NULL);
            $this->db->set('ponto_inf_lat', NULL);
            $this->db->set('ponto_inf_lng', NULL);
            $this->db->set('precisao', NULL);
            $this->db->where('id', $id);
            $this->db->update('peoplegrid.questionarios as q');
        $this->db->trans_complete();
        
    }
    
    function verificaReferenciaGrid($id){
        $this->db->select('q.ponto_sup_lat, q.ponto_sup_lng,q.ponto_inf_lat, q.ponto_inf_lng, q.precisao');
        $this->db->from('peoplegrid.questionarios as q');
        $this->db->where('q.id', $id);
        $data = $this->db->get()->row();
        
        if(($data->ponto_sup_lat != '') || ($data->ponto_sup_lng != '') || ($data->ponto_inf_lat != '')
          || ($data->ponto_inf_lng != '') || ($data->precisao != '')) {
            return false;
        } else {
            return true;
        }
        
    }

    /**
     * Inclui dados referentes a aba 4 onde salva as perguntas selecionadas
     * @param type $perguntas
     * @return boolean
     * 
     */
    function incluirPerguntasQuestionario($perguntas) {
        
        logVar($perguntas);
        
        $ret = $this->validaPerguntaQuestionario($perguntas);
        
        if (($perguntas['txtFlag'] != 1) && ($ret)) {
            
            $idQuestionarioPerguntas = $this->getQuestionarioPerguntasGrid($perguntas['txtIdQuestionarioPerguntas']);
            // percorre todas as perguntas
            $buffer = array();
            foreach ($idQuestionarioPerguntas as $pergunta) {

                $respostas = $this->getRespostasByQuestionarioPerguntaGridId($pergunta->id);
                // percorre todas as respostas das perguntas
                foreach ($respostas as $resposta) {
                    array_push($buffer, $resposta->resposta_id);
                }

                // deleta as respostas referente a $pergunta
                $this->db->where('questionario_pergunta_grid_id', $pergunta->id);
                $this->db->delete('peoplegrid.grid_respostas');

                $this->db->where('id', $pergunta->id);
                $this->db->delete('peoplegrid.questionario_perguntas_grid');
            }

            foreach ($buffer as $b) {
                $this->db->where('id', $b);
                $this->db->delete('peoplegrid.respostas');
            }

        }
        // só trooca a ordem das perguntas
        //logVar($perguntas['txtFlag']);
        //logVar($ret);
        if(($perguntas['txtFlag'] == 1) && ($ret)){
            //logVar("IF");
            if ($perguntas['txtPerguntas'] != '') {
                $perguntasId = explode(',', $perguntas['txtPerguntas']);
                for ($i = 0; $i < count($perguntasId); $i++) {
                    $this->db->set('ordem', $i + 1);
                    $this->db->where('questionario_id', $perguntas['txtIdQuestionarioPerguntas']);
                    $this->db->where('pergunta_grid_id', $perguntasId[$i]);
                    $this->db->update('peoplegrid.questionario_perguntas_grid');
                    logLastSQL();
                }
            }
            //logVar($perguntas);
            //logLastSQL();
        } else {
            //logVar("Else");
            $this->db->where('questionario_id', $perguntas['txtIdQuestionarioPerguntas']);
            $this->db->delete('peoplegrid.questionario_perguntas_grid');



            if ($perguntas['txtPerguntas'] != '') {
                $perguntasId = explode(',', $perguntas['txtPerguntas']);
                for ($i = 0; $i < count($perguntasId); $i++) {
                    $this->db->set('questionario_id', $perguntas['txtIdQuestionarioPerguntas']);
                    $this->db->set('pergunta_grid_id', $perguntasId[$i]);
                    $this->db->set('ordem', $i + 1);
                    $this->db->set('dt_cadastro', 'now()');
                    $this->db->insert('peoplegrid.questionario_perguntas_grid');
                }
            }
        }
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }
        $this->db->trans_commit();
        $this->ajax->addAjaxData('questionario', $this->getQuestionario($perguntas['txtIdQuestionarioPerguntas']));
        return true;
    }

    /**
     * Altera a descrição do mapa
     * 
     * @param type $questionario
     * @return boolean
     */
    function alterar($questionario) {
        //logVar($questionario);
        $retErro = $this->validaQuestionario($questionario);
        if ($retErro) {
            return false;
        }
        /*
        logVar($questionario);
        if($questionario['cmbAtivo'] === '1'){
            $questionario['cmbAtivo'] = 'S';
        } else {
            $questionario['cmbAtivo'] = 'N';
        }
        */
        logVar($questionario);
        $this->db->trans_begin();
        $this->db->set('descricao', $questionario['txtDescQuestionario']);
        $this->db->set('tipo_mapa', 'SAT');
        $this->db->setDate('dt_inicio', $questionario['dtInicio']);
        $this->db->setDate('dt_fim', $questionario['dtFim']);
        //$this->db->set('ativo_pelo_pesquisador', $questionario['cmbAtivo']);
        $this->db->where('id', $questionario['txtId']);
        $this->db->update('peoplegrid.questionarios as q');
        $this->db->trans_complete();
        $this->ajax->addAjaxData('questionario', $this->getQuestionario($questionario['txtId']));

        return true;
    }
    
        /**
     * Altera se o mapa esta ativo ou não.
     * 
     * @param type $questionario
     * @return boolean
     */
    function alterarAtivoPesquisador($questionario) {
        logVar($questionario);
        
        if($questionario['cmbAtivo'] === '1'){
            $questionario['cmbAtivo'] = 'S';
        } else {
            $questionario['cmbAtivo'] = 'N';
        }
        logVar($questionario);
        $this->db->trans_begin();
            $this->db->set('ativo_pelo_pesquisador', $questionario['cmbAtivo']);
            $this->db->where('id', $questionario['txtIdAtivo']);
            $this->db->update('peoplegrid.questionarios as q');
        $this->db->trans_complete();
        $this->ajax->addAjaxData('questionario', $this->getQuestionario($questionario['txtIdAtivo']));

        return true;
    }
    
    
    function excluirMapaAntigo($questionarioId){
        $idQuestionarioPerguntas = $this->getQuestionarioPerguntasGrid($questionarioId);
        // percorre todas as perguntas
        $buffer = array();
        foreach ($idQuestionarioPerguntas as $pergunta) {

            $respostas = $this->getRespostasByQuestionarioPerguntaGridId($pergunta->id);
            // percorre todas as respostas das perguntas
            foreach ($respostas as $resposta) {
                array_push($buffer, $resposta->resposta_id);
            }

            // deleta as respostas referente a $pergunta
            $this->db->where('questionario_pergunta_grid_id', $pergunta->id);
            $this->db->delete('peoplegrid.grid_respostas');

            $this->db->where('id', $pergunta->id);
            $this->db->delete('peoplegrid.questionario_perguntas_grid');
        }

        foreach ($buffer as $b) {
            $this->db->where('id', $b);
            $this->db->delete('peoplegrid.respostas');
        }
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
                $this->db->where('questionario_pergunta_grid_id', $pergunta->id);
                $this->db->delete('peoplegrid.grid_respostas');

                $this->db->where('id', $pergunta->id);
                $this->db->delete('peoplegrid.questionario_perguntas_grid');
            }

            foreach ($buffer as $b) {
                $this->db->where('id', $b);
                $this->db->delete('peoplegrid.respostas');
            }
            
            $this->db->where('questionario_id', $idQ);
            $this->db->delete('peoplegrid.questionario_cores');
            
            $this->db->where('id', $idQ);
            $this->db->delete('peoplegrid.questionarios');
            
        }
            
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }
        $this->db->trans_commit();
        return true;
    }

    function getRespostasByQuestionarioPerguntaGridId($idPerguntaQuestionario) {

        $this->db->from('peoplegrid.grid_respostas as gr');
        $this->db->where('gr.questionario_pergunta_grid_id', $idPerguntaQuestionario);
        $data = $this->db->get()->result();
        return $data;
        
    }

    function getQuestionarioPerguntasGrid($questionarioId) {
        $this->db->where('questionario_id', $questionarioId);
        return $this->db->get('peoplegrid.questionario_perguntas_grid')->result();

    }

    /**
     *
     * @return boolean
     * @param $usuario $_POST
     */
    function validaQuestionario($questionario) {
        $this->validate->setData($questionario);
        $this->validate->validateField('txtDescQuestionario', array('required'), 'Informe o nome do questionário.');
        $this->validate->validateField('dtInicio', array('required'), 'Informe a data de início da pesquisa.');
        $this->validate->validateField('dtFim', array('required'), 'Informe a data de final da pesquisa.');
        return $this->validate->existsErrors();
    }

    function validaLocalQuestionario($questionario) {
        $this->validate->setData($questionario);
        $this->validate->validateField('txtLat', array('required'), 'Informe a Localização da Pesquisa.');
        $this->validate->validateField('txtLng', array('required'), 'Informe a Localização da Pesquisa.');
        $this->validate->validateField('txtZoom', array('required'), 'Problema no Zoom.');
        return $this->validate->existsErrors();
    }

    function validaGridQuestionario($questionario) {
        $this->validate->setData($questionario);
        $this->validate->validateField('txtPontoSupLat', array('required'), 'Latitude do poto superior não está correta.');
        $this->validate->validateField('txtPontoSupLng', array('required'), 'Longitude do poto superior não está correta.');
        $this->validate->validateField('txtPontoSupLat', array('required'), 'Latitude do poto inferior não está correta.');
        $this->validate->validateField('txtPontoSupLng', array('required'), 'Longitude do poto inferior não está correta.');
        return $this->validate->existsErrors();
    }

    function validaPerguntaQuestionario($perguntas) {
        $this->db->trans_begin();
            $this->db->select('count(*) as total_perguntas', false);
            $this->db->from('peoplegrid.questionario_perguntas_grid as qp');
            $this->db->where('qp.questionario_id', @$perguntas['txtIdQuestionarioPerguntas']);
            $total = $this->db->get('peoplegrid.questionario_perguntas_grid')->row()->total_perguntas;
        $this->db->trans_complete();

        if ($total > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    function validaRespostasPerguntaQuestionario($idPerguntaQuestionario) {
        $this->db->trans_begin();
            $this->db->select('count(*) as total_respostas', false);
            $this->db->from('peoplegrid.grid_respostas as gr');
            $this->db->where('gr.questionario_pergunta_grid_id', $idPerguntaQuestionario);
            $total = $this->db->get('peoplegrid.grid_respostas')->row()->total_respostas;
        $this->db->trans_complete();
        
        if ($total > 0) {
            return true;
        } else {
            return false;
        }
    }

}
