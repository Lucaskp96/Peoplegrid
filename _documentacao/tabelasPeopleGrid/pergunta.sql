-- Table: peoplegrid.pergunta

-- DROP TABLE peoplegrid.pergunta;

CREATE TABLE peoplegrid.pergunta
(
  id serial NOT NULL,
  descricao character varying(255),
  codquestionario serial NOT NULL,
  CONSTRAINT pk_pergunta PRIMARY KEY (id),
  CONSTRAINT fk_questionario FOREIGN KEY (codquestionario)
      REFERENCES peoplegrid.questionario (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE peoplegrid.pergunta
  OWNER TO postgres;

