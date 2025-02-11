PGDMP         .                {           FootballCup    15.3    15.2 E    i           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            j           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            k           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            l           1262    16531    FootballCup    DATABASE     �   CREATE DATABASE "FootballCup" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "FootballCup";
                postgres    false            �            1255    18879    check_match_schedule()    FUNCTION     �  CREATE FUNCTION public.check_match_schedule() RETURNS trigger
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
       public          postgres    false            �            1255    18877    check_player_count()    FUNCTION     �  CREATE FUNCTION public.check_player_count() RETURNS trigger
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
       public          postgres    false            �            1255    18923    clubs_log_function()    FUNCTION     �  CREATE FUNCTION public.clubs_log_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO drop_category_club (name_cl, stadium, story, wins_home, wins_away, losses_home, losses_away, draws_home, draws_away)
    VALUES (OLD.name_cl, OLD.stadium, OLD.story, OLD.wins_home, OLD.wins_away, OLD.losses_home, OLD.losses_away, OLD.draws_home, OLD.draws_away);
    RETURN NULL;
END;
$$;
 +   DROP FUNCTION public.clubs_log_function();
       public          postgres    false            �            1259    18750    club    TABLE     g  CREATE TABLE public.club (
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
       public         heap    postgres    false            �            1259    18762    player    TABLE       CREATE TABLE public.player (
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
       public         heap    postgres    false            �            1259    18789    coach    TABLE     �   CREATE TABLE public.coach (
    is_coach boolean NOT NULL,
    name_cl_coach character varying(30) NOT NULL
)
INHERITS (public.player);
    DROP TABLE public.coach;
       public         heap    postgres    false    216            �            1259    18911    drop_category_club    TABLE     �  CREATE TABLE public.drop_category_club (
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
       public         heap    postgres    false            �            1259    18835    match_and_corners    TABLE     �   CREATE TABLE public.match_and_corners (
    id_ms integer NOT NULL,
    corner boolean NOT NULL,
    "time" interval NOT NULL
);
 %   DROP TABLE public.match_and_corners;
       public         heap    postgres    false            �            1259    18845    match_and_player_cards    TABLE     �   CREATE TABLE public.match_and_player_cards (
    id_ms integer NOT NULL,
    cards_y boolean DEFAULT false NOT NULL,
    cards_r boolean DEFAULT false NOT NULL,
    id_player integer NOT NULL,
    "time" interval NOT NULL
);
 *   DROP TABLE public.match_and_player_cards;
       public         heap    postgres    false            �            1259    18820    match_and_player_goals    TABLE     �   CREATE TABLE public.match_and_player_goals (
    id_ms integer NOT NULL,
    penalty boolean NOT NULL,
    goals_s boolean NOT NULL,
    goals_c boolean NOT NULL,
    id_player integer,
    "time" interval NOT NULL
);
 *   DROP TABLE public.match_and_player_goals;
       public         heap    postgres    false            �            1259    18862    match_and_player_time_played    TABLE     �   CREATE TABLE public.match_and_player_time_played (
    id_ms integer NOT NULL,
    id_player integer NOT NULL,
    time_played interval NOT NULL
);
 0   DROP TABLE public.match_and_player_time_played;
       public         heap    postgres    false            �            1259    18802    match_and_schedule    TABLE       CREATE TABLE public.match_and_schedule (
    id_ms integer NOT NULL,
    home_club character varying(30) NOT NULL,
    visiting_club character varying(30) NOT NULL,
    home_score integer NOT NULL,
    visiting_score integer NOT NULL,
    date date NOT NULL
);
 &   DROP TABLE public.match_and_schedule;
       public         heap    postgres    false            �            1259    18801    match_and_schedule_id_ms_seq    SEQUENCE     �   CREATE SEQUENCE public.match_and_schedule_id_ms_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.match_and_schedule_id_ms_seq;
       public          postgres    false    220            m           0    0    match_and_schedule_id_ms_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.match_and_schedule_id_ms_seq OWNED BY public.match_and_schedule.id_ms;
          public          postgres    false    219            �            1259    18774    player_club    TABLE     k   CREATE TABLE public.player_club (
    id_p integer NOT NULL,
    name_cl character varying(30) NOT NULL
);
    DROP TABLE public.player_club;
       public         heap    postgres    false            �            1259    18761    player_id_p_seq    SEQUENCE     �   CREATE SEQUENCE public.player_id_p_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.player_id_p_seq;
       public          postgres    false    216            n           0    0    player_id_p_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.player_id_p_seq OWNED BY public.player.id_p;
          public          postgres    false    215            �            1259    18930    schedule_match    VIEW     ~  CREATE VIEW public.schedule_match AS
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
       public          postgres    false    216    216    216    223    223    214    220    220    220    224    220    220    220    221    224    224    221    221    221    223    223    216    214    216    216            �            1259    18935    season_matches    VIEW     �  CREATE VIEW public.season_matches AS
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
       public          postgres    false    220    220    220    220    220    214    214            �           2604    18792 
   coach id_p    DEFAULT     i   ALTER TABLE ONLY public.coach ALTER COLUMN id_p SET DEFAULT nextval('public.player_id_p_seq'::regclass);
 9   ALTER TABLE public.coach ALTER COLUMN id_p DROP DEFAULT;
       public          postgres    false    218    215            �           2604    18805    match_and_schedule id_ms    DEFAULT     �   ALTER TABLE ONLY public.match_and_schedule ALTER COLUMN id_ms SET DEFAULT nextval('public.match_and_schedule_id_ms_seq'::regclass);
 G   ALTER TABLE public.match_and_schedule ALTER COLUMN id_ms DROP DEFAULT;
       public          postgres    false    220    219    220            �           2604    18765    player id_p    DEFAULT     j   ALTER TABLE ONLY public.player ALTER COLUMN id_p SET DEFAULT nextval('public.player_id_p_seq'::regclass);
 :   ALTER TABLE public.player ALTER COLUMN id_p DROP DEFAULT;
       public          postgres    false    216    215    216            [          0    18750    club 
   TABLE DATA                 public          postgres    false    214   /f       _          0    18789    coach 
   TABLE DATA                 public          postgres    false    218   �i       f          0    18911    drop_category_club 
   TABLE DATA                 public          postgres    false    225   �j       c          0    18835    match_and_corners 
   TABLE DATA                 public          postgres    false    222   +l       d          0    18845    match_and_player_cards 
   TABLE DATA                 public          postgres    false    223   �l       b          0    18820    match_and_player_goals 
   TABLE DATA                 public          postgres    false    221   �m       e          0    18862    match_and_player_time_played 
   TABLE DATA                 public          postgres    false    224   o       a          0    18802    match_and_schedule 
   TABLE DATA                 public          postgres    false    220   �q       ]          0    18762    player 
   TABLE DATA                 public          postgres    false    216   �r       ^          0    18774    player_club 
   TABLE DATA                 public          postgres    false    217   }u       o           0    0    match_and_schedule_id_ms_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.match_and_schedule_id_ms_seq', 10, true);
          public          postgres    false    219            p           0    0    player_id_p_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.player_id_p_seq', 15, true);
          public          postgres    false    215            �           2606    18756    club club_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_pkey PRIMARY KEY (name_cl);
 8   ALTER TABLE ONLY public.club DROP CONSTRAINT club_pkey;
       public            postgres    false    214            �           2606    18758    club club_stadium_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_stadium_key UNIQUE (stadium);
 ?   ALTER TABLE ONLY public.club DROP CONSTRAINT club_stadium_key;
       public            postgres    false    214            �           2606    18760    club club_story_key 
   CONSTRAINT     O   ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_story_key UNIQUE (story);
 =   ALTER TABLE ONLY public.club DROP CONSTRAINT club_story_key;
       public            postgres    false    214            �           2606    18795    coach coach_name_cl_coach_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.coach
    ADD CONSTRAINT coach_name_cl_coach_key UNIQUE (name_cl_coach);
 G   ALTER TABLE ONLY public.coach DROP CONSTRAINT coach_name_cl_coach_key;
       public            postgres    false    218            �           2606    18918 *   drop_category_club drop_category_club_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.drop_category_club
    ADD CONSTRAINT drop_category_club_pkey PRIMARY KEY (name_cl);
 T   ALTER TABLE ONLY public.drop_category_club DROP CONSTRAINT drop_category_club_pkey;
       public            postgres    false    225            �           2606    18920 1   drop_category_club drop_category_club_stadium_key 
   CONSTRAINT     o   ALTER TABLE ONLY public.drop_category_club
    ADD CONSTRAINT drop_category_club_stadium_key UNIQUE (stadium);
 [   ALTER TABLE ONLY public.drop_category_club DROP CONSTRAINT drop_category_club_stadium_key;
       public            postgres    false    225            �           2606    18922 /   drop_category_club drop_category_club_story_key 
   CONSTRAINT     k   ALTER TABLE ONLY public.drop_category_club
    ADD CONSTRAINT drop_category_club_story_key UNIQUE (story);
 Y   ALTER TABLE ONLY public.drop_category_club DROP CONSTRAINT drop_category_club_story_key;
       public            postgres    false    225            �           2606    18839 (   match_and_corners match_and_corners_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.match_and_corners
    ADD CONSTRAINT match_and_corners_pkey PRIMARY KEY (id_ms, "time");
 R   ALTER TABLE ONLY public.match_and_corners DROP CONSTRAINT match_and_corners_pkey;
       public            postgres    false    222    222            �           2606    18851 2   match_and_player_cards match_and_player_cards_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.match_and_player_cards
    ADD CONSTRAINT match_and_player_cards_pkey PRIMARY KEY (id_ms, "time");
 \   ALTER TABLE ONLY public.match_and_player_cards DROP CONSTRAINT match_and_player_cards_pkey;
       public            postgres    false    223    223            �           2606    18824 2   match_and_player_goals match_and_player_goals_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.match_and_player_goals
    ADD CONSTRAINT match_and_player_goals_pkey PRIMARY KEY (id_ms, "time");
 \   ALTER TABLE ONLY public.match_and_player_goals DROP CONSTRAINT match_and_player_goals_pkey;
       public            postgres    false    221    221            �           2606    18866 >   match_and_player_time_played match_and_player_time_played_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_time_played
    ADD CONSTRAINT match_and_player_time_played_pkey PRIMARY KEY (id_ms, id_player);
 h   ALTER TABLE ONLY public.match_and_player_time_played DROP CONSTRAINT match_and_player_time_played_pkey;
       public            postgres    false    224    224            �           2606    18807 *   match_and_schedule match_and_schedule_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT match_and_schedule_pkey PRIMARY KEY (id_ms);
 T   ALTER TABLE ONLY public.match_and_schedule DROP CONSTRAINT match_and_schedule_pkey;
       public            postgres    false    220            �           2606    18778    player_club player_club_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.player_club
    ADD CONSTRAINT player_club_pkey PRIMARY KEY (id_p, name_cl);
 F   ALTER TABLE ONLY public.player_club DROP CONSTRAINT player_club_pkey;
       public            postgres    false    217    217            �           2606    18768    player player_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_pkey PRIMARY KEY (id_p);
 <   ALTER TABLE ONLY public.player DROP CONSTRAINT player_pkey;
       public            postgres    false    216            �           2606    18809 *   match_and_schedule unique_match_teams_date 
   CONSTRAINT        ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT unique_match_teams_date UNIQUE (home_club, visiting_club, date);
 T   ALTER TABLE ONLY public.match_and_schedule DROP CONSTRAINT unique_match_teams_date;
       public            postgres    false    220    220    220            �           2620    18880 /   match_and_schedule check_match_schedule_trigger    TRIGGER     �   CREATE TRIGGER check_match_schedule_trigger BEFORE INSERT ON public.match_and_schedule FOR EACH ROW EXECUTE FUNCTION public.check_match_schedule();
 H   DROP TRIGGER check_match_schedule_trigger ON public.match_and_schedule;
       public          postgres    false    220    229            �           2620    18924    club clubs_log    TRIGGER     p   CREATE TRIGGER clubs_log AFTER DELETE ON public.club FOR EACH ROW EXECUTE FUNCTION public.clubs_log_function();
 '   DROP TRIGGER clubs_log ON public.club;
       public          postgres    false    214    230            �           2620    18878    player limit_player_count    TRIGGER     |   CREATE TRIGGER limit_player_count BEFORE INSERT ON public.player FOR EACH ROW EXECUTE FUNCTION public.check_player_count();
 2   DROP TRIGGER limit_player_count ON public.player;
       public          postgres    false    216    228            �           2606    18796    coach coach_name_cl_coach_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.coach
    ADD CONSTRAINT coach_name_cl_coach_fkey FOREIGN KEY (name_cl_coach) REFERENCES public.club(name_cl);
 H   ALTER TABLE ONLY public.coach DROP CONSTRAINT coach_name_cl_coach_fkey;
       public          postgres    false    3230    218    214            �           2606    18840 .   match_and_corners match_and_corners_id_ms_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_corners
    ADD CONSTRAINT match_and_corners_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);
 X   ALTER TABLE ONLY public.match_and_corners DROP CONSTRAINT match_and_corners_id_ms_fkey;
       public          postgres    false    222    220    3242            �           2606    18852 8   match_and_player_cards match_and_player_cards_id_ms_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_cards
    ADD CONSTRAINT match_and_player_cards_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);
 b   ALTER TABLE ONLY public.match_and_player_cards DROP CONSTRAINT match_and_player_cards_id_ms_fkey;
       public          postgres    false    220    223    3242            �           2606    18857 <   match_and_player_cards match_and_player_cards_id_player_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_cards
    ADD CONSTRAINT match_and_player_cards_id_player_fkey FOREIGN KEY (id_player) REFERENCES public.player(id_p);
 f   ALTER TABLE ONLY public.match_and_player_cards DROP CONSTRAINT match_and_player_cards_id_player_fkey;
       public          postgres    false    3236    223    216            �           2606    18825 8   match_and_player_goals match_and_player_goals_id_ms_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_goals
    ADD CONSTRAINT match_and_player_goals_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);
 b   ALTER TABLE ONLY public.match_and_player_goals DROP CONSTRAINT match_and_player_goals_id_ms_fkey;
       public          postgres    false    220    3242    221            �           2606    18830 <   match_and_player_goals match_and_player_goals_id_player_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_goals
    ADD CONSTRAINT match_and_player_goals_id_player_fkey FOREIGN KEY (id_player) REFERENCES public.player(id_p);
 f   ALTER TABLE ONLY public.match_and_player_goals DROP CONSTRAINT match_and_player_goals_id_player_fkey;
       public          postgres    false    3236    216    221            �           2606    18867 D   match_and_player_time_played match_and_player_time_played_id_ms_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_time_played
    ADD CONSTRAINT match_and_player_time_played_id_ms_fkey FOREIGN KEY (id_ms) REFERENCES public.match_and_schedule(id_ms);
 n   ALTER TABLE ONLY public.match_and_player_time_played DROP CONSTRAINT match_and_player_time_played_id_ms_fkey;
       public          postgres    false    224    220    3242            �           2606    18872 H   match_and_player_time_played match_and_player_time_played_id_player_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_player_time_played
    ADD CONSTRAINT match_and_player_time_played_id_player_fkey FOREIGN KEY (id_player) REFERENCES public.player(id_p);
 r   ALTER TABLE ONLY public.match_and_player_time_played DROP CONSTRAINT match_and_player_time_played_id_player_fkey;
       public          postgres    false    3236    216    224            �           2606    18810 4   match_and_schedule match_and_schedule_home_club_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT match_and_schedule_home_club_fkey FOREIGN KEY (home_club) REFERENCES public.club(name_cl);
 ^   ALTER TABLE ONLY public.match_and_schedule DROP CONSTRAINT match_and_schedule_home_club_fkey;
       public          postgres    false    220    3230    214            �           2606    18815 8   match_and_schedule match_and_schedule_visiting_club_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_and_schedule
    ADD CONSTRAINT match_and_schedule_visiting_club_fkey FOREIGN KEY (visiting_club) REFERENCES public.club(name_cl);
 b   ALTER TABLE ONLY public.match_and_schedule DROP CONSTRAINT match_and_schedule_visiting_club_fkey;
       public          postgres    false    3230    220    214            �           2606    18779 !   player_club player_club_id_p_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.player_club
    ADD CONSTRAINT player_club_id_p_fkey FOREIGN KEY (id_p) REFERENCES public.player(id_p);
 K   ALTER TABLE ONLY public.player_club DROP CONSTRAINT player_club_id_p_fkey;
       public          postgres    false    217    216    3236            �           2606    18784 $   player_club player_club_name_cl_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.player_club
    ADD CONSTRAINT player_club_name_cl_fkey FOREIGN KEY (name_cl) REFERENCES public.club(name_cl);
 N   ALTER TABLE ONLY public.player_club DROP CONSTRAINT player_club_name_cl_fkey;
       public          postgres    false    217    214    3230            �           2606    18769    player player_name_cl_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_name_cl_fkey FOREIGN KEY (name_cl) REFERENCES public.club(name_cl);
 D   ALTER TABLE ONLY public.player DROP CONSTRAINT player_name_cl_fkey;
       public          postgres    false    214    3230    216            [   �  x��TMoE��W�r�Z,�e[�V�1���ڙڝ��t��{�YN@�$�K$��%$���{�U3���ri?f��_U�WU'��G�\�����fdM���f=�=�m!ba�J��3���\��g(V�!�ھz�N
���A���-�l��ӣs�m����63�<&��>F�&LqjZ�n\A���<B���?�}?�����%A�!Bh�B7ڊ��cO4�1s��P���/���L����C�ICM�2�݇æ���Ç,Q�t��yS�oO3P<O9�"lC�����8��Z����(�S>��f����ۢ}Q�Umf�9��Ե"aE���`'�~���`��t@SUlx68��'��v!�Y�Z�Ps�ؖ�1���\4�k+��#4Κ�QbT�����0F��A�G򛓋^I�Y�7�#&�XZ�&֥\��$��W�蚊<7w|�)��P���J� �+�Ad���x~i%�^�6�,��_�W�g�vz��Z�ߥ�˫tӵǉǩ]\K��_�����:��|�c�U�� �E(���c�/&q`/�
�g��S�N��D�^0��_�v��ԿO������X�tq��c�1k]��[<W��%�oқ��U�u�+y��z*�����T9|D֒�n�Rļ���Ҧ� �@�a�X���Ju�9�F��SAni�-�22 N	5��cc?�X�Z����Z�9���T���vh���mi��v(�������J���j�ݢԲ�X@�TLM�-�CO-Rl�`g_;���h�^�ae��@��݃ރ�Z��U�䈜�)Yw��ű\��p�Ŗ�n������K#R^������ޱR�-�\����g��y�]K��Rb�H��I[��XD�e$.M����ܹ��ʹ����y�      _     x�͐�J1���C/�B[��I��m�V�K�f��6Y�]�7���ϠЃ��`�L^����B~_���%M��SHF�1��E�bGh.f��,-(>�lmBh�T:��X�V��̦��`\j^XhS.*��ml���؃󃣳��}1=���~�O���������Vn��ix\,�%r�mC�2�*�����v�~��Z�Zn���GɿQ�n�@_��h�_X�[O�pū*�WA��e��m��x��KG�7]�h      f   D  x�E��n�0��<��R���BOUK*Th���[b�ؑ�4�}�<}�:Tɇ�k��.V�����n��:H�����>g��ڜ����*v"/CXǸ�N��i�Z(�/�Z�j�]�����ׄV߂�n}������a�>ۢl6A�`N���x���u�8qh�8�+3y�8K���Z�����[�#j�{�bI�X�p�l�d�Ǫ���<i�>���b[�d.i���P��}��h獦4͠�Z1	�V��t-ϧR����
� �`$�MCq!;���ћ��EG�/D"�� ���]4�K���d2��$��aл�t:�l��      c   �   x���v
Q���W((M��L��M,IΈO�K�O�/�K-*V��L��-�Q��u�J2sS�4�}B]�4uJ�JSu��L���5��<�l����)m�63�2���F(������W[X[R�hS�іV��4�n�����9U�� n����!,�� K�ݟ      d   �   x���v
Q���W((M��L��M,IΈO�K�/�I�L-�ON,J)V��L��-�Q ��+a�"�L�J����T%M�0G�P�`C����T��Ĝb e���nhledje`��i��I[�Ь7Zojbe@'���7�������%}`	����f�t T���v��� ��%      b   k  x�͖�n�@F�>���L����tՅ��&�vK�Җ�\���A1��qya���~���r��"����U�~����;�w�l_��}��UM&�&�֔�]^5'J��Y�]�))�O(7�O�����lI&@ɧ}���9���$�����q4}͑pؕ���[&pd�OGZ�L��q�G�q86N��۩H�����I��t<��L��#�e�G$�����xbػ���g�0�:CȮ]��g�tq��������ǹYI#��%��rn`l}��fW���������G���T�.s��n�R���;<L���fP���ځI�_�����p�>p.�I�0p\:J�"��s��F���y!      e   �  x����j\1��y��KC�-�?ꪋ,J
M��?�@��6]��+_�}����,��'��o�n��/���/�۟���Ӈ���ӏ��������ߗ_�����?/W�����n9n�����^�����n���%��Д��py��b��"�����ؤ�h�x)1�VU*^��T
J���&%扆�j&Ťq�-b�0c$�ݓ�E����d��Z��J��R+Y�2A�xh���U�
�:Y��d�AV�J�$��5�o�F$����U�i<��e�V���8u�^s���	�עk�iƹ�<3�h��Ţ���tu�O8U��E�h��+G<�|�+��'ot|��A��f\"{RctR���)�6��t���Z�P<Z��
/\Vvmxp�#dp��o]2�qrWS� �ޠ(�G��pqՄv|v�*����\dc?:g���E5�q�������$���B�0!��?�ݤ���
!ڄe���I�E��,����e�e]>��m�J�h]��U�����m��pq�7��pY*��Z�y���n��<sY�G�\�����Űn3�gɺ�\V�����8�Xml4*~��]	���FW���ֺD]�ڀ��;�u��uٌ<C���Z@W�n�~���K��E��$w�u�������<��n��㿫�b�ծp����/|9���� �����}���      a   	  x���Ok�0�{?EnU�;�7m����Ca��۵�4�������/�����^�Sx�ˏ7ϛ�v��$�����C��C)����R#s���"���	H^�*�E{ȇ6���[�#�w5x�s&5%����LX@�u�Y�����mZ��=�=�)r�,�O^��<���t������6�M�+���p4@���3��L;d/�:F��k�8���@�s��������nlel�F�xߟG�������F��ZK.z���}�*�      ]     x�͖�n�@��y�U/i%���"N�(�ZD��$X�M,;��Ѐ�T�J��
ȩQ m]�f_��];�˟��D^��7�73^^Y[��ΖW�W��z���E�u��gӢR�,Vw6�ł��/�Tv-6�5�����ʎ_	J��·�Æ�A�)7�c>��/޺��Ʀm���a�߯�W�G�i���C_v�����7<����*�W���E�ԧ��g���5F��C�[(�����c�� n�JUpWch|T�o��%՟I/}$�+�7]��A��M�������'�9�K��BB���(�1���	���ss�{��A'�A�H^#���l�I�LjwU;w��I+g��E%]��k��m��<��R_e&վ�"������`���u߁c=b1M!r|K�QBpx�sO��6�+z���r�q��>@�)ή2��o�D��3�dt�9 �@��c���'�����F0h���s利�}�(�ёI��8u��H�Q;g%��(��h�֟�j�6��JQ&��$�F��=��9R���_/�x��H"a�D��4�赴��kԾ����P�;ͧq>}-��0�Y�9A�ht�@s����h��^���o ����� �MW�      ^   �   x���v
Q���W((M��L�+�I�L-�O�)MR��L�/�Q�K�M
h*�9���+h�(���T�d&&��kZsy�g��2��A&�2ȔZ�rLͦ�s�M���K�M04��P�H�K,���K�̦(^��i�153��a���� �U'     