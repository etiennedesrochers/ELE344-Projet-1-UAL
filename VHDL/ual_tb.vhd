--================ alu.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- AUTOMNE 2018, Ecole de technologie superieure
-- ***** Desrochers Etienne ************
-- ***** DESE28369801 ************
-- =============================================================
-- Description: 
--             Testbench du UAL a 32 bits.
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
USE WORK.txt_util.ALL;

ENTITY UAL_tb IS
  GENERIC (TAILLE : integer := 32);
END UAL_tb;

ARCHITECTURE UAL_tb_arc OF UAL_tb IS

  SIGNAL srcA, srcB             : std_logic_vector (TAILLE-1 DOWNTO 0);
  SIGNAL ualControl             : std_logic_vector (3 DOWNTO 0);
  SIGNAL cout, cout_attendu     : std_logic;
  SIGNAL result, result_attendu : std_logic_vector (TAILLE-1 DOWNTO 0);
  SIGNAL zero, zero_attendu     : std_logic;
  SIGNAL OpType                 : string(1 TO 3);

  CONSTANT PERIODE : time := 20 ns;

BEGIN
  ALU32 : ENTITY work.ual
      GENERIC MAP (32)
      PORT MAP (std_logic_vector(ualControl),std_logic_vector(srcA),std_logic_vector(srcB),(result),(cout),(zero));
      
    
------------------------------------------------------------------
    PROCESS(ualControl)
    BEGIN
      CASE ualControl IS
        WHEN X"0"   => OpType <= "AND";  -- Operation ET logique
        WHEN X"1"   => OpType <= "OR ";  -- Operation OU logique
        WHEN X"2"   => OpType <= "ADD";  -- Operation ADD logique
        WHEN X"6"   => OpType <= "SUB";  -- Operation SUB logique
        WHEN X"7"   => OpType <= "SLT";  -- Operation ET logique
        WHEN OTHERS => OpType <= "---";  -- Illegal
      END CASE;
    END PROCESS;

------------------------------------------------------------------                           
  PROCESS

    FILE fichierIn  : text OPEN read_mode IS "ual_entrees_V4.txt";
    FILE fichierOut : text OPEN write_mode IS "ual_sorties.txt";

    VARIABLE vsrcA, vsrcB, vresult_attendu : std_logic_vector (TAILLE-1 DOWNTO 0);
    VARIABLE vUAL                          : std_logic_vector (3 DOWNTO 0);
    VARIABLE vzero, vcout                  : std_logic;
    VARIABLE ligneEntree, ligneSortie      : line;
    VARIABLE good                          : boolean;
    VARIABLE entete                        : boolean := true;
  BEGIN
  
    --Lecture de l'entête
    IF entete THEN
      write(ligneSortie, string'("<ualCtrl> < srcA > < srcB >  < Résultat > < Résultat_UAL > < zero > < cout >: <commentaire>"));
      writeline(fichierOut, ligneSortie);
      entete := false;
      readline(fichierIn, ligneEntree);
      readline(fichierIn, ligneEntree);
    END IF;
    --Lit le fichier
    IF NOT(endfile(fichierIn)) THEN
      readline(fichierIn, ligneEntree);
      --ualControl
      hread(ligneEntree, vUAL, good);
      ASSERT good REPORT "Erreur de lecture de l'operande UALcontrol" SEVERITY error;
      --vsrCA
      hread(ligneEntree, vsrcA, good);
      ASSERT good REPORT "Erreur de lecture de l'operande vsrcA" SEVERITY error;
      --vsrCB
      hread(ligneEntree, vsrcB, good);
      ASSERT good REPORT "Erreur de lecture de l'operande vsrcA" SEVERITY error;
      --result
      hread(ligneEntree, vresult_attendu, good);
      ASSERT good REPORT "Erreur de lecture de l'operande result_attendu" SEVERITY error;
      --zero
      read(ligneEntree, vzero, good);
      ASSERT good REPORT "Erreur de lecture de l'operande zero" SEVERITY error;
      --cout
      read(ligneEntree, vcout, good);
      ASSERT good REPORT "Erreur de lecture de l'operande cout" SEVERITY error;
      --Assignation de valeur
      srcA<=vsrcA;
      srcB<=vsrcB;
      ualControl <=vUAL;
      result_attendu<= vresult_attendu;
    END IF;
    --Attend pendant 20 ns
    WAIT FOR 20 ns;
    --Écriture des valeurs dans le fichier de sortie
    hwrite(ligneSortie, ((ualControl)), right, 4);          --ualControl
    hwrite(ligneSortie, ((srcA)), right, 9);                --srcA
    hwrite(ligneSortie, ((srcB)), right, 9);                --srcB
    hwrite(ligneSortie, ((result_attendu)), right, 9);      --result_attendu
    write(ligneSortie, ((vzero)), right, 4);                --vzero
    write(ligneSortie, ((vcout)), right, 4);                --vcout
    
    --Valeur de test
    hwrite(ligneSortie, ((result)), right, 9);              --result
    write(ligneSortie, ((zero)), right, 4);                 --zero
    write(ligneSortie, ((COUT)), right, 4);                 --COUT
  
    --Valide le résultat
    if (result /= result_attendu) or (zero /= vzero) or (COUT /= vcout)then
      write(ligneSortie, string'(" : ÉCHEC"), right, 4);
    else
      write(ligneSortie, string'(" : SUCCÈS"), right, 4);
    end if;
    --On passe à la prochaine ligne
    writeline(fichierOut, ligneSortie);

    END PROCESS;
END UAL_tb_arc;
