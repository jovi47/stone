PGDMP     )    &                z         	   stonebank    14.0    14.0 !               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    24757 	   stonebank    DATABASE     i   CREATE DATABASE stonebank WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE stonebank;
                postgres    false            �            1255    24819    adjust_balance()    FUNCTION     �  CREATE FUNCTION public.adjust_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        if (NEW.transaction_type_id = 1) then
		update account set balance = balance + NEW.amount where id = NEW.destination_account_id;
		elseif (NEW.transaction_type_id = 2) then 
		update account set balance = balance - NEW.amount where id = NEW.account_id;
		update account set balance = balance + NEW.amount where id = NEW.destination_account_id;
		elseif (NEW.transaction_type_id = 3) then
		update account set balance = balance - NEW.amount where id = NEW.account_id;
		update transaction set destination_account_id = null where id = NEW.id;
		end if;
		RETURN NEW;
    END;
$$;
 '   DROP FUNCTION public.adjust_balance();
       public          postgres    false            �            1255    24822     random_between(integer, integer)    FUNCTION     �   CREATE FUNCTION public.random_between(low integer, high integer) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $$
BEGIN
   RETURN floor(random()* (high-low + 1) + low);
END;
$$;
 @   DROP FUNCTION public.random_between(low integer, high integer);
       public          postgres    false            �            1259    24776    account    TABLE       CREATE TABLE public.account (
    id integer DEFAULT nextval(('sq_account'::text)::regclass) NOT NULL,
    entity_id integer NOT NULL,
    balance integer DEFAULT 0 NOT NULL,
    account_number character(9) NOT NULL,
    agency character(4) DEFAULT '0001'::bpchar NOT NULL
);
    DROP TABLE public.account;
       public         heap    postgres    false            �            1259    24770    entity    TABLE     e  CREATE TABLE public.entity (
    id integer DEFAULT nextval(('sq_entity'::text)::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    last_name character varying(120) NOT NULL,
    document character varying(14) NOT NULL,
    birth_date date NOT NULL,
    phone_number character varying(15) NOT NULL,
    email character varying(60) NOT NULL
);
    DROP TABLE public.entity;
       public         heap    postgres    false            �            1259    24758 
   sq_account    SEQUENCE     s   CREATE SEQUENCE public.sq_account
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.sq_account;
       public          postgres    false            �            1259    24760 	   sq_entity    SEQUENCE     r   CREATE SEQUENCE public.sq_entity
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE public.sq_entity;
       public          postgres    false            �            1259    24759    sq_transaction    SEQUENCE     w   CREATE SEQUENCE public.sq_transaction
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.sq_transaction;
       public          postgres    false            �            1259    24761    sq_transaction_type    SEQUENCE     |   CREATE SEQUENCE public.sq_transaction_type
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.sq_transaction_type;
       public          postgres    false            �            1259    24796    transaction    TABLE     �  CREATE TABLE public.transaction (
    id integer DEFAULT nextval(('sq_transaction'::text)::regclass) NOT NULL,
    transaction_type_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    account_id integer NOT NULL,
    destination_account_id integer,
    amount integer NOT NULL,
    CONSTRAINT transaction_amount_check CHECK ((amount > 0))
);
    DROP TABLE public.transaction;
       public         heap    postgres    false            �            1259    24762    transaction_type    TABLE     �   CREATE TABLE public.transaction_type (
    id integer DEFAULT nextval(('sq_transaction_type'::text)::regclass) NOT NULL,
    type character varying(20) NOT NULL
);
 $   DROP TABLE public.transaction_type;
       public         heap    postgres    false                      0    24776    account 
   TABLE DATA           Q   COPY public.account (id, entity_id, balance, account_number, agency) FROM stdin;
    public          postgres    false    215   �*                 0    24770    entity 
   TABLE DATA           `   COPY public.entity (id, name, last_name, document, birth_date, phone_number, email) FROM stdin;
    public          postgres    false    214   &+                 0    24796    transaction 
   TABLE DATA           v   COPY public.transaction (id, transaction_type_id, created_at, account_id, destination_account_id, amount) FROM stdin;
    public          postgres    false    216   �,                 0    24762    transaction_type 
   TABLE DATA           4   COPY public.transaction_type (id, type) FROM stdin;
    public          postgres    false    213   >                  0    0 
   sq_account    SEQUENCE SET     8   SELECT pg_catalog.setval('public.sq_account', 6, true);
          public          postgres    false    209                        0    0 	   sq_entity    SEQUENCE SET     7   SELECT pg_catalog.setval('public.sq_entity', 7, true);
          public          postgres    false    211            !           0    0    sq_transaction    SEQUENCE SET     >   SELECT pg_catalog.setval('public.sq_transaction', 274, true);
          public          postgres    false    210            "           0    0    sq_transaction_type    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sq_transaction_type', 3, true);
          public          postgres    false    212            |           2606    24785 "   account account_account_number_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_account_number_key UNIQUE (account_number);
 L   ALTER TABLE ONLY public.account DROP CONSTRAINT account_account_number_key;
       public            postgres    false    215            ~           2606    24783    account account_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.account DROP CONSTRAINT account_pkey;
       public            postgres    false    215            z           2606    24775    entity entity_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.entity
    ADD CONSTRAINT entity_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.entity DROP CONSTRAINT entity_pkey;
       public            postgres    false    214            �           2606    24803    transaction transaction_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.transaction DROP CONSTRAINT transaction_pkey;
       public            postgres    false    216            v           2606    24767 &   transaction_type transaction_type_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.transaction_type
    ADD CONSTRAINT transaction_type_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.transaction_type DROP CONSTRAINT transaction_type_pkey;
       public            postgres    false    213            x           2606    24769 *   transaction_type transaction_type_type_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.transaction_type
    ADD CONSTRAINT transaction_type_type_key UNIQUE (type);
 T   ALTER TABLE ONLY public.transaction_type DROP CONSTRAINT transaction_type_type_key;
       public            postgres    false    213            �           2620    24820 )   transaction tg_transaction_adjust_balance    TRIGGER     �   CREATE TRIGGER tg_transaction_adjust_balance AFTER INSERT ON public.transaction FOR EACH ROW EXECUTE FUNCTION public.adjust_balance();
 B   DROP TRIGGER tg_transaction_adjust_balance ON public.transaction;
       public          postgres    false    220    216            �           2606    24786    account account_entity_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entity(id);
 H   ALTER TABLE ONLY public.account DROP CONSTRAINT account_entity_id_fkey;
       public          postgres    false    215    3194    214            �           2606    24809 '   transaction transaction_account_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id);
 Q   ALTER TABLE ONLY public.transaction DROP CONSTRAINT transaction_account_id_fkey;
       public          postgres    false    3198    215    216            �           2606    24814 3   transaction transaction_destination_account_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_destination_account_id_fkey FOREIGN KEY (destination_account_id) REFERENCES public.account(id);
 ]   ALTER TABLE ONLY public.transaction DROP CONSTRAINT transaction_destination_account_id_fkey;
       public          postgres    false    3198    215    216            �           2606    24804 0   transaction transaction_transaction_type_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_transaction_type_id_fkey FOREIGN KEY (transaction_type_id) REFERENCES public.transaction_type(id);
 Z   ALTER TABLE ONLY public.transaction DROP CONSTRAINT transaction_transaction_type_id_fkey;
       public          postgres    false    3190    213    216               h   x�=αC1C���"$%��v��s�F��
���dr��M��BDp%���Db�>��dl�S��ڕ�$�Qy����D��k �x�uX��4����g��Ep�         �  x�M��n�0�ϓ��$�o칥���	���M����,N��}�O�/��n%$l�����p��_������L��G���h������
���`ѪJX���O^�c�?M�G
M?�e�C��v�ị��=����������#=�֦����ށD]B���ڠ�M�+�[GGznf~�VAy�����Ǝ��7R~(�J��p"�������XUH�^W�N[��	=���~�q�tŎ�k�������z0�Jܩ����:э��`�%|�d�K�i9�>��7W��?i-�'�Ò&�?��<�S8�	�D���\�\\�BTJ�4<��P�<�[�`���K�9�����{:��R�}��-�����j)�]Y�}@����R����T>�\K����g~��k�e�?��[            x�eZە,7��bp�%M���T�X��k]Z%�@�j�z�����4~t�J���u�r)���%z���v�����+��U5�+^�r���g����H���Z��$ƀ���m��[m�~E�k��Ĺ�����������4����6��
��+��l���V�o/���p�ZV[;l�~T�Ð5b�+_��Xs�ec�*��1�D�X;-��_6�x!� �/�9�o�B���e�<i�Y���"Gu�^��j].G�ђ��m'26�p�_���r=��C�e�c��d!	�n�r;?�?b̖,�B��WDx\��Gba�HY�'rY��¥'��q~����w��9�Q6���<U��'�Gbv�_Q��v�tYu��V��B"|���TD*~p�L�Of�Օ�*տ�B]��/b�T�*�L�J\~�ˏ!�Hj�K��d�3�rTC���_o�"M�*�8�d��]�cʌ}�aYy����]��V�t"���cQ��<ӄ�7ŷ��9s�u_k	��⑦��4��]����y6�2�8���^ö��i�uz�"BE���득��Ǩ�W��M�����]3�OQ�x�y$T������Ў+zfi_5����;oN�+�8}�f��Ȓk�	�(�U�Գ�z�x#��%/�+�<�]J��IʶDD��+�4�EyOF���8E$j��8��C٠h�I���=j���#B�F���*�]�@��u�H�(��!���Q*s!Vg� ���v�13��1�9ό&��3���Q'�@�\g����	���@���G���W��aWy( �t���@�lθJ�s���=AVs��^�6��>M־�_t���2s�� �wh�.*@�{����/ ɒ���>B���[1��.�)�N=p/YSh��7{ԵM��H=p�_��Ѹ7�q%�Ɖ�;
�4_��_1�a��=c� ��o��T�z�l��Q�>�	4��٣����x@�lN��o�����Gpb�U�9	)k�XS
�1=�a�i���T ���Kt^�Ϛ^�*�sp��f����F�����@ @��P$�iJ�j
p0���c�
����+E�Q��x��ԙ�8��F��,�8q2�!�S�/v�a�6��<��<9J���0\��X۰�	ǁ�8S�s��0,83��tr��`�g���;z�g�_~�D�z^�I�ц�v��8�A`�5֜ExG�������4+a�;���2��*�`���mJ�0u�<~O0a�4!"���-�,��|*Ml�s��)	�<����8���y�����"0�YNLo�1��ġ�p�!�����;V ��9��G���7���Fa�ֵ�t*8�`�ҡ��2`õ�D�%	��� a3{�b��]�K�o=��l�ٳ/j]�׊����6B�o{��O�O�z�o��>|�e=�M��ת#��EX���!�����,��'�z�I�c`OtI��i���о�m�@[�{��!�z�<%,J��j}hA�`֪���ɠ�o�]ٮ�\`�gV���p%�J'9�ak�7Ŭ��mk���K��jV�8��
�����;�c�(��x�<L9Y*l������ �Ӗ�:���ML�h�;N�jYBz�F�S�'YL2���  �hX��DB[Fb:�<4��h-�O���b�'A�!U��1`{�P�X�C�\V���v͆���VF6�{�/>�^��]�'$�}۳��3#(b�tk�܉X(v�>Z�H(ڽ7B�����F��T�D���������\Kr�y��
,r�TշP�[�!�Wu��l�yR2�3��)�?����>� ��>��*z��вl�3mƐ=�~�m7^�Cy���l[��1���5`��@��A����l�n��N?��� f�5@%ҶF^�v�˳{�E�k��MB�u=1�I8�g8Y�7C(���a�X?D�͙
��Эl@3�p���l �+.��F�;��YӖ�T�Pa�P;�؝�)� c��H#ꥪ�hT)A�=F���`+�C�0 �wGx����/�0��w@���DhR���Ex�_[5����`��a��6�[�.�@������Fo}���%I�H��8�)ݛC�V��ŀ��S�W
�-(tb����憲^��֘w�kj�tđd�A��֪��h2�>Q������F8C�F��,�i�iA],�;!|YN����kAm,+���������أe���{�Jy�S�Yo�@��-���
�����$���p���Up't|��>�@8T�A�1Z�qy��.[�9�u��LP�Dd��ny��Q�����!��DȌ��sPt�ந��[(��OK�4�A4� U6�5O)qÂ�Qש���#s��t�m:�wHk0�;�$�y����`��d�/6X��҅%HF�r������e��q�zk�Pb�Mn}�N���� �֐}�6p����COL�Gd�/�v��
��_A��t"F�+Z9+K���Mw���|�#��HQo����"�Ǿ'�B`��eR����u���)��8�>hI���H˭������{{oJ��{K��k���3G$�&���m9'�9��:�g��sD�ߖ,�g�{��G�=Z$rÞ�g<9	��E�séÏ{Z/M;�o�WM	%p��%R�Q!s���H�� '�2��������J�:�,�
��$�d�[���)Ʌ���.�, y]�J~hrn�ɲ8ݡ$v`�㐣���k��(����3�C�s�-�P��G�;H<r�yd~V�@����5Ǣ����y��������6��$ӆ녑��n8�h�HG�,��&��$��_H�*.����� "!8�H����g�`3H��8��z������{@ �_P�b=�א��f���q���̷�SUl�&�s=rT��Qv�f�]/}���!��/j��M6�:���T>��@
�T�<��������H�(?�ƥu&�z��+��LR�~ODt��$�$S�k������,E��`ݡ�j�^|�G���b�{)�"���=�>Z�k�eO�5�)� pd=��`�l ��{w40�/9��;Ƚ������&g���O������v�!U0:�r�KXNO_z����<�ڬ,��t"S��C��J�8t��y�t#���� �����_J3��z'��@T���T��]������gK��fCT�g20��'zØ�!��A	U�>fS�pj(_���*�@	MϮ�� �
T�@��K�����V!)E������n��}�^��(�\���P)0�/ ����jۏ�����X����䵸޸��9J@�g�U ����$�´�`a�_�7����ր�cF����mϻ\Z��l���9qM*W�zHM��g�H?�@�<SDl��;����l�7���	ܲ��݀U��?��,�/�02X�52��؀�b�`|�lY��e�.mA��cV��L�p���t${��lI�'h�AL��{���fV_���f!���/�}��%Џ�������WM ������꛳l��`���j�y7��d�����\�ֈ��Ѹkk�n^��<���[s"{�tl���쭿��p�&��6�������*���د��Aq�c��B���w7h͜��#_��H.H?A�#3l���N�ٸ��7W�&`�Ǘ�-����F�"�=�x�<�$�bw-dBRn����c�F��9w��(��T��\�Qv�å@�7 �����	`�p}�� m�S���$�� HN�]�:�v�๪=�o������N�&_�iOzi��K|/h}���a���l�؍� #g�.|B1X|/���ۙ"'�{ۇ�o;�e�߂Z�Q�L��h0���b���N���~ƅ�ZD�Ǧ�?�л!�j�{�<�����V��/�L�55\��c��d��Y ͍�Z�e�|<�4-��eH!$�^ȍ�|�)����d���9X�@�Y�ҡu�) ��3�(bl�Oj�?)��BeW@!6ϟzH�KFD��?tAe��Ǜ�&z�w���y/��<�  #  (��9d��)���:�ܱ��[��j��5 �䴔{s�3�G��o��unm��E�BS{���~�Ƕ�Gv��	�fJ�	�n��|�ُ1�>� A��?�;���:��Ev�	��l�]�zf�^
�C����Sq䐸�H}bR�CX5�Q��m
���5���Y�M Y�v+��}p��Ϡ�}�=?J�r�4���oja=�XЇ�hG��A�{M�_�j�o^V�k<dp4�.£�a|� W���=��Y>����{`���x�g�6��>D�	�����eZ[<         -   x�3�tq���2�	r�vs�2���p	r����� ��_     