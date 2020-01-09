<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package administrador
 * @subpackage questionario
 * @author agpeil
 */
class PesquisadorModel extends Model {

    function __construct() {
        parent::__construct();
    }


    
    /**
     *
     * @return Array para montar a grid
     * @param $nome string[optional]
     * @param $login string[optional]
     * @param $start integer
     * @param $limit integer
     */
    function getUsuarios($parametros) {
        $this->db->select('u.id, p.nome as nome, u.login, p.email as email, ga.nome as tipo_usuario');
        $this->db->from('usuarios as u');
        $this->db->join('pessoas as p', 'p.id = u.pessoa_id');
        $this->db->join('usuarios_grupos_acessos as uga', 'u.id = uga.usuario_id');
        $this->db->join('grupos_acessos as ga', 'ga.id = uga.grupo_acesso_id');
        $this->db->where('ga.id !=', 1);
            
        if(@$parametros['nome'] != ''){
            $this->db->likeName('p.nome', $parametros['nome']);
        }
        if(@$parametros['login'] != ''){
            $this->db->likeName('u.login', $parametros['login']);
        }
        if(@$parametros['tipo_usuario'] != ''){
            $this->db->where('ga.id', $parametros['tipo_usuario']);
        }
    
        $this->db->sendToGrid();
    }
    
        /**
     *
     * @return Array para montar a grid
     * @param $nome string[optional]
     * @param $login string[optional]
     * @param $start integer
     * @param $limit integer
     */
    function getUsuario($id) {
        $this->db->select('u.id, p.nome as nome, u.login, p.email as email, p.sexo, '
                . 'p.telefone, ga.nome as tipo_usuario, ga.id as tipo_usuario_id,'
                . 'p.dt_nascimento, p.id as pessoa_id');
        $this->db->from('usuarios as u');
        $this->db->join('pessoas as p', 'p.id = u.pessoa_id');
        $this->db->join('usuarios_grupos_acessos as uga', 'u.id = uga.usuario_id');
        $this->db->join('grupos_acessos as ga', 'ga.id = uga.grupo_acesso_id');
        $this->db->where('u.id ', $id);
        return $this->db->get()->row();
    }
    
    /**
    * Inseri o usuário no sistema
    * @param array $usuario $_POST informações do usuário enviados pela view
    * @return boolean
     */
    function incluir($pesquisador) {
        if ($this->validaInclusaoUsuario($pesquisador)) {
            return false;
        }
        $this->db->trans_begin();
        $this->db->set('nome', 'trim(upper(\'' . trim(strtoupper($pesquisador['txtNome'])) . '\'))', false);
        $this->db->set('nome_consulta', 'trim(upper(retira_acento(\'' . trim(strtoupper($pesquisador['txtNome'])) . '\')))', false);
        $this->db->set('sexo', $pesquisador['chksexo']);
        if ($pesquisador['dtNascimento'] != '') {
            $this->db->setDate('dt_nascimento',$pesquisador['dtNascimento']);
        } else {
            $this->db->set('dt_nascimento', 'NULL', false);
        }
        $this->db->set('email', $pesquisador['txtEmail']);
        $this->db->set('telefone', $pesquisador['txtTelefone']);
        $this->db->set('dt_cadastro', 'NOW()', false);
        $this->db->insert('pessoas');

        $this->db->set('pessoa_id', $this->db->insert_id('pessoas', 'id'));
        $this->db->set('login', $pesquisador['txtLogin']);
        $this->db->set('senha', $this->encrypt->sha1($pesquisador['txtSenha']));
        $this->db->set('dt_cadastro', 'NOW()', false);
        $this->db->insert('usuarios');
        $this->ajax->addAjaxData('usuario', $this->getUsuario($this->db->insert_id('usuarios', 'id')));
        
        
        $this->db->set('usuario_id', $this->db->insert_id('usuarios', 'id'));
        $this->db->set('grupo_acesso_id', $pesquisador['cmbTipoUsuario']);
        $this->db->insert('usuarios_grupos_acessos');
        
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        $this->db->trans_commit();
        return true;
    }

    
     /**
	 * Altera o usuário no sistema
	 * @param array $usuario $_POST informações do usuário enviados pela view
     * @return boolean
     */
    function alterar($pesquisador) {
        $retErro = $this->validaAlterarUsuario($pesquisador);
        if ($retErro) {
            return false;
        }
        $pessoaId = $this->getUsuario($pesquisador['txtId'])->pessoa_id;

        $this->db->trans_begin();
        $this->db->set('nome', 'trim(upper(\'' . trim(strtoupper($pesquisador['txtNome'])) . '\'))', false);
        $this->db->set('nome_consulta', 'trim(upper(retira_acento(\'' . trim(strtoupper($pesquisador['txtNome'])) . '\')))', false);
        $this->db->set('sexo', $pesquisador['chksexo']);
        
        if ($pesquisador['dtNascimento'] != '') {
            $this->db->setDate('dt_nascimento',$pesquisador['dtNascimento']);
        } else {
            $this->db->set('dt_nascimento', 'NULL', false);
        }
        $this->db->set('email', $pesquisador['txtEmail']);
        
        $telefone = str_replace('(', '', $pesquisador['txtTelefone']);
        $telefone = str_replace(')', '', $telefone);
        $telefone = str_replace(' ', '', $telefone);
        $telefone = str_replace('-', '', $telefone);
        
        $this->db->set('telefone', $telefone);
        $this->db->where('id', $pessoaId);
        $this->db->update('pessoas');

        $this->db->set('login', $pesquisador['txtLogin']);
        if ($pesquisador['txtSenha'] != '') {
            $this->db->set('senha', $this->encrypt->sha1($pesquisador['txtSenha']));
        }
        $this->db->where('id', $pesquisador['txtId']);
        $this->db->update('usuarios');

        $this->ajax->addAjaxData('usuario', $this->getUsuario($pesquisador['txtId']));
        
        $this->db->set('grupo_acesso_id', $pesquisador['cmbTipoUsuario']);
        $this->db->where('usuario_id', $pesquisador['txtId']);
        $this->db->update('usuarios_grupos_acessos');
        
        
        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        $this->db->trans_commit();
        return true;
    }

    function excluir($id) {
        $this->db->trans_begin();
        
        $aPerguntas = explode(',', $id);
        $aExcluirPerguntas = array();
        for ($i = 0; $i < count($aPerguntas); $i++) {
            if ($aPerguntas[$i] != 'undefined') {
                array_push($aExcluirPerguntas, $aPerguntas[$i]);
            }
        }
        
        
        foreach ($aExcluirPerguntas as $a){
            
            $pessoaId = $this->getUsuario($a)->pessoa_id;
            $this->db->trans_begin();
            
            $this->db->where('usuario_id', $a);
            $this->db->delete('usuarios_grupos_acessos');
            
            $this->db->where('id', $a);
            $this->db->delete('usuarios');            

            $this->db->where('id', $pessoaId);
            $this->db->delete('pessoas');
            
            if ($this->db->trans_status() === FALSE) {
                $this->db->trans_rollback();
                return false;
            }
                
        }
        $this->db->trans_commit();
        
        return true;
    }
    
    
    /**
     *
     * @return boolean
     * @param $usuario $_POST
     */
    function validaInclusaoUsuario($usuario) {
        $this->validate->setData($usuario);
        $this->validate->validateField('txtNome', array('required'), 'Nome deve ser informado');
        $this->validate->validateField('txtLogin', array('required'), 'Login deve ser informado');
        $this->validate->validateField('txtSenha', array('required'), 'Senha deve ser informada');
        $this->validate->validateField('txtEmail', array('required'), 'Email é um campo obrigatório');
        $this->validate->validateField('cmbTipoUsuario', array('required'), 'O tipo de usuário deve ser informado');
        return $this->validate->existsErrors();
    }

    /**
     *
     * @return boolean
     * @param $usuario $_POST
     */
    function validaAlterarUsuario($usuario) {
        $this->validate->setData($usuario);
        $this->validate->validateField('txtNome', array('required'), 'Nome deve ser informado');
        $this->validate->validateField('txtLogin', array('required'), 'Login deve ser informado');
        $this->validate->validateField('txtEmail', array('required'), 'Email é um campo obrigatório');
        $this->validate->validateField('cmbTipoUsuario', array('required'), 'O tipo de usuário deve ser informado');
        return $this->validate->existsErrors();
    }
    
}