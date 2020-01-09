DROP TABLE peoplegrid.dinamica_respostas;
DROP TABLE peoplegrid.grid_respostas;
DROP TABLE peoplegrid.perguntas_questionario_dinamicas;
DROP TABLE peoplegrid.questionarios;
DROP TABLE peoplegrid.perguntas_dinamica;
DROP TABLE peoplegrid.questionario_perguntas_grid;
DROP TABLE peoplegrid.respostas;
DROP TABLE peoplegrid.perguntas_grid;
DROP TABLE peoplegrid.nivel_escolaridade;
DROP TABLE peoplegrid.tipo_pergunta_dinamica;
DROP TABLE peoplegrid.pensou_como;
DROP TABLE peoplegrid.renda_familiar;

CREATE TABLE peoplegrid.renda_familiar (
       id SERIAL NOT NULL
     , descricao VARCHAR(255)
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
);

CREATE TABLE peoplegrid.pensou_como (
       id INTEGER NOT NULL
     , descricao VARCHAR(255)
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
);

CREATE TABLE peoplegrid.tipo_pergunta_dinamica (
       id SERIAL NOT NULL
     , descricao VARCHAR(45)
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
);

CREATE TABLE peoplegrid.nivel_escolaridade (
       id SERIAL NOT NULL
     , descricao CHAR(255)
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
);

CREATE TABLE peoplegrid.perguntas_grid (
       id SERIAL NOT NULL
     , pessoa_id INTEGER
     , descricao VARCHAR(255)
     , obrigatoria CHAR(1) DEFAULT 'N'
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
     , CONSTRAINT FK_perguntas_grid_1 FOREIGN KEY (pessoa_id)
                  REFERENCES public.pessoas (id)
);

CREATE TABLE peoplegrid.respostas (
       id SERIAL NOT NULL
     , nivel_escolaridade_id INTEGER
     , pensou_como_id INTEGER
     , renda_familiar_id INTEGER
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
     , CONSTRAINT FK_respostas_3 FOREIGN KEY (pensou_como_id)
                  REFERENCES peoplegrid.pensou_como (id)
     , CONSTRAINT FK_respostas_2 FOREIGN KEY (renda_familiar_id)
                  REFERENCES peoplegrid.renda_familiar (id)
     , CONSTRAINT FK_respostas_1 FOREIGN KEY (nivel_escolaridade_id)
                  REFERENCES peoplegrid.nivel_escolaridade (id)
);

CREATE TABLE peoplegrid.questionario_perguntas_grid (
       id SERIAL NOT NULL
     , pergunta_grid_id INTEGER
     , questionario_id INTEGER
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
     , CONSTRAINT FK_questionario_perguntas_2 FOREIGN KEY (pergunta_grid_id)
                  REFERENCES peoplegrid.perguntas_grid (id)
     , CONSTRAINT FK_questionario_perguntas_1 FOREIGN KEY (questionario_id)
                  REFERENCES peoplegrid.questionarios (id)
);

CREATE TABLE peoplegrid.perguntas_dinamica (
       id SERIAL NOT NULL
     , descricao VARCHAR(255)
     , obrigatoria CHAR(1) DEFAULT 'N'
     , tipo_pergunta_dinamica_id INTEGER
     , pessoa_id INTEGER
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
     , CONSTRAINT FK_perguntas_dinamica_1 FOREIGN KEY (tipo_pergunta_dinamica_id)
                  REFERENCES peoplegrid.tipo_pergunta_dinamica (id)
     , CONSTRAINT FK_perguntas_dinamica_2 FOREIGN KEY (pessoa_id)
                  REFERENCES public.pessoas (id)
);

CREATE TABLE peoplegrid.questionarios (
       id SERIAL NOT NULL
     , descricao CHAR(255)
     , geo_lat CHAR(30)
     , geo_lon VARCHAR(30)
     , zoom INT
     , tipo_mapa CHAR(3) DEFAULT 'SAT'
     , ativo_pelo_pesquisador CHAR(1)
     , ativo_pelo_adm CHAR(1)
     , dt_inicio DATE
     , dt_fim DATE
     , pessoa_id INTEGER
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
     , CONSTRAINT FK_questionarios_1 FOREIGN KEY (pessoa_id)
                  REFERENCES public.pessoas (id)
);

CREATE TABLE peoplegrid.perguntas_questionario_dinamicas (
       id SERIAL NOT NULL
     , questionario_id INTEGER
     , pergunta_dinamica_id INTEGER
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
     , CONSTRAINT FK_perguntas_questionario_dinamicas_2 FOREIGN KEY (questionario_id)
                  REFERENCES peoplegrid.questionarios (id)
     , CONSTRAINT FK_perguntas_questionario_dinamicas_1 FOREIGN KEY (pergunta_dinamica_id)
                  REFERENCES peoplegrid.perguntas_dinamica (id)
);

CREATE TABLE peoplegrid.grid_respostas (
       id SERIAL NOT NULL
     , pergunta_questionario_grid_id INTEGER
     , resposta_id INTEGER
     , grid VARCHAR(4000)
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
     , CONSTRAINT FK_grid_respostas_1 FOREIGN KEY (pergunta_questionario_grid_id)
                  REFERENCES peoplegrid.questionario_perguntas_grid (id)
     , CONSTRAINT FK_grid_respostas_2 FOREIGN KEY (resposta_id)
                  REFERENCES peoplegrid.respostas (id)
);

CREATE TABLE peoplegrid.dinamica_respostas (
       id SERIAL NOT NULL
     , pergunta_questionario_dinamica_id INTEGER
     , resposta_id INTEGER
     , resposta_dinamica TEXT
     , dt_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now()
     , PRIMARY KEY (id)
     , CONSTRAINT FK_dinamica_respostas_1 FOREIGN KEY (pergunta_questionario_dinamica_id)
                  REFERENCES peoplegrid.perguntas_questionario_dinamicas (id)
     , CONSTRAINT FK_dinamica_respostas_2 FOREIGN KEY (id)
                  REFERENCES peoplegrid.respostas (id)
);

