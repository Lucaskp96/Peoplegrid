<?php
class ConfiguracaoModel extends Model {
    
    
    function getEmailAdministrador(){
    	$this->db->trans_start();
    		$this->db->select('email_administrador');
    		$this->db->from('configuracao');
                    $this->db->limit(1);
    	$this->db->trans_complete();	
    	return $this->db->get()->row()->email_administrador;
    }
    
    function getEmailAdministrador2(){
    	$this->db->trans_start();
    		$this->db->select('email_administrador_2');
    		$this->db->from('configuracao');
                    $this->db->limit(1);
    	$this->db->trans_complete();	
    	return $this->db->get()->row()->email_administrador_2;
    }
    
    function getEmail(){
    	$this->db->trans_start();
    		$this->db->select('email');
    		$this->db->from('configuracao');
                    $this->db->limit(1);
    	$this->db->trans_complete();	
    	return $this->db->get()->row()->email;
    }
    
    function getSenha(){
    	$this->db->trans_start();
    		$this->db->select('senha');
    		$this->db->from('configuracao');
                    $this->db->limit(1);
    	$this->db->trans_complete();	
    	return $this->db->get()->row()->senha;
    }
    
    function getPerfil($id){
    	$this->db->trans_start();
    		$this->db->select('*');
    		$this->db->from('configuracao');
    		$this->db->where('id', $id);
    	$this->db->trans_complete();
    	return $this->db->get()->result();
    }
    
    function atualizarPerfil($parametros){
        $this->db->trans_start();
            $this->db->where('id', 1);
            $this->db->set('senha', $parametros['senha']);
            $this->db->set('email', $parametros['email']);
            $this->db->set('email_administrador', $parametros['email_administrador']);
            $this->db->set('email_administrador_2', $parametros['email_administrador_2']);
            $this->db->update('configuracao');
        $this->db->trans_complete();
        
        $this->ajax->addAjaxData('perfil', $this->getPerfil(1));
    }
}
?>