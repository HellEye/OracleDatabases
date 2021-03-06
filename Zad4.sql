--<editor-fold desc="Zad 47">
--<editor-fold desc="Obiekty">

DROP TABLE okonta;
DROP TABLE oelita;
DROP TABLE oplebs;
DROP TABLE okocury;


DROP TYPE KONTO;
DROP TYPE ELITA;
DROP TYPE PLEBS;
DROP TYPE KOCUR;
--<editor-fold desc="Kocury">


CREATE OR REPLACE TYPE KOCUR AS OBJECT (
    imie            VARCHAR2(15),
    plec            VARCHAR2(1),
    pseudo          VARCHAR2(15),
    func            VARCHAR2(10),
    szef            REF KOCUR,
    w_stadku_od     DATE,
    przydzial_myszy NUMBER(3),
    myszy_extra     NUMBER(3),
    banda_nr        NUMBER(2),

MAP MEMBER FUNCTION ByPseudo
    RETURN VARCHAR2,
MEMBER FUNCTION ZjadaRazem
    RETURN NUMBER,
MEMBER FUNCTION GetDisplayName
    RETURN VARCHAR2,
MEMBER FUNCTION MaSzefa
    RETURN NUMBER,
MEMBER FUNCTION GetMinMyszy
    RETURN NUMBER,
MEMBER FUNCTION GetMaxMyszy
    RETURN NUMBER,
MEMBER FUNCTION GetNazwaBandy
    RETURN VARCHAR2,
MEMBER FUNCTION GetTeren
    RETURN VARCHAR2,
MEMBER FUNCTION GetSpozycie
    RETURN VARCHAR2,
MEMBER FUNCTION MaPremie
    RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY KOCUR IS
    MAP MEMBER FUNCTION ByPseudo
        RETURN VARCHAR2 IS BEGIN
        RETURN pseudo;
    END;
    
    MEMBER FUNCTION ZjadaRazem
        RETURN NUMBER IS BEGIN
        RETURN przydzial_myszy + NVL(myszy_extra, 0);
    END;
    
    MEMBER FUNCTION GetDisplayName
        RETURN VARCHAR2 IS BEGIN
        RETURN imie || ' (' || pseudo || ')';
    END;
    
    MEMBER FUNCTION MaSzefa
        RETURN NUMBER IS BEGIN
        IF szef IS NOT NULL THEN RETURN 1; END IF;
        RETURN 0;
    END;
    
    MEMBER FUNCTION GetMinMyszy
        RETURN NUMBER IS
        tmp NUMBER;
        BEGIN
            SELECT min_myszy INTO tmp FROM funkcje WHERE funkcje.funkcja = func;
            RETURN tmp;
        END;
    
    MEMBER FUNCTION GetMaxMyszy
        RETURN NUMBER IS
        tmp NUMBER;
        BEGIN
            SELECT max_myszy INTO tmp FROM funkcje WHERE funkcja = func;
            RETURN tmp;
        END;
    
    
    MEMBER FUNCTION GetNazwaBandy
        RETURN VARCHAR2 IS
        tmp bandy.nazwa%TYPE;
        BEGIN
            SELECT bandy.nazwa INTO tmp FROM bandy WHERE nr_bandy = banda_nr;
            RETURN tmp;
        END;
    
    MEMBER FUNCTION GetTeren
        RETURN VARCHAR2 IS
        t bandy.teren%TYPE;
        BEGIN
            SELECT teren INTO t FROM bandy WHERE nr_bandy = banda_nr;
            RETURN t;
        END;
    
    MEMBER FUNCTION GetSpozycie
        RETURN VARCHAR2 IS BEGIN
        IF ZjadaRazem() * 12 < 864 THEN RETURN 'ponizej 864';
        ELSIF ZjadaRazem() * 12 > 864 THEN RETURN 'powyzej 864';
        ELSE RETURN '864';
        END IF;
    END;
    MEMBER FUNCTION MaPremie
        RETURN NUMBER IS BEGIN
        IF myszy_extra IS NOT NULL THEN
            RETURN 1;
        END IF;
        RETURN 0;
    END;
END;

CREATE TABLE okocury OF KOCUR (
CONSTRAINT ook_pk PRIMARY KEY (pseudo
),
CONSTRAINT ook_im CHECK (imie IS NOT NULL
),
CONSTRAINT ook_pl CHECK (plec IN ('M', 'D'
)
),
CONSTRAINT ook_sc_f CHECK (func IS NOT NULL
),
CONSTRAINT ook_sc_b CHECK (banda_nr IS NOT NULL
),
CONSTRAINT ook_sz_ref szef SCOPE IS OKocury
);

--<editor-fold desc="Dane Kocurow">
INSERT INTO okocury
VALUES (Kocur('MRUCZEK', 'M', 'TYGRYS', 'SZEFUNIO', NULL, '2002-01-01', 103, 33, 1));
INSERT ALL INTO okocury
VALUES (Kocur('RUDA', 'D', 'MALA', 'MILUSIA', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2006-09-17', 22, 42, 1))
    INTO okocury
VALUES (Kocur('PUCEK', 'M', 'RAFA', 'LOWCZY', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2006-10-15', 65, NULL, 4))
    INTO okocury
VALUES (Kocur('MICKA', 'D', 'LOLA', 'MILUSIA', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2009-10-14', 25, 47, 1))
    INTO okocury
VALUES (Kocur('CHYTRY', 'M', 'BOLEK', 'DZIELCZY', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2002-05-05', 50, NULL, 1))
    INTO okocury
VALUES (Kocur('KOREK', 'M', 'ZOMBI', 'BANDZIOR', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2004-03-16', 75, 13, 3))
    INTO okocury
VALUES (Kocur('BOLEK', 'M', 'LYSY', 'BANDZIOR', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2006-08-15', 72, 21, 2))
SELECT *
FROM dual;
INSERT ALL INTO okocury
VALUES (Kocur('JACEK', 'M', 'PLACEK', 'LOWCZY', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'LYSY'),
              '2008-12-01', 67, NULL, 2))
    INTO okocury
VALUES (Kocur('BARI', 'M', 'RURA', 'LAPACZ', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'LYSY'),
              '2009-09-01', 56, NULL, 2))
    INTO okocury
VALUES (Kocur('SONIA', 'D', 'PUSZYSTA', 'MILUSIA', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'ZOMBI'),
              '2010-11-18', 20, 35, 3))
    INTO okocury
VALUES (Kocur('LATKA', 'D', 'UCHO', 'KOT', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'RAFA'),
              '2011-01-01', 40, NULL, 4))
    INTO okocury
VALUES (Kocur('DUDEK', 'M', 'MALY', 'KOT', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'RAFA'),
              '2011-05-15', 40, NULL, 4))
    INTO okocury
VALUES (Kocur('ZUZIA', 'D', 'SZYBKA', 'LOWCZY', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'LYSY'),
              '2006-07-21', 65, NULL, 2))
    INTO okocury
VALUES (Kocur('PUNIA', 'D', 'KURKA', 'LOWCZY', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'ZOMBI'),
              '2008-01-01', 61, NULL, 3))
    INTO okocury
VALUES (Kocur('BELA', 'D', 'LASKA', 'MILUSIA', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'LYSY'),
              '2008-02-01', 24, 28, 2))
    INTO okocury
VALUES (Kocur('KSAWERY', 'M', 'MAN', 'LAPACZ', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'RAFA'),
              '2008-07-12', 51, NULL, 4))
    INTO okocury
VALUES (Kocur('MELA', 'D', 'DAMA', 'LAPACZ', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'RAFA'),
              '2008-11-01', 51, NULL, 4))
SELECT *
FROM dual;
INSERT INTO okocury
VALUES (Kocur('LUCEK', 'M', 'ZERO', 'KOT', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'KURKA'),
              '2010-03-01', 43, NULL, 3));

/*INSERT INTO okocury
VALUES (Kocur('RUDA', 'D', 'MALA', 'MILUSIA', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2006-09-17', 22, 42, 1));
INSERT INTO okocury
VALUES (Kocur('PUCEK', 'M', 'RAFA', 'LOWCZY', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2006-10-15', 65, NULL, 4));
INSERT INTO okocury
VALUES (Kocur('MICKA', 'D', 'LOLA', 'MILUSIA', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2009-10-14', 25, 47, 1));
INSERT INTO okocury
VALUES (Kocur('CHYTRY', 'M', 'BOLEK', 'DZIELCZY', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2002-05-05', 50, NULL, 1));
INSERT INTO okocury
VALUES (Kocur('KOREK', 'M', 'ZOMBI', 'BANDZIOR', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2004-03-16', 75, 13, 3));
INSERT INTO okocury
VALUES (Kocur('BOLEK', 'M', 'LYSY', 'BANDZIOR', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'TYGRYS'),
              '2006-08-15', 72, 21, 2));
INSERT INTO okocury
VALUES (Kocur('JACEK', 'M', 'PLACEK', 'LOWCZY', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'LYSY'),
              '2008-12-01', 67, NULL, 2));
INSERT INTO okocury
VALUES (Kocur('BARI', 'M', 'RURA', 'LAPACZ', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'LYSY'),
              '2009-09-01', 56, NULL, 2));
INSERT INTO okocury
VALUES (Kocur('SONIA', 'D', 'PUSZYSTA', 'MILUSIA', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'ZOMBI'),
              '2010-11-18', 20, 35, 3));
INSERT INTO okocury
VALUES (Kocur('LATKA', 'D', 'UCHO', 'KOT', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'RAFA'),
              '2011-01-01', 40, NULL, 4));
INSERT INTO okocury
VALUES (Kocur('DUDEK', 'M', 'MALY', 'KOT', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'RAFA'),
              '2011-05-15', 40, NULL, 4));
INSERT INTO okocury
VALUES (Kocur('ZUZIA', 'D', 'SZYBKA', 'LOWCZY', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'LYSY'),
              '2006-07-21', 65, NULL, 2));
INSERT INTO okocury
VALUES (Kocur('PUNIA', 'D', 'KURKA', 'LOWCZY', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'ZOMBI'),
              '2008-01-01', 61, NULL, 3));
INSERT INTO okocury
VALUES (Kocur('BELA', 'D', 'LASKA', 'MILUSIA', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'LYSY'),
              '2008-02-01', 24, 28, 2));
INSERT INTO okocury
VALUES (Kocur('KSAWERY', 'M', 'MAN', 'LAPACZ', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'RAFA'),
              '2008-07-12', 51, NULL, 4));
INSERT INTO okocury
VALUES (Kocur('MELA', 'D', 'DAMA', 'LAPACZ', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'RAFA'),
              '2008-11-01', 51, NULL, 4));
INSERT INTO okocury
VALUES (Kocur('LUCEK', 'M', 'ZERO', 'KOT', (SELECT REF(kocur) FROM okocury kocur WHERE kocur.pseudo = 'KURKA'),
              '2010-03-01', 43, NULL, 3));*/
--</editor-fold>
/*SELECT kocur.szef.pseudo
FROM okocury kocur
ORDER BY kocur.szef.pseudo;*/
--</editor-fold>

--<editor-fold desc="PLEBS">
CREATE OR REPLACE TYPE PLEBS AS OBJECT (
    nr_plebsu NUMBER,
    kot       REF KOCUR,
MAP MEMBER FUNCTION ByPseudo
    RETURN VARCHAR2,
MEMBER FUNCTION GetKocur
    RETURN KOCUR
);
CREATE OR REPLACE TYPE BODY PLEBS IS
    MAP MEMBER FUNCTION ByPseudo
        RETURN VARCHAR2 IS
        k KOCUR;
        BEGIN
            SELECT deref(kot) INTO k FROM dual;
            RETURN k.pseudo;
        END;
    
    MEMBER FUNCTION GetKocur
        RETURN KOCUR IS
        k KOCUR;
        BEGIN
            SELECT deref(kot) INTO k FROM dual;
            RETURN k;
        END;
END;

CREATE TABLE oplebs OF PLEBS (
CONSTRAINT oopl_pk PRIMARY KEY (nr_plebsu
),
CONSTRAINT oopl_sc_k kot SCOPE IS OKocury
);

--<editor-fold desc="Dane Plebsu">
INSERT ALL INTO oplebs
VALUES (Plebs(1, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'SZYBKA')))
    INTO oplebs
VALUES (Plebs(2, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'BOLEK')))
    INTO oplebs
VALUES (Plebs(3, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'LASKA')))
    INTO oplebs
VALUES (Plebs(4, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'MAN')))
    INTO oplebs
VALUES (Plebs(5, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'DAMA')))
    INTO oplebs
VALUES (Plebs(6, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'PLACEK')))
    INTO oplebs
VALUES (Plebs(7, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'RURA')))
    INTO oplebs
VALUES (Plebs(8, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'ZERO')))
    INTO oplebs
VALUES (Plebs(9, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'PUSZYSTA')))
    INTO oplebs
VALUES (Plebs(10, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'UCHO')))
    INTO oplebs
VALUES (Plebs(11, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'MALY')))
    INTO oplebs
VALUES (Plebs(12, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'MALA')))
SELECT *
FROM dual;
--</editor-fold>

--</editor-fold>

--<editor-fold desc="Elita">
CREATE OR REPLACE TYPE ELITA AS OBJECT (
    nr_elity NUMBER,
    kot      REF KOCUR,
    sluga    REF PLEBS,
MAP MEMBER FUNCTION ByPseudo
    RETURN VARCHAR2,
MEMBER FUNCTION GetKot
    RETURN KOCUR,
MEMBER FUNCTION GetSluga
    RETURN KOCUR
);
CREATE OR REPLACE TYPE BODY ELITA IS
    MAP MEMBER FUNCTION ByPseudo
        RETURN VARCHAR2 IS
        k KOCUR;
        BEGIN
            SELECT deref(kot) INTO k FROM dual;
            RETURN k.pseudo;
        END;
    MEMBER FUNCTION GetSluga
        RETURN KOCUR IS
        k KOCUR;
        BEGIN
            SELECT deref(deref(sluga).kot) INTO k FROM dual;
            RETURN k;
        END;
    MEMBER FUNCTION GetKot
        RETURN KOCUR IS
        k KOCUR;
        BEGIN
            SELECT deref(kot) INTO k FROM dual;
            RETURN k;
        END;
END;

CREATE TABLE oelita OF ELITA (
CONSTRAINT ooe_pk PRIMARY KEY (nr_elity
),
CONSTRAINT ooe_sc_k kot SCOPE IS OKocury,
CONSTRAINT ooe_sc_s sluga SCOPE IS OPlebs
);

--<editor-fold desc="Dane elity">
INSERT ALL INTO oelita
VALUES (Elita(1, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'TYGRYS'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 5)))
    INTO oelita
VALUES (Elita(2, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'LOLA'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 9)))
    INTO oelita
VALUES (Elita(3, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'ZOMBI'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 4)))
    INTO oelita
VALUES (Elita(4, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'LYSY'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 1)))
    INTO oelita
VALUES (Elita(5, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'KURKA'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 10)))
    INTO oelita
VALUES (Elita(6, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'RAFA'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 7)))
SELECT *
FROM dual;
/*INSERT INTO oelita
VALUES (Elita(1, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'TYGRYS'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 5)));
INSERT INTO oelita
VALUES (Elita(2, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'LOLA'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 9)));
INSERT INTO oelita
VALUES (Elita(3, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'ZOMBI'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 4)));
INSERT INTO oelita
VALUES (Elita(4, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'LYSY'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 1)));
INSERT INTO oelita
VALUES (Elita(5, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'KURKA'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 10)));
INSERT INTO oelita
VALUES (Elita(6, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'RAFA'),
              (SELECT REF(sluga) FROM oplebs sluga WHERE sluga.nr_plebsu = 7)));*/
--</editor-fold>

--</editor-fold>

--<editor-fold desc="Konta">
CREATE OR REPLACE TYPE KONTO AS OBJECT (
    id_konta          NUMBER,
    wlasciciel        REF ELITA,
    data_wprowadzenia DATE,
    data_usuniecia    DATE,
MAP MEMBER FUNCTION ById
    RETURN NUMBER,
MEMBER FUNCTION GetWlasciciel
    RETURN KOCUR,
MEMBER FUNCTION IsOn
    RETURN NUMBER
);
CREATE OR REPLACE TYPE BODY KONTO IS
    MAP MEMBER FUNCTION ById
        RETURN NUMBER IS BEGIN
        RETURN id_konta;
    END;
    MEMBER FUNCTION GetWlasciciel
        RETURN KOCUR IS
        k KOCUR;
        BEGIN
            SELECT deref(deref(wlasciciel).kot) INTO k FROM dual;
            RETURN k;
        END;
    MEMBER FUNCTION isOn
        RETURN NUMBER IS BEGIN
        IF data_usuniecia IS NOT NULL THEN
            RETURN 1;
        END IF;
        RETURN 0;
    END;
END;
CREATE TABLE okonta OF KONTO (
CONSTRAINT ookon_pk PRIMARY KEY (id_konta
),
CONSTRAINT ookon_sc_w wlasciciel SCOPE IS Oelita,
CONSTRAINT ookon_dw CHECK (data_wprowadzenia IS NOT NULL
),
CONSTRAINT ookon_du CHECK (data_wprowadzenia <= data_usuniecia
)
);

--<editor-fold desc="Dane kont">
INSERT ALL INTO okonta
VALUES (1, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 1), '2019-01-01', '2019-01-08')
    INTO okonta
VALUES (2, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 2), '2019-01-02', '2019-01-05')
    INTO okonta
VALUES (3, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 1), '2019-01-03', '2019-01-03')
    INTO okonta
VALUES (4, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 3), '2019-01-04', '2019-01-08')
    INTO okonta
VALUES (5, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 4), '2019-01-05', NULL)
    INTO okonta
VALUES (6, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 5), '2019-01-06', NULL)
    INTO okonta
VALUES (7, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 1), '2019-01-07', '2019-01-11')
    INTO okonta
VALUES (8, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 2), '2019-01-08', NULL)
    INTO okonta
VALUES (9, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 2), '2019-01-09', NULL)
    INTO okonta
VALUES (10, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 1), '2019-01-10', '2019-01-13')
    INTO okonta
VALUES (11, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 7), '2019-01-11', NULL)
    INTO okonta
VALUES (12, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 1), '2019-01-12', NULL)
    INTO okonta
VALUES (13, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 3), '2019-01-13', NULL)
    INTO okonta
VALUES (14, (SELECT REF(kot) FROM oelita kot WHERE kot.nr_elity = 5), '2019-01-14', '2019-01-15')
SELECT *
FROM dual;
--</editor-fold>

--</editor-fold>

--<editor-fold desc="Incydenty">
CREATE OR REPLACE TYPE INCYDENT AS OBJECT (
    id_incydentu   NUMBER,
    poszkodowany   REF KOCUR,
    wrog           VARCHAR2(15),
    data_incydentu DATE,
    opis_incydentu VARCHAR2(50),

MAP MEMBER FUNCTION ById
    RETURN NUMBER,
MEMBER FUNCTION getWroga
    RETURN VARCHAR2,
MEMBER FUNCTION getKot
    RETURN KOCUR,
MEMBER FUNCTION zdarzylSiePo(data DATE)
    RETURN NUMBER,
MEMBER FUNCTION getStopienWroga
    RETURN NUMBER
);
CREATE OR REPLACE TYPE BODY INCYDENT IS
    MAP MEMBER FUNCTION ById
        RETURN NUMBER IS BEGIN
        RETURN id_incydentu;
    END;
    MEMBER FUNCTION getWroga
        RETURN VARCHAR2 IS
        gat VARCHAR2(15);
        BEGIN
            SELECT gatunek INTO gat FROM wrogowie WHERE imie_wroga = wrog;
            RETURN wrog || ' (' || gat || ')';
        END;
    MEMBER FUNCTION GetKot
        RETURN KOCUR IS
        k KOCUR;
        BEGIN
            SELECT DEREF(poszkodowany) INTO k FROM dual;
            RETURN k;
        END;
    MEMBER FUNCTION zdarzylSiePo(data DATE)
        RETURN NUMBER IS
        BEGIN
            IF data < data_incydentu THEN RETURN 1;
            END IF;
            RETURN 0;
        END;
    MEMBER FUNCTION getStopienWroga
        RETURN NUMBER IS
        st NUMBER;
        BEGIN
            SELECT stopien_wrogosci INTO st FROM wrogowie WHERE imie_wroga = wrog;
            RETURN st;
        END;
END;

CREATE TABLE oincydenty OF INCYDENT (
CONSTRAINT ooi_pk PRIMARY KEY (id_incydentu
),
CONSTRAINT ooi_n_wr CHECK (wrog IS NOT NULL
),
CONSTRAINT ooi_sc_p poszkodowany SCOPE IS okocury
);

--<editor-fold desc="Dane incydentów">
INSERT ALL INTO oincydenty
VALUES (1, (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'TYGRYS'), 'KAZIO', '2004-10-13 ', 'USILOWAL NABIC NA WIDLY')
    INTO oincydenty
VALUES (2,
        (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'ZOMBI'),
        'SWAWOLNY DYZIO',
        '2005-03-07 ',
        'WYBIL OKO Z PROCY')
    INTO oincydenty
VALUES (3, (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'BOLEK'), 'KAZIO', '2005-03-29 ', 'POSZCZUL BURKIEM')
    INTO oincydenty
VALUES (4,
        (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'SZYBKA'),
        'GLUPIA ZOSKA',
        '2006-09-12 ',
        'UZYLA KOTA JAKO SCIERKI')
    INTO oincydenty
VALUES (5, (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'MALA'), 'CHYTRUSEK', '2007-03-07 ', 'ZALECAL SIE')
    INTO oincydenty
VALUES (6,
        (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'TYGRYS'),
        'DZIKI BILL',
        '2007-06-12 ',
        'USILOWAL POZBAWIC ZYCIA')
    INTO oincydenty
VALUES (7, (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'BOLEK'), 'DZIKI BILL', '2007-11-10 ', 'ODGRYZL UCHO')
    INTO oincydenty
VALUES (8,
        (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'LASKA'),
        'DZIKI BILL',
        '2008-12-12 ',
        'POGRYZL ZE LEDWO SIE WYLIZALA')
    INTO oincydenty
VALUES (9,
        (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'LASKA'),
        'KAZIO',
        '2009-01-07 ',
        'ZLAPAL ZA OGON I ZROBIL WIATRAK')
    INTO oincydenty
VALUES (10, (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'DAMA'), 'KAZIO', '2009-02-07 ', 'CHCIAL OBEDRZEC ZE SKORY')
    INTO oincydenty
VALUES (11,
        (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'MAN'),
        'REKSIO',
        '2009-04-14 ',
        'WYJATKOWO NIEGRZECZNIE OBSZCZEKAL')
    INTO oincydenty
VALUES (12,
        (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'LYSY'),
        'BETHOVEN',
        '2009-05-11 ',
        'NIE PODZIELIL SIE SWOJA KASZA')
    INTO oincydenty
VALUES (13, (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'RURA'), 'DZIKI BILL', '2009-09-03 ', 'ODGRYZL OGON')
    INTO oincydenty
VALUES (14,
        (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'PLACEK'),
        'BAZYLI',
        '2010-07-12 ',
        'DZIOBIAC UNIEMOZLIWIL PODEBRANIE KURCZAKA')
    INTO oincydenty
VALUES (15, (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'PUSZYSTA'), 'SMUKLA', '2010-11-19 ', 'OBRZUCILA SZYSZKAMI')
    INTO oincydenty
VALUES (16, (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'KURKA'), 'BUREK', '2010-12-14 ', 'POGONIL')
    INTO oincydenty
VALUES (17,
        (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'MALY'),
        'CHYTRUSEK',
        '2011-07-13 ',
        'PODEBRAL PODEBRANE JAJKA')
    INTO oincydenty
VALUES (18,
        (SELECT REF(k) FROM okocury k WHERE k.pseudo = 'UCHO'),
        'SWAWOLNY DYZIO',
        '2011-07-14 ',
        'OBRZUCIL KAMIENIAMI')
SELECT *
FROM dual;
--</editor-fold>
--</editor-fold>
--</editor-fold>
--<editor-fold desc="przykłady zapytan">
--Obecna ilość myszy na koncie
SELECT k.getWlasciciel().getDisplayName() "kot", COUNT(*) "ilosc myszy"
FROM okonta k
WHERE k.isOn() = 1
GROUP BY k.getWlasciciel();
--plebsy które nie są sługami
SELECT p.getkocur().getDisplayName() "szczesliwy plebs"
FROM oplebs p
WHERE p.getKocur() NOT IN (SELECT e.getSluga() FROM oelita e);
--</editor-fold>
--<editor-fold desc="Zad 17">
SELECT k.getDisplayName() "kot", k.zjadarazem() "spozycie", k.getnazwabandy() "banda"
FROM okocury k
WHERE k.GetTeren() IN ('POLE', 'CALOSC');
--</editor-fold>

--<editor-fold desc="Zad 23">
SELECT k.getDisplayName() "kot", k.getSpozycie() "zjada rocznie"
FROM okocury k
WHERE k.maPremie() = 1
ORDER BY k.zjadaRazem() DESC;

--</editor-fold>

--21, 22, 35, 37
--</editor-fold>

--<editor-fold desc="Zad 48">

--<editor-fold desc="Tablice">
DROP TABLE kontatab;
DROP TABLE elitatab;
DROP TABLE plebstab;

CREATE TABLE plebstab (
    id_plebsu NUMBER,
    pseudo    VARCHAR2(15)
        CONSTRAINT ple_fk_ps REFERENCES kocury (pseudo),
    CONSTRAINT ple_pk PRIMARY KEY (id_plebsu)
);
INSERT ALL INTO plebstab
VALUES (1, 'SZYBKA')
    INTO plebstab
VALUES (2, 'BOLEK')
    INTO plebstab
VALUES (3, 'LASKA')
    INTO plebstab
VALUES (4, 'MAN')
    INTO plebstab
VALUES (5, 'DAMA')
    INTO plebstab
VALUES (6, 'PLACEK')
    INTO plebstab
VALUES (7, 'RURA')
    INTO plebstab
VALUES (8, 'ZERO')
    INTO plebstab
VALUES (9, 'PUSZYSTA')
    INTO plebstab
VALUES (10, 'UCHO')
    INTO plebstab
VALUES (11, 'MALY')
    INTO plebstab
VALUES (12, 'MALA')
SELECT *
FROM dual;

CREATE TABLE elitatab (
    id_elity NUMBER,
    pseudo   VARCHAR2(15)
        CONSTRAINT e_ps_fk REFERENCES kocury (pseudo),
    sluga    NUMBER
        CONSTRAINT e_sl_fk REFERENCES plebstab (id_plebsu),
    CONSTRAINT e_pk PRIMARY KEY (id_elity)
);
INSERT ALL INTO elitatab
VALUES (1, 'TYGRYS', 5)
    INTO elitatab
VALUES (2, 'LOLA', 9)
    INTO elitatab
VALUES (3, 'ZOMBI', 4)
    INTO elitatab
VALUES (4, 'LYSY', 1)
    INTO elitatab
VALUES (5, 'KURKA', 10)
    INTO elitatab
VALUES (6, 'RAFA', 7)
SELECT *
FROM dual;

CREATE TABLE kontatab (
    id_konta          NUMBER,
    wlasciciel        NUMBER
        CONSTRAINT kon_fk_wl REFERENCES elitatab (id_elity),
    data_wprowadzenia DATE
        CONSTRAINT kon_n_dw CHECK (data_wprowadzenia IS NOT NULL),
    data_usuniecia    DATE,
    CONSTRAINT kon_ch_du CHECK (data_wprowadzenia <= data_usuniecia),
    CONSTRAINT kon_pk PRIMARY KEY (id_konta)
);
INSERT ALL INTO kontatab
VALUES (1, 1, '2019-01-01', '2019-01-08')
    INTO kontatab
VALUES (2, 2, '2019-01-02', '2019-01-05')
    INTO kontatab
VALUES (3, 1, '2019-01-03', '2019-01-03')
    INTO kontatab
VALUES (4, 3, '2019-01-04', '2019-01-08')
    INTO kontatab
VALUES (5, 4, '2019-01-05', NULL)
    INTO kontatab
VALUES (6, 5, '2019-01-06', NULL)
    INTO kontatab
VALUES (7, 1, '2019-01-07', '2019-01-11')
    INTO kontatab
VALUES (8, 2, '2019-01-08', NULL)
    INTO kontatab
VALUES (9, 2, '2019-01-09', NULL)
    INTO kontatab
VALUES (10, 1, '2019-01-10', '2019-01-13')
    INTO kontatab
VALUES (11, 6, '2019-01-11', NULL)
    INTO kontatab
VALUES (12, 1, '2019-01-12', NULL)
    INTO kontatab
VALUES (13, 3, '2019-01-13', NULL)
    INTO kontatab
VALUES (14, 5, '2019-01-14', '2019-01-15')
SELECT *
FROM dual;

--</editor-fold>


--<editor-fold desc="Perspektywy">

CREATE OR REPLACE FORCE VIEW nakocury
        OF KOCUR
    WITH OBJECT IDENTIFIER (pseudo) AS
    SELECT imie,
           plec,
           pseudo,
           funkcja,
           MAKE_REF(nakocury, szef) szef,
           w_stadku_od,
           przydzial_myszy,
           myszy_ekstra,
           nr_bandy
    FROM kocury;

CREATE OR REPLACE VIEW naplebs
        OF PLEBS
    WITH OBJECT IDENTIFIER (nr_plebsu) AS
    SELECT id_plebsu, MAKE_REF(nakocury, pseudo) kocur
    FROM plebstab;

CREATE OR REPLACE VIEW naelity
        OF ELITA
    WITH OBJECT IDENTIFIER (nr_elity) AS
    SELECT id_elity, MAKE_REF(nakocury, pseudo) kocur, MAKE_REF(naplebs, sluga) sluga
    FROM elitatab;

CREATE OR REPLACE VIEW nakonta
        OF KONTO
    WITH OBJECT IDENTIFIER (id_konta) AS
    SELECT kontatab.id_konta, MAKE_REF(naelity, wlasciciel) wlasciciel, data_wprowadzenia, data_usuniecia
    FROM kontatab;
--</editor-fold>

--<editor-fold desc="Zadania">

--Obecna ilość myszy na koncie
SELECT k.wlasciciel "kot", COUNT(*) "ilosc myszy"
FROM kontatab k
WHERE k.data_usuniecia IS NOT NULL
GROUP BY k.wlasciciel;

--plebsy które nie są sługami
SELECT p.pseudo "szczesliwy plebs"
FROM plebstab p
WHERE p.id_plebsu NOT IN (SELECT sluga FROM elitatab);

--Zad 17
SELECT k.pseudo "kot", k.zjadarazem() "spozycie", k.getnazwabandy() "banda"
FROM nakocury k
WHERE k.GetTeren() IN ('POLE', 'CALOSC');

--Zad 23
SELECT k.pseudo "kot", k.getSpozycie() "zjada rocznie"
FROM nakocury k
WHERE k.maPremie() = 1
ORDER BY k.zjadaRazem() DESC;

--</editor-fold>

--</editor-fold>

--<editor-fold desc="Zad 49">
DROP TABLE myszy;

DECLARE
    waga_min NUMBER DEFAULT 15;
    waga_max NUMBER DEFAULT 35;
    PRAGMA AUTONOMOUS_TRANSACTION;
    query    VARCHAR2(2048);
BEGIN
    query := '
    CREATE TABLE myszy (
        nr_myszy       NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY CONSTRAINT my_pk PRIMARY KEY,
        lowca          VARCHAR(15) CONSTRAINT my_lw_fk REFERENCES kocury (pseudo),
        zjadacz        VARCHAR(15) CONSTRAINT my_zj_fk REFERENCES kocury (pseudo),
        waga_myszy     NUMBER NOT NULL CONSTRAINT my_wm_ck CHECK (waga_myszy BETWEEN ' || waga_min || ' AND ' ||
             waga_max || '),
        data_zlowienia DATE   NOT NULL,
        data_wydania   DATE
    )';
    EXECUTE IMMEDIATE query;
    COMMIT;
END;

DECLARE
    kiedy       DATE DEFAULT '2004-01-01';
    sroda       DATE;
    dzien       NUMBER;
    miesiac     NUMBER;
    waga_min NUMBER DEFAULT 15;
    waga_max NUMBER DEFAULT 35;
    TYPE TABELAPSEUDO IS TABLE OF kocury.pseudo%TYPE INDEX BY BINARY_INTEGER;
    pseuda      TABELAPSEUDO;
    querystring VARCHAR2(2048);
    ile         NUMBER;
    liczba_myszy NUMBER;
BEGIN
    sroda := kiedy;
    WHILE kiedy <= '2019-01-16' LOOP
        SELECT EXTRACT(MONTH FROM kiedy) INTO miesiac FROM dual;
        SELECT EXTRACT(DAY FROM kiedy) INTO dzien FROM dual;
        sroda := (next_day(last_day(add_months(sroda, 1)) - 7, 'Środa'));
        querystring := 'SELECT pseudo FROM Kocury WHERE w_stadku_od < ' || q'[']' || kiedy || q'[']';
        EXECUTE IMMEDIATE querystring BULK COLLECT INTO pseuda;
        liczba_myszy := pseuda.count;
        SELECT SUM(przydzial_myszy + NVL(myszy_ekstra, 0)) INTO ile FROM kocury WHERE w_stadku_od < sroda;
        FOR i IN 0..ile-1 LOOP
            INSERT INTO myszy (lowca, waga_myszy, data_zlowienia)
            VALUES (pseuda(dbms_random.VALUE(1, liczba_myszy)),
                    round(dbms_random.VALUE(waga_min, waga_max), 2),
                    kiedy + dbms_random.VALUE(0, 27)
                    );
        END LOOP;
        
        FOR kot IN (
        SELECT pseudo, przydzial_myszy + NVL(myszy_ekstra, 0) zjada FROM kocury ORDER BY zjada DESC
        ) LOOP
            UPDATE myszy
            SET zjadacz = kot.pseudo
            WHERE zjadacz IS NULL
              AND rownum <= kot.zjada;
        END LOOP;
        COMMIT;
        kiedy := last_day(kiedy) + 1;
    END LOOP;
END;

select count(*) from myszy;

declare begin
    dbms_output.PUT_LINE(round(dbms_random.value(0, 10), 2));
END;

drop table myszy;
--</editor-fold>
