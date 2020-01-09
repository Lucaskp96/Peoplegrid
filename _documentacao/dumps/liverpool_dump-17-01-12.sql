--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: peoplegrid; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA peoplegrid;


ALTER SCHEMA peoplegrid OWNER TO postgres;

--
-- Name: peopleplan; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA peopleplan;


ALTER SCHEMA peopleplan OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: fnc_get_parametro(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fnc_get_parametro(nome character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
	DECLARE
		v_nome_parametro ALIAS FOR $1;
		r record;
	BEGIN
		select into r p.* from parametros as p where p.nome = v_nome_parametro;
		
		RETURN r.valor;
	END
$_$;


ALTER FUNCTION public.fnc_get_parametro(nome character varying) OWNER TO postgres;

--
-- Name: retira_acento(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retira_acento(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select
translate($1,'áàâãäéèêëíìïóòôõöúùûüÁÀÂÃÄÉÈÊËÍÌÏÓÒÔÕÖÚÙÛÜçÇ','aaaaaeeeeiiiooooouuuuAAAAAEEEEIIIOOOOOUUUUcC');
$_$;


ALTER FUNCTION public.retira_acento(text) OWNER TO postgres;

--
-- Name: serialize_array(text[], character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION serialize_array(text[], separador character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$
	DECLARE
		v_array ALIAS FOR $1;
		v_separador ALIAS FOR $2;
		v_serialize_array text := '';
	BEGIN
		FOR i IN array_lower(v_array, 1) .. array_upper(v_array, 1) LOOP
			IF v_serialize_array = '' THEN
				v_serialize_array := v_array[i];
			ELSE
				IF v_separador = '' THEN
					v_serialize_array := v_serialize_array||','||v_array[i];
				ELSE
					v_serialize_array := v_serialize_array||v_separador||v_array[i];
				END IF;
			END IF;
		END LOOP;

		RETURN v_serialize_array;
	END
$_$;


ALTER FUNCTION public.serialize_array(text[], separador character varying) OWNER TO postgres;

SET search_path = peoplegrid, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: dinamica_respostas; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE dinamica_respostas (
    id integer NOT NULL,
    pergunta_questionario_dinamica_id integer,
    resposta_id integer,
    resposta_dinamica text,
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peoplegrid.dinamica_respostas OWNER TO postgres;

--
-- Name: dinamica_respostas_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE dinamica_respostas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.dinamica_respostas_id_seq OWNER TO postgres;

--
-- Name: dinamica_respostas_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE dinamica_respostas_id_seq OWNED BY dinamica_respostas.id;


--
-- Name: grid_respostas; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE grid_respostas (
    id integer NOT NULL,
    questionario_pergunta_grid_id integer,
    resposta_id integer,
    grid text,
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peoplegrid.grid_respostas OWNER TO postgres;

--
-- Name: grid_respostas_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE grid_respostas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.grid_respostas_id_seq OWNER TO postgres;

--
-- Name: grid_respostas_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE grid_respostas_id_seq OWNED BY grid_respostas.id;


--
-- Name: nivel_escolaridade; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE nivel_escolaridade (
    id integer NOT NULL,
    descricao character(255),
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peoplegrid.nivel_escolaridade OWNER TO postgres;

--
-- Name: nivel_escolaridade_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE nivel_escolaridade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.nivel_escolaridade_id_seq OWNER TO postgres;

--
-- Name: nivel_escolaridade_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE nivel_escolaridade_id_seq OWNED BY nivel_escolaridade.id;


--
-- Name: pensou_como; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE pensou_como (
    id integer NOT NULL,
    descricao character varying(255),
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peoplegrid.pensou_como OWNER TO postgres;

--
-- Name: pensou_como_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE pensou_como_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.pensou_como_id_seq OWNER TO postgres;

--
-- Name: pensou_como_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE pensou_como_id_seq OWNED BY pensou_como.id;


--
-- Name: perguntas_dinamica; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE perguntas_dinamica (
    id integer NOT NULL,
    descricao character varying(255),
    obrigatoria character(1) DEFAULT 'N'::bpchar,
    tipo_pergunta_dinamica_id integer,
    pessoa_id integer,
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peoplegrid.perguntas_dinamica OWNER TO postgres;

--
-- Name: perguntas_dinamica_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE perguntas_dinamica_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.perguntas_dinamica_id_seq OWNER TO postgres;

--
-- Name: perguntas_dinamica_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE perguntas_dinamica_id_seq OWNED BY perguntas_dinamica.id;


--
-- Name: perguntas_grid; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE perguntas_grid (
    id integer NOT NULL,
    pessoa_id integer,
    descricao character varying(255),
    obrigatoria character(1) DEFAULT 'N'::bpchar,
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peoplegrid.perguntas_grid OWNER TO postgres;

--
-- Name: perguntas_grid_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE perguntas_grid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.perguntas_grid_id_seq OWNER TO postgres;

--
-- Name: perguntas_grid_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE perguntas_grid_id_seq OWNED BY perguntas_grid.id;


--
-- Name: questionario_perguntas_dinamica; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE questionario_perguntas_dinamica (
    id integer NOT NULL,
    questionario_id integer,
    pergunta_dinamica_id integer,
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peoplegrid.questionario_perguntas_dinamica OWNER TO postgres;

--
-- Name: perguntas_questionario_dinamicas_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE perguntas_questionario_dinamicas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.perguntas_questionario_dinamicas_id_seq OWNER TO postgres;

--
-- Name: perguntas_questionario_dinamicas_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE perguntas_questionario_dinamicas_id_seq OWNED BY questionario_perguntas_dinamica.id;


--
-- Name: questionario_cores; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE questionario_cores (
    id integer NOT NULL,
    questionario_id integer NOT NULL,
    cor_1 character varying(6) DEFAULT '0592f7'::character varying NOT NULL,
    cor_2 character varying(6) DEFAULT '3787bf'::character varying NOT NULL,
    cor_3 character varying(6) DEFAULT '44779c'::character varying NOT NULL,
    cor_4 character varying(6) DEFAULT '43637a'::character varying NOT NULL,
    cor_5 character varying(6) DEFAULT '323c42'::character varying NOT NULL,
    cor_6 character varying(6) DEFAULT '020303'::character varying NOT NULL,
    cor_7 character varying(6) DEFAULT '403030'::character varying NOT NULL,
    cor_8 character varying(6) DEFAULT '613e3e'::character varying NOT NULL,
    cor_9 character varying(6) DEFAULT '9c2a2a'::character varying NOT NULL,
    cor_10 character varying(6) DEFAULT 'c91010'::character varying NOT NULL
);


ALTER TABLE peoplegrid.questionario_cores OWNER TO postgres;

--
-- Name: questionario_cores_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE questionario_cores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.questionario_cores_id_seq OWNER TO postgres;

--
-- Name: questionario_cores_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE questionario_cores_id_seq OWNED BY questionario_cores.id;


--
-- Name: questionario_perguntas_grid; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE questionario_perguntas_grid (
    id integer NOT NULL,
    pergunta_grid_id integer,
    questionario_id integer,
    dt_cadastro timestamp with time zone DEFAULT now(),
    ordem integer
);


ALTER TABLE peoplegrid.questionario_perguntas_grid OWNER TO postgres;

--
-- Name: questionario_perguntas_grid_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE questionario_perguntas_grid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.questionario_perguntas_grid_id_seq OWNER TO postgres;

--
-- Name: questionario_perguntas_grid_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE questionario_perguntas_grid_id_seq OWNED BY questionario_perguntas_grid.id;


--
-- Name: questionarios; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE questionarios (
    id integer NOT NULL,
    descricao text,
    geo_lat character varying(30),
    geo_lon character varying(30),
    zoom integer,
    tipo_mapa character(3) DEFAULT 'SAT'::bpchar,
    ativo_pelo_pesquisador character(1),
    ativo_pelo_adm character(1),
    dt_inicio date,
    dt_fim date,
    pessoa_id integer,
    dt_cadastro timestamp with time zone DEFAULT now(),
    ponto_sup_lat character varying(30),
    ponto_sup_lng character varying(30),
    ponto_inf_lat character varying(30),
    ponto_inf_lng character varying(30),
    precisao character varying(10),
    link character varying(50)
);


ALTER TABLE peoplegrid.questionarios OWNER TO postgres;

--
-- Name: questionarios_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE questionarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.questionarios_id_seq OWNER TO postgres;

--
-- Name: questionarios_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE questionarios_id_seq OWNED BY questionarios.id;


--
-- Name: renda_familiar; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE renda_familiar (
    id integer NOT NULL,
    descricao character varying(255),
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peoplegrid.renda_familiar OWNER TO postgres;

--
-- Name: renda_familiar_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE renda_familiar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.renda_familiar_id_seq OWNER TO postgres;

--
-- Name: renda_familiar_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE renda_familiar_id_seq OWNED BY renda_familiar.id;


--
-- Name: respostas; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE respostas (
    id integer NOT NULL,
    nivel_escolaridade_id integer,
    renda_familiar_id integer,
    dt_cadastro timestamp with time zone DEFAULT now(),
    pensou_como_id integer
);


ALTER TABLE peoplegrid.respostas OWNER TO postgres;

--
-- Name: respostas_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE respostas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.respostas_id_seq OWNER TO postgres;

--
-- Name: respostas_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE respostas_id_seq OWNED BY respostas.id;


--
-- Name: tipo_pergunta_dinamica; Type: TABLE; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE TABLE tipo_pergunta_dinamica (
    id integer NOT NULL,
    descricao character varying(45),
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peoplegrid.tipo_pergunta_dinamica OWNER TO postgres;

--
-- Name: tipo_pergunta_dinamica_id_seq; Type: SEQUENCE; Schema: peoplegrid; Owner: postgres
--

CREATE SEQUENCE tipo_pergunta_dinamica_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peoplegrid.tipo_pergunta_dinamica_id_seq OWNER TO postgres;

--
-- Name: tipo_pergunta_dinamica_id_seq; Type: SEQUENCE OWNED BY; Schema: peoplegrid; Owner: postgres
--

ALTER SEQUENCE tipo_pergunta_dinamica_id_seq OWNED BY tipo_pergunta_dinamica.id;


SET search_path = peopleplan, pg_catalog;

--
-- Name: nivel_escolaridade; Type: TABLE; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE TABLE nivel_escolaridade (
    id integer NOT NULL,
    descricao character(255),
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peopleplan.nivel_escolaridade OWNER TO postgres;

--
-- Name: nivel_escolaridade_id_seq; Type: SEQUENCE; Schema: peopleplan; Owner: postgres
--

CREATE SEQUENCE nivel_escolaridade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peopleplan.nivel_escolaridade_id_seq OWNER TO postgres;

--
-- Name: nivel_escolaridade_id_seq; Type: SEQUENCE OWNED BY; Schema: peopleplan; Owner: postgres
--

ALTER SEQUENCE nivel_escolaridade_id_seq OWNED BY nivel_escolaridade.id;


--
-- Name: pensou_como; Type: TABLE; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE TABLE pensou_como (
    id integer NOT NULL,
    descricao character varying(255),
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peopleplan.pensou_como OWNER TO postgres;

--
-- Name: pensou_como_id_seq; Type: SEQUENCE; Schema: peopleplan; Owner: postgres
--

CREATE SEQUENCE pensou_como_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peopleplan.pensou_como_id_seq OWNER TO postgres;

--
-- Name: pensou_como_id_seq; Type: SEQUENCE OWNED BY; Schema: peopleplan; Owner: postgres
--

ALTER SEQUENCE pensou_como_id_seq OWNED BY pensou_como.id;


--
-- Name: perguntas; Type: TABLE; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE TABLE perguntas (
    id integer NOT NULL,
    pessoa_id integer,
    descricao character varying(255),
    obrigatoria character(1) DEFAULT 'N'::bpchar,
    dt_cadastro timestamp with time zone DEFAULT now(),
    peso integer DEFAULT 5 NOT NULL
);


ALTER TABLE peopleplan.perguntas OWNER TO postgres;

--
-- Name: perguntas_id_seq; Type: SEQUENCE; Schema: peopleplan; Owner: postgres
--

CREATE SEQUENCE perguntas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peopleplan.perguntas_id_seq OWNER TO postgres;

--
-- Name: perguntas_id_seq; Type: SEQUENCE OWNED BY; Schema: peopleplan; Owner: postgres
--

ALTER SEQUENCE perguntas_id_seq OWNED BY perguntas.id;


--
-- Name: questionario_cores; Type: TABLE; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE TABLE questionario_cores (
    id integer NOT NULL,
    questionario_id integer NOT NULL,
    cor_1 character varying(6) DEFAULT '0592f7'::character varying NOT NULL,
    cor_2 character varying(6) DEFAULT '3787bf'::character varying NOT NULL,
    cor_3 character varying(6) DEFAULT '44779c'::character varying NOT NULL,
    cor_4 character varying(6) DEFAULT '43637a'::character varying NOT NULL,
    cor_5 character varying(6) DEFAULT '323c42'::character varying NOT NULL,
    cor_6 character varying(6) DEFAULT '020303'::character varying NOT NULL,
    cor_7 character varying(6) DEFAULT '403030'::character varying NOT NULL,
    cor_8 character varying(6) DEFAULT '613e3e'::character varying NOT NULL,
    cor_9 character varying(6) DEFAULT '9c2a2a'::character varying NOT NULL,
    cor_10 character varying(6) DEFAULT 'c91010'::character varying NOT NULL
);


ALTER TABLE peopleplan.questionario_cores OWNER TO postgres;

--
-- Name: questionario_cores_id_seq; Type: SEQUENCE; Schema: peopleplan; Owner: postgres
--

CREATE SEQUENCE questionario_cores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peopleplan.questionario_cores_id_seq OWNER TO postgres;

--
-- Name: questionario_cores_id_seq; Type: SEQUENCE OWNED BY; Schema: peopleplan; Owner: postgres
--

ALTER SEQUENCE questionario_cores_id_seq OWNED BY questionario_cores.id;


--
-- Name: questionario_perguntas_multicriterio; Type: TABLE; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE TABLE questionario_perguntas_multicriterio (
    id integer NOT NULL,
    pergunta_id integer,
    questionario_id integer,
    dt_cadastro timestamp with time zone DEFAULT now(),
    ordem integer
);


ALTER TABLE peopleplan.questionario_perguntas_multicriterio OWNER TO postgres;

--
-- Name: questionario_perguntas_multicriterio_id_seq; Type: SEQUENCE; Schema: peopleplan; Owner: postgres
--

CREATE SEQUENCE questionario_perguntas_multicriterio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peopleplan.questionario_perguntas_multicriterio_id_seq OWNER TO postgres;

--
-- Name: questionario_perguntas_multicriterio_id_seq; Type: SEQUENCE OWNED BY; Schema: peopleplan; Owner: postgres
--

ALTER SEQUENCE questionario_perguntas_multicriterio_id_seq OWNED BY questionario_perguntas_multicriterio.id;


--
-- Name: questionario_pesos_perguntas; Type: TABLE; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE TABLE questionario_pesos_perguntas (
    id integer NOT NULL,
    pergunta_id integer,
    peso integer DEFAULT 5 NOT NULL,
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peopleplan.questionario_pesos_perguntas OWNER TO postgres;

--
-- Name: questionario_pesos_perguntas_id_seq; Type: SEQUENCE; Schema: peopleplan; Owner: postgres
--

CREATE SEQUENCE questionario_pesos_perguntas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peopleplan.questionario_pesos_perguntas_id_seq OWNER TO postgres;

--
-- Name: questionario_pesos_perguntas_id_seq; Type: SEQUENCE OWNED BY; Schema: peopleplan; Owner: postgres
--

ALTER SEQUENCE questionario_pesos_perguntas_id_seq OWNED BY questionario_pesos_perguntas.id;


--
-- Name: questionarios; Type: TABLE; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE TABLE questionarios (
    id integer NOT NULL,
    descricao text,
    geo_lat character varying(30),
    geo_lon character varying(30),
    zoom integer,
    tipo_mapa character(3) DEFAULT 'SAT'::bpchar,
    ativo_pelo_pesquisador character(1),
    ativo_pelo_adm character(1),
    dt_inicio date,
    dt_fim date,
    pessoa_id integer,
    dt_cadastro timestamp with time zone DEFAULT now(),
    ponto_sup_lat character varying(30),
    ponto_sup_lng character varying(30),
    ponto_inf_lat character varying(30),
    ponto_inf_lng character varying(30),
    precisao character varying(10),
    link character varying(50)
);


ALTER TABLE peopleplan.questionarios OWNER TO postgres;

--
-- Name: questionarios_id_seq; Type: SEQUENCE; Schema: peopleplan; Owner: postgres
--

CREATE SEQUENCE questionarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peopleplan.questionarios_id_seq OWNER TO postgres;

--
-- Name: questionarios_id_seq; Type: SEQUENCE OWNED BY; Schema: peopleplan; Owner: postgres
--

ALTER SEQUENCE questionarios_id_seq OWNED BY questionarios.id;


--
-- Name: renda_familiar; Type: TABLE; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE TABLE renda_familiar (
    id integer NOT NULL,
    descricao character varying(255),
    dt_cadastro timestamp with time zone DEFAULT now()
);


ALTER TABLE peopleplan.renda_familiar OWNER TO postgres;

--
-- Name: renda_familiar_id_seq; Type: SEQUENCE; Schema: peopleplan; Owner: postgres
--

CREATE SEQUENCE renda_familiar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peopleplan.renda_familiar_id_seq OWNER TO postgres;

--
-- Name: renda_familiar_id_seq; Type: SEQUENCE OWNED BY; Schema: peopleplan; Owner: postgres
--

ALTER SEQUENCE renda_familiar_id_seq OWNED BY renda_familiar.id;


--
-- Name: respostas; Type: TABLE; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE TABLE respostas (
    id integer NOT NULL,
    nivel_escolaridade_id integer,
    renda_familiar_id integer,
    dt_cadastro timestamp with time zone DEFAULT now(),
    pensou_como_id integer
);


ALTER TABLE peopleplan.respostas OWNER TO postgres;

--
-- Name: respostas_id_seq; Type: SEQUENCE; Schema: peopleplan; Owner: postgres
--

CREATE SEQUENCE respostas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peopleplan.respostas_id_seq OWNER TO postgres;

--
-- Name: respostas_id_seq; Type: SEQUENCE OWNED BY; Schema: peopleplan; Owner: postgres
--

ALTER SEQUENCE respostas_id_seq OWNED BY respostas.id;


--
-- Name: respostas_multicriterio; Type: TABLE; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE TABLE respostas_multicriterio (
    id integer NOT NULL,
    questionario_pergunta_id integer,
    resposta_id integer,
    grid text,
    dt_cadastro timestamp with time zone DEFAULT now(),
    peso integer
);


ALTER TABLE peopleplan.respostas_multicriterio OWNER TO postgres;

--
-- Name: respostas_multicriterio_id_seq; Type: SEQUENCE; Schema: peopleplan; Owner: postgres
--

CREATE SEQUENCE respostas_multicriterio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE peopleplan.respostas_multicriterio_id_seq OWNER TO postgres;

--
-- Name: respostas_multicriterio_id_seq; Type: SEQUENCE OWNED BY; Schema: peopleplan; Owner: postgres
--

ALTER SEQUENCE respostas_multicriterio_id_seq OWNED BY respostas_multicriterio.id;


SET search_path = public, pg_catalog;

--
-- Name: ci_sessions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ci_sessions (
    session_id character varying(40) DEFAULT '0'::character varying NOT NULL,
    ip_address character varying(16) DEFAULT '0'::character varying,
    user_agent character varying(50) NOT NULL,
    last_activity integer DEFAULT 0 NOT NULL,
    user_data text
);


ALTER TABLE public.ci_sessions OWNER TO postgres;

--
-- Name: cidades; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cidades (
    id integer NOT NULL,
    unidade_federativa_id integer,
    nome character varying(255) DEFAULT NULL::character varying,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cidades OWNER TO postgres;

--
-- Name: cidades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cidades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cidades_id_seq OWNER TO postgres;

--
-- Name: cidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cidades_id_seq OWNED BY cidades.id;


--
-- Name: configuracao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE configuracao (
    id integer NOT NULL,
    nome_perfil character varying(255),
    email character varying(255),
    senha character varying(255),
    email_administrador character varying(255),
    dt_cadastro timestamp with time zone DEFAULT now(),
    email_administrador_2 character varying(255)
);


ALTER TABLE public.configuracao OWNER TO postgres;

--
-- Name: configuracao_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE configuracao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.configuracao_id_seq OWNER TO postgres;

--
-- Name: configuracao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE configuracao_id_seq OWNED BY configuracao.id;


--
-- Name: empresas; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE empresas (
    id integer NOT NULL,
    nome character varying(255) DEFAULT NULL::character varying,
    cnpj character varying(15) DEFAULT NULL::character varying,
    dt_cadastro date
);


ALTER TABLE public.empresas OWNER TO postgres;

--
-- Name: empresas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE empresas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.empresas_id_seq OWNER TO postgres;

--
-- Name: empresas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE empresas_id_seq OWNED BY empresas.id;


--
-- Name: empresas_perfis; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE empresas_perfis (
    empresa_id integer,
    perfil_id integer
);


ALTER TABLE public.empresas_perfis OWNER TO postgres;

--
-- Name: enderecos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE enderecos (
    id integer NOT NULL,
    pessoa_id integer,
    endereco_tipo_id integer,
    cidade_id integer,
    cep character varying(20) DEFAULT NULL::character varying,
    rua character varying(255) DEFAULT NULL::character varying,
    numero character varying(10) DEFAULT NULL::character varying,
    bairro character varying(255) DEFAULT NULL::character varying,
    complemento character varying(255) DEFAULT NULL::character varying,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.enderecos OWNER TO postgres;

--
-- Name: enderecos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE enderecos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enderecos_id_seq OWNER TO postgres;

--
-- Name: enderecos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE enderecos_id_seq OWNED BY enderecos.id;


--
-- Name: enderecos_tipos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE enderecos_tipos (
    id integer NOT NULL,
    descricao character varying(255) DEFAULT NULL::character varying,
    flg_tipo character varying(1) DEFAULT NULL::character varying,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.enderecos_tipos OWNER TO postgres;

--
-- Name: enderecos_tipos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE enderecos_tipos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enderecos_tipos_id_seq OWNER TO postgres;

--
-- Name: enderecos_tipos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE enderecos_tipos_id_seq OWNED BY enderecos_tipos.id;


--
-- Name: estados_civis; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE estados_civis (
    id integer NOT NULL,
    descricao character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.estados_civis OWNER TO postgres;

--
-- Name: estados_civis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE estados_civis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.estados_civis_id_seq OWNER TO postgres;

--
-- Name: estados_civis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE estados_civis_id_seq OWNED BY estados_civis.id;


--
-- Name: grupos_acessos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grupos_acessos (
    id integer NOT NULL,
    nome character varying(255) DEFAULT NULL::character varying,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.grupos_acessos OWNER TO postgres;

--
-- Name: grupos_acessos_empresas; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grupos_acessos_empresas (
    id integer NOT NULL,
    grupo_acesso_id integer,
    empresa_id integer
);


ALTER TABLE public.grupos_acessos_empresas OWNER TO postgres;

--
-- Name: grupos_acessos_empresas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE grupos_acessos_empresas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grupos_acessos_empresas_id_seq OWNER TO postgres;

--
-- Name: grupos_acessos_empresas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE grupos_acessos_empresas_id_seq OWNED BY grupos_acessos_empresas.id;


--
-- Name: grupos_acessos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE grupos_acessos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grupos_acessos_id_seq OWNER TO postgres;

--
-- Name: grupos_acessos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE grupos_acessos_id_seq OWNED BY grupos_acessos.id;


--
-- Name: grupos_acessos_perfis; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grupos_acessos_perfis (
    id integer NOT NULL,
    grupo_acesso_id integer,
    empresa_id integer,
    perfil_id integer
);


ALTER TABLE public.grupos_acessos_perfis OWNER TO postgres;

--
-- Name: grupos_acessos_perfis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE grupos_acessos_perfis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grupos_acessos_perfis_id_seq OWNER TO postgres;

--
-- Name: grupos_acessos_perfis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE grupos_acessos_perfis_id_seq OWNED BY grupos_acessos_perfis.id;


--
-- Name: grupos_acessos_programas; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grupos_acessos_programas (
    id integer NOT NULL,
    grupo_acesso_id integer,
    empresa_id integer,
    perfil_id integer,
    programa_id integer,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.grupos_acessos_programas OWNER TO postgres;

--
-- Name: grupos_acessos_programas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE grupos_acessos_programas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grupos_acessos_programas_id_seq OWNER TO postgres;

--
-- Name: grupos_acessos_programas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE grupos_acessos_programas_id_seq OWNED BY grupos_acessos_programas.id;


--
-- Name: grupos_acessos_programas_permissoes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grupos_acessos_programas_permissoes (
    id integer NOT NULL,
    grupo_acesso_id integer,
    sys_metodo_id integer,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.grupos_acessos_programas_permissoes OWNER TO postgres;

--
-- Name: grupos_acessos_programas_permissoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE grupos_acessos_programas_permissoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grupos_acessos_programas_permissoes_id_seq OWNER TO postgres;

--
-- Name: grupos_acessos_programas_permissoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE grupos_acessos_programas_permissoes_id_seq OWNED BY grupos_acessos_programas_permissoes.id;


--
-- Name: log_fields; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE log_fields (
    id integer NOT NULL,
    log_table_id integer,
    field_name character varying(255) DEFAULT NULL::character varying,
    old_value text,
    new_value text
);


ALTER TABLE public.log_fields OWNER TO postgres;

--
-- Name: log_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE log_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_fields_id_seq OWNER TO postgres;

--
-- Name: log_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE log_fields_id_seq OWNED BY log_fields.id;


--
-- Name: log_fields_structures; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE log_fields_structures (
    id integer NOT NULL,
    log_table_structure_id integer,
    field_name character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.log_fields_structures OWNER TO postgres;

--
-- Name: log_fields_structures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE log_fields_structures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_fields_structures_id_seq OWNER TO postgres;

--
-- Name: log_fields_structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE log_fields_structures_id_seq OWNED BY log_fields_structures.id;


--
-- Name: log_tables; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE log_tables (
    id integer NOT NULL,
    table_name character varying(255) DEFAULT NULL::character varying,
    table_id integer,
    flg_action character varying(10) DEFAULT NULL::character varying,
    dt_register timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.log_tables OWNER TO postgres;

--
-- Name: log_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE log_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_tables_id_seq OWNER TO postgres;

--
-- Name: log_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE log_tables_id_seq OWNED BY log_tables.id;


--
-- Name: log_tables_structures; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE log_tables_structures (
    id integer NOT NULL,
    table_name character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.log_tables_structures OWNER TO postgres;

--
-- Name: log_tables_structures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE log_tables_structures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_tables_structures_id_seq OWNER TO postgres;

--
-- Name: log_tables_structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE log_tables_structures_id_seq OWNED BY log_tables_structures.id;


--
-- Name: parametros; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE parametros (
    id integer NOT NULL,
    nome character varying(255) DEFAULT NULL::character varying,
    descricao character varying(255) DEFAULT NULL::character varying,
    valor character varying(255) DEFAULT NULL::character varying,
    dt_cadastro date
);


ALTER TABLE public.parametros OWNER TO postgres;

--
-- Name: parametros_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE parametros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parametros_id_seq OWNER TO postgres;

--
-- Name: parametros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE parametros_id_seq OWNED BY parametros.id;


--
-- Name: perfis; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE perfis (
    id integer NOT NULL,
    nome_perfil character varying(255) NOT NULL,
    flg_ativo character varying(1) DEFAULT 'S'::character varying,
    dt_cadastro date
);


ALTER TABLE public.perfis OWNER TO postgres;

--
-- Name: perfis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE perfis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.perfis_id_seq OWNER TO postgres;

--
-- Name: perfis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE perfis_id_seq OWNED BY perfis.id;


--
-- Name: perfis_programas; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE perfis_programas (
    id integer NOT NULL,
    perfil_id integer,
    programa_id integer,
    programa_pai integer,
    ordem integer,
    flg_ativo character varying(1) DEFAULT NULL::character varying
);


ALTER TABLE public.perfis_programas OWNER TO postgres;

--
-- Name: perfis_programas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE perfis_programas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.perfis_programas_id_seq OWNER TO postgres;

--
-- Name: perfis_programas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE perfis_programas_id_seq OWNED BY perfis_programas.id;


--
-- Name: pessoas; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pessoas (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    cpf character varying(15) DEFAULT NULL::character varying,
    rg character varying(15) DEFAULT NULL::character varying,
    estado_civil_id integer,
    sexo character varying(1) DEFAULT NULL::character varying,
    dt_nascimento date,
    nome_pai character varying(255) DEFAULT NULL::character varying,
    nome_mae character varying(255) DEFAULT NULL::character varying,
    telefone character varying(25) DEFAULT NULL::character varying,
    celular character varying(25) DEFAULT NULL::character varying,
    email character varying(255) DEFAULT NULL::character varying,
    observacao text,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL,
    orgao_emissor_rg character varying(10) DEFAULT NULL::character varying,
    orgao_emissor_rg_unidade_federativa_id integer,
    flg_mao_escrita character varying(1) DEFAULT 'D'::character varying,
    nacionalidade character varying(255) DEFAULT NULL::character varying,
    dt_atualizacao_gol date,
    nr_titulo_eleitor character varying(15) DEFAULT NULL::character varying,
    hash_ativacao character varying(255) DEFAULT NULL::character varying,
    email_ativacao character varying(255) DEFAULT NULL::character varying,
    senha_ativacao text,
    foto_carteira_id integer,
    cod_carteira integer,
    pessoa_tipo_id integer,
    nome_consulta character varying(255)
);


ALTER TABLE public.pessoas OWNER TO postgres;

--
-- Name: pessoas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pessoas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pessoas_id_seq OWNER TO postgres;

--
-- Name: pessoas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pessoas_id_seq OWNED BY pessoas.id;


--
-- Name: pessoas_tipos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pessoas_tipos (
    id integer NOT NULL,
    tipo character varying(50) DEFAULT NULL::character varying,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pessoas_tipos OWNER TO postgres;

--
-- Name: pessoas_tipos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pessoas_tipos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pessoas_tipos_id_seq OWNER TO postgres;

--
-- Name: pessoas_tipos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pessoas_tipos_id_seq OWNED BY pessoas_tipos.id;


--
-- Name: programas; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE programas (
    id integer NOT NULL,
    nome_programa character varying(255) DEFAULT NULL::character varying,
    descricao character varying(255) DEFAULT NULL::character varying,
    link character varying(255) DEFAULT NULL::character varying,
    onclick character varying(255) DEFAULT NULL::character varying,
    dt_cadastro date
);


ALTER TABLE public.programas OWNER TO postgres;

--
-- Name: programas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE programas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.programas_id_seq OWNER TO postgres;

--
-- Name: programas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE programas_id_seq OWNED BY programas.id;


--
-- Name: programas_parametros; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE programas_parametros (
    id integer NOT NULL,
    programa_id integer,
    nome character varying(255) DEFAULT NULL::character varying,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.programas_parametros OWNER TO postgres;

--
-- Name: programas_parametros_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE programas_parametros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.programas_parametros_id_seq OWNER TO postgres;

--
-- Name: programas_parametros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE programas_parametros_id_seq OWNED BY programas_parametros.id;


--
-- Name: sys_metodos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sys_metodos (
    id integer NOT NULL,
    classe character varying(255) DEFAULT NULL::character varying,
    metodo character varying(255) DEFAULT NULL::character varying,
    apelido character varying(255) DEFAULT NULL::character varying,
    privado integer,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sys_metodos OWNER TO postgres;

--
-- Name: sys_metodos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sys_metodos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sys_metodos_id_seq OWNER TO postgres;

--
-- Name: sys_metodos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sys_metodos_id_seq OWNED BY sys_metodos.id;


--
-- Name: sys_permissoes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sys_permissoes (
    id integer NOT NULL,
    sys_metodo_id integer,
    usuario_id integer,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sys_permissoes OWNER TO postgres;

--
-- Name: sys_permissoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sys_permissoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sys_permissoes_id_seq OWNER TO postgres;

--
-- Name: sys_permissoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sys_permissoes_id_seq OWNED BY sys_permissoes.id;


--
-- Name: telefones; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE telefones (
    id integer NOT NULL,
    pessoa_id integer NOT NULL,
    telefone_tipo_id integer NOT NULL,
    numero character varying(14) DEFAULT NULL::character varying,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.telefones OWNER TO postgres;

--
-- Name: telefones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE telefones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.telefones_id_seq OWNER TO postgres;

--
-- Name: telefones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE telefones_id_seq OWNED BY telefones.id;


--
-- Name: telefones_tipos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE telefones_tipos (
    id integer NOT NULL,
    descricao character varying(255) DEFAULT NULL::character varying,
    flg_tipo character varying(1) DEFAULT NULL::character varying,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.telefones_tipos OWNER TO postgres;

--
-- Name: telefones_tipos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE telefones_tipos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.telefones_tipos_id_seq OWNER TO postgres;

--
-- Name: telefones_tipos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE telefones_tipos_id_seq OWNED BY telefones_tipos.id;


--
-- Name: tipo_enderecos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tipo_enderecos (
    id integer NOT NULL,
    nome character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.tipo_enderecos OWNER TO postgres;

--
-- Name: tipo_enderecos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tipo_enderecos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_enderecos_id_seq OWNER TO postgres;

--
-- Name: tipo_enderecos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tipo_enderecos_id_seq OWNED BY tipo_enderecos.id;


--
-- Name: unidades_federativas; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE unidades_federativas (
    id integer NOT NULL,
    sigla character varying(2) DEFAULT NULL::character varying,
    nome character varying(255) DEFAULT NULL::character varying,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.unidades_federativas OWNER TO postgres;

--
-- Name: unidades_federativas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE unidades_federativas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unidades_federativas_id_seq OWNER TO postgres;

--
-- Name: unidades_federativas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE unidades_federativas_id_seq OWNED BY unidades_federativas.id;


--
-- Name: uploads; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE uploads (
    id integer NOT NULL,
    nome_gerado character varying(255) DEFAULT NULL::character varying,
    nome_original character varying(255) DEFAULT NULL::character varying,
    tamanho character varying(10) DEFAULT NULL::character varying,
    tipo character varying(255) DEFAULT NULL::character varying,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.uploads OWNER TO postgres;

--
-- Name: uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uploads_id_seq OWNER TO postgres;

--
-- Name: uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE uploads_id_seq OWNED BY uploads.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuarios (
    id integer NOT NULL,
    pessoa_id integer NOT NULL,
    login character varying(255) NOT NULL,
    senha text,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL,
    hash_id character varying(255) DEFAULT NULL::character varying,
    avatar_id integer,
    tema character varying(45) DEFAULT 'redmond'::character varying
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_empresas; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuarios_empresas (
    usuario_id integer NOT NULL,
    empresa_id integer NOT NULL,
    empresa_boot character varying(1) DEFAULT NULL::character varying
);


ALTER TABLE public.usuarios_empresas OWNER TO postgres;

--
-- Name: usuarios_grupos_acessos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuarios_grupos_acessos (
    id integer NOT NULL,
    usuario_id integer,
    grupo_acesso_id integer,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.usuarios_grupos_acessos OWNER TO postgres;

--
-- Name: usuarios_grupos_acessos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE usuarios_grupos_acessos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuarios_grupos_acessos_id_seq OWNER TO postgres;

--
-- Name: usuarios_grupos_acessos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usuarios_grupos_acessos_id_seq OWNED BY usuarios_grupos_acessos.id;


--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usuarios_id_seq OWNED BY usuarios.id;


--
-- Name: usuarios_perfis; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuarios_perfis (
    empresa_id integer,
    usuario_id integer,
    perfil_id integer
);


ALTER TABLE public.usuarios_perfis OWNER TO postgres;

--
-- Name: usuarios_programas_acessos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuarios_programas_acessos (
    id integer NOT NULL,
    usuario_id integer,
    empresa_id integer,
    perfil_id integer,
    programa_id integer,
    dt_cadastro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.usuarios_programas_acessos OWNER TO postgres;

--
-- Name: usuarios_programas_acessos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE usuarios_programas_acessos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuarios_programas_acessos_id_seq OWNER TO postgres;

--
-- Name: usuarios_programas_acessos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usuarios_programas_acessos_id_seq OWNED BY usuarios_programas_acessos.id;


SET search_path = peoplegrid, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY dinamica_respostas ALTER COLUMN id SET DEFAULT nextval('dinamica_respostas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY grid_respostas ALTER COLUMN id SET DEFAULT nextval('grid_respostas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY nivel_escolaridade ALTER COLUMN id SET DEFAULT nextval('nivel_escolaridade_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY pensou_como ALTER COLUMN id SET DEFAULT nextval('pensou_como_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY perguntas_dinamica ALTER COLUMN id SET DEFAULT nextval('perguntas_dinamica_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY perguntas_grid ALTER COLUMN id SET DEFAULT nextval('perguntas_grid_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY questionario_cores ALTER COLUMN id SET DEFAULT nextval('questionario_cores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY questionario_perguntas_dinamica ALTER COLUMN id SET DEFAULT nextval('perguntas_questionario_dinamicas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY questionario_perguntas_grid ALTER COLUMN id SET DEFAULT nextval('questionario_perguntas_grid_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY questionarios ALTER COLUMN id SET DEFAULT nextval('questionarios_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY renda_familiar ALTER COLUMN id SET DEFAULT nextval('renda_familiar_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY respostas ALTER COLUMN id SET DEFAULT nextval('respostas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY tipo_pergunta_dinamica ALTER COLUMN id SET DEFAULT nextval('tipo_pergunta_dinamica_id_seq'::regclass);


SET search_path = peopleplan, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY nivel_escolaridade ALTER COLUMN id SET DEFAULT nextval('nivel_escolaridade_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY pensou_como ALTER COLUMN id SET DEFAULT nextval('pensou_como_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY perguntas ALTER COLUMN id SET DEFAULT nextval('perguntas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY questionario_cores ALTER COLUMN id SET DEFAULT nextval('questionario_cores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY questionario_perguntas_multicriterio ALTER COLUMN id SET DEFAULT nextval('questionario_perguntas_multicriterio_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY questionario_pesos_perguntas ALTER COLUMN id SET DEFAULT nextval('questionario_pesos_perguntas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY questionarios ALTER COLUMN id SET DEFAULT nextval('questionarios_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY renda_familiar ALTER COLUMN id SET DEFAULT nextval('renda_familiar_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY respostas ALTER COLUMN id SET DEFAULT nextval('respostas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY respostas_multicriterio ALTER COLUMN id SET DEFAULT nextval('respostas_multicriterio_id_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cidades ALTER COLUMN id SET DEFAULT nextval('cidades_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY empresas ALTER COLUMN id SET DEFAULT nextval('empresas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enderecos ALTER COLUMN id SET DEFAULT nextval('enderecos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enderecos_tipos ALTER COLUMN id SET DEFAULT nextval('enderecos_tipos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY estados_civis ALTER COLUMN id SET DEFAULT nextval('estados_civis_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos ALTER COLUMN id SET DEFAULT nextval('grupos_acessos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_empresas ALTER COLUMN id SET DEFAULT nextval('grupos_acessos_empresas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_perfis ALTER COLUMN id SET DEFAULT nextval('grupos_acessos_perfis_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_programas ALTER COLUMN id SET DEFAULT nextval('grupos_acessos_programas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_programas_permissoes ALTER COLUMN id SET DEFAULT nextval('grupos_acessos_programas_permissoes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY log_fields ALTER COLUMN id SET DEFAULT nextval('log_fields_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY log_fields_structures ALTER COLUMN id SET DEFAULT nextval('log_fields_structures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY log_tables ALTER COLUMN id SET DEFAULT nextval('log_tables_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY log_tables_structures ALTER COLUMN id SET DEFAULT nextval('log_tables_structures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY parametros ALTER COLUMN id SET DEFAULT nextval('parametros_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY perfis ALTER COLUMN id SET DEFAULT nextval('perfis_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY perfis_programas ALTER COLUMN id SET DEFAULT nextval('perfis_programas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pessoas ALTER COLUMN id SET DEFAULT nextval('pessoas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pessoas_tipos ALTER COLUMN id SET DEFAULT nextval('pessoas_tipos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY programas ALTER COLUMN id SET DEFAULT nextval('programas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY programas_parametros ALTER COLUMN id SET DEFAULT nextval('programas_parametros_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sys_metodos ALTER COLUMN id SET DEFAULT nextval('sys_metodos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sys_permissoes ALTER COLUMN id SET DEFAULT nextval('sys_permissoes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY telefones ALTER COLUMN id SET DEFAULT nextval('telefones_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY telefones_tipos ALTER COLUMN id SET DEFAULT nextval('telefones_tipos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_enderecos ALTER COLUMN id SET DEFAULT nextval('tipo_enderecos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unidades_federativas ALTER COLUMN id SET DEFAULT nextval('unidades_federativas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY uploads ALTER COLUMN id SET DEFAULT nextval('uploads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios ALTER COLUMN id SET DEFAULT nextval('usuarios_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_grupos_acessos ALTER COLUMN id SET DEFAULT nextval('usuarios_grupos_acessos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_programas_acessos ALTER COLUMN id SET DEFAULT nextval('usuarios_programas_acessos_id_seq'::regclass);


SET search_path = peoplegrid, pg_catalog;

--
-- Data for Name: dinamica_respostas; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY dinamica_respostas (id, pergunta_questionario_dinamica_id, resposta_id, resposta_dinamica, dt_cadastro) FROM stdin;
\.


--
-- Name: dinamica_respostas_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('dinamica_respostas_id_seq', 1, false);


--
-- Data for Name: grid_respostas; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY grid_respostas (id, questionario_pergunta_grid_id, resposta_id, grid, dt_cadastro) FROM stdin;
\.


--
-- Name: grid_respostas_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('grid_respostas_id_seq', 178, true);


--
-- Data for Name: nivel_escolaridade; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY nivel_escolaridade (id, descricao, dt_cadastro) FROM stdin;
2	Ensino Fundamental                                                                                                                                                                                                                                             	2014-09-29 14:27:53.13762-03
3	Ensino Médio                                                                                                                                                                                                                                                   	2014-09-29 14:28:02.099009-03
4	Ensino Superior                                                                                                                                                                                                                                                	2014-09-29 14:28:10.310674-03
5	Pós Graduação                                                                                                                                                                                                                                                  	2014-09-29 14:28:17.880693-03
1	Nulo                                                                                                                                                                                                                                                           	2014-09-18 13:07:44.738445-03
\.


--
-- Name: nivel_escolaridade_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('nivel_escolaridade_id_seq', 1, true);


--
-- Data for Name: pensou_como; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY pensou_como (id, descricao, dt_cadastro) FROM stdin;
1	Nulo	2014-09-18 13:26:29.211457-03
2	Representante da população	2014-09-29 17:47:33.046956-03
3	Um líder comunitário e/ou ativista	2014-09-29 17:49:52.376159-03
4	Representante politico e/ou gestor	2014-09-29 17:49:54.513321-03
5	Um técnico municipal e/ou planejador urbano	2014-09-29 17:50:12.692161-03
6	Um investigador e/ou empresário	2014-09-29 17:50:34.358271-03
7	Outro	2014-09-29 17:50:52.807149-03
\.


--
-- Name: pensou_como_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('pensou_como_id_seq', 2, true);


--
-- Data for Name: perguntas_dinamica; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY perguntas_dinamica (id, descricao, obrigatoria, tipo_pergunta_dinamica_id, pessoa_id, dt_cadastro) FROM stdin;
\.


--
-- Name: perguntas_dinamica_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('perguntas_dinamica_id_seq', 1, false);


--
-- Data for Name: perguntas_grid; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY perguntas_grid (id, pessoa_id, descricao, obrigatoria, dt_cadastro) FROM stdin;
64	1	Pontos de transporte público?	S	2016-11-08 22:41:48.164895-02
63	1	Pontos de maior segurança?	S	2016-11-08 22:41:18.942798-02
\.


--
-- Name: perguntas_grid_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('perguntas_grid_id_seq', 67, true);


--
-- Name: perguntas_questionario_dinamicas_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('perguntas_questionario_dinamicas_id_seq', 1, false);


--
-- Data for Name: questionario_cores; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY questionario_cores (id, questionario_id, cor_1, cor_2, cor_3, cor_4, cor_5, cor_6, cor_7, cor_8, cor_9, cor_10) FROM stdin;
9	75	2C7BB6	64A4CC	9CCEE3	C7E5DB	ECF6C8	FEEDAA	FDC980	F89D59	E75B35	D7191C
10	76	2C7BB6	64A4CC	9CCEE3	C7E5DB	ECF6C8	FEEDAA	FDC980	F89D59	E75B35	D7191C
\.


--
-- Name: questionario_cores_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('questionario_cores_id_seq', 13, true);


--
-- Data for Name: questionario_perguntas_dinamica; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY questionario_perguntas_dinamica (id, questionario_id, pergunta_dinamica_id, dt_cadastro) FROM stdin;
\.


--
-- Data for Name: questionario_perguntas_grid; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY questionario_perguntas_grid (id, pergunta_grid_id, questionario_id, dt_cadastro, ordem) FROM stdin;
552	63	76	2016-11-08 22:43:28.022358-02	1
553	64	76	2016-11-08 22:43:28.049786-02	2
\.


--
-- Name: questionario_perguntas_grid_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('questionario_perguntas_grid_id_seq', 556, true);


--
-- Data for Name: questionarios; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY questionarios (id, descricao, geo_lat, geo_lon, zoom, tipo_mapa, ativo_pelo_pesquisador, ativo_pelo_adm, dt_inicio, dt_fim, pessoa_id, dt_cadastro, ponto_sup_lat, ponto_sup_lng, ponto_inf_lat, ponto_inf_lng, precisao, link) FROM stdin;
75	Teste	\N	\N	\N	SAT	N	S	2015-04-01	2015-05-01	5	2015-04-30 08:14:15.3198-03	\N	\N	\N	\N	\N	00a5006d
76	Novo Campus UFPel	-31.747578731227637	-52.32838670702267	12	SAT	S	S	2016-11-08	2016-12-14	1	2016-11-08 22:42:49.43208-02	-31.707499454167543	-52.39361803026486	-31.77239140210006	-52.303623828604714	295	00a6006e
\.


--
-- Name: questionarios_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('questionarios_id_seq', 79, true);


--
-- Data for Name: renda_familiar; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY renda_familiar (id, descricao, dt_cadastro) FROM stdin;
1	Nulo	2014-09-18 13:07:44.738445-03
5	Mais de 9 salários mínimos	2014-09-29 17:52:51.328855-03
2	0 a 3 salários mínimos	2014-09-29 17:51:53.741291-03
3	3 a 6 salários mínimos	2014-09-29 17:52:19.26152-03
4	6 a 9 salários mínimos	2014-09-29 17:52:35.415747-03
\.


--
-- Name: renda_familiar_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('renda_familiar_id_seq', 1, true);


--
-- Data for Name: respostas; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY respostas (id, nivel_escolaridade_id, renda_familiar_id, dt_cadastro, pensou_como_id) FROM stdin;
\.


--
-- Name: respostas_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('respostas_id_seq', 100, true);


--
-- Data for Name: tipo_pergunta_dinamica; Type: TABLE DATA; Schema: peoplegrid; Owner: postgres
--

COPY tipo_pergunta_dinamica (id, descricao, dt_cadastro) FROM stdin;
\.


--
-- Name: tipo_pergunta_dinamica_id_seq; Type: SEQUENCE SET; Schema: peoplegrid; Owner: postgres
--

SELECT pg_catalog.setval('tipo_pergunta_dinamica_id_seq', 1, false);


SET search_path = peopleplan, pg_catalog;

--
-- Data for Name: nivel_escolaridade; Type: TABLE DATA; Schema: peopleplan; Owner: postgres
--

COPY nivel_escolaridade (id, descricao, dt_cadastro) FROM stdin;
1	Nulo                                                                                                                                                                                                                                                           	2016-12-12 15:18:44.97868-02
2	Ensino Fundamental                                                                                                                                                                                                                                             	2016-12-12 15:18:59.839412-02
3	Ensino Médio                                                                                                                                                                                                                                                   	2016-12-12 15:19:07.101071-02
4	Ensino Superior                                                                                                                                                                                                                                                	2016-12-12 15:19:09.821879-02
5	Pós Graduação                                                                                                                                                                                                                                                  	2016-12-12 15:19:23.490881-02
\.


--
-- Name: nivel_escolaridade_id_seq; Type: SEQUENCE SET; Schema: peopleplan; Owner: postgres
--

SELECT pg_catalog.setval('nivel_escolaridade_id_seq', 1, true);


--
-- Data for Name: pensou_como; Type: TABLE DATA; Schema: peopleplan; Owner: postgres
--

COPY pensou_como (id, descricao, dt_cadastro) FROM stdin;
1	Nulo	2016-12-12 15:20:50.295048-02
7	Outro	2016-12-12 15:21:11.610019-02
6	Um investigador e/ou empresário	2016-12-12 15:21:09.084084-02
2	Representante da população	2016-12-12 15:20:54.207046-02
3	Um líder comunitário e/ou ativista	2016-12-12 15:20:56.140703-02
4	Representante político e/ou gestor	2016-12-12 15:20:59.324472-02
5	Um técnico municipal e/ou planejador urbano	2016-12-12 15:21:06.466928-02
\.


--
-- Name: pensou_como_id_seq; Type: SEQUENCE SET; Schema: peopleplan; Owner: postgres
--

SELECT pg_catalog.setval('pensou_como_id_seq', 1, false);


--
-- Data for Name: perguntas; Type: TABLE DATA; Schema: peopleplan; Owner: postgres
--

COPY perguntas (id, pessoa_id, descricao, obrigatoria, dt_cadastro, peso) FROM stdin;
31	1	Bibliotecas próximas?	S	2016-12-21 22:14:06.880235-02	5
32	1	Rodoviárias próximas?	S	2016-12-21 22:17:47.515623-02	5
33	1	Pontos de táxi?	S	2016-12-22 19:31:01.244167-02	5
\.


--
-- Name: perguntas_id_seq; Type: SEQUENCE SET; Schema: peopleplan; Owner: postgres
--

SELECT pg_catalog.setval('perguntas_id_seq', 33, true);


--
-- Data for Name: questionario_cores; Type: TABLE DATA; Schema: peopleplan; Owner: postgres
--

COPY questionario_cores (id, questionario_id, cor_1, cor_2, cor_3, cor_4, cor_5, cor_6, cor_7, cor_8, cor_9, cor_10) FROM stdin;
38	38	2C7BB6	64A4CC	9CCEE3	C7E5DB	ECF6C8	FEEDAA	FDC980	F89D59	E75B35	D7191C
39	39	2C7BB6	64A4CC	9CCEE3	C7E5DB	ECF6C8	FEEDAA	FDC980	F89D59	E75B35	D7191C
40	40	2C7BB6	64A4CC	9CCEE3	C7E5DB	ECF6C8	FEEDAA	FDC980	F89D59	E75B35	D7191C
\.


--
-- Name: questionario_cores_id_seq; Type: SEQUENCE SET; Schema: peopleplan; Owner: postgres
--

SELECT pg_catalog.setval('questionario_cores_id_seq', 40, true);


--
-- Data for Name: questionario_perguntas_multicriterio; Type: TABLE DATA; Schema: peopleplan; Owner: postgres
--

COPY questionario_perguntas_multicriterio (id, pergunta_id, questionario_id, dt_cadastro, ordem) FROM stdin;
75	31	38	2016-12-22 19:31:20.361405-02	1
76	32	38	2016-12-22 19:31:20.371032-02	2
77	33	38	2016-12-22 19:31:20.382105-02	3
78	31	39	2017-01-11 17:22:23.498436-02	1
79	32	39	2017-01-11 17:22:23.581597-02	2
80	33	39	2017-01-11 17:22:23.592684-02	3
\.


--
-- Name: questionario_perguntas_multicriterio_id_seq; Type: SEQUENCE SET; Schema: peopleplan; Owner: postgres
--

SELECT pg_catalog.setval('questionario_perguntas_multicriterio_id_seq', 80, true);


--
-- Data for Name: questionario_pesos_perguntas; Type: TABLE DATA; Schema: peopleplan; Owner: postgres
--

COPY questionario_pesos_perguntas (id, pergunta_id, peso, dt_cadastro) FROM stdin;
\.


--
-- Name: questionario_pesos_perguntas_id_seq; Type: SEQUENCE SET; Schema: peopleplan; Owner: postgres
--

SELECT pg_catalog.setval('questionario_pesos_perguntas_id_seq', 3, true);


--
-- Data for Name: questionarios; Type: TABLE DATA; Schema: peopleplan; Owner: postgres
--

COPY questionarios (id, descricao, geo_lat, geo_lon, zoom, tipo_mapa, ativo_pelo_pesquisador, ativo_pelo_adm, dt_inicio, dt_fim, pessoa_id, dt_cadastro, ponto_sup_lat, ponto_sup_lng, ponto_inf_lat, ponto_inf_lng, precisao, link) FROM stdin;
38	Test	-31.747578731227637	-52.32838670702267	12	SAT	S	S	2016-12-22	2016-12-29	1	2016-12-22 17:17:22.777295-02	-31.737578731227636	-52.35997240038205	-31.76655372507986	-52.31838670702268	325	00a0006c
39	Testando	-31.747578731227637	-52.32838670702267	14	SAT	S	S	2016-12-23	2017-01-31	1	2016-12-23 11:03:11.221472-02	-31.737578731227636	-52.33722726793576	-31.75604497829483	-52.31838670702268	140	00a1006d
40	Teste	-31.747578731227637	-52.32838670702267	12	SAT	N	S	2017-01-11	2017-01-31	1	2017-01-11 17:27:35.640692-02	-31.737578731227636	-52.3791984746008	-31.775893831501637	-52.31838670702268	375	009a0065
\.


--
-- Name: questionarios_id_seq; Type: SEQUENCE SET; Schema: peopleplan; Owner: postgres
--

SELECT pg_catalog.setval('questionarios_id_seq', 40, true);


--
-- Data for Name: renda_familiar; Type: TABLE DATA; Schema: peopleplan; Owner: postgres
--

COPY renda_familiar (id, descricao, dt_cadastro) FROM stdin;
1	Nulo	2016-12-12 15:23:40.49654-02
2	0 a 3 salários mínimos	2016-12-12 15:23:53.211107-02
3	3 a 6 salários mínimos	2016-12-12 15:24:03.65287-02
4	6 a 9 salários mínimos	2016-12-12 15:24:13.720986-02
5	Mais de 9 salários mínimos	2016-12-12 15:24:24.048077-02
\.


--
-- Name: renda_familiar_id_seq; Type: SEQUENCE SET; Schema: peopleplan; Owner: postgres
--

SELECT pg_catalog.setval('renda_familiar_id_seq', 1, false);


--
-- Data for Name: respostas; Type: TABLE DATA; Schema: peopleplan; Owner: postgres
--

COPY respostas (id, nivel_escolaridade_id, renda_familiar_id, dt_cadastro, pensou_como_id) FROM stdin;
10	2	2	2016-12-22 19:33:51.654449-02	7
11	2	2	2017-01-11 17:25:22.309825-02	7
\.


--
-- Name: respostas_id_seq; Type: SEQUENCE SET; Schema: peopleplan; Owner: postgres
--

SELECT pg_catalog.setval('respostas_id_seq', 11, true);


--
-- Data for Name: respostas_multicriterio; Type: TABLE DATA; Schema: peopleplan; Owner: postgres
--

COPY respostas_multicriterio (id, questionario_pergunta_id, resposta_id, grid, dt_cadastro, peso) FROM stdin;
21	75	10	[]	2016-12-22 19:33:51.684217-02	\N
22	76	10	[]	2016-12-22 19:33:51.694205-02	\N
23	77	10	[]	2016-12-22 19:33:51.705332-02	\N
24	77	10	[]	2016-12-22 19:33:51.716302-02	\N
25	78	11	[{"idCelula":0,"cor":"#ffff00","pontoSupEsq":{"lat":-31.738836372625,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.73757872269,"lng":-52.337227267936}},{"idCelula":2,"cor":"#ff0000","pontoSupEsq":{"lat":-31.73883635555,"lng":-52.33279096721},"pontoInfDir":{"lat":-31.737578705616,"lng":-52.334269693965}},{"idCelula":4,"cor":"#ff0000","pontoSupEsq":{"lat":-31.738836338475,"lng":-52.329833433394},"pontoInfDir":{"lat":-31.737578688542,"lng":-52.331312119994}},{"idCelula":5,"cor":"#ff0000","pontoSupEsq":{"lat":-31.738836329937,"lng":-52.328354666486},"pontoInfDir":{"lat":-31.737578680005,"lng":-52.329833333009}},{"idCelula":6,"cor":"#ffff00","pontoSupEsq":{"lat":-31.7388363214,"lng":-52.326875899578},"pontoInfDir":{"lat":-31.737578671467,"lng":-52.328354546024}},{"idCelula":8,"cor":"#ffa500","pontoSupEsq":{"lat":-31.738836304325,"lng":-52.323918365763},"pontoInfDir":{"lat":-31.737578654393,"lng":-52.325396972054}},{"idCelula":9,"cor":"#ffff00","pontoSupEsq":{"lat":-31.738836295787,"lng":-52.322439598855},"pontoInfDir":{"lat":-31.737578645856,"lng":-52.323918185069}},{"idCelula":10,"cor":"#ffff00","pontoSupEsq":{"lat":-31.738836287249,"lng":-52.320960831948},"pontoInfDir":{"lat":-31.737578637319,"lng":-52.322439398085}},{"idCelula":11,"cor":"#ffa500","pontoSupEsq":{"lat":-31.738836278712,"lng":-52.319482065041},"pontoInfDir":{"lat":-31.737578628782,"lng":-52.3209606111}},{"idCelula":13,"cor":"#ff0000","pontoSupEsq":{"lat":-31.740094005485,"lng":-52.334269714042},"pontoInfDir":{"lat":-31.738836355551,"lng":-52.335748460872}},{"idCelula":14,"cor":"#ff0000","pontoSupEsq":{"lat":-31.740093996947,"lng":-52.332790927056},"pontoInfDir":{"lat":-31.738836347013,"lng":-52.334269653808}},{"idCelula":15,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093988409,"lng":-52.331312140071},"pontoInfDir":{"lat":-31.738836338475,"lng":-52.332790846744}},{"idCelula":16,"cor":"#ff0000","pontoSupEsq":{"lat":-31.740093979871,"lng":-52.329833353086},"pontoInfDir":{"lat":-31.738836329938,"lng":-52.33131203968}},{"idCelula":17,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093971333,"lng":-52.328354566101},"pontoInfDir":{"lat":-31.7388363214,"lng":-52.329833232617}},{"idCelula":18,"cor":"#ffa500","pontoSupEsq":{"lat":-31.740093962795,"lng":-52.326875779116},"pontoInfDir":{"lat":-31.738836312863,"lng":-52.328354425553}},{"idCelula":19,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093954257,"lng":-52.325396992131},"pontoInfDir":{"lat":-31.738836304325,"lng":-52.32687561849}},{"idCelula":20,"cor":"#ff0000","pontoSupEsq":{"lat":-31.740093945719,"lng":-52.323918205146},"pontoInfDir":{"lat":-31.738836295787,"lng":-52.325396811427}},{"idCelula":22,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093928643,"lng":-52.320960631177},"pontoInfDir":{"lat":-31.738836278712,"lng":-52.322439197301}},{"idCelula":23,"cor":"#ffa500","pontoSupEsq":{"lat":-31.740093920105,"lng":-52.319481844193},"pontoInfDir":{"lat":-31.738836270175,"lng":-52.320960390239}},{"idCelula":25,"cor":"#ff0000","pontoSupEsq":{"lat":-31.741351646882,"lng":-52.334269693963},"pontoInfDir":{"lat":-31.740093996948,"lng":-52.335748440792}},{"idCelula":26,"cor":"#ff0000","pontoSupEsq":{"lat":-31.741351638344,"lng":-52.332790886899},"pontoInfDir":{"lat":-31.74009398841,"lng":-52.334269613649}},{"idCelula":27,"cor":"#ffff00","pontoSupEsq":{"lat":-31.741351629806,"lng":-52.331312079836},"pontoInfDir":{"lat":-31.740093979872,"lng":-52.332790786505}},{"idCelula":28,"cor":"#ffa500","pontoSupEsq":{"lat":-31.741351621267,"lng":-52.329833272772},"pontoInfDir":{"lat":-31.740093971334,"lng":-52.331311959362}},{"idCelula":30,"cor":"#ffff00","pontoSupEsq":{"lat":-31.74135160419,"lng":-52.326875658646},"pontoInfDir":{"lat":-31.740093954258,"lng":-52.328354305076}},{"idCelula":31,"cor":"#ffa500","pontoSupEsq":{"lat":-31.741351595652,"lng":-52.325396851583},"pontoInfDir":{"lat":-31.74009394572,"lng":-52.326875477933}},{"idCelula":35,"cor":"#ff0000","pontoSupEsq":{"lat":-31.741351561498,"lng":-52.319481623332},"pontoInfDir":{"lat":-31.740093911568,"lng":-52.320960169363}},{"idCelula":37,"cor":"#ff0000","pontoSupEsq":{"lat":-31.74260928828,"lng":-52.334269673884},"pontoInfDir":{"lat":-31.741351638345,"lng":-52.335748420711}},{"idCelula":38,"cor":"#ff0000","pontoSupEsq":{"lat":-31.742609279741,"lng":-52.33279084674},"pontoInfDir":{"lat":-31.741351629807,"lng":-52.334269573487}},{"idCelula":39,"cor":"#ffa500","pontoSupEsq":{"lat":-31.742609271202,"lng":-52.331312019597},"pontoInfDir":{"lat":-31.741351621268,"lng":-52.332790726263}},{"idCelula":42,"cor":"#ffa500","pontoSupEsq":{"lat":-31.742609245586,"lng":-52.326875538168},"pontoInfDir":{"lat":-31.741351595653,"lng":-52.328354184591}},{"idCelula":43,"cor":"#ffa500","pontoSupEsq":{"lat":-31.742609237047,"lng":-52.325396711025},"pontoInfDir":{"lat":-31.741351587115,"lng":-52.326875337367}},{"idCelula":46,"cor":"#ffff00","pontoSupEsq":{"lat":-31.74260921143,"lng":-52.320960229598},"pontoInfDir":{"lat":-31.741351561499,"lng":-52.322438795697}},{"idCelula":47,"cor":"#ffa500","pontoSupEsq":{"lat":-31.742609202891,"lng":-52.319481402456},"pontoInfDir":{"lat":-31.741351552961,"lng":-52.320959948474}},{"idCelula":48,"cor":"#ff0000","pontoSupEsq":{"lat":-31.743866938216,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.742609288282,"lng":-52.337227267936}},{"idCelula":50,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866921138,"lng":-52.332790806578},"pontoInfDir":{"lat":-31.742609271204,"lng":-52.334269533323}},{"idCelula":51,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866912599,"lng":-52.331311959354},"pontoInfDir":{"lat":-31.742609262665,"lng":-52.332790666016}},{"idCelula":52,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866904059,"lng":-52.32983311213},"pontoInfDir":{"lat":-31.742609254126,"lng":-52.33131179871}},{"idCelula":53,"cor":"#ffff00","pontoSupEsq":{"lat":-31.74386689552,"lng":-52.328354264907},"pontoInfDir":{"lat":-31.742609245587,"lng":-52.329832931404}},{"idCelula":55,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866878442,"lng":-52.325396570459},"pontoInfDir":{"lat":-31.74260922851,"lng":-52.326875196792}},{"idCelula":60,"cor":"#ffa500","pontoSupEsq":{"lat":-31.745124579614,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.743866929679,"lng":-52.337227267936}},{"idCelula":61,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124571075,"lng":-52.334269633721},"pontoInfDir":{"lat":-31.74386692114,"lng":-52.335748380546}},{"idCelula":62,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124562535,"lng":-52.332790766414},"pontoInfDir":{"lat":-31.743866912601,"lng":-52.334269493156}},{"idCelula":63,"cor":"#ffa500","pontoSupEsq":{"lat":-31.745124553995,"lng":-52.331311899108},"pontoInfDir":{"lat":-31.743866904061,"lng":-52.332790605766}},{"idCelula":64,"cor":"#ffa500","pontoSupEsq":{"lat":-31.745124545455,"lng":-52.329833031802},"pontoInfDir":{"lat":-31.743866895522,"lng":-52.331311718377}},{"idCelula":65,"cor":"#ffa500","pontoSupEsq":{"lat":-31.745124536916,"lng":-52.328354164496},"pontoInfDir":{"lat":-31.743866886983,"lng":-52.329832830987}},{"idCelula":66,"cor":"#ffa500","pontoSupEsq":{"lat":-31.745124528376,"lng":-52.32687529719},"pontoInfDir":{"lat":-31.743866878444,"lng":-52.328353943598}},{"idCelula":67,"cor":"#ffa500","pontoSupEsq":{"lat":-31.745124519836,"lng":-52.325396429885},"pontoInfDir":{"lat":-31.743866869904,"lng":-52.326875056209}},{"idCelula":70,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124494217,"lng":-52.320959827968},"pontoInfDir":{"lat":-31.743866844287,"lng":-52.322438394042}},{"idCelula":71,"cor":"#ffa500","pontoSupEsq":{"lat":-31.745124485678,"lng":-52.319480960663},"pontoInfDir":{"lat":-31.743866835747,"lng":-52.320959506653}},{"idCelula":73,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382212472,"lng":-52.334269613637},"pontoInfDir":{"lat":-31.745124562537,"lng":-52.335748360461}},{"idCelula":74,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382203932,"lng":-52.332790726248},"pontoInfDir":{"lat":-31.745124553998,"lng":-52.334269452987}},{"idCelula":75,"cor":"#ffa500","pontoSupEsq":{"lat":-31.746382195392,"lng":-52.331311838858},"pontoInfDir":{"lat":-31.745124545458,"lng":-52.332790545512}},{"idCelula":77,"cor":"#ff0000","pontoSupEsq":{"lat":-31.746382178311,"lng":-52.328354064079},"pontoInfDir":{"lat":-31.745124528379,"lng":-52.329832730564}},{"idCelula":78,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382169771,"lng":-52.32687517669},"pontoInfDir":{"lat":-31.745124519839,"lng":-52.32835382309}},{"idCelula":79,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382161231,"lng":-52.325396289301},"pontoInfDir":{"lat":-31.745124511299,"lng":-52.326874915616}},{"idCelula":81,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382144151,"lng":-52.322438514523},"pontoInfDir":{"lat":-31.74512449422,"lng":-52.323917100669}},{"idCelula":82,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382135611,"lng":-52.320959627135},"pontoInfDir":{"lat":-31.74512448568,"lng":-52.322438193196}},{"idCelula":83,"cor":"#ff0000","pontoSupEsq":{"lat":-31.746382127071,"lng":-52.319480739746},"pontoInfDir":{"lat":-31.745124477141,"lng":-52.320959285722}},{"idCelula":84,"cor":"#ffff00","pontoSupEsq":{"lat":-31.74763986241,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.746382212475,"lng":-52.337227267936}},{"idCelula":85,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639853869,"lng":-52.334269593553},"pontoInfDir":{"lat":-31.746382203935,"lng":-52.335748340375}},{"idCelula":86,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639845329,"lng":-52.332790686078},"pontoInfDir":{"lat":-31.746382195395,"lng":-52.334269412815}},{"idCelula":87,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639836788,"lng":-52.331311778604},"pontoInfDir":{"lat":-31.746382186855,"lng":-52.332790485255}},{"idCelula":89,"cor":"#ff0000","pontoSupEsq":{"lat":-31.747639819707,"lng":-52.328353963656},"pontoInfDir":{"lat":-31.746382169774,"lng":-52.329832630135}},{"idCelula":90,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639811167,"lng":-52.326875056182},"pontoInfDir":{"lat":-31.746382161234,"lng":-52.328353702575}},{"idCelula":92,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639794086,"lng":-52.323917241235},"pontoInfDir":{"lat":-31.746382144154,"lng":-52.325395847456}},{"idCelula":93,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639785545,"lng":-52.322438333762},"pontoInfDir":{"lat":-31.746382135614,"lng":-52.323916919896}},{"idCelula":94,"cor":"#ff0000","pontoSupEsq":{"lat":-31.747639777005,"lng":-52.320959426288},"pontoInfDir":{"lat":-31.746382127074,"lng":-52.322437992337}},{"idCelula":95,"cor":"#ffa500","pontoSupEsq":{"lat":-31.747639768464,"lng":-52.319480518815},"pontoInfDir":{"lat":-31.746382118534,"lng":-52.320959064778}},{"idCelula":96,"cor":"#ffff00","pontoSupEsq":{"lat":-31.748897503808,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.747639853873,"lng":-52.337227267936}},{"idCelula":97,"cor":"#ffff00","pontoSupEsq":{"lat":-31.748897495267,"lng":-52.334269573467},"pontoInfDir":{"lat":-31.747639845332,"lng":-52.335748320288}},{"idCelula":99,"cor":"#ffa500","pontoSupEsq":{"lat":-31.748897478185,"lng":-52.331311718346},"pontoInfDir":{"lat":-31.747639828251,"lng":-52.332790424993}},{"idCelula":102,"cor":"#ffff00","pontoSupEsq":{"lat":-31.748897452562,"lng":-52.326874935667},"pontoInfDir":{"lat":-31.747639802629,"lng":-52.328353582052}},{"idCelula":103,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897444021,"lng":-52.325396008107},"pontoInfDir":{"lat":-31.747639794089,"lng":-52.326874634405}},{"idCelula":105,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897426939,"lng":-52.322438152989},"pontoInfDir":{"lat":-31.747639777008,"lng":-52.323916739112}},{"idCelula":109,"cor":"#ffa500","pontoSupEsq":{"lat":-31.750155136664,"lng":-52.33426955338},"pontoInfDir":{"lat":-31.748897486729,"lng":-52.3357483002}},{"idCelula":110,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155128123,"lng":-52.332790605732},"pontoInfDir":{"lat":-31.748897478188,"lng":-52.334269332464}},{"idCelula":111,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155119581,"lng":-52.331311658085},"pontoInfDir":{"lat":-31.748897469648,"lng":-52.332790364728}},{"idCelula":112,"cor":"#ffff00","pontoSupEsq":{"lat":-31.75015511104,"lng":-52.329832710438},"pontoInfDir":{"lat":-31.748897461107,"lng":-52.331311396992}},{"idCelula":113,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155102499,"lng":-52.328353762791},"pontoInfDir":{"lat":-31.748897452566,"lng":-52.329832429257}},{"idCelula":114,"cor":"#ffa500","pontoSupEsq":{"lat":-31.750155093957,"lng":-52.326874815144},"pontoInfDir":{"lat":-31.748897444025,"lng":-52.328353461521}},{"idCelula":115,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155085416,"lng":-52.325395867497},"pontoInfDir":{"lat":-31.748897435484,"lng":-52.326874493786}},{"idCelula":116,"cor":"#ffa500","pontoSupEsq":{"lat":-31.750155076874,"lng":-52.323916919851},"pontoInfDir":{"lat":-31.748897426943,"lng":-52.325395526051}},{"idCelula":118,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155059792,"lng":-52.320959024558},"pontoInfDir":{"lat":-31.748897409861,"lng":-52.322437590581}},{"idCelula":119,"cor":"#ffa500","pontoSupEsq":{"lat":-31.75015505125,"lng":-52.319480076912},"pontoInfDir":{"lat":-31.74889740132,"lng":-52.320958622847}},{"idCelula":122,"cor":"#ffff00","pontoSupEsq":{"lat":-31.75141276952,"lng":-52.332790565555},"pontoInfDir":{"lat":-31.750155119585,"lng":-52.334269292284}},{"idCelula":123,"cor":"#ffa500","pontoSupEsq":{"lat":-31.751412760978,"lng":-52.33131159782},"pontoInfDir":{"lat":-31.750155111044,"lng":-52.332790304459}},{"idCelula":124,"cor":"#ffff00","pontoSupEsq":{"lat":-31.751412752436,"lng":-52.329832630084},"pontoInfDir":{"lat":-31.750155102503,"lng":-52.331311316634}},{"idCelula":125,"cor":"#ff0000","pontoSupEsq":{"lat":-31.751412743894,"lng":-52.328353662349},"pontoInfDir":{"lat":-31.750155093961,"lng":-52.329832328809}},{"idCelula":126,"cor":"#ff0000","pontoSupEsq":{"lat":-31.751412735352,"lng":-52.326874694614},"pontoInfDir":{"lat":-31.75015508542,"lng":-52.328353340984}},{"idCelula":127,"cor":"#ff0000","pontoSupEsq":{"lat":-31.751412726811,"lng":-52.325395726879},"pontoInfDir":{"lat":-31.750155076879,"lng":-52.326874353159}},{"idCelula":129,"cor":"#ffff00","pontoSupEsq":{"lat":-31.751412709727,"lng":-52.322437791409},"pontoInfDir":{"lat":-31.750155059796,"lng":-52.323916377509}},{"idCelula":130,"cor":"#ffff00","pontoSupEsq":{"lat":-31.751412701185,"lng":-52.320958823674},"pontoInfDir":{"lat":-31.750155051255,"lng":-52.322437389685}},{"idCelula":135,"cor":"#ff0000","pontoSupEsq":{"lat":-31.752670402374,"lng":-52.331311537551},"pontoInfDir":{"lat":-31.751412752441,"lng":-52.332790244186}},{"idCelula":136,"cor":"#ffa500","pontoSupEsq":{"lat":-31.752670393832,"lng":-52.329832549726},"pontoInfDir":{"lat":-31.751412743899,"lng":-52.33131123627}},{"idCelula":137,"cor":"#ffa500","pontoSupEsq":{"lat":-31.75267038529,"lng":-52.328353561901},"pontoInfDir":{"lat":-31.751412735357,"lng":-52.329832228354}},{"idCelula":138,"cor":"#ffa500","pontoSupEsq":{"lat":-31.752670376748,"lng":-52.326874574076},"pontoInfDir":{"lat":-31.751412726815,"lng":-52.328353220438}},{"idCelula":139,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670368205,"lng":-52.325395586251},"pontoInfDir":{"lat":-31.751412718273,"lng":-52.326874212522}},{"idCelula":140,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670359663,"lng":-52.323916598426},"pontoInfDir":{"lat":-31.751412709732,"lng":-52.325395204607}},{"idCelula":141,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670351121,"lng":-52.322437610602},"pontoInfDir":{"lat":-31.75141270119,"lng":-52.323916196691}},{"idCelula":142,"cor":"#ff0000","pontoSupEsq":{"lat":-31.752670342579,"lng":-52.320958622777},"pontoInfDir":{"lat":-31.751412692648,"lng":-52.322437188776}},{"idCelula":149,"cor":"#ff0000","pontoSupEsq":{"lat":-31.753928026686,"lng":-52.328353461446},"pontoInfDir":{"lat":-31.752670376753,"lng":-52.329832127893}},{"idCelula":150,"cor":"#ff0000","pontoSupEsq":{"lat":-31.753928018143,"lng":-52.32687445353},"pontoInfDir":{"lat":-31.75267036821,"lng":-52.328353099885}},{"idCelula":151,"cor":"#ffff00","pontoSupEsq":{"lat":-31.7539280096,"lng":-52.325395445615},"pontoInfDir":{"lat":-31.752670359668,"lng":-52.326874071877}},{"idCelula":152,"cor":"#ffa500","pontoSupEsq":{"lat":-31.753928001058,"lng":-52.323916437699},"pontoInfDir":{"lat":-31.752670351126,"lng":-52.325395043869}},{"idCelula":154,"cor":"#ff0000","pontoSupEsq":{"lat":-31.753927983972,"lng":-52.320958421868},"pontoInfDir":{"lat":-31.752670334042,"lng":-52.322436987854}},{"idCelula":156,"cor":"#ffff00","pontoSupEsq":{"lat":-31.755185710796,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.753928060861,"lng":-52.337227267936}},{"idCelula":157,"cor":"#ffff00","pontoSupEsq":{"lat":-31.755185702253,"lng":-52.334269473018},"pontoInfDir":{"lat":-31.753928052319,"lng":-52.335748219834}},{"idCelula":159,"cor":"#ffff00","pontoSupEsq":{"lat":-31.755185685167,"lng":-52.331311417002},"pontoInfDir":{"lat":-31.753928035234,"lng":-52.332790123629}},{"idCelula":161,"cor":"#ffff00","pontoSupEsq":{"lat":-31.755185668081,"lng":-52.328353360985},"pontoInfDir":{"lat":-31.753928018148,"lng":-52.329832027426}},{"idCelula":162,"cor":"#ffff00","pontoSupEsq":{"lat":-31.755185659538,"lng":-52.326874332977},"pontoInfDir":{"lat":-31.753928009606,"lng":-52.328352979324}},{"idCelula":164,"cor":"#ff0000","pontoSupEsq":{"lat":-31.755185642452,"lng":-52.323916276962},"pontoInfDir":{"lat":-31.75392799252,"lng":-52.325394883122}}]	2017-01-11 17:25:22.551008-02	\N
26	79	11	[{"idCelula":1,"cor":"#ffa500","pontoSupEsq":{"lat":-31.738836364088,"lng":-52.334269734119},"pontoInfDir":{"lat":-31.737578714153,"lng":-52.33574848095}},{"idCelula":2,"cor":"#ff0000","pontoSupEsq":{"lat":-31.73883635555,"lng":-52.33279096721},"pontoInfDir":{"lat":-31.737578705616,"lng":-52.334269693965}},{"idCelula":3,"cor":"#ff0000","pontoSupEsq":{"lat":-31.738836347013,"lng":-52.331312200302},"pontoInfDir":{"lat":-31.737578697079,"lng":-52.332790906979}},{"idCelula":6,"cor":"#ff0000","pontoSupEsq":{"lat":-31.7388363214,"lng":-52.326875899578},"pontoInfDir":{"lat":-31.737578671467,"lng":-52.328354546024}},{"idCelula":7,"cor":"#ffff00","pontoSupEsq":{"lat":-31.738836312862,"lng":-52.32539713267},"pontoInfDir":{"lat":-31.73757866293,"lng":-52.326875759039}},{"idCelula":8,"cor":"#ff0000","pontoSupEsq":{"lat":-31.738836304325,"lng":-52.323918365763},"pontoInfDir":{"lat":-31.737578654393,"lng":-52.325396972054}},{"idCelula":9,"cor":"#ffa500","pontoSupEsq":{"lat":-31.738836295787,"lng":-52.322439598855},"pontoInfDir":{"lat":-31.737578645856,"lng":-52.323918185069}},{"idCelula":10,"cor":"#ff0000","pontoSupEsq":{"lat":-31.738836287249,"lng":-52.320960831948},"pontoInfDir":{"lat":-31.737578637319,"lng":-52.322439398085}},{"idCelula":12,"cor":"#ffa500","pontoSupEsq":{"lat":-31.740094014023,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.738836364088,"lng":-52.337227267936}},{"idCelula":13,"cor":"#ff0000","pontoSupEsq":{"lat":-31.740094005485,"lng":-52.334269714042},"pontoInfDir":{"lat":-31.738836355551,"lng":-52.335748460872}},{"idCelula":14,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093996947,"lng":-52.332790927056},"pontoInfDir":{"lat":-31.738836347013,"lng":-52.334269653808}},{"idCelula":18,"cor":"#ff0000","pontoSupEsq":{"lat":-31.740093962795,"lng":-52.326875779116},"pontoInfDir":{"lat":-31.738836312863,"lng":-52.328354425553}},{"idCelula":20,"cor":"#ff0000","pontoSupEsq":{"lat":-31.740093945719,"lng":-52.323918205146},"pontoInfDir":{"lat":-31.738836295787,"lng":-52.325396811427}},{"idCelula":21,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093937181,"lng":-52.322439418162},"pontoInfDir":{"lat":-31.73883628725,"lng":-52.323918004364}},{"idCelula":22,"cor":"#ff0000","pontoSupEsq":{"lat":-31.740093928643,"lng":-52.320960631177},"pontoInfDir":{"lat":-31.738836278712,"lng":-52.322439197301}},{"idCelula":24,"cor":"#ffff00","pontoSupEsq":{"lat":-31.741351655421,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.740094005486,"lng":-52.337227267936}},{"idCelula":25,"cor":"#ffa500","pontoSupEsq":{"lat":-31.741351646882,"lng":-52.334269693963},"pontoInfDir":{"lat":-31.740093996948,"lng":-52.335748440792}},{"idCelula":26,"cor":"#ffa500","pontoSupEsq":{"lat":-31.741351638344,"lng":-52.332790886899},"pontoInfDir":{"lat":-31.74009398841,"lng":-52.334269613649}},{"idCelula":28,"cor":"#ffff00","pontoSupEsq":{"lat":-31.741351621267,"lng":-52.329833272772},"pontoInfDir":{"lat":-31.740093971334,"lng":-52.331311959362}},{"idCelula":30,"cor":"#ff0000","pontoSupEsq":{"lat":-31.74135160419,"lng":-52.326875658646},"pontoInfDir":{"lat":-31.740093954258,"lng":-52.328354305076}},{"idCelula":31,"cor":"#ffa500","pontoSupEsq":{"lat":-31.741351595652,"lng":-52.325396851583},"pontoInfDir":{"lat":-31.74009394572,"lng":-52.326875477933}},{"idCelula":34,"cor":"#ff0000","pontoSupEsq":{"lat":-31.741351570037,"lng":-52.320960430394},"pontoInfDir":{"lat":-31.740093920106,"lng":-52.322438996505}},{"idCelula":36,"cor":"#ff0000","pontoSupEsq":{"lat":-31.742609296819,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.741351646884,"lng":-52.337227267936}},{"idCelula":39,"cor":"#ff0000","pontoSupEsq":{"lat":-31.742609271202,"lng":-52.331312019597},"pontoInfDir":{"lat":-31.741351621268,"lng":-52.332790726263}},{"idCelula":41,"cor":"#ffa500","pontoSupEsq":{"lat":-31.742609254124,"lng":-52.328354365311},"pontoInfDir":{"lat":-31.741351604192,"lng":-52.329833031815}},{"idCelula":42,"cor":"#ff0000","pontoSupEsq":{"lat":-31.742609245586,"lng":-52.326875538168},"pontoInfDir":{"lat":-31.741351595653,"lng":-52.328354184591}},{"idCelula":43,"cor":"#ff0000","pontoSupEsq":{"lat":-31.742609237047,"lng":-52.325396711025},"pontoInfDir":{"lat":-31.741351587115,"lng":-52.326875337367}},{"idCelula":45,"cor":"#ff0000","pontoSupEsq":{"lat":-31.742609219969,"lng":-52.32243905674},"pontoInfDir":{"lat":-31.741351570038,"lng":-52.32391764292}},{"idCelula":47,"cor":"#ff0000","pontoSupEsq":{"lat":-31.742609202891,"lng":-52.319481402456},"pontoInfDir":{"lat":-31.741351552961,"lng":-52.320959948474}},{"idCelula":49,"cor":"#ffa500","pontoSupEsq":{"lat":-31.743866929677,"lng":-52.334269653803},"pontoInfDir":{"lat":-31.742609279743,"lng":-52.335748400629}},{"idCelula":50,"cor":"#ffa500","pontoSupEsq":{"lat":-31.743866921138,"lng":-52.332790806578},"pontoInfDir":{"lat":-31.742609271204,"lng":-52.334269533323}},{"idCelula":52,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866904059,"lng":-52.32983311213},"pontoInfDir":{"lat":-31.742609254126,"lng":-52.33131179871}},{"idCelula":53,"cor":"#ffff00","pontoSupEsq":{"lat":-31.74386689552,"lng":-52.328354264907},"pontoInfDir":{"lat":-31.742609245587,"lng":-52.329832931404}},{"idCelula":54,"cor":"#ff0000","pontoSupEsq":{"lat":-31.743866886981,"lng":-52.326875417683},"pontoInfDir":{"lat":-31.742609237048,"lng":-52.328354064098}},{"idCelula":55,"cor":"#ff0000","pontoSupEsq":{"lat":-31.743866878442,"lng":-52.325396570459},"pontoInfDir":{"lat":-31.74260922851,"lng":-52.326875196792}},{"idCelula":56,"cor":"#ff0000","pontoSupEsq":{"lat":-31.743866869902,"lng":-52.323917723236},"pontoInfDir":{"lat":-31.742609219971,"lng":-52.325396329487}},{"idCelula":57,"cor":"#ff0000","pontoSupEsq":{"lat":-31.743866861363,"lng":-52.322438876013},"pontoInfDir":{"lat":-31.742609211432,"lng":-52.323917462181}},{"idCelula":58,"cor":"#ff0000","pontoSupEsq":{"lat":-31.743866852824,"lng":-52.32096002879},"pontoInfDir":{"lat":-31.742609202893,"lng":-52.322438594876}},{"idCelula":59,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866844284,"lng":-52.319481181567},"pontoInfDir":{"lat":-31.742609194354,"lng":-52.32095972757}},{"idCelula":61,"cor":"#ff0000","pontoSupEsq":{"lat":-31.745124571075,"lng":-52.334269633721},"pontoInfDir":{"lat":-31.74386692114,"lng":-52.335748380546}},{"idCelula":62,"cor":"#ffa500","pontoSupEsq":{"lat":-31.745124562535,"lng":-52.332790766414},"pontoInfDir":{"lat":-31.743866912601,"lng":-52.334269493156}},{"idCelula":63,"cor":"#ff0000","pontoSupEsq":{"lat":-31.745124553995,"lng":-52.331311899108},"pontoInfDir":{"lat":-31.743866904061,"lng":-52.332790605766}},{"idCelula":64,"cor":"#ff0000","pontoSupEsq":{"lat":-31.745124545455,"lng":-52.329833031802},"pontoInfDir":{"lat":-31.743866895522,"lng":-52.331311718377}},{"idCelula":65,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124536916,"lng":-52.328354164496},"pontoInfDir":{"lat":-31.743866886983,"lng":-52.329832830987}},{"idCelula":66,"cor":"#ff0000","pontoSupEsq":{"lat":-31.745124528376,"lng":-52.32687529719},"pontoInfDir":{"lat":-31.743866878444,"lng":-52.328353943598}},{"idCelula":67,"cor":"#ff0000","pontoSupEsq":{"lat":-31.745124519836,"lng":-52.325396429885},"pontoInfDir":{"lat":-31.743866869904,"lng":-52.326875056209}},{"idCelula":68,"cor":"#ff0000","pontoSupEsq":{"lat":-31.745124511297,"lng":-52.323917562579},"pontoInfDir":{"lat":-31.743866861365,"lng":-52.32539616882}},{"idCelula":69,"cor":"#ff0000","pontoSupEsq":{"lat":-31.745124502757,"lng":-52.322438695274},"pontoInfDir":{"lat":-31.743866852826,"lng":-52.323917281431}},{"idCelula":70,"cor":"#ff0000","pontoSupEsq":{"lat":-31.745124494217,"lng":-52.320959827968},"pontoInfDir":{"lat":-31.743866844287,"lng":-52.322438394042}},{"idCelula":71,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124485678,"lng":-52.319480960663},"pontoInfDir":{"lat":-31.743866835747,"lng":-52.320959506653}},{"idCelula":72,"cor":"#ff0000","pontoSupEsq":{"lat":-31.746382221012,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.745124571077,"lng":-52.337227267936}},{"idCelula":73,"cor":"#ff0000","pontoSupEsq":{"lat":-31.746382212472,"lng":-52.334269613637},"pontoInfDir":{"lat":-31.745124562537,"lng":-52.335748360461}},{"idCelula":74,"cor":"#ff0000","pontoSupEsq":{"lat":-31.746382203932,"lng":-52.332790726248},"pontoInfDir":{"lat":-31.745124553998,"lng":-52.334269452987}},{"idCelula":75,"cor":"#ffa500","pontoSupEsq":{"lat":-31.746382195392,"lng":-52.331311838858},"pontoInfDir":{"lat":-31.745124545458,"lng":-52.332790545512}},{"idCelula":76,"cor":"#ff0000","pontoSupEsq":{"lat":-31.746382186852,"lng":-52.329832951469},"pontoInfDir":{"lat":-31.745124536918,"lng":-52.331311638038}},{"idCelula":77,"cor":"#ff0000","pontoSupEsq":{"lat":-31.746382178311,"lng":-52.328354064079},"pontoInfDir":{"lat":-31.745124528379,"lng":-52.329832730564}},{"idCelula":78,"cor":"#ffa500","pontoSupEsq":{"lat":-31.746382169771,"lng":-52.32687517669},"pontoInfDir":{"lat":-31.745124519839,"lng":-52.32835382309}},{"idCelula":79,"cor":"#ff0000","pontoSupEsq":{"lat":-31.746382161231,"lng":-52.325396289301},"pontoInfDir":{"lat":-31.745124511299,"lng":-52.326874915616}},{"idCelula":80,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382152691,"lng":-52.323917401912},"pontoInfDir":{"lat":-31.74512450276,"lng":-52.325396008143}},{"idCelula":81,"cor":"#ffa500","pontoSupEsq":{"lat":-31.746382144151,"lng":-52.322438514523},"pontoInfDir":{"lat":-31.74512449422,"lng":-52.323917100669}},{"idCelula":82,"cor":"#ff0000","pontoSupEsq":{"lat":-31.746382135611,"lng":-52.320959627135},"pontoInfDir":{"lat":-31.74512448568,"lng":-52.322438193196}},{"idCelula":83,"cor":"#ffa500","pontoSupEsq":{"lat":-31.746382127071,"lng":-52.319480739746},"pontoInfDir":{"lat":-31.745124477141,"lng":-52.320959285722}},{"idCelula":85,"cor":"#ffa500","pontoSupEsq":{"lat":-31.747639853869,"lng":-52.334269593553},"pontoInfDir":{"lat":-31.746382203935,"lng":-52.335748340375}},{"idCelula":86,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639845329,"lng":-52.332790686078},"pontoInfDir":{"lat":-31.746382195395,"lng":-52.334269412815}},{"idCelula":87,"cor":"#ff0000","pontoSupEsq":{"lat":-31.747639836788,"lng":-52.331311778604},"pontoInfDir":{"lat":-31.746382186855,"lng":-52.332790485255}},{"idCelula":88,"cor":"#ff0000","pontoSupEsq":{"lat":-31.747639828248,"lng":-52.32983287113},"pontoInfDir":{"lat":-31.746382178314,"lng":-52.331311557695}},{"idCelula":89,"cor":"#ffa500","pontoSupEsq":{"lat":-31.747639819707,"lng":-52.328353963656},"pontoInfDir":{"lat":-31.746382169774,"lng":-52.329832630135}},{"idCelula":90,"cor":"#ff0000","pontoSupEsq":{"lat":-31.747639811167,"lng":-52.326875056182},"pontoInfDir":{"lat":-31.746382161234,"lng":-52.328353702575}},{"idCelula":91,"cor":"#ff0000","pontoSupEsq":{"lat":-31.747639802626,"lng":-52.325396148709},"pontoInfDir":{"lat":-31.746382152694,"lng":-52.326874775015}},{"idCelula":92,"cor":"#ffa500","pontoSupEsq":{"lat":-31.747639794086,"lng":-52.323917241235},"pontoInfDir":{"lat":-31.746382144154,"lng":-52.325395847456}},{"idCelula":94,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639777005,"lng":-52.320959426288},"pontoInfDir":{"lat":-31.746382127074,"lng":-52.322437992337}},{"idCelula":95,"cor":"#ff0000","pontoSupEsq":{"lat":-31.747639768464,"lng":-52.319480518815},"pontoInfDir":{"lat":-31.746382118534,"lng":-52.320959064778}},{"idCelula":96,"cor":"#ffa500","pontoSupEsq":{"lat":-31.748897503808,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.747639853873,"lng":-52.337227267936}},{"idCelula":97,"cor":"#ffa500","pontoSupEsq":{"lat":-31.748897495267,"lng":-52.334269573467},"pontoInfDir":{"lat":-31.747639845332,"lng":-52.335748320288}},{"idCelula":98,"cor":"#ffff00","pontoSupEsq":{"lat":-31.748897486726,"lng":-52.332790645907},"pontoInfDir":{"lat":-31.747639836792,"lng":-52.334269372641}},{"idCelula":99,"cor":"#ffff00","pontoSupEsq":{"lat":-31.748897478185,"lng":-52.331311718346},"pontoInfDir":{"lat":-31.747639828251,"lng":-52.332790424993}},{"idCelula":100,"cor":"#ffff00","pontoSupEsq":{"lat":-31.748897469644,"lng":-52.329832790786},"pontoInfDir":{"lat":-31.747639819711,"lng":-52.331311477346}},{"idCelula":101,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897461103,"lng":-52.328353863227},"pontoInfDir":{"lat":-31.74763981117,"lng":-52.329832529699}},{"idCelula":102,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897452562,"lng":-52.326874935667},"pontoInfDir":{"lat":-31.747639802629,"lng":-52.328353582052}},{"idCelula":103,"cor":"#ffff00","pontoSupEsq":{"lat":-31.748897444021,"lng":-52.325396008107},"pontoInfDir":{"lat":-31.747639794089,"lng":-52.326874634405}},{"idCelula":104,"cor":"#ffff00","pontoSupEsq":{"lat":-31.74889743548,"lng":-52.323917080548},"pontoInfDir":{"lat":-31.747639785548,"lng":-52.325395686758}},{"idCelula":106,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897418398,"lng":-52.32095922543},"pontoInfDir":{"lat":-31.747639768467,"lng":-52.322437791465}},{"idCelula":107,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897409857,"lng":-52.319480297871},"pontoInfDir":{"lat":-31.747639759927,"lng":-52.320958843819}},{"idCelula":109,"cor":"#ff0000","pontoSupEsq":{"lat":-31.750155136664,"lng":-52.33426955338},"pontoInfDir":{"lat":-31.748897486729,"lng":-52.3357483002}},{"idCelula":110,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155128123,"lng":-52.332790605732},"pontoInfDir":{"lat":-31.748897478188,"lng":-52.334269332464}},{"idCelula":111,"cor":"#ff0000","pontoSupEsq":{"lat":-31.750155119581,"lng":-52.331311658085},"pontoInfDir":{"lat":-31.748897469648,"lng":-52.332790364728}},{"idCelula":112,"cor":"#ffff00","pontoSupEsq":{"lat":-31.75015511104,"lng":-52.329832710438},"pontoInfDir":{"lat":-31.748897461107,"lng":-52.331311396992}},{"idCelula":113,"cor":"#ffa500","pontoSupEsq":{"lat":-31.750155102499,"lng":-52.328353762791},"pontoInfDir":{"lat":-31.748897452566,"lng":-52.329832429257}},{"idCelula":114,"cor":"#ff0000","pontoSupEsq":{"lat":-31.750155093957,"lng":-52.326874815144},"pontoInfDir":{"lat":-31.748897444025,"lng":-52.328353461521}},{"idCelula":115,"cor":"#ff0000","pontoSupEsq":{"lat":-31.750155085416,"lng":-52.325395867497},"pontoInfDir":{"lat":-31.748897435484,"lng":-52.326874493786}},{"idCelula":116,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155076874,"lng":-52.323916919851},"pontoInfDir":{"lat":-31.748897426943,"lng":-52.325395526051}},{"idCelula":117,"cor":"#ffa500","pontoSupEsq":{"lat":-31.750155068333,"lng":-52.322437972204},"pontoInfDir":{"lat":-31.748897418402,"lng":-52.323916558316}},{"idCelula":118,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155059792,"lng":-52.320959024558},"pontoInfDir":{"lat":-31.748897409861,"lng":-52.322437590581}},{"idCelula":122,"cor":"#ffa500","pontoSupEsq":{"lat":-31.75141276952,"lng":-52.332790565555},"pontoInfDir":{"lat":-31.750155119585,"lng":-52.334269292284}},{"idCelula":124,"cor":"#ff0000","pontoSupEsq":{"lat":-31.751412752436,"lng":-52.329832630084},"pontoInfDir":{"lat":-31.750155102503,"lng":-52.331311316634}},{"idCelula":125,"cor":"#ff0000","pontoSupEsq":{"lat":-31.751412743894,"lng":-52.328353662349},"pontoInfDir":{"lat":-31.750155093961,"lng":-52.329832328809}},{"idCelula":126,"cor":"#ffa500","pontoSupEsq":{"lat":-31.751412735352,"lng":-52.326874694614},"pontoInfDir":{"lat":-31.75015508542,"lng":-52.328353340984}},{"idCelula":127,"cor":"#ffa500","pontoSupEsq":{"lat":-31.751412726811,"lng":-52.325395726879},"pontoInfDir":{"lat":-31.750155076879,"lng":-52.326874353159}},{"idCelula":128,"cor":"#ffff00","pontoSupEsq":{"lat":-31.751412718269,"lng":-52.323916759144},"pontoInfDir":{"lat":-31.750155068337,"lng":-52.325395365334}},{"idCelula":129,"cor":"#ff0000","pontoSupEsq":{"lat":-31.751412709727,"lng":-52.322437791409},"pontoInfDir":{"lat":-31.750155059796,"lng":-52.323916377509}},{"idCelula":130,"cor":"#ff0000","pontoSupEsq":{"lat":-31.751412701185,"lng":-52.320958823674},"pontoInfDir":{"lat":-31.750155051255,"lng":-52.322437389685}},{"idCelula":132,"cor":"#ffa500","pontoSupEsq":{"lat":-31.752670428001,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.751412778066,"lng":-52.337227267936}},{"idCelula":134,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670410916,"lng":-52.332790525376},"pontoInfDir":{"lat":-31.751412760982,"lng":-52.334269252103}},{"idCelula":135,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670402374,"lng":-52.331311537551},"pontoInfDir":{"lat":-31.751412752441,"lng":-52.332790244186}},{"idCelula":136,"cor":"#ff0000","pontoSupEsq":{"lat":-31.752670393832,"lng":-52.329832549726},"pontoInfDir":{"lat":-31.751412743899,"lng":-52.33131123627}},{"idCelula":137,"cor":"#ffff00","pontoSupEsq":{"lat":-31.75267038529,"lng":-52.328353561901},"pontoInfDir":{"lat":-31.751412735357,"lng":-52.329832228354}},{"idCelula":140,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670359663,"lng":-52.323916598426},"pontoInfDir":{"lat":-31.751412709732,"lng":-52.325395204607}},{"idCelula":141,"cor":"#ff0000","pontoSupEsq":{"lat":-31.752670351121,"lng":-52.322437610602},"pontoInfDir":{"lat":-31.75141270119,"lng":-52.323916196691}},{"idCelula":143,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670334037,"lng":-52.319479634953},"pontoInfDir":{"lat":-31.751412684106,"lng":-52.32095818086}},{"idCelula":144,"cor":"#ffa500","pontoSupEsq":{"lat":-31.753928069399,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.752670419464,"lng":-52.337227267936}},{"idCelula":146,"cor":"#ff0000","pontoSupEsq":{"lat":-31.753928052313,"lng":-52.332790485194},"pontoInfDir":{"lat":-31.752670402379,"lng":-52.334269211918}},{"idCelula":147,"cor":"#ff0000","pontoSupEsq":{"lat":-31.753928043771,"lng":-52.331311477278},"pontoInfDir":{"lat":-31.752670393837,"lng":-52.33279018391}},{"idCelula":148,"cor":"#ff0000","pontoSupEsq":{"lat":-31.753928035228,"lng":-52.329832469362},"pontoInfDir":{"lat":-31.752670385295,"lng":-52.331311155901}},{"idCelula":149,"cor":"#ffa500","pontoSupEsq":{"lat":-31.753928026686,"lng":-52.328353461446},"pontoInfDir":{"lat":-31.752670376753,"lng":-52.329832127893}},{"idCelula":150,"cor":"#ff0000","pontoSupEsq":{"lat":-31.753928018143,"lng":-52.32687445353},"pontoInfDir":{"lat":-31.75267036821,"lng":-52.328353099885}},{"idCelula":151,"cor":"#ffff00","pontoSupEsq":{"lat":-31.7539280096,"lng":-52.325395445615},"pontoInfDir":{"lat":-31.752670359668,"lng":-52.326874071877}},{"idCelula":152,"cor":"#ff0000","pontoSupEsq":{"lat":-31.753928001058,"lng":-52.323916437699},"pontoInfDir":{"lat":-31.752670351126,"lng":-52.325395043869}},{"idCelula":155,"cor":"#ffa500","pontoSupEsq":{"lat":-31.75392797543,"lng":-52.319479413953},"pontoInfDir":{"lat":-31.752670325499,"lng":-52.320957959846}},{"idCelula":156,"cor":"#ffa500","pontoSupEsq":{"lat":-31.755185710796,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.753928060861,"lng":-52.337227267936}},{"idCelula":157,"cor":"#ff0000","pontoSupEsq":{"lat":-31.755185702253,"lng":-52.334269473018},"pontoInfDir":{"lat":-31.753928052319,"lng":-52.335748219834}},{"idCelula":158,"cor":"#ffff00","pontoSupEsq":{"lat":-31.75518569371,"lng":-52.33279044501},"pontoInfDir":{"lat":-31.753928043776,"lng":-52.334269171731}},{"idCelula":160,"cor":"#ff0000","pontoSupEsq":{"lat":-31.755185676624,"lng":-52.329832388993},"pontoInfDir":{"lat":-31.753928026691,"lng":-52.331311075528}},{"idCelula":161,"cor":"#ff0000","pontoSupEsq":{"lat":-31.755185668081,"lng":-52.328353360985},"pontoInfDir":{"lat":-31.753928018148,"lng":-52.329832027426}},{"idCelula":162,"cor":"#ff0000","pontoSupEsq":{"lat":-31.755185659538,"lng":-52.326874332977},"pontoInfDir":{"lat":-31.753928009606,"lng":-52.328352979324}},{"idCelula":163,"cor":"#ff0000","pontoSupEsq":{"lat":-31.755185650995,"lng":-52.325395304969},"pontoInfDir":{"lat":-31.753928001063,"lng":-52.326873931223}},{"idCelula":164,"cor":"#ffff00","pontoSupEsq":{"lat":-31.755185642452,"lng":-52.323916276962},"pontoInfDir":{"lat":-31.75392799252,"lng":-52.325394883122}},{"idCelula":166,"cor":"#ffa500","pontoSupEsq":{"lat":-31.755185625366,"lng":-52.320958220947},"pontoInfDir":{"lat":-31.753927975435,"lng":-52.32243678692}},{"idCelula":167,"cor":"#ffa500","pontoSupEsq":{"lat":-31.755185616823,"lng":-52.319479192939},"pontoInfDir":{"lat":-31.753927966893,"lng":-52.320957738819}}]	2017-01-11 17:25:22.644195-02	\N
27	80	11	[{"idCelula":1,"cor":"#ffa500","pontoSupEsq":{"lat":-31.738836364088,"lng":-52.334269734119},"pontoInfDir":{"lat":-31.737578714153,"lng":-52.33574848095}},{"idCelula":2,"cor":"#ffff00","pontoSupEsq":{"lat":-31.73883635555,"lng":-52.33279096721},"pontoInfDir":{"lat":-31.737578705616,"lng":-52.334269693965}},{"idCelula":3,"cor":"#ffa500","pontoSupEsq":{"lat":-31.738836347013,"lng":-52.331312200302},"pontoInfDir":{"lat":-31.737578697079,"lng":-52.332790906979}},{"idCelula":4,"cor":"#ffff00","pontoSupEsq":{"lat":-31.738836338475,"lng":-52.329833433394},"pontoInfDir":{"lat":-31.737578688542,"lng":-52.331312119994}},{"idCelula":5,"cor":"#ffff00","pontoSupEsq":{"lat":-31.738836329937,"lng":-52.328354666486},"pontoInfDir":{"lat":-31.737578680005,"lng":-52.329833333009}},{"idCelula":7,"cor":"#ffa500","pontoSupEsq":{"lat":-31.738836312862,"lng":-52.32539713267},"pontoInfDir":{"lat":-31.73757866293,"lng":-52.326875759039}},{"idCelula":8,"cor":"#ffff00","pontoSupEsq":{"lat":-31.738836304325,"lng":-52.323918365763},"pontoInfDir":{"lat":-31.737578654393,"lng":-52.325396972054}},{"idCelula":10,"cor":"#ffa500","pontoSupEsq":{"lat":-31.738836287249,"lng":-52.320960831948},"pontoInfDir":{"lat":-31.737578637319,"lng":-52.322439398085}},{"idCelula":13,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740094005485,"lng":-52.334269714042},"pontoInfDir":{"lat":-31.738836355551,"lng":-52.335748460872}},{"idCelula":14,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093996947,"lng":-52.332790927056},"pontoInfDir":{"lat":-31.738836347013,"lng":-52.334269653808}},{"idCelula":15,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093988409,"lng":-52.331312140071},"pontoInfDir":{"lat":-31.738836338475,"lng":-52.332790846744}},{"idCelula":16,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093979871,"lng":-52.329833353086},"pontoInfDir":{"lat":-31.738836329938,"lng":-52.33131203968}},{"idCelula":17,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093971333,"lng":-52.328354566101},"pontoInfDir":{"lat":-31.7388363214,"lng":-52.329833232617}},{"idCelula":18,"cor":"#ff0000","pontoSupEsq":{"lat":-31.740093962795,"lng":-52.326875779116},"pontoInfDir":{"lat":-31.738836312863,"lng":-52.328354425553}},{"idCelula":19,"cor":"#ffa500","pontoSupEsq":{"lat":-31.740093954257,"lng":-52.325396992131},"pontoInfDir":{"lat":-31.738836304325,"lng":-52.32687561849}},{"idCelula":20,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093945719,"lng":-52.323918205146},"pontoInfDir":{"lat":-31.738836295787,"lng":-52.325396811427}},{"idCelula":21,"cor":"#ffa500","pontoSupEsq":{"lat":-31.740093937181,"lng":-52.322439418162},"pontoInfDir":{"lat":-31.73883628725,"lng":-52.323918004364}},{"idCelula":22,"cor":"#ffff00","pontoSupEsq":{"lat":-31.740093928643,"lng":-52.320960631177},"pontoInfDir":{"lat":-31.738836278712,"lng":-52.322439197301}},{"idCelula":25,"cor":"#ffff00","pontoSupEsq":{"lat":-31.741351646882,"lng":-52.334269693963},"pontoInfDir":{"lat":-31.740093996948,"lng":-52.335748440792}},{"idCelula":26,"cor":"#ffff00","pontoSupEsq":{"lat":-31.741351638344,"lng":-52.332790886899},"pontoInfDir":{"lat":-31.74009398841,"lng":-52.334269613649}},{"idCelula":28,"cor":"#ffff00","pontoSupEsq":{"lat":-31.741351621267,"lng":-52.329833272772},"pontoInfDir":{"lat":-31.740093971334,"lng":-52.331311959362}},{"idCelula":29,"cor":"#ffff00","pontoSupEsq":{"lat":-31.741351612729,"lng":-52.328354465709},"pontoInfDir":{"lat":-31.740093962796,"lng":-52.329833132219}},{"idCelula":30,"cor":"#ff0000","pontoSupEsq":{"lat":-31.74135160419,"lng":-52.326875658646},"pontoInfDir":{"lat":-31.740093954258,"lng":-52.328354305076}},{"idCelula":31,"cor":"#ffa500","pontoSupEsq":{"lat":-31.741351595652,"lng":-52.325396851583},"pontoInfDir":{"lat":-31.74009394572,"lng":-52.326875477933}},{"idCelula":32,"cor":"#ffff00","pontoSupEsq":{"lat":-31.741351587113,"lng":-52.32391804452},"pontoInfDir":{"lat":-31.740093937182,"lng":-52.32539665079}},{"idCelula":33,"cor":"#ffff00","pontoSupEsq":{"lat":-31.741351578575,"lng":-52.322439237457},"pontoInfDir":{"lat":-31.740093928644,"lng":-52.323917823648}},{"idCelula":34,"cor":"#ffff00","pontoSupEsq":{"lat":-31.741351570037,"lng":-52.320960430394},"pontoInfDir":{"lat":-31.740093920106,"lng":-52.322438996505}},{"idCelula":35,"cor":"#ff0000","pontoSupEsq":{"lat":-31.741351561498,"lng":-52.319481623332},"pontoInfDir":{"lat":-31.740093911568,"lng":-52.320960169363}},{"idCelula":37,"cor":"#ffff00","pontoSupEsq":{"lat":-31.74260928828,"lng":-52.334269673884},"pontoInfDir":{"lat":-31.741351638345,"lng":-52.335748420711}},{"idCelula":40,"cor":"#ffff00","pontoSupEsq":{"lat":-31.742609262663,"lng":-52.329833192454},"pontoInfDir":{"lat":-31.74135161273,"lng":-52.331311879038}},{"idCelula":41,"cor":"#ff0000","pontoSupEsq":{"lat":-31.742609254124,"lng":-52.328354365311},"pontoInfDir":{"lat":-31.741351604192,"lng":-52.329833031815}},{"idCelula":42,"cor":"#ffa500","pontoSupEsq":{"lat":-31.742609245586,"lng":-52.326875538168},"pontoInfDir":{"lat":-31.741351595653,"lng":-52.328354184591}},{"idCelula":43,"cor":"#ffff00","pontoSupEsq":{"lat":-31.742609237047,"lng":-52.325396711025},"pontoInfDir":{"lat":-31.741351587115,"lng":-52.326875337367}},{"idCelula":45,"cor":"#ffff00","pontoSupEsq":{"lat":-31.742609219969,"lng":-52.32243905674},"pontoInfDir":{"lat":-31.741351570038,"lng":-52.32391764292}},{"idCelula":47,"cor":"#ffa500","pontoSupEsq":{"lat":-31.742609202891,"lng":-52.319481402456},"pontoInfDir":{"lat":-31.741351552961,"lng":-52.320959948474}},{"idCelula":49,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866929677,"lng":-52.334269653803},"pontoInfDir":{"lat":-31.742609279743,"lng":-52.335748400629}},{"idCelula":51,"cor":"#ffa500","pontoSupEsq":{"lat":-31.743866912599,"lng":-52.331311959354},"pontoInfDir":{"lat":-31.742609262665,"lng":-52.332790666016}},{"idCelula":52,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866904059,"lng":-52.32983311213},"pontoInfDir":{"lat":-31.742609254126,"lng":-52.33131179871}},{"idCelula":54,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866886981,"lng":-52.326875417683},"pontoInfDir":{"lat":-31.742609237048,"lng":-52.328354064098}},{"idCelula":56,"cor":"#ff0000","pontoSupEsq":{"lat":-31.743866869902,"lng":-52.323917723236},"pontoInfDir":{"lat":-31.742609219971,"lng":-52.325396329487}},{"idCelula":57,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866861363,"lng":-52.322438876013},"pontoInfDir":{"lat":-31.742609211432,"lng":-52.323917462181}},{"idCelula":58,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866852824,"lng":-52.32096002879},"pontoInfDir":{"lat":-31.742609202893,"lng":-52.322438594876}},{"idCelula":59,"cor":"#ffff00","pontoSupEsq":{"lat":-31.743866844284,"lng":-52.319481181567},"pontoInfDir":{"lat":-31.742609194354,"lng":-52.32095972757}},{"idCelula":61,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124571075,"lng":-52.334269633721},"pontoInfDir":{"lat":-31.74386692114,"lng":-52.335748380546}},{"idCelula":62,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124562535,"lng":-52.332790766414},"pontoInfDir":{"lat":-31.743866912601,"lng":-52.334269493156}},{"idCelula":63,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124553995,"lng":-52.331311899108},"pontoInfDir":{"lat":-31.743866904061,"lng":-52.332790605766}},{"idCelula":64,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124545455,"lng":-52.329833031802},"pontoInfDir":{"lat":-31.743866895522,"lng":-52.331311718377}},{"idCelula":65,"cor":"#ffa500","pontoSupEsq":{"lat":-31.745124536916,"lng":-52.328354164496},"pontoInfDir":{"lat":-31.743866886983,"lng":-52.329832830987}},{"idCelula":67,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124519836,"lng":-52.325396429885},"pontoInfDir":{"lat":-31.743866869904,"lng":-52.326875056209}},{"idCelula":68,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124511297,"lng":-52.323917562579},"pontoInfDir":{"lat":-31.743866861365,"lng":-52.32539616882}},{"idCelula":69,"cor":"#ff0000","pontoSupEsq":{"lat":-31.745124502757,"lng":-52.322438695274},"pontoInfDir":{"lat":-31.743866852826,"lng":-52.323917281431}},{"idCelula":70,"cor":"#ffa500","pontoSupEsq":{"lat":-31.745124494217,"lng":-52.320959827968},"pontoInfDir":{"lat":-31.743866844287,"lng":-52.322438394042}},{"idCelula":71,"cor":"#ffff00","pontoSupEsq":{"lat":-31.745124485678,"lng":-52.319480960663},"pontoInfDir":{"lat":-31.743866835747,"lng":-52.320959506653}},{"idCelula":72,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382221012,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.745124571077,"lng":-52.337227267936}},{"idCelula":73,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382212472,"lng":-52.334269613637},"pontoInfDir":{"lat":-31.745124562537,"lng":-52.335748360461}},{"idCelula":74,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382203932,"lng":-52.332790726248},"pontoInfDir":{"lat":-31.745124553998,"lng":-52.334269452987}},{"idCelula":75,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382195392,"lng":-52.331311838858},"pontoInfDir":{"lat":-31.745124545458,"lng":-52.332790545512}},{"idCelula":76,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382186852,"lng":-52.329832951469},"pontoInfDir":{"lat":-31.745124536918,"lng":-52.331311638038}},{"idCelula":77,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382178311,"lng":-52.328354064079},"pontoInfDir":{"lat":-31.745124528379,"lng":-52.329832730564}},{"idCelula":78,"cor":"#ffa500","pontoSupEsq":{"lat":-31.746382169771,"lng":-52.32687517669},"pontoInfDir":{"lat":-31.745124519839,"lng":-52.32835382309}},{"idCelula":79,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382161231,"lng":-52.325396289301},"pontoInfDir":{"lat":-31.745124511299,"lng":-52.326874915616}},{"idCelula":80,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382152691,"lng":-52.323917401912},"pontoInfDir":{"lat":-31.74512450276,"lng":-52.325396008143}},{"idCelula":81,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382144151,"lng":-52.322438514523},"pontoInfDir":{"lat":-31.74512449422,"lng":-52.323917100669}},{"idCelula":82,"cor":"#ffff00","pontoSupEsq":{"lat":-31.746382135611,"lng":-52.320959627135},"pontoInfDir":{"lat":-31.74512448568,"lng":-52.322438193196}},{"idCelula":83,"cor":"#ff0000","pontoSupEsq":{"lat":-31.746382127071,"lng":-52.319480739746},"pontoInfDir":{"lat":-31.745124477141,"lng":-52.320959285722}},{"idCelula":85,"cor":"#ffa500","pontoSupEsq":{"lat":-31.747639853869,"lng":-52.334269593553},"pontoInfDir":{"lat":-31.746382203935,"lng":-52.335748340375}},{"idCelula":86,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639845329,"lng":-52.332790686078},"pontoInfDir":{"lat":-31.746382195395,"lng":-52.334269412815}},{"idCelula":87,"cor":"#ffa500","pontoSupEsq":{"lat":-31.747639836788,"lng":-52.331311778604},"pontoInfDir":{"lat":-31.746382186855,"lng":-52.332790485255}},{"idCelula":88,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639828248,"lng":-52.32983287113},"pontoInfDir":{"lat":-31.746382178314,"lng":-52.331311557695}},{"idCelula":90,"cor":"#ffa500","pontoSupEsq":{"lat":-31.747639811167,"lng":-52.326875056182},"pontoInfDir":{"lat":-31.746382161234,"lng":-52.328353702575}},{"idCelula":91,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639802626,"lng":-52.325396148709},"pontoInfDir":{"lat":-31.746382152694,"lng":-52.326874775015}},{"idCelula":93,"cor":"#ffa500","pontoSupEsq":{"lat":-31.747639785545,"lng":-52.322438333762},"pontoInfDir":{"lat":-31.746382135614,"lng":-52.323916919896}},{"idCelula":94,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639777005,"lng":-52.320959426288},"pontoInfDir":{"lat":-31.746382127074,"lng":-52.322437992337}},{"idCelula":95,"cor":"#ffff00","pontoSupEsq":{"lat":-31.747639768464,"lng":-52.319480518815},"pontoInfDir":{"lat":-31.746382118534,"lng":-52.320959064778}},{"idCelula":96,"cor":"#ffa500","pontoSupEsq":{"lat":-31.748897503808,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.747639853873,"lng":-52.337227267936}},{"idCelula":97,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897495267,"lng":-52.334269573467},"pontoInfDir":{"lat":-31.747639845332,"lng":-52.335748320288}},{"idCelula":98,"cor":"#ffff00","pontoSupEsq":{"lat":-31.748897486726,"lng":-52.332790645907},"pontoInfDir":{"lat":-31.747639836792,"lng":-52.334269372641}},{"idCelula":99,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897478185,"lng":-52.331311718346},"pontoInfDir":{"lat":-31.747639828251,"lng":-52.332790424993}},{"idCelula":101,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897461103,"lng":-52.328353863227},"pontoInfDir":{"lat":-31.74763981117,"lng":-52.329832529699}},{"idCelula":102,"cor":"#ffff00","pontoSupEsq":{"lat":-31.748897452562,"lng":-52.326874935667},"pontoInfDir":{"lat":-31.747639802629,"lng":-52.328353582052}},{"idCelula":103,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897444021,"lng":-52.325396008107},"pontoInfDir":{"lat":-31.747639794089,"lng":-52.326874634405}},{"idCelula":104,"cor":"#ffff00","pontoSupEsq":{"lat":-31.74889743548,"lng":-52.323917080548},"pontoInfDir":{"lat":-31.747639785548,"lng":-52.325395686758}},{"idCelula":105,"cor":"#ffa500","pontoSupEsq":{"lat":-31.748897426939,"lng":-52.322438152989},"pontoInfDir":{"lat":-31.747639777008,"lng":-52.323916739112}},{"idCelula":106,"cor":"#ffff00","pontoSupEsq":{"lat":-31.748897418398,"lng":-52.32095922543},"pontoInfDir":{"lat":-31.747639768467,"lng":-52.322437791465}},{"idCelula":107,"cor":"#ff0000","pontoSupEsq":{"lat":-31.748897409857,"lng":-52.319480297871},"pontoInfDir":{"lat":-31.747639759927,"lng":-52.320958843819}},{"idCelula":109,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155136664,"lng":-52.33426955338},"pontoInfDir":{"lat":-31.748897486729,"lng":-52.3357483002}},{"idCelula":111,"cor":"#ff0000","pontoSupEsq":{"lat":-31.750155119581,"lng":-52.331311658085},"pontoInfDir":{"lat":-31.748897469648,"lng":-52.332790364728}},{"idCelula":112,"cor":"#ffa500","pontoSupEsq":{"lat":-31.75015511104,"lng":-52.329832710438},"pontoInfDir":{"lat":-31.748897461107,"lng":-52.331311396992}},{"idCelula":113,"cor":"#ffa500","pontoSupEsq":{"lat":-31.750155102499,"lng":-52.328353762791},"pontoInfDir":{"lat":-31.748897452566,"lng":-52.329832429257}},{"idCelula":114,"cor":"#ffa500","pontoSupEsq":{"lat":-31.750155093957,"lng":-52.326874815144},"pontoInfDir":{"lat":-31.748897444025,"lng":-52.328353461521}},{"idCelula":115,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155085416,"lng":-52.325395867497},"pontoInfDir":{"lat":-31.748897435484,"lng":-52.326874493786}},{"idCelula":117,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155068333,"lng":-52.322437972204},"pontoInfDir":{"lat":-31.748897418402,"lng":-52.323916558316}},{"idCelula":118,"cor":"#ffff00","pontoSupEsq":{"lat":-31.750155059792,"lng":-52.320959024558},"pontoInfDir":{"lat":-31.748897409861,"lng":-52.322437590581}},{"idCelula":119,"cor":"#ffff00","pontoSupEsq":{"lat":-31.75015505125,"lng":-52.319480076912},"pontoInfDir":{"lat":-31.74889740132,"lng":-52.320958622847}},{"idCelula":121,"cor":"#ffff00","pontoSupEsq":{"lat":-31.751412778061,"lng":-52.334269533291},"pontoInfDir":{"lat":-31.750155128127,"lng":-52.33574828011}},{"idCelula":122,"cor":"#ff0000","pontoSupEsq":{"lat":-31.75141276952,"lng":-52.332790565555},"pontoInfDir":{"lat":-31.750155119585,"lng":-52.334269292284}},{"idCelula":123,"cor":"#ffa500","pontoSupEsq":{"lat":-31.751412760978,"lng":-52.33131159782},"pontoInfDir":{"lat":-31.750155111044,"lng":-52.332790304459}},{"idCelula":124,"cor":"#ffff00","pontoSupEsq":{"lat":-31.751412752436,"lng":-52.329832630084},"pontoInfDir":{"lat":-31.750155102503,"lng":-52.331311316634}},{"idCelula":126,"cor":"#ffa500","pontoSupEsq":{"lat":-31.751412735352,"lng":-52.326874694614},"pontoInfDir":{"lat":-31.75015508542,"lng":-52.328353340984}},{"idCelula":127,"cor":"#ffa500","pontoSupEsq":{"lat":-31.751412726811,"lng":-52.325395726879},"pontoInfDir":{"lat":-31.750155076879,"lng":-52.326874353159}},{"idCelula":128,"cor":"#ffff00","pontoSupEsq":{"lat":-31.751412718269,"lng":-52.323916759144},"pontoInfDir":{"lat":-31.750155068337,"lng":-52.325395365334}},{"idCelula":129,"cor":"#ffff00","pontoSupEsq":{"lat":-31.751412709727,"lng":-52.322437791409},"pontoInfDir":{"lat":-31.750155059796,"lng":-52.323916377509}},{"idCelula":130,"cor":"#ff0000","pontoSupEsq":{"lat":-31.751412701185,"lng":-52.320958823674},"pontoInfDir":{"lat":-31.750155051255,"lng":-52.322437389685}},{"idCelula":131,"cor":"#ffa500","pontoSupEsq":{"lat":-31.751412692643,"lng":-52.31947985594},"pontoInfDir":{"lat":-31.750155042713,"lng":-52.32095840186}},{"idCelula":132,"cor":"#ffa500","pontoSupEsq":{"lat":-31.752670428001,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.751412778066,"lng":-52.337227267936}},{"idCelula":134,"cor":"#ff0000","pontoSupEsq":{"lat":-31.752670410916,"lng":-52.332790525376},"pontoInfDir":{"lat":-31.751412760982,"lng":-52.334269252103}},{"idCelula":135,"cor":"#ffa500","pontoSupEsq":{"lat":-31.752670402374,"lng":-52.331311537551},"pontoInfDir":{"lat":-31.751412752441,"lng":-52.332790244186}},{"idCelula":136,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670393832,"lng":-52.329832549726},"pontoInfDir":{"lat":-31.751412743899,"lng":-52.33131123627}},{"idCelula":138,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670376748,"lng":-52.326874574076},"pontoInfDir":{"lat":-31.751412726815,"lng":-52.328353220438}},{"idCelula":139,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670368205,"lng":-52.325395586251},"pontoInfDir":{"lat":-31.751412718273,"lng":-52.326874212522}},{"idCelula":140,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670359663,"lng":-52.323916598426},"pontoInfDir":{"lat":-31.751412709732,"lng":-52.325395204607}},{"idCelula":141,"cor":"#ff0000","pontoSupEsq":{"lat":-31.752670351121,"lng":-52.322437610602},"pontoInfDir":{"lat":-31.75141270119,"lng":-52.323916196691}},{"idCelula":142,"cor":"#ffff00","pontoSupEsq":{"lat":-31.752670342579,"lng":-52.320958622777},"pontoInfDir":{"lat":-31.751412692648,"lng":-52.322437188776}},{"idCelula":143,"cor":"#ffa500","pontoSupEsq":{"lat":-31.752670334037,"lng":-52.319479634953},"pontoInfDir":{"lat":-31.751412684106,"lng":-52.32095818086}},{"idCelula":145,"cor":"#ffff00","pontoSupEsq":{"lat":-31.753928060856,"lng":-52.334269493111},"pontoInfDir":{"lat":-31.752670410921,"lng":-52.335748239927}},{"idCelula":146,"cor":"#ffff00","pontoSupEsq":{"lat":-31.753928052313,"lng":-52.332790485194},"pontoInfDir":{"lat":-31.752670402379,"lng":-52.334269211918}},{"idCelula":147,"cor":"#ff0000","pontoSupEsq":{"lat":-31.753928043771,"lng":-52.331311477278},"pontoInfDir":{"lat":-31.752670393837,"lng":-52.33279018391}},{"idCelula":149,"cor":"#ff0000","pontoSupEsq":{"lat":-31.753928026686,"lng":-52.328353461446},"pontoInfDir":{"lat":-31.752670376753,"lng":-52.329832127893}},{"idCelula":150,"cor":"#ffff00","pontoSupEsq":{"lat":-31.753928018143,"lng":-52.32687445353},"pontoInfDir":{"lat":-31.75267036821,"lng":-52.328353099885}},{"idCelula":152,"cor":"#ffff00","pontoSupEsq":{"lat":-31.753928001058,"lng":-52.323916437699},"pontoInfDir":{"lat":-31.752670351126,"lng":-52.325395043869}},{"idCelula":153,"cor":"#ffff00","pontoSupEsq":{"lat":-31.753927992515,"lng":-52.322437429784},"pontoInfDir":{"lat":-31.752670342584,"lng":-52.323916015861}},{"idCelula":154,"cor":"#ffff00","pontoSupEsq":{"lat":-31.753927983972,"lng":-52.320958421868},"pontoInfDir":{"lat":-31.752670334042,"lng":-52.322436987854}},{"idCelula":155,"cor":"#ffff00","pontoSupEsq":{"lat":-31.75392797543,"lng":-52.319479413953},"pontoInfDir":{"lat":-31.752670325499,"lng":-52.320957959846}},{"idCelula":156,"cor":"#ffa500","pontoSupEsq":{"lat":-31.755185710796,"lng":-52.335748501027},"pontoInfDir":{"lat":-31.753928060861,"lng":-52.337227267936}},{"idCelula":157,"cor":"#ffff00","pontoSupEsq":{"lat":-31.755185702253,"lng":-52.334269473018},"pontoInfDir":{"lat":-31.753928052319,"lng":-52.335748219834}},{"idCelula":158,"cor":"#ffff00","pontoSupEsq":{"lat":-31.75518569371,"lng":-52.33279044501},"pontoInfDir":{"lat":-31.753928043776,"lng":-52.334269171731}},{"idCelula":161,"cor":"#ffff00","pontoSupEsq":{"lat":-31.755185668081,"lng":-52.328353360985},"pontoInfDir":{"lat":-31.753928018148,"lng":-52.329832027426}},{"idCelula":162,"cor":"#ffff00","pontoSupEsq":{"lat":-31.755185659538,"lng":-52.326874332977},"pontoInfDir":{"lat":-31.753928009606,"lng":-52.328352979324}},{"idCelula":165,"cor":"#ffff00","pontoSupEsq":{"lat":-31.755185633909,"lng":-52.322437248954},"pontoInfDir":{"lat":-31.753927983978,"lng":-52.323915835021}},{"idCelula":166,"cor":"#ffa500","pontoSupEsq":{"lat":-31.755185625366,"lng":-52.320958220947},"pontoInfDir":{"lat":-31.753927975435,"lng":-52.32243678692}},{"idCelula":167,"cor":"#ff0000","pontoSupEsq":{"lat":-31.755185616823,"lng":-52.319479192939},"pontoInfDir":{"lat":-31.753927966893,"lng":-52.320957738819}}]	2017-01-11 17:25:22.677826-02	\N
28	80	11	[]	2017-01-11 17:25:22.688548-02	\N
\.


--
-- Name: respostas_multicriterio_id_seq; Type: SEQUENCE SET; Schema: peopleplan; Owner: postgres
--

SELECT pg_catalog.setval('respostas_multicriterio_id_seq', 28, true);


SET search_path = public, pg_catalog;

--
-- Data for Name: ci_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ci_sessions (session_id, ip_address, user_agent, last_activity, user_data) FROM stdin;
f13cdadac6c56e0cf33c16db3120fd44	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:49.0) Gec	1479136352	\N
c885e7e9022ae242eb46a75296d500d9	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:50.0) Gec	1480256396	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3708:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
6546127ca98778a4ac52fd24dddf13c9	127.0.0.1	Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (	1426788224	\N
37931a0eb83518b34e3160f90e2cac4d	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:50.0) Gec	1480253909	\N
9cf8f1a845c3304679c58e92f17a0e63	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:50.0) Gec	1480254628	\N
77871b2e60aec977ea8ac5e0543bed4a	10.14.132.203	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) Ap	1427220629	\N
20b795e0bf4794ff5a49cc86108b054d	127.0.0.1	Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (	1425773570	a:2:{s:7:"usuario";s:231:"{"id":"14","pessoa_id":"15","login":"dudu","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"EDUARDO ROCHA","email":"amigodudu@yahoo.com.br","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"redmond"}";s:4:"menu";s:737:"<li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
8e1e660ee9b8881df903e895ca7da2da	127.0.0.1	Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (	1430392648	\N
626ce83a4353483a19e4dffe72507b06	10.14.132.203	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:3	1427223120	\N
1e31ff45b63373ab9a32f82391aa1492	10.14.132.203	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) Ap	1427223438	\N
274e0c5c4e07483d824b4c0f3ae9cffb	10.14.132.240	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) Ap	1429296293	\N
cc404d88712eab390592c087e028f2c6	10.14.132.203	Mozilla/5.0 (Linux; U; Android 2.1; en-us; GT-I900	1427215580	\N
9b03666033e89f363ae24edd06dc60ae	10.14.132.150	Mozilla/5.0 (iPad; CPU OS 8_1_2 like Mac OS X) App	1429303950	\N
efb50e3021f0ff9f258bb381c846ff65	10.14.132.203	Mozilla/5.0 (Linux; Android 4.3; Nexus 7 Build/JSS	1427215932	\N
58026569ffcb604104d3cb0023586e38	10.14.132.203	Mozilla/5.0 (Linux; U; Android 2.3; en-us; SAMSUNG	1427215946	\N
83f4357a7745307ce373ec3a6829b627	10.14.132.203	Mozilla/5.0 (Linux; U; Android 2.3; en-us; SAMSUNG	1427215965	\N
7eab3785081bedcb76762544d730d6b3	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:21.0) Gec	1427218812	\N
d19a58b1d8508d28d66efb91c059f4e7	10.14.132.186	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) Ap	1427392861	\N
108bad62c2e784ca5c728542b36d626d	10.14.132.240	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) Ap	1429295617	\N
b4f89ba460eeb3940cac634c9f066127	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:21.0) Gec	1429274682	\N
b8a7d2a8e854f370f9c4ad7475fcde14	10.14.132.240	Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 4 	1429296305	\N
2198c24bbb343de4e8e61a7d1f992c95	10.14.132.203	Mozilla/5.0 (Linux; Android 4.3; Nexus 7 Build/JSS	1427223240	\N
a45be41e281fa71545ceba7fad354528	10.14.132.203	Mozilla/5.0 (Linux; Android 4.3; Nexus 7 Build/JSS	1427224269	\N
7bf34643f371c11a3abbdaa5465f6fd1	10.14.132.186	Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 5 	1427394444	\N
2acd16ec62253ea25ef28864d1cf2742	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:49.0) Gec	1479509767	\N
a1fa14c325a08bc9824574ecf94dedd7	127.0.0.1	Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (	1426788219	a:2:{s:7:"usuario";s:239:"{"id":"4","pessoa_id":"5","login":"peil","senha":"ca031666132f6c7a24affa8fdb8ddaecc8b49f1f","nome_pessoa":"ANDR{{slash}}u00c9 PEIL","email":"andreguipeil@gmail.com","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"redmond"}";s:4:"menu";s:1462:"<li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
0c0540e4ed38171148f24f5274758976	10.14.132.203	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) Ap	1427215547	\N
15e142445e5ef06e30e0dfad2c537c22	10.14.132.203	Mozilla/5.0 (Linux; U; Android 4.0; en-us; LT28at 	1427215920	\N
ffda0f2053f93ebd4e4a62ba29f3a623	10.14.132.203	Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 5 	1427215941	\N
ea6e7f9270cf8804ddcbdd4de75e4449	10.14.132.203	Mozilla/5.0 (Linux; U; Android 2.2; en-us; SCH-I80	1427215951	\N
3fa898d1d355efb7ca46b8dcfc8e848e	10.14.132.203	Mozilla/5.0 (Linux; Android 4.3; Nexus 7 Build/JSS	1427218183	\N
d44de747ff87d42a9149fd46a926a387	10.14.132.240	Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 4 	1429296155	\N
6e5f857be6cc77f22a1b9aff96159dfa	10.14.132.240	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) Ap	1429297966	\N
29c69291b629daadaf30bbf9f684e100	10.14.132.150	Mozilla/5.0 (iPad; CPU OS 8_1_2 like Mac OS X) App	1429299260	\N
ce807201a6435563ca83023c7b934aa2	127.0.0.1	Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (	1428865511	a:2:{s:7:"usuario";s:239:"{"id":"4","pessoa_id":"5","login":"peil","senha":"ca031666132f6c7a24affa8fdb8ddaecc8b49f1f","nome_pessoa":"ANDR{{slash}}u00c9 PEIL","email":"andreguipeil@gmail.com","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"redmond"}";s:4:"menu";s:1462:"<li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
6b175b9b4e68f7c0c9740f95847d14b7	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:49.0) Gec	1478657961	\N
aa9743984a587e535a30ca557cf03702	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1482164579	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
94faff61b44feccdec3c2e45524d7b38	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1480459321	\N
9cc4fd0dec2ca401a12fb475ee197b77	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1482362125	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
fec4b59ef28ef91ef0d1b701a51c07f3	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1480649824	\N
81b95fc602ffcc7ba596e7324cacb9c9	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1480649874	\N
56e6f68122693e6f3469548ff72803d9	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1482411161	\N
303beef1e027802d40bf9a403d1fd466	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1481805280	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
0168cfe13fd4bce311796902dfbed38c	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1481904115	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
fe4a5eb70abbb09df51cffd26fe1f774	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1482110331	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
49d7a03dbb9fd30c24eccf01c077570d	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1484225224	\N
0a629988193e3361be3ed406c1c1539c	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1480639235	\N
3d571beb9b1cc09e636cbcc696b960f7	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1482166879	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
d4f2c7de1be27c2450f6e7f79a9d2bbe	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1480649073	\N
e1d3fa16273c3f03b5eb769e7227dfc3	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1481667168	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
f8ebd987a121420d2605bac7c7aed4ff	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1480650166	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
ad46a954dc882c50c15faba52728ef25	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1481507787	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
bff18fbeee1a023487a968e1ace26d2a	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1482079448	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
73e435b358ba5d886ae72bbc941a302a	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1484224536	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3353:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Critérios</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Perguntas</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
6736f153bd95a12200acda20eca0008d	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1484158166	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
e34c548e00e0347ed2ae3935d47a3da3	127.0.0.1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) G	1482498743	a:2:{s:7:"usuario";s:244:"{"id":"1","pessoa_id":"1","login":"admin","senha":"d033e22ae348aeb5660fc2140aec35850c4da997","nome_pessoa":"ADMINISTRADOR DO SISTEMA","email":"administrador@localhost","avatar_id":null,"nome_gerado":null,"nome_original":null,"tema":"cupertino"}";s:4:"menu";s:3357:"<li><span>Administração</span><ul style="background: none !important;"><li class="closed"><span>Sistema</span><ul style="background: none !important;"><li class="closed"><span>Usuários e Módulos</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/usuario">Usuários</a></li><li><a href="http://localhost/peoplegrid/gerenciador/perfil">Módulos</a></li><li><a href="http://localhost/peoplegrid/gerenciador/grupoAcesso">Grupos de Acesso</a></li></ul></li><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/parametro">Parâmetros</a></li><li><a href="http://localhost/peoplegrid/gerenciador/programa">Programas</a></li><li><a href="http://localhost/peoplegrid/gerenciador/empresa">Setores</a></li></ul></li></ul></li></ul></li><li><span>PeopleGrid</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisador">Pesquisadores</a></li></ul></li><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/pesquisa">Questionários</a></li><li><a href="http://localhost/peoplegrid/coordenador/perguntas">Perguntas</a></li></ul></li><li class="closed"><span>Configurações</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/gerenciador/configuracao">Email do Servidor</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/pergunta">Perguntas em Grid</a></li><li><a href="http://localhost/peoplegrid/pesquisador/perguntaDinamica">Perguntas Dinâmicas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/questionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/resultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li><li><span>PeoplePlan</span><ul style="background: none !important;"><li class="closed"><span>Gerenciador</span><ul style="background: none !important;"><li class="closed"><span>Pesquisas</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPerguntas">Perguntas</a></li><li><a href="http://localhost/peoplegrid/coordenador/peopleplanPesquisa">Questionários</a></li></ul></li></ul></li><li class="closed"><span>Pesquisador</span><ul style="background: none !important;"><li class="closed"><span>Cadastrar</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanPergunta">Perguntas</a></li><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanQuestionario">Questionários</a></li></ul></li><li class="closed"><span>Relatórios</span><ul style="background: none !important;"><li><a href="http://localhost/peoplegrid/pesquisador/peopleplanResultado">Resultado de Questionários</a></li></ul></li></ul></li></ul></li>";}
\.


--
-- Data for Name: cidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cidades (id, unidade_federativa_id, nome, dt_cadastro) FROM stdin;
1	1	ACRELÂNDIA	2010-03-11 00:00:00
2	1	ASSIS BRASIL	2010-03-11 00:00:00
4	1	BUJARI	2010-03-11 00:00:00
5	1	CAPIXABA	2010-03-11 00:00:00
6	1	CRUZEIRO DO SUL	2010-03-11 00:00:00
7	1	EPITACIOLÂNDIA	2010-03-11 00:00:00
8	1	FEIJÓ	2010-03-11 00:00:00
9	1	JORDÃO	2010-03-11 00:00:00
10	1	MANCIO LIMA	2010-03-11 00:00:00
11	1	MANOEL URBANO	2010-03-11 00:00:00
12	1	MARECHAL THAUMATURGO	2010-03-11 00:00:00
13	1	PLÁCIDO DE CASTRO	2010-03-11 00:00:00
14	1	PORTO ACRE	2010-03-11 00:00:00
15	1	PORTO WALTER	2010-03-11 00:00:00
16	1	RIO BRANCO	2010-03-11 00:00:00
17	1	RODRIGUES ALVES	2010-03-11 00:00:00
18	1	SANTA ROSA DO PURUS	2010-03-11 00:00:00
19	1	SENA MADUREIRA	2010-03-11 00:00:00
20	1	SENADOR GUIOMARD	2010-03-11 00:00:00
21	1	TARAUACÁ	2010-03-11 00:00:00
22	1	XAPURI	2010-03-11 00:00:00
23	2	ÁGUA BRANCA	2010-03-11 00:00:00
24	2	ANADIA	2010-03-11 00:00:00
25	2	ARAPIRACA	2010-03-11 00:00:00
26	2	ATALAIA	2010-03-11 00:00:00
27	2	BARRA DE SANTO ANTÔNIO	2010-03-11 00:00:00
28	2	BARRA DE SÃO MIGUEL	2010-03-11 00:00:00
29	2	BATALHA	2010-03-11 00:00:00
30	2	BELÉM	2010-03-11 00:00:00
31	2	BELO MONTE	2010-03-11 00:00:00
32	2	BOCA DA MATA	2010-03-11 00:00:00
33	2	BRANQUINHA	2010-03-11 00:00:00
34	2	CACIMBINHAS	2010-03-11 00:00:00
35	2	CAJUEIRO	2010-03-11 00:00:00
36	2	CAMPESTRE	2010-03-11 00:00:00
37	2	CAMPO ALEGRE	2010-03-11 00:00:00
38	2	CAMPO GRANDE	2010-03-11 00:00:00
39	2	CANAPI	2010-03-11 00:00:00
40	2	CAPELA	2010-03-11 00:00:00
41	2	CARNEIROS	2010-03-11 00:00:00
42	2	CHÃ PRETA	2010-03-11 00:00:00
43	2	COITÉ DO NÓIA	2010-03-11 00:00:00
44	2	COLÔNIA LEOPOLDINA	2010-03-11 00:00:00
45	2	COQUEIRO SECO	2010-03-11 00:00:00
46	2	CORURIPE	2010-03-11 00:00:00
47	2	CRAIBAS	2010-03-11 00:00:00
48	2	DELMIRO GOUVEIA	2010-03-11 00:00:00
49	2	DOIS RIACHOS	2010-03-11 00:00:00
50	2	ESTRELA DE ALAGOAS	2010-03-11 00:00:00
51	2	FEIRA GRANDE	2010-03-11 00:00:00
52	2	FELIZ DESERTO	2010-03-11 00:00:00
53	2	FLEXEIRAS	2010-03-11 00:00:00
54	2	GIRAU DO PONCIANO	2010-03-11 00:00:00
55	2	IBATEGUARA	2010-03-11 00:00:00
56	2	IGACI	2010-03-11 00:00:00
57	2	IGREJA NOVA	2010-03-11 00:00:00
58	2	INHAPI	2010-03-11 00:00:00
59	2	JACARÉ DOS HOMENS	2010-03-11 00:00:00
60	2	JACUÍPE	2010-03-11 00:00:00
61	2	JAPARATINGA	2010-03-11 00:00:00
62	2	JARAMATAIA	2010-03-11 00:00:00
63	2	JEQUIÁ DA PRAIA	2010-03-11 00:00:00
64	2	JOAQUIM GOMES	2010-03-11 00:00:00
65	2	JUNDIÁ	2010-03-11 00:00:00
66	2	JUNQUEIRO	2010-03-11 00:00:00
67	2	LAGOA DA CANOA	2010-03-11 00:00:00
68	2	LIMOEIRO DE ANADIA	2010-03-11 00:00:00
69	2	MACEIÓ	2010-03-11 00:00:00
70	2	MAJOR ISIDORO	2010-03-11 00:00:00
71	2	MAR VERMELHO	2010-03-11 00:00:00
72	2	MARAGOGI	2010-03-11 00:00:00
73	2	MARAVILHA	2010-03-11 00:00:00
74	2	MARECHAL DEODORO	2010-03-11 00:00:00
75	2	MARIBONDO	2010-03-11 00:00:00
76	2	MATA GRANDE	2010-03-11 00:00:00
77	2	MATRIZ DE CAMARAGIBE	2010-03-11 00:00:00
78	2	MESSIAS	2010-03-11 00:00:00
79	2	MINADOR DO NEGRÃO	2010-03-11 00:00:00
80	2	MONTEIRÓPOLIS	2010-03-11 00:00:00
81	2	MURICI	2010-03-11 00:00:00
82	2	NOVO LINO	2010-03-11 00:00:00
83	2	OLHO D  ÁGUA DO CASADO	2010-03-11 00:00:00
84	2	OLHO D ÁGUA DAS FLORES	2010-03-11 00:00:00
85	2	OLHO D ÁGUA GRANDE	2010-03-11 00:00:00
86	2	OLIVENÇA	2010-03-11 00:00:00
87	2	OURO BRANCO	2010-03-11 00:00:00
88	2	PALESTINA	2010-03-11 00:00:00
89	2	PALMEIRA DOS ÍNDIOS	2010-03-11 00:00:00
90	2	PÃO DE AÇÚCAR	2010-03-11 00:00:00
91	2	PARICONHA	2010-03-11 00:00:00
92	2	PARIPUEIRA	2010-03-11 00:00:00
93	2	PASSO DE CAMARAGIBE	2010-03-11 00:00:00
94	2	PAULO JACINTO	2010-03-11 00:00:00
95	2	PENEDO	2010-03-11 00:00:00
96	2	PIAÇABUCU	2010-03-11 00:00:00
97	2	PILAR	2010-03-11 00:00:00
98	2	PINDOBA	2010-03-11 00:00:00
99	2	PIRANHAS	2010-03-11 00:00:00
100	2	POÇO DAS TRINCHEIRAS	2010-03-11 00:00:00
101	2	PORTO CALVO	2010-03-11 00:00:00
102	2	PORTO DE PEDRAS	2010-03-11 00:00:00
103	2	PORTO REAL DO COLÉGIO	2010-03-11 00:00:00
104	2	QUEBRÂNGULO	2010-03-11 00:00:00
105	2	RIO LARGO	2010-03-11 00:00:00
106	2	ROTEIRO	2010-03-11 00:00:00
107	2	SANTA LUZIA DO NORTE	2010-03-11 00:00:00
108	2	SANTANA DE IPANEMA	2010-03-11 00:00:00
109	2	SANTANA DO MUNDAU	2010-03-11 00:00:00
110	2	SÃO BRÁS	2010-03-11 00:00:00
111	2	SÃO JOSÉ DA LAJE	2010-03-11 00:00:00
112	2	SÃO JOSÉ DA TAPERA	2010-03-11 00:00:00
113	2	SÃO LUÍS DO QUITUNDE	2010-03-11 00:00:00
114	2	SÃO MIGUEL DOS CAMPOS	2010-03-11 00:00:00
115	2	SÃO MIGUEL DOS MILAGRES	2010-03-11 00:00:00
116	2	SÃO SEBASTIÃO	2010-03-11 00:00:00
117	2	SATUBA	2010-03-11 00:00:00
118	2	SENADOR RUI PALMEIRA	2010-03-11 00:00:00
119	2	TANQUE D ARCA	2010-03-11 00:00:00
120	2	TAQUARANA	2010-03-11 00:00:00
121	2	TEOTÔNIO VILELA	2010-03-11 00:00:00
122	2	TRAIPU	2010-03-11 00:00:00
123	2	UNIÃO DOS PALMARES	2010-03-11 00:00:00
124	2	VIÇOSA	2010-03-11 00:00:00
125	3	ALVARÃES	2010-03-11 00:00:00
126	3	AMATURA	2010-03-11 00:00:00
127	3	ANAMÃ	2010-03-11 00:00:00
128	3	ANORI	2010-03-11 00:00:00
129	3	APUI	2010-03-11 00:00:00
130	3	ATALAIA DO NORTE	2010-03-11 00:00:00
131	3	AUTAZES	2010-03-11 00:00:00
132	3	BARCELOS	2010-03-11 00:00:00
133	3	BARREIRINHA	2010-03-11 00:00:00
134	3	BENJAMIN CONSTANT	2010-03-11 00:00:00
135	3	BERURI	2010-03-11 00:00:00
136	3	BOA VISTA DO RAMOS	2010-03-11 00:00:00
137	3	BOCA DO ACRE	2010-03-11 00:00:00
138	3	BORBA	2010-03-11 00:00:00
139	3	CAAPIRANGA	2010-03-11 00:00:00
140	3	CANUTAMA	2010-03-11 00:00:00
141	3	CARAUARI	2010-03-11 00:00:00
142	3	CAREIRO	2010-03-11 00:00:00
143	3	CAREIRO DA VÁRZEA	2010-03-11 00:00:00
144	3	COARI	2010-03-11 00:00:00
145	3	CODAJÁS	2010-03-11 00:00:00
146	3	EIRUNEPE	2010-03-11 00:00:00
147	3	ENVIRA	2010-03-11 00:00:00
148	3	FONTE BOA	2010-03-11 00:00:00
149	3	GUAJARÁ	2010-03-11 00:00:00
150	3	HUMAITÁ	2010-03-11 00:00:00
151	3	IPIXUNA	2010-03-11 00:00:00
152	3	IRANDUBA	2010-03-11 00:00:00
153	3	ITACOATIARA	2010-03-11 00:00:00
154	3	ITAMARATI	2010-03-11 00:00:00
155	3	ITAPIRANGA	2010-03-11 00:00:00
156	3	JAPURÁ	2010-03-11 00:00:00
157	3	JURUÁ	2010-03-11 00:00:00
158	3	JUTAI	2010-03-11 00:00:00
159	3	LABREA	2010-03-11 00:00:00
160	3	MANACAPURU	2010-03-11 00:00:00
161	3	MANAQUIRI	2010-03-11 00:00:00
162	3	MANAUS	2010-03-11 00:00:00
163	3	MANICORÉ	2010-03-11 00:00:00
164	3	MARAÃ	2010-03-11 00:00:00
165	3	MAUÉS	2010-03-11 00:00:00
166	3	NHAMUNDA	2010-03-11 00:00:00
167	3	NOVA OLINDA DO NORTE	2010-03-11 00:00:00
168	3	NOVO AIRÃO	2010-03-11 00:00:00
169	3	NOVO ARIPUANÃ	2010-03-11 00:00:00
170	3	PARINTINS	2010-03-11 00:00:00
171	3	PAUINI	2010-03-11 00:00:00
172	3	PRESIDENTE FIGUEIREDO	2010-03-11 00:00:00
173	3	RIO PRETO DA EVA	2010-03-11 00:00:00
174	3	SANTA ISABEL DO RIO NEGRO	2010-03-11 00:00:00
175	3	SANTO ANTONIO  DO IÇÁ	2010-03-11 00:00:00
176	3	SÃO GABRIEL DA CACHOEIRA	2010-03-11 00:00:00
177	3	SÃO PAULO DE OLIVENÇA	2010-03-11 00:00:00
178	3	SÃO SEBASTIÃO DO UATUMÃ	2010-03-11 00:00:00
179	3	SILVES	2010-03-11 00:00:00
180	3	TABATINGA	2010-03-11 00:00:00
181	3	TAPAUA	2010-03-11 00:00:00
182	3	TEFÉ	2010-03-11 00:00:00
183	3	TONANTINS	2010-03-11 00:00:00
184	3	UARINI	2010-03-11 00:00:00
185	3	URUCARA	2010-03-11 00:00:00
186	3	URUCURITUBA	2010-03-11 00:00:00
187	4	AMAPÁ	2010-03-11 00:00:00
188	4	CALÇOENE	2010-03-11 00:00:00
189	4	CUTIAS	2010-03-11 00:00:00
190	4	FERREIRA GOMES	2010-03-11 00:00:00
191	4	ITAUBAL	2010-03-11 00:00:00
192	4	LARANJAL DO JARI	2010-03-11 00:00:00
193	4	MACAPÁ	2010-03-11 00:00:00
194	4	MAZAGÃO	2010-03-11 00:00:00
195	4	OIAPOQUE	2010-03-11 00:00:00
196	4	PEDRA BRANCA DO AMAPARI	2010-03-11 00:00:00
197	4	PORTO GRANDE	2010-03-11 00:00:00
198	4	PRACUUBA	2010-03-11 00:00:00
199	4	SANTANA	2010-03-11 00:00:00
200	4	SERRA DO NAVIO	2010-03-11 00:00:00
201	4	TARTARUGALZINHO	2010-03-11 00:00:00
202	4	VITÓRIA DO JARI	2010-03-11 00:00:00
203	5	ABAIRA	2010-03-11 00:00:00
204	5	ABARÉ	2010-03-11 00:00:00
205	5	ACAJUTIBA	2010-03-11 00:00:00
206	5	ADUSTINA	2010-03-11 00:00:00
207	5	ÁGUA FRIA	2010-03-11 00:00:00
208	5	AIQUARA	2010-03-11 00:00:00
209	5	ALAGOINHAS	2010-03-11 00:00:00
210	5	ALCOBAÇA	2010-03-11 00:00:00
211	5	ALMADINA	2010-03-11 00:00:00
212	5	AMARGOSA	2010-03-11 00:00:00
213	5	AMÉLIA RODRIGUES	2010-03-11 00:00:00
214	5	AMÉRICA DOURADA	2010-03-11 00:00:00
215	5	ANAGE	2010-03-11 00:00:00
216	5	ANDARAÍ	2010-03-11 00:00:00
217	5	ANDORINHA	2010-03-11 00:00:00
218	5	ANGICAL	2010-03-11 00:00:00
219	5	ANGUERA	2010-03-11 00:00:00
220	5	ANTAS	2010-03-11 00:00:00
221	5	ANTÔNIO CARDOSO	2010-03-11 00:00:00
222	5	ANTÔNIO GONÇALVES	2010-03-11 00:00:00
223	5	APORA	2010-03-11 00:00:00
224	5	APUAREMA	2010-03-11 00:00:00
225	5	ARAÇAS	2010-03-11 00:00:00
226	5	ARACATU	2010-03-11 00:00:00
227	5	ARACI	2010-03-11 00:00:00
228	5	ARAMARI	2010-03-11 00:00:00
229	5	ARATACA	2010-03-11 00:00:00
230	5	ARATUIPE	2010-03-11 00:00:00
231	5	AURELINO LEAL	2010-03-11 00:00:00
232	5	BAIANÓPOLIS	2010-03-11 00:00:00
233	5	BAIXA GRANDE	2010-03-11 00:00:00
234	5	BANZAE	2010-03-11 00:00:00
235	5	BARRA	2010-03-11 00:00:00
236	5	BARRA DA ESTIVA	2010-03-11 00:00:00
237	5	BARRA DO CHOÇA	2010-03-11 00:00:00
238	5	BARRA DO MENDES	2010-03-11 00:00:00
239	5	BARRA DO ROCHA	2010-03-11 00:00:00
240	5	BARREIRAS	2010-03-11 00:00:00
241	5	BARRO ALTO	2010-03-11 00:00:00
242	5	BARRO PRETO	2010-03-11 00:00:00
243	5	BARROCAS	2010-03-11 00:00:00
244	5	BELMONTE	2010-03-11 00:00:00
245	5	BELO CAMPO	2010-03-11 00:00:00
246	5	BIRITINGA	2010-03-11 00:00:00
247	5	BOA NOVA	2010-03-11 00:00:00
248	5	BOA VISTA DO TUPIM	2010-03-11 00:00:00
249	5	BOM JESUS DA LAPA	2010-03-11 00:00:00
250	5	BOM JESUS DA SERRA	2010-03-11 00:00:00
251	5	BONINAL	2010-03-11 00:00:00
252	5	BONITO	2010-03-11 00:00:00
253	5	BOQUIRA	2010-03-11 00:00:00
254	5	BOTUPORÃ	2010-03-11 00:00:00
255	5	BREJÕES	2010-03-11 00:00:00
256	5	BREJOLÂNDIA	2010-03-11 00:00:00
257	5	BROTAS DE MACAUBAS	2010-03-11 00:00:00
258	5	BRUMADO	2010-03-11 00:00:00
259	5	BUERAREMA	2010-03-11 00:00:00
260	5	BURITIRAMA	2010-03-11 00:00:00
261	5	CAATIBA	2010-03-11 00:00:00
262	5	CABACEIRAS DO PARAGUAÇU	2010-03-11 00:00:00
263	5	CACHOEIRA	2010-03-11 00:00:00
264	5	CACULÉ	2010-03-11 00:00:00
265	5	CAEM	2010-03-11 00:00:00
266	5	CAETANOS	2010-03-11 00:00:00
267	5	CAETITÉ	2010-03-11 00:00:00
268	5	CAFARNAUM	2010-03-11 00:00:00
269	5	CAIRU	2010-03-11 00:00:00
270	5	CALDEIRÃO GRANDE	2010-03-11 00:00:00
271	5	CAMACAN	2010-03-11 00:00:00
272	5	CAMAÇARI	2010-03-11 00:00:00
273	5	CAMAMU	2010-03-11 00:00:00
274	5	CAMPO ALEGRE DE LOURDES	2010-03-11 00:00:00
275	5	CAMPO FORMOSO	2010-03-11 00:00:00
276	5	CANÁPOLIS	2010-03-11 00:00:00
277	5	CANARANA	2010-03-11 00:00:00
278	5	CANAVIEIRAS	2010-03-11 00:00:00
279	5	CANDEAL	2010-03-11 00:00:00
280	5	CANDEIAS	2010-03-11 00:00:00
281	5	CANDIBA	2010-03-11 00:00:00
282	5	CÂNDIDO SALES	2010-03-11 00:00:00
283	5	CANSANÇÃO	2010-03-11 00:00:00
284	5	CANUDOS	2010-03-11 00:00:00
285	5	CAPELA DO ALTO ALEGRE	2010-03-11 00:00:00
286	5	CAPIM GROSSO	2010-03-11 00:00:00
287	5	CARAÍBAS	2010-03-11 00:00:00
288	5	CARAVELAS	2010-03-11 00:00:00
289	5	CARDEAL DA SILVA	2010-03-11 00:00:00
290	5	CARINHANHA	2010-03-11 00:00:00
291	5	CASA NOVA	2010-03-11 00:00:00
292	5	CASTRO ALVES	2010-03-11 00:00:00
293	5	CATOLÂNDIA	2010-03-11 00:00:00
294	5	CATU	2010-03-11 00:00:00
295	5	CATURAMA	2010-03-11 00:00:00
296	5	CENTRAL	2010-03-11 00:00:00
297	5	CHORROCHO	2010-03-11 00:00:00
298	5	CÍCERO DANTAS	2010-03-11 00:00:00
299	5	CIPÓ	2010-03-11 00:00:00
300	5	COARACI	2010-03-11 00:00:00
301	5	COCOS	2010-03-11 00:00:00
302	5	CONCEIÇÃO DA FEIRA	2010-03-11 00:00:00
303	5	CONCEIÇÃO DO ALMEIDA	2010-03-11 00:00:00
304	5	CONCEIÇÃO DO COITÉ	2010-03-11 00:00:00
305	5	CONCEIÇÃO DO JACUÍPE	2010-03-11 00:00:00
306	5	CONDE	2010-03-11 00:00:00
307	5	CONDEUBA	2010-03-11 00:00:00
308	5	CONTENDAS DO SINCORÁ	2010-03-11 00:00:00
309	5	CORAÇÃO DE MARIA	2010-03-11 00:00:00
310	5	CORDEIROS	2010-03-11 00:00:00
311	5	CORIBE	2010-03-11 00:00:00
312	5	CORONEL JOÃO SÁ	2010-03-11 00:00:00
313	5	CORRENTINA	2010-03-11 00:00:00
314	5	COTEGIPE	2010-03-11 00:00:00
315	5	CRAVOLÂNDIA	2010-03-11 00:00:00
316	5	CRISÓPOLIS	2010-03-11 00:00:00
317	5	CRISTÓPOLIS	2010-03-11 00:00:00
318	5	CRUZ DAS ALMAS	2010-03-11 00:00:00
319	5	CURAÇA	2010-03-11 00:00:00
320	5	DARIO MEIRA	2010-03-11 00:00:00
321	5	DIAS D ÁVILA	2010-03-11 00:00:00
322	5	DOM BASÍLIO	2010-03-11 00:00:00
323	5	DOM MACEDO COSTA	2010-03-11 00:00:00
324	5	ELÍSIO MEDRADO	2010-03-11 00:00:00
325	5	ENCRUZILHADA	2010-03-11 00:00:00
326	5	ENTRE RIOS	2010-03-11 00:00:00
327	5	ÉRICO CARDOSO	2010-03-11 00:00:00
328	5	ESPLANADA	2010-03-11 00:00:00
329	5	EUCLIDES DA CUNHA	2010-03-11 00:00:00
330	5	EUNÁPOLIS	2010-03-11 00:00:00
331	5	FÁTIMA	2010-03-11 00:00:00
332	5	FEIRA DA MATA	2010-03-11 00:00:00
333	5	FEIRA DE SANTANA	2010-03-11 00:00:00
334	5	FILADÉLFIA	2010-03-11 00:00:00
335	5	FIRMINO ALVES	2010-03-11 00:00:00
336	5	FLORESTA AZUL	2010-03-11 00:00:00
337	5	FORMOSA DO RIO PRETO	2010-03-11 00:00:00
338	5	GANDU	2010-03-11 00:00:00
339	5	GAVIÃO	2010-03-11 00:00:00
340	5	GENTIO DO OURO	2010-03-11 00:00:00
341	5	GLÓRIA	2010-03-11 00:00:00
342	5	GONGOGI	2010-03-11 00:00:00
343	5	GOVERNADOR MANGABEIRA	2010-03-11 00:00:00
344	5	GUAJERU	2010-03-11 00:00:00
345	5	GUANAMBI	2010-03-11 00:00:00
346	5	GUARATINGA	2010-03-11 00:00:00
347	5	HELIÓPOLIS	2010-03-11 00:00:00
348	5	IAÇU	2010-03-11 00:00:00
349	5	IBIASSUCE	2010-03-11 00:00:00
350	5	IBICARAÍ	2010-03-11 00:00:00
351	5	IBICOARA	2010-03-11 00:00:00
352	5	IBICUÍ	2010-03-11 00:00:00
353	5	IBIPEBA	2010-03-11 00:00:00
354	5	IBIPITANGA	2010-03-11 00:00:00
355	5	IBIQUERA	2010-03-11 00:00:00
356	5	IBIRAPITANGA	2010-03-11 00:00:00
357	5	IBIRAPUÃ	2010-03-11 00:00:00
358	5	IBIRATAIA	2010-03-11 00:00:00
359	5	IBITIARA	2010-03-11 00:00:00
360	5	IBITITA	2010-03-11 00:00:00
361	5	IBOTIRAMA	2010-03-11 00:00:00
362	5	ICHU	2010-03-11 00:00:00
363	5	IGAPORÃ	2010-03-11 00:00:00
364	5	IGRAPIUNA	2010-03-11 00:00:00
365	5	IGUAI	2010-03-11 00:00:00
366	5	ILHÉUS	2010-03-11 00:00:00
367	5	INHAMBUPE	2010-03-11 00:00:00
368	5	IPECAETÁ	2010-03-11 00:00:00
369	5	IPIAU	2010-03-11 00:00:00
370	5	IPIRA	2010-03-11 00:00:00
371	5	IPUPIARA	2010-03-11 00:00:00
372	5	IRAJUBA	2010-03-11 00:00:00
373	5	IRAMAIA	2010-03-11 00:00:00
374	5	IRAQUARA	2010-03-11 00:00:00
375	5	IRARA	2010-03-11 00:00:00
376	5	IRECÊ	2010-03-11 00:00:00
377	5	ITABELA	2010-03-11 00:00:00
378	5	ITABERABA	2010-03-11 00:00:00
379	5	ITABUNA	2010-03-11 00:00:00
380	5	ITACARÉ	2010-03-11 00:00:00
381	5	ITAETE	2010-03-11 00:00:00
382	5	ITAGI	2010-03-11 00:00:00
383	5	ITAGIBA	2010-03-11 00:00:00
384	5	ITAGIMIRIM	2010-03-11 00:00:00
385	5	ITAGUAÇU DA BAHIA	2010-03-11 00:00:00
386	5	ITAJU DO COLÔNIA	2010-03-11 00:00:00
387	5	ITAJUIPE	2010-03-11 00:00:00
388	5	ITAMARAJU	2010-03-11 00:00:00
389	5	ITAMARI	2010-03-11 00:00:00
390	5	ITAMBÉ	2010-03-11 00:00:00
391	5	ITANAGRA	2010-03-11 00:00:00
392	5	ITANHEM	2010-03-11 00:00:00
393	5	ITAPARICA	2010-03-11 00:00:00
394	5	ITAPÉ	2010-03-11 00:00:00
395	5	ITAPEBI	2010-03-11 00:00:00
396	5	ITAPETINGA	2010-03-11 00:00:00
397	5	ITAPICURU	2010-03-11 00:00:00
398	5	ITAPITANGA	2010-03-11 00:00:00
399	5	ITAQUARA	2010-03-11 00:00:00
400	5	ITARANTIM	2010-03-11 00:00:00
401	5	ITATIM	2010-03-11 00:00:00
402	5	ITIRUÇU	2010-03-11 00:00:00
403	5	ITIUBA	2010-03-11 00:00:00
404	5	ITORORÓ	2010-03-11 00:00:00
405	5	ITUAÇU	2010-03-11 00:00:00
406	5	ITUBERA	2010-03-11 00:00:00
407	5	IUIU	2010-03-11 00:00:00
408	5	JABORANDI	2010-03-11 00:00:00
409	5	JACARACI	2010-03-11 00:00:00
410	5	JACOBINA	2010-03-11 00:00:00
411	5	JAGUAQUARA	2010-03-11 00:00:00
412	5	JAGUARARI	2010-03-11 00:00:00
413	5	JAGUARIPE	2010-03-11 00:00:00
414	5	JANDAÍRA	2010-03-11 00:00:00
415	5	JEQUIÉ	2010-03-11 00:00:00
416	5	JEREMOABO	2010-03-11 00:00:00
417	5	JIQUIRIÇA	2010-03-11 00:00:00
418	5	JITAUNA	2010-03-11 00:00:00
419	5	JOÃO DOURADO	2010-03-11 00:00:00
420	5	JUAZEIRO	2010-03-11 00:00:00
421	5	JUCURUÇU	2010-03-11 00:00:00
422	5	JUSSARA	2010-03-11 00:00:00
423	5	JUSSARI	2010-03-11 00:00:00
424	5	JUSSIAPE	2010-03-11 00:00:00
425	5	LAFAIETE COUTINHO	2010-03-11 00:00:00
426	5	LAGOA REAL	2010-03-11 00:00:00
427	5	LAJE	2010-03-11 00:00:00
428	5	LAJEDÃO	2010-03-11 00:00:00
429	5	LAJEDINHO	2010-03-11 00:00:00
430	5	LAJEDO DO TABOCAL	2010-03-11 00:00:00
431	5	LAMARÃO	2010-03-11 00:00:00
432	5	LAPÃO	2010-03-11 00:00:00
433	5	LAURO DE FREITAS	2010-03-11 00:00:00
434	5	LENÇOIS	2010-03-11 00:00:00
435	5	LICINIO DE ALMEIDA	2010-03-11 00:00:00
436	5	LIVRAMENTO DE NOSSA SENHORA	2010-03-11 00:00:00
437	5	LUIS EDUARDO MAGALHÃES	2010-03-11 00:00:00
438	5	MACAJUBA	2010-03-11 00:00:00
439	5	MACARANI	2010-03-11 00:00:00
440	5	MACAUBAS	2010-03-11 00:00:00
441	5	MACURURE	2010-03-11 00:00:00
442	5	MADRE DE DEUS	2010-03-11 00:00:00
443	5	MAETINGA	2010-03-11 00:00:00
444	5	MAIQUINIQUE	2010-03-11 00:00:00
445	5	MAIRI	2010-03-11 00:00:00
446	5	MALHADA	2010-03-11 00:00:00
447	5	MALHADA DE PEDRAS	2010-03-11 00:00:00
448	5	MANOEL VITORINO	2010-03-11 00:00:00
449	5	MANSIDÃO	2010-03-11 00:00:00
450	5	MARACAS	2010-03-11 00:00:00
451	5	MARAGOGIPE	2010-03-11 00:00:00
452	5	MARAU	2010-03-11 00:00:00
453	5	MARCIONÍLIO SOUZA	2010-03-11 00:00:00
454	5	MASCOTE	2010-03-11 00:00:00
455	5	MATA DE SÃO JOÃO	2010-03-11 00:00:00
456	5	MATINA	2010-03-11 00:00:00
457	5	MEDEIROS NETO	2010-03-11 00:00:00
458	5	MIGUEL CALMON	2010-03-11 00:00:00
459	5	MILAGRES	2010-03-11 00:00:00
460	5	MIRANGABA	2010-03-11 00:00:00
461	5	MIRANTE	2010-03-11 00:00:00
462	5	MONTE SANTO	2010-03-11 00:00:00
463	5	MORPARA	2010-03-11 00:00:00
464	5	MORRO DO CHAPÉU	2010-03-11 00:00:00
465	5	MORTUGABA	2010-03-11 00:00:00
466	5	MUCUGE	2010-03-11 00:00:00
467	5	MUCURI	2010-03-11 00:00:00
468	5	MULUNGU DO MORRO	2010-03-11 00:00:00
469	5	MUNDO NOVO	2010-03-11 00:00:00
470	5	MUNIZ FERREIRA	2010-03-11 00:00:00
471	5	MUQUEM DE SÃO FRANCISCO	2010-03-11 00:00:00
472	5	MURITIBA	2010-03-11 00:00:00
473	5	MUTUÍPE	2010-03-11 00:00:00
474	5	NAZARÉ	2010-03-11 00:00:00
475	5	NILO PEÇANHA	2010-03-11 00:00:00
476	5	NORDESTINA	2010-03-11 00:00:00
477	5	NOVA CANAÃ	2010-03-11 00:00:00
478	5	NOVA FÁTIMA	2010-03-11 00:00:00
479	5	NOVA IBIA	2010-03-11 00:00:00
480	5	NOVA ITARANA	2010-03-11 00:00:00
481	5	NOVA REDENÇÃO	2010-03-11 00:00:00
482	5	NOVA SOURÉ	2010-03-11 00:00:00
483	5	NOVA VIÇOSA	2010-03-11 00:00:00
484	5	NOVO HORIZONTE	2010-03-11 00:00:00
485	5	NOVO TRIUNFO	2010-03-11 00:00:00
486	5	OLINDINA	2010-03-11 00:00:00
487	5	OLIVEIRA DOS BREJINHOS	2010-03-11 00:00:00
488	5	OURIÇANGAS	2010-03-11 00:00:00
489	5	OUROLÂNDIA	2010-03-11 00:00:00
490	5	PALMAS DE MONTE ALTO	2010-03-11 00:00:00
491	5	PALMEIRAS	2010-03-11 00:00:00
492	5	PARAMIRIM	2010-03-11 00:00:00
493	5	PARATINGA	2010-03-11 00:00:00
494	5	PARIPIRANGA	2010-03-11 00:00:00
495	5	PAU BRASIL	2010-03-11 00:00:00
496	5	PAULO AFONSO	2010-03-11 00:00:00
497	5	PÉ DE SERRA	2010-03-11 00:00:00
498	5	PEDRÃO	2010-03-11 00:00:00
499	5	PEDRO ALEXANDRE	2010-03-11 00:00:00
500	5	PIATÃ	2010-03-11 00:00:00
501	5	PILÃO ARCADO	2010-03-11 00:00:00
502	5	PINDAI	2010-03-11 00:00:00
503	5	PINDOBAÇU	2010-03-11 00:00:00
504	5	PINTADAS	2010-03-11 00:00:00
505	5	PIRAÍ DO NORTE	2010-03-11 00:00:00
506	5	PIRIPA	2010-03-11 00:00:00
507	5	PIRITIBA	2010-03-11 00:00:00
508	5	PLANALTINO	2010-03-11 00:00:00
509	5	PLANALTO	2010-03-11 00:00:00
510	5	POÇÕES	2010-03-11 00:00:00
511	5	POJUCA	2010-03-11 00:00:00
512	5	PONTO NOVO	2010-03-11 00:00:00
513	5	PORTO SEGURO	2010-03-11 00:00:00
514	5	POTIRAGUA	2010-03-11 00:00:00
515	5	PRADO	2010-03-11 00:00:00
516	5	PRESIDENTE DUTRA	2010-03-11 00:00:00
517	5	PRESIDENTE JÂNIO QUADROS	2010-03-11 00:00:00
518	5	PRESIDENTE TANCREDO NEVES	2010-03-11 00:00:00
519	5	QUEIMADAS	2010-03-11 00:00:00
520	5	QUIJINGUE	2010-03-11 00:00:00
521	5	QUIXABEIRA	2010-03-11 00:00:00
522	5	RAFAEL JAMBEIRO	2010-03-11 00:00:00
523	5	REMANSO	2010-03-11 00:00:00
524	5	RETIROLÂNDIA	2010-03-11 00:00:00
525	5	RIACHÃO DAS NEVES	2010-03-11 00:00:00
526	5	RIACHÃO DO JACUÍPE	2010-03-11 00:00:00
527	5	RIACHO DE SANTANA	2010-03-11 00:00:00
528	5	RIBEIRA DO AMPARO	2010-03-11 00:00:00
529	5	RIBEIRA DO POMBAL	2010-03-11 00:00:00
530	5	RIBEIRÃO DO LARGO	2010-03-11 00:00:00
531	5	RIO DE CONTAS	2010-03-11 00:00:00
532	5	RIO DO ANTÔNIO	2010-03-11 00:00:00
533	5	RIO DO PIRES	2010-03-11 00:00:00
534	5	RIO REAL	2010-03-11 00:00:00
535	5	RODELAS	2010-03-11 00:00:00
536	5	RUY BARBOSA	2010-03-11 00:00:00
537	5	SALINAS DA MARGARIDA	2010-03-11 00:00:00
538	5	SALVADOR	2010-03-11 00:00:00
539	5	SANTA BÁRBARA	2010-03-11 00:00:00
540	5	SANTA BRÍGIDA	2010-03-11 00:00:00
541	5	SANTA CRUZ CABRÁLIA	2010-03-11 00:00:00
542	5	SANTA CRUZ DA VITÓRIA	2010-03-11 00:00:00
543	5	SANTA INÊS	2010-03-11 00:00:00
544	5	SANTA LUZIA	2010-03-11 00:00:00
545	5	SANTA MARIA DA VITÓRIA	2010-03-11 00:00:00
546	5	SANTA RITA DE CÁSSIA	2010-03-11 00:00:00
547	5	SANTA TERESINHA	2010-03-11 00:00:00
548	5	SANTALUZ	2010-03-11 00:00:00
549	5	SANTANA	2010-03-11 00:00:00
550	5	SANTANÓPOLIS	2010-03-11 00:00:00
551	5	SANTO AMARO	2010-03-11 00:00:00
552	5	SANTO ANTÔNIO DE JESUS	2010-03-11 00:00:00
553	5	SANTO ESTEVÃO	2010-03-11 00:00:00
554	5	SÃO DESIDÉRIO	2010-03-11 00:00:00
555	5	SÃO DOMINGOS	2010-03-11 00:00:00
556	5	SÃO FELIPE	2010-03-11 00:00:00
557	5	SÃO FÉLIX	2010-03-11 00:00:00
558	5	SÃO FÉLIX DO CORIBE	2010-03-11 00:00:00
559	5	SÃO FRANCISCO DO CONDE	2010-03-11 00:00:00
560	5	SÃO GABRIEL	2010-03-11 00:00:00
561	5	SÃO GONÇALO DOS CAMPOS	2010-03-11 00:00:00
562	5	SÃO JOSÉ DA VITÓRIA	2010-03-11 00:00:00
563	5	SÃO JOSÉ DO JACUÍPE	2010-03-11 00:00:00
564	5	SÃO MIGUEL DAS MATAS	2010-03-11 00:00:00
565	5	SÃO SEBASTIÃO DO PASSE	2010-03-11 00:00:00
566	5	SAPEAÇU	2010-03-11 00:00:00
567	5	SÁTIRO DIAS	2010-03-11 00:00:00
568	5	SAUBARA	2010-03-11 00:00:00
569	5	SAÚDE	2010-03-11 00:00:00
570	5	SEABRA	2010-03-11 00:00:00
571	5	SEBASTIÃO LARANJEIRAS	2010-03-11 00:00:00
572	5	SENHOR DO BONFIM	2010-03-11 00:00:00
573	5	SENTO SÉ	2010-03-11 00:00:00
574	5	SERRA DO RAMALHO	2010-03-11 00:00:00
575	5	SERRA DOURADA	2010-03-11 00:00:00
576	5	SERRA PRETA	2010-03-11 00:00:00
577	5	SERRINHA	2010-03-11 00:00:00
578	5	SERROLÂNDIA	2010-03-11 00:00:00
579	5	SIMÕES FILHO	2010-03-11 00:00:00
580	5	SÍTIO DO MATO	2010-03-11 00:00:00
581	5	SÍTIO DO QUINTO	2010-03-11 00:00:00
582	5	SOBRADINHO	2010-03-11 00:00:00
583	5	SOUTO SOARES	2010-03-11 00:00:00
584	5	TABOCAS DO BREJO VELHO	2010-03-11 00:00:00
585	5	TANHAÇU	2010-03-11 00:00:00
586	5	TANQUE NOVO	2010-03-11 00:00:00
587	5	TANQUINHO	2010-03-11 00:00:00
588	5	TAPEROÁ	2010-03-11 00:00:00
589	5	TAPIRAMUTA	2010-03-11 00:00:00
590	5	TEIXEIRA DE FREITAS	2010-03-11 00:00:00
591	5	TEODORO SAMPAIO	2010-03-11 00:00:00
592	5	TEOFILÂNDIA	2010-03-11 00:00:00
593	5	TEOLÂNDIA	2010-03-11 00:00:00
594	5	TERRA NOVA	2010-03-11 00:00:00
595	5	TREMEDAL	2010-03-11 00:00:00
596	5	TUCANO	2010-03-11 00:00:00
597	5	UAUÁ	2010-03-11 00:00:00
598	5	UBAIRA	2010-03-11 00:00:00
599	5	UBAITABA	2010-03-11 00:00:00
600	5	UBATÃ	2010-03-11 00:00:00
601	5	UIBAI	2010-03-11 00:00:00
602	5	UMBURANAS	2010-03-11 00:00:00
603	5	UNA	2010-03-11 00:00:00
604	5	URANDI	2010-03-11 00:00:00
605	5	URUÇUCA	2010-03-11 00:00:00
606	5	UTINGA	2010-03-11 00:00:00
607	5	VALENÇA	2010-03-11 00:00:00
608	5	VALENTE	2010-03-11 00:00:00
609	5	VÁRZEA DA ROÇA	2010-03-11 00:00:00
610	5	VÁRZEA DO POÇO	2010-03-11 00:00:00
611	5	VÁRZEA NOVA	2010-03-11 00:00:00
612	5	VARZEDO	2010-03-11 00:00:00
613	5	VERA CRUZ	2010-03-11 00:00:00
614	5	VEREDA	2010-03-11 00:00:00
615	5	VITÓRIA DA CONQUISTA	2010-03-11 00:00:00
616	5	WAGNER	2010-03-11 00:00:00
617	5	WANDERLEY	2010-03-11 00:00:00
618	5	WENCESLAU GUIMARÃES	2010-03-11 00:00:00
619	5	XIQUE-XIQUE	2010-03-11 00:00:00
620	6	ABAIARA	2010-03-11 00:00:00
621	6	ACARAPE	2010-03-11 00:00:00
622	6	ACARAU	2010-03-11 00:00:00
623	6	ACOPIARA	2010-03-11 00:00:00
624	6	AIUABA	2010-03-11 00:00:00
625	6	ALCANTARAS	2010-03-11 00:00:00
626	6	ALTANEIRA	2010-03-11 00:00:00
627	6	ALTO SANTO	2010-03-11 00:00:00
628	6	AMONTADA	2010-03-11 00:00:00
629	6	ANTONINA DO NORTE	2010-03-11 00:00:00
630	6	APUIARES	2010-03-11 00:00:00
631	6	AQUIRAZ	2010-03-11 00:00:00
632	6	ARACATI	2010-03-11 00:00:00
633	6	ARACOIABA	2010-03-11 00:00:00
634	6	ARARENDA	2010-03-11 00:00:00
635	6	ARARIPE	2010-03-11 00:00:00
636	6	ARATUBA	2010-03-11 00:00:00
637	6	ARNEIROZ	2010-03-11 00:00:00
638	6	ASSARÉ	2010-03-11 00:00:00
639	6	AURORA	2010-03-11 00:00:00
640	6	BAIXIO	2010-03-11 00:00:00
641	6	BANABUIU	2010-03-11 00:00:00
642	6	BARBALHA	2010-03-11 00:00:00
643	6	BARREIRA	2010-03-11 00:00:00
644	6	BARRO	2010-03-11 00:00:00
645	6	BARROQUINHA	2010-03-11 00:00:00
646	6	BATURITÉ	2010-03-11 00:00:00
647	6	BEBERIBE	2010-03-11 00:00:00
648	6	BELA CRUZ	2010-03-11 00:00:00
649	6	BOA VIAGEM	2010-03-11 00:00:00
650	6	BREJO SANTO	2010-03-11 00:00:00
651	6	CAMOCIM	2010-03-11 00:00:00
652	6	CAMPOS SALES	2010-03-11 00:00:00
653	6	CANINDÉ	2010-03-11 00:00:00
654	6	CAPISTRANO	2010-03-11 00:00:00
655	6	CARIDADE	2010-03-11 00:00:00
656	6	CARIRE	2010-03-11 00:00:00
657	6	CARIRIAÇU	2010-03-11 00:00:00
658	6	CARIUS	2010-03-11 00:00:00
659	6	CARNAUBAL	2010-03-11 00:00:00
660	6	CASCAVEL	2010-03-11 00:00:00
661	6	CATARINA	2010-03-11 00:00:00
662	6	CATUNDA	2010-03-11 00:00:00
663	6	CAUCAIA	2010-03-11 00:00:00
664	6	CEDRO	2010-03-11 00:00:00
665	6	CHAVAL	2010-03-11 00:00:00
666	6	CHORO	2010-03-11 00:00:00
667	6	CHOROZINHO	2010-03-11 00:00:00
668	6	COREAU	2010-03-11 00:00:00
669	6	CRATEÚS	2010-03-11 00:00:00
670	6	CRATO	2010-03-11 00:00:00
671	6	CROATA	2010-03-11 00:00:00
672	6	CRUZ	2010-03-11 00:00:00
673	6	DEPUTADO IRAPUAN RIBEIRO	2010-03-11 00:00:00
674	6	ERERE	2010-03-11 00:00:00
675	6	EUSÉBIO	2010-03-11 00:00:00
676	6	FARIAS BRITO	2010-03-11 00:00:00
677	6	FORQUILHA	2010-03-11 00:00:00
678	6	FORTALEZA	2010-03-11 00:00:00
679	6	FORTIM	2010-03-11 00:00:00
680	6	FRECHEIRINHA	2010-03-11 00:00:00
681	6	GENERAL SAMPAIO	2010-03-11 00:00:00
682	6	GRAÇA	2010-03-11 00:00:00
683	6	GRANJA	2010-03-11 00:00:00
684	6	GRANJEIRO	2010-03-11 00:00:00
685	6	GROAíRAS	2010-03-11 00:00:00
686	6	GUAIUBA	2010-03-11 00:00:00
687	6	GUARACIABA DO NORTE	2010-03-11 00:00:00
688	6	GUARAMIRANGA	2010-03-11 00:00:00
689	6	HIDROLÂNDIA	2010-03-11 00:00:00
690	6	HORIZONTE	2010-03-11 00:00:00
691	6	IBARETAMA	2010-03-11 00:00:00
692	6	IBIAPINA	2010-03-11 00:00:00
693	6	IBICUITINGA	2010-03-11 00:00:00
694	6	ICAPUI	2010-03-11 00:00:00
695	6	ICÓ	2010-03-11 00:00:00
696	6	IGUATU	2010-03-11 00:00:00
697	6	INDEPENDÊNCIA	2010-03-11 00:00:00
698	6	IPAPORANGA	2010-03-11 00:00:00
699	6	IPAUMIRIM	2010-03-11 00:00:00
700	6	IPU	2010-03-11 00:00:00
701	6	IPUEIRAS	2010-03-11 00:00:00
702	6	IRACEMA	2010-03-11 00:00:00
703	6	IRAUÇUBA	2010-03-11 00:00:00
704	6	ITAIÇABA	2010-03-11 00:00:00
705	6	ITAITINGA	2010-03-11 00:00:00
706	6	ITAPAGÉ	2010-03-11 00:00:00
707	6	ITAPIPOCA	2010-03-11 00:00:00
708	6	ITAPIUNA	2010-03-11 00:00:00
709	6	ITAREMA	2010-03-11 00:00:00
710	6	ITATIRA	2010-03-11 00:00:00
711	6	JAGUARETAMA	2010-03-11 00:00:00
712	6	JAGUARIBARA	2010-03-11 00:00:00
713	6	JAGUARIBE	2010-03-11 00:00:00
714	6	JAGUARUANA	2010-03-11 00:00:00
715	6	JARDIM	2010-03-11 00:00:00
716	6	JATI	2010-03-11 00:00:00
717	6	JIJOCA DE JERICOACOARA	2010-03-11 00:00:00
718	6	JUAZEIRO DO NORTE	2010-03-11 00:00:00
719	6	JUCAS	2010-03-11 00:00:00
720	6	LAVRAS DA MANGABEIRA	2010-03-11 00:00:00
721	6	LIMOEIRO DO NORTE	2010-03-11 00:00:00
722	6	MADALENA	2010-03-11 00:00:00
723	6	MARACANAU	2010-03-11 00:00:00
724	6	MARANGUAPE	2010-03-11 00:00:00
725	6	MARCO	2010-03-11 00:00:00
726	6	MARTINÓPOLE	2010-03-11 00:00:00
727	6	MASSAPÊ	2010-03-11 00:00:00
728	6	MAURITI	2010-03-11 00:00:00
729	6	MERUOCA	2010-03-11 00:00:00
730	6	MILAGRES	2010-03-11 00:00:00
731	6	MILHÃ	2010-03-11 00:00:00
732	6	MIRAIMA	2010-03-11 00:00:00
733	6	MISSÃO VELHA	2010-03-11 00:00:00
734	6	MOMBAÇA	2010-03-11 00:00:00
735	6	MONSENHOR TABOSA	2010-03-11 00:00:00
736	6	MORADA NOVA	2010-03-11 00:00:00
737	6	MORAUJO	2010-03-11 00:00:00
738	6	MORRINHOS	2010-03-11 00:00:00
739	6	MUCAMBO	2010-03-11 00:00:00
740	6	MULUNGU	2010-03-11 00:00:00
741	6	NOVA OLINDA	2010-03-11 00:00:00
742	6	NOVA RUSSAS	2010-03-11 00:00:00
743	6	NOVO ORIENTE	2010-03-11 00:00:00
744	6	OCARA	2010-03-11 00:00:00
745	6	ORÓS	2010-03-11 00:00:00
746	6	PACAJUS	2010-03-11 00:00:00
747	6	PACATUBA	2010-03-11 00:00:00
748	6	PACOTI	2010-03-11 00:00:00
749	6	PACUJA	2010-03-11 00:00:00
750	6	PALHANO	2010-03-11 00:00:00
751	6	PALMACIA	2010-03-11 00:00:00
752	6	PARACURU	2010-03-11 00:00:00
753	6	PARAIPABA	2010-03-11 00:00:00
754	6	PARAMBU	2010-03-11 00:00:00
755	6	PARAMOTI	2010-03-11 00:00:00
756	6	PEDRA BRANCA	2010-03-11 00:00:00
757	6	PENA FORTE	2010-03-11 00:00:00
758	6	PENTECOSTE	2010-03-11 00:00:00
759	6	PEREIRO	2010-03-11 00:00:00
760	6	PINDORETAMA	2010-03-11 00:00:00
761	6	PIQUET CARNEIRO	2010-03-11 00:00:00
762	6	PIRES FERREIRA	2010-03-11 00:00:00
763	6	PORANGA	2010-03-11 00:00:00
764	6	PORTEIRAS	2010-03-11 00:00:00
765	6	POTENGI	2010-03-11 00:00:00
766	6	POTIRETAMA	2010-03-11 00:00:00
767	6	QUITERIANÓPOLIS	2010-03-11 00:00:00
768	6	QUIXADÁ	2010-03-11 00:00:00
769	6	QUIXELO	2010-03-11 00:00:00
770	6	QUIXERAMOBIM	2010-03-11 00:00:00
771	6	QUIXERE	2010-03-11 00:00:00
772	6	REDENÇÃO	2010-03-11 00:00:00
773	6	RERIUTABA	2010-03-11 00:00:00
774	6	RUSSAS	2010-03-11 00:00:00
775	6	SABOEIRO	2010-03-11 00:00:00
776	6	SALITRE	2010-03-11 00:00:00
777	6	SANTA QUITÉRIA	2010-03-11 00:00:00
778	6	SANTANA DO ACARAU	2010-03-11 00:00:00
779	6	SANTANA DO CARIRI	2010-03-11 00:00:00
780	6	SÃO BENEDITO	2010-03-11 00:00:00
781	6	SÃO GONÇALO DO AMARANTE	2010-03-11 00:00:00
782	6	SÃO JOÃO DO JAGUARIBE	2010-03-11 00:00:00
783	6	SÃO LUIZ DO CURU	2010-03-11 00:00:00
784	6	SENADOR POMPEU	2010-03-11 00:00:00
785	6	SENADOR SÁ	2010-03-11 00:00:00
786	6	SOBRAL	2010-03-11 00:00:00
787	6	SOLONÓPOLE	2010-03-11 00:00:00
788	6	TABULEIRO DO NORTE	2010-03-11 00:00:00
789	6	TAMBORIL	2010-03-11 00:00:00
790	6	TARRAFAS	2010-03-11 00:00:00
791	6	TAUÁ	2010-03-11 00:00:00
792	6	TEJUÇUOCA	2010-03-11 00:00:00
793	6	TIANGUA	2010-03-11 00:00:00
794	6	TRAIRI	2010-03-11 00:00:00
795	6	TURURU	2010-03-11 00:00:00
796	6	UBAJARA	2010-03-11 00:00:00
797	6	UMARI	2010-03-11 00:00:00
798	6	UMIRIM	2010-03-11 00:00:00
799	6	URUBURETAMA	2010-03-11 00:00:00
800	6	URUOCA	2010-03-11 00:00:00
801	6	VARJOTA	2010-03-11 00:00:00
802	6	VÁRZEA ALEGRE	2010-03-11 00:00:00
803	6	VIÇOSA DO CEARÁ	2010-03-11 00:00:00
804	7	BRASÍLIA	2010-03-11 00:00:00
805	8	AFONSO CLÁUDIO	2010-03-11 00:00:00
806	8	ÁGUA DOCE DO NORTE	2010-03-11 00:00:00
807	8	ÁGUIA BRANCA	2010-03-11 00:00:00
808	8	ALEGRE	2010-03-11 00:00:00
809	8	ALFREDO CHAVES	2010-03-11 00:00:00
810	8	ALTO RIO NOVO	2010-03-11 00:00:00
811	8	ANCHIETA	2010-03-11 00:00:00
812	8	APIACÁ	2010-03-11 00:00:00
813	8	ARACRUZ	2010-03-11 00:00:00
814	8	ATILIO VIVÁCQUA	2010-03-11 00:00:00
815	8	BAIXO GUANDU	2010-03-11 00:00:00
816	8	BARRA DE SÃO FRANCISCO	2010-03-11 00:00:00
817	8	BOA ESPERANÇA	2010-03-11 00:00:00
818	8	BOM JESUS DO NORTE	2010-03-11 00:00:00
819	8	BREJETUBA	2010-03-11 00:00:00
820	8	CACHOEIRO DO ITAPEMIRIM	2010-03-11 00:00:00
821	8	CARIACICA	2010-03-11 00:00:00
822	8	CASTELO	2010-03-11 00:00:00
823	8	COLATINA	2010-03-11 00:00:00
824	8	CONCEIÇÃO DA BARRA	2010-03-11 00:00:00
825	8	CONCEIÇÃO DO CASTELO	2010-03-11 00:00:00
826	8	DIVINO DE SÃO LOURENÇO	2010-03-11 00:00:00
827	8	DOMINGOS MARTINS	2010-03-11 00:00:00
828	8	DORES DO RIO PRETO	2010-03-11 00:00:00
829	8	ECOPORANGA	2010-03-11 00:00:00
830	8	FUNDÃO	2010-03-11 00:00:00
831	8	GOVERNADOR LINDENBERG	2010-03-11 00:00:00
832	8	GUAÇUÍ	2010-03-11 00:00:00
833	8	GUARAPARI	2010-03-11 00:00:00
834	8	IBATIBA	2010-03-11 00:00:00
835	8	IBIRAÇU	2010-03-11 00:00:00
836	8	IBITIRAMA	2010-03-11 00:00:00
837	8	ICONHA	2010-03-11 00:00:00
838	8	IRUPI	2010-03-11 00:00:00
839	8	ITAGUAÇU	2010-03-11 00:00:00
840	8	ITAPEMIRIM	2010-03-11 00:00:00
841	8	ITARANA	2010-03-11 00:00:00
842	8	IÚNA	2010-03-11 00:00:00
843	8	JAGUARÉ	2010-03-11 00:00:00
844	8	JERÔNIMO MONTEIRO	2010-03-11 00:00:00
845	8	JOÃO NEIVA	2010-03-11 00:00:00
846	8	LARANJA DA TERRA	2010-03-11 00:00:00
847	8	LINHARES	2010-03-11 00:00:00
848	8	MANTENÓPOLIS	2010-03-11 00:00:00
849	8	MARATAÍZES	2010-03-11 00:00:00
850	8	MARECHAL FLORIANO	2010-03-11 00:00:00
851	8	MARILÂNDIA	2010-03-11 00:00:00
852	8	MIMOSO DO SUL	2010-03-11 00:00:00
853	8	MONTANHA	2010-03-11 00:00:00
854	8	MUCURICI	2010-03-11 00:00:00
855	8	MUNIZ FREIRE	2010-03-11 00:00:00
856	8	MUQUI	2010-03-11 00:00:00
857	8	NOVA VENÉCIA	2010-03-11 00:00:00
858	8	PANCAS	2010-03-11 00:00:00
859	8	PEDRO CANÁRIO	2010-03-11 00:00:00
860	8	PINHEIROS	2010-03-11 00:00:00
861	8	PIÚMA	2010-03-11 00:00:00
862	8	PONTO BELO	2010-03-11 00:00:00
863	8	PRESIDENTE KENNEDY	2010-03-11 00:00:00
864	8	RIO BANANAL	2010-03-11 00:00:00
865	8	RIO NOVO DO SUL	2010-03-11 00:00:00
866	8	SANTA LEOPOLDINA	2010-03-11 00:00:00
867	8	SANTA MARIA DE JETIBÁ	2010-03-11 00:00:00
868	8	SANTA TERESA	2010-03-11 00:00:00
869	8	SÃO DOMINGOS DO NORTE	2010-03-11 00:00:00
870	8	SÃO GABRIEL DA PALHA	2010-03-11 00:00:00
871	8	SÃO JOSÉ DO CALÇADO	2010-03-11 00:00:00
872	8	SÃO MATEUS	2010-03-11 00:00:00
873	8	SÃO ROQUE DO CANAÃ	2010-03-11 00:00:00
874	8	SERRA	2010-03-11 00:00:00
875	8	SOORETAMA	2010-03-11 00:00:00
876	8	VARGEM ALTA	2010-03-11 00:00:00
877	8	VENDA NOVA DO IMIGRANTE	2010-03-11 00:00:00
878	8	VIANA	2010-03-11 00:00:00
879	8	VILA PAVÃO	2010-03-11 00:00:00
880	8	VILA VALÉRIO	2010-03-11 00:00:00
881	8	VILA VELHA	2010-03-11 00:00:00
882	8	VITÓRIA	2010-03-11 00:00:00
883	9	ABADIA DE GOIÁS	2010-03-11 00:00:00
884	9	ABADIÂNIA	2010-03-11 00:00:00
885	9	ACREÚNA	2010-03-11 00:00:00
886	9	ADELÂNDIA	2010-03-11 00:00:00
887	9	ÁGUA FRIA DE GOIÁS	2010-03-11 00:00:00
888	9	ÁGUA LIMPA	2010-03-11 00:00:00
889	9	ÁGUA LINDAS DE GOIÁS	2010-03-11 00:00:00
890	9	ALEXÂNIA	2010-03-11 00:00:00
891	9	ALOÂNDIA	2010-03-11 00:00:00
892	9	ALTO HORIZONTE	2010-03-11 00:00:00
893	9	ALTO PARAÍSO DE GOIÁS	2010-03-11 00:00:00
894	9	ALVORADA DO NORTE	2010-03-11 00:00:00
895	9	AMARALINA	2010-03-11 00:00:00
896	9	AMERICANO DO BRASIL	2010-03-11 00:00:00
897	9	AMORINÓPOLIS	2010-03-11 00:00:00
898	9	ANÁPOLIS	2010-03-11 00:00:00
899	9	ANHANGUERA	2010-03-11 00:00:00
900	9	ANICUNS	2010-03-11 00:00:00
901	9	APARECIDA DE GOIÂNIA	2010-03-11 00:00:00
902	9	APARECIDA DO RIO DOCE	2010-03-11 00:00:00
903	9	APORÉ	2010-03-11 00:00:00
904	9	ARAÇU	2010-03-11 00:00:00
905	9	ARAGARÇAS	2010-03-11 00:00:00
906	9	ARAGOIÂNIA	2010-03-11 00:00:00
907	9	ARAGUAPAZ	2010-03-11 00:00:00
908	9	ARENÓPOLIS	2010-03-11 00:00:00
909	9	ARUANÃ	2010-03-11 00:00:00
910	9	AURILÂNDIA	2010-03-11 00:00:00
911	9	AVELINÓPOLIS	2010-03-11 00:00:00
912	9	BALIZA	2010-03-11 00:00:00
913	9	BARRO ALTO	2010-03-11 00:00:00
914	9	BELA VISTA DE GOIÁS	2010-03-11 00:00:00
915	9	BOM JARDIM DE GOIÁS	2010-03-11 00:00:00
916	9	BOM JESUS DE GOIÁS	2010-03-11 00:00:00
917	9	BONFINÓPOLIS	2010-03-11 00:00:00
918	9	BONÓPOLIS	2010-03-11 00:00:00
919	9	BRAZABRANTES	2010-03-11 00:00:00
920	9	BRITÂNIA	2010-03-11 00:00:00
921	9	BURITI ALEGRE	2010-03-11 00:00:00
922	9	BURITI DE GOIÁS	2010-03-11 00:00:00
923	9	BURITINÓPOLIS	2010-03-11 00:00:00
924	9	CABECEIRAS	2010-03-11 00:00:00
925	9	CACHOEIRA ALTA	2010-03-11 00:00:00
926	9	CACHOEIRA DE GOIÁS	2010-03-11 00:00:00
927	9	CACHOEIRA DOURADA	2010-03-11 00:00:00
928	9	CAÇU	2010-03-11 00:00:00
929	9	CAIAPÔNIA	2010-03-11 00:00:00
930	9	CALDAS NOVAS	2010-03-11 00:00:00
931	9	CALDAZINHA	2010-03-11 00:00:00
932	9	CAMPESTRE DE GOIÁS	2010-03-11 00:00:00
933	9	CAMPINAÇU	2010-03-11 00:00:00
934	9	CAMPINORTE	2010-03-11 00:00:00
935	9	CAMPO ALEGRE DE GOIÁS	2010-03-11 00:00:00
936	9	CAMPO LIMPO DE GOIÁS	2010-03-11 00:00:00
937	9	CAMPOS BELOS	2010-03-11 00:00:00
938	9	CAMPOS VERDES	2010-03-11 00:00:00
939	9	CARMO DO RIO VERDE	2010-03-11 00:00:00
940	9	CASTELÂNDIA	2010-03-11 00:00:00
941	9	CATALÃO	2010-03-11 00:00:00
942	9	CATURAÍ	2010-03-11 00:00:00
943	9	CAVALCANTE	2010-03-11 00:00:00
944	9	CERES	2010-03-11 00:00:00
945	9	CEZARINA	2010-03-11 00:00:00
946	9	CHAPADÃO DO CÉU	2010-03-11 00:00:00
947	9	CIDADE OCIDENTAL	2010-03-11 00:00:00
948	9	COCALZINHO DE GOIÁS	2010-03-11 00:00:00
949	9	COLINAS DO SUL	2010-03-11 00:00:00
950	9	CÓRREGO DO OURO	2010-03-11 00:00:00
951	9	CORUMBÁ DE GOIÁS	2010-03-11 00:00:00
952	9	CORUMBAÍBA	2010-03-11 00:00:00
953	9	CRISTALINA	2010-03-11 00:00:00
954	9	CRISTIANÓPOLIS	2010-03-11 00:00:00
955	9	CRIXAS	2010-03-11 00:00:00
956	9	CROMÍNIA	2010-03-11 00:00:00
957	9	CUMARI	2010-03-11 00:00:00
958	9	DAMIANÓPOLIS	2010-03-11 00:00:00
959	9	DAMOLÂNDIA	2010-03-11 00:00:00
960	9	DAVINÓPOLIS	2010-03-11 00:00:00
961	9	DIORAMA	2010-03-11 00:00:00
962	9	DIVINÓPOLIS DE GOIÁS	2010-03-11 00:00:00
963	9	DOVERLÂNDIA	2010-03-11 00:00:00
964	9	EDEALINA	2010-03-11 00:00:00
965	9	EDEIA	2010-03-11 00:00:00
966	9	ESTRELA DO NORTE	2010-03-11 00:00:00
967	9	FAINA	2010-03-11 00:00:00
968	9	FAZENDA NOVA	2010-03-11 00:00:00
969	9	FIRMINÓPOLIS	2010-03-11 00:00:00
970	9	FLORES DE GOIÁS	2010-03-11 00:00:00
971	9	FORMOSA	2010-03-11 00:00:00
972	9	FORMOSO	2010-03-11 00:00:00
973	9	GAMELEIRA DE GOIÁS	2010-03-11 00:00:00
974	9	GOIANÁPOLIS	2010-03-11 00:00:00
975	9	GOIANDIRA	2010-03-11 00:00:00
976	9	GOIANÉSIA	2010-03-11 00:00:00
977	9	GOIÂNIA	2010-03-11 00:00:00
978	9	GOIANIRA	2010-03-11 00:00:00
979	9	GOIÁS	2010-03-11 00:00:00
980	9	GOIATUBA	2010-03-11 00:00:00
981	9	GOUVELÂNDIA	2010-03-11 00:00:00
982	9	GUAPO	2010-03-11 00:00:00
983	9	GUARAÍTA	2010-03-11 00:00:00
984	9	GUARANI DE GOÍAS	2010-03-11 00:00:00
985	9	GUARINOS	2010-03-11 00:00:00
986	9	HEITORAÍ	2010-03-11 00:00:00
987	9	HIDROLÂNDIA	2010-03-11 00:00:00
988	9	HIDROLINA	2010-03-11 00:00:00
989	9	IACIARA	2010-03-11 00:00:00
990	9	INACIOLÂNDIA	2010-03-11 00:00:00
991	9	INDIARA	2010-03-11 00:00:00
992	9	INHUMAS	2010-03-11 00:00:00
993	9	IPAMERI	2010-03-11 00:00:00
994	9	IPIRANGA DE GOIÁS	2010-03-11 00:00:00
995	9	IPORÃ	2010-03-11 00:00:00
996	9	ISRAELÂNDIA	2010-03-11 00:00:00
997	9	ITABERAÍ	2010-03-11 00:00:00
998	9	ITAGUARI	2010-03-11 00:00:00
999	9	ITAGUARU	2010-03-11 00:00:00
1000	9	ITAJÁ	2010-03-11 00:00:00
1001	9	ITAPACI	2010-03-11 00:00:00
1002	9	ITAPIRAPUÃ	2010-03-11 00:00:00
1003	9	ITAPURANGA	2010-03-11 00:00:00
1004	9	ITARUMÃ	2010-03-11 00:00:00
1005	9	ITAUÇU	2010-03-11 00:00:00
1006	9	ITUMBIARA	2010-03-11 00:00:00
1007	9	IVOLÂNDIA	2010-03-11 00:00:00
1008	9	JANDAIA	2010-03-11 00:00:00
1009	9	JARAGUÁ	2010-03-11 00:00:00
1010	9	JATAÍ	2010-03-11 00:00:00
1011	9	JAUPACI	2010-03-11 00:00:00
1012	9	JESÚPOLIS	2010-03-11 00:00:00
1013	9	JOVIÂNIA	2010-03-11 00:00:00
1014	9	JUSSARA	2010-03-11 00:00:00
1015	9	LAGOA SANTA	2010-03-11 00:00:00
1016	9	LEOPOLDO DE BULHÕES	2010-03-11 00:00:00
1017	9	LUZIÂNIA	2010-03-11 00:00:00
1018	9	MAIRIPOTABA	2010-03-11 00:00:00
1019	9	MAMBAÍ	2010-03-11 00:00:00
1020	9	MARA ROSA	2010-03-11 00:00:00
1021	9	MARZAGÃO	2010-03-11 00:00:00
1022	9	MATRINCHÃ	2010-03-11 00:00:00
1023	9	MAURILÂNDIA	2010-03-11 00:00:00
1024	9	MIMOSO DE GOIÁS	2010-03-11 00:00:00
1025	9	MINAÇU	2010-03-11 00:00:00
1026	9	MINEIROS	2010-03-11 00:00:00
1027	9	MOIPORÃ	2010-03-11 00:00:00
1028	9	MONTE ALEGRE DE GOIÁS	2010-03-11 00:00:00
1029	9	MONTES CLAROS DE GOIÁS	2010-03-11 00:00:00
1030	9	MONTIVIDIU	2010-03-11 00:00:00
1031	9	MONTIVIDIU DO NORTE	2010-03-11 00:00:00
1032	9	MORRINHOS	2010-03-11 00:00:00
1033	9	MORRO AGUDO DE GOIÁS	2010-03-11 00:00:00
1034	9	MOSSAMEDES	2010-03-11 00:00:00
1035	9	MOZARLÂNDIA	2010-03-11 00:00:00
1036	9	MUNDO NOVO	2010-03-11 00:00:00
1037	9	MUTUNÓPOLIS	2010-03-11 00:00:00
1038	9	NAZÁRIO	2010-03-11 00:00:00
1039	9	NERÓPOLIS	2010-03-11 00:00:00
1040	9	NIQUELÂNDIA	2010-03-11 00:00:00
1041	9	NOVA AMÉRICA	2010-03-11 00:00:00
1042	9	NOVA AURORA	2010-03-11 00:00:00
1043	9	NOVA CRIXAS	2010-03-11 00:00:00
1044	9	NOVA GLÓRIA	2010-03-11 00:00:00
1045	9	NOVA IGUAÇU DE GOIÁS	2010-03-11 00:00:00
1046	9	NOVA ROMA	2010-03-11 00:00:00
1047	9	NOVA VENEZA	2010-03-11 00:00:00
1048	9	NOVO BRASIL	2010-03-11 00:00:00
1049	9	NOVO GAMA	2010-03-11 00:00:00
1050	9	NOVO PLANALTO	2010-03-11 00:00:00
1051	9	ORIZONA	2010-03-11 00:00:00
1052	9	OURO VERDE DE GOIÁS	2010-03-11 00:00:00
1053	9	OUVIDOR	2010-03-11 00:00:00
1054	9	PADRE BERNARDO	2010-03-11 00:00:00
1055	9	PALESTINA DE GOIÁS	2010-03-11 00:00:00
1056	9	PALMEIRA DE GOIÁS	2010-03-11 00:00:00
1057	9	PALMELO	2010-03-11 00:00:00
1058	9	PALMINÓPOLIS	2010-03-11 00:00:00
1059	9	PANAMÁ	2010-03-11 00:00:00
1060	9	PARANAIGUARA	2010-03-11 00:00:00
1061	9	PARAÚNA	2010-03-11 00:00:00
1062	9	PEROLÂNDIA	2010-03-11 00:00:00
1063	9	PETROLINA DE GOIÁS	2010-03-11 00:00:00
1064	9	PILAR DE GOIÁS	2010-03-11 00:00:00
1065	9	PIRACANJUBA	2010-03-11 00:00:00
1066	9	PIRANHAS	2010-03-11 00:00:00
1067	9	PIRENÓPOLIS	2010-03-11 00:00:00
1068	9	PIRES DO RIO	2010-03-11 00:00:00
1069	9	PLANALTINA	2010-03-11 00:00:00
1070	9	PONTALINA	2010-03-11 00:00:00
1071	9	PORANGATU	2010-03-11 00:00:00
1072	9	PORTEIRÃO	2010-03-11 00:00:00
1073	9	PORTELÂNDIA	2010-03-11 00:00:00
1074	9	POSSE	2010-03-11 00:00:00
1075	9	PROFESSOR JAMIL	2010-03-11 00:00:00
1076	9	QUIRINÓPOLIS	2010-03-11 00:00:00
1077	9	RIALMA	2010-03-11 00:00:00
1078	9	RIANÁPOLIS	2010-03-11 00:00:00
1079	9	RIO QUENTE	2010-03-11 00:00:00
1080	9	RIO VERDE	2010-03-11 00:00:00
1081	9	RUBIATABA	2010-03-11 00:00:00
1082	9	SANCLERLÂNDIA	2010-03-11 00:00:00
1083	9	SANTA BÁRBARA DE GOIÁS	2010-03-11 00:00:00
1084	9	SANTA CRUZ DE GOIÁS	2010-03-11 00:00:00
1085	9	SANTA FÉ DE GOIÁS	2010-03-11 00:00:00
1086	9	SANTA HELENA DE GOIÁS	2010-03-11 00:00:00
1087	9	SANTA ISABEL	2010-03-11 00:00:00
1088	9	SANTA RITA DO ARAGUAIA	2010-03-11 00:00:00
1089	9	SANTA RITA DO NOVO DESTINO	2010-03-11 00:00:00
1090	9	SANTA ROSA DE GOIÁS	2010-03-11 00:00:00
1091	9	SANTA TEREZA DE GOIÁS	2010-03-11 00:00:00
1092	9	SANTA TEREZINHA DE GOIÁS	2010-03-11 00:00:00
1093	9	SANTO ANTÔNIO DA BARRA	2010-03-11 00:00:00
1094	9	SANTO ANTÔNIO DE GOIÁS	2010-03-11 00:00:00
1095	9	SANTO ANTÔNIO DO DESCOBERTO	2010-03-11 00:00:00
1096	9	SÃO DOMINGOS	2010-03-11 00:00:00
1097	9	SÃO FRANCISCO DE GOIÁS	2010-03-11 00:00:00
1098	9	SÃO JOÃO D ALIANÇA	2010-03-11 00:00:00
1099	9	SÃO JOÃO DA PARAÚNA	2010-03-11 00:00:00
1100	9	SÃO LUÍS DE MONTES BELOS	2010-03-11 00:00:00
1101	9	SÃO LUIZ DO NORTE	2010-03-11 00:00:00
1102	9	SÃO MIGUEL DO ARAGUAIA	2010-03-11 00:00:00
1103	9	SÃO MIGUEL DO PASSA QUATRO	2010-03-11 00:00:00
1104	9	SÃO PATRÍCIO	2010-03-11 00:00:00
1105	9	SÃO SIMÃO	2010-03-11 00:00:00
1106	9	SENADOR CANEDO	2010-03-11 00:00:00
1107	9	SERRANÓPOLIS	2010-03-11 00:00:00
1108	9	SILVÂNIA	2010-03-11 00:00:00
1109	9	SIMOLÂNDIA	2010-03-11 00:00:00
1110	9	SÍTIO D ABADIA	2010-03-11 00:00:00
1111	9	TAQUARAL DE GOIÁS	2010-03-11 00:00:00
1112	9	TERESINA DE GOIÁS	2010-03-11 00:00:00
1113	9	TEREZÓPOLIS DE GOIÁS	2010-03-11 00:00:00
1114	9	TRÊS RANCHOS	2010-03-11 00:00:00
1115	9	TRINDADE	2010-03-11 00:00:00
1116	9	TROMBAS	2010-03-11 00:00:00
1117	9	TURVÂNIA	2010-03-11 00:00:00
1118	9	TURVELÂNDIA	2010-03-11 00:00:00
1119	9	UIRAPURU	2010-03-11 00:00:00
1120	9	URUAÇU	2010-03-11 00:00:00
1121	9	URUANA	2010-03-11 00:00:00
1122	9	URUTAÍ	2010-03-11 00:00:00
1123	9	VALPARAÍSO DE GOIÁS	2010-03-11 00:00:00
1124	9	VARJÃO	2010-03-11 00:00:00
1125	9	VIANÓPOLIS	2010-03-11 00:00:00
1126	9	VICENTINÓPOLIS	2010-03-11 00:00:00
1127	9	VILA BOA	2010-03-11 00:00:00
1128	9	VILA PROPÍCIO	2010-03-11 00:00:00
1129	10	AÇAILÂNDIA	2010-03-11 00:00:00
1130	10	AFONSO CUNHA	2010-03-11 00:00:00
1131	10	ÁGUA DOCE DO MARANHÃO	2010-03-11 00:00:00
1132	10	ALCÂNTARA	2010-03-11 00:00:00
1133	10	ALDEIAS ALTAS	2010-03-11 00:00:00
1134	10	ALTAMIRA DO MARANHÃO	2010-03-11 00:00:00
1135	10	ALTO ALEGRE DO MARANHÃO	2010-03-11 00:00:00
1136	10	ALTO ALEGRE DO PINDARÉ	2010-03-11 00:00:00
1137	10	ALTO PARNAÍBA	2010-03-11 00:00:00
1138	10	AMAPÁ DO MARANHÃO	2010-03-11 00:00:00
1139	10	AMARANTE DO MARANHÃO	2010-03-11 00:00:00
1140	10	ANAJATUBA	2010-03-11 00:00:00
1141	10	ANAPURUS	2010-03-11 00:00:00
1142	10	APICUM-AÇU	2010-03-11 00:00:00
1143	10	ARAGUANÃ	2010-03-11 00:00:00
1144	10	ARAIÓSES	2010-03-11 00:00:00
1145	10	ARAME	2010-03-11 00:00:00
1146	10	ARARI	2010-03-11 00:00:00
1147	10	AXIXÁ	2010-03-11 00:00:00
1148	10	BACABAL	2010-03-11 00:00:00
1149	10	BACABEIRA	2010-03-11 00:00:00
1150	10	BACURI	2010-03-11 00:00:00
1151	10	BACURITUBA	2010-03-11 00:00:00
1152	10	BALSAS	2010-03-11 00:00:00
1153	10	BARÃO DE GRAJAÚ	2010-03-11 00:00:00
1154	10	BARRA DO CORDA	2010-03-11 00:00:00
1155	10	BARREIRINHAS	2010-03-11 00:00:00
1156	10	BELA VISTA DO MARANHÃO	2010-03-11 00:00:00
1157	10	BELÁGUA	2010-03-11 00:00:00
1158	10	BENEDITO LEITE	2010-03-11 00:00:00
1159	10	BEQUIMÃO	2010-03-11 00:00:00
1160	10	BERNARDO DO MEARIM	2010-03-11 00:00:00
1161	10	BOA VISTA DO GURUPI	2010-03-11 00:00:00
1162	10	BOM JARDIM	2010-03-11 00:00:00
1163	10	BOM JESUS DAS SELVAS	2010-03-11 00:00:00
1164	10	BOM LUGAR	2010-03-11 00:00:00
1165	10	BREJO	2010-03-11 00:00:00
1166	10	BREJO DE AREIA	2010-03-11 00:00:00
1167	10	BURITI	2010-03-11 00:00:00
1168	10	BURITI BRAVO	2010-03-11 00:00:00
1169	10	BURITICUPU	2010-03-11 00:00:00
1170	10	BURITIRANA	2010-03-11 00:00:00
1171	10	CACHOEIRA GRANDE	2010-03-11 00:00:00
1172	10	CAJAPIO	2010-03-11 00:00:00
1173	10	CAJARI	2010-03-11 00:00:00
1174	10	CAMPESTRE DO MARANHÃO	2010-03-11 00:00:00
1175	10	CÂNDIDO MENDES	2010-03-11 00:00:00
1176	10	CANTANHEDE	2010-03-11 00:00:00
1177	10	CAPINZAL DO NORTE	2010-03-11 00:00:00
1178	10	CAROLINA	2010-03-11 00:00:00
1179	10	CARUTAPERA	2010-03-11 00:00:00
1180	10	CAXIAS	2010-03-11 00:00:00
1181	10	CEDRAL	2010-03-11 00:00:00
1182	10	CENTRAL DO MARANHÃO	2010-03-11 00:00:00
1183	10	CENTRO DO GUILHERME	2010-03-11 00:00:00
1184	10	CENTRO NOVO DO MARANHÃO	2010-03-11 00:00:00
1185	10	CHAPADINHA	2010-03-11 00:00:00
1186	10	CIDELÂNDIA	2010-03-11 00:00:00
1187	10	CODÓ	2010-03-11 00:00:00
1188	10	COELHO NETO	2010-03-11 00:00:00
1189	10	COLINAS	2010-03-11 00:00:00
1190	10	CONCEIÇÃO DO LAGO AÇU	2010-03-11 00:00:00
1191	10	COROATÁ	2010-03-11 00:00:00
1192	10	CURURUPU	2010-03-11 00:00:00
1193	10	DAVINÓPOLIS	2010-03-11 00:00:00
1194	10	DOM PEDRO	2010-03-11 00:00:00
1195	10	DUQUE BACELAR	2010-03-11 00:00:00
1196	10	ESPERANTINÓPOLIS	2010-03-11 00:00:00
1197	10	ESTREITO	2010-03-11 00:00:00
1198	10	FEIRA NOVA DO MARANHÃO	2010-03-11 00:00:00
1199	10	FERNANDO FALCÃO	2010-03-11 00:00:00
1200	10	FORMOSA DA SERRA NEGRA	2010-03-11 00:00:00
1201	10	FORTALEZA DOS NOGUEIRAS	2010-03-11 00:00:00
1202	10	FORTUNA	2010-03-11 00:00:00
1203	10	GODOFREDO VIANA	2010-03-11 00:00:00
1204	10	GONÇALVES DIAS	2010-03-11 00:00:00
1205	10	GOVERNADOR ARCHER	2010-03-11 00:00:00
1206	10	GOVERNADOR EDISON LOBÃO	2010-03-11 00:00:00
1207	10	GOVERNADOR EUGÊNIO BARROS	2010-03-11 00:00:00
1208	10	GOVERNADOR LUÍS ROCHA	2010-03-11 00:00:00
1209	10	GOVERNADOR NEWTON BELLO	2010-03-11 00:00:00
1210	10	GOVERNADOR NUNES FREIRE	2010-03-11 00:00:00
1211	10	GRAÇA ARANHA	2010-03-11 00:00:00
1212	10	GRAJAÚ	2010-03-11 00:00:00
1213	10	GUIMARÃES	2010-03-11 00:00:00
1214	10	HUMBERTO DE CAMPOS	2010-03-11 00:00:00
1215	10	ICATU	2010-03-11 00:00:00
1216	10	IGARAPÉ DO MEIO	2010-03-11 00:00:00
1217	10	IGARAPÉ GRANDE	2010-03-11 00:00:00
1218	10	IMPERATRIZ	2010-03-11 00:00:00
1219	10	ITAIPAVA DO GRAJAÚ	2010-03-11 00:00:00
1220	10	ITAPECURU MIRIM	2010-03-11 00:00:00
1221	10	ITINGA DO MARANHÃO	2010-03-11 00:00:00
1222	10	JATOBÁ	2010-03-11 00:00:00
1223	10	JENIPAPO DOS VIEIRAS	2010-03-11 00:00:00
1224	10	JOÃO LISBOA	2010-03-11 00:00:00
1225	10	JOSELÂNDIA	2010-03-11 00:00:00
1226	10	JUNCO DO MARANHÃO	2010-03-11 00:00:00
1227	10	LAGO DA PEDRA	2010-03-11 00:00:00
1228	10	LAGO DO JUNCO	2010-03-11 00:00:00
1229	10	LAGO DOS RODRIGUES	2010-03-11 00:00:00
1230	10	LAGO VERDE	2010-03-11 00:00:00
1231	10	LAGOA DO MATO	2010-03-11 00:00:00
1232	10	LAGOA GRANDE DO MARANHÃO	2010-03-11 00:00:00
1233	10	LAJEADO NOVO	2010-03-11 00:00:00
1234	10	LIMA CAMPOS	2010-03-11 00:00:00
1235	10	LORETO	2010-03-11 00:00:00
1236	10	LUÍS DOMINGUES	2010-03-11 00:00:00
1237	10	MAGALHÃES DE ALMEIDA	2010-03-11 00:00:00
1238	10	MARACAÇUMÉ	2010-03-11 00:00:00
1239	10	MARAJÁ DO SENA	2010-03-11 00:00:00
1240	10	MARANHÃOZINHO	2010-03-11 00:00:00
1241	10	MATA ROMA	2010-03-11 00:00:00
1242	10	MATINHA	2010-03-11 00:00:00
1243	10	MATÕES	2010-03-11 00:00:00
1244	10	MATÕES DO NORTE	2010-03-11 00:00:00
1245	10	MILAGRES DO MARANHÃO	2010-03-11 00:00:00
1246	10	MIRADOR	2010-03-11 00:00:00
1247	10	MIRANDA DO NORTE	2010-03-11 00:00:00
1248	10	MIRINZAL	2010-03-11 00:00:00
1249	10	MONÇÃO	2010-03-11 00:00:00
1250	10	MONTES ALTOS	2010-03-11 00:00:00
1251	10	MORROS	2010-03-11 00:00:00
1252	10	NINA RODRIGUES	2010-03-11 00:00:00
1253	10	NOVA COLINAS	2010-03-11 00:00:00
1254	10	NOVA IORQUE	2010-03-11 00:00:00
1255	10	NOVA OLINDA DO MARANHÃO	2010-03-11 00:00:00
1256	10	OLHO D ÁGUA DAS CUNHÃS	2010-03-11 00:00:00
1257	10	OLINDA NOVA DO MARANHÃO	2010-03-11 00:00:00
1258	10	PAÇO DO LUMIAR	2010-03-11 00:00:00
1259	10	PALMEIRÂNDIA	2010-03-11 00:00:00
1260	10	PARAIBANO	2010-03-11 00:00:00
1261	10	PARNARAMA	2010-03-11 00:00:00
1262	10	PASSAGEM FRANCA	2010-03-11 00:00:00
1263	10	PASTOS BONS	2010-03-11 00:00:00
1264	10	PAULINO NEVES	2010-03-11 00:00:00
1265	10	PAULO RAMOS	2010-03-11 00:00:00
1266	10	PEDREIRAS	2010-03-11 00:00:00
1267	10	PEDRO DO ROSÁRIO	2010-03-11 00:00:00
1268	10	PENALVA	2010-03-11 00:00:00
1269	10	PERI MIRIM	2010-03-11 00:00:00
1270	10	PERITORÓ	2010-03-11 00:00:00
1271	10	PINDARÉ-MIRIM	2010-03-11 00:00:00
1272	10	PINHEIRO	2010-03-11 00:00:00
1273	10	PIO XII	2010-03-11 00:00:00
1274	10	PIRAPEMAS	2010-03-11 00:00:00
1275	10	POÇÃO DE PEDRAS	2010-03-11 00:00:00
1276	10	PORTO FRANCO	2010-03-11 00:00:00
1277	10	PORTO RICO DO MARANHÃO	2010-03-11 00:00:00
1278	10	PRESIDENTE DUTRA	2010-03-11 00:00:00
1279	10	PRESIDENTE JUSCELINO	2010-03-11 00:00:00
1280	10	PRESIDENTE MÉDICI	2010-03-11 00:00:00
1281	10	PRESIDENTE SARNEY	2010-03-11 00:00:00
1282	10	PRESIDENTE VARGAS	2010-03-11 00:00:00
1283	10	PRIMEIRA CRUZ	2010-03-11 00:00:00
1284	10	RAPOSA	2010-03-11 00:00:00
1285	10	RIACHÃO	2010-03-11 00:00:00
1286	10	RIBAMAR FIQUENE	2010-03-11 00:00:00
1287	10	ROSÁRIO	2010-03-11 00:00:00
1288	10	SAMBAÍBA	2010-03-11 00:00:00
1289	10	SANTA FILOMENA DO MARANHÃO	2010-03-11 00:00:00
1290	10	SANTA HELENA	2010-03-11 00:00:00
1291	10	SANTA INÊS	2010-03-11 00:00:00
1292	10	SANTA LUZIA	2010-03-11 00:00:00
1293	10	SANTA LUZIA DO PARUÁ	2010-03-11 00:00:00
1294	10	SANTA QUITÉRIA DO MARANHÃO	2010-03-11 00:00:00
1295	10	SANTA RITA	2010-03-11 00:00:00
1296	10	SANTANA DO MARANHÃO	2010-03-11 00:00:00
1297	10	SANTO AMARO DO MARANHÃO	2010-03-11 00:00:00
1298	10	SANTO ANTÔNIO DOS LOPES	2010-03-11 00:00:00
1299	10	SÃO BENEDITO DO RIO PRETO	2010-03-11 00:00:00
1300	10	SÃO BENTO	2010-03-11 00:00:00
1301	10	SÃO BERNARDO	2010-03-11 00:00:00
1302	10	SÃO DOMINGOS DO AZEITÃO	2010-03-11 00:00:00
1303	10	SÃO DOMINGOS DO MARANHÃO	2010-03-11 00:00:00
1304	10	SÃO FÉLIX DE BALSAS	2010-03-11 00:00:00
1305	10	SÃO FRANCISCO DO BREJÃO	2010-03-11 00:00:00
1306	10	SÃO FRANCISCO DO MARANHÃO	2010-03-11 00:00:00
1307	10	SÃO JOÃO BATISTA	2010-03-11 00:00:00
1308	10	SÃO JOÃO DO CARU	2010-03-11 00:00:00
1309	10	SÃO JOÃO DO PARAÍSO	2010-03-11 00:00:00
1310	10	SÃO JOÃO DO SÓTER	2010-03-11 00:00:00
1311	10	SÃO JOÃO DOS PATOS	2010-03-11 00:00:00
1312	10	SÃO JOSÉ DE RIBAMAR	2010-03-11 00:00:00
1313	10	SÃO JOSÉ DOS BASÍLIOS	2010-03-11 00:00:00
1314	10	SÃO LUÍS	2010-03-11 00:00:00
1315	10	SÃO LUÍS GONZAGA DO MARANHÃO	2010-03-11 00:00:00
1316	10	SÃO MATEUS DO MARANHÃO	2010-03-11 00:00:00
1317	10	SÃO PEDRO DA ÁGUA BRANCA	2010-03-11 00:00:00
1318	10	SÃO PEDRO DOS CRENTES	2010-03-11 00:00:00
1319	10	SÃO RAIMUNDO DAS MANGABEIRAS	2010-03-11 00:00:00
1320	10	SÃO RAIMUNDO DO DOCA BEZERRA	2010-03-11 00:00:00
1321	10	SÃO ROBERTO	2010-03-11 00:00:00
1322	10	SÃO VICENTE FERRER	2010-03-11 00:00:00
1323	10	SATUBINHA	2010-03-11 00:00:00
1324	10	SENADOR ALEXANDRE COSTA	2010-03-11 00:00:00
1325	10	SENADOR LA ROQUE	2010-03-11 00:00:00
1326	10	SERRANO DO MARANHÃO	2010-03-11 00:00:00
1327	10	SÍTIO NOVO	2010-03-11 00:00:00
1328	10	SUCUPIRA DO NORTE	2010-03-11 00:00:00
1329	10	SUCUPIRA DO RIACHÃO	2010-03-11 00:00:00
1330	10	TASSO FRAGOSO	2010-03-11 00:00:00
1331	10	TIMBIRAS	2010-03-11 00:00:00
1332	10	TIMON	2010-03-11 00:00:00
1333	10	TRIZIDELA DO VALE	2010-03-11 00:00:00
1334	10	TUFILÂNDIA	2010-03-11 00:00:00
1335	10	TUNTUM	2010-03-11 00:00:00
1336	10	TURIAÇU	2010-03-11 00:00:00
1337	10	TURILÂNDIA	2010-03-11 00:00:00
1338	10	TUTÓIA	2010-03-11 00:00:00
1339	10	URBANO SANTOS	2010-03-11 00:00:00
1340	10	VARGEM GRANDE	2010-03-11 00:00:00
1341	10	VIANA	2010-03-11 00:00:00
1342	10	VILA NOVA DOS MARTÍRIOS	2010-03-11 00:00:00
1343	10	VITÓRIA DO MEARIM	2010-03-11 00:00:00
1344	10	VITORINO FREIRE	2010-03-11 00:00:00
1345	10	ZÉ DOCA	2010-03-11 00:00:00
1347	11	ABAETÉ	2010-03-11 00:00:00
1348	11	ABRE CAMPO	2010-03-11 00:00:00
1349	11	ACAIACA	2010-03-11 00:00:00
1350	11	AÇUCENA	2010-03-11 00:00:00
1351	11	ÁGUA BOA	2010-03-11 00:00:00
1352	11	ÁGUA COMPRIDA	2010-03-11 00:00:00
1353	11	AGUANIL	2010-03-11 00:00:00
1354	11	ÁGUAS FORMOSAS	2010-03-11 00:00:00
1355	11	ÁGUAS VERMELHAS	2010-03-11 00:00:00
1356	11	AIMORÉS	2010-03-11 00:00:00
1357	11	AIURUOCA	2010-03-11 00:00:00
1358	11	ALAGOA	2010-03-11 00:00:00
1359	11	ALBERTINA	2010-03-11 00:00:00
1360	11	ALÉM PARAÍBA	2010-03-11 00:00:00
1361	11	ALFENAS	2010-03-11 00:00:00
1362	11	ALFREDO VASCONCELOS	2010-03-11 00:00:00
1363	11	ALMENARA	2010-03-11 00:00:00
1364	11	ALPERCATA	2010-03-11 00:00:00
1365	11	ALPINÓPOLIS	2010-03-11 00:00:00
1366	11	ALTEROSA	2010-03-11 00:00:00
1367	11	ALTO CAPARAÓ	2010-03-11 00:00:00
1368	11	ALTO JEQUITIBÁ	2010-03-11 00:00:00
1369	11	ALTO RIO DOCE	2010-03-11 00:00:00
1370	11	ALVARENGA	2010-03-11 00:00:00
1371	11	ALVINÓPOLIS	2010-03-11 00:00:00
1372	11	ALVORADA DE MINAS	2010-03-11 00:00:00
1373	11	AMPARO DA SERRA	2010-03-11 00:00:00
1374	11	ANDRADAS	2010-03-11 00:00:00
1375	11	ANDRELÂNDIA	2010-03-11 00:00:00
1376	11	ANGELÂNDIA	2010-03-11 00:00:00
1377	11	ANTÔNIO CARLOS	2010-03-11 00:00:00
1378	11	ANTÔNIO DIAS	2010-03-11 00:00:00
1379	11	ANTÔNIO PRADO DE MINAS	2010-03-11 00:00:00
1380	11	ARAÇAÍ	2010-03-11 00:00:00
1381	11	ARACITABA	2010-03-11 00:00:00
1382	11	ARAÇUAÍ	2010-03-11 00:00:00
1383	11	ARAGUARI	2010-03-11 00:00:00
1384	11	ARANTINA	2010-03-11 00:00:00
1385	11	ARAPONGA	2010-03-11 00:00:00
1386	11	ARAPORÃ	2010-03-11 00:00:00
1387	11	ARAPUA	2010-03-11 00:00:00
1388	11	ARAÚJOS	2010-03-11 00:00:00
1389	11	ARAXÁ	2010-03-11 00:00:00
1390	11	ARCEBURGO	2010-03-11 00:00:00
1391	11	ARCOS	2010-03-11 00:00:00
1392	11	AREADO	2010-03-11 00:00:00
1393	11	ARGIRITA	2010-03-11 00:00:00
1394	11	ARICANDUVA	2010-03-11 00:00:00
1395	11	ARINOS	2010-03-11 00:00:00
1396	11	ASTOLFO DUTRA	2010-03-11 00:00:00
1397	11	ATALÉIA	2010-03-11 00:00:00
1398	11	AUGUSTO DE LIMA	2010-03-11 00:00:00
1399	11	BAEPENDI	2010-03-11 00:00:00
1400	11	BALDIM	2010-03-11 00:00:00
1401	11	BAMBUÍ	2010-03-11 00:00:00
1402	11	BANDEIRA	2010-03-11 00:00:00
1403	11	BANDEIRA DO SUL	2010-03-11 00:00:00
1404	11	BARÃO DE COCAIS	2010-03-11 00:00:00
1405	11	BARÃO DE MONTE ALTO	2010-03-11 00:00:00
1406	11	BARBACENA	2010-03-11 00:00:00
1407	11	BARRA LONGA	2010-03-11 00:00:00
1408	11	BARROSO	2010-03-11 00:00:00
1409	11	BELA VISTA DE MINAS	2010-03-11 00:00:00
1410	11	BELMIRO BRAGA	2010-03-11 00:00:00
1411	11	BELO HORIZONTE	2010-03-11 00:00:00
1412	11	BELO ORIENTE	2010-03-11 00:00:00
1413	11	BELO VALE	2010-03-11 00:00:00
1414	11	BERILO	2010-03-11 00:00:00
1415	11	BERIZAL	2010-03-11 00:00:00
1416	11	BERTÓPOLIS	2010-03-11 00:00:00
1417	11	BETIM	2010-03-11 00:00:00
1418	11	BIAS FORTES	2010-03-11 00:00:00
1419	11	BICAS	2010-03-11 00:00:00
1420	11	BIQUINHAS	2010-03-11 00:00:00
1421	11	BOA ESPERANÇA	2010-03-11 00:00:00
1422	11	BOCAINA DE MINAS	2010-03-11 00:00:00
1423	11	BOCAIÚVA	2010-03-11 00:00:00
1424	11	BOM DESPACHO	2010-03-11 00:00:00
1425	11	BOM JARDIM DE MINAS	2010-03-11 00:00:00
1426	11	BOM JESUS DA PENHA	2010-03-11 00:00:00
1427	11	BOM JESUS DO AMPARO	2010-03-11 00:00:00
1428	11	BOM JESUS DO GALHO	2010-03-11 00:00:00
1429	11	BOM REPOUSO	2010-03-11 00:00:00
1430	11	BOM SUCESSO	2010-03-11 00:00:00
1431	11	BONFIM	2010-03-11 00:00:00
1432	11	BONFINÓPOLIS DE MINAS	2010-03-11 00:00:00
1433	11	BONITO DE MINAS	2010-03-11 00:00:00
1434	11	BORDA DA MATA	2010-03-11 00:00:00
1435	11	BOTELHOS	2010-03-11 00:00:00
1436	11	BOTUMIRIM	2010-03-11 00:00:00
1437	11	BRÁS PIRES	2010-03-11 00:00:00
1438	11	BRASILÂNDIA DE MINAS	2010-03-11 00:00:00
1439	11	BRASÍLIA DE MINAS	2010-03-11 00:00:00
1440	11	BRASÓPOLIS	2010-03-11 00:00:00
1441	11	BRAÚNAS	2010-03-11 00:00:00
1442	11	BRUMADINHO	2010-03-11 00:00:00
1443	11	BUENO BRANDÃO	2010-03-11 00:00:00
1444	11	BUENÓPOLIS	2010-03-11 00:00:00
1445	11	BUGRE	2010-03-11 00:00:00
1446	11	BURITIS	2010-03-11 00:00:00
1447	11	BURITIZEIRO	2010-03-11 00:00:00
1448	11	CABECEIRA GRANDE	2010-03-11 00:00:00
1449	11	CABO VERDE	2010-03-11 00:00:00
1450	11	CACHOEIRA DA PRATA	2010-03-11 00:00:00
1451	11	CACHOEIRA DE MINAS	2010-03-11 00:00:00
1452	11	CACHOEIRA DE PAJEÚ	2010-03-11 00:00:00
1453	11	CACHOEIRA DOURADA	2010-03-11 00:00:00
1454	11	CAETANÓPOLIS	2010-03-11 00:00:00
1455	11	CAETÉ	2010-03-11 00:00:00
1456	11	CAIANA	2010-03-11 00:00:00
1457	11	CAJURI	2010-03-11 00:00:00
1458	11	CALDAS	2010-03-11 00:00:00
1459	11	CAMACHO	2010-03-11 00:00:00
1460	11	CAMANDUCAIA	2010-03-11 00:00:00
1461	11	CAMBUÍ	2010-03-11 00:00:00
1462	11	CAMBUQUIRA	2010-03-11 00:00:00
1463	11	CAMPANÁRIO	2010-03-11 00:00:00
1464	11	CAMPANHA	2010-03-11 00:00:00
1465	11	CAMPESTRE	2010-03-11 00:00:00
1466	11	CAMPINA VERDE	2010-03-11 00:00:00
1467	11	CAMPO AZUL	2010-03-11 00:00:00
1468	11	CAMPO BELO	2010-03-11 00:00:00
1469	11	CAMPO DO MEIO	2010-03-11 00:00:00
1470	11	CAMPO FLORIDO	2010-03-11 00:00:00
1471	11	CAMPOS ALTOS	2010-03-11 00:00:00
1472	11	CAMPOS GERAIS	2010-03-11 00:00:00
1473	11	CANA VERDE	2010-03-11 00:00:00
1474	11	CANAÃ	2010-03-11 00:00:00
1475	11	CANÁPOLIS	2010-03-11 00:00:00
1476	11	CANDEIAS	2010-03-11 00:00:00
1477	11	CANTAGALO	2010-03-11 00:00:00
1478	11	CAPARAÓ	2010-03-11 00:00:00
1479	11	CAPELA NOVA	2010-03-11 00:00:00
1480	11	CAPELINHA	2010-03-11 00:00:00
1481	11	CAPETINGA	2010-03-11 00:00:00
1482	11	CAPIM BRANCO	2010-03-11 00:00:00
1483	11	CAPINÓPOLIS	2010-03-11 00:00:00
1484	11	CAPITÃO ANDRADE	2010-03-11 00:00:00
1485	11	CAPITÃO ENÉAS	2010-03-11 00:00:00
1486	11	CAPITÓLIO	2010-03-11 00:00:00
1487	11	CAPURITA	2010-03-11 00:00:00
1488	11	CARAÍ	2010-03-11 00:00:00
1489	11	CARANAÍBA	2010-03-11 00:00:00
1490	11	CARANDAÍ	2010-03-11 00:00:00
1491	11	CARANGOLA	2010-03-11 00:00:00
1492	11	CARATINGA	2010-03-11 00:00:00
1493	11	CARBONITA	2010-03-11 00:00:00
1494	11	CAREAÇU	2010-03-11 00:00:00
1495	11	CARLOS CHAGAS	2010-03-11 00:00:00
1496	11	CARMÉSIA	2010-03-11 00:00:00
1497	11	CARMO DA CACHOEIRA	2010-03-11 00:00:00
1498	11	CARMO DA MATA	2010-03-11 00:00:00
1499	11	CARMO DE MINAS	2010-03-11 00:00:00
1500	11	CARMO DO CAJURU	2010-03-11 00:00:00
1501	11	CARMO DO PARANAÍBA	2010-03-11 00:00:00
1502	11	CARMO DO RIO CLARO	2010-03-11 00:00:00
1503	11	CARMÓPOLIS DE MINAS	2010-03-11 00:00:00
1504	11	CARNEIRINHO	2010-03-11 00:00:00
1505	11	CARRANCAS	2010-03-11 00:00:00
1506	11	CARVALHÓPOLIS	2010-03-11 00:00:00
1507	11	CARVALHOS	2010-03-11 00:00:00
1508	11	CASA GRANDE	2010-03-11 00:00:00
1509	11	CASCALHO RICO	2010-03-11 00:00:00
1510	11	CÁSSIA	2010-03-11 00:00:00
1511	11	CATAGUASES	2010-03-11 00:00:00
1512	11	CATAS ALTAS	2010-03-11 00:00:00
1513	11	CATAS ALTAS DA NORUEGA	2010-03-11 00:00:00
1514	11	CATUJI	2010-03-11 00:00:00
1515	11	CATUTI	2010-03-11 00:00:00
1516	11	CAXAMBU	2010-03-11 00:00:00
1517	11	CEDRO DO ABAETÉ	2010-03-11 00:00:00
1518	11	CENTRAL DE MINAS	2010-03-11 00:00:00
1519	11	CENTRALINA	2010-03-11 00:00:00
1520	11	CHÁCARA	2010-03-11 00:00:00
1521	11	CHALE	2010-03-11 00:00:00
1522	11	CHAPADA DO NORTE	2010-03-11 00:00:00
1523	11	CHAPADA GAÚCHA	2010-03-11 00:00:00
1524	11	CHIADOR	2010-03-11 00:00:00
1525	11	CIPOTÂNEA	2010-03-11 00:00:00
1526	11	CLARAVAL	2010-03-11 00:00:00
1527	11	CLARO DOS POÇOES	2010-03-11 00:00:00
1528	11	CLÁUDIO	2010-03-11 00:00:00
1529	11	COIMBRA	2010-03-11 00:00:00
1530	11	COLUNA	2010-03-11 00:00:00
1531	11	COMENDADOR GOMES	2010-03-11 00:00:00
1532	11	COMERCINHO	2010-03-11 00:00:00
1533	11	CONCEIÇÃO DA APARECIDA	2010-03-11 00:00:00
1534	11	CONCEIÇÃO DA BARRA DE MINAS	2010-03-11 00:00:00
1535	11	CONCEIÇÃO DAS ALAGOAS	2010-03-11 00:00:00
1536	11	CONCEIÇÃO DAS PEDRAS	2010-03-11 00:00:00
1537	11	CONCEIÇÃO DE IPANEMA	2010-03-11 00:00:00
1538	11	CONCEIÇÃO DO MATO DENTRO	2010-03-11 00:00:00
1539	11	CONCEIÇÃO DO PARÁ	2010-03-11 00:00:00
1540	11	CONCEIÇÃO DO RIO VERDE	2010-03-11 00:00:00
1541	11	CONCEIÇÃO DOS OUROS	2010-03-11 00:00:00
1542	11	CÔNEGO MARINHO	2010-03-11 00:00:00
1543	11	CONFINS	2010-03-11 00:00:00
1544	11	CONGONHAL	2010-03-11 00:00:00
1545	11	CONGONHAS	2010-03-11 00:00:00
1546	11	CONGONHAS DO NORTE	2010-03-11 00:00:00
1547	11	CONQUISTA	2010-03-11 00:00:00
1548	11	CONSELHEIRO LAFAIETE	2010-03-11 00:00:00
1549	11	CONSELHEIRO PENA	2010-03-11 00:00:00
1550	11	CONSOLAÇÃO	2010-03-11 00:00:00
1551	11	CONTAGEM	2010-03-11 00:00:00
1552	11	COQUEIRAL	2010-03-11 00:00:00
1553	11	CORAÇÃO DE JESUS	2010-03-11 00:00:00
1554	11	CORDISBURGO	2010-03-11 00:00:00
1555	11	CORDISLÂNDIA	2010-03-11 00:00:00
1556	11	CORINTO	2010-03-11 00:00:00
1557	11	COROACI	2010-03-11 00:00:00
1558	11	COROMANDEL	2010-03-11 00:00:00
1559	11	CORONEL FABRICIANO	2010-03-11 00:00:00
1560	11	CORONEL MURTA	2010-03-11 00:00:00
1561	11	CORONEL PACHECO	2010-03-11 00:00:00
1562	11	CORONEL XAVIER CHAVES	2010-03-11 00:00:00
1563	11	CÓRREGO DANTA	2010-03-11 00:00:00
1564	11	CÓRREGO DO BOM JESUS	2010-03-11 00:00:00
1565	11	CÓRREGO FUNDO	2010-03-11 00:00:00
1566	11	CÓRREGO NOVO	2010-03-11 00:00:00
1567	11	COUTO DE MAGALHÃES DE MINAS	2010-03-11 00:00:00
1568	11	CRISÓLITA	2010-03-11 00:00:00
1569	11	CRISTAIS	2010-03-11 00:00:00
1570	11	CRISTÁLIA	2010-03-11 00:00:00
1571	11	CRISTIANO OTONI	2010-03-11 00:00:00
1572	11	CRISTINA	2010-03-11 00:00:00
1573	11	CRUCILÂNDIA	2010-03-11 00:00:00
1574	11	CRUZEIRO DA FORTALEZA	2010-03-11 00:00:00
1575	11	CRUZÍLIA	2010-03-11 00:00:00
1576	11	CUPARAQUE	2010-03-11 00:00:00
1577	11	CURRAL DE DENTRO	2010-03-11 00:00:00
1578	11	CURVELO	2010-03-11 00:00:00
1579	11	DATAS	2010-03-11 00:00:00
1580	11	DELFIM MOREIRA	2010-03-11 00:00:00
1581	11	DELFINÓPOLIS	2010-03-11 00:00:00
1582	11	DELTA	2010-03-11 00:00:00
1583	11	DESCOBERTO	2010-03-11 00:00:00
1584	11	DESTERRO DE ENTRE RIOS	2010-03-11 00:00:00
1585	11	DESTERRO DO MELO	2010-03-11 00:00:00
1586	11	DIAMANTINA	2010-03-11 00:00:00
1587	11	DIOGO DE VASCONCELOS	2010-03-11 00:00:00
1588	11	DIONÍSIO	2010-03-11 00:00:00
1589	11	DIVINÉSIA	2010-03-11 00:00:00
1590	11	DIVINO	2010-03-11 00:00:00
1591	11	DIVINO DAS LARANJEIRAS	2010-03-11 00:00:00
1592	11	DIVINOLÂNDIA DE MINAS	2010-03-11 00:00:00
1593	11	DIVINÓPOLIS	2010-03-11 00:00:00
1594	11	DIVISA ALEGRE	2010-03-11 00:00:00
1595	11	DIVISA NOVA	2010-03-11 00:00:00
1596	11	DIVISÓPOLIS	2010-03-11 00:00:00
1597	11	DOM BOSCO	2010-03-11 00:00:00
1598	11	DOM CAVATI	2010-03-11 00:00:00
1599	11	DOM JOAQUIM	2010-03-11 00:00:00
1600	11	DOM SILVÉRIO	2010-03-11 00:00:00
1601	11	DOM VIÇOSO	2010-03-11 00:00:00
1602	11	DONA EUZÉBIA	2010-03-11 00:00:00
1603	11	DORES DE CAMPOS	2010-03-11 00:00:00
1604	11	DORES DE GUANHÃES	2010-03-11 00:00:00
1605	11	DORES DO INDAIÁ	2010-03-11 00:00:00
1606	11	DORES DO TURVO	2010-03-11 00:00:00
1607	11	DORESÓPOLIS	2010-03-11 00:00:00
1608	11	DOURADOQUARA	2010-03-11 00:00:00
1609	11	DURANDE	2010-03-11 00:00:00
1610	11	ELÓI MENDES	2010-03-11 00:00:00
1611	11	ENGENHEIRO CALDAS	2010-03-11 00:00:00
1612	11	ENGENHEIRO NAVARRO	2010-03-11 00:00:00
1613	11	ENTRE FOLHAS	2010-03-11 00:00:00
1614	11	ENTRE RIOS DE MINAS	2010-03-11 00:00:00
1615	11	ERVÁLIA	2010-03-11 00:00:00
1616	11	ESMERALDAS	2010-03-11 00:00:00
1617	11	ESPERA FELIZ	2010-03-11 00:00:00
1618	11	ESPINOSA	2010-03-11 00:00:00
1619	11	ESPÍRITO SANTO DO DOURADO	2010-03-11 00:00:00
1620	11	ESTIVA	2010-03-11 00:00:00
1621	11	ESTRELA DALVA	2010-03-11 00:00:00
1622	11	ESTRELA DO INDAIÁ	2010-03-11 00:00:00
1623	11	ESTRELA DO SUL	2010-03-11 00:00:00
1624	11	EUGENÓPOLIS	2010-03-11 00:00:00
1625	11	EWBANK DA CÂMARA	2010-03-11 00:00:00
1626	11	EXTREMA	2010-03-11 00:00:00
1627	11	FAMA	2010-03-11 00:00:00
1628	11	FARIA LEMOS	2010-03-11 00:00:00
1629	11	FELÍCIO DOS SANTOS	2010-03-11 00:00:00
1630	11	FELISBURGO	2010-03-11 00:00:00
1631	11	FELIXLÂNDIA	2010-03-11 00:00:00
1632	11	FERNANDES TOURINHO	2010-03-11 00:00:00
1633	11	FERROS	2010-03-11 00:00:00
1634	11	FERVEDOURO	2010-03-11 00:00:00
1635	11	FLORESTAL	2010-03-11 00:00:00
1636	11	FORMIGA	2010-03-11 00:00:00
1637	11	FORMOSO	2010-03-11 00:00:00
1638	11	FORTALEZA DE MINAS	2010-03-11 00:00:00
1639	11	FORTUNA DE MINAS	2010-03-11 00:00:00
1640	11	FRANCISCO BADARÓ	2010-03-11 00:00:00
1641	11	FRANCISCO DUMONT	2010-03-11 00:00:00
1642	11	FRANCISCO SÁ	2010-03-11 00:00:00
1643	11	FRANCISCÓPOLIS	2010-03-11 00:00:00
1644	11	FREI GASPAR	2010-03-11 00:00:00
1645	11	FREI INOCÊNCIO	2010-03-11 00:00:00
1646	11	FREI LAGONEGRO	2010-03-11 00:00:00
1647	11	FRONTEIRA	2010-03-11 00:00:00
1648	11	FRONTEIRA DOS VALES	2010-03-11 00:00:00
1649	11	FRUTA DE LEITE	2010-03-11 00:00:00
1650	11	FRUTAL	2010-03-11 00:00:00
1651	11	FUNILÂNDIA	2010-03-11 00:00:00
1652	11	GALILÉIA	2010-03-11 00:00:00
1653	11	GAMELEIRAS	2010-03-11 00:00:00
1654	11	GLAUCILÂNDIA	2010-03-11 00:00:00
1655	11	GOIABEIRA	2010-03-11 00:00:00
1656	11	GOIANÁ	2010-03-11 00:00:00
1657	11	GONÇALVES	2010-03-11 00:00:00
1658	11	GONZAGA	2010-03-11 00:00:00
1659	11	GOUVEIA	2010-03-11 00:00:00
1660	11	GOVERNADOR VALADARES	2010-03-11 00:00:00
1661	11	GRÃO MOGOL	2010-03-11 00:00:00
1662	11	GRUPIARA	2010-03-11 00:00:00
1663	11	GUANHÃES	2010-03-11 00:00:00
1664	11	GUAPÉ	2010-03-11 00:00:00
1665	11	GUARACIABA	2010-03-11 00:00:00
1666	11	GUARACIAMA	2010-03-11 00:00:00
1667	11	GUARANÉSIA	2010-03-11 00:00:00
1668	11	GUARANI	2010-03-11 00:00:00
1669	11	GUARARA	2010-03-11 00:00:00
1670	11	GUARDA-MOR	2010-03-11 00:00:00
1671	11	GUAXUPÉ	2010-03-11 00:00:00
1672	11	GUIDOVAL	2010-03-11 00:00:00
1673	11	GUIMARÂNIA	2010-03-11 00:00:00
1674	11	GUIRICEMA	2010-03-11 00:00:00
1675	11	GURINHATÃ	2010-03-11 00:00:00
1676	11	HELIODORA	2010-03-11 00:00:00
1677	11	IAPU	2010-03-11 00:00:00
1678	11	IBERTIOGA	2010-03-11 00:00:00
1679	11	IBIA	2010-03-11 00:00:00
1680	11	IBIAI	2010-03-11 00:00:00
1681	11	IBIRACATU	2010-03-11 00:00:00
1682	11	IBIRACI	2010-03-11 00:00:00
1683	11	IBIRITÉ	2010-03-11 00:00:00
1684	11	IBITIÚRA DE MINAS	2010-03-11 00:00:00
1685	11	IBITURUNA	2010-03-11 00:00:00
1686	11	ICARAÍ DE MINAS	2010-03-11 00:00:00
1687	11	IGARAPÉ	2010-03-11 00:00:00
1688	11	IGARATINGA	2010-03-11 00:00:00
1689	11	IGUATAMA	2010-03-11 00:00:00
1690	11	IJACI	2010-03-11 00:00:00
1691	11	ILICINEA	2010-03-11 00:00:00
1692	11	IMBÉ DE MINAS	2010-03-11 00:00:00
1693	11	INCONFIDENTES	2010-03-11 00:00:00
1694	11	INDAIABIRA	2010-03-11 00:00:00
1695	11	INDIANÓPOLIS	2010-03-11 00:00:00
1696	11	INGAI	2010-03-11 00:00:00
1697	11	INHAPIM	2010-03-11 00:00:00
1698	11	INHAUMA	2010-03-11 00:00:00
1699	11	INIMUTABA	2010-03-11 00:00:00
1700	11	IPABA	2010-03-11 00:00:00
1701	11	IPANEMA	2010-03-11 00:00:00
1702	11	IPATINGA	2010-03-11 00:00:00
1703	11	IPIAÇU	2010-03-11 00:00:00
1704	11	IPUIUNA	2010-03-11 00:00:00
1705	11	IRAÍ DE MINAS	2010-03-11 00:00:00
1706	11	ITABIRA	2010-03-11 00:00:00
1707	11	ITABIRINHA DE MANTENA	2010-03-11 00:00:00
1708	11	ITABIRITO	2010-03-11 00:00:00
1709	11	ITACAMBIRA	2010-03-11 00:00:00
1710	11	ITACARAMBI	2010-03-11 00:00:00
1711	11	ITAGUARA	2010-03-11 00:00:00
1712	11	ITAÍPE	2010-03-11 00:00:00
1713	11	ITAJUBÁ	2010-03-11 00:00:00
1714	11	ITAMARANDIBA	2010-03-11 00:00:00
1715	11	ITAMARATI DE MINAS	2010-03-11 00:00:00
1716	11	ITAMBACURI	2010-03-11 00:00:00
1717	11	ITAMBÉ DO MATO DENTRO	2010-03-11 00:00:00
1718	11	ITAMOGI	2010-03-11 00:00:00
1719	11	ITAMONTE	2010-03-11 00:00:00
1720	11	ITANHANDU	2010-03-11 00:00:00
1721	11	ITANHOMI	2010-03-11 00:00:00
1722	11	ITAOBIM	2010-03-11 00:00:00
1723	11	ITAPAGIPE	2010-03-11 00:00:00
1724	11	ITAPECERICA	2010-03-11 00:00:00
1725	11	ITAPEVA	2010-03-11 00:00:00
1726	11	ITATIAIUÇU	2010-03-11 00:00:00
1727	11	ITAÚ DE MINAS	2010-03-11 00:00:00
1728	11	ITAÚNA	2010-03-11 00:00:00
1729	11	ITAVERAVA	2010-03-11 00:00:00
1730	11	ITINGA	2010-03-11 00:00:00
1731	11	ITUETA	2010-03-11 00:00:00
1732	11	ITUIUTABA	2010-03-11 00:00:00
1733	11	ITUMIRIM	2010-03-11 00:00:00
1734	11	ITURAMA	2010-03-11 00:00:00
1735	11	ITUTINGA	2010-03-11 00:00:00
1736	11	JABOTICATUBAS	2010-03-11 00:00:00
1737	11	JACINTO	2010-03-11 00:00:00
1738	11	JACUÍ	2010-03-11 00:00:00
1739	11	JACUTINGA	2010-03-11 00:00:00
1740	11	JAGUARAÇU	2010-03-11 00:00:00
1741	11	JAÍBA	2010-03-11 00:00:00
1742	11	JAMPRUCA	2010-03-11 00:00:00
1743	11	JANAÚBA	2010-03-11 00:00:00
1744	11	JANUÁRIA	2010-03-11 00:00:00
1745	11	JAPARAÍBA	2010-03-11 00:00:00
1746	11	JAPONVAR	2010-03-11 00:00:00
1747	11	JECEABA	2010-03-11 00:00:00
1748	11	JENIPAPO DE MINAS	2010-03-11 00:00:00
1749	11	JEQUERI	2010-03-11 00:00:00
1750	11	JEQUITAÍ	2010-03-11 00:00:00
1751	11	JEQUITIBÁ	2010-03-11 00:00:00
1752	11	JEQUITINHONHA	2010-03-11 00:00:00
1753	11	JESUÂNIA	2010-03-11 00:00:00
1754	11	JOAIMA	2010-03-11 00:00:00
1755	11	JOANÉSIA	2010-03-11 00:00:00
1756	11	JOÃO MONLEVADE	2010-03-11 00:00:00
1757	11	JOÃO PINHEIRO	2010-03-11 00:00:00
1758	11	JOAQUIM FELÍCIO	2010-03-11 00:00:00
1759	11	JORDÂNIA	2010-03-11 00:00:00
1760	11	JOSÉ GONÇALVES DE MINAS	2010-03-11 00:00:00
1761	11	JOSÉ RAYDAN	2010-03-11 00:00:00
1762	11	JOSENÓPOLIS	2010-03-11 00:00:00
1763	11	JUATUBA	2010-03-11 00:00:00
1764	11	JUIZ DE FORA	2010-03-11 00:00:00
1765	11	JURAMENTO	2010-03-11 00:00:00
1766	11	JURUAIA	2010-03-11 00:00:00
1767	11	JUVENILIA	2010-03-11 00:00:00
1768	11	LADAINHA	2010-03-11 00:00:00
1769	11	LAGAMAR	2010-03-11 00:00:00
1770	11	LAGOA DA PRATA	2010-03-11 00:00:00
1771	11	LAGOA DOS PATOS	2010-03-11 00:00:00
1772	11	LAGOA DOURADA	2010-03-11 00:00:00
1773	11	LAGOA FORMOSA	2010-03-11 00:00:00
1774	11	LAGOA GRANDE	2010-03-11 00:00:00
1775	11	LAGOA SANTA	2010-03-11 00:00:00
1776	11	LAJINHA	2010-03-11 00:00:00
1777	11	LAMBARI	2010-03-11 00:00:00
1778	11	LAMIM	2010-03-11 00:00:00
1779	11	LARANJAL	2010-03-11 00:00:00
1780	11	LASSANCE	2010-03-11 00:00:00
1781	11	LAVRAS	2010-03-11 00:00:00
1782	11	LEANDRO FERREIRA	2010-03-11 00:00:00
1783	11	LEME DO PRADO	2010-03-11 00:00:00
1784	11	LEOPOLDINA	2010-03-11 00:00:00
1785	11	LIBERDADE	2010-03-11 00:00:00
1786	11	LIMA DUARTE	2010-03-11 00:00:00
1787	11	LIMEIRA DO OESTE	2010-03-11 00:00:00
1788	11	LONTRA	2010-03-11 00:00:00
1789	11	LUISLÂNDIA	2010-03-11 00:00:00
1790	11	LUIZBURGO	2010-03-11 00:00:00
1791	11	LUMINÁRIAS	2010-03-11 00:00:00
1792	11	LUZ	2010-03-11 00:00:00
1793	11	MACHACALIS	2010-03-11 00:00:00
1794	11	MACHADO	2010-03-11 00:00:00
1795	11	MADRE DE DEUS DE MINAS	2010-03-11 00:00:00
1796	11	MALACACHETA	2010-03-11 00:00:00
1797	11	MAMONAS	2010-03-11 00:00:00
1798	11	MANGA	2010-03-11 00:00:00
1799	11	MANHUAÇU	2010-03-11 00:00:00
1800	11	MANHUMIRIM	2010-03-11 00:00:00
1801	11	MANTENA	2010-03-11 00:00:00
1802	11	MAR DE ESPANHA	2010-03-11 00:00:00
1803	11	MARAVILHAS	2010-03-11 00:00:00
1804	11	MARIA DA FÉ	2010-03-11 00:00:00
1805	11	MARIANA	2010-03-11 00:00:00
1806	11	MARILAC	2010-03-11 00:00:00
1807	11	MÁRIO CAMPOS	2010-03-11 00:00:00
1808	11	MARIPA DE MINAS	2010-03-11 00:00:00
1809	11	MARLIÉRIA	2010-03-11 00:00:00
1810	11	MARMELÓPOLIS	2010-03-11 00:00:00
1811	11	MARTINHO CAMPOS	2010-03-11 00:00:00
1812	11	MARTINS SOARES	2010-03-11 00:00:00
1813	11	MATA VERDE	2010-03-11 00:00:00
1814	11	MATERLÂNDIA	2010-03-11 00:00:00
1815	11	MATEUS LEME	2010-03-11 00:00:00
1816	11	MATHIAS LOBATO	2010-03-11 00:00:00
1817	11	MATIAS BARBOSA	2010-03-11 00:00:00
1818	11	MATIAS CARDOSO	2010-03-11 00:00:00
1819	11	MATIPÓ	2010-03-11 00:00:00
1820	11	MATO VERDE	2010-03-11 00:00:00
1821	11	MATOZINHOS	2010-03-11 00:00:00
1822	11	MATUTINA	2010-03-11 00:00:00
1823	11	MEDEIROS	2010-03-11 00:00:00
1824	11	MEDINA	2010-03-11 00:00:00
1825	11	MENDES PIMENTEL	2010-03-11 00:00:00
1826	11	MERCÊS	2010-03-11 00:00:00
1827	11	MESQUITA	2010-03-11 00:00:00
1828	11	MINAS NOVAS	2010-03-11 00:00:00
1829	11	MINDURI	2010-03-11 00:00:00
1830	11	MIRABELA	2010-03-11 00:00:00
1831	11	MIRADOURO	2010-03-11 00:00:00
1832	11	MIRAÍ	2010-03-11 00:00:00
1833	11	MIRAVÂNIA	2010-03-11 00:00:00
1834	11	MOEDA	2010-03-11 00:00:00
1835	11	MOEMA	2010-03-11 00:00:00
1836	11	MONJOLOS	2010-03-11 00:00:00
1837	11	MONSENHOR PAULO	2010-03-11 00:00:00
1838	11	MONTALVÂNIA	2010-03-11 00:00:00
1839	11	MONTE ALEGRE DE MINAS	2010-03-11 00:00:00
1840	11	MONTE AZUL	2010-03-11 00:00:00
1841	11	MONTE BELO	2010-03-11 00:00:00
1842	11	MONTE CARMELO	2010-03-11 00:00:00
1843	11	MONTE FORMOSO	2010-03-11 00:00:00
1844	11	MONTE SANTO DE MINAS	2010-03-11 00:00:00
1845	11	MONTE SIÃO	2010-03-11 00:00:00
1846	11	MONTES CLAROS	2010-03-11 00:00:00
1847	11	MONTEZUMA	2010-03-11 00:00:00
1848	11	MORADA NOVA DE MINAS	2010-03-11 00:00:00
1849	11	MORRO DO GARÇA	2010-03-11 00:00:00
1850	11	MORRO DO PILAR	2010-03-11 00:00:00
1851	11	MUNHOZ	2010-03-11 00:00:00
1852	11	MURIAÉ	2010-03-11 00:00:00
1853	11	MUTUM	2010-03-11 00:00:00
1854	11	MUZAMBINHO	2010-03-11 00:00:00
1855	11	NACIP RAYDAN	2010-03-11 00:00:00
1856	11	NANUQUE	2010-03-11 00:00:00
1857	11	NAQUE	2010-03-11 00:00:00
1858	11	NATALÂNDIA	2010-03-11 00:00:00
1859	11	NATÉRCIA	2010-03-11 00:00:00
1860	11	NAZARENO	2010-03-11 00:00:00
1861	11	NEPOMUCENO	2010-03-11 00:00:00
1862	11	NINHEIRA	2010-03-11 00:00:00
1863	11	NOVA BELÉM	2010-03-11 00:00:00
1864	11	NOVA ERA	2010-03-11 00:00:00
1865	11	NOVA LIMA	2010-03-11 00:00:00
1866	11	NOVA MÓDICA	2010-03-11 00:00:00
1867	11	NOVA PONTE	2010-03-11 00:00:00
1868	11	NOVA PORTEIRINHA	2010-03-11 00:00:00
1869	11	NOVA RESENDE	2010-03-11 00:00:00
1870	11	NOVA SERRANA	2010-03-11 00:00:00
1871	11	NOVA UNIÃO	2010-03-11 00:00:00
1872	11	NOVO CRUZEIRO	2010-03-11 00:00:00
1873	11	NOVO ORIENTE DE MINAS	2010-03-11 00:00:00
1874	11	NOVORIZONTE	2010-03-11 00:00:00
1875	11	OLARIA	2010-03-11 00:00:00
1876	11	OLHOS D ÁGUA	2010-03-11 00:00:00
1877	11	OLÍMPIO NORONHA	2010-03-11 00:00:00
1878	11	OLIVEIRA	2010-03-11 00:00:00
1879	11	OLIVEIRA FORTES	2010-03-11 00:00:00
1880	11	ONÇA DE PITANGUI	2010-03-11 00:00:00
1881	11	ORATÓRIOS	2010-03-11 00:00:00
1882	11	ORIZÂNIA	2010-03-11 00:00:00
1883	11	OURO BRANCO	2010-03-11 00:00:00
1884	11	OURO FINO	2010-03-11 00:00:00
1885	11	OURO PRETO	2010-03-11 00:00:00
1886	11	OURO VERDE DE MINAS	2010-03-11 00:00:00
1887	11	PADRE CARVALHO	2010-03-11 00:00:00
1888	11	PADRE PARAÍSO	2010-03-11 00:00:00
1889	11	PAI PEDRO	2010-03-11 00:00:00
1890	11	PAINEIRAS	2010-03-11 00:00:00
1891	11	PAINS	2010-03-11 00:00:00
1892	11	PAIVA	2010-03-11 00:00:00
1893	11	PALMA	2010-03-11 00:00:00
1894	11	PALMÓPOLIS	2010-03-11 00:00:00
1895	11	PAPAGAIOS	2010-03-11 00:00:00
1896	11	PARÁ DE MINAS	2010-03-11 00:00:00
1897	11	PARACATU	2010-03-11 00:00:00
1898	11	PARAGUAÇU	2010-03-11 00:00:00
1899	11	PARAISÓPOLIS	2010-03-11 00:00:00
1900	11	PARAOPEBA	2010-03-11 00:00:00
1901	11	PASSA QUATRO	2010-03-11 00:00:00
1902	11	PASSA TEMPO	2010-03-11 00:00:00
1903	11	PASSA VINTE	2010-03-11 00:00:00
1904	11	PASSABEM	2010-03-11 00:00:00
1905	11	PASSOS	2010-03-11 00:00:00
1906	11	PATIS	2010-03-11 00:00:00
1907	11	PATOS DE MINAS	2010-03-11 00:00:00
1908	11	PATROCÍNIO	2010-03-11 00:00:00
1909	11	PATROCÍNIO DO MURIAÉ	2010-03-11 00:00:00
1910	11	PAULA CÂNDIDO	2010-03-11 00:00:00
1911	11	PAULISTAS	2010-03-11 00:00:00
1912	11	PAVÃO	2010-03-11 00:00:00
1913	11	PEÇANHA	2010-03-11 00:00:00
1914	11	PEDRA AZUL	2010-03-11 00:00:00
1915	11	PEDRA BONITA	2010-03-11 00:00:00
1916	11	PEDRA DO ANTA	2010-03-11 00:00:00
1917	11	PEDRA DO INDAIÁ	2010-03-11 00:00:00
1918	11	PEDRA DOURADA	2010-03-11 00:00:00
1919	11	PEDRALVA	2010-03-11 00:00:00
1920	11	PEDRAS DE MARIA DA CRUZ	2010-03-11 00:00:00
1921	11	PEDRINÓPOLIS	2010-03-11 00:00:00
1922	11	PEDRO LEOPOLDO	2010-03-11 00:00:00
1923	11	PEDRO TEIXEIRA	2010-03-11 00:00:00
1924	11	PEQUERI	2010-03-11 00:00:00
1925	11	PEQUI	2010-03-11 00:00:00
1926	11	PERDIGÃO	2010-03-11 00:00:00
1927	11	PERDIZES	2010-03-11 00:00:00
1928	11	PERDÕES	2010-03-11 00:00:00
1929	11	PERIQUITO	2010-03-11 00:00:00
1930	11	PESCADOR	2010-03-11 00:00:00
1931	11	PIAU	2010-03-11 00:00:00
1932	11	PIEDADE DE CARATINGA	2010-03-11 00:00:00
1933	11	PIEDADE DE PONTE NOVA	2010-03-11 00:00:00
1934	11	PIEDADE DO RIO GRANDE	2010-03-11 00:00:00
1935	11	PIEDADE DOS GERAIS	2010-03-11 00:00:00
1936	11	PIMENTA	2010-03-11 00:00:00
1937	11	PINGO D  ÁGUA	2010-03-11 00:00:00
1938	11	PINTÓPOLIS	2010-03-11 00:00:00
1939	11	PIRACEMA	2010-03-11 00:00:00
1940	11	PIRAJUBA	2010-03-11 00:00:00
1941	11	PIRANGA	2010-03-11 00:00:00
1942	11	PIRANGUÇU	2010-03-11 00:00:00
1943	11	PIRANGUINHO	2010-03-11 00:00:00
1944	11	PIRAPETINGA	2010-03-11 00:00:00
1945	11	PIRAPORA	2010-03-11 00:00:00
1946	11	PIRAÚBA	2010-03-11 00:00:00
1947	11	PITANGUI	2010-03-11 00:00:00
1948	11	PIUMHI	2010-03-11 00:00:00
1949	11	PLANURA	2010-03-11 00:00:00
1950	11	POÇO FUNDO	2010-03-11 00:00:00
1951	11	POÇOS DE CALDAS	2010-03-11 00:00:00
1952	11	POCRANE	2010-03-11 00:00:00
1953	11	POMPEU	2010-03-11 00:00:00
1954	11	PONTE NOVA	2010-03-11 00:00:00
1955	11	PONTO CHIQUE	2010-03-11 00:00:00
1956	11	PONTO DOS VOLANTES	2010-03-11 00:00:00
1957	11	PORTEIRINHA	2010-03-11 00:00:00
1958	11	PORTO FIRME	2010-03-11 00:00:00
1959	11	POTE	2010-03-11 00:00:00
1960	11	POUSO ALEGRE	2010-03-11 00:00:00
1961	11	POUSO ALTO	2010-03-11 00:00:00
1962	11	PRADOS	2010-03-11 00:00:00
1963	11	PRATA	2010-03-11 00:00:00
1964	11	PRATÁPOLIS	2010-03-11 00:00:00
1965	11	PRATINHA	2010-03-11 00:00:00
1966	11	PRESIDENTE BERNARDES	2010-03-11 00:00:00
1967	11	PRESIDENTE JUSCELINO	2010-03-11 00:00:00
1968	11	PRESIDENTE KUBITSCHEK	2010-03-11 00:00:00
1969	11	PRESIDENTE OLEGÁRIO	2010-03-11 00:00:00
1970	11	PRUDENTE DE MORAIS	2010-03-11 00:00:00
1971	11	QUARTEL GERAL	2010-03-11 00:00:00
1972	11	QUELUZITO	2010-03-11 00:00:00
1973	11	RAPOSOS	2010-03-11 00:00:00
1974	11	RAUL SOARES	2010-03-11 00:00:00
1975	11	RECREIO	2010-03-11 00:00:00
1976	11	REDUTO	2010-03-11 00:00:00
1977	11	RESENDE COSTA	2010-03-11 00:00:00
1978	11	RESPLENDOR	2010-03-11 00:00:00
1979	11	RESSAQUINHA	2010-03-11 00:00:00
1980	11	RIACHINHO	2010-03-11 00:00:00
1981	11	RIACHO DOS MACHADOS	2010-03-11 00:00:00
1982	11	RIBEIRÃO DAS NEVES	2010-03-11 00:00:00
1983	11	RIBEIRÃO VERMELHO	2010-03-11 00:00:00
1984	11	RIO ACIMA	2010-03-11 00:00:00
1985	11	RIO CASCA	2010-03-11 00:00:00
1986	11	RIO DO PRADO	2010-03-11 00:00:00
1987	11	RIO DOCE	2010-03-11 00:00:00
1988	11	RIO ESPERA	2010-03-11 00:00:00
1989	11	RIO MANSO	2010-03-11 00:00:00
1990	11	RIO NOVO	2010-03-11 00:00:00
1991	11	RIO PARANAÍBA	2010-03-11 00:00:00
1992	11	RIO PARDO DE MINAS	2010-03-11 00:00:00
1993	11	RIO PIRACICABA	2010-03-11 00:00:00
1994	11	RIO POMBA	2010-03-11 00:00:00
1995	11	RIO PRETO	2010-03-11 00:00:00
1996	11	RIO VERMELHO	2010-03-11 00:00:00
1997	11	RITÁPOLIS	2010-03-11 00:00:00
1998	11	ROCHEDO DE MINAS	2010-03-11 00:00:00
1999	11	RODEIRO	2010-03-11 00:00:00
2000	11	ROMARIA	2010-03-11 00:00:00
2001	11	ROSÁRIO DA LIMEIRA	2010-03-11 00:00:00
2002	11	RUBELITA	2010-03-11 00:00:00
2003	11	RUBIM	2010-03-11 00:00:00
2004	11	SABARÁ	2010-03-11 00:00:00
2005	11	SABINÓPOLIS	2010-03-11 00:00:00
2006	11	SACRAMENTO	2010-03-11 00:00:00
2007	11	SALINAS	2010-03-11 00:00:00
2008	11	SALTO DA DIVISA	2010-03-11 00:00:00
2009	11	SANTA BÁRBARA	2010-03-11 00:00:00
2010	11	SANTA BÁRBARA DO LESTE	2010-03-11 00:00:00
2011	11	SANTA BÁRBARA DO MONTE VERDE	2010-03-11 00:00:00
2012	11	SANTA BÁRBARA DO TUGÚRIO	2010-03-11 00:00:00
2013	11	SANTA CRUZ DE MINAS	2010-03-11 00:00:00
2014	11	SANTA CRUZ DE SALINAS	2010-03-11 00:00:00
2015	11	SANTA CRUZ DO ESCALVADO	2010-03-11 00:00:00
2016	11	SANTA EFIGÊNIA DE MINAS	2010-03-11 00:00:00
2017	11	SANTA FÉ DE MINAS	2010-03-11 00:00:00
2018	11	SANTA HELENA DE MINAS	2010-03-11 00:00:00
2019	11	SANTA JULIANA	2010-03-11 00:00:00
2020	11	SANTA LUZIA	2010-03-11 00:00:00
2021	11	SANTA MARGARIDA	2010-03-11 00:00:00
2022	11	SANTA MARIA DE ITABIRA	2010-03-11 00:00:00
2023	11	SANTA MARIA DO SALTO	2010-03-11 00:00:00
2024	11	SANTA MARIA DO SUAÇUI	2010-03-11 00:00:00
2025	11	SANTA RITA DE CALDAS	2010-03-11 00:00:00
2026	11	SANTA RITA DE MINAS	2010-03-11 00:00:00
2027	11	SANTA RITA DO IBITIPOCA	2010-03-11 00:00:00
2028	11	SANTA RITA DO ITUETO	2010-03-11 00:00:00
2029	11	SANTA RITA DO JACUTINGA	2010-03-11 00:00:00
2030	11	SANTA RITA DO SAPUCAÍ	2010-03-11 00:00:00
2031	11	SANTA ROSA DA SERRA	2010-03-11 00:00:00
2032	11	SANTA VITÓRIA	2010-03-11 00:00:00
2033	11	SANTANA DA VARGEM	2010-03-11 00:00:00
2034	11	SANTANA DE CATAGUASES	2010-03-11 00:00:00
2035	11	SANTANA DE PIRAPAMA	2010-03-11 00:00:00
2036	11	SANTANA DO DESERTO	2010-03-11 00:00:00
2037	11	SANTANA DO GARAMBÉU	2010-03-11 00:00:00
2038	11	SANTANA DO JACARÉ	2010-03-11 00:00:00
2039	11	SANTANA DO MANHUAÇU	2010-03-11 00:00:00
2040	11	SANTANA DO PARAÍSO	2010-03-11 00:00:00
2041	11	SANTANA DO RIACHO	2010-03-11 00:00:00
2042	11	SANTANA DOS MONTES	2010-03-11 00:00:00
2043	11	SANTO ANTÔNIO DO AMPARO	2010-03-11 00:00:00
2044	11	SANTO ANTÔNIO DO AVENTUREIRO	2010-03-11 00:00:00
2045	11	SANTO ANTÔNIO DO GRAMA	2010-03-11 00:00:00
2046	11	SANTO ANTÔNIO DO ITAMBÉ	2010-03-11 00:00:00
2047	11	SANTO ANTÔNIO DO JACINTO	2010-03-11 00:00:00
2048	11	SANTO ANTÔNIO DO MONTE	2010-03-11 00:00:00
2049	11	SANTO ANTÔNIO DO RETIRO	2010-03-11 00:00:00
2050	11	SANTO ANTÔNIO DO RIO ABAIXO	2010-03-11 00:00:00
2051	11	SANTO HIPÓLITO	2010-03-11 00:00:00
2052	11	SANTOS DUMONT	2010-03-11 00:00:00
2053	11	SÃO BENTO ABADE	2010-03-11 00:00:00
2054	11	SÃO BRÁS DO SUAÇUÍ	2010-03-11 00:00:00
2055	11	SÃO DOMINGOS DAS DORES	2010-03-11 00:00:00
2056	11	SÃO DOMINGOS DO PRATA	2010-03-11 00:00:00
2057	11	SÃO FÉLIX DE MINAS	2010-03-11 00:00:00
2058	11	SÃO FRANCISCO	2010-03-11 00:00:00
2059	11	SÃO FRANCISCO DE PAULA	2010-03-11 00:00:00
2060	11	SÃO FRANCISCO DE SALES	2010-03-11 00:00:00
2061	11	SÃO FRANCISCO DO GLÓRIA	2010-03-11 00:00:00
2062	11	SÃO GERALDO	2010-03-11 00:00:00
2063	11	SÃO GERALDO DA PIEDADE	2010-03-11 00:00:00
2064	11	SÃO GERALDO DO BAIXIO	2010-03-11 00:00:00
2065	11	SÃO GONÇALO DO ABAETÉ	2010-03-11 00:00:00
2066	11	SÃO GONÇALO DO PARÁ	2010-03-11 00:00:00
2067	11	SÃO GONÇALO DO RIO ABAIXO	2010-03-11 00:00:00
2068	11	SÃO GONÇALO DO RIO PRETO	2010-03-11 00:00:00
2069	11	SÃO GONÇALO DO SAPUCAÍ	2010-03-11 00:00:00
2070	11	SÃO GOTARDO	2010-03-11 00:00:00
2071	11	SÃO JOÃO BATISTA DO GLÓRIA	2010-03-11 00:00:00
2072	11	SÃO JOÃO DA LAGOA	2010-03-11 00:00:00
2073	11	SÃO JOÃO DA MATA	2010-03-11 00:00:00
2074	11	SÃO JOÃO DA PONTE	2010-03-11 00:00:00
2075	11	SÃO JOÃO DAS MISSÕES	2010-03-11 00:00:00
2076	11	SÃO JOÃO DEL REI	2010-03-11 00:00:00
2077	11	SÃO JOÃO DO MANHUAÇU	2010-03-11 00:00:00
2078	11	SÃO JOÃO DO MANTENINHA	2010-03-11 00:00:00
2079	11	SÃO JOÃO DO ORIENTE	2010-03-11 00:00:00
2080	11	SÃO JOÃO DO PACUÍ	2010-03-11 00:00:00
2081	11	SÃO JOÃO DO PARAÍSO	2010-03-11 00:00:00
2082	11	SÃO JOÃO EVANGELISTA	2010-03-11 00:00:00
2083	11	SÃO JOÃO NEPOMUCENO	2010-03-11 00:00:00
2084	11	SÃO JOAQUIM DE BICAS	2010-03-11 00:00:00
2085	11	SÃO JOSÉ DA BARRA	2010-03-11 00:00:00
2086	11	SÃO JOSÉ DA LAPA	2010-03-11 00:00:00
2087	11	SÃO JOSÉ DA SAFIRA	2010-03-11 00:00:00
2088	11	SÃO JOSÉ DA VARGINHA	2010-03-11 00:00:00
2089	11	SÃO JOSÉ DO ALEGRE	2010-03-11 00:00:00
2090	11	SÃO JOSÉ DO DIVINO	2010-03-11 00:00:00
2091	11	SÃO JOSÉ DO GOIABAL	2010-03-11 00:00:00
2092	11	SÃO JOSÉ DO JACURI	2010-03-11 00:00:00
2093	11	SÃO JOSÉ DO MANTIMENTO	2010-03-11 00:00:00
2094	11	SÃO LOURENÇO	2010-03-11 00:00:00
2095	11	SÃO MIGUEL DO ANTA	2010-03-11 00:00:00
2096	11	SÃO PEDRO DA UNIÃO	2010-03-11 00:00:00
2097	11	SÃO PEDRO DO SUAÇUI	2010-03-11 00:00:00
2098	11	SÃO PEDRO DOS FERROS	2010-03-11 00:00:00
2099	11	SÃO ROMÃO	2010-03-11 00:00:00
2100	11	SÃO ROQUE DE MINAS	2010-03-11 00:00:00
2101	11	SÃO SEBASTIÃO DA BELA VISTA	2010-03-11 00:00:00
2102	11	SÃO SEBASTIÃO DA VARGEM ALEGRE	2010-03-11 00:00:00
2103	11	SÃO SEBASTIÃO DO ANTA	2010-03-11 00:00:00
2104	11	SÃO SEBASTIÃO DO MARANHÃO	2010-03-11 00:00:00
2105	11	SÃO SEBASTIÃO DO OESTE	2010-03-11 00:00:00
2106	11	SÃO SEBASTIÃO DO PARAÍSO	2010-03-11 00:00:00
2107	11	SÃO SEBASTIÃO DO RIO PRETO	2010-03-11 00:00:00
2108	11	SÃO SEBASTIÃO DO RIO VERDE	2010-03-11 00:00:00
2109	11	SÃO TIAGO	2010-03-11 00:00:00
2110	11	SÃO TOMÁS DE AQUINO	2010-03-11 00:00:00
2111	11	SÃO TOMÉ DAS LETRAS	2010-03-11 00:00:00
2112	11	SÃO VICENTE DE MINAS	2010-03-11 00:00:00
2113	11	SAPUCAÍ-MIRIM	2010-03-11 00:00:00
2114	11	SARDOA	2010-03-11 00:00:00
2115	11	SARZEDO	2010-03-11 00:00:00
2116	11	SEM PEIXE	2010-03-11 00:00:00
2117	11	SENADOR AMARAL	2010-03-11 00:00:00
2118	11	SENADOR CORTES	2010-03-11 00:00:00
2119	11	SENADOR FIRMINO	2010-03-11 00:00:00
2120	11	SENADOR JOSÉ BENTO	2010-03-11 00:00:00
2121	11	SENADOR MODESTINO GONÇALVES	2010-03-11 00:00:00
2122	11	SENHORA DE OLIVEIRA	2010-03-11 00:00:00
2123	11	SENHORA DO PORTO	2010-03-11 00:00:00
2124	11	SENHORA DOS REMÉDIOS	2010-03-11 00:00:00
2125	11	SERICITA	2010-03-11 00:00:00
2126	11	SERITINGA	2010-03-11 00:00:00
2127	11	SERRA AZUL DE MINAS	2010-03-11 00:00:00
2128	11	SERRA DA SAUDADE	2010-03-11 00:00:00
2129	11	SERRA DO SALITRE	2010-03-11 00:00:00
2130	11	SERRA DOS AIMORÉS	2010-03-11 00:00:00
2131	11	SERRÂNIA	2010-03-11 00:00:00
2132	11	SERRANÓPOLIS DE MINAS	2010-03-11 00:00:00
2133	11	SERRANOS	2010-03-11 00:00:00
2134	11	SERRO	2010-03-11 00:00:00
2135	11	SETE LAGOAS	2010-03-11 00:00:00
2136	11	SETUBINHA	2010-03-11 00:00:00
2137	11	SILVEIRÂNIA	2010-03-11 00:00:00
2138	11	SILVIANÓPOLIS	2010-03-11 00:00:00
2139	11	SIMÃO PEREIRA	2010-03-11 00:00:00
2140	11	SIMONÉSIA	2010-03-11 00:00:00
2141	11	SOBRÁLIA	2010-03-11 00:00:00
2142	11	SOLEDADE DE MINAS	2010-03-11 00:00:00
2143	11	TABULEIRO	2010-03-11 00:00:00
2144	11	TAIOBEIRAS	2010-03-11 00:00:00
2145	11	TAPARUBA	2010-03-11 00:00:00
2146	11	TAPIRA	2010-03-11 00:00:00
2147	11	TAPIRAÍ	2010-03-11 00:00:00
2148	11	TAQUARAÇU DE MINAS	2010-03-11 00:00:00
2149	11	TARUMIRIM	2010-03-11 00:00:00
2150	11	TEIXEIRAS	2010-03-11 00:00:00
2151	11	TEÓFILO OTONI	2010-03-11 00:00:00
2152	11	TIMÓTEO	2010-03-11 00:00:00
2153	11	TIRADENTES	2010-03-11 00:00:00
2154	11	TIROS	2010-03-11 00:00:00
2155	11	TOCANTINS	2010-03-11 00:00:00
2156	11	TOCOS DO MOJI	2010-03-11 00:00:00
2157	11	TOLEDO	2010-03-11 00:00:00
2158	11	TOMBOS	2010-03-11 00:00:00
2159	11	TRÊS CORAÇÕES	2010-03-11 00:00:00
2160	11	TRÊS MARIAS	2010-03-11 00:00:00
2161	11	TRÊS PONTAS	2010-03-11 00:00:00
2162	11	TUMIRITINGA	2010-03-11 00:00:00
2163	11	TUPACIGUARA	2010-03-11 00:00:00
2164	11	TURMALINA	2010-03-11 00:00:00
2165	11	TURVOLÂNDIA	2010-03-11 00:00:00
2166	11	UBÁ	2010-03-11 00:00:00
2167	11	UBAÍ	2010-03-11 00:00:00
2168	11	UBAPORANGA	2010-03-11 00:00:00
2169	11	UBERABA	2010-03-11 00:00:00
2170	11	UBERLÂNDIA	2010-03-11 00:00:00
2171	11	UMBURATIBA	2010-03-11 00:00:00
2172	11	UNAÍ	2010-03-11 00:00:00
2173	11	UNIÃO DE MINAS	2010-03-11 00:00:00
2174	11	URUANA DE MINAS	2010-03-11 00:00:00
2175	11	URUCÂNIA	2010-03-11 00:00:00
2176	11	URUCUIA	2010-03-11 00:00:00
2177	11	VARGEM ALEGRE	2010-03-11 00:00:00
2178	11	VARGEM BONITA	2010-03-11 00:00:00
2179	11	VARGEM GRANDE DO RIO PARDO	2010-03-11 00:00:00
2180	11	VARGINHA	2010-03-11 00:00:00
2181	11	VARJÃO DE MINAS	2010-03-11 00:00:00
2182	11	VÁRZEA DA PALMA	2010-03-11 00:00:00
2183	11	VARZELÂNDIA	2010-03-11 00:00:00
2184	11	VAZANTE	2010-03-11 00:00:00
2185	11	VERDELÂNDIA	2010-03-11 00:00:00
2186	11	VEREDINHA	2010-03-11 00:00:00
2187	11	VERÍSSIMO	2010-03-11 00:00:00
2188	11	VERMELHO NOVO	2010-03-11 00:00:00
2189	11	VESPASIANO	2010-03-11 00:00:00
2190	11	VIÇOSA	2010-03-11 00:00:00
2191	11	VIEIRAS	2010-03-11 00:00:00
2192	11	VIRGEM DA LAPA	2010-03-11 00:00:00
2193	11	VIRGÍNIA	2010-03-11 00:00:00
2194	11	VIRGINÓPOLIS	2010-03-11 00:00:00
2195	11	VIRGOLÂNDIA	2010-03-11 00:00:00
2196	11	VISCONDE DO RIO BRANCO	2010-03-11 00:00:00
2197	11	VOLTA GRANDE	2010-03-11 00:00:00
2198	11	WENCESLAU BRAZ	2010-03-11 00:00:00
2199	12	ÁGUA CLARA	2010-03-11 00:00:00
2200	12	ALCINÓPOLIS	2010-03-11 00:00:00
2201	12	AMAMBAÍ	2010-03-11 00:00:00
2202	12	ANASTÁCIO	2010-03-11 00:00:00
2203	12	ANAURILÂNDIA	2010-03-11 00:00:00
2204	12	ANGÉLICA	2010-03-11 00:00:00
2205	12	ANTÔNIO JOÃO	2010-03-11 00:00:00
2206	12	APARECIDA DO TABOADO	2010-03-11 00:00:00
2207	12	AQUIDAUANA	2010-03-11 00:00:00
2208	12	ARAL MOREIRA	2010-03-11 00:00:00
2209	12	BANDEIRANTES	2010-03-11 00:00:00
2210	12	BATAGUASSU	2010-03-11 00:00:00
2211	12	BATAYPORÃ	2010-03-11 00:00:00
2212	12	BELA VISTA	2010-03-11 00:00:00
2213	12	BODOQUENA	2010-03-11 00:00:00
2214	12	BONITO	2010-03-11 00:00:00
2215	12	BRASILÂNDIA	2010-03-11 00:00:00
2216	12	CAARAPÓ	2010-03-11 00:00:00
2217	12	CAMAPUÃ	2010-03-11 00:00:00
2218	12	CAMPO GRANDE	2010-03-11 00:00:00
2219	12	CARACOL	2010-03-11 00:00:00
2220	12	CASSILÂNDIA	2010-03-11 00:00:00
2221	12	CHAPADÃO DO SUL	2010-03-11 00:00:00
2222	12	CORGUINHO	2010-03-11 00:00:00
2223	12	CORONEL SAPUCAIA	2010-03-11 00:00:00
2224	12	CORUMBÁ	2010-03-11 00:00:00
2225	12	COSTA RICA	2010-03-11 00:00:00
2226	12	COXIM	2010-03-11 00:00:00
2227	12	DEADÁPOLIS	2010-03-11 00:00:00
2228	12	DOIS IRMÃOS DO BURITI	2010-03-11 00:00:00
2229	12	DOURADINA	2010-03-11 00:00:00
2230	12	DOURADOS	2010-03-11 00:00:00
2231	12	ELDORADO	2010-03-11 00:00:00
2232	12	FÁTIMA DO SUL	2010-03-11 00:00:00
2233	12	FIGUEIRÃO	2010-03-11 00:00:00
2234	12	GLÓRIA DE DOURADOS	2010-03-11 00:00:00
2235	12	GUIA LOPES DA LAGUNA	2010-03-11 00:00:00
2236	12	IGUATEMI	2010-03-11 00:00:00
2237	12	INOCÊNCIA	2010-03-11 00:00:00
2238	12	ITAPORÃ	2010-03-11 00:00:00
2239	12	ITAQUIRAÍ	2010-03-11 00:00:00
2240	12	IVINHEMA	2010-03-11 00:00:00
2241	12	JAPORÃ	2010-03-11 00:00:00
2242	12	JARAGUARI	2010-03-11 00:00:00
2243	12	JARDIM	2010-03-11 00:00:00
2244	12	JATEÍ	2010-03-11 00:00:00
2245	12	JUTI	2010-03-11 00:00:00
2246	12	LADÁRIO	2010-03-11 00:00:00
2247	12	LAGUNA CARAPÃ	2010-03-11 00:00:00
2248	12	MARACAJU	2010-03-11 00:00:00
2249	12	MIRANDA	2010-03-11 00:00:00
2250	12	MUNDO NOVO	2010-03-11 00:00:00
2251	12	NAVIRAÍ	2010-03-11 00:00:00
2252	12	NIOAQUE	2010-03-11 00:00:00
2253	12	NOVA ALVORADA DO SUL	2010-03-11 00:00:00
2254	12	NOVA ANDRADINA	2010-03-11 00:00:00
2255	12	NOVO HORIZONTE DO SUL	2010-03-11 00:00:00
2256	12	PARANAÍBA	2010-03-11 00:00:00
2257	12	PARANHOS	2010-03-11 00:00:00
2258	12	PEDRO GOMES	2010-03-11 00:00:00
2259	12	PONTA PORÃ	2010-03-11 00:00:00
2260	12	PORTO MURTINHO	2010-03-11 00:00:00
2261	12	RIBAS DO RIO PARDO	2010-03-11 00:00:00
2262	12	RIO BRILHANTE	2010-03-11 00:00:00
2263	12	RIO NEGRO	2010-03-11 00:00:00
2264	12	RIO VERDE DE MATO GROSSO	2010-03-11 00:00:00
2265	12	ROCHEDO	2010-03-11 00:00:00
2266	12	SANTA RITA DO PARDO	2010-03-11 00:00:00
2267	12	SÃO GABRIEL DO OESTE	2010-03-11 00:00:00
2268	12	SELVÍRIA	2010-03-11 00:00:00
2269	12	SETE QUEDAS	2010-03-11 00:00:00
2270	12	SIDROLÂNDIA	2010-03-11 00:00:00
2271	12	SONORA	2010-03-11 00:00:00
2272	12	TACURU	2010-03-11 00:00:00
2273	12	TAQUARUSSU	2010-03-11 00:00:00
2274	12	TERENOS	2010-03-11 00:00:00
2275	12	TRÊS LAGOAS	2010-03-11 00:00:00
2276	12	VICENTINA	2010-03-11 00:00:00
2277	13	ACORIZAL	2010-03-11 00:00:00
2278	13	ÁGUA BOA	2010-03-11 00:00:00
2279	13	ALTA FLORESTA	2010-03-11 00:00:00
2280	13	ALTO ARAGUAIA	2010-03-11 00:00:00
2281	13	ALTO BOA VISTA	2010-03-11 00:00:00
2282	13	ALTO GARÇAS	2010-03-11 00:00:00
2283	13	ALTO PARAGUAI	2010-03-11 00:00:00
2284	13	ALTO TAQUARI	2010-03-11 00:00:00
2285	13	APIACÁS	2010-03-11 00:00:00
2286	13	ARAGUAIANA	2010-03-11 00:00:00
2287	13	ARAGUAINHA	2010-03-11 00:00:00
2288	13	ARAPUTANGA	2010-03-11 00:00:00
2289	13	ARENÁPOLIS	2010-03-11 00:00:00
2290	13	ARIPUANÃ	2010-03-11 00:00:00
2291	13	BARÃO DE MELGAÇO	2010-03-11 00:00:00
2292	13	BARRA DO BUGRES	2010-03-11 00:00:00
2293	13	BARRA DO GARÇAS	2010-03-11 00:00:00
2294	13	BOM JESUS DO ARAGUAIA	2010-03-11 00:00:00
2295	13	BRASNORTE	2010-03-11 00:00:00
2296	13	CÁCERES	2010-03-11 00:00:00
2297	13	CAMPINÁPOLIS	2010-03-11 00:00:00
2298	13	CAMPO NOVO DO PARECIS	2010-03-11 00:00:00
2299	13	CAMPO VERDE	2010-03-11 00:00:00
2300	13	CAMPOS DE JÚLIO	2010-03-11 00:00:00
2301	13	CANABRAVA DO NORTE	2010-03-11 00:00:00
2302	13	CANARANA	2010-03-11 00:00:00
2303	13	CARLINDA	2010-03-11 00:00:00
2304	13	CASTANHEIRA	2010-03-11 00:00:00
2305	13	CHAPADA DOS GUIMARÃES	2010-03-11 00:00:00
2306	13	CLÁUDIA	2010-03-11 00:00:00
2307	13	COCALINHO	2010-03-11 00:00:00
2308	13	COLIDER	2010-03-11 00:00:00
2309	13	COLNIZA	2010-03-11 00:00:00
2310	13	COMODORO	2010-03-11 00:00:00
2311	13	CONFRESA	2010-03-11 00:00:00
2312	13	CONQUISTA D´OESTE	2010-03-11 00:00:00
2313	13	COTRIGUAÇU	2010-03-11 00:00:00
2314	13	CUIABÁ	2010-03-11 00:00:00
2315	13	CURVELÂNDIA	2010-03-11 00:00:00
2316	13	DENISE	2010-03-11 00:00:00
2317	13	DIAMANTINO	2010-03-11 00:00:00
2318	13	DOM AQUINO	2010-03-11 00:00:00
2319	13	FELIZ NATAL	2010-03-11 00:00:00
2320	13	FIGUEIRÓPOLIS D OESTE	2010-03-11 00:00:00
2321	13	GAÚCHA DO NORTE	2010-03-11 00:00:00
2322	13	GENERAL CARNEIRO	2010-03-11 00:00:00
2323	13	GLÓRIA D OESTE	2010-03-11 00:00:00
2324	13	GUARANTÃ DO NORTE	2010-03-11 00:00:00
2325	13	GUIRATINGA	2010-03-11 00:00:00
2326	13	INDIAVAÍ	2010-03-11 00:00:00
2327	13	IPIRANGA DO NORTE	2010-03-11 00:00:00
2328	13	ITANHANGÁ	2010-03-11 00:00:00
2329	13	ITAUBA	2010-03-11 00:00:00
2330	13	ITIQUIRA	2010-03-11 00:00:00
2331	13	JACIARA	2010-03-11 00:00:00
2332	13	JANGADA	2010-03-11 00:00:00
2333	13	JAURU	2010-03-11 00:00:00
2334	13	JUARA	2010-03-11 00:00:00
2335	13	JUÍNA	2010-03-11 00:00:00
2336	13	JURUENA	2010-03-11 00:00:00
2337	13	JUSCIMEIRA	2010-03-11 00:00:00
2338	13	LAMBARI D OESTE	2010-03-11 00:00:00
2339	13	LUCAS DO RIO VERDE	2010-03-11 00:00:00
2340	13	LUCIARA	2010-03-11 00:00:00
2341	13	MARCELÂNDIA	2010-03-11 00:00:00
2342	13	MATUPÁ	2010-03-11 00:00:00
2343	13	MIRASSOL D OESTE	2010-03-11 00:00:00
2344	13	NOBRES	2010-03-11 00:00:00
2345	13	NORTELÂNDIA	2010-03-11 00:00:00
2346	13	NOSSA SENHORA DO LIVRAMENTO	2010-03-11 00:00:00
2347	13	NOVA BANDEIRANTES	2010-03-11 00:00:00
2348	13	NOVA BRASILÂNDIA	2010-03-11 00:00:00
2349	13	NOVA CANAÃ DO NORTE	2010-03-11 00:00:00
2350	13	NOVA GUARITA	2010-03-11 00:00:00
2351	13	NOVA LACERDA	2010-03-11 00:00:00
2352	13	NOVA MARILÂNDIA	2010-03-11 00:00:00
2353	13	NOVA MARINGÁ	2010-03-11 00:00:00
2354	13	NOVA MONTE VERDE	2010-03-11 00:00:00
2355	13	NOVA MUTUM	2010-03-11 00:00:00
2356	13	NOVA NAZARÉ	2010-03-11 00:00:00
2357	13	NOVA OLÍMPIA	2010-03-11 00:00:00
2358	13	NOVA SANTA HELENA	2010-03-11 00:00:00
2359	13	NOVA UBIRATÃ	2010-03-11 00:00:00
2360	13	NOVA XAVANTINA	2010-03-11 00:00:00
2361	13	NOVO HORIZONTE DO NORTE	2010-03-11 00:00:00
2362	13	NOVO MUNDO	2010-03-11 00:00:00
2363	13	NOVO SANTO ANTÔNIO	2010-03-11 00:00:00
2364	13	NOVO SÃO JOAQUIM	2010-03-11 00:00:00
2365	13	PARANAÍTA	2010-03-11 00:00:00
2366	13	PARANATINGA	2010-03-11 00:00:00
2367	13	PEDRA PRETA	2010-03-11 00:00:00
2368	13	PEIXOTO DE AZEVEDO	2010-03-11 00:00:00
2369	13	PLANALTO DA SERRA	2010-03-11 00:00:00
2370	13	POCONÉ	2010-03-11 00:00:00
2371	13	PONTAL DO ARAGUAIA	2010-03-11 00:00:00
2372	13	PONTE BRANCA	2010-03-11 00:00:00
2373	13	PONTES E LACERDA	2010-03-11 00:00:00
2374	13	PORTO ALEGRE DO NORTE	2010-03-11 00:00:00
2375	13	PORTO DOS GAÚCHOS	2010-03-11 00:00:00
2376	13	PORTO ESPERIDIÃO	2010-03-11 00:00:00
2377	13	PORTO ESTRELA	2010-03-11 00:00:00
2378	13	POXOREO	2010-03-11 00:00:00
2379	13	PRIMAVERA DO LESTE	2010-03-11 00:00:00
2380	13	QUERÊNCIA	2010-03-11 00:00:00
2381	13	RESERVA DO CABAÇAL	2010-03-11 00:00:00
2382	13	RIBEIRÃO CASCALHEIRA	2010-03-11 00:00:00
2383	13	RIBEIRÃOZINHO	2010-03-11 00:00:00
2384	13	RIO BRANCO	2010-03-11 00:00:00
2385	13	RONDOLÂNDIA	2010-03-11 00:00:00
2386	13	RONDONÓPOLIS	2010-03-11 00:00:00
2387	13	ROSÁRIO DO OESTE	2010-03-11 00:00:00
2388	13	SALTO DO CÉU	2010-03-11 00:00:00
2389	13	SANTA  RITA DO TRIVELATO	2010-03-11 00:00:00
2390	13	SANTA CARMEM	2010-03-11 00:00:00
2391	13	SANTA CRUZ DO XINGU	2010-03-11 00:00:00
2392	13	SANTA TEREZINHA	2010-03-11 00:00:00
2393	13	SANTO AFONSO	2010-03-11 00:00:00
2394	13	SANTO ANTONIO DO LESTE	2010-03-11 00:00:00
2395	13	SANTO ANTÔNIO DO LEVERGER	2010-03-11 00:00:00
2396	13	SÃO FÉLIX DO ARAGUAIA	2010-03-11 00:00:00
2397	13	SÃO JOSÉ DO POVO	2010-03-11 00:00:00
2398	13	SÃO JOSÉ DO RIO CLARO	2010-03-11 00:00:00
2399	13	SÃO JOSÉ DO XINGU	2010-03-11 00:00:00
2400	13	SÃO JOSÉ DOS QUATRO MARCOS	2010-03-11 00:00:00
2401	13	SÃO PEDRO DA CIPA	2010-03-11 00:00:00
2402	13	SAPEZAL	2010-03-11 00:00:00
2403	13	SERRA NOVA DOURADA	2010-03-11 00:00:00
2404	13	SINOP	2010-03-11 00:00:00
2405	13	SORRISO	2010-03-11 00:00:00
2406	13	TABAPORÃ	2010-03-11 00:00:00
2407	13	TANGARÁ DA SERRA	2010-03-11 00:00:00
2408	13	TAPURAH	2010-03-11 00:00:00
2409	13	TERRA NOVA DO NORTE	2010-03-11 00:00:00
2410	13	TESOURO	2010-03-11 00:00:00
2411	13	TORIXORÉU	2010-03-11 00:00:00
2412	13	UNIÃO DO SUL	2010-03-11 00:00:00
2413	13	VALE DE SÃO DOMINGOS	2010-03-11 00:00:00
2414	13	VÁRZEA GRANDE	2010-03-11 00:00:00
2415	13	VERA	2010-03-11 00:00:00
2416	13	VILA BELA DA SANTÍSSIMA TRINDADE	2010-03-11 00:00:00
2417	13	VILA RICA	2010-03-11 00:00:00
2419	14	ABEL FIGUEIREDO	2010-03-11 00:00:00
2420	14	ACARA	2010-03-11 00:00:00
2421	14	AFUA	2010-03-11 00:00:00
2422	14	ÁGUA AZUL DO NORTE	2010-03-11 00:00:00
2423	14	ALENQUER	2010-03-11 00:00:00
2424	14	ALMEIRIM	2010-03-11 00:00:00
2425	14	ALTAMIRA	2010-03-11 00:00:00
2426	14	ANAJÁS	2010-03-11 00:00:00
2427	14	ANANINDEUA	2010-03-11 00:00:00
2428	14	ANAPÚ	2010-03-11 00:00:00
2429	14	AUGUSTO CORREA	2010-03-11 00:00:00
2430	14	AURORA DO PARÁ	2010-03-11 00:00:00
2431	14	AVEIRO	2010-03-11 00:00:00
2432	14	BAGRE	2010-03-11 00:00:00
2433	14	BAIÃO	2010-03-11 00:00:00
2434	14	BANNACH	2010-03-11 00:00:00
2435	14	BARCARENA	2010-03-11 00:00:00
2436	14	BELÉM	2010-03-11 00:00:00
2437	14	BELTERRA	2010-03-11 00:00:00
2438	14	BENEVIDES	2010-03-11 00:00:00
2439	14	BOM JESUS DO TOCANTINS	2010-03-11 00:00:00
2440	14	BONITO	2010-03-11 00:00:00
2441	14	BRAGANÇA	2010-03-11 00:00:00
2442	14	BRASIL NOVO	2010-03-11 00:00:00
2443	14	BREJO GRANDE DO ARAGUAIA	2010-03-11 00:00:00
2444	14	BREU BRANCO	2010-03-11 00:00:00
2445	14	BREVES	2010-03-11 00:00:00
2446	14	BUJARU	2010-03-11 00:00:00
2447	14	CACHOEIRA DO ARARI	2010-03-11 00:00:00
2448	14	CACHOEIRA DO PIRIÁ	2010-03-11 00:00:00
2449	14	CAMETÁ	2010-03-11 00:00:00
2450	14	CANAÃ DOS CARAJÁS	2010-03-11 00:00:00
2451	14	CAPANEMA	2010-03-11 00:00:00
2452	14	CAPITÃO POÇO	2010-03-11 00:00:00
2453	14	CASTANHAL	2010-03-11 00:00:00
2454	14	CHAVES	2010-03-11 00:00:00
2455	14	COLARES	2010-03-11 00:00:00
2456	14	CONCEIÇÃO DO ARAGUAIA	2010-03-11 00:00:00
2457	14	CONCÓRDIA DO PARÁ	2010-03-11 00:00:00
2458	14	CUMARU DO NORTE	2010-03-11 00:00:00
2459	14	CURIONÓPOLIS	2010-03-11 00:00:00
2460	14	CURRALINHO	2010-03-11 00:00:00
2461	14	CURUÁ	2010-03-11 00:00:00
2462	14	CURUÇA	2010-03-11 00:00:00
2463	14	DOM ELISEU	2010-03-11 00:00:00
2464	14	ELDORADO DOS CARAJÁS	2010-03-11 00:00:00
2465	14	FARO	2010-03-11 00:00:00
2466	14	FLORESTA DO ARAGUAIA	2010-03-11 00:00:00
2467	14	GARRAFÃO DO NORTE	2010-03-11 00:00:00
2468	14	GOIANÉSIA DO PARÁ	2010-03-11 00:00:00
2469	14	GURUPA	2010-03-11 00:00:00
2470	14	IGARAPÉ-AÇU	2010-03-11 00:00:00
2471	14	IGARAPÉ-MIRI	2010-03-11 00:00:00
2472	14	INHANGAPI	2010-03-11 00:00:00
2473	14	IPIXUNA DO PARÁ	2010-03-11 00:00:00
2474	14	IRITUIA	2010-03-11 00:00:00
2475	14	ITAITUBA	2010-03-11 00:00:00
2476	14	ITUPIRANGA	2010-03-11 00:00:00
2477	14	JACAREACANGA	2010-03-11 00:00:00
2478	14	JACUNDÁ	2010-03-11 00:00:00
2479	14	JURUTI	2010-03-11 00:00:00
2480	14	LIMOEIRO DO AJURU	2010-03-11 00:00:00
2481	14	MÃE DO RIO	2010-03-11 00:00:00
2482	14	MAGALHÃES BARATA	2010-03-11 00:00:00
2483	14	MARABÁ	2010-03-11 00:00:00
2484	14	MARACANÃ	2010-03-11 00:00:00
2485	14	MARAPANIM	2010-03-11 00:00:00
2486	14	MARITUBA	2010-03-11 00:00:00
2487	14	MEDICILÂNDIA	2010-03-11 00:00:00
2488	14	MELGAÇO	2010-03-11 00:00:00
2489	14	MOCAJUBA	2010-03-11 00:00:00
2490	14	MOJU	2010-03-11 00:00:00
2491	14	MONTE ALEGRE	2010-03-11 00:00:00
2492	14	MUANA	2010-03-11 00:00:00
2493	14	NOVA ESPERANÇA DO PIRIÁ	2010-03-11 00:00:00
2494	14	NOVA IPIXUNA	2010-03-11 00:00:00
2495	14	NOVA TIMBOTEUA	2010-03-11 00:00:00
2496	14	NOVO PROGRESSO	2010-03-11 00:00:00
2497	14	NOVO REPARTIMENTO	2010-03-11 00:00:00
2498	14	ÓBIDOS	2010-03-11 00:00:00
2499	14	OEIRAS DO PARÁ	2010-03-11 00:00:00
2500	14	ORIXIMINA	2010-03-11 00:00:00
2501	14	OUREM	2010-03-11 00:00:00
2502	14	OURILÂNDIA DO NORTE	2010-03-11 00:00:00
2503	14	PACAJÁ	2010-03-11 00:00:00
2504	14	PALESTINA DO PARÁ	2010-03-11 00:00:00
2505	14	PARAGOMINAS	2010-03-11 00:00:00
2506	14	PARAUAPEBAS	2010-03-11 00:00:00
2507	14	PAU D ARCO	2010-03-11 00:00:00
2508	14	PEIXE-BOI	2010-03-11 00:00:00
2509	14	PIÇARRA	2010-03-11 00:00:00
2510	14	PLACAS	2010-03-11 00:00:00
2511	14	PONTA DE PEDRAS	2010-03-11 00:00:00
2512	14	PORTEL	2010-03-11 00:00:00
2513	14	PORTO DE MOZ	2010-03-11 00:00:00
2514	14	PRAINHA	2010-03-11 00:00:00
2515	14	PRIMAVERA	2010-03-11 00:00:00
2516	14	QUATIPURÚ	2010-03-11 00:00:00
2517	14	REDENÇÃO	2010-03-11 00:00:00
2518	14	RIO MARIA	2010-03-11 00:00:00
2519	14	RONDON DO PARÁ	2010-03-11 00:00:00
2520	14	RURÓPOLIS	2010-03-11 00:00:00
2521	14	SALINÓPLIS	2010-03-11 00:00:00
2522	14	SALVATERRA	2010-03-11 00:00:00
2523	14	SANTA BÁRBARA DO PARÁ	2010-03-11 00:00:00
2524	14	SANTA CRUZ DO ARARI	2010-03-11 00:00:00
2525	14	SANTA ISABEL DO PARÁ	2010-03-11 00:00:00
2526	14	SANTA LUZIA DO PARÁ	2010-03-11 00:00:00
2527	14	SANTA MARIA DAS BARREIRAS	2010-03-11 00:00:00
2528	14	SANTA MARIA DO PARÁ	2010-03-11 00:00:00
2529	14	SANTANA DO ARAGUAIA	2010-03-11 00:00:00
2530	14	SANTARÉM	2010-03-11 00:00:00
2531	14	SANTARÉM NOVO	2010-03-11 00:00:00
2532	14	SANTO ANTÔNIO DO TAUÁ	2010-03-11 00:00:00
2533	14	SÃO CAETANO DE ODIVELAS	2010-03-11 00:00:00
2534	14	SÃO DOMINGOS DO ARAGUAIA	2010-03-11 00:00:00
2535	14	SÃO DOMINGOS DO CAPIM	2010-03-11 00:00:00
2536	14	SÃO FÉLIX DO XINGU	2010-03-11 00:00:00
2537	14	SÃO FRANCISCO DO PARÁ	2010-03-11 00:00:00
2538	14	SÃO GERALDO DO ARAGUAIA	2010-03-11 00:00:00
2539	14	SÃO JOÃO DA PONTA	2010-03-11 00:00:00
2540	14	SÃO JOÃO DE PIRABAS	2010-03-11 00:00:00
2541	14	SÃO JOÃO DO ARAGUAIA	2010-03-11 00:00:00
2542	14	SÃO MIGUEL DO GUAMA	2010-03-11 00:00:00
2543	14	SÃO SEBASTIÃO DA BOA VISTA	2010-03-11 00:00:00
2544	14	SAPUCAIA	2010-03-11 00:00:00
2545	14	SENADOR JOSÉ PORFÍRIO	2010-03-11 00:00:00
2546	14	SOURE	2010-03-11 00:00:00
2547	14	TAILÂNDIA	2010-03-11 00:00:00
2548	14	TERRA ALTA	2010-03-11 00:00:00
2549	14	TERRA SANTA	2010-03-11 00:00:00
2550	14	TOME-AÇU	2010-03-11 00:00:00
2551	14	TRACUATEUA	2010-03-11 00:00:00
2552	14	TRAIRÃO	2010-03-11 00:00:00
2553	14	TUCUMÃ	2010-03-11 00:00:00
2554	14	TUCURUÍ	2010-03-11 00:00:00
2555	14	ULIANÓPOLIS	2010-03-11 00:00:00
2556	14	URUARA	2010-03-11 00:00:00
2557	14	VIGIA	2010-03-11 00:00:00
2558	14	VISEU	2010-03-11 00:00:00
2559	14	VITÓRIA DO XINGU	2010-03-11 00:00:00
2560	14	XINGUARA	2010-03-11 00:00:00
2561	15	ÁGUA BRANCA	2010-03-11 00:00:00
2562	15	AGUIAR	2010-03-11 00:00:00
2563	15	ALAGOA GRANDE	2010-03-11 00:00:00
2564	15	ALAGOA NOVA	2010-03-11 00:00:00
2565	15	ALAGOINHA	2010-03-11 00:00:00
2566	15	ALCANTIL	2010-03-11 00:00:00
2567	15	ALGODÃO DE JANDAÍRA	2010-03-11 00:00:00
2568	15	ALHANDRA	2010-03-11 00:00:00
2569	15	AMPARO	2010-03-11 00:00:00
2570	15	APARECIDA	2010-03-11 00:00:00
2571	15	ARAÇAGI	2010-03-11 00:00:00
2572	15	ARARA	2010-03-11 00:00:00
2573	15	ARARUNA	2010-03-11 00:00:00
2574	15	AREIA	2010-03-11 00:00:00
2575	15	AREIA DE BARAÚNAS	2010-03-11 00:00:00
2576	15	AREIAL	2010-03-11 00:00:00
2577	15	AROEIRAS	2010-03-11 00:00:00
2578	15	ASSUNÇÃO	2010-03-11 00:00:00
2579	15	BAÍA DA TRAIÇÃO	2010-03-11 00:00:00
2580	15	BANANEIRAS	2010-03-11 00:00:00
2581	15	BARAÚNA	2010-03-11 00:00:00
2582	15	BARRA DE SANTA ROSA	2010-03-11 00:00:00
2583	15	BARRA DE SANTANA	2010-03-11 00:00:00
2584	15	BARRA DE SÃO MIGUEL	2010-03-11 00:00:00
2585	15	BAYEUX	2010-03-11 00:00:00
2586	15	BELÉM	2010-03-11 00:00:00
2587	15	BELÉM DO BREJO DA CRUZ	2010-03-11 00:00:00
2588	15	BERNARDINO BATISTA	2010-03-11 00:00:00
2589	15	BOA VENTURA	2010-03-11 00:00:00
2590	15	BOA VISTA	2010-03-11 00:00:00
2591	15	BOM JESUS	2010-03-11 00:00:00
2592	15	BOM SUCESSO	2010-03-11 00:00:00
2593	15	BONITO DE SANTA FÉ	2010-03-11 00:00:00
2594	15	BOQUEIRÃO	2010-03-11 00:00:00
2595	15	BORBOREMA	2010-03-11 00:00:00
2596	15	BREJO DO CRUZ	2010-03-11 00:00:00
2597	15	BREJO DOS SANTOS	2010-03-11 00:00:00
2598	15	CAAPORÃ	2010-03-11 00:00:00
2599	15	CABACEIRAS	2010-03-11 00:00:00
2600	15	CABEDELO	2010-03-11 00:00:00
2601	15	CACHOEIRA DOS ÍNDIOS	2010-03-11 00:00:00
2602	15	CACIMBA DE AREIA	2010-03-11 00:00:00
2603	15	CACIMBA DE DENTRO	2010-03-11 00:00:00
2604	15	CACIMBAS	2010-03-11 00:00:00
2605	15	CAIÇARA	2010-03-11 00:00:00
2606	15	CAJAZEIRAS	2010-03-11 00:00:00
2607	15	CAJAZEIRINHAS	2010-03-11 00:00:00
2608	15	CALDAS BRANDÃO	2010-03-11 00:00:00
2609	15	CAMALAÚ	2010-03-11 00:00:00
2610	15	CAMPINA GRANDE	2010-03-11 00:00:00
2611	15	CAMPO DE SANTANA	2010-03-11 00:00:00
2612	15	CAPIM	2010-03-11 00:00:00
2613	15	CARAÚBAS	2010-03-11 00:00:00
2614	15	CARRAPATEIRA	2010-03-11 00:00:00
2615	15	CASSERENGUE	2010-03-11 00:00:00
2616	15	CATINGUEIRA	2010-03-11 00:00:00
2617	15	CATOLÉ DO ROCHA	2010-03-11 00:00:00
2618	15	CATURITÉ	2010-03-11 00:00:00
2619	15	CONCEIÇÃO	2010-03-11 00:00:00
2620	15	CONDADO	2010-03-11 00:00:00
2621	15	CONDE	2010-03-11 00:00:00
2622	15	CONGO	2010-03-11 00:00:00
2623	15	COREMAS	2010-03-11 00:00:00
2624	15	COXIXOLA	2010-03-11 00:00:00
2625	15	CRUZ DO ESPÍRITO SANTO	2010-03-11 00:00:00
2626	15	CUBATI	2010-03-11 00:00:00
2627	15	CUITÉ	2010-03-11 00:00:00
2628	15	CUITÉ DE MAMANGUAPE	2010-03-11 00:00:00
2629	15	CUITEGI	2010-03-11 00:00:00
2630	15	CURRAL DE CIMA	2010-03-11 00:00:00
2631	15	CURRAL VELHO	2010-03-11 00:00:00
2632	15	DAMIÃO	2010-03-11 00:00:00
2633	15	DESTERRO	2010-03-11 00:00:00
2634	15	DIAMANTE	2010-03-11 00:00:00
2635	15	DONA INÊS	2010-03-11 00:00:00
2636	15	DUAS ESTRADAS	2010-03-11 00:00:00
2637	15	EMAS	2010-03-11 00:00:00
2638	15	ESPERANÇA	2010-03-11 00:00:00
2639	15	FAGUNDES	2010-03-11 00:00:00
2640	15	FREI MARTINHO	2010-03-11 00:00:00
2641	15	GADO BRAVO	2010-03-11 00:00:00
2642	15	GUARABIRA	2010-03-11 00:00:00
2643	15	GURINHÉM	2010-03-11 00:00:00
2644	15	GURJÃO	2010-03-11 00:00:00
2645	15	IBIARA	2010-03-11 00:00:00
2646	15	IGARACY	2010-03-11 00:00:00
2647	15	IMACULADA	2010-03-11 00:00:00
2648	15	INGÁ	2010-03-11 00:00:00
2649	15	ITABAIANA	2010-03-11 00:00:00
2650	15	ITAPORANGA	2010-03-11 00:00:00
2651	15	ITAPOROROCA	2010-03-11 00:00:00
2652	15	ITATUBA	2010-03-11 00:00:00
2653	15	JACARAÚ	2010-03-11 00:00:00
2654	15	JERICÓ	2010-03-11 00:00:00
2655	15	JOÃO PESSOA	2010-03-11 00:00:00
2656	15	JUAREZ TÁVORA	2010-03-11 00:00:00
2657	15	JUAZEIRINHO	2010-03-11 00:00:00
2658	15	JUNCO DO SERIDÓ	2010-03-11 00:00:00
2659	15	JURIPIRANGA	2010-03-11 00:00:00
2660	15	JURU	2010-03-11 00:00:00
2661	15	LAGOA	2010-03-11 00:00:00
2662	15	LAGOA DE DENTRO	2010-03-11 00:00:00
2663	15	LAGOA SECA	2010-03-11 00:00:00
2664	15	LASTRO	2010-03-11 00:00:00
2665	15	LIVRAMENTO	2010-03-11 00:00:00
2666	15	LOGRADOURO	2010-03-11 00:00:00
2667	15	LUCENA	2010-03-11 00:00:00
2668	15	MÃE D ÁGUA	2010-03-11 00:00:00
2669	15	MALTA	2010-03-11 00:00:00
2670	15	MAMANGUAPE	2010-03-11 00:00:00
2671	15	MANAÍRA	2010-03-11 00:00:00
2672	15	MARCAÇÃO	2010-03-11 00:00:00
2673	15	MARI	2010-03-11 00:00:00
2674	15	MARIZÓPOLIS	2010-03-11 00:00:00
2675	15	MASSARANDUBA	2010-03-11 00:00:00
2676	15	MATARACA	2010-03-11 00:00:00
2677	15	MATINHAS	2010-03-11 00:00:00
2678	15	MATO GROSSO	2010-03-11 00:00:00
2679	15	MATURÉIA	2010-03-11 00:00:00
2680	15	MOGEIRO	2010-03-11 00:00:00
2681	15	MONTADAS	2010-03-11 00:00:00
2682	15	MONTE HOREBE	2010-03-11 00:00:00
2683	15	MONTEIRO	2010-03-11 00:00:00
2684	15	MULUNGU	2010-03-11 00:00:00
2685	15	NATUBA	2010-03-11 00:00:00
2686	15	NAZAREZINHO	2010-03-11 00:00:00
2687	15	NOVA FLORESTA	2010-03-11 00:00:00
2688	15	NOVA OLINDA	2010-03-11 00:00:00
2689	15	NOVA PALMEIRA	2010-03-11 00:00:00
2690	15	OLHO D ÁGUA	2010-03-11 00:00:00
2691	15	OLIVEDOS	2010-03-11 00:00:00
2692	15	OURO VELHO	2010-03-11 00:00:00
2693	15	PARARI	2010-03-11 00:00:00
2694	15	PASSAGEM	2010-03-11 00:00:00
2695	15	PATOS	2010-03-11 00:00:00
2696	15	PAULISTA	2010-03-11 00:00:00
2697	15	PEDRA BRANCA	2010-03-11 00:00:00
2698	15	PEDRA LAVRADA	2010-03-11 00:00:00
2699	15	PEDRAS DE FOGO	2010-03-11 00:00:00
2700	15	PEDRO RÉGIS	2010-03-11 00:00:00
2701	15	PIANCÓ	2010-03-11 00:00:00
2702	15	PICUÍ	2010-03-11 00:00:00
2703	15	PILAR	2010-03-11 00:00:00
2704	15	PILÕES	2010-03-11 00:00:00
2705	15	PILÕEZINHOS	2010-03-11 00:00:00
2706	15	PIRPIRITUBA	2010-03-11 00:00:00
2707	15	PITIMBU	2010-03-11 00:00:00
2708	15	POCINHOS	2010-03-11 00:00:00
2709	15	POÇO DANTAS	2010-03-11 00:00:00
2710	15	POÇO DE JOSÉ DE MOURA	2010-03-11 00:00:00
2711	15	POMBAL	2010-03-11 00:00:00
2712	15	PRATA	2010-03-11 00:00:00
2713	15	PRINCESA ISABEL	2010-03-11 00:00:00
2714	15	PUXINANÃ	2010-03-11 00:00:00
2715	15	QUEIMADAS	2010-03-11 00:00:00
2716	15	QUIXABA	2010-03-11 00:00:00
2717	15	REMÍGIO	2010-03-11 00:00:00
2718	15	RIACHÃO	2010-03-11 00:00:00
2719	15	RIACHÃO DO BACAMARTE	2010-03-11 00:00:00
2720	15	RIACHÃO DO POÇO	2010-03-11 00:00:00
2721	15	RIACHO DE SANTO ANTÔNIO	2010-03-11 00:00:00
2722	15	RIACHO DOS CAVALOS	2010-03-11 00:00:00
2723	15	RIO TINTO	2010-03-11 00:00:00
2724	15	SALGADINHO	2010-03-11 00:00:00
2725	15	SALGADO DE SÃO FÉLIX	2010-03-11 00:00:00
2726	15	SANTA CECÍLIA	2010-03-11 00:00:00
2727	15	SANTA CRUZ	2010-03-11 00:00:00
2728	15	SANTA HELENA	2010-03-11 00:00:00
2729	15	SANTA INÊS	2010-03-11 00:00:00
2730	15	SANTA LUZIA	2010-03-11 00:00:00
2731	15	SANTA RITA	2010-03-11 00:00:00
2732	15	SANTA TERESINHA	2010-03-11 00:00:00
2733	15	SANTANA DE MANGUEIRA	2010-03-11 00:00:00
2734	15	SANTANA DOS GARROTES	2010-03-11 00:00:00
2735	15	SANTARÉM	2010-03-11 00:00:00
2736	15	SANTO ANDRÉ	2010-03-11 00:00:00
2737	15	SÃO BENTINHO	2010-03-11 00:00:00
2738	15	SÃO BENTO	2010-03-11 00:00:00
2739	15	SÃO DOMINGOS DE POMBAL	2010-03-11 00:00:00
2740	15	SÃO DOMINGOS DO CARIRI	2010-03-11 00:00:00
2741	15	SÃO FRANCISCO	2010-03-11 00:00:00
2742	15	SÃO JOÃO DO CARIRI	2010-03-11 00:00:00
2743	15	SÃO JOÃO DO RIO DO PEIXE	2010-03-11 00:00:00
2744	15	SÃO JOÃO DO TIGRE	2010-03-11 00:00:00
2745	15	SÃO JOSÉ DA LAGOA TAPADA	2010-03-11 00:00:00
2746	15	SÃO JOSÉ DE CAIANA	2010-03-11 00:00:00
2747	15	SÃO JOSÉ DE ESPINHARAS	2010-03-11 00:00:00
2748	15	SÃO JOSÉ DE PIRANHAS	2010-03-11 00:00:00
2749	15	SÃO JOSÉ DE PRINCESA	2010-03-11 00:00:00
2750	15	SÃO JOSÉ DO BONFIM	2010-03-11 00:00:00
2751	15	SÃO JOSÉ DO BREJO DA CRUZ	2010-03-11 00:00:00
2752	15	SÃO JOSÉ DO SABUGI	2010-03-11 00:00:00
2753	15	SÃO JOSÉ DOS CORDEIROS	2010-03-11 00:00:00
2754	15	SÃO JOSÉ DOS RAMOS	2010-03-11 00:00:00
2755	15	SÃO MAMEDE	2010-03-11 00:00:00
2756	15	SÃO MIGUEL DE TAIPU	2010-03-11 00:00:00
2757	15	SÃO SEBASTIÃO DE LAGOA DE ROÇA	2010-03-11 00:00:00
2758	15	SÃO SEBASTIÃO DO UMBUZEIRO	2010-03-11 00:00:00
2759	15	SAPÉ	2010-03-11 00:00:00
2760	15	SERIDÓ	2010-03-11 00:00:00
2761	15	SERRA BRANCA	2010-03-11 00:00:00
2762	15	SERRA DA RAIZ	2010-03-11 00:00:00
2763	15	SERRA GRANDE	2010-03-11 00:00:00
2764	15	SERRA REDONDA	2010-03-11 00:00:00
2765	15	SERRARIA	2010-03-11 00:00:00
2766	15	SERTÃOZINHO	2010-03-11 00:00:00
2767	15	SOBRADO	2010-03-11 00:00:00
2768	15	SOLÂNEA	2010-03-11 00:00:00
2769	15	SOLEDADE	2010-03-11 00:00:00
2770	15	SOSSEGO	2010-03-11 00:00:00
2771	15	SOUSA	2010-03-11 00:00:00
2772	15	SUMÉ	2010-03-11 00:00:00
2773	15	TAPEROÁ	2010-03-11 00:00:00
2774	15	TAVARES	2010-03-11 00:00:00
2775	15	TEIXEIRA	2010-03-11 00:00:00
2776	15	TENÓRIO	2010-03-11 00:00:00
2777	15	TRIUNFO	2010-03-11 00:00:00
2778	15	UIRAÚNA	2010-03-11 00:00:00
2779	15	UMBUZEIRO	2010-03-11 00:00:00
2780	15	VÁRZEA	2010-03-11 00:00:00
2781	15	VIERÓPOLIS	2010-03-11 00:00:00
2782	15	VISTA SERRANA	2010-03-11 00:00:00
2783	15	ZABELÊ	2010-03-11 00:00:00
2784	16	ABREU E LIMA	2010-03-11 00:00:00
2785	16	AFOGADOS DA INGAZEIRA	2010-03-11 00:00:00
2786	16	AFRÂNIO	2010-03-11 00:00:00
2787	16	AGRESTINA	2010-03-11 00:00:00
2788	16	ÁGUA PRETA	2010-03-11 00:00:00
2789	16	ÁGUAS BELAS	2010-03-11 00:00:00
2790	16	ALAGOINHA	2010-03-11 00:00:00
2791	16	ALIANÇA	2010-03-11 00:00:00
2792	16	ALTINHO	2010-03-11 00:00:00
2793	16	AMARAJÍ	2010-03-11 00:00:00
2794	16	ANGELIM	2010-03-11 00:00:00
2795	16	ARAÇOIABA	2010-03-11 00:00:00
2796	16	ARARIPINA	2010-03-11 00:00:00
2797	16	ARCOVERDE	2010-03-11 00:00:00
2798	16	BARRA DE GUABIRABA	2010-03-11 00:00:00
2799	16	BARREIROS	2010-03-11 00:00:00
2800	16	BELÉM DE  SÃO FRANCISCO	2010-03-11 00:00:00
2801	16	BELÉM DE MARIA	2010-03-11 00:00:00
2802	16	BELO JARDIM	2010-03-11 00:00:00
2803	16	BETÂNIA	2010-03-11 00:00:00
2804	16	BEZERROS	2010-03-11 00:00:00
2805	16	BODOCÓ	2010-03-11 00:00:00
2806	16	BOM CONSELHO	2010-03-11 00:00:00
2807	16	BOM JARDIM	2010-03-11 00:00:00
2808	16	BONITO	2010-03-11 00:00:00
2809	16	BREJÃO	2010-03-11 00:00:00
2810	16	BREJINHO	2010-03-11 00:00:00
2811	16	BREJO DA MADRE DE DEUS	2010-03-11 00:00:00
2812	16	BUENOS AIRES	2010-03-11 00:00:00
2813	16	BUÍQUE	2010-03-11 00:00:00
2814	16	CABO DE SANTO AGOSTINHO	2010-03-11 00:00:00
2815	16	CABROBÓ	2010-03-11 00:00:00
2816	16	CACHOEIRINHA	2010-03-11 00:00:00
2817	16	CAETÉS	2010-03-11 00:00:00
2818	16	CALÇADO	2010-03-11 00:00:00
2819	16	CALUMBÍ	2010-03-11 00:00:00
2820	16	CAMARAGIBE	2010-03-11 00:00:00
2821	16	CAMOCIM DE SÃO FÉLIX	2010-03-11 00:00:00
2822	16	CAMUTANGA	2010-03-11 00:00:00
2823	16	CANHOTINHO	2010-03-11 00:00:00
2824	16	CAPOEIRAS	2010-03-11 00:00:00
2825	16	CARNAÍBA	2010-03-11 00:00:00
2826	16	CARNAUBEIRAS DA PENHA	2010-03-11 00:00:00
2827	16	CARPINA	2010-03-11 00:00:00
2828	16	CARUARU	2010-03-11 00:00:00
2829	16	CASINHAS	2010-03-11 00:00:00
2830	16	CATENDE	2010-03-11 00:00:00
2831	16	CEDRO	2010-03-11 00:00:00
2832	16	CHÃ DE ALEGRIA	2010-03-11 00:00:00
2833	16	CHÃ GRANDE	2010-03-11 00:00:00
2834	16	CONDADO	2010-03-11 00:00:00
2835	16	CORRENTES	2010-03-11 00:00:00
2836	16	CORTÊS	2010-03-11 00:00:00
2837	16	CUMARU	2010-03-11 00:00:00
2838	16	CUPIRA	2010-03-11 00:00:00
2839	16	CUSTÓDIA	2010-03-11 00:00:00
2840	16	DORMENTES	2010-03-11 00:00:00
2841	16	ESCADA	2010-03-11 00:00:00
2842	16	EXÚ	2010-03-11 00:00:00
2843	16	FEIRA NOVA	2010-03-11 00:00:00
2844	16	FERNANDO DE NORONHA	2010-03-11 00:00:00
2845	16	FERREIROS	2010-03-11 00:00:00
2846	16	FLORES	2010-03-11 00:00:00
2847	16	FLORESTA	2010-03-11 00:00:00
2848	16	FREI MIGUELINHO	2010-03-11 00:00:00
2849	16	GAMELEIRA	2010-03-11 00:00:00
2850	16	GARANHUNS	2010-03-11 00:00:00
2851	16	GLÓRIA DO GOITÁ	2010-03-11 00:00:00
2852	16	GOIANA	2010-03-11 00:00:00
2853	16	GRANITO	2010-03-11 00:00:00
2854	16	GRAVATÁ	2010-03-11 00:00:00
2855	16	IATÍ	2010-03-11 00:00:00
2856	16	IBIMIRIM	2010-03-11 00:00:00
2857	16	IBIRAJUBA	2010-03-11 00:00:00
2858	16	IGARASSU	2010-03-11 00:00:00
2859	16	IGUARACI	2010-03-11 00:00:00
2860	16	ILHA DE ITAMARACÁ	2010-03-11 00:00:00
2861	16	INAJÁ	2010-03-11 00:00:00
2862	16	INGAZEIRA	2010-03-11 00:00:00
2863	16	IPOJUCA	2010-03-11 00:00:00
2864	16	IPUBI	2010-03-11 00:00:00
2865	16	ITACURUBA	2010-03-11 00:00:00
2866	16	ITAÍBA	2010-03-11 00:00:00
2867	16	ITAMBÉ	2010-03-11 00:00:00
2868	16	ITAPETIM	2010-03-11 00:00:00
2869	16	ITAPISSUMA	2010-03-11 00:00:00
2870	16	ITAQUITINGA	2010-03-11 00:00:00
2871	16	JABOATÃO DOS GUARARAPES	2010-03-11 00:00:00
2872	16	JAQUEIRA	2010-03-11 00:00:00
2873	16	JATAÚBA	2010-03-11 00:00:00
2874	16	JATOBÁ	2010-03-11 00:00:00
2875	16	JOÃO ALFREDO	2010-03-11 00:00:00
2876	16	JOAQUIM NABUCO	2010-03-11 00:00:00
2877	16	JUCATI	2010-03-11 00:00:00
2878	16	JUPÍ	2010-03-11 00:00:00
2879	16	JUREMA	2010-03-11 00:00:00
2880	16	LAGOA DO CARRO	2010-03-11 00:00:00
2881	16	LAGOA DO ITAENGA	2010-03-11 00:00:00
2882	16	LAGOA DO OURO	2010-03-11 00:00:00
2883	16	LAGOA DOS GATOS	2010-03-11 00:00:00
2884	16	LAGOA GRANDE	2010-03-11 00:00:00
2885	16	LAJEDO	2010-03-11 00:00:00
2886	16	LIMOEIRO	2010-03-11 00:00:00
2887	16	MACAPARANA	2010-03-11 00:00:00
2888	16	MACHADOS	2010-03-11 00:00:00
2889	16	MANARI	2010-03-11 00:00:00
2890	16	MARAIAL	2010-03-11 00:00:00
2891	16	MIRANDIBA	2010-03-11 00:00:00
2892	16	MOREILÂNDIA	2010-03-11 00:00:00
2893	16	MORENO	2010-03-11 00:00:00
2894	16	NAZARÉ DA MATA	2010-03-11 00:00:00
2895	16	OLINDA	2010-03-11 00:00:00
2896	16	OROBÓ	2010-03-11 00:00:00
2897	16	OROCÓ	2010-03-11 00:00:00
2898	16	OURICURI	2010-03-11 00:00:00
2899	16	PALMARES	2010-03-11 00:00:00
2900	16	PALMEIRINA	2010-03-11 00:00:00
2901	16	PANELAS	2010-03-11 00:00:00
2902	16	PARANATAMA	2010-03-11 00:00:00
2903	16	PARNAMIRIM	2010-03-11 00:00:00
2904	16	PASSIRA	2010-03-11 00:00:00
2905	16	PAUDALHO	2010-03-11 00:00:00
2906	16	PAULISTA	2010-03-11 00:00:00
2907	16	PEDRA	2010-03-11 00:00:00
2908	16	PESQUEIRA	2010-03-11 00:00:00
2909	16	PETROLÂNDIA	2010-03-11 00:00:00
2910	16	PETROLINA	2010-03-11 00:00:00
2911	16	POÇÃO	2010-03-11 00:00:00
2912	16	POMBOS	2010-03-11 00:00:00
2913	16	PRIMAVERA	2010-03-11 00:00:00
2914	16	QUIPAPÁ	2010-03-11 00:00:00
2915	16	QUIXABA	2010-03-11 00:00:00
2916	16	RECIFE	2010-03-11 00:00:00
2917	16	RIACHO DAS ALMAS	2010-03-11 00:00:00
2918	16	RIBEIRÃO	2010-03-11 00:00:00
2919	16	RIO FORMOSO	2010-03-11 00:00:00
2920	16	SAIRÉ	2010-03-11 00:00:00
2921	16	SALGADINHO	2010-03-11 00:00:00
2922	16	SALGUEIRO	2010-03-11 00:00:00
2923	16	SALOÁ	2010-03-11 00:00:00
2924	16	SANHARÓ	2010-03-11 00:00:00
2925	16	SANTA CRUZ	2010-03-11 00:00:00
2926	16	SANTA CRUZ DA BAIXA VERDE	2010-03-11 00:00:00
2927	16	SANTA CRUZ DO CAPIBARIBE	2010-03-11 00:00:00
2928	16	SANTA FILOMENA	2010-03-11 00:00:00
2929	16	SANTA MARIA DA BOA VISTA	2010-03-11 00:00:00
2930	16	SANTA MARIA DO CAMBUCÁ	2010-03-11 00:00:00
2931	16	SANTA TEREZINHA	2010-03-11 00:00:00
2932	16	SÃO BENEDITO DO SUL	2010-03-11 00:00:00
2933	16	SÃO BENTO DO UNA	2010-03-11 00:00:00
2934	16	SÃO CAITANO	2010-03-11 00:00:00
2935	16	SÃO JOÃO	2010-03-11 00:00:00
2936	16	SÃO JOAQUIM DO MONTE	2010-03-11 00:00:00
2937	16	SÃO JOSÉ DA COROA GRANDE	2010-03-11 00:00:00
2938	16	SÃO JOSÉ DO BELMONTE	2010-03-11 00:00:00
2939	16	SÃO JOSÉ DO EGITO	2010-03-11 00:00:00
2940	16	SÃO LOURENÇO DA MATA	2010-03-11 00:00:00
2941	16	SÃO VICENTE FERRER	2010-03-11 00:00:00
2942	16	SERRA TALHADA	2010-03-11 00:00:00
2943	16	SERRITA	2010-03-11 00:00:00
2944	16	SERTÂNIA	2010-03-11 00:00:00
2945	16	SIRINHAÉM	2010-03-11 00:00:00
2946	16	SOLIDÃO	2010-03-11 00:00:00
2947	16	SURUBIM	2010-03-11 00:00:00
2948	16	TABIRA	2010-03-11 00:00:00
2949	16	TACAIMBÓ	2010-03-11 00:00:00
2950	16	TACARATU	2010-03-11 00:00:00
2951	16	TAMANDARÉ	2010-03-11 00:00:00
2952	16	TAQUARITINGA DO NORTE	2010-03-11 00:00:00
2953	16	TEREZINHA	2010-03-11 00:00:00
2954	16	TERRA NOVA	2010-03-11 00:00:00
2955	16	TIMBAÚBA	2010-03-11 00:00:00
2956	16	TORITAMA	2010-03-11 00:00:00
2957	16	TRACUNHAÉM	2010-03-11 00:00:00
2958	16	TRINDADE	2010-03-11 00:00:00
2959	16	TRIUNFO	2010-03-11 00:00:00
2960	16	TUPANATINGA	2010-03-11 00:00:00
2961	16	TUPARETAMA	2010-03-11 00:00:00
2962	16	VENTUROSA	2010-03-11 00:00:00
2963	16	VERDEJANTE	2010-03-11 00:00:00
2964	16	VERTENTE DO LÉRIO	2010-03-11 00:00:00
2965	16	VERTENTES	2010-03-11 00:00:00
2966	16	VICÊNCIA	2010-03-11 00:00:00
2967	16	VITÓRIA DE SANTO ANTÃO	2010-03-11 00:00:00
2968	16	XEXÉU	2010-03-11 00:00:00
2969	17	ACAUÃ	2010-03-11 00:00:00
2970	17	AGRICOLÂNDIA	2010-03-11 00:00:00
2971	17	ÁGUA BRANCA	2010-03-11 00:00:00
2972	17	ALAGOINHA DO PIAUÍ	2010-03-11 00:00:00
2973	17	ALEGRETE DO PIAUÍ	2010-03-11 00:00:00
2974	17	ALTO LONGÁ	2010-03-11 00:00:00
2975	17	ALTOS	2010-03-11 00:00:00
2976	17	ALVORADA DO GURGUÉIA	2010-03-11 00:00:00
2977	17	AMARANTE	2010-03-11 00:00:00
2978	17	ANGICAL DO PIAUÍ	2010-03-11 00:00:00
2979	17	ANÍSIO DE ABREU	2010-03-11 00:00:00
2980	17	ANTÔNIO ALMEIDA	2010-03-11 00:00:00
2981	17	AROAZES	2010-03-11 00:00:00
2982	17	AROEIRAS DO ITAIM	2010-03-11 00:00:00
2983	17	ARRAIAL	2010-03-11 00:00:00
2984	17	ASSUNÇÃO DO PIAUÍ	2010-03-11 00:00:00
2985	17	AVELINO LOPES	2010-03-11 00:00:00
2986	17	BAIXA GRANDE DO RIBEIRO	2010-03-11 00:00:00
2987	17	BARRA D ALCÂNTARA	2010-03-11 00:00:00
2988	17	BARRAS	2010-03-11 00:00:00
2989	17	BARREIRAS DO PIAUÍ	2010-03-11 00:00:00
2990	17	BARRO DURO	2010-03-11 00:00:00
2991	17	BATALHA	2010-03-11 00:00:00
2992	17	BELA VISTA DO PIAUÍ	2010-03-11 00:00:00
2993	17	BELÉM DO PIAUÍ	2010-03-11 00:00:00
2994	17	BENEDITINOS	2010-03-11 00:00:00
2995	17	BERTOLÍNIA	2010-03-11 00:00:00
2996	17	BETÂNIA DO PIAUÍ	2010-03-11 00:00:00
2997	17	BOA HORA	2010-03-11 00:00:00
2998	17	BOCAINA	2010-03-11 00:00:00
2999	17	BOM JESUS	2010-03-11 00:00:00
3000	17	BOM PRINCÍPIO DO PIAUÍ	2010-03-11 00:00:00
3001	17	BONFIM DO PIAUÍ	2010-03-11 00:00:00
3002	17	BOQUEIRÃO DO PIAUÍ	2010-03-11 00:00:00
3003	17	BRASILEIRA	2010-03-11 00:00:00
3004	17	BREJO DO PIAUÍ	2010-03-11 00:00:00
3005	17	BURITI DOS LOPES	2010-03-11 00:00:00
3006	17	BURITI DOS MONTES	2010-03-11 00:00:00
3007	17	CABECEIRAS DO PIAUÍ	2010-03-11 00:00:00
3008	17	CAJAZEIRAS DO PIAUÍ	2010-03-11 00:00:00
3009	17	CAJUEIRO DA PRAIA	2010-03-11 00:00:00
3010	17	CALDEIRÃO GRANDE DO PIAUÍ	2010-03-11 00:00:00
3011	17	CAMPINAS DO PIAUÍ	2010-03-11 00:00:00
3012	17	CAMPO ALEGRE DO FIDALGO	2010-03-11 00:00:00
3013	17	CAMPO GRANDE DO PIAUÍ	2010-03-11 00:00:00
3014	17	CAMPO LARGO DO PIAUÍ	2010-03-11 00:00:00
3015	17	CAMPO MAIOR	2010-03-11 00:00:00
3016	17	CANAVIEIRA	2010-03-11 00:00:00
3017	17	CANTO DO BURITI	2010-03-11 00:00:00
3018	17	CAPITÃO DE CAMPOS	2010-03-11 00:00:00
3019	17	CAPITÃO GERVÁSIO OLIVEIRA	2010-03-11 00:00:00
3020	17	CARACOL	2010-03-11 00:00:00
3021	17	CARAÚBAS DO PIAUÍ	2010-03-11 00:00:00
3022	17	CARIDADE DO PIAUÍ	2010-03-11 00:00:00
3023	17	CASTELO DO PIAUÍ	2010-03-11 00:00:00
3024	17	CAXINGÓ	2010-03-11 00:00:00
3025	17	COCAL	2010-03-11 00:00:00
3026	17	COCAL DE TELHA	2010-03-11 00:00:00
3027	17	COCAL DO ALVES	2010-03-11 00:00:00
3028	17	COIVARAS	2010-03-11 00:00:00
3029	17	COLÔNIA DO GURGUÉIA	2010-03-11 00:00:00
3030	17	COLÔNIA DO PIAUÍ	2010-03-11 00:00:00
3031	17	CONCEIÇÃO DO CANINDÉ	2010-03-11 00:00:00
3032	17	CORONEL JOSÉ DIAS	2010-03-11 00:00:00
3033	17	CORRENTE	2010-03-11 00:00:00
3034	17	CRISTALÂNDIA DO PIAUÍ	2010-03-11 00:00:00
3035	17	CRISTINO CASTRO	2010-03-11 00:00:00
3036	17	CURIMATÁ	2010-03-11 00:00:00
3037	17	CURRAIS	2010-03-11 00:00:00
3038	17	CURRAL NOVO DO PIAUÍ	2010-03-11 00:00:00
3039	17	CURRALINHOS	2010-03-11 00:00:00
3040	17	DEMERVAL LOBÃO	2010-03-11 00:00:00
3041	17	DIRCEU ARCOVERDE	2010-03-11 00:00:00
3042	17	DOM EXPEDITO LOPES	2010-03-11 00:00:00
3043	17	DOM INOCÊNCIO	2010-03-11 00:00:00
3044	17	DOMINGOS MOURÃO	2010-03-11 00:00:00
3045	17	ELESBÃO VELOSO	2010-03-11 00:00:00
3046	17	ELISEU MARTINS	2010-03-11 00:00:00
3047	17	ESPERANTINA	2010-03-11 00:00:00
3048	17	FARTURA DO PIAUÍ	2010-03-11 00:00:00
3049	17	FLORES DO PIAUÍ	2010-03-11 00:00:00
3050	17	FLORESTA DO PIAUÍ	2010-03-11 00:00:00
3051	17	FLORIANO	2010-03-11 00:00:00
3052	17	FRANCINÓPOLIS	2010-03-11 00:00:00
3053	17	FRANCISCO AYRES	2010-03-11 00:00:00
3054	17	FRANCISCO MACEDO	2010-03-11 00:00:00
3055	17	FRANCISCO SANTOS	2010-03-11 00:00:00
3056	17	FRONTEIRAS	2010-03-11 00:00:00
3057	17	GEMINIANO	2010-03-11 00:00:00
3058	17	GILBUÉS	2010-03-11 00:00:00
3059	17	GUADALUPE	2010-03-11 00:00:00
3060	17	GUARIBAS	2010-03-11 00:00:00
3061	17	HUGO NAPOLEÃO	2010-03-11 00:00:00
3062	17	ILHA GRANDE	2010-03-11 00:00:00
3063	17	INHUMA	2010-03-11 00:00:00
3064	17	IPIRANGA DO PIAUÍ	2010-03-11 00:00:00
3065	17	ISAIAS COELHO	2010-03-11 00:00:00
3066	17	ITAINÓPOLIS	2010-03-11 00:00:00
3067	17	ITAUEIRA	2010-03-11 00:00:00
3068	17	JACOBINA DO PIAUÍ	2010-03-11 00:00:00
3069	17	JAICÓS	2010-03-11 00:00:00
3070	17	JARDIM DO MULATO	2010-03-11 00:00:00
3071	17	JATOBÁ DO PIAUÍ	2010-03-11 00:00:00
3072	17	JERUMENHA	2010-03-11 00:00:00
3073	17	JOÃO COSTA	2010-03-11 00:00:00
3074	17	JOAQUIM PIRES	2010-03-11 00:00:00
3075	17	JOCA MARQUES	2010-03-11 00:00:00
3076	17	JOSÉ DE FREITAS	2010-03-11 00:00:00
3077	17	JUAZEIRO DO PIAUÍ	2010-03-11 00:00:00
3078	17	JÚLIO BORGES	2010-03-11 00:00:00
3079	17	JUREMA	2010-03-11 00:00:00
3080	17	LAGOA ALEGRE	2010-03-11 00:00:00
3081	17	LAGOA DO BARRO DO PIAUÍ	2010-03-11 00:00:00
3082	17	LAGOA DO PIAUÍ	2010-03-11 00:00:00
3083	17	LAGOA DO SÃO FRANCISCO	2010-03-11 00:00:00
3084	17	LAGOA DO SÍTIO	2010-03-11 00:00:00
3085	17	LAGOINHA DO PIAUÍ	2010-03-11 00:00:00
3086	17	LANDRI SALES	2010-03-11 00:00:00
3087	17	LUÍS CORREIA	2010-03-11 00:00:00
3088	17	LUZILÂNDIA	2010-03-11 00:00:00
3089	17	MADEIRO	2010-03-11 00:00:00
3090	17	MANOEL EMÍDIO	2010-03-11 00:00:00
3091	17	MARCOLÂNDIA	2010-03-11 00:00:00
3092	17	MARCOS PARENTE	2010-03-11 00:00:00
3093	17	MASSAPÊ DO PIAUÍ	2010-03-11 00:00:00
3094	17	MATIAS OLÍMPIO	2010-03-11 00:00:00
3095	17	MIGUEL ALVES	2010-03-11 00:00:00
3096	17	MIGUEL LEÃO	2010-03-11 00:00:00
3097	17	MILTON BRANDÃO	2010-03-11 00:00:00
3098	17	MONSENHOR GIL	2010-03-11 00:00:00
3099	17	MONSENHOR HIPÓLITO	2010-03-11 00:00:00
3100	17	MONTE ALEGRE DO PIAUÍ	2010-03-11 00:00:00
3101	17	MORRO CABEÇA NO TEMPO	2010-03-11 00:00:00
3102	17	MORRO DO CHAPÉU DO PIAUÍ	2010-03-11 00:00:00
3103	17	MURICI DOS PORTELAS	2010-03-11 00:00:00
3104	17	NAZARÉ DO PIAUÍ	2010-03-11 00:00:00
3105	17	NOSSA SENHORA DE NAZARÉ	2010-03-11 00:00:00
3106	17	NOSSA SENHORA DOS REMÉDIOS	2010-03-11 00:00:00
3107	17	NOVA SANTA RITA	2010-03-11 00:00:00
3108	17	NOVO ORIENTE DO PIAUÍ	2010-03-11 00:00:00
3109	17	NOVO SANTO ANTÔNIO	2010-03-11 00:00:00
3110	17	OEIRAS	2010-03-11 00:00:00
3111	17	OLHO D ÁGUA DO PIAUÍ	2010-03-11 00:00:00
3112	17	PADRE MARCOS	2010-03-11 00:00:00
3113	17	PAES LANDIM	2010-03-11 00:00:00
3114	17	PAJEÚ DO PIAUÍ	2010-03-11 00:00:00
3115	17	PALMEIRA DO PIAUÍ	2010-03-11 00:00:00
3116	17	PALMERAIS	2010-03-11 00:00:00
3117	17	PAQUETÁ	2010-03-11 00:00:00
3118	17	PARNAGUÁ	2010-03-11 00:00:00
3119	17	PARNAÍBA	2010-03-11 00:00:00
3120	17	PASSAGEM FRANCA DO PIAUÍ	2010-03-11 00:00:00
3121	17	PATOS DO PIAUÍ	2010-03-11 00:00:00
3122	17	PAU D´ARCO DO PIAUÍ	2010-03-11 00:00:00
3123	17	PAULISTANA	2010-03-11 00:00:00
3124	17	PAVUSSU	2010-03-11 00:00:00
3125	17	PEDRO II	2010-03-11 00:00:00
3126	17	PEDRO LAURENTINO	2010-03-11 00:00:00
3127	17	PICOS	2010-03-11 00:00:00
3128	17	PIMENTEIRAS	2010-03-11 00:00:00
3129	17	PIO IX	2010-03-11 00:00:00
3130	17	PIRACURUCA	2010-03-11 00:00:00
3131	17	PIRIPIRI	2010-03-11 00:00:00
3132	17	PORTO	2010-03-11 00:00:00
3133	17	PORTO ALEGRE DO PIAUÍ	2010-03-11 00:00:00
3134	17	PRATA DO PIAUÍ	2010-03-11 00:00:00
3135	17	QUEIMADA NOVA	2010-03-11 00:00:00
3136	17	REDENÇÃO DO GURGUÉIA	2010-03-11 00:00:00
3137	17	REGENERAÇÃO	2010-03-11 00:00:00
3138	17	RIACHO FRIO	2010-03-11 00:00:00
3139	17	RIBEIRA DO PIAUÍ	2010-03-11 00:00:00
3140	17	RIBEIRO GONÇALVES	2010-03-11 00:00:00
3141	17	RIO GRANDE DO PIAUÍ	2010-03-11 00:00:00
3142	17	SANTA CRUZ DO PIAUÍ	2010-03-11 00:00:00
3143	17	SANTA CRUZ DOS MILAGRES	2010-03-11 00:00:00
3144	17	SANTA FILOMENA	2010-03-11 00:00:00
3145	17	SANTA LUZ	2010-03-11 00:00:00
3146	17	SANTA ROSA DO PIAUÍ	2010-03-11 00:00:00
3147	17	SANTANA DO PIAUÍ	2010-03-11 00:00:00
3148	17	SANTO ANTÔNIO DE LISBOA	2010-03-11 00:00:00
3149	17	SANTO ANTÔNIO DOS MILAGRES	2010-03-11 00:00:00
3150	17	SANTO INÁCIO DO PIAUÍ	2010-03-11 00:00:00
3151	17	SÃO BRAZ DO PIAUÍ	2010-03-11 00:00:00
3152	17	SÃO FÉLIX DO PIAUÍ	2010-03-11 00:00:00
3153	17	SÃO FRANCISCO DE ASSIS DO PIAUÍ	2010-03-11 00:00:00
3154	17	SÃO FRANCISCO DO PIAUÍ	2010-03-11 00:00:00
3155	17	SÃO GONÇALO DO GURGUÉIA	2010-03-11 00:00:00
3156	17	SÃO GONÇALO DO PIAUÍ	2010-03-11 00:00:00
3157	17	SÃO JOÃO DA CANABRAVA	2010-03-11 00:00:00
3158	17	SÃO JOÃO DA FRONTEIRA	2010-03-11 00:00:00
3159	17	SÃO JOÃO DA SERRA	2010-03-11 00:00:00
3160	17	SÃO JOÃO DA VARJOTA	2010-03-11 00:00:00
3161	17	SÃO JOÃO DO ARRAIAL	2010-03-11 00:00:00
3162	17	SÃO JOÃO DO PIAUÍ	2010-03-11 00:00:00
3163	17	SÃO JOSÉ DO DIVINO	2010-03-11 00:00:00
3164	17	SÃO JOSÉ DO PEIXE	2010-03-11 00:00:00
3165	17	SÃO JOSÉ DO PIAUÍ	2010-03-11 00:00:00
3166	17	SÃO JULIÃO	2010-03-11 00:00:00
3167	17	SÃO LOURENÇO DO PIAUÍ	2010-03-11 00:00:00
3168	17	SÃO LUÍS DO PIAUÍ	2010-03-11 00:00:00
3169	17	SÃO MIGUEL DA BAIXA GRANDE	2010-03-11 00:00:00
3170	17	SÃO MIGUEL DO FIDALGO	2010-03-11 00:00:00
3171	17	SÃO MIGUEL DO TAPUIO	2010-03-11 00:00:00
3172	17	SÃO PEDRO DO PIAUÍ	2010-03-11 00:00:00
3173	17	SÃO RAIMUNDO NONATO	2010-03-11 00:00:00
3174	17	SEBASTIÃO BARROS	2010-03-11 00:00:00
3175	17	SEBASTIÃO LEAL	2010-03-11 00:00:00
3176	17	SIGEFREDO PACHECO	2010-03-11 00:00:00
3177	17	SIMÕES	2010-03-11 00:00:00
3178	17	SIMPLÍCIO MENDES	2010-03-11 00:00:00
3179	17	SOCORRO DO PIAUÍ	2010-03-11 00:00:00
3180	17	SUSSUAPARA	2010-03-11 00:00:00
3181	17	TAMBORIL DO PIAUÍ	2010-03-11 00:00:00
3182	17	TANQUE DO PIAUÍ	2010-03-11 00:00:00
3183	17	TERESINA	2010-03-11 00:00:00
3184	17	UNIÃO	2010-03-11 00:00:00
3185	17	URUÇUÍ	2010-03-11 00:00:00
3186	17	VALENÇA DO PIAUÍ	2010-03-11 00:00:00
3187	17	VÁRZEA BRANCA	2010-03-11 00:00:00
3188	17	VÁRZEA GRANDE	2010-03-11 00:00:00
3189	17	VERA MENDES	2010-03-11 00:00:00
3190	17	VILA NOVA DO PIAUÍ	2010-03-11 00:00:00
3191	17	WALL FERRAZ	2010-03-11 00:00:00
3192	18	ABATIA	2010-03-11 00:00:00
3193	18	ADRIANÓPOLIS	2010-03-11 00:00:00
3194	18	AGUDOS DO SUL	2010-03-11 00:00:00
3195	18	ALMIRANTE TAMANDARÉ	2010-03-11 00:00:00
3196	18	ALTAMIRA DO PARANÁ	2010-03-11 00:00:00
3197	18	ALTO PARAÍSO	2010-03-11 00:00:00
3198	18	ALTO PARANÁ	2010-03-11 00:00:00
3199	18	ALTO PIQUIRI	2010-03-11 00:00:00
3200	18	ALTONIA	2010-03-11 00:00:00
3201	18	ALVORADA DO SUL	2010-03-11 00:00:00
3202	18	AMAPORÃ	2010-03-11 00:00:00
3203	18	AMPERE	2010-03-11 00:00:00
3204	18	ANAHY	2010-03-11 00:00:00
3205	18	ANDIRA	2010-03-11 00:00:00
3206	18	ÂNGULO	2010-03-11 00:00:00
3207	18	ANTONINA	2010-03-11 00:00:00
3208	18	ANTONIO OLINTO	2010-03-11 00:00:00
3209	18	APUCARANA	2010-03-11 00:00:00
3210	18	ARAPONGAS	2010-03-11 00:00:00
3211	18	ARAPOTI	2010-03-11 00:00:00
3212	18	ARAPUA	2010-03-11 00:00:00
3213	18	ARARUNA	2010-03-11 00:00:00
3214	18	ARAUCÁRIA	2010-03-11 00:00:00
3215	18	ARIRANHA DO IVAÍ	2010-03-11 00:00:00
3216	18	ASSAÍ	2010-03-11 00:00:00
3217	18	ASSIS CHATEAUBRIAND	2010-03-11 00:00:00
3218	18	ASTORGA	2010-03-11 00:00:00
3219	18	ATALAIA	2010-03-11 00:00:00
3220	18	BALSA NOVA	2010-03-11 00:00:00
3221	18	BANDEIRANTES	2010-03-11 00:00:00
3222	18	BARBOSA FERRAZ	2010-03-11 00:00:00
3223	18	BARRA DO JACARÉ	2010-03-11 00:00:00
3224	18	BARRACÃO	2010-03-11 00:00:00
3225	18	BELA VISTA DA CAROBA	2010-03-11 00:00:00
3226	18	BELA VISTA DO PARAÍSO	2010-03-11 00:00:00
3227	18	BITURUNA	2010-03-11 00:00:00
3228	18	BOA ESPERANÇA	2010-03-11 00:00:00
3229	18	BOA ESPERANÇA DO IGUAÇU	2010-03-11 00:00:00
3230	18	BOA VENTURA DE SÃO ROQUE	2010-03-11 00:00:00
3231	18	BOA VISTA DA APARECIDA	2010-03-11 00:00:00
3232	18	BOCAIÚVA DO SUL	2010-03-11 00:00:00
3233	18	BOM JESUS DO SUL	2010-03-11 00:00:00
3234	18	BOM SUCESSO	2010-03-11 00:00:00
3235	18	BOM SUCESSO DO SUL	2010-03-11 00:00:00
3236	18	BORRAZÓPOLIS	2010-03-11 00:00:00
3237	18	BRAGANEY	2010-03-11 00:00:00
3238	18	BRASILÂNDIA DO SUL	2010-03-11 00:00:00
3239	18	CAFEARA	2010-03-11 00:00:00
3240	18	CAFELÂNDIA	2010-03-11 00:00:00
3241	18	CAFEZAL DO SUL	2010-03-11 00:00:00
3242	18	CALIFÓRNIA	2010-03-11 00:00:00
3243	18	CAMBARÁ	2010-03-11 00:00:00
3244	18	CAMBÉ	2010-03-11 00:00:00
3245	18	CAMBIRA	2010-03-11 00:00:00
3246	18	CAMPINA DA LAGOA	2010-03-11 00:00:00
3247	18	CAMPINA DO SIMÃO	2010-03-11 00:00:00
3248	18	CAMPINA GRANDE DO SUL	2010-03-11 00:00:00
3249	18	CAMPO BONITO	2010-03-11 00:00:00
3250	18	CAMPO DO TENENTE	2010-03-11 00:00:00
3251	18	CAMPO LARGO	2010-03-11 00:00:00
3252	18	CAMPO MAGRO	2010-03-11 00:00:00
3253	18	CAMPO MOURÃO	2010-03-11 00:00:00
3254	18	CÂNDIDO DE ABREU	2010-03-11 00:00:00
3255	18	CANDOI	2010-03-11 00:00:00
3256	18	CANTAGALO	2010-03-11 00:00:00
3257	18	CAPANEMA	2010-03-11 00:00:00
3258	18	CAPITÃO LEÔNIDAS MARQUES	2010-03-11 00:00:00
3259	18	CARAMBEÍ	2010-03-11 00:00:00
3260	18	CARLÓPOLIS	2010-03-11 00:00:00
3261	18	CASCAVEL	2010-03-11 00:00:00
3262	18	CASTRO	2010-03-11 00:00:00
3263	18	CATANDUVAS	2010-03-11 00:00:00
3264	18	CENTENÁRIO DO SUL	2010-03-11 00:00:00
3265	18	CÉU AZUL	2010-03-11 00:00:00
3266	18	CHOPINZINHO	2010-03-11 00:00:00
3267	18	CIANORTE	2010-03-11 00:00:00
3268	18	CIDADE GAÚCHA	2010-03-11 00:00:00
3269	18	CLEVELÂNDIA	2010-03-11 00:00:00
3270	18	COLOMBO	2010-03-11 00:00:00
3271	18	COLORADO	2010-03-11 00:00:00
3272	18	CONGONHINHAS	2010-03-11 00:00:00
3273	18	CONSELHEIRO MAIRINCK	2010-03-11 00:00:00
3274	18	CONTENDA	2010-03-11 00:00:00
3275	18	CORBÉLIA	2010-03-11 00:00:00
3276	18	CORNÉLIO PROCÓPIO	2010-03-11 00:00:00
3277	18	CORONEL DOMINGOS  SOARES	2010-03-11 00:00:00
3278	18	CORONEL VIVIDA	2010-03-11 00:00:00
3279	18	CORUMBATAÍ DO SUL	2010-03-11 00:00:00
3280	18	CRUZ MACHADO	2010-03-11 00:00:00
3281	18	CRUZEIRO DO IGUAÇU	2010-03-11 00:00:00
3282	18	CRUZEIRO DO OESTE	2010-03-11 00:00:00
3283	18	CRUZEIRO DO SUL	2010-03-11 00:00:00
3284	18	CRUZMALTINA	2010-03-11 00:00:00
3285	18	CURITIBA	2010-03-11 00:00:00
3286	18	CURIUVA	2010-03-11 00:00:00
3287	18	DIAMANTE D OESTE	2010-03-11 00:00:00
3288	18	DIAMANTE DO NORTE	2010-03-11 00:00:00
3289	18	DIAMANTE DO SUL	2010-03-11 00:00:00
3290	18	DOIS VIZINHOS	2010-03-11 00:00:00
3291	18	DOURADINA	2010-03-11 00:00:00
3292	18	DOUTOR CAMARGO	2010-03-11 00:00:00
3293	18	DOUTOR ULYSSES	2010-03-11 00:00:00
3294	18	ENÉAS MARQUES	2010-03-11 00:00:00
3295	18	ENGENHEIRO BELTRÃO	2010-03-11 00:00:00
3296	18	ENTRE RIOS DO OESTE	2010-03-11 00:00:00
3297	18	ESPERANÇA NOVA	2010-03-11 00:00:00
3298	18	ESPIGÃO ALTO DO IGUAÇU	2010-03-11 00:00:00
3299	18	FAROL	2010-03-11 00:00:00
3300	18	FAXINAL	2010-03-11 00:00:00
3301	18	FAZENDA RIO GRANDE	2010-03-11 00:00:00
3302	18	FÊNIX	2010-03-11 00:00:00
3303	18	FERNANDES PINHEIRO	2010-03-11 00:00:00
3304	18	FIGUEIRA	2010-03-11 00:00:00
3305	18	FLOR DA SERRA DO SUL	2010-03-11 00:00:00
3306	18	FLORAI	2010-03-11 00:00:00
3307	18	FLORESTA	2010-03-11 00:00:00
3308	18	FLORESTÓPOLIS	2010-03-11 00:00:00
3309	18	FLÓRIDA	2010-03-11 00:00:00
3310	18	FORMOSA DO OESTE	2010-03-11 00:00:00
3311	18	FOZ DO IGUAÇU	2010-03-11 00:00:00
3312	18	FOZ DO JORDÃO	2010-03-11 00:00:00
3313	18	FRANCISCO ALVES	2010-03-11 00:00:00
3314	18	FRANCISCO BELTRÃO	2010-03-11 00:00:00
3315	18	GENERAL CARNEIRO	2010-03-11 00:00:00
3316	18	GODOY MOREIRA	2010-03-11 00:00:00
3317	18	GOIÔERE	2010-03-11 00:00:00
3318	18	GOIOXIM	2010-03-11 00:00:00
3319	18	GRANDES RIOS	2010-03-11 00:00:00
3320	18	GUAÍRA	2010-03-11 00:00:00
3321	18	GUAIRAÇA	2010-03-11 00:00:00
3322	18	GUAMIRANGA	2010-03-11 00:00:00
3323	18	GUAPIRAMA	2010-03-11 00:00:00
3324	18	GUAPOREMA	2010-03-11 00:00:00
3325	18	GUARACI	2010-03-11 00:00:00
3326	18	GUARANIAÇU	2010-03-11 00:00:00
3327	18	GUARAPUAVA	2010-03-11 00:00:00
3328	18	GUARAQUEÇABA	2010-03-11 00:00:00
3329	18	GUARATUBA	2010-03-11 00:00:00
3330	18	HONÓRIO SERPA	2010-03-11 00:00:00
3331	18	IBAITI	2010-03-11 00:00:00
3332	18	IBEMA	2010-03-11 00:00:00
3333	18	IBIPORÃ	2010-03-11 00:00:00
3334	18	ICARAIMA	2010-03-11 00:00:00
3335	18	IGUARAÇU	2010-03-11 00:00:00
3336	18	IGUATU	2010-03-11 00:00:00
3337	18	IMBAU	2010-03-11 00:00:00
3338	18	IMBITUVA	2010-03-11 00:00:00
3339	18	INÁCIO MARTINS	2010-03-11 00:00:00
3340	18	INAJÁ	2010-03-11 00:00:00
3341	18	INDIANÓPOLIS	2010-03-11 00:00:00
3342	18	IPIRANGA	2010-03-11 00:00:00
3343	18	IPORÃ	2010-03-11 00:00:00
3344	18	IRACEMA DO OESTE	2010-03-11 00:00:00
3345	18	IRATI	2010-03-11 00:00:00
3346	18	IRETAMA	2010-03-11 00:00:00
3347	18	ITAGUAJÉ	2010-03-11 00:00:00
3348	18	ITAIPULÂNDIA	2010-03-11 00:00:00
3349	18	ITAMBARACÁ	2010-03-11 00:00:00
3350	18	ITAMBÉ	2010-03-11 00:00:00
3351	18	ITAPEJARA D OESTE	2010-03-11 00:00:00
3352	18	ITAPERUÇU	2010-03-11 00:00:00
3353	18	ITAÚNA DO SUL	2010-03-11 00:00:00
3354	18	IVAÍ	2010-03-11 00:00:00
3355	18	IVAIPORÃ	2010-03-11 00:00:00
3356	18	IVATE	2010-03-11 00:00:00
3357	18	IVATUBA	2010-03-11 00:00:00
3358	18	JABOTI	2010-03-11 00:00:00
3359	18	JACAREZINHO	2010-03-11 00:00:00
3360	18	JAGUAPITÃ	2010-03-11 00:00:00
3361	18	JAGUARIAIVA	2010-03-11 00:00:00
3362	18	JANDAIA DO SUL	2010-03-11 00:00:00
3363	18	JANIÓPOLIS	2010-03-11 00:00:00
3364	18	JAPIRA	2010-03-11 00:00:00
3365	18	JAPURÁ	2010-03-11 00:00:00
3366	18	JARDIM ALEGRE	2010-03-11 00:00:00
3367	18	JARDIM OLINDA	2010-03-11 00:00:00
3368	18	JATAIZINHO	2010-03-11 00:00:00
3369	18	JESUÍTAS	2010-03-11 00:00:00
3370	18	JOAQUIM TÁVORA	2010-03-11 00:00:00
3371	18	JUNDIAÍ DO SUL	2010-03-11 00:00:00
3372	18	JURANDA	2010-03-11 00:00:00
3373	18	JUSSARA	2010-03-11 00:00:00
3374	18	KALORÉ	2010-03-11 00:00:00
3375	18	LAPA	2010-03-11 00:00:00
3376	18	LARANJAL	2010-03-11 00:00:00
3377	18	LARANJEIRAS DO SUL	2010-03-11 00:00:00
3378	18	LEÓPOLIS	2010-03-11 00:00:00
3379	18	LIDIANÓPOLIS	2010-03-11 00:00:00
3380	18	LINDOESTE	2010-03-11 00:00:00
3381	18	LOANDA	2010-03-11 00:00:00
3382	18	LOBATO	2010-03-11 00:00:00
3383	18	LONDRINA	2010-03-11 00:00:00
3384	18	LUIZIANA	2010-03-11 00:00:00
3385	18	LUNARDELLI	2010-03-11 00:00:00
3386	18	LUPIONÓPOLIS	2010-03-11 00:00:00
3387	18	MALLET	2010-03-11 00:00:00
3388	18	MAMBORÉ	2010-03-11 00:00:00
3389	18	MANDAGUAÇU	2010-03-11 00:00:00
3390	18	MANDAGUARI	2010-03-11 00:00:00
3391	18	MANDIRITUBA	2010-03-11 00:00:00
3392	18	MANFRINÓPOLIS	2010-03-11 00:00:00
3393	18	MANGUEIRINHA	2010-03-11 00:00:00
3394	18	MANOEL RIBAS	2010-03-11 00:00:00
3395	18	MARECHAL CÂNDIDO RONDON	2010-03-11 00:00:00
3396	18	MARIA HELENA	2010-03-11 00:00:00
3397	18	MARIALVA	2010-03-11 00:00:00
3398	18	MARILANDIA DO SUL	2010-03-11 00:00:00
3399	18	MARILENA	2010-03-11 00:00:00
3400	18	MARILUZ	2010-03-11 00:00:00
3401	18	MARINGÁ	2010-03-11 00:00:00
3402	18	MARIÓPOLIS	2010-03-11 00:00:00
3403	18	MARIPÁ	2010-03-11 00:00:00
3404	18	MARMELEIRO	2010-03-11 00:00:00
3405	18	MARQUINHO	2010-03-11 00:00:00
3406	18	MARUMBI	2010-03-11 00:00:00
3407	18	MATELÂNDIA	2010-03-11 00:00:00
3408	18	MATINHOS	2010-03-11 00:00:00
3409	18	MATO RICO	2010-03-11 00:00:00
3410	18	MAUÁ DA SERRA	2010-03-11 00:00:00
3411	18	MEDIANEIRA	2010-03-11 00:00:00
3412	18	MERCEDES	2010-03-11 00:00:00
3413	18	MIRADOR	2010-03-11 00:00:00
3414	18	MIRASELVA	2010-03-11 00:00:00
3415	18	MISSAL	2010-03-11 00:00:00
3416	18	MOREIRA SALES	2010-03-11 00:00:00
3417	18	MORRETES	2010-03-11 00:00:00
3418	18	MUNHOZ DE MELO	2010-03-11 00:00:00
3419	18	NOSSA SENHORA DAS GRAÇAS	2010-03-11 00:00:00
3420	18	NOVA ALIANÇA DO IVAÍ	2010-03-11 00:00:00
3421	18	NOVA AMÉRICA DA COLINA	2010-03-11 00:00:00
3422	18	NOVA AURORA	2010-03-11 00:00:00
3423	18	NOVA CANTU	2010-03-11 00:00:00
3424	18	NOVA ESPERANÇA	2010-03-11 00:00:00
3425	18	NOVA ESPERANÇA DO SUDOESTE	2010-03-11 00:00:00
3426	18	NOVA FÁTIMA	2010-03-11 00:00:00
3427	18	NOVA LARANJEIRAS	2010-03-11 00:00:00
3428	18	NOVA LONDRINA	2010-03-11 00:00:00
3429	18	NOVA OLÍMPIA	2010-03-11 00:00:00
3430	18	NOVA PRATA DO IGUAÇU	2010-03-11 00:00:00
3431	18	NOVA SANTA BÁRBARA	2010-03-11 00:00:00
3432	18	NOVA SANTA ROSA	2010-03-11 00:00:00
3433	18	NOVA TEBAS	2010-03-11 00:00:00
3434	18	NOVO ITACOLOMI	2010-03-11 00:00:00
3435	18	ORTIGUEIRA	2010-03-11 00:00:00
3436	18	OURIZONA	2010-03-11 00:00:00
3437	18	OURO VERDE DO OESTE	2010-03-11 00:00:00
3438	18	PAIÇANDU	2010-03-11 00:00:00
3439	18	PALMAS	2010-03-11 00:00:00
3440	18	PALMEIRA	2010-03-11 00:00:00
3441	18	PALMITAL	2010-03-11 00:00:00
3442	18	PALOTINA	2010-03-11 00:00:00
3443	18	PARAÍSO DO NORTE	2010-03-11 00:00:00
3444	18	PARANACITY	2010-03-11 00:00:00
3445	18	PARANAGUÁ	2010-03-11 00:00:00
3446	18	PARANAPOEMA	2010-03-11 00:00:00
3447	18	PARANAVAÍ	2010-03-11 00:00:00
3448	18	PATO BRAGADO	2010-03-11 00:00:00
3449	18	PATO BRANCO	2010-03-11 00:00:00
3450	18	PAULA FREITAS	2010-03-11 00:00:00
3451	18	PAULO FRONTIN	2010-03-11 00:00:00
3452	18	PEABIRU	2010-03-11 00:00:00
3453	18	PEROBAL	2010-03-11 00:00:00
3454	18	PÉROLA	2010-03-11 00:00:00
3455	18	PÉROLA D OESTE	2010-03-11 00:00:00
3456	18	PIEN	2010-03-11 00:00:00
3457	18	PINHAIS	2010-03-11 00:00:00
3458	18	PINHAL DE SÃO BENTO	2010-03-11 00:00:00
3459	18	PINHALÃO	2010-03-11 00:00:00
3460	18	PINHÃO	2010-03-11 00:00:00
3461	18	PIRAÍ DO SUL	2010-03-11 00:00:00
3462	18	PIRAQUARA	2010-03-11 00:00:00
3463	18	PITANGA	2010-03-11 00:00:00
3464	18	PITANGUEIRAS	2010-03-11 00:00:00
3465	18	PLANALTINA DO PARANÁ	2010-03-11 00:00:00
3466	18	PLANALTO	2010-03-11 00:00:00
3467	18	PONTA GROSSA	2010-03-11 00:00:00
3468	18	PONTAL DO PARANÁ	2010-03-11 00:00:00
3469	18	PORECATU	2010-03-11 00:00:00
3470	18	PORTO AMAZONAS	2010-03-11 00:00:00
3471	18	PORTO BARREIRO	2010-03-11 00:00:00
3472	18	PORTO RICO	2010-03-11 00:00:00
3473	18	PORTO VITÓRIA	2010-03-11 00:00:00
3474	18	PRADO FERREIRA	2010-03-11 00:00:00
3475	18	PRANCHITA	2010-03-11 00:00:00
3476	18	PRESIDENTE CASTELO BRANCO	2010-03-11 00:00:00
3477	18	PRIMEIRO DE MAIO	2010-03-11 00:00:00
3478	18	PRUDENTÓPOLIS	2010-03-11 00:00:00
3479	18	QUARTO CENTENÁRIO	2010-03-11 00:00:00
3480	18	QUATIGUÁ	2010-03-11 00:00:00
3481	18	QUATRO BARRAS	2010-03-11 00:00:00
3482	18	QUATRO PONTES	2010-03-11 00:00:00
3483	18	QUEDAS DO IGUAÇU	2010-03-11 00:00:00
3484	18	QUERÊNCIA DO NORTE	2010-03-11 00:00:00
3485	18	QUINTA DO SOL	2010-03-11 00:00:00
3486	18	QUITANDINHA	2010-03-11 00:00:00
3487	18	RAMILÂNDIA	2010-03-11 00:00:00
3488	18	RANCHO ALEGRE	2010-03-11 00:00:00
3489	18	RANCHO ALEGRE D OESTE	2010-03-11 00:00:00
3490	18	REALEZA	2010-03-11 00:00:00
3491	18	REBOUÇAS	2010-03-11 00:00:00
3492	18	RENASCENÇA	2010-03-11 00:00:00
3493	18	RESERVA	2010-03-11 00:00:00
3494	18	RESERVA DO IGUAÇU	2010-03-11 00:00:00
3495	18	RIBEIRÃO CLARO	2010-03-11 00:00:00
3496	18	RIBEIRÃO DO PINHAL	2010-03-11 00:00:00
3497	18	RIO AZUL	2010-03-11 00:00:00
3498	18	RIO BOM	2010-03-11 00:00:00
3499	18	RIO BONITO DO IGUAÇU	2010-03-11 00:00:00
3500	18	RIO BRANCO DO IVAÍ	2010-03-11 00:00:00
3501	18	RIO BRANCO DO SUL	2010-03-11 00:00:00
3502	18	RIO NEGRO	2010-03-11 00:00:00
3503	18	ROLÂNDIA	2010-03-11 00:00:00
3504	18	RONCADOR	2010-03-11 00:00:00
3505	18	RONDON	2010-03-11 00:00:00
3506	18	ROSÁRIO DO IVAÍ	2010-03-11 00:00:00
3507	18	SABAUDIA	2010-03-11 00:00:00
3508	18	SALGADO FILHO	2010-03-11 00:00:00
3509	18	SALTO DO ITARARÉ	2010-03-11 00:00:00
3510	18	SALTO DO LONTRA	2010-03-11 00:00:00
3511	18	SANTA AMÉLIA	2010-03-11 00:00:00
3512	18	SANTA CECÍLIA DO PAVÃO	2010-03-11 00:00:00
3513	18	SANTA CRUZ DE MONTE CASTELO	2010-03-11 00:00:00
3514	18	SANTA FÉ	2010-03-11 00:00:00
3515	18	SANTA HELENA	2010-03-11 00:00:00
3516	18	SANTA INÊS	2010-03-11 00:00:00
3517	18	SANTA ISABEL DO IVAÍ	2010-03-11 00:00:00
3518	18	SANTA IZABEL DO OESTE	2010-03-11 00:00:00
3519	18	SANTA LÚCIA	2010-03-11 00:00:00
3520	18	SANTA MARIA DO OESTE	2010-03-11 00:00:00
3521	18	SANTA MARIANA	2010-03-11 00:00:00
3522	18	SANTA MÔNICA	2010-03-11 00:00:00
3523	18	SANTA TEREZA DO OESTE	2010-03-11 00:00:00
3524	18	SANTA TEREZINHA DE ITAIPU	2010-03-11 00:00:00
3525	18	SANTANA DO ITARARÉ	2010-03-11 00:00:00
3526	18	SANTO ANTÔNIO DA PLATINA	2010-03-11 00:00:00
3527	18	SANTO ANTÔNIO DO CAIUÁ	2010-03-11 00:00:00
3528	18	SANTO ANTÔNIO DO PARAÍSO	2010-03-11 00:00:00
3529	18	SANTO ANTÔNIO DO SUDOESTE	2010-03-11 00:00:00
3530	18	SANTO INÁCIO	2010-03-11 00:00:00
3531	18	SÃO CARLOS DO IVAÍ	2010-03-11 00:00:00
3532	18	SÃO JERÔNIMO DA SERRA	2010-03-11 00:00:00
3533	18	SÃO JOÃO	2010-03-11 00:00:00
3534	18	SÃO JOÃO DO CAIUÁ	2010-03-11 00:00:00
3535	18	SÃO JOÃO DO IVAÍ	2010-03-11 00:00:00
3536	18	SÃO JOÃO DO TRIUNFO	2010-03-11 00:00:00
3537	18	SÃO JORGE D OESTE	2010-03-11 00:00:00
3538	18	SÃO JORGE DO IVAÍ	2010-03-11 00:00:00
3539	18	SÃO JORGE DO PATROCÍNIO	2010-03-11 00:00:00
3540	18	SÃO JOSÉ DA BOA VISTA	2010-03-11 00:00:00
3541	18	SÃO JOSÉ DAS PALMEIRAS	2010-03-11 00:00:00
3542	18	SÃO JOSÉ DOS PINHAIS	2010-03-11 00:00:00
3543	18	SÃO MANOEL DO PARANÁ	2010-03-11 00:00:00
3544	18	SÃO MATEUS DO SUL	2010-03-11 00:00:00
3545	18	SÃO MIGUEL DO IGUAÇU	2010-03-11 00:00:00
3546	18	SÃO PEDRO DO IGUAÇU	2010-03-11 00:00:00
3547	18	SÃO PEDRO DO IVAÍ	2010-03-11 00:00:00
3548	18	SÃO PEDRO DO PARANÁ	2010-03-11 00:00:00
3549	18	SÃO SEBASTIÃO DA AMOREIRA	2010-03-11 00:00:00
3550	18	SÃO TOMÉ	2010-03-11 00:00:00
3551	18	SAPOPEMA	2010-03-11 00:00:00
3552	18	SARANDI	2010-03-11 00:00:00
3553	18	SAUDADE DO IGUAÇU	2010-03-11 00:00:00
3554	18	SENGES	2010-03-11 00:00:00
3555	18	SERRANÓPOLIS DO IGUAÇU	2010-03-11 00:00:00
3556	18	SERRO AZUL	2010-03-11 00:00:00
3557	18	SERTANEJA	2010-03-11 00:00:00
3558	18	SERTANÓPOLIS	2010-03-11 00:00:00
3559	18	SIQUEIRA CAMPOS	2010-03-11 00:00:00
3560	18	SULINA	2010-03-11 00:00:00
3561	18	TAMARANA	2010-03-11 00:00:00
3562	18	TAMBOARA	2010-03-11 00:00:00
3563	18	TAPEJARA	2010-03-11 00:00:00
3564	18	TAPIRA	2010-03-11 00:00:00
3565	18	TEIXEIRA SOARES	2010-03-11 00:00:00
3566	18	TELÊMACO BORBA	2010-03-11 00:00:00
3567	18	TERRA BOA	2010-03-11 00:00:00
3568	18	TERRA RICA	2010-03-11 00:00:00
3569	18	TERRA ROXA	2010-03-11 00:00:00
3570	18	TIBAGI	2010-03-11 00:00:00
3571	18	TIJUCAS DO SUL	2010-03-11 00:00:00
3572	18	TOLEDO	2010-03-11 00:00:00
3573	18	TOMAZINA	2010-03-11 00:00:00
3574	18	TRÊS BARRAS DO PARANÁ	2010-03-11 00:00:00
3575	18	TUNAS DO PARANÁ	2010-03-11 00:00:00
3576	18	TUNEIRAS DO OESTE	2010-03-11 00:00:00
3577	18	TUPÃSSI	2010-03-11 00:00:00
3578	18	TURVO	2010-03-11 00:00:00
3579	18	UBIRATÃ	2010-03-11 00:00:00
3580	18	UMUARAMA	2010-03-11 00:00:00
3581	18	UNIÃO DA VITÓRIA	2010-03-11 00:00:00
3582	18	UNIFLOR	2010-03-11 00:00:00
3583	18	URAÍ	2010-03-11 00:00:00
3584	18	VENTANIA	2010-03-11 00:00:00
3585	18	VERA CRUZ DO OESTE	2010-03-11 00:00:00
3586	18	VERE	2010-03-11 00:00:00
3587	18	VIRMOND	2010-03-11 00:00:00
3588	18	VITORINO	2010-03-11 00:00:00
3589	18	WENCESLAU BRAZ	2010-03-11 00:00:00
3590	18	XAMBRE	2010-03-11 00:00:00
3591	19	ANGRA DOS REIS	2010-03-11 00:00:00
3592	19	APERIBÉ	2010-03-11 00:00:00
3593	19	ARARUAMA	2010-03-11 00:00:00
3594	19	AREAL	2010-03-11 00:00:00
3595	19	ARMAÇÃO DE BÚZIOS	2010-03-11 00:00:00
3596	19	ARRAIAL DO CABO	2010-03-11 00:00:00
3597	19	BARRA DO PIRAÍ	2010-03-11 00:00:00
3598	19	BARRA MANSA	2010-03-11 00:00:00
3599	19	BELFORD ROXO	2010-03-11 00:00:00
3600	19	BOM JARDIM	2010-03-11 00:00:00
3601	19	BOM JESUS DO ITABAPOANA	2010-03-11 00:00:00
3602	19	CABO FRIO	2010-03-11 00:00:00
3603	19	CACHOEIRAS DE MACACU	2010-03-11 00:00:00
3604	19	CAMBUCI	2010-03-11 00:00:00
3605	19	CAMPOS DOS GOYTACAZES	2010-03-11 00:00:00
3606	19	CANTAGALO	2010-03-11 00:00:00
3607	19	CARAPEBUS	2010-03-11 00:00:00
3608	19	CARDOSO MOREIRA	2010-03-11 00:00:00
3609	19	CARMO	2010-03-11 00:00:00
3610	19	CASIMIRO DE ABREU	2010-03-11 00:00:00
3611	19	COMENDADOR LEVY GASPARIAN	2010-03-11 00:00:00
3612	19	CONCEIÇÃO DE MACABU	2010-03-11 00:00:00
3613	19	CORDEIRO	2010-03-11 00:00:00
3614	19	DUAS BARRAS	2010-03-11 00:00:00
3615	19	DUQUE DE CAXIAS	2010-03-11 00:00:00
3616	19	ENGENHEIRO PAULO DE FRONTIN	2010-03-11 00:00:00
3617	19	GUAPIMIRIM	2010-03-11 00:00:00
3618	19	IGUABA GRANDE	2010-03-11 00:00:00
3619	19	ITABORAÍ	2010-03-11 00:00:00
3620	19	ITAGUAÍ	2010-03-11 00:00:00
3621	19	ITALVA	2010-03-11 00:00:00
3622	19	ITAOCARA	2010-03-11 00:00:00
3623	19	ITAPERUNA	2010-03-11 00:00:00
3624	19	ITATIAIA	2010-03-11 00:00:00
3625	19	JAPERI	2010-03-11 00:00:00
3626	19	LAJE DO MURIAÉ	2010-03-11 00:00:00
3627	19	MACAÉ	2010-03-11 00:00:00
3628	19	MACUCO	2010-03-11 00:00:00
3629	19	MAGÉ	2010-03-11 00:00:00
3630	19	MANGARATIBA	2010-03-11 00:00:00
3631	19	MARICÁ	2010-03-11 00:00:00
3632	19	MENDES	2010-03-11 00:00:00
3633	19	MESQUITA	2010-03-11 00:00:00
3634	19	MIGUEL PEREIRA	2010-03-11 00:00:00
3635	19	MIRACEMA	2010-03-11 00:00:00
3636	19	NATIVIDADE	2010-03-11 00:00:00
3637	19	NILÓPOLIS	2010-03-11 00:00:00
3638	19	NITERÓI	2010-03-11 00:00:00
3639	19	NOVA FRIBURGO	2010-03-11 00:00:00
3640	19	NOVA IGUAÇU	2010-03-11 00:00:00
3641	19	PARACAMBI	2010-03-11 00:00:00
3642	19	PARAÍBA DO SUL	2010-03-11 00:00:00
3643	19	PARATI	2010-03-11 00:00:00
3644	19	PATY DO ALFERES	2010-03-11 00:00:00
3645	19	PETRÓPOLIS	2010-03-11 00:00:00
3646	19	PINHEIRAL	2010-03-11 00:00:00
3647	19	PIRAÍ	2010-03-11 00:00:00
3648	19	PORCIÚNCULA	2010-03-11 00:00:00
3649	19	PORTO REAL	2010-03-11 00:00:00
3650	19	QUATIS	2010-03-11 00:00:00
3651	19	QUEIMADOS	2010-03-11 00:00:00
3652	19	QUISSAMÃ	2010-03-11 00:00:00
3653	19	RESENDE	2010-03-11 00:00:00
3654	19	RIO BONITO	2010-03-11 00:00:00
3655	19	RIO CLARO	2010-03-11 00:00:00
3656	19	RIO DAS FLORES	2010-03-11 00:00:00
3657	19	RIO DAS OSTRAS	2010-03-11 00:00:00
3658	19	RIO DE JANEIRO	2010-03-11 00:00:00
3659	19	SANTA MARIA MADALENA	2010-03-11 00:00:00
3660	19	SANTO ANTÔNIO DE PÁDUA	2010-03-11 00:00:00
3661	19	SÃO FIDÉLIS	2010-03-11 00:00:00
3662	19	SÃO FRANCISCO DE ITABAPOANA	2010-03-11 00:00:00
3663	19	SÃO GONÇALO	2010-03-11 00:00:00
3664	19	SÃO JOÃO DA BARRA	2010-03-11 00:00:00
3665	19	SÃO JOÃO DE MERITI	2010-03-11 00:00:00
3666	19	SÃO JOSÉ DE UBÁ	2010-03-11 00:00:00
3667	19	SÃO JOSÉ DO VALE DO RIO PRETO	2010-03-11 00:00:00
3668	19	SÃO PEDRO DA ALDEIA	2010-03-11 00:00:00
3669	19	SÃO SEBASTIÃO DO ALTO	2010-03-11 00:00:00
3670	19	SAPUCAIA	2010-03-11 00:00:00
3671	19	SAQUAREMA	2010-03-11 00:00:00
3672	19	SEROPÉDICA	2010-03-11 00:00:00
3673	19	SILVA JARDIM	2010-03-11 00:00:00
3674	19	SUMIDOURO	2010-03-11 00:00:00
3675	19	TANGUÁ	2010-03-11 00:00:00
3676	19	TERESÓPOLIS	2010-03-11 00:00:00
3677	19	TRAJANO DE MORAIS	2010-03-11 00:00:00
3678	19	TRÊS RIOS	2010-03-11 00:00:00
3679	19	VALENÇA	2010-03-11 00:00:00
3680	19	VARRE E SAI	2010-03-11 00:00:00
3681	19	VASSOURAS	2010-03-11 00:00:00
3682	19	VOLTA REDONDA	2010-03-11 00:00:00
3683	20	ACARI	2010-03-11 00:00:00
3684	20	AÇU	2010-03-11 00:00:00
3685	20	AFONSO BEZERRA	2010-03-11 00:00:00
3686	20	ÁGUA NOVA	2010-03-11 00:00:00
3687	20	ALEXANDRIA	2010-03-11 00:00:00
3688	20	ALMINO AFONSO	2010-03-11 00:00:00
3689	20	ALTO DOS RODRIGUES	2010-03-11 00:00:00
3690	20	ANGICOS	2010-03-11 00:00:00
3691	20	ANTÔNIO MARTINS	2010-03-11 00:00:00
3692	20	APODI	2010-03-11 00:00:00
3693	20	AREIA BRANCA	2010-03-11 00:00:00
3694	20	ARES	2010-03-11 00:00:00
3695	20	AUGUSTO SEVERO	2010-03-11 00:00:00
3696	20	BAÍA FORMOSA	2010-03-11 00:00:00
3697	20	BARAÚNA	2010-03-11 00:00:00
3698	20	BARCELONA	2010-03-11 00:00:00
3699	20	BENTO FERNANDES	2010-03-11 00:00:00
3700	20	BODÓ	2010-03-11 00:00:00
3701	20	BOM JESUS	2010-03-11 00:00:00
3702	20	BREJINHO	2010-03-11 00:00:00
3703	20	CAIÇARA DO NORTE	2010-03-11 00:00:00
3704	20	CAIÇARA DO RIO DO VENTO	2010-03-11 00:00:00
3705	20	CAICÓ	2010-03-11 00:00:00
3706	20	CAMPO REDONDO	2010-03-11 00:00:00
3707	20	CANGUARETAMA	2010-03-11 00:00:00
3708	20	CARAÚBAS	2010-03-11 00:00:00
3709	20	CARNAÚBA DOS DANTAS	2010-03-11 00:00:00
3710	20	CARNAUBAIS	2010-03-11 00:00:00
3711	20	CEARÁ-MIRIM	2010-03-11 00:00:00
3712	20	CERRO CORÁ	2010-03-11 00:00:00
3713	20	CORONEL EZEQUIEL	2010-03-11 00:00:00
3714	20	CORONEL JOÃO PESSOA	2010-03-11 00:00:00
3715	20	CRUZETA	2010-03-11 00:00:00
3716	20	CURRAIS NOVOS	2010-03-11 00:00:00
3717	20	DOUTOR SEVERIANO	2010-03-11 00:00:00
3718	20	ENCANTO	2010-03-11 00:00:00
3719	20	EQUADOR	2010-03-11 00:00:00
3720	20	ESPÍRITO SANTO	2010-03-11 00:00:00
3721	20	EXTREMOZ	2010-03-11 00:00:00
3722	20	FELIPE GUERRA	2010-03-11 00:00:00
3723	20	FERNANDO PEDROZA	2010-03-11 00:00:00
3724	20	FLORÂNIA	2010-03-11 00:00:00
3725	20	FRANCISCO DANTAS	2010-03-11 00:00:00
3726	20	FRUTUOSO GOMES	2010-03-11 00:00:00
3727	20	GALINHOS	2010-03-11 00:00:00
3728	20	GOIANINHA	2010-03-11 00:00:00
3729	20	GOVERNADOR DIX-SEPT ROSADO	2010-03-11 00:00:00
3730	20	GROSSOS	2010-03-11 00:00:00
3731	20	GUAMARE	2010-03-11 00:00:00
3732	20	IELMO MARINHO	2010-03-11 00:00:00
3733	20	IPANGUAÇU	2010-03-11 00:00:00
3734	20	IPUEIRA	2010-03-11 00:00:00
3735	20	ITAJÁ	2010-03-11 00:00:00
3736	20	ITAÚ	2010-03-11 00:00:00
3737	20	JAÇANÃ	2010-03-11 00:00:00
3738	20	JANDAÍRA	2010-03-11 00:00:00
3739	20	JANDUÍS	2010-03-11 00:00:00
3740	20	JANUÁRIO CICCO	2010-03-11 00:00:00
3741	20	JAPI	2010-03-11 00:00:00
3742	20	JARDIM DE ANGICOS	2010-03-11 00:00:00
3743	20	JARDIM DE PIRANHAS	2010-03-11 00:00:00
3744	20	JARDIM DO SERIDÓ	2010-03-11 00:00:00
3745	20	JOÃO CÂMARA	2010-03-11 00:00:00
3746	20	JOÃO DIAS	2010-03-11 00:00:00
3747	20	JOSÉ DA PENHA	2010-03-11 00:00:00
3748	20	JUCURUTU	2010-03-11 00:00:00
3749	20	JUNDIÁ	2010-03-11 00:00:00
3750	20	LAGOA D ANTA	2010-03-11 00:00:00
3751	20	LAGOA DE PEDRAS	2010-03-11 00:00:00
3752	20	LAGOA DE VELHOS	2010-03-11 00:00:00
3753	20	LAGOA NOVA	2010-03-11 00:00:00
3754	20	LAGOA SALGADA	2010-03-11 00:00:00
3755	20	LAJES	2010-03-11 00:00:00
3756	20	LAJES PINTADAS	2010-03-11 00:00:00
3757	20	LUCRÉCIA	2010-03-11 00:00:00
3758	20	LUIS GOMES	2010-03-11 00:00:00
3759	20	MACAIBA	2010-03-11 00:00:00
3760	20	MACAU	2010-03-11 00:00:00
3761	20	MAJOR SALES	2010-03-11 00:00:00
3762	20	MARCELINO VIEIRA	2010-03-11 00:00:00
3763	20	MARTINS	2010-03-11 00:00:00
3764	20	MAXARANGUAPE	2010-03-11 00:00:00
3765	20	MESSIAS TARGINO	2010-03-11 00:00:00
3766	20	MONTANHAS	2010-03-11 00:00:00
3767	20	MONTE ALEGRE	2010-03-11 00:00:00
3768	20	MONTE DAS GAMELEIRAS	2010-03-11 00:00:00
3769	20	MOSSORÓ	2010-03-11 00:00:00
3770	20	NATAL	2010-03-11 00:00:00
3771	20	NISIA FLORESTA	2010-03-11 00:00:00
3772	20	NOVA CRUZ	2010-03-11 00:00:00
3773	20	OLHO D ÁGUA DO BORGES	2010-03-11 00:00:00
3774	20	OURO BRANCO	2010-03-11 00:00:00
3775	20	PARANÁ	2010-03-11 00:00:00
3776	20	PARAU	2010-03-11 00:00:00
3777	20	PARAZINHO	2010-03-11 00:00:00
3778	20	PARELHAS	2010-03-11 00:00:00
3779	20	PARNAMIRIM	2010-03-11 00:00:00
3780	20	PASSA E FICA	2010-03-11 00:00:00
3781	20	PASSAGEM	2010-03-11 00:00:00
3782	20	PATU	2010-03-11 00:00:00
3783	20	PAU DOS FERROS	2010-03-11 00:00:00
3784	20	PEDRA GRANDE	2010-03-11 00:00:00
3785	20	PEDRA PRETA	2010-03-11 00:00:00
3786	20	PEDRO AVELINO	2010-03-11 00:00:00
3787	20	PEDRO VELHO	2010-03-11 00:00:00
3788	20	PENDÊNCIAS	2010-03-11 00:00:00
3789	20	PILÕES	2010-03-11 00:00:00
3790	20	POÇO BRANCO	2010-03-11 00:00:00
3791	20	PORTALEGRE	2010-03-11 00:00:00
3792	20	PORTO DO MANGUE	2010-03-11 00:00:00
3793	20	PRESIDENTE JUSCELINO	2010-03-11 00:00:00
3794	20	PUREZA	2010-03-11 00:00:00
3795	20	RAFAEL FERNANDES	2010-03-11 00:00:00
3796	20	RAFAEL GODEIRO	2010-03-11 00:00:00
3797	20	RIACHO DA CRUZ	2010-03-11 00:00:00
3798	20	RIACHO DE SANTANA	2010-03-11 00:00:00
3799	20	RIACHUELO	2010-03-11 00:00:00
3800	20	RIO DO FOGO	2010-03-11 00:00:00
3801	20	RODOLFO FERNANDES	2010-03-11 00:00:00
3802	20	RUY BARBOSA	2010-03-11 00:00:00
3803	20	SANTA CRUZ	2010-03-11 00:00:00
3804	20	SANTA MARIA	2010-03-11 00:00:00
3805	20	SANTANA DO MATOS	2010-03-11 00:00:00
3806	20	SANTANA DO SERIDÓ	2010-03-11 00:00:00
3807	20	SANTO ANTÔNIO	2010-03-11 00:00:00
3808	20	SÃO BENTO DO NORTE	2010-03-11 00:00:00
3809	20	SÃO BENTO DO TRAIRI	2010-03-11 00:00:00
3810	20	SÃO FERNANDO	2010-03-11 00:00:00
3811	20	SÃO FRANCISCO DO OESTE	2010-03-11 00:00:00
3812	20	SÃO GONÇALO DO AMARANTE	2010-03-11 00:00:00
3813	20	SÃO JOÃO DO SABUGI	2010-03-11 00:00:00
3814	20	SÃO JOSÉ DE MIPIBU	2010-03-11 00:00:00
3815	20	SÃO JOSÉ DO CAMPESTRE	2010-03-11 00:00:00
3816	20	SÃO JOSÉ DO SERIDÓ	2010-03-11 00:00:00
3817	20	SÃO MIGUEL	2010-03-11 00:00:00
3818	20	SÃO MIGUEL DO GOSTOSO	2010-03-11 00:00:00
3819	20	SÃO PAULO DO POTENGI	2010-03-11 00:00:00
3820	20	SÃO PEDRO	2010-03-11 00:00:00
3821	20	SÃO RAFAEL	2010-03-11 00:00:00
3822	20	SÃO TOMÉ	2010-03-11 00:00:00
3823	20	SÃO VICENTE	2010-03-11 00:00:00
3824	20	SENADOR ELÓI DE SOUZA	2010-03-11 00:00:00
3825	20	SENADOR GEORGINO AVELINO	2010-03-11 00:00:00
3826	20	SERRA DE SÃO BENTO	2010-03-11 00:00:00
3827	20	SERRA DO MEL	2010-03-11 00:00:00
3828	20	SERRA NEGRA DO NORTE	2010-03-11 00:00:00
3829	20	SERRINHA	2010-03-11 00:00:00
3830	20	SERRINHA DOS PINTOS	2010-03-11 00:00:00
3831	20	SEVERIANO MELO	2010-03-11 00:00:00
3832	20	SÍTIO NOVO	2010-03-11 00:00:00
3833	20	TABOLEIRO GRANDE	2010-03-11 00:00:00
3834	20	TAIPU	2010-03-11 00:00:00
3835	20	TANGARÁ	2010-03-11 00:00:00
3836	20	TENENTE ANANIAS	2010-03-11 00:00:00
3837	20	TENENTE LAURENTINO CRUZ	2010-03-11 00:00:00
3838	20	TIBAU	2010-03-11 00:00:00
3839	20	TIBAU DO SUL	2010-03-11 00:00:00
3840	20	TIMBAÚBA DOS BATISTAS	2010-03-11 00:00:00
3841	20	TOUROS	2010-03-11 00:00:00
3842	20	TRIUNFO POTIGUAR	2010-03-11 00:00:00
3843	20	UMARIZAL	2010-03-11 00:00:00
3844	20	UPANEMA	2010-03-11 00:00:00
3845	20	VÁRZEA	2010-03-11 00:00:00
3846	20	VENHA-VER	2010-03-11 00:00:00
3847	20	VERA CRUZ	2010-03-11 00:00:00
3848	20	VIÇOSA	2010-03-11 00:00:00
3849	20	VILA FLOR	2010-03-11 00:00:00
3850	21	ALTA FLORESTA D OESTE	2010-03-11 00:00:00
3851	21	ALTO ALEGRE DOS PARECIS	2010-03-11 00:00:00
3852	21	ALTO PARAÍSO	2010-03-11 00:00:00
3853	21	ALVORADA D OESTE	2010-03-11 00:00:00
3854	21	ARIQUEMES	2010-03-11 00:00:00
3855	21	BURITIS	2010-03-11 00:00:00
3856	21	CABIXI	2010-03-11 00:00:00
3857	21	CACAULÂNDIA	2010-03-11 00:00:00
3858	21	CACOAL	2010-03-11 00:00:00
3859	21	CAMPO NOVO DE RONDÔNIA	2010-03-11 00:00:00
3860	21	CANDEIAS DO JAMARI	2010-03-11 00:00:00
3861	21	CASTANHEIRAS	2010-03-11 00:00:00
3862	21	CEREJEIRAS	2010-03-11 00:00:00
3863	21	CHUPINGUAIA	2010-03-11 00:00:00
3864	21	COLORADO DO OESTE	2010-03-11 00:00:00
3865	21	CORUMBIARA	2010-03-11 00:00:00
3866	21	COSTA MARQUES	2010-03-11 00:00:00
3867	21	CUJUBIM	2010-03-11 00:00:00
3868	21	ESPIGÃO D OESTE	2010-03-11 00:00:00
3869	21	GOVERNADOR JORGE TEIXEIRA	2010-03-11 00:00:00
3870	21	GUAJARÁ-MIRIM	2010-03-11 00:00:00
3871	21	ITAPUÃ DO OESTE	2010-03-11 00:00:00
3872	21	JARU	2010-03-11 00:00:00
3873	21	JI-PARANÁ	2010-03-11 00:00:00
3874	21	MACHADINHO D OESTE	2010-03-11 00:00:00
3875	21	MINISTRO ANDREAZZA	2010-03-11 00:00:00
3876	21	MIRANTE DA SERRA	2010-03-11 00:00:00
3877	21	MONTE NEGRO	2010-03-11 00:00:00
3878	21	NOVA BRASILÂNDIA D OESTE	2010-03-11 00:00:00
3879	21	NOVA MAMORÉ	2010-03-11 00:00:00
3880	21	NOVA UNIÃO	2010-03-11 00:00:00
3881	21	NOVO HORIZONTE D OESTE	2010-03-11 00:00:00
3882	21	OURO PRETO DO OESTE	2010-03-11 00:00:00
3883	21	PARECIS	2010-03-11 00:00:00
3884	21	PIMENTA BUENO	2010-03-11 00:00:00
3885	21	PIMENTEIRAS DO OESTE	2010-03-11 00:00:00
3886	21	PORTO VELHO	2010-03-11 00:00:00
3887	21	PRESIDENTE MÉDICI	2010-03-11 00:00:00
3888	21	PRIMAVERA DE RONDÔNIA	2010-03-11 00:00:00
3889	21	RIO CRESPO	2010-03-11 00:00:00
3890	21	ROLIM DE MOURA	2010-03-11 00:00:00
3891	21	SANTA LUZIA D OESTE	2010-03-11 00:00:00
3892	21	SÃO FELIPE D OESTE	2010-03-11 00:00:00
3893	21	SÃO FRANCISCO DO GUAPORÉ	2010-03-11 00:00:00
3894	21	SÃO MIGUEL DO GUAPORÉ	2010-03-11 00:00:00
3895	21	SERINGUEIRAS	2010-03-11 00:00:00
3896	21	TEIXEIRÓPOLIS	2010-03-11 00:00:00
3897	21	THEOBROMA	2010-03-11 00:00:00
3898	21	URUPA	2010-03-11 00:00:00
3899	21	VALE DO ANARI	2010-03-11 00:00:00
3900	21	VALE DO PARAÍSO	2010-03-11 00:00:00
3901	21	VILHENA	2010-03-11 00:00:00
3902	22	ALTO ALEGRE	2010-03-11 00:00:00
3903	22	AMAJARI	2010-03-11 00:00:00
3904	22	BOA VISTA	2010-03-11 00:00:00
3905	22	BONFIM	2010-03-11 00:00:00
3906	22	CANTA	2010-03-11 00:00:00
3907	22	CARACARAÍ	2010-03-11 00:00:00
3908	22	CAROEBE	2010-03-11 00:00:00
3909	22	IRACEMA	2010-03-11 00:00:00
3910	22	MUCAJAI	2010-03-11 00:00:00
3911	22	NORMÂNDIA	2010-03-11 00:00:00
3912	22	PACARAIMA	2010-03-11 00:00:00
3913	22	RORAINÓPOLIS	2010-03-11 00:00:00
3914	22	SÃO JOÃO DA BALIZA	2010-03-11 00:00:00
3915	22	SÃO LUIZ	2010-03-11 00:00:00
3916	22	UIRAMUTÃ	2010-03-11 00:00:00
3917	23	ACEGUÁ	2010-03-11 00:00:00
3918	23	ÁGUA SANTA	2010-03-11 00:00:00
3919	23	AGUDO	2010-03-11 00:00:00
3920	23	AJURICABA	2010-03-11 00:00:00
3921	23	ALECRIM	2010-03-11 00:00:00
3922	23	ALEGRETE	2010-03-11 00:00:00
3923	23	ALEGRIA	2010-03-11 00:00:00
3924	23	ALMIRANTE TAMANDARÉ DO SUL	2010-03-11 00:00:00
3925	23	ALPESTRE	2010-03-11 00:00:00
3926	23	ALTO ALEGRE	2010-03-11 00:00:00
3927	23	ALTO FELIZ	2010-03-11 00:00:00
3928	23	ALVORADA	2010-03-11 00:00:00
3929	23	AMARAL FERRADOR	2010-03-11 00:00:00
3930	23	AMETISTA DO SUL	2010-03-11 00:00:00
3931	23	ANDRÉ DA ROCHA	2010-03-11 00:00:00
3932	23	ANTA GORDA	2010-03-11 00:00:00
3933	23	ANTÔNIO PRADO	2010-03-11 00:00:00
3934	23	ARAMBARÉ	2010-03-11 00:00:00
3935	23	ARARICÁ	2010-03-11 00:00:00
3936	23	ARATIBA	2010-03-11 00:00:00
3937	23	ARROIO DO MEIO	2010-03-11 00:00:00
3938	23	ARROIO DO PADRE	2010-03-11 00:00:00
3939	23	ARROIO DO SAL	2010-03-11 00:00:00
3940	23	ARROIO DO TIGRE	2010-03-11 00:00:00
3941	23	ARROIO DOS RATOS	2010-03-11 00:00:00
3942	23	ARROIO GRANDE	2010-03-11 00:00:00
3943	23	ARVOREZINHA	2010-03-11 00:00:00
3944	23	AUGUSTO PESTANA	2010-03-11 00:00:00
3945	23	ÁUREA	2010-03-11 00:00:00
3946	23	BAGÉ	2010-03-11 00:00:00
3947	23	BALNEÁRIO PINHAL	2010-03-11 00:00:00
3948	23	BARÃO	2010-03-11 00:00:00
3949	23	BARÃO DE COTEGIPE	2010-03-11 00:00:00
3950	23	BARÃO DO TRIUNFO	2010-03-11 00:00:00
3951	23	BARRA DO GUARITA	2010-03-11 00:00:00
3952	23	BARRA DO QUARAÍ	2010-03-11 00:00:00
3953	23	BARRA DO RIBEIRO	2010-03-11 00:00:00
3954	23	BARRA DO RIO AZUL	2010-03-11 00:00:00
3955	23	BARRA FUNDA	2010-03-11 00:00:00
3956	23	BARRACÃO	2010-03-11 00:00:00
3957	23	BARROS CASSAL	2010-03-11 00:00:00
3958	23	BENJAMIN CONSTANT DO SUL	2010-03-11 00:00:00
3959	23	BENTO GONÇALVES	2010-03-11 00:00:00
3960	23	BOA VISTA DAS MISSÕES	2010-03-11 00:00:00
3961	23	BOA VISTA DO BURICÁ	2010-03-11 00:00:00
3962	23	BOA VISTA DO CADEADO	2010-03-11 00:00:00
3963	23	BOA VISTA DO INCRA	2010-03-11 00:00:00
3964	23	BOA VISTA DO SUL	2010-03-11 00:00:00
3965	23	BOM JESUS	2010-03-11 00:00:00
3966	23	BOM PRINCÍPIO	2010-03-11 00:00:00
3967	23	BOM PROGRESSO	2010-03-11 00:00:00
3968	23	BOM RETIRO DO SUL	2010-03-11 00:00:00
3969	23	BOQUEIRÃO DO LEÃO	2010-03-11 00:00:00
3970	23	BOSSOROCA	2010-03-11 00:00:00
3971	23	BOZANO	2010-03-11 00:00:00
3972	23	BRAGA	2010-03-11 00:00:00
3973	23	BROCHIER	2010-03-11 00:00:00
3974	23	BUTIÁ	2010-03-11 00:00:00
3975	23	CAÇAPAVA DO SUL	2010-03-11 00:00:00
3976	23	CACEQUI	2010-03-11 00:00:00
3977	23	CACHOEIRA DO SUL	2010-03-11 00:00:00
3978	23	CACHOEIRINHA	2010-03-11 00:00:00
3979	23	CACIQUE DOBLE	2010-03-11 00:00:00
3980	23	CAIBATÉ	2010-03-11 00:00:00
3981	23	CAIÇARA	2010-03-11 00:00:00
3982	23	CAMAQUÃ	2010-03-11 00:00:00
3983	23	CAMARGO	2010-03-11 00:00:00
3984	23	CAMBARÁ DO SUL	2010-03-11 00:00:00
3985	23	CAMPESTRE DA SERRA	2010-03-11 00:00:00
3986	23	CAMPINA DAS MISSÕES	2010-03-11 00:00:00
3987	23	CAMPINAS DO SUL	2010-03-11 00:00:00
3988	23	CAMPO BOM	2010-03-11 00:00:00
3989	23	CAMPO NOVO	2010-03-11 00:00:00
3990	23	CAMPOS BORGES	2010-03-11 00:00:00
3991	23	CANDELÁRIA	2010-03-11 00:00:00
3992	23	CÂNDIDO GODÓI	2010-03-11 00:00:00
3993	23	CANDIOTA	2010-03-11 00:00:00
3994	23	CANELA	2010-03-11 00:00:00
3995	23	CANGUÇU	2010-03-11 00:00:00
3996	23	CANOAS	2010-03-11 00:00:00
3997	23	CANUDOS DO VALE	2010-03-11 00:00:00
3998	23	CAPÃO BONITO DO SUL	2010-03-11 00:00:00
3999	23	CAPÃO DA CANOA	2010-03-11 00:00:00
4000	23	CAPÃO DO CIPÓ	2010-03-11 00:00:00
4001	23	CAPÃO DO LEÃO	2010-03-11 00:00:00
4002	23	CAPELA DE SANTANA	2010-03-11 00:00:00
4003	23	CAPITÃO	2010-03-11 00:00:00
4004	23	CAPIVARI DO SUL	2010-03-11 00:00:00
4005	23	CARAÁ	2010-03-11 00:00:00
4006	23	CARAZINHO	2010-03-11 00:00:00
4007	23	CARLOS BARBOSA	2010-03-11 00:00:00
4008	23	CARLOS GOMES	2010-03-11 00:00:00
4009	23	CASCA	2010-03-11 00:00:00
4010	23	CASEIROS	2010-03-11 00:00:00
4011	23	CATUÍPE	2010-03-11 00:00:00
4012	23	CAXIAS DO SUL	2010-03-11 00:00:00
4013	23	CENTENÁRIO	2010-03-11 00:00:00
4014	23	CERRITO	2010-03-11 00:00:00
4015	23	CERRO BRANCO	2010-03-11 00:00:00
4016	23	CERRO GRANDE	2010-03-11 00:00:00
4017	23	CERRO GRANDE DO SUL	2010-03-11 00:00:00
4018	23	CERRO LARGO	2010-03-11 00:00:00
4019	23	CHAPADA	2010-03-11 00:00:00
4020	23	CHARQUEADAS	2010-03-11 00:00:00
4021	23	CHARRUA	2010-03-11 00:00:00
4022	23	CHIAPETTA	2010-03-11 00:00:00
4023	23	CHUÍ	2010-03-11 00:00:00
4024	23	CHUVISCA	2010-03-11 00:00:00
4025	23	CIDREIRA	2010-03-11 00:00:00
4026	23	CIRÍACO	2010-03-11 00:00:00
4027	23	COLINAS	2010-03-11 00:00:00
4028	23	COLORADO	2010-03-11 00:00:00
4029	23	CONDOR	2010-03-11 00:00:00
4030	23	CONSTANTINA	2010-03-11 00:00:00
4031	23	COQUEIRO BAIXO	2010-03-11 00:00:00
4032	23	COQUEIROS DO SUL	2010-03-11 00:00:00
4033	23	CORONEL BARROS	2010-03-11 00:00:00
4034	23	CORONEL BICACO	2010-03-11 00:00:00
4035	23	CORONEL PILAR	2010-03-11 00:00:00
4036	23	COTIPORÃ	2010-03-11 00:00:00
4037	23	COXILHA	2010-03-11 00:00:00
4038	23	CRISSIUMAL	2010-03-11 00:00:00
4039	23	CRISTAL	2010-03-11 00:00:00
4040	23	CRISTAL DO SUL	2010-03-11 00:00:00
4041	23	CRUZ ALTA	2010-03-11 00:00:00
4042	23	CRUZALTENSE	2010-03-11 00:00:00
4043	23	CRUZEIRO DO SUL	2010-03-11 00:00:00
4044	23	DAVID CANABARRO	2010-03-11 00:00:00
4045	23	DERRUBADAS	2010-03-11 00:00:00
4046	23	DEZESSEIS DE NOVEMBRO	2010-03-11 00:00:00
4047	23	DILERMANDO DE AGUIAR	2010-03-11 00:00:00
4048	23	DOIS IRMÃOS	2010-03-11 00:00:00
4049	23	DOIS IRMÃOS DAS MISSÕES	2010-03-11 00:00:00
4050	23	DOIS LAJEADOS	2010-03-11 00:00:00
4051	23	DOM FELICIANO	2010-03-11 00:00:00
4052	23	DOM PEDRITO	2010-03-11 00:00:00
4053	23	DOM PEDRO DE ALCÂNTARA	2010-03-11 00:00:00
4054	23	DONA FRANCISCA	2010-03-11 00:00:00
4055	23	DOUTOR MAURÍCIO CARDOSO	2010-03-11 00:00:00
4056	23	DOUTOR RICARDO	2010-03-11 00:00:00
4057	23	ELDORADO DO SUL	2010-03-11 00:00:00
4058	23	ENCANTADO	2010-03-11 00:00:00
4059	23	ENCRUZILHADA DO SUL	2010-03-11 00:00:00
4060	23	ENGENHO VELHO	2010-03-11 00:00:00
4061	23	ENTRE IJUÍS	2010-03-11 00:00:00
4062	23	ENTRE RIOS DO SUL	2010-03-11 00:00:00
4063	23	EREBANGO	2010-03-11 00:00:00
4064	23	ERECHIM	2010-03-11 00:00:00
4065	23	ERNESTINA	2010-03-11 00:00:00
4066	23	ERVAL GRANDE	2010-03-11 00:00:00
4067	23	ERVAL SECO	2010-03-11 00:00:00
4068	23	ESMERALDA	2010-03-11 00:00:00
4069	23	ESPERANÇA DO SUL	2010-03-11 00:00:00
4070	23	ESPUMOSO	2010-03-11 00:00:00
4071	23	ESTAÇÃO	2010-03-11 00:00:00
4072	23	ESTÂNCIA VELHA	2010-03-11 00:00:00
4073	23	ESTEIO	2010-03-11 00:00:00
4074	23	ESTRELA	2010-03-11 00:00:00
4075	23	ESTRELA VELHA	2010-03-11 00:00:00
4076	23	EUGÊNIO DE CASTRO	2010-03-11 00:00:00
4077	23	FAGUNDES VARELA	2010-03-11 00:00:00
4078	23	FARROUPILHA	2010-03-11 00:00:00
4079	23	FAXINAL DO SOTURNO	2010-03-11 00:00:00
4080	23	FAXINALZINHO	2010-03-11 00:00:00
4081	23	FAZENDA VILANOVA	2010-03-11 00:00:00
4082	23	FELIZ	2010-03-11 00:00:00
4083	23	FLORES DA CUNHA	2010-03-11 00:00:00
4084	23	FLORIANO PEIXOTO	2010-03-11 00:00:00
4085	23	FONTOURA XAVIER	2010-03-11 00:00:00
4086	23	FORMIGUEIRO	2010-03-11 00:00:00
4087	23	FORQUETINHA	2010-03-11 00:00:00
4088	23	FORTALEZA DOS VALOS	2010-03-11 00:00:00
4089	23	FREDERICO WESTPHALEN	2010-03-11 00:00:00
4090	23	GARIBALDI	2010-03-11 00:00:00
4091	23	GARRUCHOS	2010-03-11 00:00:00
4092	23	GAURAMA	2010-03-11 00:00:00
4093	23	GENERAL CÂMARA	2010-03-11 00:00:00
4094	23	GENTIL	2010-03-11 00:00:00
4095	23	GETÚLIO VARGAS	2010-03-11 00:00:00
4096	23	GIRUÁ	2010-03-11 00:00:00
4097	23	GLORINHA	2010-03-11 00:00:00
4098	23	GRAMADO	2010-03-11 00:00:00
4099	23	GRAMADO DOS LOUREIROS	2010-03-11 00:00:00
4100	23	GRAMADO XAVIER	2010-03-11 00:00:00
4101	23	GRAVATAÍ	2010-03-11 00:00:00
4102	23	GUABIJU	2010-03-11 00:00:00
4103	23	GUAÍBA	2010-03-11 00:00:00
4104	23	GUAPORÉ	2010-03-11 00:00:00
4105	23	GUARANI DAS MISSÕES	2010-03-11 00:00:00
4106	23	HARMONIA	2010-03-11 00:00:00
4107	23	HERVAL	2010-03-11 00:00:00
4108	23	HERVEIRAS	2010-03-11 00:00:00
4109	23	HORIZONTINA	2010-03-11 00:00:00
4110	23	HULHA NEGRA	2010-03-11 00:00:00
4111	23	HUMAITÁ	2010-03-11 00:00:00
4112	23	IBARAMA	2010-03-11 00:00:00
4113	23	IBIAÇÁ	2010-03-11 00:00:00
4114	23	IBIRAIARAS	2010-03-11 00:00:00
4115	23	IBIRAPUITÃ	2010-03-11 00:00:00
4116	23	IBIRUBÁ	2010-03-11 00:00:00
4117	23	IGREJINHA	2010-03-11 00:00:00
4118	23	IJUÍ	2010-03-11 00:00:00
4119	23	ILÓPOLIS	2010-03-11 00:00:00
4120	23	IMBÉ	2010-03-11 00:00:00
4121	23	IMIGRANTE	2010-03-11 00:00:00
4122	23	INDEPENDÊNCIA	2010-03-11 00:00:00
4123	23	INHACORÁ	2010-03-11 00:00:00
4124	23	IPÊ	2010-03-11 00:00:00
4125	23	IPIRANGA DO SUL	2010-03-11 00:00:00
4126	23	IRAÍ	2010-03-11 00:00:00
4127	23	ITAÁRA	2010-03-11 00:00:00
4128	23	ITACURUBI	2010-03-11 00:00:00
4129	23	ITAPUCA	2010-03-11 00:00:00
4130	23	ITAQUI	2010-03-11 00:00:00
4131	23	ITATI	2010-03-11 00:00:00
4132	23	ITATIBA DO SUL	2010-03-11 00:00:00
4133	23	IVORÁ	2010-03-11 00:00:00
4134	23	IVOTI	2010-03-11 00:00:00
4135	23	JABOTICABA	2010-03-11 00:00:00
4136	23	JACUIZINHO	2010-03-11 00:00:00
4137	23	JACUTINGA	2010-03-11 00:00:00
4138	23	JAGUARÃO	2010-03-11 00:00:00
4139	23	JAGUARI	2010-03-11 00:00:00
4140	23	JAQUIRANA	2010-03-11 00:00:00
4141	23	JARI	2010-03-11 00:00:00
4142	23	JÓIA	2010-03-11 00:00:00
4143	23	JÚLIO DE CASTILHOS	2010-03-11 00:00:00
4144	23	LAGOA BONITA DO SUL	2010-03-11 00:00:00
4145	23	LAGOA DOS TRÊS CANTOS	2010-03-11 00:00:00
4146	23	LAGOA VERMELHA	2010-03-11 00:00:00
4147	23	LAGOÃO	2010-03-11 00:00:00
4148	23	LAJEADO	2010-03-11 00:00:00
4149	23	LAJEADO DO BUGRE	2010-03-11 00:00:00
4150	23	LAVRAS DO SUL	2010-03-11 00:00:00
4151	23	LIBERATO SALZANO	2010-03-11 00:00:00
4152	23	LINDOLFO COLLOR	2010-03-11 00:00:00
4153	23	LINHA NOVA	2010-03-11 00:00:00
4154	23	MAÇAMBARÁ	2010-03-11 00:00:00
4155	23	MACHADINHO	2010-03-11 00:00:00
4156	23	MAMPITUBA	2010-03-11 00:00:00
4157	23	MANOEL VIANA	2010-03-11 00:00:00
4158	23	MAQUINÉ	2010-03-11 00:00:00
4159	23	MARATÁ	2010-03-11 00:00:00
4160	23	MARAU	2010-03-11 00:00:00
4161	23	MARCELINO RAMOS	2010-03-11 00:00:00
4162	23	MARIANA PIMENTEL	2010-03-11 00:00:00
4163	23	MARIANO MORO	2010-03-11 00:00:00
4164	23	MARQUES DE SOUZA	2010-03-11 00:00:00
4165	23	MATA	2010-03-11 00:00:00
4166	23	MATO CASTELHANO	2010-03-11 00:00:00
4167	23	MATO LEITÃO	2010-03-11 00:00:00
4168	23	MATO QUEIMADO	2010-03-11 00:00:00
4169	23	MAXIMILIANO DE ALMEIDA	2010-03-11 00:00:00
4170	23	MINAS DO LEÃO	2010-03-11 00:00:00
4171	23	MIRAGUAÍ	2010-03-11 00:00:00
4172	23	MONTAURI	2010-03-11 00:00:00
4173	23	MONTE ALEGRE DOS CAMPOS	2010-03-11 00:00:00
4174	23	MONTE BELO DO SUL	2010-03-11 00:00:00
4175	23	MONTENEGRO	2010-03-11 00:00:00
4176	23	MORMAÇO	2010-03-11 00:00:00
4177	23	MORRINHOS DO SUL	2010-03-11 00:00:00
4178	23	MORRO REDONDO	2010-03-11 00:00:00
4179	23	MORRO REUTER	2010-03-11 00:00:00
4180	23	MOSTARDAS	2010-03-11 00:00:00
4181	23	MUÇUM	2010-03-11 00:00:00
4182	23	MUITOS CAPÕES	2010-03-11 00:00:00
4183	23	MULITERNO	2010-03-11 00:00:00
4184	23	NÃO-ME-TOQUE	2010-03-11 00:00:00
4185	23	NICOLAU VERGUEIRO	2010-03-11 00:00:00
4186	23	NONOAÍ	2010-03-11 00:00:00
4187	23	NOVA ALVORADA	2010-03-11 00:00:00
4188	23	NOVA ARAÇÁ	2010-03-11 00:00:00
4189	23	NOVA BASSANO	2010-03-11 00:00:00
4190	23	NOVA BOA VISTA	2010-03-11 00:00:00
4191	23	NOVA BRÉSCIA	2010-03-11 00:00:00
4192	23	NOVA CANDELÁRIA	2010-03-11 00:00:00
4193	23	NOVA ESPERANÇA DO SUL	2010-03-11 00:00:00
4194	23	NOVA HARTZ	2010-03-11 00:00:00
4195	23	NOVA PÁDUA	2010-03-11 00:00:00
4196	23	NOVA PALMA	2010-03-11 00:00:00
4197	23	NOVA PETRÓPOLIS	2010-03-11 00:00:00
4198	23	NOVA PRATA	2010-03-11 00:00:00
4199	23	NOVA RAMADA	2010-03-11 00:00:00
4200	23	NOVA ROMA DO SUL	2010-03-11 00:00:00
4201	23	NOVA SANTA RITA	2010-03-11 00:00:00
4202	23	NOVO BARREIRO	2010-03-11 00:00:00
4203	23	NOVO CABRAIS	2010-03-11 00:00:00
4204	23	NOVO HAMBURGO	2010-03-11 00:00:00
4205	23	NOVO MACHADO	2010-03-11 00:00:00
4206	23	NOVO TIRADENTES	2010-03-11 00:00:00
4207	23	NOVO XINGU	2010-03-11 00:00:00
4208	23	OSÓRIO	2010-03-11 00:00:00
4209	23	PAIM FILHO	2010-03-11 00:00:00
4210	23	PALMARES DO SUL	2010-03-11 00:00:00
4211	23	PALMEIRA DAS MISSÕES	2010-03-11 00:00:00
4212	23	PALMITINHO	2010-03-11 00:00:00
4213	23	PANAMBI	2010-03-11 00:00:00
4214	23	PÂNTANO GRANDE	2010-03-11 00:00:00
4215	23	PARAÍ	2010-03-11 00:00:00
4216	23	PARAÍSO DO SUL	2010-03-11 00:00:00
4217	23	PARECI NOVO	2010-03-11 00:00:00
4218	23	PAROBÉ	2010-03-11 00:00:00
4219	23	PASSA SETE	2010-03-11 00:00:00
4220	23	PASSO DO SOBRADO	2010-03-11 00:00:00
4221	23	PASSO FUNDO	2010-03-11 00:00:00
4222	23	PAULO BENTO	2010-03-11 00:00:00
4223	23	PAVERAMA	2010-03-11 00:00:00
4224	23	PEDRAS ALTAS	2010-03-11 00:00:00
4225	23	PEDRO OSÓRIO	2010-03-11 00:00:00
4226	23	PEJUÇARA	2010-03-11 00:00:00
4228	23	PICADA CAFÉ	2010-03-11 00:00:00
4229	23	PINHAL	2010-03-11 00:00:00
4230	23	PINHAL DA SERRA	2010-03-11 00:00:00
4231	23	PINHAL GRANDE	2010-03-11 00:00:00
4232	23	PINHEIRINHO DO VALE	2010-03-11 00:00:00
4233	23	PINHEIRO MACHADO	2010-03-11 00:00:00
4234	23	PIRAPÓ	2010-03-11 00:00:00
4235	23	PIRATINI	2010-03-11 00:00:00
4236	23	PLANALTO	2010-03-11 00:00:00
4237	23	POÇO DAS ANTAS	2010-03-11 00:00:00
4238	23	PONTÃO	2010-03-11 00:00:00
4239	23	PONTE PRETA	2010-03-11 00:00:00
4240	23	PORTÃO	2010-03-11 00:00:00
4241	23	PORTO ALEGRE	2010-03-11 00:00:00
4242	23	PORTO LUCENA	2010-03-11 00:00:00
4243	23	PORTO MAUÁ	2010-03-11 00:00:00
4244	23	PORTO VERA CRUZ	2010-03-11 00:00:00
4245	23	PORTO XAVIER	2010-03-11 00:00:00
4246	23	POUSO NOVO	2010-03-11 00:00:00
4247	23	PRESIDENTE LUCENA	2010-03-11 00:00:00
4248	23	PROGRESSO	2010-03-11 00:00:00
4249	23	PROTÁSIO ALVES	2010-03-11 00:00:00
4250	23	PUTINGA	2010-03-11 00:00:00
4251	23	QUARAÍ	2010-03-11 00:00:00
4252	23	QUATRO IRMÃOS	2010-03-11 00:00:00
4253	23	QUEVEDOS	2010-03-11 00:00:00
4254	23	QUINZE DE NOVEMBRO	2010-03-11 00:00:00
4255	23	REDENTORA	2010-03-11 00:00:00
4256	23	RELVADO	2010-03-11 00:00:00
4257	23	RESTINGA SECA	2010-03-11 00:00:00
4258	23	RIO DOS ÍNDIOS	2010-03-11 00:00:00
4259	23	RIO GRANDE	2010-03-11 00:00:00
4260	23	RIO PARDO	2010-03-11 00:00:00
4261	23	RIOZINHO	2010-03-11 00:00:00
4262	23	ROCA SALES	2010-03-11 00:00:00
4263	23	RODEIO BONITO	2010-03-11 00:00:00
4264	23	ROLADOR	2010-03-11 00:00:00
4265	23	ROLANTE	2010-03-11 00:00:00
4266	23	RONDA ALTA	2010-03-11 00:00:00
4267	23	RONDINHA	2010-03-11 00:00:00
4268	23	ROQUE GONZALES	2010-03-11 00:00:00
4269	23	ROSÁRIO DO SUL	2010-03-11 00:00:00
4270	23	SAGRADA FAMÍLIA	2010-03-11 00:00:00
4271	23	SALDANHA MARINHO	2010-03-11 00:00:00
4272	23	SALTO DO JACUÍ	2010-03-11 00:00:00
4273	23	SALVADOR DAS MISSÕES	2010-03-11 00:00:00
4274	23	SALVADOR DO SUL	2010-03-11 00:00:00
4275	23	SANANDUVA	2010-03-11 00:00:00
4276	23	SANTA BÁRBARA DO SUL	2010-03-11 00:00:00
4277	23	SANTA CECÍLIA DO SUL	2010-03-11 00:00:00
4278	23	SANTA CLARA DO SUL	2010-03-11 00:00:00
4279	23	SANTA CRUZ DO SUL	2010-03-11 00:00:00
4280	23	SANTA MARGARIDA DO SUL	2010-03-11 00:00:00
4281	23	SANTA MARIA	2010-03-11 00:00:00
4282	23	SANTA MARIA DO HERVAL	2010-03-11 00:00:00
4283	23	SANTA ROSA	2010-03-11 00:00:00
4284	23	SANTA TEREZA	2010-03-11 00:00:00
4285	23	SANTA VITÓRIA DO PALMAR	2010-03-11 00:00:00
4286	23	SANTANA DA BOA VISTA	2010-03-11 00:00:00
4287	23	SANTANA DO LIVRAMENTO	2010-03-11 00:00:00
4288	23	SANTIAGO	2010-03-11 00:00:00
4289	23	SANTO ÂNGELO	2010-03-11 00:00:00
4290	23	SANTO ANTÔNIO DA PATRULHA	2010-03-11 00:00:00
4291	23	SANTO ANTÔNIO DAS MISSÕES	2010-03-11 00:00:00
4292	23	SANTO ANTÔNIO DO PALMA	2010-03-11 00:00:00
4227	23	PELOTAS	2010-03-11 00:00:00
4293	23	SANTO ANTÔNIO DO PLANALTO	2010-03-11 00:00:00
4294	23	SANTO AUGUSTO	2010-03-11 00:00:00
4295	23	SANTO CRISTO	2010-03-11 00:00:00
4296	23	SANTO EXPEDITO DO SUL	2010-03-11 00:00:00
4297	23	SÃO BORJA	2010-03-11 00:00:00
4298	23	SÃO DOMINGOS DO SUL	2010-03-11 00:00:00
4299	23	SÃO FRANCISCO DE ASSIS	2010-03-11 00:00:00
4300	23	SÃO FRANCISCO DE PAULA	2010-03-11 00:00:00
4301	23	SÃO GABRIEL	2010-03-11 00:00:00
4302	23	SÃO JERÔNIMO	2010-03-11 00:00:00
4303	23	SÃO JOÃO DA URTIGA	2010-03-11 00:00:00
4304	23	SÃO JOÃO DO POLÊSINE	2010-03-11 00:00:00
4305	23	SÃO JORGE	2010-03-11 00:00:00
4306	23	SÃO JOSÉ DAS MISSÕES	2010-03-11 00:00:00
4307	23	SÃO JOSÉ DO HERVAL	2010-03-11 00:00:00
4308	23	SÃO JOSÉ DO HORTÊNCIO	2010-03-11 00:00:00
4309	23	SÃO JOSÉ DO INHACORÁ	2010-03-11 00:00:00
4310	23	SÃO JOSÉ DO NORTE	2010-03-11 00:00:00
4311	23	SÃO JOSÉ DO OURO	2010-03-11 00:00:00
4312	23	SÃO JOSÉ DO SUL	2010-03-11 00:00:00
4313	23	SÃO JOSÉ DOS AUSENTES	2010-03-11 00:00:00
4314	23	SÃO LEOPOLDO	2010-03-11 00:00:00
4315	23	SÃO LOURENÇO DO SUL	2010-03-11 00:00:00
4316	23	SÃO LUIZ GONZAGA	2010-03-11 00:00:00
4317	23	SÃO MARCOS	2010-03-11 00:00:00
4318	23	SÃO MARTINHO	2010-03-11 00:00:00
4319	23	SÃO MARTINHO DA SERRA	2010-03-11 00:00:00
4320	23	SÃO MIGUEL DAS MISSÕES	2010-03-11 00:00:00
4321	23	SÃO NICOLAU	2010-03-11 00:00:00
4322	23	SÃO PAULO DAS MISSÕES	2010-03-11 00:00:00
4323	23	SÃO PEDRO DA SERRA	2010-03-11 00:00:00
4324	23	SÃO PEDRO DAS MISSÕES	2010-03-11 00:00:00
4325	23	SÃO PEDRO DO BUTIÁ	2010-03-11 00:00:00
4326	23	SÃO PEDRO DO SUL	2010-03-11 00:00:00
4327	23	SÃO SEBASTIÃO DO CAÍ	2010-03-11 00:00:00
4328	23	SÃO SEPÉ	2010-03-11 00:00:00
4329	23	SÃO VALENTIM	2010-03-11 00:00:00
4330	23	SÃO VALENTIM DO SUL	2010-03-11 00:00:00
4331	23	SÃO VALÉRIO DO SUL	2010-03-11 00:00:00
4332	23	SÃO VENDELINO	2010-03-11 00:00:00
4333	23	SÃO VICENTE DO SUL	2010-03-11 00:00:00
4334	23	SAPIRANGA	2010-03-11 00:00:00
4335	23	SAPUCAIA DO SUL	2010-03-11 00:00:00
4336	23	SARANDI	2010-03-11 00:00:00
4337	23	SEBERI	2010-03-11 00:00:00
4338	23	SEDE NOVA	2010-03-11 00:00:00
4339	23	SEGREDO	2010-03-11 00:00:00
4340	23	SELBACH	2010-03-11 00:00:00
4341	23	SENADOR SALGADO FILHO	2010-03-11 00:00:00
4342	23	SENTINELA DO SUL	2010-03-11 00:00:00
4343	23	SERAFINA CÔRREA	2010-03-11 00:00:00
4344	23	SÉRIO	2010-03-11 00:00:00
4345	23	SERTÃO 	2010-03-11 00:00:00
4346	23	SERTÃO SANTANA	2010-03-11 00:00:00
4347	23	SETE DE SETEMBRO	2010-03-11 00:00:00
4348	23	SEVERIANO DE ALMEIDA	2010-03-11 00:00:00
4349	23	SILVEIRA MARTINS	2010-03-11 00:00:00
4350	23	SINIMBU	2010-03-11 00:00:00
4351	23	SOBRADINHO	2010-03-11 00:00:00
4352	23	SOLEDADE	2010-03-11 00:00:00
4353	23	TABAÍ	2010-03-11 00:00:00
4354	23	TAPEJARA	2010-03-11 00:00:00
4355	23	TAPERA	2010-03-11 00:00:00
4356	23	TAPES	2010-03-11 00:00:00
4357	23	TAQUARA	2010-03-11 00:00:00
4358	23	TAQUARAÇU DO SUL	2010-03-11 00:00:00
4359	23	TAQUARI	2010-03-11 00:00:00
4360	23	TAVARES	2010-03-11 00:00:00
4361	23	TENENTE PORTELA	2010-03-11 00:00:00
4362	23	TERRA DE AREIA	2010-03-11 00:00:00
4363	23	TEUTÔNIA	2010-03-11 00:00:00
4364	23	TIO HUGO	2010-03-11 00:00:00
4365	23	TIRADENTES DO SUL	2010-03-11 00:00:00
4366	23	TOROPI	2010-03-11 00:00:00
4367	23	TORRES	2010-03-11 00:00:00
4368	23	TRAMANDAÍ	2010-03-11 00:00:00
4369	23	TRAVESSEIRO	2010-03-11 00:00:00
4370	23	TRÊS ARROIOS	2010-03-11 00:00:00
4371	23	TRÊS CACHOEIRAS	2010-03-11 00:00:00
4372	23	TRÊS COROAS	2010-03-11 00:00:00
4373	23	TRÊS DE MAIO	2010-03-11 00:00:00
4374	23	TRÊS FORQUILHAS	2010-03-11 00:00:00
4375	23	TRÊS PALMEIRAS	2010-03-11 00:00:00
4376	23	TRÊS PASSOS	2010-03-11 00:00:00
4377	23	TRINDADE DO SUL	2010-03-11 00:00:00
4378	23	TRIUNFO	2010-03-11 00:00:00
4379	23	TUCUNDUVA	2010-03-11 00:00:00
4380	23	TUNAS	2010-03-11 00:00:00
4381	23	TUPANCI DO SUL	2010-03-11 00:00:00
4382	23	TUPANCIRETÃ	2010-03-11 00:00:00
4383	23	TUPANDI	2010-03-11 00:00:00
4384	23	TUPARENDI	2010-03-11 00:00:00
4385	23	TURUÇU	2010-03-11 00:00:00
4386	23	UBIRETAMA	2010-03-11 00:00:00
4387	23	UNIÃO DA SERRA	2010-03-11 00:00:00
4388	23	UNISTALDA	2010-03-11 00:00:00
4389	23	URUGUAIANA	2010-03-11 00:00:00
4390	23	VACARIA	2010-03-11 00:00:00
4391	23	VALE DO SOL	2010-03-11 00:00:00
4392	23	VALE REAL	2010-03-11 00:00:00
4393	23	VALE VERDE	2010-03-11 00:00:00
4394	23	VANINI	2010-03-11 00:00:00
4395	23	VENÂNCIO AIRES	2010-03-11 00:00:00
4396	23	VERA CRUZ	2010-03-11 00:00:00
4397	23	VERANÓPOLIS	2010-03-11 00:00:00
4398	23	VESPASIANO CORREA	2010-03-11 00:00:00
4399	23	VIADUTOS	2010-03-11 00:00:00
4400	23	VIAMÃO	2010-03-11 00:00:00
4401	23	VICENTE DUTRA	2010-03-11 00:00:00
4402	23	VICTOR GRAEFF	2010-03-11 00:00:00
4403	23	VILA FLORES	2010-03-11 00:00:00
4404	23	VILA LÂNGARO	2010-03-11 00:00:00
4405	23	VILA MARIA	2010-03-11 00:00:00
4406	23	VILA NOVA DO SUL	2010-03-11 00:00:00
4407	23	VISTA ALEGRE	2010-03-11 00:00:00
4408	23	VISTA ALEGRE DO PRATA	2010-03-11 00:00:00
4409	23	VISTA GAÚCHA	2010-03-11 00:00:00
4410	23	VITÓRIA DAS MISSÕES	2010-03-11 00:00:00
4411	23	WESTFÁLIA	2010-03-11 00:00:00
4412	23	XANGRI-LÁ	2010-03-11 00:00:00
4413	24	ABDON BATISTA	2010-03-11 00:00:00
4414	24	ABELARDO LUZ	2010-03-11 00:00:00
4415	24	AGROLÂNDIA	2010-03-11 00:00:00
4416	24	AGRONÔMICA	2010-03-11 00:00:00
4417	24	ÁGUA DOCE	2010-03-11 00:00:00
4418	24	ÁGUAS DE CHAPECÓ	2010-03-11 00:00:00
4419	24	ÁGUAS FRIAS	2010-03-11 00:00:00
4420	24	ÁGUAS MORNAS	2010-03-11 00:00:00
4421	24	ALFREDO WAGNER	2010-03-11 00:00:00
4422	24	ALTO BELA VISTA	2010-03-11 00:00:00
4423	24	ANCHIETA	2010-03-11 00:00:00
4424	24	ANGELINA	2010-03-11 00:00:00
4425	24	ANITA GARIBALDI	2010-03-11 00:00:00
4426	24	ANITÁPOLIS	2010-03-11 00:00:00
4427	24	ANTÔNIO CARLOS	2010-03-11 00:00:00
4428	24	APIÚNA	2010-03-11 00:00:00
4429	24	ARABUTÃ	2010-03-11 00:00:00
4430	24	ARAQUARI	2010-03-11 00:00:00
4431	24	ARARANGUÁ	2010-03-11 00:00:00
4432	24	ARMAZÉM	2010-03-11 00:00:00
4433	24	ARROIO TRINTA	2010-03-11 00:00:00
4434	24	ARVOREDO	2010-03-11 00:00:00
4435	24	ASCURRA	2010-03-11 00:00:00
4436	24	ATALANTA	2010-03-11 00:00:00
4437	24	AURORA	2010-03-11 00:00:00
4438	24	BALNEÁRIO ARROIO DO SILVA	2010-03-11 00:00:00
4439	24	BALNEÁRIO BARRA DO SUL	2010-03-11 00:00:00
4440	24	BALNEÁRIO CAMBORIÚ	2010-03-11 00:00:00
4441	24	BALNEÁRIO GAIVOTA	2010-03-11 00:00:00
4442	24	BALNEÁRIO PIÇARRAS	2010-03-11 00:00:00
4443	24	BANDEIRANTE	2010-03-11 00:00:00
4444	24	BARRA BONITA	2010-03-11 00:00:00
4445	24	BARRA VELHA	2010-03-11 00:00:00
4446	24	BELA VISTA DO TOLDO	2010-03-11 00:00:00
4447	24	BELMONTE	2010-03-11 00:00:00
4448	24	BENEDITO NOVO	2010-03-11 00:00:00
4449	24	BIGUAÇU	2010-03-11 00:00:00
4450	24	BLUMENAU	2010-03-11 00:00:00
4451	24	BOCAINA DO SUL	2010-03-11 00:00:00
4452	24	BOM JARDIM DA SERRA	2010-03-11 00:00:00
4453	24	BOM JESUS	2010-03-11 00:00:00
4454	24	BOM JESUS DO OESTE	2010-03-11 00:00:00
4455	24	BOM RETIRO	2010-03-11 00:00:00
4456	24	BOMBINHAS	2010-03-11 00:00:00
4457	24	BOTUVERÁ	2010-03-11 00:00:00
4458	24	BRAÇO DO NORTE	2010-03-11 00:00:00
4459	24	BRAÇO DO TROMBUDO	2010-03-11 00:00:00
4460	24	BRUNÓPOLIS	2010-03-11 00:00:00
4461	24	BRUSQUE	2010-03-11 00:00:00
4462	24	CAÇADOR	2010-03-11 00:00:00
4463	24	CAIBI	2010-03-11 00:00:00
4464	24	CALMON	2010-03-11 00:00:00
4465	24	CAMBORIÚ	2010-03-11 00:00:00
4466	24	CAMPO ALEGRE	2010-03-11 00:00:00
4467	24	CAMPO BELO DO SUL	2010-03-11 00:00:00
4468	24	CAMPO ERÊ	2010-03-11 00:00:00
4469	24	CAMPOS NOVOS	2010-03-11 00:00:00
4470	24	CANELINHA	2010-03-11 00:00:00
4471	24	CANOINHAS	2010-03-11 00:00:00
4472	24	CAPÃO ALTO	2010-03-11 00:00:00
4473	24	CAPINZAL	2010-03-11 00:00:00
4474	24	CAPIVARI DE BAIXO	2010-03-11 00:00:00
4475	24	CATANDUVAS	2010-03-11 00:00:00
4476	24	CAXAMBU DO SUL	2010-03-11 00:00:00
4477	24	CELSO RAMOS	2010-03-11 00:00:00
4478	24	CERRO NEGRO	2010-03-11 00:00:00
4479	24	CHAPADÃO DO LAGEADO	2010-03-11 00:00:00
4480	24	CHAPECÓ	2010-03-11 00:00:00
4481	24	COCAL DO SUL	2010-03-11 00:00:00
4482	24	CONCÓRDIA	2010-03-11 00:00:00
4483	24	CORDILHEIRA ALTA	2010-03-11 00:00:00
4484	24	CORONEL FREITAS	2010-03-11 00:00:00
4485	24	CORONEL MARTINS	2010-03-11 00:00:00
4486	24	CORREIA PINTO	2010-03-11 00:00:00
4487	24	CORUPÁ	2010-03-11 00:00:00
4488	24	CRICIÚMA	2010-03-11 00:00:00
4489	24	CUNHA PORÃ	2010-03-11 00:00:00
4490	24	CUNHATAÍ	2010-03-11 00:00:00
4491	24	CURITIBANOS	2010-03-11 00:00:00
4492	24	DESCANSO	2010-03-11 00:00:00
4493	24	DIONÍSIO CERQUEIRA	2010-03-11 00:00:00
4494	24	DONA EMMA	2010-03-11 00:00:00
4495	24	DOUTOR PEDRINHO	2010-03-11 00:00:00
4496	24	ENTRE RIOS	2010-03-11 00:00:00
4497	24	ERMO	2010-03-11 00:00:00
4498	24	ERVAL VELHO	2010-03-11 00:00:00
4499	24	FAXINAL DOS GUEDES	2010-03-11 00:00:00
4500	24	FLOR DO SERTÃO	2010-03-11 00:00:00
4501	24	FLORIANÓPOLIS	2010-03-11 00:00:00
4502	24	FORMOSA DO SUL	2010-03-11 00:00:00
4503	24	FORQUILHINHA	2010-03-11 00:00:00
4504	24	FRAIBURGO	2010-03-11 00:00:00
4505	24	FREI ROGÉRIO	2010-03-11 00:00:00
4506	24	GALVÃO	2010-03-11 00:00:00
4507	24	GAROPABA	2010-03-11 00:00:00
4508	24	GARUVA	2010-03-11 00:00:00
4509	24	GASPAR	2010-03-11 00:00:00
4510	24	GOVERNADOR CELSO RAMOS	2010-03-11 00:00:00
4511	24	GRÃO PARÁ	2010-03-11 00:00:00
4512	24	GRAVATAL	2010-03-11 00:00:00
4513	24	GUABIRUBA	2010-03-11 00:00:00
4514	24	GUARACIABA	2010-03-11 00:00:00
4515	24	GUARAMIRIM	2010-03-11 00:00:00
4516	24	GUARUJÁ DO SUL	2010-03-11 00:00:00
4517	24	GUATAMBU	2010-03-11 00:00:00
4518	24	HERVAL D OESTE	2010-03-11 00:00:00
4519	24	IBIAM	2010-03-11 00:00:00
4520	24	IBICARÉ	2010-03-11 00:00:00
4521	24	IBIRAMA	2010-03-11 00:00:00
4522	24	IÇARA	2010-03-11 00:00:00
4523	24	ILHOTA	2010-03-11 00:00:00
4524	24	IMARUÍ	2010-03-11 00:00:00
4525	24	IMBITUBA	2010-03-11 00:00:00
4526	24	IMBUIA	2010-03-11 00:00:00
4527	24	INDAIAL	2010-03-11 00:00:00
4528	24	IOMERÊ	2010-03-11 00:00:00
4529	24	IPIRA	2010-03-11 00:00:00
4530	24	IPORÃ DO OESTE	2010-03-11 00:00:00
4531	24	IPUAÇU	2010-03-11 00:00:00
4532	24	IPUMIRIM	2010-03-11 00:00:00
4533	24	IRACEMINHA	2010-03-11 00:00:00
4534	24	IRANI	2010-03-11 00:00:00
4535	24	IRATI	2010-03-11 00:00:00
4536	24	IRINEÓPOLIS	2010-03-11 00:00:00
4537	24	ITÁ	2010-03-11 00:00:00
4538	24	ITAIÓPOLIS	2010-03-11 00:00:00
4539	24	ITAJAÍ	2010-03-11 00:00:00
4540	24	ITAPEMA	2010-03-11 00:00:00
4541	24	ITAPIRANGA	2010-03-11 00:00:00
4542	24	ITAPOÁ	2010-03-11 00:00:00
4543	24	ITUPORANGA	2010-03-11 00:00:00
4544	24	JABORÁ	2010-03-11 00:00:00
4545	24	JACINTO MACHADO	2010-03-11 00:00:00
4546	24	JAGUARUNA	2010-03-11 00:00:00
4547	24	JARAGUÁ DO SUL	2010-03-11 00:00:00
4548	24	JARDINÓPOLIS	2010-03-11 00:00:00
4549	24	JOAÇABA	2010-03-11 00:00:00
4550	24	JOINVILLE	2010-03-11 00:00:00
4551	24	JOSÉ BOITEUX	2010-03-11 00:00:00
4552	24	JUPIÁ	2010-03-11 00:00:00
4553	24	LACERDÓPOLIS	2010-03-11 00:00:00
4554	24	LAGES	2010-03-11 00:00:00
4555	24	LAGUNA	2010-03-11 00:00:00
4556	24	LAJEADO GRANDE	2010-03-11 00:00:00
4557	24	LAURENTINO	2010-03-11 00:00:00
4558	24	LAURO MULLER	2010-03-11 00:00:00
4559	24	LEBON RÉGIS	2010-03-11 00:00:00
4560	24	LEOBERTO LEAL	2010-03-11 00:00:00
4561	24	LINDÓIA DO SUL	2010-03-11 00:00:00
4562	24	LONTRAS	2010-03-11 00:00:00
4563	24	LUIZ ALVES	2010-03-11 00:00:00
4564	24	LUZERNA	2010-03-11 00:00:00
4565	24	MACIEIRA	2010-03-11 00:00:00
4566	24	MAFRA	2010-03-11 00:00:00
4567	24	MAJOR GERCINO	2010-03-11 00:00:00
4568	24	MAJOR VIEIRA	2010-03-11 00:00:00
4569	24	MARACAJÁ	2010-03-11 00:00:00
4570	24	MARAVILHA	2010-03-11 00:00:00
4571	24	MAREMA	2010-03-11 00:00:00
4572	24	MASSARANDUBA	2010-03-11 00:00:00
4573	24	MATOS COSTA	2010-03-11 00:00:00
4574	24	MELEIRO	2010-03-11 00:00:00
4575	24	MIRIM DOCE	2010-03-11 00:00:00
4576	24	MODELO	2010-03-11 00:00:00
4577	24	MONDAÍ	2010-03-11 00:00:00
4578	24	MONTE CARLO	2010-03-11 00:00:00
4579	24	MONTE CASTELO	2010-03-11 00:00:00
4580	24	MORRO DA FUMAÇA	2010-03-11 00:00:00
4581	24	MORRO GRANDE	2010-03-11 00:00:00
4582	24	NAVEGANTES	2010-03-11 00:00:00
4583	24	NOVA ERECHIM	2010-03-11 00:00:00
4584	24	NOVA ITABERABA	2010-03-11 00:00:00
4585	24	NOVA TRENTO	2010-03-11 00:00:00
4586	24	NOVA VENEZA	2010-03-11 00:00:00
4587	24	NOVO HORIZONTE	2010-03-11 00:00:00
4588	24	ORLEANS	2010-03-11 00:00:00
4589	24	OTACÍLIO COSTA	2010-03-11 00:00:00
4590	24	OURO	2010-03-11 00:00:00
4591	24	OURO VERDE	2010-03-11 00:00:00
4592	24	PAIAL	2010-03-11 00:00:00
4593	24	PAINEL	2010-03-11 00:00:00
4594	24	PALHOÇA	2010-03-11 00:00:00
4595	24	PALMA SOLA	2010-03-11 00:00:00
4596	24	PALMEIRA	2010-03-11 00:00:00
4597	24	PALMITOS	2010-03-11 00:00:00
4598	24	PAPANDUVA	2010-03-11 00:00:00
4599	24	PARAÍSO	2010-03-11 00:00:00
4600	24	PASSO DE TORRES	2010-03-11 00:00:00
4601	24	PASSOS MAIA	2010-03-11 00:00:00
4602	24	PAULO LOPES	2010-03-11 00:00:00
4603	24	PEDRAS GRANDES	2010-03-11 00:00:00
4604	24	PENHA	2010-03-11 00:00:00
4605	24	PERITIBA	2010-03-11 00:00:00
4606	24	PETROLÂNDIA	2010-03-11 00:00:00
4607	24	PINHALZINHO	2010-03-11 00:00:00
4608	24	PINHEIRO PRETO	2010-03-11 00:00:00
4609	24	PIRATUBA	2010-03-11 00:00:00
4610	24	PLANALTO ALEGRE	2010-03-11 00:00:00
4611	24	POMERODE	2010-03-11 00:00:00
4612	24	PONTE ALTA	2010-03-11 00:00:00
4613	24	PONTE ALTA DO NORTE	2010-03-11 00:00:00
4614	24	PONTE SERRADA	2010-03-11 00:00:00
4615	24	PORTO BELO	2010-03-11 00:00:00
4616	24	PORTO UNIÃO	2010-03-11 00:00:00
4617	24	POUSO REDONDO	2010-03-11 00:00:00
4618	24	PRAIA GRANDE	2010-03-11 00:00:00
4619	24	PRESIDENTE CASTELLO BRANCO	2010-03-11 00:00:00
4620	24	PRESIDENTE GETÚLIO	2010-03-11 00:00:00
4621	24	PRESIDENTE NEREU	2010-03-11 00:00:00
4622	24	PRINCESA	2010-03-11 00:00:00
4623	24	QUILOMBO	2010-03-11 00:00:00
4624	24	RANCHO QUEIMADO	2010-03-11 00:00:00
4625	24	RIO DAS ANTAS	2010-03-11 00:00:00
4626	24	RIO DO CAMPO	2010-03-11 00:00:00
4627	24	RIO DO OESTE	2010-03-11 00:00:00
4628	24	RIO DO SUL	2010-03-11 00:00:00
4629	24	RIO DOS CEDROS	2010-03-11 00:00:00
4630	24	RIO FORTUNA	2010-03-11 00:00:00
4631	24	RIO NEGRINHO	2010-03-11 00:00:00
4632	24	RIO RUFINO	2010-03-11 00:00:00
4633	24	RIQUEZA	2010-03-11 00:00:00
4634	24	RODEIO	2010-03-11 00:00:00
4635	24	ROMELÂNDIA	2010-03-11 00:00:00
4636	24	SALETE	2010-03-11 00:00:00
4637	24	SALTINHO	2010-03-11 00:00:00
4638	24	SALTO VELOSO	2010-03-11 00:00:00
4639	24	SANGÃO	2010-03-11 00:00:00
4640	24	SANTA CECÍLIA	2010-03-11 00:00:00
4641	24	SANTA HELENA	2010-03-11 00:00:00
4642	24	SANTA ROSA DE LIMA	2010-03-11 00:00:00
4643	24	SANTA ROSA DO SUL	2010-03-11 00:00:00
4644	24	SANTA TEREZINHA	2010-03-11 00:00:00
4645	24	SANTA TEREZINHA DO PROGRESSO	2010-03-11 00:00:00
4646	24	SANTIAGO DO SUL	2010-03-11 00:00:00
4647	24	SANTO AMARO DA IMPERATRIZ	2010-03-11 00:00:00
4648	24	SÃO BENTO DO SUL	2010-03-11 00:00:00
4649	24	SÃO BERNARDINO	2010-03-11 00:00:00
4650	24	SÃO BONIFÁCIO	2010-03-11 00:00:00
4651	24	SÃO CARLOS	2010-03-11 00:00:00
4652	24	SÃO CRISTÓVÃO DO SUL	2010-03-11 00:00:00
4653	24	SÃO DOMINGOS	2010-03-11 00:00:00
4654	24	SÃO FRANCISCO DO SUL	2010-03-11 00:00:00
4655	24	SÃO JOÃO BATISTA	2010-03-11 00:00:00
4656	24	SÃO JOÃO DO ITAPERIU	2010-03-11 00:00:00
4657	24	SÃO JOÃO DO OESTE	2010-03-11 00:00:00
4658	24	SÃO JOÃO DO SUL	2010-03-11 00:00:00
4659	24	SÃO JOAQUIM	2010-03-11 00:00:00
4660	24	SÃO JOSÉ	2010-03-11 00:00:00
4661	24	SÃO JOSÉ DO CEDRO	2010-03-11 00:00:00
4662	24	SÃO JOSÉ DO CERRITO	2010-03-11 00:00:00
4663	24	SÃO LOURENÇO DO OESTE	2010-03-11 00:00:00
4664	24	SÃO LUDGERO	2010-03-11 00:00:00
4665	24	SÃO MARTINHO	2010-03-11 00:00:00
4666	24	SÃO MIGUEL D OESTE	2010-03-11 00:00:00
4667	24	SÃO MIGUEL DA BOA VISTA	2010-03-11 00:00:00
4668	24	SÃO PEDRO DE ALCÂNTARA	2010-03-11 00:00:00
4669	24	SAUDADES	2010-03-11 00:00:00
4670	24	SCHROEDER	2010-03-11 00:00:00
4671	24	SEARA	2010-03-11 00:00:00
4672	24	SERRA ALTA	2010-03-11 00:00:00
4673	24	SIDERÓPOLIS	2010-03-11 00:00:00
4674	24	SOMBRIO	2010-03-11 00:00:00
4675	24	SUL BRASIL	2010-03-11 00:00:00
4676	24	TAIÓ	2010-03-11 00:00:00
4677	24	TANGARÁ	2010-03-11 00:00:00
4678	24	TIGRINHOS	2010-03-11 00:00:00
4679	24	TIJUCAS	2010-03-11 00:00:00
4680	24	TIMBÉ DO SUL	2010-03-11 00:00:00
4681	24	TIMBÓ	2010-03-11 00:00:00
4682	24	TIMBÓ GRANDE	2010-03-11 00:00:00
4683	24	TRÊS BARRAS	2010-03-11 00:00:00
4684	24	TREVISO	2010-03-11 00:00:00
4685	24	TREZE DE MAIO	2010-03-11 00:00:00
4686	24	TREZE TÍLIAS	2010-03-11 00:00:00
4687	24	TROMBUDO CENTRAL	2010-03-11 00:00:00
4688	24	TUBARÃO	2010-03-11 00:00:00
4689	24	TUNÁPOLIS	2010-03-11 00:00:00
4690	24	TURVO	2010-03-11 00:00:00
4691	24	UNIÃO DO OESTE	2010-03-11 00:00:00
4692	24	URUBICI	2010-03-11 00:00:00
4693	24	URUPEMA	2010-03-11 00:00:00
4694	24	URUSSANGA	2010-03-11 00:00:00
4695	24	VARGEÃO	2010-03-11 00:00:00
4696	24	VARGEM	2010-03-11 00:00:00
4697	24	VARGEM BONITA	2010-03-11 00:00:00
4698	24	VIDAL RAMOS	2010-03-11 00:00:00
4699	24	VIDEIRA	2010-03-11 00:00:00
4700	24	VITOR MEIRELES	2010-03-11 00:00:00
4701	24	WITTMARSUM	2010-03-11 00:00:00
4702	24	XANXERÊ	2010-03-11 00:00:00
4703	24	XAVANTINA	2010-03-11 00:00:00
4704	24	XAXIM	2010-03-11 00:00:00
4705	24	ZORTÉA	2010-03-11 00:00:00
4706	25	AMPARO DE SÃO FRANCISCO	2010-03-11 00:00:00
4707	25	AQUIDABÃ	2010-03-11 00:00:00
4708	25	ARACAJU	2010-03-11 00:00:00
4709	25	ARAUA	2010-03-11 00:00:00
4710	25	AREIA BRANCA	2010-03-11 00:00:00
4711	25	BARRA DOS COQUEIROS	2010-03-11 00:00:00
4712	25	BOQUIM	2010-03-11 00:00:00
4713	25	BREJO GRANDE	2010-03-11 00:00:00
4714	25	CAMPO DO BRITO	2010-03-11 00:00:00
4715	25	CANHOBA	2010-03-11 00:00:00
4716	25	CANINDÉ DE SÃO FRANCISCO	2010-03-11 00:00:00
4717	25	CAPELA	2010-03-11 00:00:00
4718	25	CARIRA	2010-03-11 00:00:00
4719	25	CARMÓPOLIS	2010-03-11 00:00:00
4720	25	CEDRO DE SÃO JOÃO	2010-03-11 00:00:00
4721	25	CRISTINÁPOLIS	2010-03-11 00:00:00
4722	25	CUMBE	2010-03-11 00:00:00
4723	25	DIVINA PASTORA	2010-03-11 00:00:00
4724	25	ESTÂNCIA	2010-03-11 00:00:00
4725	25	FEIRA NOVA	2010-03-11 00:00:00
4726	25	FREI PAULO	2010-03-11 00:00:00
4727	25	GARARU	2010-03-11 00:00:00
4728	25	GENERAL MAYNARD	2010-03-11 00:00:00
4729	25	GRACHO CARDOSO	2010-03-11 00:00:00
4730	25	ILHA DAS FLORES	2010-03-11 00:00:00
4731	25	INDIAROBA	2010-03-11 00:00:00
4732	25	ITABAIANA	2010-03-11 00:00:00
4733	25	ITABAIANINHA	2010-03-11 00:00:00
4734	25	ITABI	2010-03-11 00:00:00
4735	25	ITAPORANGA D AJUDA	2010-03-11 00:00:00
4736	25	JAPARATUBA	2010-03-11 00:00:00
4737	25	JAPOATÃ	2010-03-11 00:00:00
4738	25	LAGARTO	2010-03-11 00:00:00
4739	25	LARANJEIRAS	2010-03-11 00:00:00
4740	25	MACAMBIRA	2010-03-11 00:00:00
4741	25	MALHADA DOS BOIS	2010-03-11 00:00:00
4742	25	MALHADOR	2010-03-11 00:00:00
4743	25	MARUIM	2010-03-11 00:00:00
4744	25	MOITA BONITA	2010-03-11 00:00:00
4745	25	MONTE ALEGRE DE SERGIPE	2010-03-11 00:00:00
4746	25	MURIBECA	2010-03-11 00:00:00
4747	25	NEÓPOLIS	2010-03-11 00:00:00
4748	25	NOSSA SENHORA APARECIDA	2010-03-11 00:00:00
4749	25	NOSSA SENHORA DA GLÓRIA	2010-03-11 00:00:00
4750	25	NOSSA SENHORA DAS DORES	2010-03-11 00:00:00
4751	25	NOSSA SENHORA DE LOURDES	2010-03-11 00:00:00
4752	25	NOSSA SENHORA DO SOCORRO	2010-03-11 00:00:00
4753	25	PACATUBA	2010-03-11 00:00:00
4754	25	PEDRA MOLE	2010-03-11 00:00:00
4755	25	PEDRINHAS	2010-03-11 00:00:00
4756	25	PINHÃO	2010-03-11 00:00:00
4757	25	PIRAMBU	2010-03-11 00:00:00
4758	25	POÇO REDONDO	2010-03-11 00:00:00
4759	25	POÇO VERDE	2010-03-11 00:00:00
4760	25	PORTO DA FOLHA	2010-03-11 00:00:00
4761	25	PROPRIÁ	2010-03-11 00:00:00
4762	25	RIACHÃO DO DANTAS	2010-03-11 00:00:00
4763	25	RIACHUELO	2010-03-11 00:00:00
4764	25	RIBEIROPÓLIS	2010-03-11 00:00:00
4765	25	ROSÁRIO DO CATETE	2010-03-11 00:00:00
4766	25	SALGADO	2010-03-11 00:00:00
4767	25	SANTA LUZIA DO ITANHY	2010-03-11 00:00:00
4768	25	SANTA ROSA DE LIMA	2010-03-11 00:00:00
4769	25	SANTANA DE SÃO FRANCISCO	2010-03-11 00:00:00
4770	25	SANTO AMARO DAS BROTAS	2010-03-11 00:00:00
4771	25	SÃO CRISTÓVÃO	2010-03-11 00:00:00
4772	25	SÃO DOMINGOS	2010-03-11 00:00:00
4773	25	SÃO FRANCISCO	2010-03-11 00:00:00
4774	25	SÃO MIGUEL DO ALEIXO	2010-03-11 00:00:00
4775	25	SIMÃO DIAS	2010-03-11 00:00:00
4776	25	SIRIRI	2010-03-11 00:00:00
4777	25	TELHA	2010-03-11 00:00:00
4778	25	TOBIAS BARRETO	2010-03-11 00:00:00
4779	25	TOMAR DO GERU	2010-03-11 00:00:00
4780	25	UMBAÚBA	2010-03-11 00:00:00
4781	26	ADAMANTINA	2010-03-11 00:00:00
4782	26	ADOLFO	2010-03-11 00:00:00
4783	26	AGUAI	2010-03-11 00:00:00
4784	26	ÁGUAS DA PRATA	2010-03-11 00:00:00
4785	26	ÁGUAS DE LINDÓIA	2010-03-11 00:00:00
4786	26	ÁGUAS DE SANTA BÁRBARA	2010-03-11 00:00:00
4787	26	ÁGUAS DE SÃO PEDRO	2010-03-11 00:00:00
4788	26	AGUDOS	2010-03-11 00:00:00
4789	26	ALAMBARI	2010-03-11 00:00:00
4790	26	ALFREDO MARCONDES	2010-03-11 00:00:00
4791	26	ALTAIR	2010-03-11 00:00:00
4792	26	ALTINÓPOLIS	2010-03-11 00:00:00
4793	26	ALTO ALEGRE	2010-03-11 00:00:00
4794	26	ALUMÍNIO	2010-03-11 00:00:00
4795	26	ALVARES FLORENCE	2010-03-11 00:00:00
4796	26	ALVARES MACHADO	2010-03-11 00:00:00
4797	26	ÁLVARO DE CARVALHO	2010-03-11 00:00:00
4798	26	ALVINLÂNDIA	2010-03-11 00:00:00
4799	26	AMERICANA	2010-03-11 00:00:00
4800	26	AMÉRICO BRASILIENSE	2010-03-11 00:00:00
4801	26	AMÉRICO DE CAMPOS	2010-03-11 00:00:00
4802	26	AMPARO	2010-03-11 00:00:00
4803	26	ANALÂNDIA	2010-03-11 00:00:00
4804	26	ANDRADINA	2010-03-11 00:00:00
4805	26	ANGATUBA	2010-03-11 00:00:00
4806	26	ANHEMBI	2010-03-11 00:00:00
4807	26	ANHUMAS	2010-03-11 00:00:00
4808	26	APARECIDA	2010-03-11 00:00:00
4809	26	APARECIDA D OESTE	2010-03-11 00:00:00
4810	26	APIAÍ	2010-03-11 00:00:00
4811	26	ARAÇARIGUAMA	2010-03-11 00:00:00
4812	26	ARAÇATUBA	2010-03-11 00:00:00
4813	26	ARAÇOIABA DA SERRA	2010-03-11 00:00:00
4814	26	ARAMINA	2010-03-11 00:00:00
4815	26	ARANDU	2010-03-11 00:00:00
4816	26	ARAPEÍ	2010-03-11 00:00:00
4817	26	ARARAQUARA	2010-03-11 00:00:00
4818	26	ARARAS	2010-03-11 00:00:00
4819	26	ARCO-ÍRIS	2010-03-11 00:00:00
4820	26	AREALVA	2010-03-11 00:00:00
4821	26	AREIAS	2010-03-11 00:00:00
4822	26	AREIÓPOLIS	2010-03-11 00:00:00
4823	26	ARIRANHA	2010-03-11 00:00:00
4824	26	ARTUR NOGUEIRA	2010-03-11 00:00:00
4825	26	ARUJÁ	2010-03-11 00:00:00
4826	26	ASPÁSIA	2010-03-11 00:00:00
4827	26	ASSIS	2010-03-11 00:00:00
4828	26	ATIBAIA	2010-03-11 00:00:00
4829	26	AURIFLAMA	2010-03-11 00:00:00
4830	26	AVAÍ	2010-03-11 00:00:00
4831	26	AVANHANDAVA	2010-03-11 00:00:00
4832	26	AVARÉ	2010-03-11 00:00:00
4833	26	BADY BASSITT	2010-03-11 00:00:00
4834	26	BALBINOS	2010-03-11 00:00:00
4835	26	BÁLSAMO	2010-03-11 00:00:00
4836	26	BANANAL	2010-03-11 00:00:00
4837	26	BARÃO DE ANTONINA	2010-03-11 00:00:00
4838	26	BARBOSA	2010-03-11 00:00:00
4839	26	BARIRI	2010-03-11 00:00:00
4840	26	BARRA BONITA	2010-03-11 00:00:00
4841	26	BARRA DO CHAPÉU	2010-03-11 00:00:00
4842	26	BARRA DO TURVO	2010-03-11 00:00:00
4843	26	BARRETOS	2010-03-11 00:00:00
4844	26	BARRINHA	2010-03-11 00:00:00
4845	26	BARUERI	2010-03-11 00:00:00
4846	26	BASTOS	2010-03-11 00:00:00
4847	26	BATATAIS	2010-03-11 00:00:00
4848	26	BAURU	2010-03-11 00:00:00
4849	26	BEBEDOURO	2010-03-11 00:00:00
4850	26	BENTO DE ABREU	2010-03-11 00:00:00
4851	26	BERNARDINO DE CAMPOS	2010-03-11 00:00:00
4852	26	BERTIOGA	2010-03-11 00:00:00
4853	26	BILAC	2010-03-11 00:00:00
4854	26	BIRIGUI	2010-03-11 00:00:00
4855	26	BIRITIBA-MIRIM	2010-03-11 00:00:00
4856	26	BOA ESPERANÇA DO SUL	2010-03-11 00:00:00
4857	26	BOCAINA	2010-03-11 00:00:00
4858	26	BOFETE	2010-03-11 00:00:00
4859	26	BOITUVA	2010-03-11 00:00:00
4860	26	BOM JESUS DOS PERDÕES	2010-03-11 00:00:00
4861	26	BOM SUCESSO DE ITARARÉ	2010-03-11 00:00:00
4862	26	BORÁ	2010-03-11 00:00:00
4863	26	BORACÉIA	2010-03-11 00:00:00
4864	26	BORBOREMA	2010-03-11 00:00:00
4865	26	BOREBI	2010-03-11 00:00:00
4866	26	BOTUCATU	2010-03-11 00:00:00
4867	26	BRAGANÇA PAULISTA	2010-03-11 00:00:00
4868	26	BRAÚNA	2010-03-11 00:00:00
4869	26	BREJO ALEGRE	2010-03-11 00:00:00
4870	26	BRODOSQUI	2010-03-11 00:00:00
4871	26	BROTAS	2010-03-11 00:00:00
4872	26	BURI	2010-03-11 00:00:00
4873	26	BURITAMA	2010-03-11 00:00:00
4874	26	BURITIZAL	2010-03-11 00:00:00
4875	26	CABRÁLIA PAULISTA	2010-03-11 00:00:00
4876	26	CABREÚVA	2010-03-11 00:00:00
4877	26	CAÇAPAVA	2010-03-11 00:00:00
4878	26	CACHOEIRA PAULISTA	2010-03-11 00:00:00
4879	26	CACONDE	2010-03-11 00:00:00
4880	26	CAFELÂNDIA	2010-03-11 00:00:00
4881	26	CAIABU	2010-03-11 00:00:00
4882	26	CAIEIRAS	2010-03-11 00:00:00
4883	26	CAIUA	2010-03-11 00:00:00
4884	26	CAJAMAR	2010-03-11 00:00:00
4885	26	CAJATI	2010-03-11 00:00:00
4886	26	CAJOBI	2010-03-11 00:00:00
4887	26	CAJURU	2010-03-11 00:00:00
4888	26	CAMPINA DO MONTE ALEGRE	2010-03-11 00:00:00
4889	26	CAMPINAS	2010-03-11 00:00:00
4890	26	CAMPO LIMPO PAULISTA	2010-03-11 00:00:00
4891	26	CAMPOS DO JORDÃO	2010-03-11 00:00:00
4892	26	CAMPOS NOVOS PAULISTA	2010-03-11 00:00:00
4893	26	CANANÉIA	2010-03-11 00:00:00
4894	26	CANAS	2010-03-11 00:00:00
4895	26	CÂNDIDO MOTA	2010-03-11 00:00:00
4896	26	CÂNDIDO RODRIGUES	2010-03-11 00:00:00
4897	26	CANITAR	2010-03-11 00:00:00
4898	26	CAPÃO BONITO	2010-03-11 00:00:00
4899	26	CAPELA DO ALTO	2010-03-11 00:00:00
4900	26	CAPIVARI	2010-03-11 00:00:00
4901	26	CARAGUATATUBA	2010-03-11 00:00:00
4902	26	CARAPICUÍBA	2010-03-11 00:00:00
4903	26	CARDOSO	2010-03-11 00:00:00
4904	26	CASA BRANCA	2010-03-11 00:00:00
4905	26	CÁSSIA DOS COQUEIROS	2010-03-11 00:00:00
4906	26	CASTILHO	2010-03-11 00:00:00
4907	26	CATANDUVA	2010-03-11 00:00:00
4908	26	CATIGUÁ	2010-03-11 00:00:00
4909	26	CEDRAL	2010-03-11 00:00:00
4910	26	CERQUEIRA CÉSAR	2010-03-11 00:00:00
4911	26	CERQUILHO	2010-03-11 00:00:00
4912	26	CESÁRIO LANGE	2010-03-11 00:00:00
4913	26	CHARQUEADA	2010-03-11 00:00:00
4914	26	CHAVANTES	2010-03-11 00:00:00
4915	26	CLEMENTINA	2010-03-11 00:00:00
4916	26	COLINA	2010-03-11 00:00:00
4917	26	COLÔMBIA	2010-03-11 00:00:00
4918	26	CONCHAL	2010-03-11 00:00:00
4919	26	CONCHAS	2010-03-11 00:00:00
4920	26	CORDEIRÓPOLIS	2010-03-11 00:00:00
4921	26	COROADOS	2010-03-11 00:00:00
4922	26	CORONEL MACEDO	2010-03-11 00:00:00
4923	26	CORUMBATAI	2010-03-11 00:00:00
4924	26	COSMÓPOLIS	2010-03-11 00:00:00
4925	26	COSMORAMA	2010-03-11 00:00:00
4926	26	COTIA	2010-03-11 00:00:00
4927	26	CRAVINHOS	2010-03-11 00:00:00
4928	26	CRISTAIS PAULISTA	2010-03-11 00:00:00
4929	26	CRUZÁLIA	2010-03-11 00:00:00
4930	26	CRUZEIRO	2010-03-11 00:00:00
4931	26	CUBATÃO	2010-03-11 00:00:00
4932	26	CUNHA	2010-03-11 00:00:00
4933	26	DESCALVADO	2010-03-11 00:00:00
4934	26	DIADEMA	2010-03-11 00:00:00
4935	26	DIRCE REIS	2010-03-11 00:00:00
4936	26	DIVINOLÂNDIA	2010-03-11 00:00:00
4937	26	DOBRADA	2010-03-11 00:00:00
4938	26	DOIS CÓRREGOS	2010-03-11 00:00:00
4939	26	DOLCINÓPOLIS	2010-03-11 00:00:00
4940	26	DOURADO	2010-03-11 00:00:00
4941	26	DRACENA	2010-03-11 00:00:00
4942	26	DUARTINA	2010-03-11 00:00:00
4943	26	DUMONT	2010-03-11 00:00:00
4944	26	ECHAPORÃ	2010-03-11 00:00:00
4945	26	ELDORADO	2010-03-11 00:00:00
4946	26	ELIAS FAUSTO	2010-03-11 00:00:00
4947	26	ELISIÁRIO	2010-03-11 00:00:00
4948	26	EMBAÚBA	2010-03-11 00:00:00
4949	26	EMBU	2010-03-11 00:00:00
4950	26	EMBU-GUAÇU	2010-03-11 00:00:00
4951	26	EMILIANÓPOLIS	2010-03-11 00:00:00
4952	26	ENGENHEIRO COELHO	2010-03-11 00:00:00
4953	26	ESPÍRITO SANTO DO PINHAL	2010-03-11 00:00:00
4954	26	ESPÍRITO SANTO DO TURVO	2010-03-11 00:00:00
4955	26	ESTIVA GERBI	2010-03-11 00:00:00
4956	26	ESTRELA D OESTE	2010-03-11 00:00:00
4957	26	ESTRELA DO NORTE	2010-03-11 00:00:00
4958	26	EUCLIDES DA CUNHA PAULISTA	2010-03-11 00:00:00
4959	26	FARTURA	2010-03-11 00:00:00
4960	26	FERNANDO PRESTES	2010-03-11 00:00:00
4961	26	FERNANDÓPOLIS	2010-03-11 00:00:00
4962	26	FERNÃO	2010-03-11 00:00:00
4963	26	FERRAZ DE VASCONCELOS	2010-03-11 00:00:00
4964	26	FLORA RICA	2010-03-11 00:00:00
4965	26	FLOREAL	2010-03-11 00:00:00
4966	26	FLÓRIDA PAULISTA	2010-03-11 00:00:00
4967	26	FLORÍNIA	2010-03-11 00:00:00
4968	26	FRANCA	2010-03-11 00:00:00
4969	26	FRANCISCO MORATO	2010-03-11 00:00:00
4970	26	FRANCO DA ROCHA	2010-03-11 00:00:00
4971	26	GABRIEL MONTEIRO	2010-03-11 00:00:00
4972	26	GÁLIA	2010-03-11 00:00:00
4973	26	GARÇA	2010-03-11 00:00:00
4974	26	GASTÃO VIDIGAL	2010-03-11 00:00:00
4975	26	GAVIÃO PEIXOTO	2010-03-11 00:00:00
4976	26	GENERAL SALGADO	2010-03-11 00:00:00
4977	26	GETULINA	2010-03-11 00:00:00
4978	26	GLICÉRIO	2010-03-11 00:00:00
4979	26	GUAIÇARA	2010-03-11 00:00:00
4980	26	GUAIMBÉ	2010-03-11 00:00:00
4981	26	GUAÍRA	2010-03-11 00:00:00
4982	26	GUAPIAÇU	2010-03-11 00:00:00
4983	26	GUAPIARA	2010-03-11 00:00:00
4984	26	GUARÁ	2010-03-11 00:00:00
4985	26	GUARAÇAÍ	2010-03-11 00:00:00
4986	26	GUARACI	2010-03-11 00:00:00
4987	26	GUARANI D OESTE	2010-03-11 00:00:00
4988	26	GUARANTÃ	2010-03-11 00:00:00
4989	26	GUARAPARES	2010-03-11 00:00:00
4990	26	GUARAREMA	2010-03-11 00:00:00
4991	26	GUARATINGUETÁ	2010-03-11 00:00:00
4992	26	GUAREÍ	2010-03-11 00:00:00
4993	26	GUARIBA	2010-03-11 00:00:00
4994	26	GUARUJÁ	2010-03-11 00:00:00
4995	26	GUARULHOS	2010-03-11 00:00:00
4996	26	GUATAPARA	2010-03-11 00:00:00
4997	26	GUZOLÂNDIA	2010-03-11 00:00:00
4998	26	HERCULÂNDIA	2010-03-11 00:00:00
4999	26	HOLAMBRA	2010-03-11 00:00:00
5000	26	HORTOLÂNDIA	2010-03-11 00:00:00
5001	26	IACANGA	2010-03-11 00:00:00
5002	26	IACRI	2010-03-11 00:00:00
5003	26	IARAS	2010-03-11 00:00:00
5004	26	IBATE	2010-03-11 00:00:00
5005	26	IBIRA	2010-03-11 00:00:00
5006	26	IBIRAREMA	2010-03-11 00:00:00
5007	26	IBITINGA	2010-03-11 00:00:00
5008	26	IBIUNA	2010-03-11 00:00:00
5009	26	ICEM	2010-03-11 00:00:00
5010	26	IEPÊ	2010-03-11 00:00:00
5011	26	IGARAÇU DO TIETÊ	2010-03-11 00:00:00
5012	26	IGARAPAVA	2010-03-11 00:00:00
5013	26	IGARATÁ	2010-03-11 00:00:00
5014	26	IGUAPE	2010-03-11 00:00:00
5015	26	ILHA COMPRIDA	2010-03-11 00:00:00
5016	26	ILHA SOLTEIRA	2010-03-11 00:00:00
5017	26	ILHABELA	2010-03-11 00:00:00
5018	26	INDAIATUBA	2010-03-11 00:00:00
5019	26	INDIANA	2010-03-11 00:00:00
5020	26	INDIAPORÃ	2010-03-11 00:00:00
5021	26	INÚBIA PAULISTA	2010-03-11 00:00:00
5022	26	IPAUSSU	2010-03-11 00:00:00
5023	26	IPERÓ	2010-03-11 00:00:00
5024	26	IPEUNA	2010-03-11 00:00:00
5025	26	IPIGUÁ	2010-03-11 00:00:00
5026	26	IPORANGA	2010-03-11 00:00:00
5027	26	IPUÃ	2010-03-11 00:00:00
5028	26	IRACEMÁPOLIS	2010-03-11 00:00:00
5029	26	IRAPUÃ	2010-03-11 00:00:00
5030	26	IRAPURU	2010-03-11 00:00:00
5031	26	ITABERA	2010-03-11 00:00:00
5032	26	ITAÍ	2010-03-11 00:00:00
5033	26	ITAJOBI	2010-03-11 00:00:00
5034	26	ITAJU	2010-03-11 00:00:00
5035	26	ITANHAEM	2010-03-11 00:00:00
5036	26	ITAÓCA	2010-03-11 00:00:00
5037	26	ITAPECERICA DA SERRA	2010-03-11 00:00:00
5038	26	ITAPETININGA	2010-03-11 00:00:00
5039	26	ITAPEVA	2010-03-11 00:00:00
5040	26	ITAPEVI	2010-03-11 00:00:00
5041	26	ITAPIRA	2010-03-11 00:00:00
5042	26	ITAPIRAPUÃ PAULISTA	2010-03-11 00:00:00
5043	26	ITÁPOLIS	2010-03-11 00:00:00
5044	26	ITAPORANGA	2010-03-11 00:00:00
5045	26	ITAPUI	2010-03-11 00:00:00
5046	26	ITAPURA	2010-03-11 00:00:00
5047	26	ITAQUAQUECETUBA	2010-03-11 00:00:00
5048	26	ITARARÉ	2010-03-11 00:00:00
5049	26	ITARIRI	2010-03-11 00:00:00
5050	26	ITATIBA	2010-03-11 00:00:00
5051	26	ITATINGA	2010-03-11 00:00:00
5052	26	ITIRAPINA	2010-03-11 00:00:00
5053	26	ITIRAPUÃ	2010-03-11 00:00:00
5054	26	ITOBI	2010-03-11 00:00:00
5055	26	ITU	2010-03-11 00:00:00
5056	26	ITUPEVA	2010-03-11 00:00:00
5057	26	ITUVERAVA	2010-03-11 00:00:00
5058	26	JABORANDI	2010-03-11 00:00:00
5059	26	JABOTICABAL	2010-03-11 00:00:00
5060	26	JACAREÍ	2010-03-11 00:00:00
5061	26	JACI	2010-03-11 00:00:00
5062	26	JACUPIRANGA	2010-03-11 00:00:00
5063	26	JAGUARIÚNA	2010-03-11 00:00:00
5064	26	JALES	2010-03-11 00:00:00
5065	26	JAMBEIRO	2010-03-11 00:00:00
5066	26	JANDIRA	2010-03-11 00:00:00
5067	26	JARDINÓPOLIS	2010-03-11 00:00:00
5068	26	JARINU	2010-03-11 00:00:00
5069	26	JAÚ	2010-03-11 00:00:00
5070	26	JERIQUARA	2010-03-11 00:00:00
5071	26	JOANÓPOLIS	2010-03-11 00:00:00
5072	26	JOÃO RAMALHO	2010-03-11 00:00:00
5073	26	JOSÉ BONIFÁCIO	2010-03-11 00:00:00
5074	26	JÚLIO MESQUITA	2010-03-11 00:00:00
5075	26	JUMIRIM	2010-03-11 00:00:00
5076	26	JUNDIAÍ	2010-03-11 00:00:00
5077	26	JUNQUEIRÓPOLIS	2010-03-11 00:00:00
5078	26	JUQUIÁ	2010-03-11 00:00:00
5079	26	JUQUITIBA	2010-03-11 00:00:00
5080	26	LAGOINHA	2010-03-11 00:00:00
5081	26	LARANJAL PAULISTA	2010-03-11 00:00:00
5082	26	LAVÍNIA	2010-03-11 00:00:00
5083	26	LAVRINHAS	2010-03-11 00:00:00
5084	26	LEME	2010-03-11 00:00:00
5085	26	LENÇÓIS PAULISTA	2010-03-11 00:00:00
5086	26	LIMEIRA	2010-03-11 00:00:00
5087	26	LINDÓIA	2010-03-11 00:00:00
5088	26	LINS	2010-03-11 00:00:00
5089	26	LORENA	2010-03-11 00:00:00
5090	26	LOURDES	2010-03-11 00:00:00
5091	26	LOUVEIRA	2010-03-11 00:00:00
5092	26	LUCÉLIA	2010-03-11 00:00:00
5093	26	LUCIANÓPOLIS	2010-03-11 00:00:00
5094	26	LUIS ANTÔNIO	2010-03-11 00:00:00
5095	26	LUIZIÂNIA	2010-03-11 00:00:00
5096	26	LUPÉRCIO	2010-03-11 00:00:00
5097	26	LUTÉCIA	2010-03-11 00:00:00
5098	26	MACATUBA	2010-03-11 00:00:00
5099	26	MACAUBAL	2010-03-11 00:00:00
5100	26	MACEDÔNIA	2010-03-11 00:00:00
5101	26	MAGDA	2010-03-11 00:00:00
5102	26	MAIRINQUE	2010-03-11 00:00:00
5103	26	MAIRIPORÃ	2010-03-11 00:00:00
5104	26	MANDURI	2010-03-11 00:00:00
5105	26	MARABÁ PAULISTA	2010-03-11 00:00:00
5106	26	MARACAÍ	2010-03-11 00:00:00
5107	26	MARAPOAMA	2010-03-11 00:00:00
5108	26	MARIÁPOLIS	2010-03-11 00:00:00
5109	26	MARÍLIA	2010-03-11 00:00:00
5110	26	MARINÓPOLIS	2010-03-11 00:00:00
5111	26	MARTINÓPOLIS	2010-03-11 00:00:00
5112	26	MATÃO	2010-03-11 00:00:00
5113	26	MAUÁ	2010-03-11 00:00:00
5114	26	MENDONÇA	2010-03-11 00:00:00
5115	26	MERIDIANO	2010-03-11 00:00:00
5116	26	MESÓPOLIS	2010-03-11 00:00:00
5117	26	MIGUELÓPOLIS	2010-03-11 00:00:00
5118	26	MINEIROS DO TIETÊ	2010-03-11 00:00:00
5119	26	MIRA ESTRELA	2010-03-11 00:00:00
5120	26	MIRACATU	2010-03-11 00:00:00
5121	26	MIRANDÓPOLIS	2010-03-11 00:00:00
5122	26	MIRANTE DO PARANAPANEMA	2010-03-11 00:00:00
5123	26	MIRASSOL	2010-03-11 00:00:00
5124	26	MIRASSOLÂNDIA	2010-03-11 00:00:00
5125	26	MOCOCA	2010-03-11 00:00:00
5126	26	MOJI DAS CRUZES	2010-03-11 00:00:00
5127	26	MOJI-GUAÇU	2010-03-11 00:00:00
5128	26	MOJI-MIRIM	2010-03-11 00:00:00
5129	26	MOMBUCA	2010-03-11 00:00:00
5130	26	MONÇÕES	2010-03-11 00:00:00
5131	26	MONGAGUÁ	2010-03-11 00:00:00
5132	26	MONTE ALEGRE DO SUL	2010-03-11 00:00:00
5133	26	MONTE ALTO	2010-03-11 00:00:00
5134	26	MONTE APRAZÍVEL	2010-03-11 00:00:00
5135	26	MONTE AZUL PAULISTA	2010-03-11 00:00:00
5136	26	MONTE CASTELO	2010-03-11 00:00:00
5137	26	MONTE MOR	2010-03-11 00:00:00
5138	26	MONTEIRO LOBATO	2010-03-11 00:00:00
5139	26	MORRO AGUDO	2010-03-11 00:00:00
5140	26	MORUNGABA	2010-03-11 00:00:00
5141	26	MOTUCA	2010-03-11 00:00:00
5142	26	MURUTINGA DO SUL	2010-03-11 00:00:00
5143	26	NANTES	2010-03-11 00:00:00
5144	26	NARANDIBA	2010-03-11 00:00:00
5145	26	NATIVIDADE DA SERRA	2010-03-11 00:00:00
5146	26	NAZARÉ PAULISTA	2010-03-11 00:00:00
5147	26	NEVES PAULISTA	2010-03-11 00:00:00
5148	26	NHANDEARA	2010-03-11 00:00:00
5149	26	NIPOÃ	2010-03-11 00:00:00
5150	26	NOVA ALIANÇA	2010-03-11 00:00:00
5151	26	NOVA CAMPINA	2010-03-11 00:00:00
5152	26	NOVA CANAÃ PAULISTA	2010-03-11 00:00:00
5153	26	NOVA CASTILHO	2010-03-11 00:00:00
5154	26	NOVA EUROPA	2010-03-11 00:00:00
5155	26	NOVA GRANADA	2010-03-11 00:00:00
5156	26	NOVA GUATAPORANGA	2010-03-11 00:00:00
5157	26	NOVA INDEPENDÊNCIA	2010-03-11 00:00:00
5158	26	NOVA LUZITÂNIA	2010-03-11 00:00:00
5159	26	NOVA ODESSA	2010-03-11 00:00:00
5160	26	NOVAIS	2010-03-11 00:00:00
5161	26	NOVO HORIZONTE	2010-03-11 00:00:00
5162	26	NUPORANGA	2010-03-11 00:00:00
5163	26	OCAUÇU	2010-03-11 00:00:00
5164	26	ÓLEO	2010-03-11 00:00:00
5165	26	OLÍMPIA	2010-03-11 00:00:00
5166	26	ONDA VERDE	2010-03-11 00:00:00
5167	26	ORIENTE	2010-03-11 00:00:00
5168	26	ORINDIUVA	2010-03-11 00:00:00
5169	26	ORLÂNDIA	2010-03-11 00:00:00
5170	26	OSASCO	2010-03-11 00:00:00
5171	26	OSCAR BRESSANE	2010-03-11 00:00:00
5172	26	OSVALDO CRUZ	2010-03-11 00:00:00
5173	26	OURINHOS	2010-03-11 00:00:00
5174	26	OURO VERDE	2010-03-11 00:00:00
5175	26	OUROESTE	2010-03-11 00:00:00
5176	26	PACAEMBU	2010-03-11 00:00:00
5177	26	PALESTINA	2010-03-11 00:00:00
5178	26	PALMARES PAULISTA	2010-03-11 00:00:00
5179	26	PALMEIRA D OESTE	2010-03-11 00:00:00
5180	26	PALMITAL	2010-03-11 00:00:00
5181	26	PANORAMA	2010-03-11 00:00:00
5182	26	PARAGUAÇU PAULISTA	2010-03-11 00:00:00
5183	26	PARAIBUNA	2010-03-11 00:00:00
5184	26	PARAÍSO	2010-03-11 00:00:00
5185	26	PARANAPANEMA	2010-03-11 00:00:00
5186	26	PARANAPUÃ	2010-03-11 00:00:00
5187	26	PARAPUÃ	2010-03-11 00:00:00
5188	26	PARDINHO	2010-03-11 00:00:00
5189	26	PARIQUERA-AÇU	2010-03-11 00:00:00
5190	26	PARISI	2010-03-11 00:00:00
5191	26	PATROCÍNIO PAULISTA	2010-03-11 00:00:00
5192	26	PAULICÉIA	2010-03-11 00:00:00
5193	26	PAULÍNIA	2010-03-11 00:00:00
5194	26	PAULISTÂNIA	2010-03-11 00:00:00
5195	26	PAULO DE FARIA	2010-03-11 00:00:00
5196	26	PEDERNEIRAS	2010-03-11 00:00:00
5197	26	PEDRA BELA	2010-03-11 00:00:00
5198	26	PEDRANÓPOLIS	2010-03-11 00:00:00
5199	26	PEDREGULHO	2010-03-11 00:00:00
5200	26	PEDREIRA	2010-03-11 00:00:00
5201	26	PEDRINHAS PAULISTA	2010-03-11 00:00:00
5202	26	PEDRO DE TOLEDO	2010-03-11 00:00:00
5203	26	PENÁPOLIS	2010-03-11 00:00:00
5204	26	PEREIRA BARRETO	2010-03-11 00:00:00
5205	26	PEREIRAS	2010-03-11 00:00:00
5206	26	PERUÍBE	2010-03-11 00:00:00
5207	26	PIACATU	2010-03-11 00:00:00
5208	26	PIEDADE	2010-03-11 00:00:00
5209	26	PILAR DO SUL	2010-03-11 00:00:00
5210	26	PINDAMONHANGABA	2010-03-11 00:00:00
5211	26	PINDORAMA	2010-03-11 00:00:00
5212	26	PINHALZINHO	2010-03-11 00:00:00
5213	26	PIQUEROBI	2010-03-11 00:00:00
5214	26	PIQUETE	2010-03-11 00:00:00
5215	26	PIRACAIA	2010-03-11 00:00:00
5216	26	PIRACICABA	2010-03-11 00:00:00
5217	26	PIRAJU	2010-03-11 00:00:00
5218	26	PIRAJUÍ	2010-03-11 00:00:00
5219	26	PIRANGI	2010-03-11 00:00:00
5220	26	PIRAPORA DO BOM JESUS	2010-03-11 00:00:00
5221	26	PIRAPOZINHO	2010-03-11 00:00:00
5222	26	PIRASSUNUNGA	2010-03-11 00:00:00
5223	26	PIRATININGA	2010-03-11 00:00:00
5224	26	PITANGUEIRAS	2010-03-11 00:00:00
5225	26	PLANALTO	2010-03-11 00:00:00
5226	26	PLATINA	2010-03-11 00:00:00
5227	26	POÁ	2010-03-11 00:00:00
5228	26	POLONI	2010-03-11 00:00:00
5229	26	POMPÉIA	2010-03-11 00:00:00
5230	26	PONGAI	2010-03-11 00:00:00
5231	26	PONTAL	2010-03-11 00:00:00
5232	26	PONTALINDA	2010-03-11 00:00:00
5233	26	PONTES GESTAL	2010-03-11 00:00:00
5234	26	POPULINA	2010-03-11 00:00:00
5235	26	PORANGABA	2010-03-11 00:00:00
5236	26	PORTO FELIZ	2010-03-11 00:00:00
5237	26	PORTO FERREIRA	2010-03-11 00:00:00
5238	26	POTIM	2010-03-11 00:00:00
5239	26	POTIRENDABA	2010-03-11 00:00:00
5240	26	PRACINHA	2010-03-11 00:00:00
5241	26	PRADÓPOLIS	2010-03-11 00:00:00
5242	26	PRAIA GRANDE	2010-03-11 00:00:00
5243	26	PRATÂNIA	2010-03-11 00:00:00
5244	26	PRESIDENTE ALVES	2010-03-11 00:00:00
5245	26	PRESIDENTE BERNARDES	2010-03-11 00:00:00
5246	26	PRESIDENTE EPITÁCIO	2010-03-11 00:00:00
5247	26	PRESIDENTE PRUDENTE	2010-03-11 00:00:00
5248	26	PRESIDENTE VENCESLAU	2010-03-11 00:00:00
5249	26	PROMISSÃO	2010-03-11 00:00:00
5250	26	QUADRA	2010-03-11 00:00:00
5251	26	QUATÁ	2010-03-11 00:00:00
5252	26	QUEIROZ	2010-03-11 00:00:00
5253	26	QUELUZ	2010-03-11 00:00:00
5254	26	QUINTANA	2010-03-11 00:00:00
5255	26	RAFARD	2010-03-11 00:00:00
5256	26	RANCHARIA	2010-03-11 00:00:00
5257	26	REDENÇÃO DA SERRA	2010-03-11 00:00:00
5258	26	REGENTE FEIJÓ	2010-03-11 00:00:00
5259	26	REGINÓPOLIS	2010-03-11 00:00:00
5260	26	REGISTRO	2010-03-11 00:00:00
5261	26	RESTINGA	2010-03-11 00:00:00
5262	26	RIBEIRA	2010-03-11 00:00:00
5263	26	RIBEIRÃO BONITO	2010-03-11 00:00:00
5264	26	RIBEIRÃO BRANCO	2010-03-11 00:00:00
5265	26	RIBEIRÃO CORRENTE	2010-03-11 00:00:00
5266	26	RIBEIRÃO DO SUL	2010-03-11 00:00:00
5267	26	RIBEIRÃO DOS ÍNDIOS	2010-03-11 00:00:00
5268	26	RIBEIRÃO GRANDE	2010-03-11 00:00:00
5269	26	RIBEIRÃO PIRES	2010-03-11 00:00:00
5270	26	RIBEIRÃO PRETO	2010-03-11 00:00:00
5271	26	RIFAINA	2010-03-11 00:00:00
5272	26	RINCÃO	2010-03-11 00:00:00
5273	26	RINÓPOLIS	2010-03-11 00:00:00
5274	26	RIO CLARO	2010-03-11 00:00:00
5275	26	RIO DAS PEDRAS	2010-03-11 00:00:00
5276	26	RIO GRANDE DA SERRA	2010-03-11 00:00:00
5277	26	RIOLÂNDIA	2010-03-11 00:00:00
5278	26	RIVERSUL	2010-03-11 00:00:00
5279	26	ROSANA	2010-03-11 00:00:00
5280	26	ROSEIRA	2010-03-11 00:00:00
5281	26	RUBIÁCEA	2010-03-11 00:00:00
5282	26	RUBINÉIA	2010-03-11 00:00:00
5283	26	SABINO	2010-03-11 00:00:00
5284	26	SAGRES	2010-03-11 00:00:00
5285	26	SALES	2010-03-11 00:00:00
5286	26	SALES OLIVEIRA	2010-03-11 00:00:00
5287	26	SALESÓPOLIS	2010-03-11 00:00:00
5288	26	SALMOURÃO	2010-03-11 00:00:00
5289	26	SALTINHO	2010-03-11 00:00:00
5290	26	SALTO	2010-03-11 00:00:00
5291	26	SALTO DE PIRAPORA	2010-03-11 00:00:00
5292	26	SALTO GRANDE	2010-03-11 00:00:00
5293	26	SANDOVALINA	2010-03-11 00:00:00
5294	26	SANTA ADÉLIA	2010-03-11 00:00:00
5295	26	SANTA ALBERTINA	2010-03-11 00:00:00
5296	26	SANTA BÁRBARA D OESTE	2010-03-11 00:00:00
5297	26	SANTA BRANCA	2010-03-11 00:00:00
5298	26	SANTA CLARA D OESTE	2010-03-11 00:00:00
5299	26	SANTA CRUZ DA CONCEIÇÃO	2010-03-11 00:00:00
5300	26	SANTA CRUZ DA ESPERANÇA	2010-03-11 00:00:00
5301	26	SANTA CRUZ DAS PALMEIRAS	2010-03-11 00:00:00
5302	26	SANTA CRUZ DO RIO PARDO	2010-03-11 00:00:00
5303	26	SANTA ERNESTINA	2010-03-11 00:00:00
5304	26	SANTA FÉ DO SUL	2010-03-11 00:00:00
5305	26	SANTA GERTRUDES	2010-03-11 00:00:00
5306	26	SANTA ISABEL	2010-03-11 00:00:00
5307	26	SANTA LÚCIA	2010-03-11 00:00:00
5308	26	SANTA MARIA DA SERRA	2010-03-11 00:00:00
5309	26	SANTA MERCEDES	2010-03-11 00:00:00
5310	26	SANTA RITA D OESTE	2010-03-11 00:00:00
5311	26	SANTA RITA DO PASSA QUATRO	2010-03-11 00:00:00
5312	26	SANTA ROSA DE VITERBO	2010-03-11 00:00:00
5313	26	SANTA SALETE	2010-03-11 00:00:00
5314	26	SANTANA DA PONTE PENSA	2010-03-11 00:00:00
5315	26	SANTANA DE PARNAÍBA	2010-03-11 00:00:00
5316	26	SANTO ANASTÁCIO	2010-03-11 00:00:00
5317	26	SANTO ANDRÉ	2010-03-11 00:00:00
5318	26	SANTO ANTÔNIO DA ALEGRIA	2010-03-11 00:00:00
5319	26	SANTO ANTÔNIO DE POSSE	2010-03-11 00:00:00
5320	26	SANTO ANTÔNIO DO ARACANGUÁ	2010-03-11 00:00:00
5321	26	SANTO ANTÔNIO DO JARDIM	2010-03-11 00:00:00
5322	26	SANTO ANTÔNIO DO PINHAL	2010-03-11 00:00:00
5323	26	SANTO EXPEDITO	2010-03-11 00:00:00
5324	26	SANTÓPOLIS DO AGUAPEÍ	2010-03-11 00:00:00
5325	26	SANTOS	2010-03-11 00:00:00
5326	26	SÃO BENTO DO SAPUCAÍ	2010-03-11 00:00:00
5327	26	SÃO BERNARDO DO CAMPO	2010-03-11 00:00:00
5328	26	SÃO CAETANO DO SUL	2010-03-11 00:00:00
5329	26	SÃO CARLOS	2010-03-11 00:00:00
5330	26	SÃO FRANCISCO	2010-03-11 00:00:00
5331	26	SÃO JOÃO DA BOA VISTA	2010-03-11 00:00:00
5332	26	SÃO JOÃO DAS DUAS PONTES	2010-03-11 00:00:00
5333	26	SÃO JOÃO DE IRACEMA	2010-03-11 00:00:00
5334	26	SÃO JOÃO DO PAU D ALHO	2010-03-11 00:00:00
5335	26	SÃO JOAQUIM DA BARRA	2010-03-11 00:00:00
5336	26	SÃO JOSÉ DA BELA VISTA	2010-03-11 00:00:00
5337	26	SÃO JOSÉ DO BARREIRO	2010-03-11 00:00:00
5338	26	SÃO JOSÉ DO RIO PARDO	2010-03-11 00:00:00
5339	26	SÃO JOSÉ DO RIO PRETO	2010-03-11 00:00:00
5340	26	SÃO JOSÉ DOS CAMPOS	2010-03-11 00:00:00
5341	26	SÃO LOURENÇO DA SERRA	2010-03-11 00:00:00
5342	26	SÃO LUÍS DO PARAITINGA	2010-03-11 00:00:00
5343	26	SÃO MANUEL	2010-03-11 00:00:00
5344	26	SÃO MIGUEL ARCANJO	2010-03-11 00:00:00
5345	26	SÃO PAULO	2010-03-11 00:00:00
5346	26	SÃO PEDRO	2010-03-11 00:00:00
5347	26	SÃO PEDRO DO TURVO	2010-03-11 00:00:00
5348	26	SÃO ROQUE	2010-03-11 00:00:00
5349	26	SÃO SEBASTIÃO	2010-03-11 00:00:00
5350	26	SÃO SEBASTIÃO DA GRAMA	2010-03-11 00:00:00
5351	26	SÃO SIMÃO	2010-03-11 00:00:00
5352	26	SÃO VICENTE	2010-03-11 00:00:00
5353	26	SARAPUÍ	2010-03-11 00:00:00
5354	26	SARUTAIA	2010-03-11 00:00:00
5355	26	SEBASTIANÓPOLIS DO SUL	2010-03-11 00:00:00
5356	26	SERRA AZUL	2010-03-11 00:00:00
5357	26	SERRA NEGRA	2010-03-11 00:00:00
5358	26	SERRANA	2010-03-11 00:00:00
5359	26	SERTÃOZINHO	2010-03-11 00:00:00
5360	26	SETE BARRAS	2010-03-11 00:00:00
5361	26	SEVERÍNIA	2010-03-11 00:00:00
5362	26	SILVEIRAS	2010-03-11 00:00:00
5363	26	SOCORRO	2010-03-11 00:00:00
5364	26	SOROCABA	2010-03-11 00:00:00
5365	26	SUD MENNUCCI	2010-03-11 00:00:00
5366	26	SUMARÉ	2010-03-11 00:00:00
5367	26	SUZANÁPOLIS	2010-03-11 00:00:00
5368	26	SUZANO	2010-03-11 00:00:00
5369	26	TABAPUÃ	2010-03-11 00:00:00
5370	26	TABATINGA	2010-03-11 00:00:00
5371	26	TABOÃO DA SERRA	2010-03-11 00:00:00
5372	26	TACIBA	2010-03-11 00:00:00
5373	26	TAGUAÍ	2010-03-11 00:00:00
5374	26	TAIAÇU	2010-03-11 00:00:00
5375	26	TAIÚVA	2010-03-11 00:00:00
5376	26	TAMBAÚ	2010-03-11 00:00:00
5377	26	TANABI	2010-03-11 00:00:00
5378	26	TAPIRAÍ	2010-03-11 00:00:00
5379	26	TAPIRATIBA	2010-03-11 00:00:00
5380	26	TAQUARAL	2010-03-11 00:00:00
5381	26	TAQUARITINGA	2010-03-11 00:00:00
5382	26	TAQUARITUBA	2010-03-11 00:00:00
5383	26	TAQUARIVAÍ	2010-03-11 00:00:00
5384	26	TARABAÍ	2010-03-11 00:00:00
5385	26	TARUMÃ	2010-03-11 00:00:00
5386	26	TATUÍ	2010-03-11 00:00:00
5387	26	TAUBATÉ	2010-03-11 00:00:00
5388	26	TEJUPA	2010-03-11 00:00:00
5389	26	TEODORO SAMPAIO	2010-03-11 00:00:00
5390	26	TERRA ROXA	2010-03-11 00:00:00
5391	26	TIETÊ	2010-03-11 00:00:00
5392	26	TIMBURI	2010-03-11 00:00:00
5393	26	TORRE DE PEDRA	2010-03-11 00:00:00
5394	26	TORRINHA	2010-03-11 00:00:00
5395	26	TRABIJU	2010-03-11 00:00:00
5396	26	TREMEMBÉ	2010-03-11 00:00:00
5397	26	TRÊS FRONTEIRAS	2010-03-11 00:00:00
5398	26	TUIUTI	2010-03-11 00:00:00
5399	26	TUPÃ	2010-03-11 00:00:00
5400	26	TUPI PAULISTA	2010-03-11 00:00:00
5401	26	TURIÚBA	2010-03-11 00:00:00
5402	26	TURMALINA	2010-03-11 00:00:00
5403	26	UBARANA	2010-03-11 00:00:00
5404	26	UBATUBA	2010-03-11 00:00:00
5405	26	UBIRAJARA	2010-03-11 00:00:00
5406	26	UCHOA	2010-03-11 00:00:00
5407	26	UNIÃO PAULISTA	2010-03-11 00:00:00
5408	26	URÂNIA	2010-03-11 00:00:00
5409	26	URU	2010-03-11 00:00:00
5410	26	URUPÊS	2010-03-11 00:00:00
5411	26	VALENTIM GENTIL	2010-03-11 00:00:00
5412	26	VALINHOS	2010-03-11 00:00:00
5413	26	VALPARAÍSO	2010-03-11 00:00:00
5414	26	VARGEM	2010-03-11 00:00:00
5415	26	VARGEM GRANDE DO SUL	2010-03-11 00:00:00
5416	26	VARGEM GRANDE PAULISTA	2010-03-11 00:00:00
5417	26	VÁRZEA PAULISTA	2010-03-11 00:00:00
5418	26	VERA CRUZ	2010-03-11 00:00:00
5419	26	VINHEDO	2010-03-11 00:00:00
5420	26	VIRADOURO	2010-03-11 00:00:00
5421	26	VISTA ALEGRE DO ALTO	2010-03-11 00:00:00
5422	26	VITÓRIA BRASIL	2010-03-11 00:00:00
5423	26	VOTORANTIM	2010-03-11 00:00:00
5424	26	VOTUPORANGA	2010-03-11 00:00:00
5425	26	ZACARIAS	2010-03-11 00:00:00
5426	27	ABREULÂNDIA	2010-03-11 00:00:00
5427	27	AGUIARNÓPOLIS	2010-03-11 00:00:00
5428	27	ALIANÇA DO TOCANTINS	2010-03-11 00:00:00
5429	27	ALMAS	2010-03-11 00:00:00
5430	27	ALVORADA	2010-03-11 00:00:00
5431	27	ANANAS	2010-03-11 00:00:00
5432	27	ANGICO	2010-03-11 00:00:00
5433	27	APARECIDA DO RIO NEGRO	2010-03-11 00:00:00
5434	27	ARAGOMINAS	2010-03-11 00:00:00
5435	27	ARAGUACEMA	2010-03-11 00:00:00
5436	27	ARAGUAÇU	2010-03-11 00:00:00
5437	27	ARAGUAÍNA	2010-03-11 00:00:00
5438	27	ARAGUANÃ	2010-03-11 00:00:00
5439	27	ARAGUATINS	2010-03-11 00:00:00
5440	27	ARAPOEMA	2010-03-11 00:00:00
5441	27	ARRAIAS	2010-03-11 00:00:00
5442	27	AUGUSTINÓPOLIS	2010-03-11 00:00:00
5443	27	AURORA DO TOCANTINS	2010-03-11 00:00:00
5444	27	AXIXÁ DO TOCANTINS	2010-03-11 00:00:00
5445	27	BABAÇULÂNDIA	2010-03-11 00:00:00
5446	27	BANDEIRANTES DO TOCANTINS	2010-03-11 00:00:00
5447	27	BARRA DO OURO	2010-03-11 00:00:00
5448	27	BARROLÂNDIA	2010-03-11 00:00:00
5449	27	BERNARDO SAYÃO	2010-03-11 00:00:00
5450	27	BOM JESUS DO TOCANTINS	2010-03-11 00:00:00
5451	27	BRASILÂNDIA DO TOCANTINS	2010-03-11 00:00:00
5452	27	BREJINHO DE NAZARÉ	2010-03-11 00:00:00
5453	27	BURITI DO TOCANTINS	2010-03-11 00:00:00
5454	27	CACHOEIRINHA	2010-03-11 00:00:00
5455	27	CAMPOS LINDOS	2010-03-11 00:00:00
5456	27	CARIRI DO TOCANTINS	2010-03-11 00:00:00
5457	27	CARMOLÂNDIA	2010-03-11 00:00:00
5458	27	CARRASCO BONITO	2010-03-11 00:00:00
5459	27	CASEARA	2010-03-11 00:00:00
5460	27	CENTENÁRIO	2010-03-11 00:00:00
5461	27	CHAPADA DA NATIVIDADE	2010-03-11 00:00:00
5462	27	CHAPADA DE AREIA	2010-03-11 00:00:00
5463	27	COLINAS DO TOCANTINS	2010-03-11 00:00:00
5464	27	COLMÉIA	2010-03-11 00:00:00
5465	27	COMBINADO	2010-03-11 00:00:00
5466	27	CONCEIÇÃO DO TOCANTINS	2010-03-11 00:00:00
5467	27	COUTO DE MAGALHÃES	2010-03-11 00:00:00
5468	27	CRISTALÂNDIA	2010-03-11 00:00:00
5469	27	CRIXAS DO TOCANTINS	2010-03-11 00:00:00
5470	27	DARCINÓPOLIS	2010-03-11 00:00:00
5471	27	DIANÓPOLIS	2010-03-11 00:00:00
5472	27	DIVINÓPOLIS DO TOCANTINS	2010-03-11 00:00:00
5473	27	DOIS IRMÃOS DO TOCANTINS	2010-03-11 00:00:00
5474	27	DUERE	2010-03-11 00:00:00
5475	27	ESPERANTINA	2010-03-11 00:00:00
5476	27	FÁTIMA	2010-03-11 00:00:00
5477	27	FIGUEIRÓPOLIS	2010-03-11 00:00:00
5478	27	FILADÉLFIA	2010-03-11 00:00:00
5479	27	FORMOSO DO ARAGUAIA	2010-03-11 00:00:00
5480	27	FORTALEZA DO TABOCÃO	2010-03-11 00:00:00
5481	27	GOIANORTE	2010-03-11 00:00:00
5482	27	GOIATINS	2010-03-11 00:00:00
5483	27	GUARAÍ	2010-03-11 00:00:00
5484	27	GURUPI	2010-03-11 00:00:00
5485	27	IPUEIRAS	2010-03-11 00:00:00
5486	27	ITACAJÁ	2010-03-11 00:00:00
5487	27	ITAGUATINS	2010-03-11 00:00:00
5488	27	ITAPIRATINS	2010-03-11 00:00:00
5489	27	ITAPORÃ DO TOCANTINS	2010-03-11 00:00:00
5490	27	JAÚ DO TOCANTINS	2010-03-11 00:00:00
5491	27	JUARINA	2010-03-11 00:00:00
5492	27	LAGOA DA CONFUSÃO	2010-03-11 00:00:00
5493	27	LAGOA DO TOCANTINS	2010-03-11 00:00:00
5494	27	LAJEADO	2010-03-11 00:00:00
5495	27	LAVANDEIRA	2010-03-11 00:00:00
5496	27	LIZARDA	2010-03-11 00:00:00
5497	27	LUZINÓPOLIS	2010-03-11 00:00:00
5498	27	MARIANÓPOLIS DO TOCANTINS	2010-03-11 00:00:00
5499	27	MATEIROS	2010-03-11 00:00:00
5500	27	MAURILÂNDIA DO TOCANTINS	2010-03-11 00:00:00
5501	27	MIRACEMA DO TOCANTINS	2010-03-11 00:00:00
5502	27	MIRANORTE	2010-03-11 00:00:00
5503	27	MONTE DO CARMO	2010-03-11 00:00:00
5504	27	MONTE SANTO DO TOCANTINS	2010-03-11 00:00:00
5505	27	MURICILÂNDIA	2010-03-11 00:00:00
5506	27	NATIVIDADE	2010-03-11 00:00:00
5507	27	NAZARÉ	2010-03-11 00:00:00
5508	27	NOVA OLINDA	2010-03-11 00:00:00
5509	27	NOVA ROSALÂNDIA	2010-03-11 00:00:00
5510	27	NOVO ACORDO	2010-03-11 00:00:00
5511	27	NOVO ALEGRE	2010-03-11 00:00:00
5512	27	NOVO JARDIM	2010-03-11 00:00:00
5513	27	OLIVEIRA DE FÁTIMA	2010-03-11 00:00:00
5514	27	PALMAS	2010-03-11 00:00:00
5515	27	PALMEIRANTE	2010-03-11 00:00:00
5516	27	PALMEIRAS DO TOCANTINS	2010-03-11 00:00:00
5517	27	PALMEIRÓPOLIS	2010-03-11 00:00:00
5518	27	PARAÍSO DO TOCANTINS	2010-03-11 00:00:00
5519	27	PARANÃ	2010-03-11 00:00:00
5520	27	PAU D ARCO	2010-03-11 00:00:00
5521	27	PEDRO AFONSO	2010-03-11 00:00:00
5522	27	PEIXE	2010-03-11 00:00:00
5523	27	PEQUIZEIRO	2010-03-11 00:00:00
5524	27	PINDORAMA DO TOCANTINS	2010-03-11 00:00:00
5525	27	PIRAQUÊ	2010-03-11 00:00:00
5526	27	PIUM	2010-03-11 00:00:00
5527	27	PONTE ALTA DO BOM JESUS	2010-03-11 00:00:00
5528	27	PONTE ALTA DO TOCANTINS	2010-03-11 00:00:00
5529	27	PORTO ALEGRE DO TOCANTINS	2010-03-11 00:00:00
5530	27	PORTO NACIONAL	2010-03-11 00:00:00
5531	27	PRAIA NORTE	2010-03-11 00:00:00
5532	27	PRESIDENTE KENNEDY	2010-03-11 00:00:00
5533	27	PUGMIL	2010-03-11 00:00:00
5534	27	RECURSOLÂNDIA	2010-03-11 00:00:00
5535	27	RIACHINHO	2010-03-11 00:00:00
5536	27	RIO DA CONCEIÇÃO	2010-03-11 00:00:00
5537	27	RIO DOS BOIS	2010-03-11 00:00:00
5538	27	RIO SONO	2010-03-11 00:00:00
5539	27	SAMPAIO	2010-03-11 00:00:00
5540	27	SANDOLÂNDIA	2010-03-11 00:00:00
5541	27	SANTA FÉ DO ARAGUAIA	2010-03-11 00:00:00
5542	27	SANTA MARIA DO TOCANTINS	2010-03-11 00:00:00
5543	27	SANTA RITA DO TOCANTINS	2010-03-11 00:00:00
5544	27	SANTA ROSA DO TOCANTINS	2010-03-11 00:00:00
5545	27	SANTA TEREZA DO TOCANTINS	2010-03-11 00:00:00
5546	27	SANTA TEREZINHA DO TOCANTINS	2010-03-11 00:00:00
5547	27	SÃO BENTO DO TOCANTINS	2010-03-11 00:00:00
5548	27	SÃO FÉLIX DO TOCANTINS	2010-03-11 00:00:00
5549	27	SÃO MIGUEL DO TOCANTINS	2010-03-11 00:00:00
5550	27	SÃO SALVADOR DO TOCANTINS	2010-03-11 00:00:00
5551	27	SÃO SEBASTIÃO DO TOCANTINS	2010-03-11 00:00:00
5552	27	SÃO VALÉRIO DA NATIVIDADE	2010-03-11 00:00:00
5553	27	SILVANÓPOLIS	2010-03-11 00:00:00
5554	27	SÍTIO NOVO DO TOCANTINS	2010-03-11 00:00:00
5555	27	SUCUPIRA	2010-03-11 00:00:00
5556	27	TAGUATINGA	2010-03-11 00:00:00
5557	27	TAIPAS DO TOCANTINS	2010-03-11 00:00:00
5558	27	TALISMÃ	2010-03-11 00:00:00
5559	27	TOCANTÍNIA	2010-03-11 00:00:00
5560	27	TOCANTINÓPOLIS	2010-03-11 00:00:00
5561	27	TUPIRAMA	2010-03-11 00:00:00
5562	27	TUPIRATINS	2010-03-11 00:00:00
5563	27	WANDERLÂNDIA	2010-03-11 00:00:00
5564	27	XAMBIOÁ	2010-03-11 00:00:00
1346	11	ABADIA DOS DOURADOS	2010-03-11 00:00:00
2418	14	ABAETETUBA	2010-03-11 00:00:00
3	1	Pelotas	2010-03-11 00:00:00
\.


--
-- Name: cidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cidades_id_seq', 5564, true);


--
-- Data for Name: configuracao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY configuracao (id, nome_perfil, email, senha, email_administrador, dt_cadastro, email_administrador_2) FROM stdin;
1	padrao	contatopeoplegrid@gmail.com	admin#peoplegrid	mauricio.polidori@gmail.com	2015-03-03 14:13:44.712258-03	otmperes@gmail.com
\.


--
-- Name: configuracao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('configuracao_id_seq', 1, true);


--
-- Data for Name: empresas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY empresas (id, nome, cnpj, dt_cadastro) FROM stdin;
1	Administração	\N	2010-01-07
5	PeopleGrid	\N	2014-08-01
6	PeoplePlan	\N	2016-11-09
\.


--
-- Name: empresas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('empresas_id_seq', 6, true);


--
-- Data for Name: empresas_perfis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY empresas_perfis (empresa_id, perfil_id) FROM stdin;
1	1
5	6
5	5
6	6
6	5
\.


--
-- Data for Name: enderecos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY enderecos (id, pessoa_id, endereco_tipo_id, cidade_id, cep, rua, numero, bairro, complemento, dt_cadastro) FROM stdin;
\.


--
-- Name: enderecos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('enderecos_id_seq', 1, false);


--
-- Data for Name: enderecos_tipos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY enderecos_tipos (id, descricao, flg_tipo, dt_cadastro) FROM stdin;
\.


--
-- Name: enderecos_tipos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('enderecos_tipos_id_seq', 1, false);


--
-- Data for Name: estados_civis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY estados_civis (id, descricao) FROM stdin;
8	SOLTEIRO
9	CASADO
10	VIUVO
11	DIVORCIADO
12	DESQUITADO
13	OUTROS
\.


--
-- Name: estados_civis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('estados_civis_id_seq', 13, true);


--
-- Data for Name: grupos_acessos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY grupos_acessos (id, nome, dt_cadastro) FROM stdin;
1	ADMINISTRADOR	2012-04-26 00:00:00
2	GERENCIADOR	2014-04-28 09:55:49.428184
3	PESQUISADOR	2014-05-07 17:02:47.333651
\.


--
-- Data for Name: grupos_acessos_empresas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY grupos_acessos_empresas (id, grupo_acesso_id, empresa_id) FROM stdin;
1	1	1
8	1	5
9	2	5
10	3	5
11	1	6
12	2	6
13	3	6
\.


--
-- Name: grupos_acessos_empresas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('grupos_acessos_empresas_id_seq', 13, true);


--
-- Name: grupos_acessos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('grupos_acessos_id_seq', 3, true);


--
-- Data for Name: grupos_acessos_perfis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY grupos_acessos_perfis (id, grupo_acesso_id, empresa_id, perfil_id) FROM stdin;
10	1	1	1
12	1	5	6
13	1	5	5
14	2	5	5
15	2	5	6
19	3	5	5
20	2	6	6
21	2	6	5
22	1	6	6
23	1	6	5
26	3	6	5
\.


--
-- Name: grupos_acessos_perfis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('grupos_acessos_perfis_id_seq', 26, true);


--
-- Data for Name: grupos_acessos_programas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY grupos_acessos_programas (id, grupo_acesso_id, empresa_id, perfil_id, programa_id, dt_cadastro) FROM stdin;
666	1	1	1	8	2016-12-13 17:26:39.91325
667	1	1	1	9	2016-12-13 17:26:39.91325
668	1	1	1	3	2016-12-13 17:26:39.91325
669	1	1	1	10	2016-12-13 17:26:39.91325
670	1	1	1	1	2016-12-13 17:26:39.91325
671	1	1	1	4	2016-12-13 17:26:39.91325
672	1	1	1	2	2016-12-13 17:26:39.91325
673	1	1	1	5	2016-12-13 17:26:39.91325
674	1	5	6	19	2016-12-13 17:26:39.91325
675	1	5	6	26	2016-12-13 17:26:39.91325
676	1	5	6	28	2016-12-13 17:26:39.91325
677	1	5	6	29	2016-12-13 17:26:39.91325
678	1	5	6	30	2016-12-13 17:26:39.91325
679	1	5	6	31	2016-12-13 17:26:39.91325
680	1	5	6	32	2016-12-13 17:26:39.91325
681	1	5	5	19	2016-12-13 17:26:39.91325
682	1	5	5	22	2016-12-13 17:26:39.91325
683	1	5	5	23	2016-12-13 17:26:39.91325
684	1	5	5	24	2016-12-13 17:26:39.91325
685	1	5	5	21	2016-12-13 17:26:39.91325
686	1	5	5	25	2016-12-13 17:26:39.91325
687	1	6	6	28	2016-12-13 17:26:39.91325
688	1	6	6	36	2016-12-13 17:26:39.91325
689	1	6	6	37	2016-12-13 17:26:39.91325
690	1	6	5	19	2016-12-13 17:26:39.91325
691	1	6	5	33	2016-12-13 17:26:39.91325
692	1	6	5	34	2016-12-13 17:26:39.91325
693	1	6	5	21	2016-12-13 17:26:39.91325
694	1	6	5	35	2016-12-13 17:26:39.91325
695	2	5	5	19	2016-12-13 17:26:54.695069
696	2	5	5	22	2016-12-13 17:26:54.695069
697	2	5	5	23	2016-12-13 17:26:54.695069
698	2	5	5	24	2016-12-13 17:26:54.695069
699	2	5	5	21	2016-12-13 17:26:54.695069
700	2	5	5	25	2016-12-13 17:26:54.695069
701	2	5	6	19	2016-12-13 17:26:54.695069
702	2	5	6	26	2016-12-13 17:26:54.695069
703	2	5	6	28	2016-12-13 17:26:54.695069
704	2	5	6	29	2016-12-13 17:26:54.695069
705	2	5	6	30	2016-12-13 17:26:54.695069
706	2	5	6	31	2016-12-13 17:26:54.695069
707	2	5	6	32	2016-12-13 17:26:54.695069
708	2	6	6	28	2016-12-13 17:26:54.695069
709	2	6	6	36	2016-12-13 17:26:54.695069
710	2	6	6	37	2016-12-13 17:26:54.695069
711	2	6	5	19	2016-12-13 17:26:54.695069
712	2	6	5	33	2016-12-13 17:26:54.695069
713	2	6	5	34	2016-12-13 17:26:54.695069
714	2	6	5	21	2016-12-13 17:26:54.695069
715	2	6	5	35	2016-12-13 17:26:54.695069
716	3	5	5	19	2016-12-13 17:27:05.229486
717	3	5	5	22	2016-12-13 17:27:05.229486
718	3	5	5	23	2016-12-13 17:27:05.229486
719	3	5	5	24	2016-12-13 17:27:05.229486
720	3	5	5	21	2016-12-13 17:27:05.229486
721	3	5	5	25	2016-12-13 17:27:05.229486
722	3	6	5	19	2016-12-13 17:27:05.229486
723	3	6	5	33	2016-12-13 17:27:05.229486
724	3	6	5	34	2016-12-13 17:27:05.229486
725	3	6	5	21	2016-12-13 17:27:05.229486
726	3	6	5	35	2016-12-13 17:27:05.229486
\.


--
-- Name: grupos_acessos_programas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('grupos_acessos_programas_id_seq', 726, true);


--
-- Data for Name: grupos_acessos_programas_permissoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY grupos_acessos_programas_permissoes (id, grupo_acesso_id, sys_metodo_id, dt_cadastro) FROM stdin;
1	1	34	2012-04-26 00:00:00
2	1	36	2012-04-26 00:00:00
3	1	38	2012-04-26 00:00:00
4	1	35	2012-04-26 00:00:00
5	1	39	2012-04-26 00:00:00
6	1	44	2012-04-26 00:00:00
\.


--
-- Name: grupos_acessos_programas_permissoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('grupos_acessos_programas_permissoes_id_seq', 13, true);


--
-- Data for Name: log_fields; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY log_fields (id, log_table_id, field_name, old_value, new_value) FROM stdin;
\.


--
-- Name: log_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('log_fields_id_seq', 1, false);


--
-- Data for Name: log_fields_structures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY log_fields_structures (id, log_table_structure_id, field_name) FROM stdin;
\.


--
-- Name: log_fields_structures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('log_fields_structures_id_seq', 1, false);


--
-- Data for Name: log_tables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY log_tables (id, table_name, table_id, flg_action, dt_register) FROM stdin;
\.


--
-- Name: log_tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('log_tables_id_seq', 1, false);


--
-- Data for Name: log_tables_structures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY log_tables_structures (id, table_name) FROM stdin;
\.


--
-- Name: log_tables_structures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('log_tables_structures_id_seq', 1, false);


--
-- Data for Name: parametros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY parametros (id, nome, descricao, valor, dt_cadastro) FROM stdin;
\.


--
-- Name: parametros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('parametros_id_seq', 1, false);


--
-- Data for Name: perfis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY perfis (id, nome_perfil, flg_ativo, dt_cadastro) FROM stdin;
1	Sistema	S	2010-01-07
6	Gerenciador	S	2014-08-01
5	Pesquisador	S	2014-08-01
\.


--
-- Name: perfis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('perfis_id_seq', 6, true);


--
-- Data for Name: perfis_programas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY perfis_programas (id, perfil_id, programa_id, programa_pai, ordem, flg_ativo) FROM stdin;
16	1	9	8	1	S
17	1	3	8	2	S
18	1	8	0	0	S
240	1	10	8	4	S
250	1	1	0	3	S
251	1	4	1	1	S
252	1	2	1	2	S
253	1	5	1	3	S
259	5	19	0	0	S
258	5	21	0	1	S
263	5	25	21	1	S
264	6	26	19	1	S
267	6	19	0	0	S
256	6	28	0	1	S
272	6	31	0	2	S
273	6	32	31	1	S
277	5	35	21	2	S
268	6	29	28	0	S
269	6	30	28	1	S
278	6	36	28	2	S
279	6	37	28	3	S
262	5	22	19	0	S
261	5	23	19	1	S
260	5	24	19	2	S
274	5	33	19	3	S
275	5	34	19	5	S
\.


--
-- Name: perfis_programas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('perfis_programas_id_seq', 280, true);


--
-- Data for Name: pessoas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pessoas (id, nome, cpf, rg, estado_civil_id, sexo, dt_nascimento, nome_pai, nome_mae, telefone, celular, email, observacao, dt_cadastro, orgao_emissor_rg, orgao_emissor_rg_unidade_federativa_id, flg_mao_escrita, nacionalidade, dt_atualizacao_gol, nr_titulo_eleitor, hash_ativacao, email_ativacao, senha_ativacao, foto_carteira_id, cod_carteira, pessoa_tipo_id, nome_consulta) FROM stdin;
5	ANDRÉ PEIL	01767688075	6102931612	\N	M	2991-01-01	\N	\N	\N	\N	andreguipeil@gmail.com	\N	2014-05-07 17:42:41.027224	\N	\N	D	\N	\N	\N	\N	\N	\N	\N	\N	\N	ANDRE PEIL
1	ADMINISTRADOR DO SISTEMA	12345678910		\N	M	2013-01-01	\N	\N	\N	\N	administrador@localhost	\N	2010-02-18 22:00:01	\N	\N	D	\N	\N	\N	\N	\N	\N	\N	\N	\N	ADMINISTRADOR DO SISTEMA
4	MAURICIO COUTO POLIDORI			\N	M	2950-01-01	\N	\N	\N	\N		\N	2014-04-28 10:44:30.040893	\N	\N	D	\N	\N	\N	\N	\N	\N	\N	\N	\N	MAURICIO COUTO POLIDORI
13	OTÁVIO MARTINS PERES			\N	M	\N	\N	\N	\N	\N		\N	2014-06-05 11:21:30.613097	\N	\N	D	\N	\N	\N	\N	\N	\N	\N	\N	\N	OTAVIO MARTINS PERES
15	EDUARDO ROCHA			\N	M	\N	\N	\N		\N	amigodudu@yahoo.com.br	\N	2014-06-05 15:37:56.798849	\N	\N	D	\N	\N	\N	\N	\N	\N	\N	\N	\N	EDUARDO ROCHA
14	GLAUCO ROBERTO			\N	M	\N	\N	\N		\N	glaucomusnberg@gmail.com	\N	2014-06-05 11:40:04.484539	\N	\N	D	\N	\N	\N	\N	\N	\N	\N	\N	\N	GLAUCO ROBERTO
16	RUBENS	\N	\N	\N	M	1982-11-21	\N	\N		\N	lottuxx@gmail.com	\N	2015-04-17 16:38:03.022363	\N	\N	D	\N	\N	\N	\N	\N	\N	\N	\N	\N	RUBENS
17	FELIPE LOPES	\N	\N	\N	M	1991-05-26	\N	\N		\N	fdloopes@gmail.com	\N	2016-11-30 19:42:35.138621	\N	\N	D	\N	\N	\N	\N	\N	\N	\N	\N	\N	FELIPE LOPES
\.


--
-- Name: pessoas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pessoas_id_seq', 17, true);


--
-- Data for Name: pessoas_tipos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pessoas_tipos (id, tipo, dt_cadastro) FROM stdin;
\.


--
-- Name: pessoas_tipos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pessoas_tipos_id_seq', 1, false);


--
-- Data for Name: programas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY programas (id, nome_programa, descricao, link, onclick, dt_cadastro) FROM stdin;
1	Gerenciador				2008-04-02
4	Parâmetros		gerenciador/parametro		2008-04-02
2	Programas		gerenciador/programa		2008-04-02
3	Módulos		gerenciador/perfil		2008-04-02
5	Setores		gerenciador/empresa		2008-04-05
9	Usuários		gerenciador/usuario		2008-04-09
10	Grupos de Acesso	Montar os itens de menu que o grupo poderá visualizar	gerenciador/grupoAcesso		2012-04-26
8	Usuários e Módulos				2008-04-09
17	Gerenciar				2014-06-16
19	Cadastrar				2014-08-01
21	Relatórios	de Pesquisador			2014-08-01
20	Relatórios	de Gerenciador			2014-08-01
24	Questionários		pesquisador/questionario		2014-08-01
22	Perguntas em Grid		pesquisador/pergunta		2014-08-01
27	Questionários Resultados				2014-08-01
25	Resultado de Questionários		pesquisador/resultado		2014-08-01
23	Perguntas Dinâmicas		pesquisador/perguntaDinamica		2014-08-01
28	Pesquisas				2015-03-03
29	Questionários		coordenador/pesquisa		2015-03-03
30	Perguntas		coordenador/perguntas		2015-03-03
26	Pesquisadores		coordenador/pesquisador		2014-08-01
31	Configurações				2015-03-03
32	Email do Servidor		gerenciador/configuracao		2015-03-03
35	Resultado de Questionários		pesquisador/peopleplanResultado		2016-11-09
36	Perguntas		coordenador/peopleplanPerguntas		2016-11-29
37	Questionários		coordenador/peopleplanPesquisa		2016-11-30
34	Perguntas		pesquisador/peopleplanQuestionario		2016-11-09
33	Critérios		pesquisador/peopleplanPergunta		2016-11-09
\.


--
-- Name: programas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('programas_id_seq', 38, true);


--
-- Data for Name: programas_parametros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY programas_parametros (id, programa_id, nome, dt_cadastro) FROM stdin;
\.


--
-- Name: programas_parametros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('programas_parametros_id_seq', 1, false);


--
-- Data for Name: sys_metodos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sys_metodos (id, classe, metodo, apelido, privado, dt_cadastro) FROM stdin;
34	gerenciador/usuario	novo	gerenciador/usuario/novo	1	2011-01-25 00:00:00
36	gerenciador/usuario	salvar	gerenciador/usuario/salvar	1	2011-01-25 00:00:00
37	academico/cadastros/curso	novo	academico/cadastros/curso/novo	1	2011-01-25 00:00:00
38	gerenciador/usuario	incluirEmpresa	gerenciador/usuario/incluirEmpresa	1	2011-01-25 00:00:00
35	gerenciador/usuario	editar	gerenciador/usuario/editar	0	2011-01-25 00:00:00
39	gerenciador/usuario	salvarUsuarioProgramaAcessos	gerenciador/usuario/salvarUsuarioProgramaAcessos	1	2011-01-27 00:00:00
40	academico/cadastros/disciplina	novo	academico/cadastros/disciplina/novo	1	2011-01-27 00:00:00
41	academico/cadastros/disciplina	salvar	academico/cadastros/disciplina/salvar	1	2011-01-27 00:00:00
42	academico/cadastros/disciplina	excluir	academico/cadastros/disciplina/excluir	1	2011-01-27 00:00:00
43	academico/cadastros/disciplina	editar	academico/cadastros/disciplina/editar	1	2011-02-16 00:00:00
44	gerenciador/usuario	fazerLoginComo	gerenciador/usuario/fazerLoginComo	1	2011-09-12 00:00:00
45	gerenciador/usuarioPeopleGrid	novo	gerenciador/usuarioPeopleGrid/novo	1	2014-05-07 17:14:19.483178
46	gerenciador/usuarioPeopleGrid	editar	gerenciador/usuarioPeopleGrid/editar	1	2014-05-07 17:31:59.428199
47	gerenciador/usuarioPeopleGrid	salvarUsuarioPeopleGrid	gerenciador/usuarioPeopleGrid/salvarUsuarioPeopleGrid	1	2014-05-12 11:20:38.606502
48	gerenciador/usuarioPeopleGrid	salvar	gerenciador/usuarioPeopleGrid/salvar	1	2014-05-12 11:58:04.800955
\.


--
-- Name: sys_metodos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sys_metodos_id_seq', 48, true);


--
-- Data for Name: sys_permissoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sys_permissoes (id, sys_metodo_id, usuario_id, dt_cadastro) FROM stdin;
82	35	1	2011-11-15 00:00:00
83	44	1	2011-11-15 00:00:00
84	38	1	2011-11-15 00:00:00
85	34	1	2011-11-15 00:00:00
86	36	1	2011-11-15 00:00:00
87	39	1	2011-11-15 00:00:00
115	34	12	2014-06-05 11:54:05.588349
116	36	12	2014-06-05 11:54:05.588349
117	38	12	2014-06-05 11:54:05.588349
118	35	12	2014-06-05 11:54:05.588349
119	39	12	2014-06-05 11:54:05.588349
120	44	12	2014-06-05 11:54:05.588349
\.


--
-- Name: sys_permissoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sys_permissoes_id_seq', 120, true);


--
-- Data for Name: telefones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY telefones (id, pessoa_id, telefone_tipo_id, numero, dt_cadastro) FROM stdin;
\.


--
-- Name: telefones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('telefones_id_seq', 1, false);


--
-- Data for Name: telefones_tipos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY telefones_tipos (id, descricao, flg_tipo, dt_cadastro) FROM stdin;
\.


--
-- Name: telefones_tipos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('telefones_tipos_id_seq', 1, false);


--
-- Data for Name: tipo_enderecos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipo_enderecos (id, nome) FROM stdin;
\.


--
-- Name: tipo_enderecos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_enderecos_id_seq', 1, false);


--
-- Data for Name: unidades_federativas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY unidades_federativas (id, sigla, nome, dt_cadastro) FROM stdin;
1	AC	Acre	2010-02-25 00:00:00
2	AL	Alagoas	2010-02-25 00:00:00
3	AM	Amazonas	2010-02-25 00:00:00
4	AP	Amapá	2010-02-25 00:00:00
5	BA	Bahia	2010-02-25 00:00:00
6	CE	Ceará	2010-02-25 00:00:00
7	DF	Distrito Federal	2010-02-25 00:00:00
8	ES	Espírito Santo	2010-02-25 00:00:00
9	GO	Goiás	2010-02-25 00:00:00
10	MA	Maranhão	2010-02-25 00:00:00
11	MG	Minas Gerais	2010-02-25 00:00:00
12	MS	Mato Grosso do Sul	2010-02-25 00:00:00
13	MT	Mato Grosso	2010-02-25 00:00:00
14	PA	Pará	2010-02-25 00:00:00
15	PB	Paraíba	2010-02-25 00:00:00
16	PE	Pernambuco	2010-02-25 00:00:00
17	PI	Piauí	2010-02-25 00:00:00
18	PR	Paraná	2010-02-25 00:00:00
19	RJ	Rio de Janeiro	2010-02-25 00:00:00
20	RN	Rio Grande do Norte	2010-02-25 00:00:00
21	RO	Rondônia	2010-02-25 00:00:00
22	RR	Roraima	2010-02-25 00:00:00
23	RS	Rio Grande do Sul	2010-02-25 00:00:00
24	SC	Santa Catarina	2010-02-25 00:00:00
25	SE	Sergipe	2010-02-25 00:00:00
26	SP	São Paulo	2010-02-25 00:00:00
27	TO	Tocantins	2010-02-25 00:00:00
\.


--
-- Name: unidades_federativas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('unidades_federativas_id_seq', 27, true);


--
-- Data for Name: uploads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY uploads (id, nome_gerado, nome_original, tamanho, tipo, dt_cadastro) FROM stdin;
\.


--
-- Name: uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('uploads_id_seq', 1, false);


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios (id, pessoa_id, login, senha, dt_cadastro, hash_id, avatar_id, tema) FROM stdin;
4	5	peil	ca031666132f6c7a24affa8fdb8ddaecc8b49f1f	2014-05-07 17:42:41.027224	\N	\N	redmond
3	4	mpolidori	d033e22ae348aeb5660fc2140aec35850c4da997	2014-04-28 10:44:30.040893	\N	\N	redmond
12	13	operes	d033e22ae348aeb5660fc2140aec35850c4da997	2014-06-05 11:21:30.613097	\N	\N	redmond
14	15	dudu	d033e22ae348aeb5660fc2140aec35850c4da997	2014-06-05 15:37:56.798849	\N	\N	redmond
13	14	glauco	d033e22ae348aeb5660fc2140aec35850c4da997	2014-06-05 11:40:04.484539	\N	\N	redmond
1	1	admin	d033e22ae348aeb5660fc2140aec35850c4da997	2010-02-18 22:00:01	\N	\N	cupertino
15	16	rubao	d033e22ae348aeb5660fc2140aec35850c4da997	2015-04-17 16:38:03.022363	\N	\N	redmond
16	17	fdloopes	16333792a423e8d166cbce26cd8bbe3012ff21ae	2016-11-30 19:42:35.138621	\N	\N	redmond
\.


--
-- Data for Name: usuarios_empresas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios_empresas (usuario_id, empresa_id, empresa_boot) FROM stdin;
1	1	N
14	5	S
16	6	N
\.


--
-- Data for Name: usuarios_grupos_acessos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios_grupos_acessos (id, usuario_id, grupo_acesso_id, dt_cadastro) FROM stdin;
2	1	1	2014-04-28 11:02:47.021269
19	3	2	2014-06-16 08:45:07.284483
20	12	2	2014-06-16 08:45:15.776257
23	14	3	2014-11-24 09:01:51.576624
18	13	2	2014-06-16 08:44:56.731899
24	4	1	2015-04-17 10:57:17.02068
25	15	3	2015-04-17 16:38:03.022363
26	16	3	2016-11-30 19:42:35.138621
\.


--
-- Name: usuarios_grupos_acessos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_grupos_acessos_id_seq', 26, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_id_seq', 16, true);


--
-- Data for Name: usuarios_perfis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios_perfis (empresa_id, usuario_id, perfil_id) FROM stdin;
1	1	1
5	14	5
6	16	5
\.


--
-- Data for Name: usuarios_programas_acessos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios_programas_acessos (id, usuario_id, empresa_id, perfil_id, programa_id, dt_cadastro) FROM stdin;
11297	12	1	1	8	2014-06-05 11:54:12.471451
11298	12	1	1	9	2014-06-05 11:54:12.471451
11299	12	1	1	1	2014-06-05 11:54:12.471451
11300	12	1	1	5	2014-06-05 11:54:12.471451
11328	1	1	1	8	2014-08-01 11:59:17.411005
11329	1	1	1	9	2014-08-01 11:59:17.411005
11330	1	1	1	3	2014-08-01 11:59:17.411005
11331	1	1	1	10	2014-08-01 11:59:17.411005
11332	1	1	1	1	2014-08-01 11:59:17.411005
11333	1	1	1	4	2014-08-01 11:59:17.411005
11334	1	1	1	2	2014-08-01 11:59:17.411005
11335	1	1	1	5	2014-08-01 11:59:17.411005
\.


--
-- Name: usuarios_programas_acessos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_programas_acessos_id_seq', 11335, true);


SET search_path = peoplegrid, pg_catalog;

--
-- Name: dinamica_respostas_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dinamica_respostas
    ADD CONSTRAINT dinamica_respostas_pkey PRIMARY KEY (id);


--
-- Name: grid_respostas_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grid_respostas
    ADD CONSTRAINT grid_respostas_pkey PRIMARY KEY (id);


--
-- Name: nivel_escolaridade_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nivel_escolaridade
    ADD CONSTRAINT nivel_escolaridade_pkey PRIMARY KEY (id);


--
-- Name: pensou_como_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pensou_como
    ADD CONSTRAINT pensou_como_pkey PRIMARY KEY (id);


--
-- Name: perguntas_dinamica_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY perguntas_dinamica
    ADD CONSTRAINT perguntas_dinamica_pkey PRIMARY KEY (id);


--
-- Name: perguntas_grid_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY perguntas_grid
    ADD CONSTRAINT perguntas_grid_pkey PRIMARY KEY (id);


--
-- Name: perguntas_questionario_dinamicas_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY questionario_perguntas_dinamica
    ADD CONSTRAINT perguntas_questionario_dinamicas_pkey PRIMARY KEY (id);


--
-- Name: questionario_cores_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY questionario_cores
    ADD CONSTRAINT questionario_cores_pkey PRIMARY KEY (id);


--
-- Name: questionario_perguntas_grid_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY questionario_perguntas_grid
    ADD CONSTRAINT questionario_perguntas_grid_pkey PRIMARY KEY (id);


--
-- Name: questionarios_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY questionarios
    ADD CONSTRAINT questionarios_pkey PRIMARY KEY (id);


--
-- Name: renda_familiar_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY renda_familiar
    ADD CONSTRAINT renda_familiar_pkey PRIMARY KEY (id);


--
-- Name: respostas_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY respostas
    ADD CONSTRAINT respostas_pkey PRIMARY KEY (id);


--
-- Name: tipo_pergunta_dinamica_pkey; Type: CONSTRAINT; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_pergunta_dinamica
    ADD CONSTRAINT tipo_pergunta_dinamica_pkey PRIMARY KEY (id);


SET search_path = peopleplan, pg_catalog;

--
-- Name: nivel_escolaridade_pkey; Type: CONSTRAINT; Schema: peopleplan; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nivel_escolaridade
    ADD CONSTRAINT nivel_escolaridade_pkey PRIMARY KEY (id);


--
-- Name: pensou_como_pkey; Type: CONSTRAINT; Schema: peopleplan; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pensou_como
    ADD CONSTRAINT pensou_como_pkey PRIMARY KEY (id);


--
-- Name: perguntas_pkey; Type: CONSTRAINT; Schema: peopleplan; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY perguntas
    ADD CONSTRAINT perguntas_pkey PRIMARY KEY (id);


--
-- Name: questionario_cores_pkey; Type: CONSTRAINT; Schema: peopleplan; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY questionario_cores
    ADD CONSTRAINT questionario_cores_pkey PRIMARY KEY (id);


--
-- Name: questionario_perguntas_multicriterio_pkey; Type: CONSTRAINT; Schema: peopleplan; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY questionario_perguntas_multicriterio
    ADD CONSTRAINT questionario_perguntas_multicriterio_pkey PRIMARY KEY (id);


--
-- Name: questionario_pesos_perguntas_pkey; Type: CONSTRAINT; Schema: peopleplan; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY questionario_pesos_perguntas
    ADD CONSTRAINT questionario_pesos_perguntas_pkey PRIMARY KEY (id);


--
-- Name: questionarios_pkey; Type: CONSTRAINT; Schema: peopleplan; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY questionarios
    ADD CONSTRAINT questionarios_pkey PRIMARY KEY (id);


--
-- Name: renda_familiar_pkey; Type: CONSTRAINT; Schema: peopleplan; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY renda_familiar
    ADD CONSTRAINT renda_familiar_pkey PRIMARY KEY (id);


--
-- Name: respostas_multicriterio_pkey; Type: CONSTRAINT; Schema: peopleplan; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY respostas_multicriterio
    ADD CONSTRAINT respostas_multicriterio_pkey PRIMARY KEY (id);


--
-- Name: respostas_pkey; Type: CONSTRAINT; Schema: peopleplan; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY respostas
    ADD CONSTRAINT respostas_pkey PRIMARY KEY (id);


SET search_path = public, pg_catalog;

--
-- Name: ci_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ci_sessions
    ADD CONSTRAINT ci_sessions_pkey PRIMARY KEY (session_id);


--
-- Name: cidades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cidades
    ADD CONSTRAINT cidades_pkey PRIMARY KEY (id);


--
-- Name: configuracao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY configuracao
    ADD CONSTRAINT configuracao_pkey PRIMARY KEY (id);


--
-- Name: empresas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY empresas
    ADD CONSTRAINT empresas_pkey PRIMARY KEY (id);


--
-- Name: enderecos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY enderecos
    ADD CONSTRAINT enderecos_pkey PRIMARY KEY (id);


--
-- Name: enderecos_tipos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY enderecos_tipos
    ADD CONSTRAINT enderecos_tipos_pkey PRIMARY KEY (id);


--
-- Name: estados_civis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY estados_civis
    ADD CONSTRAINT estados_civis_pkey PRIMARY KEY (id);


--
-- Name: grupos_acessos_empresas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grupos_acessos_empresas
    ADD CONSTRAINT grupos_acessos_empresas_pkey PRIMARY KEY (id);


--
-- Name: grupos_acessos_perfis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grupos_acessos_perfis
    ADD CONSTRAINT grupos_acessos_perfis_pkey PRIMARY KEY (id);


--
-- Name: grupos_acessos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grupos_acessos
    ADD CONSTRAINT grupos_acessos_pkey PRIMARY KEY (id);


--
-- Name: grupos_acessos_programas_permissoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grupos_acessos_programas_permissoes
    ADD CONSTRAINT grupos_acessos_programas_permissoes_pkey PRIMARY KEY (id);


--
-- Name: grupos_acessos_programas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grupos_acessos_programas
    ADD CONSTRAINT grupos_acessos_programas_pkey PRIMARY KEY (id);


--
-- Name: log_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY log_fields
    ADD CONSTRAINT log_fields_pkey PRIMARY KEY (id);


--
-- Name: log_fields_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY log_fields_structures
    ADD CONSTRAINT log_fields_structures_pkey PRIMARY KEY (id);


--
-- Name: log_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY log_tables
    ADD CONSTRAINT log_tables_pkey PRIMARY KEY (id);


--
-- Name: log_tables_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY log_tables_structures
    ADD CONSTRAINT log_tables_structures_pkey PRIMARY KEY (id);


--
-- Name: parametros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY parametros
    ADD CONSTRAINT parametros_pkey PRIMARY KEY (id);


--
-- Name: perfis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY perfis
    ADD CONSTRAINT perfis_pkey PRIMARY KEY (id);


--
-- Name: perfis_programas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY perfis_programas
    ADD CONSTRAINT perfis_programas_pkey PRIMARY KEY (id);


--
-- Name: pessoas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pessoas
    ADD CONSTRAINT pessoas_pkey PRIMARY KEY (id);


--
-- Name: pessoas_tipos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pessoas_tipos
    ADD CONSTRAINT pessoas_tipos_pkey PRIMARY KEY (id);


--
-- Name: programas_parametros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY programas_parametros
    ADD CONSTRAINT programas_parametros_pkey PRIMARY KEY (id);


--
-- Name: programas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY programas
    ADD CONSTRAINT programas_pkey PRIMARY KEY (id);


--
-- Name: sys_metodos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sys_metodos
    ADD CONSTRAINT sys_metodos_pkey PRIMARY KEY (id);


--
-- Name: sys_permissoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sys_permissoes
    ADD CONSTRAINT sys_permissoes_pkey PRIMARY KEY (id);


--
-- Name: telefones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY telefones
    ADD CONSTRAINT telefones_pkey PRIMARY KEY (id);


--
-- Name: telefones_tipos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY telefones_tipos
    ADD CONSTRAINT telefones_tipos_pkey PRIMARY KEY (id);


--
-- Name: tipo_enderecos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_enderecos
    ADD CONSTRAINT tipo_enderecos_pkey PRIMARY KEY (id);


--
-- Name: unidades_federativas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unidades_federativas
    ADD CONSTRAINT unidades_federativas_pkey PRIMARY KEY (id);


--
-- Name: uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY uploads
    ADD CONSTRAINT uploads_pkey PRIMARY KEY (id);


--
-- Name: usuarios_grupos_acessos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuarios_grupos_acessos
    ADD CONSTRAINT usuarios_grupos_acessos_pkey PRIMARY KEY (id);


--
-- Name: usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: usuarios_programas_acessos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuarios_programas_acessos
    ADD CONSTRAINT usuarios_programas_acessos_pkey PRIMARY KEY (id);


SET search_path = peoplegrid, pg_catalog;

--
-- Name: fki_forekey; Type: INDEX; Schema: peoplegrid; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_forekey ON questionario_cores USING btree (questionario_id);


SET search_path = peopleplan, pg_catalog;

--
-- Name: fki_forekey; Type: INDEX; Schema: peopleplan; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_forekey ON questionario_cores USING btree (questionario_id);


SET search_path = peoplegrid, pg_catalog;

--
-- Name: fk_dinamica_respostas_1; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY dinamica_respostas
    ADD CONSTRAINT fk_dinamica_respostas_1 FOREIGN KEY (pergunta_questionario_dinamica_id) REFERENCES questionario_perguntas_dinamica(id);


--
-- Name: fk_dinamica_respostas_2; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY dinamica_respostas
    ADD CONSTRAINT fk_dinamica_respostas_2 FOREIGN KEY (id) REFERENCES respostas(id);


--
-- Name: fk_grid_respostas_1; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY grid_respostas
    ADD CONSTRAINT fk_grid_respostas_1 FOREIGN KEY (questionario_pergunta_grid_id) REFERENCES questionario_perguntas_grid(id);


--
-- Name: fk_grid_respostas_2; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY grid_respostas
    ADD CONSTRAINT fk_grid_respostas_2 FOREIGN KEY (resposta_id) REFERENCES respostas(id);


--
-- Name: fk_pensou_como_1; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY respostas
    ADD CONSTRAINT fk_pensou_como_1 FOREIGN KEY (pensou_como_id) REFERENCES pensou_como(id);


--
-- Name: fk_perguntas_dinamica_1; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY perguntas_dinamica
    ADD CONSTRAINT fk_perguntas_dinamica_1 FOREIGN KEY (tipo_pergunta_dinamica_id) REFERENCES tipo_pergunta_dinamica(id);


--
-- Name: fk_perguntas_dinamica_2; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY perguntas_dinamica
    ADD CONSTRAINT fk_perguntas_dinamica_2 FOREIGN KEY (pessoa_id) REFERENCES public.pessoas(id);


--
-- Name: fk_perguntas_grid_1; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY perguntas_grid
    ADD CONSTRAINT fk_perguntas_grid_1 FOREIGN KEY (pessoa_id) REFERENCES public.pessoas(id);


--
-- Name: fk_perguntas_questionario_dinamicas_1; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY questionario_perguntas_dinamica
    ADD CONSTRAINT fk_perguntas_questionario_dinamicas_1 FOREIGN KEY (pergunta_dinamica_id) REFERENCES perguntas_dinamica(id);


--
-- Name: fk_perguntas_questionario_dinamicas_2; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY questionario_perguntas_dinamica
    ADD CONSTRAINT fk_perguntas_questionario_dinamicas_2 FOREIGN KEY (questionario_id) REFERENCES questionarios(id);


--
-- Name: fk_questionario_perguntas_1; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY questionario_perguntas_grid
    ADD CONSTRAINT fk_questionario_perguntas_1 FOREIGN KEY (questionario_id) REFERENCES questionarios(id);


--
-- Name: fk_questionario_perguntas_2; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY questionario_perguntas_grid
    ADD CONSTRAINT fk_questionario_perguntas_2 FOREIGN KEY (pergunta_grid_id) REFERENCES perguntas_grid(id);


--
-- Name: fk_questionarios_1; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY questionarios
    ADD CONSTRAINT fk_questionarios_1 FOREIGN KEY (pessoa_id) REFERENCES public.pessoas(id);


--
-- Name: fk_respostas_1; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY respostas
    ADD CONSTRAINT fk_respostas_1 FOREIGN KEY (nivel_escolaridade_id) REFERENCES nivel_escolaridade(id);


--
-- Name: fk_respostas_2; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY respostas
    ADD CONSTRAINT fk_respostas_2 FOREIGN KEY (renda_familiar_id) REFERENCES renda_familiar(id);


--
-- Name: forekey; Type: FK CONSTRAINT; Schema: peoplegrid; Owner: postgres
--

ALTER TABLE ONLY questionario_cores
    ADD CONSTRAINT forekey FOREIGN KEY (questionario_id) REFERENCES questionarios(id);


SET search_path = peopleplan, pg_catalog;

--
-- Name: fk_pensou_como_1; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY respostas
    ADD CONSTRAINT fk_pensou_como_1 FOREIGN KEY (pensou_como_id) REFERENCES pensou_como(id);


--
-- Name: fk_perguntas_1; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY perguntas
    ADD CONSTRAINT fk_perguntas_1 FOREIGN KEY (pessoa_id) REFERENCES public.pessoas(id);


--
-- Name: fk_questionario_perguntas_1; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY questionario_perguntas_multicriterio
    ADD CONSTRAINT fk_questionario_perguntas_1 FOREIGN KEY (questionario_id) REFERENCES questionarios(id);


--
-- Name: fk_questionario_perguntas_2; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY questionario_perguntas_multicriterio
    ADD CONSTRAINT fk_questionario_perguntas_2 FOREIGN KEY (pergunta_id) REFERENCES perguntas(id);


--
-- Name: fk_questionarios_1; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY questionarios
    ADD CONSTRAINT fk_questionarios_1 FOREIGN KEY (pessoa_id) REFERENCES public.pessoas(id);


--
-- Name: fk_respostas_1; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY respostas
    ADD CONSTRAINT fk_respostas_1 FOREIGN KEY (nivel_escolaridade_id) REFERENCES nivel_escolaridade(id);


--
-- Name: fk_respostas_1; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY respostas_multicriterio
    ADD CONSTRAINT fk_respostas_1 FOREIGN KEY (questionario_pergunta_id) REFERENCES questionario_perguntas_multicriterio(id);


--
-- Name: fk_respostas_2; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY respostas
    ADD CONSTRAINT fk_respostas_2 FOREIGN KEY (renda_familiar_id) REFERENCES renda_familiar(id);


--
-- Name: fk_respostas_2; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY respostas_multicriterio
    ADD CONSTRAINT fk_respostas_2 FOREIGN KEY (resposta_id) REFERENCES respostas(id);


--
-- Name: forekey; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY questionario_cores
    ADD CONSTRAINT forekey FOREIGN KEY (questionario_id) REFERENCES questionarios(id);


--
-- Name: questionario_pesos_perguntas_pergunta_id_fkey; Type: FK CONSTRAINT; Schema: peopleplan; Owner: postgres
--

ALTER TABLE ONLY questionario_pesos_perguntas
    ADD CONSTRAINT questionario_pesos_perguntas_pergunta_id_fkey FOREIGN KEY (pergunta_id) REFERENCES perguntas(id);


SET search_path = public, pg_catalog;

--
-- Name: fk_cidades_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cidades
    ADD CONSTRAINT fk_cidades_1 FOREIGN KEY (unidade_federativa_id) REFERENCES unidades_federativas(id);


--
-- Name: fk_empresas_perfis_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY empresas_perfis
    ADD CONSTRAINT fk_empresas_perfis_1 FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_empresas_perfis_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY empresas_perfis
    ADD CONSTRAINT fk_empresas_perfis_2 FOREIGN KEY (perfil_id) REFERENCES perfis(id);


--
-- Name: fk_enderecos_fisicos_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enderecos
    ADD CONSTRAINT fk_enderecos_fisicos_1 FOREIGN KEY (endereco_tipo_id) REFERENCES enderecos_tipos(id);


--
-- Name: fk_enderecos_fisicos_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enderecos
    ADD CONSTRAINT fk_enderecos_fisicos_2 FOREIGN KEY (pessoa_id) REFERENCES pessoas(id);


--
-- Name: fk_grupos_acessos_empresas_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_empresas
    ADD CONSTRAINT fk_grupos_acessos_empresas_1 FOREIGN KEY (grupo_acesso_id) REFERENCES grupos_acessos(id);


--
-- Name: fk_grupos_acessos_empresas_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_empresas
    ADD CONSTRAINT fk_grupos_acessos_empresas_2 FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_grupos_acessos_perfis_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_perfis
    ADD CONSTRAINT fk_grupos_acessos_perfis_1 FOREIGN KEY (perfil_id) REFERENCES perfis(id);


--
-- Name: fk_grupos_acessos_perfis_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_perfis
    ADD CONSTRAINT fk_grupos_acessos_perfis_2 FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_grupos_acessos_perfis_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_perfis
    ADD CONSTRAINT fk_grupos_acessos_perfis_3 FOREIGN KEY (grupo_acesso_id) REFERENCES grupos_acessos(id);


--
-- Name: fk_grupos_acessos_programas_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_programas
    ADD CONSTRAINT fk_grupos_acessos_programas_1 FOREIGN KEY (grupo_acesso_id) REFERENCES grupos_acessos(id);


--
-- Name: fk_grupos_acessos_programas_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_programas
    ADD CONSTRAINT fk_grupos_acessos_programas_2 FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_grupos_acessos_programas_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_programas
    ADD CONSTRAINT fk_grupos_acessos_programas_3 FOREIGN KEY (perfil_id) REFERENCES perfis(id);


--
-- Name: fk_grupos_acessos_programas_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_programas
    ADD CONSTRAINT fk_grupos_acessos_programas_4 FOREIGN KEY (programa_id) REFERENCES programas(id);


--
-- Name: fk_grupos_acessos_programas_permissoes_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_programas
    ADD CONSTRAINT fk_grupos_acessos_programas_permissoes_1 FOREIGN KEY (grupo_acesso_id) REFERENCES grupos_acessos(id);


--
-- Name: fk_grupos_acessos_programas_permissoes_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_programas_permissoes
    ADD CONSTRAINT fk_grupos_acessos_programas_permissoes_1 FOREIGN KEY (grupo_acesso_id) REFERENCES grupos_acessos(id);


--
-- Name: fk_grupos_acessos_programas_permissoes_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grupos_acessos_programas_permissoes
    ADD CONSTRAINT fk_grupos_acessos_programas_permissoes_2 FOREIGN KEY (sys_metodo_id) REFERENCES sys_metodos(id);


--
-- Name: fk_log_fields_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY log_fields
    ADD CONSTRAINT fk_log_fields_1 FOREIGN KEY (log_table_id) REFERENCES log_tables(id);


--
-- Name: fk_log_fields_structures_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY log_fields_structures
    ADD CONSTRAINT fk_log_fields_structures_1 FOREIGN KEY (log_table_structure_id) REFERENCES log_tables_structures(id);


--
-- Name: fk_perfis_programas_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY perfis_programas
    ADD CONSTRAINT fk_perfis_programas_1 FOREIGN KEY (programa_id) REFERENCES programas(id);


--
-- Name: fk_perfis_programas_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY perfis_programas
    ADD CONSTRAINT fk_perfis_programas_2 FOREIGN KEY (perfil_id) REFERENCES perfis(id);


--
-- Name: fk_pessoas_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pessoas
    ADD CONSTRAINT fk_pessoas_1 FOREIGN KEY (estado_civil_id) REFERENCES estados_civis(id);


--
-- Name: fk_pessoas_foto_carteira; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pessoas
    ADD CONSTRAINT fk_pessoas_foto_carteira FOREIGN KEY (foto_carteira_id) REFERENCES uploads(id);


--
-- Name: fk_programas_parametros_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY programas_parametros
    ADD CONSTRAINT fk_programas_parametros_1 FOREIGN KEY (programa_id) REFERENCES programas(id);


--
-- Name: fk_sys_permissoes_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sys_permissoes
    ADD CONSTRAINT fk_sys_permissoes_1 FOREIGN KEY (sys_metodo_id) REFERENCES sys_metodos(id);


--
-- Name: fk_sys_permissoes_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sys_permissoes
    ADD CONSTRAINT fk_sys_permissoes_2 FOREIGN KEY (usuario_id) REFERENCES usuarios(id);


--
-- Name: fk_telefones_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY telefones
    ADD CONSTRAINT fk_telefones_1 FOREIGN KEY (telefone_tipo_id) REFERENCES telefones_tipos(id);


--
-- Name: fk_telefones_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY telefones
    ADD CONSTRAINT fk_telefones_2 FOREIGN KEY (pessoa_id) REFERENCES pessoas(id);


--
-- Name: fk_usuarios_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT fk_usuarios_1 FOREIGN KEY (pessoa_id) REFERENCES pessoas(id);


--
-- Name: fk_usuarios_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT fk_usuarios_2 FOREIGN KEY (avatar_id) REFERENCES uploads(id);


--
-- Name: fk_usuarios_empresas_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_empresas
    ADD CONSTRAINT fk_usuarios_empresas_1 FOREIGN KEY (usuario_id) REFERENCES usuarios(id);


--
-- Name: fk_usuarios_empresas_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_empresas
    ADD CONSTRAINT fk_usuarios_empresas_2 FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_usuarios_grupos_acessos_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_grupos_acessos
    ADD CONSTRAINT fk_usuarios_grupos_acessos_1 FOREIGN KEY (grupo_acesso_id) REFERENCES grupos_acessos(id);


--
-- Name: fk_usuarios_grupos_acessos_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_grupos_acessos
    ADD CONSTRAINT fk_usuarios_grupos_acessos_2 FOREIGN KEY (usuario_id) REFERENCES usuarios(id);


--
-- Name: fk_usuarios_perfis_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_perfis
    ADD CONSTRAINT fk_usuarios_perfis_1 FOREIGN KEY (usuario_id) REFERENCES usuarios(id);


--
-- Name: fk_usuarios_perfis_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_perfis
    ADD CONSTRAINT fk_usuarios_perfis_2 FOREIGN KEY (perfil_id) REFERENCES perfis(id);


--
-- Name: fk_usuarios_perfis_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_perfis
    ADD CONSTRAINT fk_usuarios_perfis_3 FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_usuarios_programas_acessos_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_programas_acessos
    ADD CONSTRAINT fk_usuarios_programas_acessos_1 FOREIGN KEY (usuario_id) REFERENCES usuarios(id);


--
-- Name: fk_usuarios_programas_acessos_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_programas_acessos
    ADD CONSTRAINT fk_usuarios_programas_acessos_2 FOREIGN KEY (programa_id) REFERENCES programas(id);


--
-- Name: fk_usuarios_programas_acessos_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_programas_acessos
    ADD CONSTRAINT fk_usuarios_programas_acessos_3 FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_usuarios_programas_acessos_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_programas_acessos
    ADD CONSTRAINT fk_usuarios_programas_acessos_4 FOREIGN KEY (perfil_id) REFERENCES perfis(id);


--
-- Name: pessoas_orgao_emissor_rg_unidade_federativa_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pessoas
    ADD CONSTRAINT pessoas_orgao_emissor_rg_unidade_federativa_id FOREIGN KEY (orgao_emissor_rg_unidade_federativa_id) REFERENCES unidades_federativas(id);


--
-- Name: pessoas_pessoa_tipo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pessoas
    ADD CONSTRAINT pessoas_pessoa_tipo_id_fkey FOREIGN KEY (pessoa_tipo_id) REFERENCES pessoas_tipos(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

