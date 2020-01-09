CREATE TABLE peoplegrid.nivelEscolaridade
(
  id serial NOT NULL,
  descricao character varying(255),
  CONSTRAINT pk_nivelEscolaridade PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
