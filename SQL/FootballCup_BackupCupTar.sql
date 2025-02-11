toc.dat                                                                                             0000600 0004000 0002000 00000062553 14447250777 0014473 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP           *                {           FootballCup    15.3    15.2 E    i           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         j           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         k           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         l           1262    16531    FootballCup    DATABASE     �   CREATE DATABASE "FootballCup" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "FootballCup";
                postgres    false         �            1255    18879    check_match_schedule()    FUNCTION     �  CREATE FUNCTION public.check_match_schedule() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    previous_match_date DATE;
BEGIN
    -- Check if the home team has a match within 10 days before or after the current match
    SELECT date INTO previous_match_date
    FROM match_and_schedule
    WHERE (home_club = NEW.home_club OR visiting_club = NEW.home_club)
    AND date >= NEW.date - INTERVAL '10 days'
    AND date <= NEW.date + INTERVAL '10 days'
    AND id_ms != NEW.id_ms;
    
    IF previous_match_date IS NOT NULL THEN
        RAISE EXCEPTION 'A team has a match within 10 days before or after this match.';
    END IF;
    
    RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.check_match_schedule();
       public          postgres    false         �            1255    18877    check_player_count()    FUNCTION     �  CREATE FUNCTION public.check_player_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  player_count INTEGER;
BEGIN
  -- Get the count of rows for the current club name
  SELECT COUNT(*) INTO player_count
  FROM player
  WHERE name_cl = NEW.name_cl;

  -- Raise an exception if the row count exceeds the limit
  IF player_count >= 11 THEN
    RAISE EXCEPTION 'Maximum row limit reached for club: %', NEW.name_cl;
  END IF;

  RETURN NEW;
END;
$$;
 +   DROP FUNCTION public.check_player_count();
       public          postgres    false         �            1255    18923    clubs_log_function()    FUNCTION     �  CREATE FUNCTION public.clubs_log_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO drop_category_club (name_cl, stadium, story, wins_home, wins_away, losses_home, losses_away, draws_home, draws_away)
    VALUES (OLD.name_cl, OLD.stadium, OLD.story, OLD.wins_home, OLD.wins_away, OLD.losses_home, OLD.losses_away, OLD.draws_home, OLD.draws_away);
    RETURN NULL;
END;
$$;
 +   DROP FUNCTION public.clubs_log_function();
       public          postgres    false         �            1259    18750    club    TABLE     g  CREATE TABLE public.club (
    name_cl character varying(30) NOT NULL,
    stadium character varying(50) NOT NULL,
    story character varying(1000) NOT NULL,
    wins_home integer NOT NULL,
    wins_away integer NOT NULL,
    losses_home integer NOT NULL,
    losses_away integer NOT NULL,
    draws_home integer NOT NULL,
    draws_away integer NOT NULL
);
    DROP TABLE public.club;
       public         heap    postgres    false         �            1259    18762    player    TABLE       CREATE TABLE public.player (
    id_p integer NOT NULL,
    name character varying(20) NOT NULL,
    surname character varying(20) NOT NULL,
    name_cl character varying(30) NOT NULL,
    "position" character varying(20) NOT NULL,
    cards_y integer NOT NULL,
    cards_r integer NOT NULL,
    goals integer NOT NULL,
    is_active boolean NOT NULL,
    CONSTRAINT name_charset CHECK ((((name)::text ~ '^[Α-Ωα-ωάέήίϊΐόύϋΰώ\-]+$'::text) AND ((surname)::text ~ '^[Α-Ωα-ωάέήίϊΐόύϋΰώ\-]+$'::text)))
);
    DROP TABLE public.player;
       public         heap    postgres    false         �            1259    18789    coach    TABLE     �   CREATE TABLE public.coach (
    is_coach boolean NOT NULL,
    name_cl_coach character varying(30) NOT NULL
)
INHERITS (public.player);
    DROP TABLE public.coach;
       public         heap    postgres    false    216         �            1259    18911    drop_category_club    TABLE     �  CREATE TABLE public.drop_category_club (
    name_cl character varying(30) NOT NULL,
    stadium character varying(50) NOT NULL,
    story character varying(1000) NOT NULL,
    wins_home integer NOT NULL,
    wins_away integer NOT NULL,
    losses_home integer NOT NULL,
    losses_away integer NOT NULL,
    draws_home integer NOT NULL,
    draws_away integer NOT NULL,
    deleted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 &   DROP TABLE public.drop_category_club;
       public         heap    postgres    false         �            1259    18835    match_and_corners    TABLE     �   CREATE TABLE public.match_and_corners (
    id_ms integer NOT NULL,
    corner boolean NOT NULL,
    "time" interval NOT NULL
);
 %   DROP TABLE public.match_and_corners;
       public         heap    postgres    false         �            1259    18845    match_and_player_cards    TABLE     �   CREATE TABLE public.match_and_player_cards (
    id_ms integer NOT NULL,
    cards_y boolean DEFAULT false NOT NULL,
    cards_r boolean DEFAULT false NOT NULL,
    id_player integer NOT NULL,
    "time" interval NOT NULL
);
 *   DROP TABLE public.match_and_player_cards;
       public         heap    postgres    false         �            1259    18820    match_and_player_goals    TABLE     �   CREATE TABLE public.match_and_player_goals (
    id_ms integer NOT NULL,
    penalty boolean NOT NULL,
    goals_s boolean NOT NULL,
    goals_c boolean NOT NULL,
    id_player integer,
    "time" interval NOT NULL
);
 *   DROP TABLE public.match_and_player_goals;
       public         heap    postgres    false         �            1259    18862    match_and_player_time_played    TABLE     �   CREATE TABLE public.match_and_player_time_played (
    id_ms integer NOT NULL,
    id_player integer NOT NULL,
    time_played interval NOT NULL
);
 0   DROP TABLE public.match_and_player_time_played;
       public         heap    postgres    false         �            1259    18802    match_and_schedule    TABLE       CREATE TABLE public.match_and_schedule (
    id_ms integer NOT NULL,
    home_club character varying(30) NOT NULL,
    visiting_club character varying(30) NOT NULL,
    home_score integer NOT NULL,
    visiting_score integer NOT NULL,
    date date NOT NULL
);
 &   DROP TABLE public.match_and_schedule;
       public         heap    postgres    false         �            1259    18801    match_and_schedule_id_ms_seq    SEQUENCE     �   CREATE SEQUENCE public.match_and_schedule_id_ms_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.match_and_schedule_id_ms_seq;
       public          postgres    false    220         m           0    0    match_and_schedule_id_ms_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.match_and_schedule_id_ms_seq OWNED BY public.match_and_schedule.id_ms;
          public          postgres    false    219         �            1259    18774    player_club    TABLE     k   CREATE TABLE public.player_club (
    id_p integer NOT NULL,
    name_cl character varying(30) NOT NULL
);
    DROP TABLE public.player_club;
       public         heap    postgres    false         �            1259    18761    player_id_p_seq    SEQUENCE     �   CREATE SEQUENCE public.player_id_p_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.player_id_p_seq;
       public          postgres    false    216         n           0    0    player_id_p_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.player_id_p_seq OWNED BY public.player.id_p;
          public          postgres    false    215         �            1259    18930    schedule_match    VIEW     ~  CREATE VIEW public.schedule_match AS
 SELECT match_and_schedule.date,
    match_and_schedule.home_club,
    match_and_schedule.visiting_club,
    match_and_schedule.home_score,
    match_and_schedule.visiting_score,
    club.stadium,
    player.name,
    player.surname,
    player."position",
    player.name_cl,
    match_and_player_cards.cards_y,
    match_and_player_cards.cards_r,
    match_and_player_time_played.time_played,
    match_and_player_goals.goals_s,
    match_and_player_goals."time"
   FROM (((((public.match_and_schedule
     FULL JOIN public.club ON (((match_and_schedule.home_club)::text = (club.name_cl)::text)))
     FULL JOIN public.player ON ((((match_and_schedule.home_club)::text = (player.name_cl)::text) OR ((match_and_schedule.visiting_club)::text = (player.name_cl)::text))))
     LEFT JOIN public.match_and_player_cards ON (((player.id_p = match_and_player_cards.id_player) AND (match_and_schedule.id_ms = match_and_player_cards.id_ms))))
     FULL JOIN public.match_and_player_goals ON (((match_and_schedule.id_ms = match_and_player_goals.id_ms) AND (match_and_player_goals.id_player = player.id_p))))
     FULL JOIN public.match_and_player_time_played ON (((match_and_player_time_played.id_ms = match_and_schedule.id_ms) AND (match_and_player_time_played.id_player = player.id_p))))
  WHERE ((match_and_schedule.date = '2023-06-29'::date) AND (player.is_active = true));
 !   DROP VIEW public.schedule_match;
       public          postgres    false    216    216    216    223    223    214    220    220    220    224    220    220    220    221    224    224    221    221    221    223    223    216    214    216    216         �            1259    18935    season_matches    VIEW     �  CREATE VIEW public.season_matches AS
 SELECT match_and_schedule.date,
    match_and_schedule.home_club,
    match_and_schedule.visiting_club,
    match_and_schedule.home_score,
    match_and_schedule.visiting_score,
    club.stadium
   FROM (public.match_and_schedule
     JOIN public.club ON (((match_and_schedule.home_club)::text = (club.name_cl)::text)))
  WHERE ((match_and_schedule.date >= '2023-04-01'::date) AND (match_and_schedule.date <= '2023-06-30'::date))
  ORDER BY match_and_schedule.date;
 !   DROP VIEW public.season_matches;
       public          postgres    false    220    220    220    220    220    214    214         �           2604    18792 
   coach id_p    DEFAULT     i   ALTER TABLE ONLY public.coach ALTER COLUMN id_p SET DEFAULT nextval('public.player_id_p_seq'::regclass);
 9   ALTER TABLE public.coach ALTER COLUMN id_p DROP DEFAULT;
       public          postgres    false    218    215         �           2604    18805    match_and_schedule id_ms    DEFAULT     �   ALTER TABLE ONLY public.match_and_schedule ALTER COLUMN id_ms SET DEFAULT nextval('public.match_and_schedule_id_ms_seq'::regclass);
 G   ALTER TABLE public.match_and_schedule ALTER COLUMN id_ms DROP DEFAULT;
       public          postgres    false    220    219    220         �           2604    18765    player id_p    DEFAULT     j   ALTER TABLE ONLY public.player ALTER COLUMN id_p SET DEFAULT nextval('public.player_id_p_seq'::regclass);
 :   ALTER TABLE public.player ALTER COLUMN id_p DROP DEFAULT;
       public          postgres    false    216    215    216         [          0    18750    club 
   TABLE DATA                 public          postgres    false    214       3419.dat _          0    18789    coach 
   TABLE DATA                 public          postgres    false    218       3423.dat f          0    18911    drop_category_club 
   TABLE DATA                 public          postgres    false    225       3430.dat c          0    18835    match_and_corners 
   TABLE DATA                 public          postgres    false    222       3427.dat d          0    18845    match_and_player_cards 
   TABLE DATA                 public          postgres    false    223       3428.dat b          0    18820    match_and_player_goals 
   TABLE DATA                 public          postgres    false    221       3426.dat e          0    18862    match_and_player_time_played 
   TABLE DATA                 public          postgres    false    224       3429.dat a          0    18802    match_and_schedule 
   TABLE DATA                 public          postgres    false    220       3425.dat ]          0    18762    player 
   TABLE DATA                 public          postgres    false    216       3421.dat ^          0    18774    player_club 
   TABLE DATA                 public          postgres    false    217       3422.dat o           0    0    match_and_schedule_id_ms_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.match_and_schedule_id_ms_seq', 10, true);
          public          postgres    false    219         p           0    0    player_id_p_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.player_id_p_seq', 15, true);
          public          postgres    false    215         �           2606    18756    club club_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_pkey PRIMARY KEY (name_cl);
 8   ALTER TABLE ONLY public.club DROP CONSTRAINT club_pkey;
       public            postgres    false    214         �           2606    18758    club club_stadium_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_stadium_key UNIQUE (stadium);
 ?   ALTER TABLE ONLY public.club DROP CONSTRAINT club_stadium_key;
       public            postgres    false    214         �           2606    18760    club club_story_key 
   CONSTRAINT     O   ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_story_key UNIQUE (story);
 =   ALTER TABLE ONLY public.club DROP CONSTRAINT club_story_key;
       public            postgres    false    214         �           2606    18795    coach coach_name_cl_coach_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.coach
    ADD CONSTRAINT coach_name_cl_coach_key UNIQUE (name_cl_coach);
 G   ALTER TABLE ONLY public.coach DROP CONSTRAINT coach_name_cl_coach_key;
       public            postgres    false    218         �           2606    18918 *   drop_category_club drop_category_club_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.drop_category_club
    ADD CONSTRAINT drop_category_club_pkey PRIMARY KEY (name_cl);
 T   ALTER TABLE ONLY public.drop_category_club DROP CONSTRAINT drop_category_club_pkey;
       public            postgres    false    225         �           2606    18920 1   drop_category_club drop_category_club_stadium_key 
   CONSTRAINT     o   ALTER TABLE ONLY public.drop_category_club
    ADD CONSTRAINT drop_category_club_stadium_key UNIQUE (stadium);
 [   ALTER TABLE ONLY public.drop_category_club DROP CONSTRAINT drop_category_club_stadium_key;
       public            postgres    false    225         �           2606    18922 /   drop_category_club drop_category_club_story_key 
   CONSTRAINT     k   ALTER TABLE ONLY public.drop_category_club
    ADD CONSTRAINT drop_category_club_story_key UNIQUE (story);
 Y   ALTER TABLE ONLY public.drop_category_club DROP CONSTRAINT drop_category_club_story_key;
       public            postgres    false    225         �           2606    18839 (   match_and_corners match_and_corners_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.match_and_corners
    ADD CONSTRAINT match_and_corners_pkey PRIMARY KEY (id_ms, "time");
 R   ALTER TABLE ONLY public.match_and_corners DROP CONSTRAINT match_and_corners_pkey;
       public            postgres    false    222    222         �           2606    18851 2   match_and_player_cards match_and_player_cards_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.match_and_player_cards
    ADD CONSTRAINT match_and_player_cards_pkey PRIMARY KEY (id_ms, "time");
 \   ALTER TABLE ONLY public.match_and_player_cards DROP CONSTRAINT match_and_player_cards_pkey;
       public            postgres    false    223    223         �           2606    18824 2   match_and_player_goals match_and_player_goals_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.match_and_player_goals
    ADD CONSTRAINT match_and_player_goals_pkey PRIMARY KEY (id_ms, "time");
 \   ALTER TABLE ONLY public.match_and_player_goals DROP CONSTRAINT match_and_player_goals_pkey;
       public            postgres    false    221    221         �           2606    18866 >   match_and_player_time_played match_and_player_time_played_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_time_played
    ADD CONSTRAINT match_and_player_time_played_pkey PRIMARY KEY (id_ms, id_player);
 h   ALTER TABLE ONLY public.match_and_player_time_played DROP CONSTRAINT match_and_player_time_played_pkey;
       public            postgres    false    224    224         �           2606    18807 *   match_and_schedule match_and_schedule_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT match_and_schedule_pkey PRIMARY KEY (id_ms);
 T   ALTER TABLE ONLY public.match_and_schedule DROP CONSTRAINT match_and_schedule_pkey;
       public            postgres    false    220         �           2606    18778    player_club player_club_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.player_club
    ADD CONSTRAINT player_club_pkey PRIMARY KEY (id_p, name_cl);
 F   ALTER TABLE ONLY public.player_club DROP CONSTRAINT player_club_pkey;
       public            postgres    false    217    217         �           2606    18768    player player_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_pkey PRIMARY KEY (id_p);
 <   ALTER TABLE ONLY public.player DROP CONSTRAINT player_pkey;
       public            postgres    false    216         �           2606    18809 *   match_and_schedule unique_match_teams_date 
   CONSTRAINT        ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT unique_match_teams_date UNIQUE (home_club, visiting_club, date);
 T   ALTER TABLE ONLY public.match_and_schedule DROP CONSTRAINT unique_match_teams_date;
       public            postgres    false    220    220    220         �           2620    18880 /   match_and_schedule check_match_schedule_trigger    TRIGGER     �   CREATE TRIGGER check_match_schedule_trigger BEFORE INSERT ON public.match_and_schedule FOR EACH ROW EXECUTE FUNCTION public.check_match_schedule();
 H   DROP TRIGGER check_match_schedule_trigger ON public.match_and_schedule;
       public          postgres    false    220    229         �           2620    18924    club clubs_log    TRIGGER     p   CREATE TRIGGER clubs_log AFTER DELETE ON public.club FOR EACH ROW EXECUTE FUNCTION public.clubs_log_function();
 '   DROP TRIGGER clubs_log ON public.club;
       public          postgres    false    214    230         �           2620    18878    player limit_player_count    TRIGGER     |   CREATE TRIGGER limit_player_count BEFORE INSERT ON public.player FOR EACH ROW EXECUTE FUNCTION public.check_player_count();
 2   DROP TRIGGER limit_player_count ON public.player;
       public          postgres    false    216    228         �           2606    18796    coach coach_name_cl_coach_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.coach
    ADD CONSTRAINT coach_name_cl_coach_fkey FOREIGN KEY (name_cl_coach) REFERENCES public.club(name_cl);
 H   ALTER TABLE ONLY public.coach DROP CONSTRAINT coach_name_cl_coach_fkey;
       public          postgres    false    3230    218    214         �           2606    18840 .   match_and_corners match_and_corners_id_ms_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_corners
    ADD CONSTRAINT match_and_corners_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);
 X   ALTER TABLE ONLY public.match_and_corners DROP CONSTRAINT match_and_corners_id_ms_fkey;
       public          postgres    false    222    220    3242         �           2606    18852 8   match_and_player_cards match_and_player_cards_id_ms_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_cards
    ADD CONSTRAINT match_and_player_cards_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);
 b   ALTER TABLE ONLY public.match_and_player_cards DROP CONSTRAINT match_and_player_cards_id_ms_fkey;
       public          postgres    false    220    223    3242         �           2606    18857 <   match_and_player_cards match_and_player_cards_id_player_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_cards
    ADD CONSTRAINT match_and_player_cards_id_player_fkey FOREIGN KEY (id_player) REFERENCES public.player(id_p);
 f   ALTER TABLE ONLY public.match_and_player_cards DROP CONSTRAINT match_and_player_cards_id_player_fkey;
       public          postgres    false    3236    223    216         �           2606    18825 8   match_and_player_goals match_and_player_goals_id_ms_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_goals
    ADD CONSTRAINT match_and_player_goals_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);
 b   ALTER TABLE ONLY public.match_and_player_goals DROP CONSTRAINT match_and_player_goals_id_ms_fkey;
       public          postgres    false    220    3242    221         �           2606    18830 <   match_and_player_goals match_and_player_goals_id_player_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_goals
    ADD CONSTRAINT match_and_player_goals_id_player_fkey FOREIGN KEY (id_player) REFERENCES public.player(id_p);
 f   ALTER TABLE ONLY public.match_and_player_goals DROP CONSTRAINT match_and_player_goals_id_player_fkey;
       public          postgres    false    3236    216    221         �           2606    18867 D   match_and_player_time_played match_and_player_time_played_id_ms_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_time_played
    ADD CONSTRAINT match_and_player_time_played_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);
 n   ALTER TABLE ONLY public.match_and_player_time_played DROP CONSTRAINT match_and_player_time_played_id_ms_fkey;
       public          postgres    false    224    220    3242         �           2606    18872 H   match_and_player_time_played match_and_player_time_played_id_player_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_time_played
    ADD CONSTRAINT match_and_player_time_played_id_player_fkey FOREIGN KEY (id_player) REFERENCES public.player(id_p);
 r   ALTER TABLE ONLY public.match_and_player_time_played DROP CONSTRAINT match_and_player_time_played_id_player_fkey;
       public          postgres    false    3236    216    224         �           2606    18810 4   match_and_schedule match_and_schedule_home_club_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT match_and_schedule_home_club_fkey FOREIGN KEY (home_club) REFERENCES public.club(name_cl);
 ^   ALTER TABLE ONLY public.match_and_schedule DROP CONSTRAINT match_and_schedule_home_club_fkey;
       public          postgres    false    220    3230    214         �           2606    18815 8   match_and_schedule match_and_schedule_visiting_club_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT match_and_schedule_visiting_club_fkey FOREIGN KEY (visiting_club) REFERENCES public.club(name_cl);
 b   ALTER TABLE ONLY public.match_and_schedule DROP CONSTRAINT match_and_schedule_visiting_club_fkey;
       public          postgres    false    3230    220    214         �           2606    18779 !   player_club player_club_id_p_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.player_club
    ADD CONSTRAINT player_club_id_p_fkey FOREIGN KEY (id_p) REFERENCES public.player(id_p);
 K   ALTER TABLE ONLY public.player_club DROP CONSTRAINT player_club_id_p_fkey;
       public          postgres    false    217    216    3236         �           2606    18784 $   player_club player_club_name_cl_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.player_club
    ADD CONSTRAINT player_club_name_cl_fkey FOREIGN KEY (name_cl) REFERENCES public.club(name_cl);
 N   ALTER TABLE ONLY public.player_club DROP CONSTRAINT player_club_name_cl_fkey;
       public          postgres    false    217    214    3230         �           2606    18769    player player_name_cl_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_name_cl_fkey FOREIGN KEY (name_cl) REFERENCES public.club(name_cl);
 D   ALTER TABLE ONLY public.player DROP CONSTRAINT player_name_cl_fkey;
       public          postgres    false    214    3230    216                                                                                                                                                             3419.dat                                                                                            0000600 0004000 0002000 00000003267 14447250777 0014303 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.club (name_cl, stadium, story, wins_home, wins_away, losses_home, losses_away, draws_home, draws_away) VALUES ('Olympiacos', 'Georgios Karaiskakis', 'Founded on 10 March 1925, Olympiacos is the most successful club in Greek football history,having won 47 League titles, 28 Cups (18 Doubles) and 4 Super Cups, all records. Τotalling 79 national trophies, Olympiacos is 9th in the world in total titles won by a football club', 5, 2, 0, 1, 1, 1);
INSERT INTO public.club (name_cl, stadium, story, wins_home, wins_away, losses_home, losses_away, draws_home, draws_away) VALUES ('Aek', 'OPAP Arena', 'The large Greek population of Constantinople, not unlike that of the other Ottoman urban centres, continued its athletic traditions in the form of numerous athletic clubs. Clubs such as Énosis Tatávlon (Ένωσις Ταταύλων) and Iraklís (Ηρακλής) from the Tatavla district, Mégas Aléxandros (Μέγας Αλέξανδρος) and Ermís (Ερμής) of Galata, and Olympiás (Ολυμπιάς) of Therapia existed to promote Hellenic athletic and cultural ideals. These were amongst a dozen Greek-backed clubs that dominated the sporting landscape of the city in the years preceding World War I.', 4, 2, 1, 1, 0, 2);
INSERT INTO public.club (name_cl, stadium, story, wins_home, wins_away, losses_home, losses_away, draws_home, draws_away) VALUES ('Panathinaikos', 'Apostolos Nikolaidis', 'Created in 1908 as "Podosfairikos Omilos Athinon" (Football Club of Athens) by Georgios Kalafatis,they play in Super League Greece, being one of the most successful clubs in Greek football and one of the three clubs which have never been relegated from the top division', 4, 0, 2, 1, 1, 2);


                                                                                                                                                                                                                                                                                                                                         3423.dat                                                                                            0000600 0004000 0002000 00000000752 14447250777 0014272 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.coach (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active, is_coach, name_cl_coach) VALUES (1, 'Παναγιώτης', 'Ρέτσος', 'Olympiacos', 'Defender', 2, 0, 0, false, true, 'Olympiacos');
INSERT INTO public.coach (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active, is_coach, name_cl_coach) VALUES (15, 'Ρούμπεν', 'Πέρεθ', 'Panathinaikos', 'Midfielder', 0, 0, 12, false, true, 'Panathinaikos');


                      3430.dat                                                                                            0000600 0004000 0002000 00000000716 14447250777 0014270 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.drop_category_club (name_cl, stadium, story, wins_home, wins_away, losses_home, losses_away, draws_home, draws_away, deleted_at) VALUES ('PP', 'Georgios Kis', 'Founded on 10 March 192Greek football history,having won 47 League titles, 28 Cups (18 Doubles) and 4 Super Cups, all records. Τotalling 79 national trophies, Olympiacos is 9th in the world in total titles won by a football club', 5, 2, 0, 1, 1, 1, '2023-06-24 13:28:53.627974');


                                                  3427.dat                                                                                            0000600 0004000 0002000 00000001333 14447250777 0014272 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.match_and_corners (id_ms, corner, "time") VALUES (1, true, '10:42:00');
INSERT INTO public.match_and_corners (id_ms, corner, "time") VALUES (1, true, '17:35:00');
INSERT INTO public.match_and_corners (id_ms, corner, "time") VALUES (1, true, '60:55:00');
INSERT INTO public.match_and_corners (id_ms, corner, "time") VALUES (2, true, '17:38:00');
INSERT INTO public.match_and_corners (id_ms, corner, "time") VALUES (3, true, '68:39:00');
INSERT INTO public.match_and_corners (id_ms, corner, "time") VALUES (5, true, '90:01:00');
INSERT INTO public.match_and_corners (id_ms, corner, "time") VALUES (8, true, '48:47:00');
INSERT INTO public.match_and_corners (id_ms, corner, "time") VALUES (10, true, '89:15:00');


                                                                                                                                                                                                                                                                                                     3428.dat                                                                                            0000600 0004000 0002000 00000001202 14447250777 0014266 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.match_and_player_cards (id_ms, cards_y, cards_r, id_player, "time") VALUES (1, true, false, 2, '13:25:00');
INSERT INTO public.match_and_player_cards (id_ms, cards_y, cards_r, id_player, "time") VALUES (2, true, false, 3, '54:05:00');
INSERT INTO public.match_and_player_cards (id_ms, cards_y, cards_r, id_player, "time") VALUES (10, true, false, 11, '46:19:00');
INSERT INTO public.match_and_player_cards (id_ms, cards_y, cards_r, id_player, "time") VALUES (9, false, true, 11, '61:05:00');
INSERT INTO public.match_and_player_cards (id_ms, cards_y, cards_r, id_player, "time") VALUES (10, false, true, 12, '65:08:00');


                                                                                                                                                                                                                                                                                                                                                                                              3426.dat                                                                                            0000600 0004000 0002000 00000007007 14447250777 0014275 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (1, false, true, false, 2, '10:35:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (2, false, false, true, 3, '27:13:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (3, false, true, false, 7, '32:59:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (4, false, true, false, 8, '32:39:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (5, false, true, false, 11, '81:10:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (6, true, false, false, 12, '91:50:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (7, false, false, true, 9, '45:10:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (8, false, true, false, 12, '90:15:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (9, true, false, false, 13, '10:29:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (10, false, true, false, 14, '01:10:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (1, true, false, false, 2, '10:45:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (2, false, false, true, 3, '11:47:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (3, false, false, true, 7, '87:40:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (4, true, false, false, 8, '41:01:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (5, false, true, false, 12, '61:15:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (6, true, false, false, 12, '71:11:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (7, false, true, false, 8, '68:17:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (8, false, true, false, 13, '69:39:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (9, false, true, false, 13, '28:48:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (10, false, true, false, 14, '18:39:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (10, false, true, false, 3, '67:59:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (5, false, true, false, 4, '13:17:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (5, false, true, false, 3, '28:54:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (5, false, true, false, 4, '89:11:00');
INSERT INTO public.match_and_player_goals (id_ms, penalty, goals_s, goals_c, id_player, "time") VALUES (7, true, false, false, 14, '20:45:00');


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         3429.dat                                                                                            0000600 0004000 0002000 00000020647 14447250777 0014305 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (1, 2, '09:42:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (1, 3, '83:27:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (1, 4, '15:01:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (1, 5, '98:58:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (1, 7, '20:33:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (1, 8, '52:09:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (1, 9, '43:17:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (1, 10, '115:22:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (2, 2, '34:11:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (2, 3, '60:19:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (2, 4, '23:40:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (2, 5, '95:50:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (2, 7, '09:08:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (2, 8, '72:54:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (2, 9, '30:47:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (2, 10, '86:38:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (3, 7, '16:14:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (3, 8, '53:56:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (3, 9, '74:27:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (3, 10, '39:05:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (3, 11, '107:39:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (3, 12, '29:46:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (3, 13, '65:59:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (3, 14, '12:54:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (4, 7, '45:32:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (4, 8, '27:04:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (4, 9, '91:15:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (4, 10, '61:27:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (4, 11, '102:58:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (4, 12, '20:05:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (4, 13, '58:37:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (4, 14, '34:41:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (5, 2, '73:51:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (5, 3, '16:24:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (5, 4, '88:40:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (5, 5, '54:16:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (5, 11, '112:45:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (5, 12, '41:18:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (5, 13, '76:59:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (5, 14, '22:37:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (6, 2, '39:57:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (6, 3, '75:43:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (6, 4, '48:26:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (6, 5, '84:55:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (6, 11, '33:12:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (6, 12, '65:35:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (6, 13, '21:48:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (6, 14, '52:57:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (7, 7, '59:08:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (7, 8, '32:40:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (7, 9, '76:52:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (7, 10, '45:09:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (7, 11, '91:01:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (7, 12, '18:14:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (7, 13, '62:27:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (7, 14, '27:37:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (8, 7, '20:02:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (8, 8, '47:43:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (8, 9, '88:22:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (8, 10, '11:36:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (8, 11, '105:49:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (8, 12, '23:30:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (8, 13, '54:58:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (8, 14, '30:19:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (9, 7, '61:28:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (9, 8, '28:04:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (9, 9, '82:12:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (9, 10, '17:32:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (9, 11, '95:53:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (9, 12, '37:14:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (9, 13, '68:44:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (9, 14, '43:06:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (10, 2, '94:05:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (10, 3, '45:28:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (10, 4, '116:07:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (10, 5, '60:33:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (10, 11, '14:50:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (10, 12, '87:03:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (10, 13, '28:16:00');
INSERT INTO public.match_and_player_time_played (id_ms, id_player, time_played) VALUES (10, 14, '75:22:00');


                                                                                         3425.dat                                                                                            0000600 0004000 0002000 00000003155 14447250777 0014274 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.match_and_schedule (id_ms, home_club, visiting_club, home_score, visiting_score, date) VALUES (1, 'Olympiacos', 'Aek', 1, 0, '2023-02-15');
INSERT INTO public.match_and_schedule (id_ms, home_club, visiting_club, home_score, visiting_score, date) VALUES (2, 'Aek', 'Olympiacos', 0, 0, '2023-02-26');
INSERT INTO public.match_and_schedule (id_ms, home_club, visiting_club, home_score, visiting_score, date) VALUES (3, 'Aek', 'Panathinaikos', 1, 0, '2023-03-21');
INSERT INTO public.match_and_schedule (id_ms, home_club, visiting_club, home_score, visiting_score, date) VALUES (4, 'Panathinaikos', 'Aek', 0, 1, '2023-04-01');
INSERT INTO public.match_and_schedule (id_ms, home_club, visiting_club, home_score, visiting_score, date) VALUES (5, 'Olympiacos', 'Panathinaikos', 0, 2, '2023-04-09');
INSERT INTO public.match_and_schedule (id_ms, home_club, visiting_club, home_score, visiting_score, date) VALUES (6, 'Panathinaikos', 'Olympiacos', 0, 0, '2023-04-23');
INSERT INTO public.match_and_schedule (id_ms, home_club, visiting_club, home_score, visiting_score, date) VALUES (7, 'Aek', 'Panathinaikos', 1, 0, '2023-05-17');
INSERT INTO public.match_and_schedule (id_ms, home_club, visiting_club, home_score, visiting_score, date) VALUES (8, 'Olympiacos', 'Panathinaikos', 0, 2, '2023-05-30');
INSERT INTO public.match_and_schedule (id_ms, home_club, visiting_club, home_score, visiting_score, date) VALUES (9, 'Panathinaikos', 'Aek', 1, 0, '2023-06-14');
INSERT INTO public.match_and_schedule (id_ms, home_club, visiting_club, home_score, visiting_score, date) VALUES (10, 'Panathinaikos', 'Olympiacos', 2, 1, '2023-06-29');


                                                                                                                                                                                                                                                                                                                                                                                                                   3421.dat                                                                                            0000600 0004000 0002000 00000005627 14447250777 0014276 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (1, 'Παναγιώτης', 'Ρέτσος', 'Olympiacos', 'Defender', 2, 0, 0, false);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (2, 'Κώστας', 'Φορτούνης', 'Olympiacos', 'Midfielder', 0, 0, 2, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (3, 'Υούσεφ', 'Ελ-Αραμπί', 'Olympiacos', 'Forward', 0, 0, 1, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (4, 'Τζέιμς', 'Ροντρίγκες', 'Olympiacos', 'Midfielder', 0, 0, 0, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (5, 'Μαρσέλο', 'Βιέιρα', 'Olympiacos', 'Defender', 0, 0, 2, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (6, 'Γιώργος', 'Τζαβέλας', 'Aek', 'Defender', 0, 0, 1, false);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (7, 'Πέτρος', 'Μάνταλος', 'Aek', 'Forward', 0, 0, 8, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (8, 'Γιώργος', 'Αθανασιάδης', 'Aek', 'GoalKeeper', 1, 0, 2, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (9, 'Κωνσταντίνος', 'Γαλανόπουλος', 'Aek', 'Midfielder', 0, 0, 7, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (10, 'Λάζαρος', 'Ρότας', 'Aek', 'Defender', 0, 0, 2, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (11, 'Φώτης', 'Ιωαννίδης', 'Panathinaikos', 'Forward', 0, 0, 12, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (12, 'Λεονάρντο', 'Φρόκκου', 'Panathinaikos', 'Midfielder', 0, 1, 0, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (13, 'Αλμπέρτο', 'Μπρινιόλι', 'Panathinaikos', 'Goalkeeper', 0, 0, 12, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (14, 'Σεμπαστιάν', 'Παλάσιος', 'Panathinaikos', 'Midfielder', 0, 0, 12, true);
INSERT INTO public.player (id_p, name, surname, name_cl, "position", cards_y, cards_r, goals, is_active) VALUES (15, 'Ρούμπεν', 'Πέρεθ', 'Panathinaikos', 'Midfielder', 0, 0, 12, false);


                                                                                                         3422.dat                                                                                            0000600 0004000 0002000 00000002073 14447250777 0014267 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.player_club (id_p, name_cl) VALUES (1, 'Olympiacos');
INSERT INTO public.player_club (id_p, name_cl) VALUES (2, 'Olympiacos');
INSERT INTO public.player_club (id_p, name_cl) VALUES (3, 'Olympiacos');
INSERT INTO public.player_club (id_p, name_cl) VALUES (4, 'Olympiacos');
INSERT INTO public.player_club (id_p, name_cl) VALUES (5, 'Olympiacos');
INSERT INTO public.player_club (id_p, name_cl) VALUES (6, 'Aek');
INSERT INTO public.player_club (id_p, name_cl) VALUES (7, 'Aek');
INSERT INTO public.player_club (id_p, name_cl) VALUES (8, 'Aek');
INSERT INTO public.player_club (id_p, name_cl) VALUES (9, 'Aek');
INSERT INTO public.player_club (id_p, name_cl) VALUES (10, 'Aek');
INSERT INTO public.player_club (id_p, name_cl) VALUES (11, 'Panathinaikos');
INSERT INTO public.player_club (id_p, name_cl) VALUES (12, 'Panathinaikos');
INSERT INTO public.player_club (id_p, name_cl) VALUES (13, 'Panathinaikos');
INSERT INTO public.player_club (id_p, name_cl) VALUES (14, 'Panathinaikos');
INSERT INTO public.player_club (id_p, name_cl) VALUES (15, 'Panathinaikos');


                                                                                                                                                                                                                                                                                                                                                                                                                                                                     restore.sql                                                                                         0000600 0004000 0002000 00000046651 14447250777 0015421 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE "FootballCup";
--
-- Name: FootballCup; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "FootballCup" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE "FootballCup" OWNER TO postgres;

\connect "FootballCup"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: check_match_schedule(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_match_schedule() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    previous_match_date DATE;
BEGIN
    -- Check if the home team has a match within 10 days before or after the current match
    SELECT date INTO previous_match_date
    FROM match_and_schedule
    WHERE (home_club = NEW.home_club OR visiting_club = NEW.home_club)
    AND date >= NEW.date - INTERVAL '10 days'
    AND date <= NEW.date + INTERVAL '10 days'
    AND id_ms != NEW.id_ms;
    
    IF previous_match_date IS NOT NULL THEN
        RAISE EXCEPTION 'A team has a match within 10 days before or after this match.';
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_match_schedule() OWNER TO postgres;

--
-- Name: check_player_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_player_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  player_count INTEGER;
BEGIN
  -- Get the count of rows for the current club name
  SELECT COUNT(*) INTO player_count
  FROM player
  WHERE name_cl = NEW.name_cl;

  -- Raise an exception if the row count exceeds the limit
  IF player_count >= 11 THEN
    RAISE EXCEPTION 'Maximum row limit reached for club: %', NEW.name_cl;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_player_count() OWNER TO postgres;

--
-- Name: clubs_log_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.clubs_log_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO drop_category_club (name_cl, stadium, story, wins_home, wins_away, losses_home, losses_away, draws_home, draws_away)
    VALUES (OLD.name_cl, OLD.stadium, OLD.story, OLD.wins_home, OLD.wins_away, OLD.losses_home, OLD.losses_away, OLD.draws_home, OLD.draws_away);
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.clubs_log_function() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: club; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.club (
    name_cl character varying(30) NOT NULL,
    stadium character varying(50) NOT NULL,
    story character varying(1000) NOT NULL,
    wins_home integer NOT NULL,
    wins_away integer NOT NULL,
    losses_home integer NOT NULL,
    losses_away integer NOT NULL,
    draws_home integer NOT NULL,
    draws_away integer NOT NULL
);


ALTER TABLE public.club OWNER TO postgres;

--
-- Name: player; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.player (
    id_p integer NOT NULL,
    name character varying(20) NOT NULL,
    surname character varying(20) NOT NULL,
    name_cl character varying(30) NOT NULL,
    "position" character varying(20) NOT NULL,
    cards_y integer NOT NULL,
    cards_r integer NOT NULL,
    goals integer NOT NULL,
    is_active boolean NOT NULL,
    CONSTRAINT name_charset CHECK ((((name)::text ~ '^[Α-Ωα-ωάέήίϊΐόύϋΰώ\-]+$'::text) AND ((surname)::text ~ '^[Α-Ωα-ωάέήίϊΐόύϋΰώ\-]+$'::text)))
);


ALTER TABLE public.player OWNER TO postgres;

--
-- Name: coach; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coach (
    is_coach boolean NOT NULL,
    name_cl_coach character varying(30) NOT NULL
)
INHERITS (public.player);


ALTER TABLE public.coach OWNER TO postgres;

--
-- Name: drop_category_club; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drop_category_club (
    name_cl character varying(30) NOT NULL,
    stadium character varying(50) NOT NULL,
    story character varying(1000) NOT NULL,
    wins_home integer NOT NULL,
    wins_away integer NOT NULL,
    losses_home integer NOT NULL,
    losses_away integer NOT NULL,
    draws_home integer NOT NULL,
    draws_away integer NOT NULL,
    deleted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.drop_category_club OWNER TO postgres;

--
-- Name: match_and_corners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.match_and_corners (
    id_ms integer NOT NULL,
    corner boolean NOT NULL,
    "time" interval NOT NULL
);


ALTER TABLE public.match_and_corners OWNER TO postgres;

--
-- Name: match_and_player_cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.match_and_player_cards (
    id_ms integer NOT NULL,
    cards_y boolean DEFAULT false NOT NULL,
    cards_r boolean DEFAULT false NOT NULL,
    id_player integer NOT NULL,
    "time" interval NOT NULL
);


ALTER TABLE public.match_and_player_cards OWNER TO postgres;

--
-- Name: match_and_player_goals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.match_and_player_goals (
    id_ms integer NOT NULL,
    penalty boolean NOT NULL,
    goals_s boolean NOT NULL,
    goals_c boolean NOT NULL,
    id_player integer,
    "time" interval NOT NULL
);


ALTER TABLE public.match_and_player_goals OWNER TO postgres;

--
-- Name: match_and_player_time_played; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.match_and_player_time_played (
    id_ms integer NOT NULL,
    id_player integer NOT NULL,
    time_played interval NOT NULL
);


ALTER TABLE public.match_and_player_time_played OWNER TO postgres;

--
-- Name: match_and_schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.match_and_schedule (
    id_ms integer NOT NULL,
    home_club character varying(30) NOT NULL,
    visiting_club character varying(30) NOT NULL,
    home_score integer NOT NULL,
    visiting_score integer NOT NULL,
    date date NOT NULL
);


ALTER TABLE public.match_and_schedule OWNER TO postgres;

--
-- Name: match_and_schedule_id_ms_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.match_and_schedule_id_ms_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.match_and_schedule_id_ms_seq OWNER TO postgres;

--
-- Name: match_and_schedule_id_ms_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.match_and_schedule_id_ms_seq OWNED BY public.match_and_schedule.id_ms;


--
-- Name: player_club; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.player_club (
    id_p integer NOT NULL,
    name_cl character varying(30) NOT NULL
);


ALTER TABLE public.player_club OWNER TO postgres;

--
-- Name: player_id_p_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.player_id_p_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.player_id_p_seq OWNER TO postgres;

--
-- Name: player_id_p_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.player_id_p_seq OWNED BY public.player.id_p;


--
-- Name: schedule_match; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.schedule_match AS
 SELECT match_and_schedule.date,
    match_and_schedule.home_club,
    match_and_schedule.visiting_club,
    match_and_schedule.home_score,
    match_and_schedule.visiting_score,
    club.stadium,
    player.name,
    player.surname,
    player."position",
    player.name_cl,
    match_and_player_cards.cards_y,
    match_and_player_cards.cards_r,
    match_and_player_time_played.time_played,
    match_and_player_goals.goals_s,
    match_and_player_goals."time"
   FROM (((((public.match_and_schedule
     FULL JOIN public.club ON (((match_and_schedule.home_club)::text = (club.name_cl)::text)))
     FULL JOIN public.player ON ((((match_and_schedule.home_club)::text = (player.name_cl)::text) OR ((match_and_schedule.visiting_club)::text = (player.name_cl)::text))))
     LEFT JOIN public.match_and_player_cards ON (((player.id_p = match_and_player_cards.id_player) AND (match_and_schedule.id_ms = match_and_player_cards.id_ms))))
     FULL JOIN public.match_and_player_goals ON (((match_and_schedule.id_ms = match_and_player_goals.id_ms) AND (match_and_player_goals.id_player = player.id_p))))
     FULL JOIN public.match_and_player_time_played ON (((match_and_player_time_played.id_ms = match_and_schedule.id_ms) AND (match_and_player_time_played.id_player = player.id_p))))
  WHERE ((match_and_schedule.date = '2023-06-29'::date) AND (player.is_active = true));


ALTER TABLE public.schedule_match OWNER TO postgres;

--
-- Name: season_matches; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.season_matches AS
 SELECT match_and_schedule.date,
    match_and_schedule.home_club,
    match_and_schedule.visiting_club,
    match_and_schedule.home_score,
    match_and_schedule.visiting_score,
    club.stadium
   FROM (public.match_and_schedule
     JOIN public.club ON (((match_and_schedule.home_club)::text = (club.name_cl)::text)))
  WHERE ((match_and_schedule.date >= '2023-04-01'::date) AND (match_and_schedule.date <= '2023-06-30'::date))
  ORDER BY match_and_schedule.date;


ALTER TABLE public.season_matches OWNER TO postgres;

--
-- Name: coach id_p; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coach ALTER COLUMN id_p SET DEFAULT nextval('public.player_id_p_seq'::regclass);


--
-- Name: match_and_schedule id_ms; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_schedule ALTER COLUMN id_ms SET DEFAULT nextval('public.match_and_schedule_id_ms_seq'::regclass);


--
-- Name: player id_p; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player ALTER COLUMN id_p SET DEFAULT nextval('public.player_id_p_seq'::regclass);


--
-- Data for Name: club; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3419.dat

--
-- Data for Name: coach; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3423.dat

--
-- Data for Name: drop_category_club; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3430.dat

--
-- Data for Name: match_and_corners; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3427.dat

--
-- Data for Name: match_and_player_cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3428.dat

--
-- Data for Name: match_and_player_goals; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3426.dat

--
-- Data for Name: match_and_player_time_played; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3429.dat

--
-- Data for Name: match_and_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3425.dat

--
-- Data for Name: player; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3421.dat

--
-- Data for Name: player_club; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3422.dat

--
-- Name: match_and_schedule_id_ms_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.match_and_schedule_id_ms_seq', 10, true);


--
-- Name: player_id_p_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.player_id_p_seq', 15, true);


--
-- Name: club club_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_pkey PRIMARY KEY (name_cl);


--
-- Name: club club_stadium_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_stadium_key UNIQUE (stadium);


--
-- Name: club club_story_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_story_key UNIQUE (story);


--
-- Name: coach coach_name_cl_coach_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coach
    ADD CONSTRAINT coach_name_cl_coach_key UNIQUE (name_cl_coach);


--
-- Name: drop_category_club drop_category_club_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drop_category_club
    ADD CONSTRAINT drop_category_club_pkey PRIMARY KEY (name_cl);


--
-- Name: drop_category_club drop_category_club_stadium_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drop_category_club
    ADD CONSTRAINT drop_category_club_stadium_key UNIQUE (stadium);


--
-- Name: drop_category_club drop_category_club_story_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drop_category_club
    ADD CONSTRAINT drop_category_club_story_key UNIQUE (story);


--
-- Name: match_and_corners match_and_corners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_corners
    ADD CONSTRAINT match_and_corners_pkey PRIMARY KEY (id_ms, "time");


--
-- Name: match_and_player_cards match_and_player_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_player_cards
    ADD CONSTRAINT match_and_player_cards_pkey PRIMARY KEY (id_ms, "time");


--
-- Name: match_and_player_goals match_and_player_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_player_goals
    ADD CONSTRAINT match_and_player_goals_pkey PRIMARY KEY (id_ms, "time");


--
-- Name: match_and_player_time_played match_and_player_time_played_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_player_time_played
    ADD CONSTRAINT match_and_player_time_played_pkey PRIMARY KEY (id_ms, id_player);


--
-- Name: match_and_schedule match_and_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT match_and_schedule_pkey PRIMARY KEY (id_ms);


--
-- Name: player_club player_club_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_club
    ADD CONSTRAINT player_club_pkey PRIMARY KEY (id_p, name_cl);


--
-- Name: player player_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_pkey PRIMARY KEY (id_p);


--
-- Name: match_and_schedule unique_match_teams_date; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT unique_match_teams_date UNIQUE (home_club, visiting_club, date);


--
-- Name: match_and_schedule check_match_schedule_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_match_schedule_trigger BEFORE INSERT ON public.match_and_schedule FOR EACH ROW EXECUTE FUNCTION public.check_match_schedule();


--
-- Name: club clubs_log; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER clubs_log AFTER DELETE ON public.club FOR EACH ROW EXECUTE FUNCTION public.clubs_log_function();


--
-- Name: player limit_player_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER limit_player_count BEFORE INSERT ON public.player FOR EACH ROW EXECUTE FUNCTION public.check_player_count();


--
-- Name: coach coach_name_cl_coach_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coach
    ADD CONSTRAINT coach_name_cl_coach_fkey FOREIGN KEY (name_cl_coach) REFERENCES public.club(name_cl);


--
-- Name: match_and_corners match_and_corners_id_ms_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_corners
    ADD CONSTRAINT match_and_corners_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);


--
-- Name: match_and_player_cards match_and_player_cards_id_ms_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_player_cards
    ADD CONSTRAINT match_and_player_cards_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);


--
-- Name: match_and_player_cards match_and_player_cards_id_player_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_player_cards
    ADD CONSTRAINT match_and_player_cards_id_player_fkey FOREIGN KEY (id_player) REFERENCES public.player(id_p);


--
-- Name: match_and_player_goals match_and_player_goals_id_ms_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_player_goals
    ADD CONSTRAINT match_and_player_goals_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);


--
-- Name: match_and_player_goals match_and_player_goals_id_player_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_player_goals
    ADD CONSTRAINT match_and_player_goals_id_player_fkey FOREIGN KEY (id_player) REFERENCES public.player(id_p);


--
-- Name: match_and_player_time_played match_and_player_time_played_id_ms_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_player_time_played
    ADD CONSTRAINT match_and_player_time_played_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);


--
-- Name: match_and_player_time_played match_and_player_time_played_id_player_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_player_time_played
    ADD CONSTRAINT match_and_player_time_played_id_player_fkey FOREIGN KEY (id_player) REFERENCES public.player(id_p);


--
-- Name: match_and_schedule match_and_schedule_home_club_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT match_and_schedule_home_club_fkey FOREIGN KEY (home_club) REFERENCES public.club(name_cl);


--
-- Name: match_and_schedule match_and_schedule_visiting_club_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT match_and_schedule_visiting_club_fkey FOREIGN KEY (visiting_club) REFERENCES public.club(name_cl);


--
-- Name: player_club player_club_id_p_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_club
    ADD CONSTRAINT player_club_id_p_fkey FOREIGN KEY (id_p) REFERENCES public.player(id_p);


--
-- Name: player_club player_club_name_cl_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_club
    ADD CONSTRAINT player_club_name_cl_fkey FOREIGN KEY (name_cl) REFERENCES public.club(name_cl);


--
-- Name: player player_name_cl_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_name_cl_fkey FOREIGN KEY (name_cl) REFERENCES public.club(name_cl);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       