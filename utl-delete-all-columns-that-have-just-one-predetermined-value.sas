Delete all columns that have just one predetermined value

see github
https://tinyurl.com/y9axht9y
https://github.com/rogerjdeangelis/utl-delete-all-columns-that-have-just-one-predetermined-value

see stackoverflow
https://tinyurl.com/yaev3jge
https://stackoverflow.com/questions/52423387/how-do-i-delete-multiple-column-variables-in-sas-which-just-state-null-but-are

for macros used
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories


INPUT
=====

 WORK.HAVE total obs=4

              FAVOURITE_                  FAVOURITE_
  NAME           FOOD       OCCUPATION      SPORT

  John           Null        Nurse           Null
  Michelle       Null        Lawyer          Null
  Peter          Null        Teacher         Null
  Kai            Null        Doctor          Null


 RULES

  Drop favourite_food favourite_sport because they are null;


 EXAMPLE OUTPUT
 --------------

 WORK.WANT total obs=4

  NAME        OCCUPATION

  John         Nurse
  Michelle     Lawyer
  Peter        Teacher
  Kai          Doctor


PROCESS
=======

  * general - you do not need to know the variable names;

  /* I expect this to be fast, especially if the number of cores is
    greater than the number of variables. */

  %symdel %varlist(have) / nowarn; * just in case;

  %array(vars,values=%varlist(have));

  proc sql;
    select
       catx(" ", %do_over(vars,phrase=?,between=comma) )
    into
       :drpkep
    from (
      select
          %do_over(vars,phrase=%str(
         ifc (sum(? = 'Null') = count(*), "drop ?;","keep ?;") as ?),between=comma)
      from
          have)
 ;quit;

 data want;
    &drpkep
    set have;
 run;quit;



* LOG and generated code;

SYMBOLGEN:  Macro variable DRPKEP resolves to keep NAME; drop FAVOURITE_FOOD; keep OCCUPATION; drop FAVOURITE_SPORT;

GENERATED CODE
If you highlight the code and type debug on the command lne and then go to
saswork you will find mactxt.sas  withthe generated code


options mfile mprint source2;
proc sql;
   select
      catx(" ", NAME , FAVOURITE_FOOD , OCCUPATION , FAVOURITE_SPORT)
   into
      :drpkep
   from
     ( select
         ifc (sum(NAME = 'Null') = count(*), "drop NAME;","keep NAME;") as NAME
       , ifc (sum(FAVOURITE_FOOD = 'Null') = count(*), "drop FAVOURITE_FOOD;","keep FAVOURITE_FOOD;") as FAVOURITE_FOOD
       , ifc (sum(OCCUPATION = 'Null') = count(*), "drop OCCUPATION;","keep OCCUPATION;") as OCCUPATION
       , ifc (sum(FAVOURITE_SPORT = 'Null') = count(*), "drop FAVOURITE_SPORT;","keep FAVOURITE_SPORT;") asFAVOURITE_SPORT
     from
         have) ;
quit;

data want;
   keep NAME;
   drop FAVOURITE_FOOD;
   keep OCCUPATION;
   drop FAVOURITE_SPORT;
set have;
run;
quit;

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;


DATA have;
INPUT name$ favourite_food$ occupation$ favourite_sport$;
CARDS4;
John Null Nurse Null
Michelle Null Lawyer Null
Peter Null Teacher Null
Kai Null Doctor Null
run;quit;

