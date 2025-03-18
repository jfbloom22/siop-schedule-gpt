--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: session_speakers; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.session_speakers (
    session_id integer NOT NULL,
    speaker_id integer NOT NULL
);


ALTER TABLE public.session_speakers OWNER TO neondb_owner;

--
-- Name: session_tracks; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.session_tracks (
    session_id integer NOT NULL,
    track_id integer NOT NULL
);


ALTER TABLE public.session_tracks OWNER TO neondb_owner;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: neondb_owner
--

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


ALTER TABLE public.sessions OWNER TO neondb_owner;

--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sessions_id_seq OWNER TO neondb_owner;

--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: speakers; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.speakers (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.speakers OWNER TO neondb_owner;

--
-- Name: speakers_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.speakers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.speakers_id_seq OWNER TO neondb_owner;

--
-- Name: speakers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.speakers_id_seq OWNED BY public.speakers.id;


--
-- Name: sub_session_speakers; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sub_session_speakers (
    sub_session_id integer NOT NULL,
    speaker_id integer NOT NULL
);


ALTER TABLE public.sub_session_speakers OWNER TO neondb_owner;

--
-- Name: sub_sessions; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sub_sessions (
    id integer NOT NULL,
    parent_session_id integer,
    name character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.sub_sessions OWNER TO neondb_owner;

--
-- Name: sub_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.sub_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sub_sessions_id_seq OWNER TO neondb_owner;

--
-- Name: sub_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.sub_sessions_id_seq OWNED BY public.sub_sessions.id;


--
-- Name: tracks; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.tracks (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.tracks OWNER TO neondb_owner;

--
-- Name: tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.tracks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tracks_id_seq OWNER TO neondb_owner;

--
-- Name: tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.tracks_id_seq OWNED BY public.tracks.id;


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: speakers id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.speakers ALTER COLUMN id SET DEFAULT nextval('public.speakers_id_seq'::regclass);


--
-- Name: sub_sessions id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sub_sessions ALTER COLUMN id SET DEFAULT nextval('public.sub_sessions_id_seq'::regclass);


--
-- Name: tracks id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.tracks ALTER COLUMN id SET DEFAULT nextval('public.tracks_id_seq'::regclass);


--
-- Name: session_speakers session_speakers_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.session_speakers
    ADD CONSTRAINT session_speakers_pkey PRIMARY KEY (session_id, speaker_id);


--
-- Name: session_tracks session_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.session_tracks
    ADD CONSTRAINT session_tracks_pkey PRIMARY KEY (session_id, track_id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: speakers speakers_name_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.speakers
    ADD CONSTRAINT speakers_name_key UNIQUE (name);


--
-- Name: speakers speakers_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.speakers
    ADD CONSTRAINT speakers_pkey PRIMARY KEY (id);


--
-- Name: sub_session_speakers sub_session_speakers_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sub_session_speakers
    ADD CONSTRAINT sub_session_speakers_pkey PRIMARY KEY (sub_session_id, speaker_id);


--
-- Name: sub_sessions sub_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sub_sessions
    ADD CONSTRAINT sub_sessions_pkey PRIMARY KEY (id);


--
-- Name: tracks tracks_name_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_name_key UNIQUE (name);


--
-- Name: tracks tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- Name: session_speakers session_speakers_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.session_speakers
    ADD CONSTRAINT session_speakers_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id);


--
-- Name: session_speakers session_speakers_speaker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.session_speakers
    ADD CONSTRAINT session_speakers_speaker_id_fkey FOREIGN KEY (speaker_id) REFERENCES public.speakers(id);


--
-- Name: session_tracks session_tracks_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.session_tracks
    ADD CONSTRAINT session_tracks_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id);


--
-- Name: session_tracks session_tracks_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.session_tracks
    ADD CONSTRAINT session_tracks_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.tracks(id);


--
-- Name: sub_session_speakers sub_session_speakers_speaker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sub_session_speakers
    ADD CONSTRAINT sub_session_speakers_speaker_id_fkey FOREIGN KEY (speaker_id) REFERENCES public.speakers(id);


--
-- Name: sub_session_speakers sub_session_speakers_sub_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sub_session_speakers
    ADD CONSTRAINT sub_session_speakers_sub_session_id_fkey FOREIGN KEY (sub_session_id) REFERENCES public.sub_sessions(id);


--
-- Name: sub_sessions sub_sessions_parent_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sub_sessions
    ADD CONSTRAINT sub_sessions_parent_session_id_fkey FOREIGN KEY (parent_session_id) REFERENCES public.sessions(id);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

