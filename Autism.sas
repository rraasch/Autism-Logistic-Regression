*import the data;
FILENAME dat '/folders/myfolders/sasuser.v94/base_data_3.csv';

PROC IMPORT DATAFILE=dat
	DBMS=CSV
	OUT=autism;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=autism; RUN;

PROC PRINT DATA=autism;RUN;

*set the state average rate, change this later to be accurate;
*new variable to use 'rate';
DATA autism1;
SET autism;
IF A_Rate <= 8 THEN rate = 0;
ELSE rate=1;
DROP A_Count A_Rate;
RUN;

*backward selection of logistic regression variables;
TITLE2 'ANALYSIS 2';
PROC LOGISTIC DATA=autism1 DESC;
 MODEL RATE = D_Size -- Income_median/SELECTION=BACKWARD SLSTAY=.10;
 OUTPUT OUT=PDICTS  PREDICTED=PHAT;

DATA PDICTS_ALL;
SET pdicts;
IF PHAT <.5 THEN PREDICT = 0;
IF PHAT >=.5 THEN PREDICT=1;
IF rate = 0 AND PREDICT = 0 THEN RESULT = 'TRUE NEGATIVE';
ELSE IF rate = 0 AND PREDICT = 1 THEN RESULT = 'FALSE POSITIVE';
ELSE IF rate = 1 AND PREDICT = 0 THEN RESULT = 'FALSE NEGATIVE';
ELSE RESULT = 'TRUE POSITIVE';
RUN;

PROC SQL;
SELECT DISTINCT RESULT, COUNT(RESULT)/367 FROM PDICTS_ALL
GROUP BY RESULT;
QUIT;

PROC FREQ;
 TABLES RATE*PREDICT;
 RUN;











/*
 Dr. Kim's code
DATA FINAL; SET autism1;
  G1 = 32.1633-.3663*HUM+.0111*TIB+.1497*TIN;
  G2 =  6.1005-.5759*HUM+.1831*TIB+.2827*TIN;
  EG1=EXP(G1); EG2=EXP(G2);
  IF EG1>EG2 THEN PREDICT='0';
  IF EG2>EG1 THEN PREDICT='1';
RUN;

PROC PRINT DATA=FINAL;
 VAR RATE EG1 EG2 PREDICT;
 RUN;

PROC FREQ;
 TABLES RATE*PREDICT;
 RUN;

TITLE2 'ANALYSIS 2';
PROC LOGISTIC DATA=TURKEY;
 MODEL TYPE =HUM--STL/SELECTION=BACKWARD SLSTAY=.10;
 OUTPUT OUT=PDICTS  PREDICTED=PHAT;

DATA ONE;
 SET PDICTS;
 IF _LEVEL_='BB' THEN P1=PHAT;

 IF _LEVEL_='BB';

DATA TWO;
 SET PDICTS;
 IF _LEVEL_='OT' THEN P2=PHAT;
 IF _LEVEL_='OT';

DATA THREE; DROP _LEVEL_;
 MERGE ONE TWO;
 P2=P2-P1;
 P3=1-P1-P2;
RUN;

DATA FINAL; SET THREE;
 IF P1>P2 AND P1>P3 THEN PREDICT='BB';
 IF P2>P1 AND P2>P3 THEN PREDICT='OT';
 IF P3>P1 AND P3>P2 THEN PREDICT='W ';

PROC PRINT; VAR ID TYPE P1 P2 P3 PREDICT;

PROC FREQ;
 TABLES TYPE*PREDICT;
 RUN;
 */


















/* begin logistic on factor analysis */

*factor analysis logistic on 7 factors;
PROC IMPORT DATAFILE='/folders/myfolders/sasuser.v94/fa_08_7.csv'
	DBMS=CSV
	OUT=fa_7;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=fa_7; RUN;


DATA autism7;
SET fa_7;
IF A_Rate < 8 THEN rate = 0;
ELSE rate=1;
DROP A_Rate;
RUN;

TITLE "Logistic Regression on Autism Rate Above State Average";

 
TITLE2 'ANALYSIS FA7';
PROC LOGISTIC DATA=autism7;
 MODEL RATE = FACTOR1-FACTOR7/SELECTION=BACKWARD SLSTAY=.10;
 OUTPUT OUT=PDICTS  PREDICTED=PHAT;
RUN;

DATA PDICTS7;
SET pdicts;
IF PHAT <.5 THEN PREDICT = 0;
IF PHAT >=.5 THEN PREDICT=1;
IF rate = 0 AND PREDICT = 0 THEN RESULT = 'TRUE NEGATIVE';
ELSE IF rate = 0 AND PREDICT = 1 THEN RESULT = 'FALSE POSITIVE';
ELSE IF rate = 1 AND PREDICT = 0 THEN RESULT = 'FALSE NEGATIVE';
ELSE RESULT = 'TRUE POSITIVE';
RUN;
*PROC PRINT DATA=PDICTS7;RUN;

PROC SQL;
SELECT DISTINCT RESULT, COUNT(RESULT)/367 FROM PDICTS7
GROUP BY RESULT;
QUIT;
  
PROC FREQ;
 TABLES RATE*PREDICT;
 RUN;







/* 12 factors */

PROC IMPORT DATAFILE='/folders/myfolders/sasuser.v94/fa_08_12.csv'
	DBMS=CSV
	OUT=fa_12;
	GETNAMES=YES;
RUN;


DATA autism12;
SET fa_12;
IF A_Rate < 8 THEN rate = 0;
ELSE rate=1;
DROP A_Rate;
RUN;

TITLE "Logistic Regression on Autism Rate Above State Average";


TITLE2 'ANALYSIS FA12';
PROC LOGISTIC DATA=autism12;
 MODEL RATE = FACTOR1-FACTOR12/SELECTION=BACKWARD SLSTAY=.10;
 OUTPUT OUT=PDICTS  PREDICTED=PHAT;
RUN;


DATA PDICTS12;
SET pdicts;
IF PHAT <.5 THEN PREDICT = 0;
IF PHAT >=.5 THEN PREDICT=1;
IF rate = 0 AND PREDICT = 0 THEN RESULT = 'TRUE NEGATIVE';
ELSE IF rate = 0 AND PREDICT = 1 THEN RESULT = 'FALSE POSITIVE';
ELSE IF rate = 1 AND PREDICT = 0 THEN RESULT = 'FALSE NEGATIVE';
ELSE RESULT = 'TRUE POSITIVE';
RUN;

PROC SQL;
SELECT DISTINCT RESULT, COUNT(RESULT)/367 FROM PDICTS12
GROUP BY RESULT;
QUIT;

PROC FREQ;
 TABLES RATE*PREDICT;
 RUN;






