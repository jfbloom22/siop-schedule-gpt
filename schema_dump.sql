--
-- PostgreSQL database dump
--


CREATE TABLE public.session_speakers (
    session_id integer NOT NULL,
    speaker_id integer NOT NULL
);


--

CREATE TABLE public.session_tracks (
    session_id integer NOT NULL,
    track_id integer NOT NULL
);



CREATE TABLE public.sessions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    date date NOT NULL,
    location character varying(255),
    description text,
    session_id character varying(50),
    is_virtual boolean DEFAULT false,
    event_name character varying(255),
    timezone character varying(50)
);


CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE public.speakers (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


--

CREATE SEQUENCE public.speakers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.speakers_id_seq OWNER TO neondb_owner;


CREATE TABLE public.sub_session_speakers (
    sub_session_id integer NOT NULL,
    speaker_id integer NOT NULL
);

--

CREATE TABLE public.sub_sessions (
    id integer NOT NULL,
    parent_session_id integer,
    name character varying(255) NOT NULL,
    description text
);

--

CREATE SEQUENCE public.sub_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.tracks (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);

