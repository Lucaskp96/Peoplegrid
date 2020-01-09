-- Table: peoplegrid.grid

-- DROP TABLE peoplegrid.grid;

CREATE TABLE peoplegrid.grid
(
  codpergunta serial NOT NULL,
  codresposta serial NOT NULL,
  codquestionario serial NOT NULL,
  respostagrid character varying(4000),
  CONSTRAINT pk_grid PRIMARY KEY (codpergunta, codresposta, codquestionario),
  CONSTRAINT fk_codquestionario FOREIGN KEY (codquestionario)
      REFERENCES peoplegrid.questionario (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_pergunta FOREIGN KEY (codpergunta)
      REFERENCES peoplegrid.pergunta (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_resposta FOREIGN KEY (codresposta)
      REFERENCES peoplegrid.resposta (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE peoplegrid.grid
  OWNER TO postgres;

