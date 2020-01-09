<?php

/**
 * Classe responsável por manipular as tabelas referentes aos questinários
 * @package publico
 * @subpackage filtro
 * @author agpeil
 */
class FiltroModel extends Model {
    
    function __construct() {
        parent::__construct();
    }
    
    
    function getPensouComo(){
        $this->db->select('pc.id, pc.descricao');
        $this->db->from('peoplegrid.pensou_como as pc');
        $this->db->where('pc.id !=', 1);
        $this->db->order_by('pc.id');
        $data = $this->db->get()->result();
        return $data;  
    }
    
    
    function getNivelEscolaridade(){
        $this->db->select('ne.id, ne.descricao');
        $this->db->from('peoplegrid.nivel_escolaridade as ne');
        $this->db->where('ne.id !=', 1);
        $this->db->order_by('ne.id');
        $data = $this->db->get()->result();
        return $data; 
    }
    
    function getRendaFamiliar(){
        $this->db->select('rf.id, rf.descricao');
        $this->db->from('peoplegrid.renda_familiar as rf');
        $this->db->where('rf.id !=', 1);
        $this->db->order_by('rf.id');
        $data = $this->db->get()->result();
        return $data;
    }
    
}



?>