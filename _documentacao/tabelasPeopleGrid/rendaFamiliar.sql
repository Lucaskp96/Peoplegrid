CREATE TABLE peoplegrid.rendaFamiliar
(
  id serial NOT NULL,
  descricao character varying(255),
  CONSTRAINT pk_rendaFamiliar PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
