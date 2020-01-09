-- Table: peoplegrid.questionario

-- DROP TABLE peoplegrid.questionario;

CREATE TABLE peoplegrid.questionario
(
  id serial NOT NULL,
  descricao character varying(255),
  referenciamapa character varying(255),
  ativo character varying(1),
  dt_inicio date,
  dt_fim date,
  codcidade serial NOT NULL,
  codusuario serial NOT NULL,
  CONSTRAINT pk_questionario PRIMARY KEY (id),
  CONSTRAINT fk_cidades FOREIGN KEY (codcidade)
      REFERENCES cidades (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_usuarios FOREIGN KEY (codusuario)
      REFERENCES usuarios (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE peoplegrid.questionario
  OWNER TO postgres;
