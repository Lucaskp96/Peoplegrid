-- Table: peoplegrid.resposta

-- DROP TABLE peoplegrid.resposta;

CREATE TABLE peoplegrid.resposta
(
  id serial NOT NULL,
  codnivelescolaridade serial NOT NULL,
  codrendafamiliar serial NOT NULL,
  codvocepensoucomo serial NOT NULL,
  codquestionario serial NOT NULL,
  CONSTRAINT pk_resposta PRIMARY KEY (id),
  CONSTRAINT fk_codquestionario FOREIGN KEY (codquestionario)
      REFERENCES peoplegrid.questionario (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_nivelescolaridade FOREIGN KEY (codnivelescolaridade)
      REFERENCES peoplegrid.nivelescolaridade (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_rendafamiliar FOREIGN KEY (codrendafamiliar)
      REFERENCES peoplegrid.rendafamiliar (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_vocepensoucomo FOREIGN KEY (codvocepensoucomo)
      REFERENCES peoplegrid.vocepensoucomo (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE peoplegrid.resposta
  OWNER TO postgres;

