--Zad 47
--<editor-fold desc="Zad 47">
--<editor-fold desc="Kocury">


DROP TYPE KOCUR;

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
MEMBER FUNCTION HasSzef
    RETURN BOOLEAN,
MEMBER FUNCTION JoinedBefore(inny KOCUR)
    RETURN BOOLEAN,
MEMBER FUNCTION IleMiesiecyWStadku
    RETURN NUMBER,
MEMBER FUNCTION GetMinMyszy
    RETURN NUMBER,
MEMBER FUNCTION GetMaxMyszy
    RETURN NUMBER,
MEMBER FUNCTION GetNazwaBandy
    RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY KOCUR IS
    MAP MEMBER FUNCTION ByPseudo
        RETURN VARCHAR2 IS BEGIN
        RETURN pseudo;
    END;
    
    MEMBER FUNCTION ZjadaRazem
        RETURN NUMBER IS BEGIN
        RETURN NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0);
    END;
    
    MEMBER FUNCTION GetDisplayName
        RETURN VARCHAR2 IS BEGIN
        RETURN imie || ' (' || pseudo || ')';
    END;
    
    MEMBER FUNCTION HasSzef
        RETURN BOOLEAN IS BEGIN
        RETURN szef IS NOT NULL;
    END;
    
    MEMBER FUNCTION JoinedBefore(inny KOCUR)
        RETURN BOOLEAN IS BEGIN
        RETURN w_stadku_od < inny.w_stadku_od;
    END;
    
    MEMBER FUNCTION IleMiesiecyWStadku
        RETURN NUMBER IS
        tmp NUMBER;
        BEGIN
            SELECT EXTRACT(MONTH FROM w_stadku_od) INTO tmp FROM dual;
            RETURN tmp;
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
        tmp VARCHAR2(20);
        BEGIN
            SELECT bandy.nazwa INTO tmp FROM bandy WHERE nr_bandy = banda_nr;
            RETURN tmp;
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
INSERT INTO okocury
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
              '2010-03-01', 43, NULL, 3));
--</editor-fold>
SELECT kocur.szef.pseudo
FROM okocury kocur
ORDER BY kocur.szef.pseudo;
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
        k kocur;
        BEGIN
            SELECT deref(kot) into k from dual;
        RETURN k.pseudo;
    END;
    
    MEMBER FUNCTION GetKocur
        RETURN KOCUR IS
        k kocur;
        BEGIN
            SELECT deref(kot) into k from dual;
        RETURN k;
    END;
END;

CREATE TABLE oplebs OF PLEBS (
CONSTRAINT oopl_pk PRIMARY KEY (nr_plebsu
),
CONSTRAINT oopl_sc_k kot SCOPE IS OKocury
);

--<editor-fold desc="Dane Plebsu">
INSERT INTO oplebs
VALUES (Plebs(1, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'SZYBKA')));
INSERT INTO oplebs
VALUES (Plebs(2, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'BOLEK')));
INSERT INTO oplebs
VALUES (Plebs(3, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'LASKA')));
INSERT INTO oplebs
VALUES (Plebs(4, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'MAN')));
INSERT INTO oplebs
VALUES (Plebs(5, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'DAMA')));
INSERT INTO oplebs
VALUES (Plebs(6, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'PLACEK')));
INSERT INTO oplebs
VALUES (Plebs(7, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'RURA')));
INSERT INTO oplebs
VALUES (Plebs(8, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'ZERO')));
INSERT INTO oplebs
VALUES (Plebs(9, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'PUSZYSTA')));
INSERT INTO oplebs
VALUES (Plebs(10, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'UCHO')));
INSERT INTO oplebs
VALUES (Plebs(11, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'MALY')));
INSERT INTO oplebs
VALUES (Plebs(12, (SELECT REF(kot) FROM okocury kot WHERE kot.pseudo = 'MALA')));
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
        k Kocur;
        BEGIN
            SELECT deref(kot) into k from dual;
        RETURN k.pseudo;
    END;
    MEMBER FUNCTION GetSluga
        RETURN KOCUR IS
        p plebs;
        k kocur;
        BEGIN
            SELECT deref(sluga) into p from dual;
            SELECT deref(p.kot) into k from dual;
        RETURN k;
    END;
    MEMBER FUNCTION GetKot
        RETURN KOCUR IS
        k kocur;
        BEGIN
            SELECT deref(kot) into k from dual;
        RETURN k;
    END;
END;

CREATE TABLE OElita OF elita (
    CONSTRAINT ooe_pk PRIMARY KEY (nr_elity),
    CONSTRAINT ooe_sc_k kot SCOPE IS OKocury,
    CONSTRAINT ooe_sc_s sluga SCOPE IS OPlebs
);

--<editor-fold desc="Dane plebsu">
INSERT INTO OElita VALUES (Elita(1, (SELECT REF(kot) FROM OKocury kot WHERE kot.pseudo='TYGRYS'), (SELECT REF(sluga) FROM OPlebs sluga WHERE sluga.nr_plebsu=5)));
INSERT INTO OElita VALUES (Elita(2, (SELECT REF(kot) FROM OKocury kot WHERE kot.pseudo='LOLA'), (SELECT REF(sluga) FROM OPlebs sluga WHERE sluga.nr_plebsu=9)));
INSERT INTO OElita VALUES (Elita(3, (SELECT REF(kot) FROM OKocury kot WHERE kot.pseudo='ZOMBI'), (SELECT REF(sluga) FROM OPlebs sluga WHERE sluga.nr_plebsu=4)));
INSERT INTO OElita VALUES (Elita(4, (SELECT REF(kot) FROM OKocury kot WHERE kot.pseudo='LYSY'), (SELECT REF(sluga) FROM OPlebs sluga WHERE sluga.nr_plebsu=1)));
INSERT INTO OElita VALUES (Elita(5, (SELECT REF(kot) FROM OKocury kot WHERE kot.pseudo='KURKA'), (SELECT REF(sluga) FROM OPlebs sluga WHERE sluga.nr_plebsu=10)));
INSERT INTO OElita VALUES (Elita(6, (SELECT REF(kot) FROM OKocury kot WHERE kot.pseudo='RAFA'), (SELECT REF(sluga) FROM OPlebs sluga WHERE sluga.nr_plebsu=7)));
--</editor-fold>
SELECT nr_elity, e.getkot(), e.getsluga() from oelita e;
--</editor-fold>
--</editor-fold>