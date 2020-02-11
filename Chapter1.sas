
FILENAME REFFILE '/folders/myfolders/FAA1.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT;
	GETNAMES=YES;
	SHEET="Faa1";
RUN;

PROC CONTENTS DATA=WORK.IMPORT;
RUN;

FILENAME REFFILE '/folders/myfolders/FAA2.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
	SHEET="Faa2";
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; 
RUN;

Data COMBINED;
SET Import Import1;
RUN;
proc print data=COMBINED;
run;


data missing;
set combined;
options missing='';
if missing(cats(of _all_))then delete;
run;
proc print data=missing;
run;

proc sort data=missing Out=missing_noduplicate Nodupkey;
by aircraft no_pasg speed_ground speed_air height pitch distance;
run;
proc print data=missing_noduplicate;
run;


DATA abnormal;
SET missing_noduplicate; 
IF duration <40 THEN DURATION_ABNORMAL='YES';
ELSE DURATION_ABNORMAL='NO'
;
if speed_air < 30 
   or speed_air > 140 
then AIRSPEED_abnormal = 'YES';
else AIRSPEED_abnormal = 'NO' 
;
if height < 6 
then HEIGHT_ABNORMAL = 'YES';
else HEIGHT_ABNORMAL = 'NO'
;
if distance >6000
then DISTANCE_ABNORMAL ='YES';
else DISTANCE_ABNORMAL = 'NO'
;
RUN;
proc print data=abnormal;
run;

data cleaning;
 set missing_noduplicate;
 if no_pasg =. or no_pasg<0 then delete;
	if speed_ground =. or speed_ground < 30 or speed_ground >140 then delete;
	if height =. or height<6 then delete;
	if pitch =. then delete;
	if distance =.  or distance> 6000 then delete;	
proc print data = cleaning;
run;
proc means data = cleaning n nmiss min max;
run;


data distribution;
set cleaning;
proc univariate data= distribution;
   var pitch ;
run;
proc print data=distribution;
run;

PROC MEANS DATA=cleaning N NMISS MEAN STD MIN MAX RANGE; 
TITLE SUMMARY STATISTICS FOR Airline Data;
RUN;
proc print data=cleaning;
run;


proc plot data = cleaning;
plot distance*duration = '$';
run;

proc plot data=cleaning;
plot distance*no_pasg = '@';
run;

proc plot data=cleaning;
plot distance*speed_air = '*';
run;

proc plot data=cleaning;
plot distance*speed_ground ;
run;

proc plot data=cleaning;
plot distance*height = '@';
run;

proc plot data=cleaning;
plot distance*pitch = '*';
run;

proc corr data=cleaning;
var distance;
with duration speed_air speed_ground height pitch no_pasg;
title CORRELATION COEFFICIENTS WITH DISTANCE;
run;

proc plot data=cleaning;
plot speed_ground*speed_air = '#';
run;

proc corr data=cleaning;
var speed_ground;
with speed_air;
title CORRELATION COEFFICIENT OF speed_ground WITH speed_air;
run;

/*Regression Analysis */
proc reg data = cleaning;
model distance = duration no_pasg speed_ground speed_air height pitch;
title Regression Analysis of DISTANCE using the cleaned dataset;
run;

/*Regression Analysis with Residuals */
proc reg data = cleaning;
model distance = speed_air height/r;
output out = cleaneddata_residuals r = residuals;
title Regression Analysis of DISTANCE with Residuals using the cleaned dataset;
run;

proc ttest data =cleaneddata_residuals;
var residuals;
run;



