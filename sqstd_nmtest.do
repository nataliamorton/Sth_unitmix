#delimit ;
set more off;
version 7;
set mem 10000m;
set matsize 800;
clear;

/*if "$S_OS"=="Windows" {global prefix="x:"};*/
if "$S_OS"=="Windows" {global prefix="//odin/reisadmin"};
if "$S_OS"=="Unix" {global prefix="/home"};

/** DQ 04-23-2015: INPUT FORMAT NOTE: I am formatting the Last Surveyed and Last Updated and SurveyDate columns in student1.txt to the format of mm/dd/yyyy just in case squaring needs to read it that way **/
/** DQ 01-05-2016: INPUT NOTE: I am not sure whether any subroutines still use student1.txt or not, so I will continue to save student1.txt AND stdbase.txt until advised otherwise **/

run $prefix/central/master-do-files/date_aptoffret;

/** This is automated script to generate pastyr, pastqtr, etc, no need to update this **/

global pastyr2 = $curryr;

if $currqtr == 1 & $currmo == 1 {;
   global pastyr = ($curryr - 1);
   global pastyr2 = ($curryr - 1);
   global pastqtr = 4;
   global pastqtr2 = 4;
   global foryr = $curryr;
   global forqtr = 1;
   global prevyr = ($curryr - 1);
   global prevmon = 12;
   };
   
if $currqtr == 1 & $currmo == 2 {;
   global pastyr = $curryr;
   global pastyr2 = ($curryr - 1);
   global pastqtr = 1;
   global pastqtr2 = 4;
   global foryr = $curryr;
   global forqtr = 1;
   global prevyr = ($curryr - 1);
   global prevmon = 1;
   };   
   
if $currqtr == 1 & $currmo == 3 {;
   global pastyr = $curryr;
   global pastyr2 = $curryr;
   global pastqtr = 1;
   global pastqtr2 = 1;
   global foryr = $curryr;
   global forqtr = 2;
   global prevyr = ($curryr - 1);
   global prevmon = 2;
   };   

if $currqtr == 2 & $currmo == 4 {;
   global pastyr = $curryr;
   global pastyr2 = $curryr;
   global pastqtr = 1;
   global pastqtr2 = 1;
   global foryr = $curryr;
   global forqtr = 2;
   global prevyr = ($curryr - 1);
   global prevmon = 3;
   };   

if $currqtr == 2 & $currmo == 5 {;
   global pastyr = $curryr;
   global pastyr2 = $curryr;
   global pastqtr = 2;
   global pastqtr2 = 1;
   global foryr = $curryr;
   global forqtr = 2;
   global prevyr = ($curryr - 1);
   global prevmon = 4;
   };   

if $currqtr == 2 & $currmo == 6 {;
   global pastyr = $curryr;
   global pastyr2 = $curryr;
   global pastqtr = 2;
   global pastqtr2 = 2;
   global foryr = $curryr;
   global forqtr = 3;
   global prevyr = ($curryr - 1);
   global prevmon = 5;
   };   
   
if $currqtr == 3 & $currmo == 7 {;
   global pastyr = $curryr;
   global pastyr2 = $curryr;
   global pastqtr = 2;
   global pastqtr2 = 2;
   global foryr = $curryr;
   global forqtr = 3;
   global prevyr = ($curryr - 1);
   global prevmon = 6;
   };      
   
if $currqtr == 3 & $currmo == 8 {;
   global pastyr = $curryr;
   global pastyr2 = $curryr;
   global pastqtr = 3;
   global pastqtr2 = 2;
   global foryr = $curryr;
   global forqtr = 3;
   global prevyr = ($curryr - 1);
   global prevmon = 7;
   };      
   
if $currqtr == 3 & $currmo == 9 {;
   global pastyr = $curryr;
   global pastyr2 = $curryr;
   global pastqtr = 3;
   global pastqtr2 = 3;
   global foryr = $curryr;
   global forqtr = 4;
   global prevyr = ($curryr - 1);
   global prevmon = 8;
   };         
   
if $currqtr == 4 & $currmo == 10 {;
   global pastyr = $curryr;
   global pastyr2 = $curryr;
   global pastqtr = 3;
   global pastqtr2 = 3;
   global foryr = $curryr;
   global forqtr = 4;
   global prevyr = ($curryr - 1);
   global prevmon = 9;
   }; 
   
if $currqtr == 4 & $currmo == 11 {;
   global pastyr = $curryr;
   global pastyr2 = $curryr;
   global pastqtr = 4;
   global pastqtr2 = 3;
   global foryr = $curryr;
   global forqtr = 4;
   global prevyr = ($curryr - 1);
   global prevmon = 10;
   };   
   
if $currqtr == 4 & $currmo == 12 {;
   global pastyr = $curryr;
   global pastyr2 = $curryr;
   global pastqtr = 4;
   global pastqtr2 = 4;
   global foryr = ($curryr + 1);
   global forqtr = 1;
   global prevyr = ($curryr - 1);
   global prevmon = 11;
   }; 
   

/** Set period seed here: Start year, where ending year is curryr / currqtr **/

global begyr = 2014;
global curryr = 2019;
global currqtr = 1;
global currmo = 3;

/** Set the metro list here **/

*run $prefix/central/master-do-files/metlist_std.do;
global metlist = "tsa fsu";

/** Generate "prep" files for framing time periods, etc **/

global expper = (($curryr - $begyr) + 1);

/** Format STD-specific Economy.com data **/
/**
use $prefix/central/metcast/data/rfa/current/rfa_${curryr}q${currqtr}_final;
keep metcode yr qtr state qfhholdq qfpop1519q qfpop2024q qfpop2529q metcpi;

/** Monthize **/

drop if qtr == 5;
drop if yr < ($begyr - 1);
expand 3;
sort metcode yr qtr; 
by metcode yr: gen currmon = _n;

gen mhh = qfhholdq;
gen mpop1519 = qfpop1519q;
gen mpop2024 = qfpop2024q;
gen mpop2529 = qfpop2529q;
gen mpop1529 = qfpop1519q + qfpop2024q + qfpop2529q;
gen mcpi = metcpi;

by metcode: replace mhh = (0.35*mhh[_n - 1] + 0.65*mhh[_n + 2]) if (currmon == 2 | currmon == 5 | currmon == 8 | currmon == 11);
by metcode: replace mhh = (0.50*mhh[_n - 1] + 0.50*mhh[_n + 1]) if (currmon == 3 | currmon == 6 | currmon == 9);
by metcode: replace mhh = round(mhh, 0.01);

by metcode: replace mpop1519 = (0.35*mpop1519[_n - 1] + 0.65*mpop1519[_n + 2]) if (currmon == 2 | currmon == 5 | currmon == 8 | currmon == 11);
by metcode: replace mpop1519 = (0.50*mpop1519[_n - 1] + 0.50*mpop1519[_n + 1]) if (currmon == 3 | currmon == 6 | currmon == 9);
by metcode: replace mpop1519 = round(mpop1519, 0.01);

by metcode: replace mpop2024 = (0.35*mpop2024[_n - 1] + 0.65*mpop2024[_n + 2]) if (currmon == 2 | currmon == 5 | currmon == 8 | currmon == 11);
by metcode: replace mpop2024 = (0.50*mpop2024[_n - 1] + 0.50*mpop2024[_n + 1]) if (currmon == 3 | currmon == 6 | currmon == 9);
by metcode: replace mpop2024 = round(mpop2024, 0.01);

by metcode: replace mpop2529 = (0.35*mpop2529[_n - 1] + 0.65*mpop2529[_n + 2]) if (currmon == 2 | currmon == 5 | currmon == 8 | currmon == 11);
by metcode: replace mpop2529 = (0.50*mpop2529[_n - 1] + 0.50*mpop2529[_n + 1]) if (currmon == 3 | currmon == 6 | currmon == 9);
by metcode: replace mpop2529 = round(mpop2529, 0.01);

by metcode: replace mpop1529 = (0.35*mpop1529[_n - 1] + 0.65*mpop1529[_n + 2]) if (currmon == 2 | currmon == 5 | currmon == 8 | currmon == 11);
by metcode: replace mpop1529 = (0.50*mpop1529[_n - 1] + 0.50*mpop1529[_n + 1]) if (currmon == 3 | currmon == 6 | currmon == 9);
by metcode: replace mpop1529 = round(mpop1529, 0.01);

by metcode: replace mcpi = (0.35*mcpi[_n - 1] + 0.65*mcpi[_n + 2]) if (currmon == 2 | currmon == 5 | currmon == 8 | currmon == 11);
by metcode: replace mcpi = (0.50*mcpi[_n - 1] + 0.50*mcpi[_n + 1]) if (currmon == 3 | currmon == 6 | currmon == 9);
by metcode: replace mcpi = round(mcpi, 0.01);

by metcode: gen mhhd = (mhh - mhh[_n - 1])/mhh[_n - 1];
by metcode: gen mpop1519d = (mpop1519 - mpop1519[_n - 1])/mpop1519[_n - 1];
by metcode: gen mpop2024d = (mpop2024 - mpop2024[_n - 1])/mpop2024[_n - 1];
by metcode: gen mpop2529d = (mpop2529 - mpop2529[_n - 1])/mpop2529[_n - 1];
by metcode: gen mpop1529d = (mpop1529 - mpop1529[_n - 1])/mpop1529[_n - 1];
by metcode: gen mcpid = (mcpi - mcpi[_n - 1])/mcpi[_n - 1];

keep metcode state yr qtr currmon mhh mhhd mpop1519 mpop1519d mpop2024 mpop2024d mpop2529 mpop2529d mpop1529 mpop1529d mcpi mcpid;
order metcode state yr qtr currmon mhh mhhd mpop1519 mpop1519d mpop2024 mpop2024d mpop2529 mpop2529d mpop1529 mpop1529d mcpi mcpid;
sort metcode yr qtr currmon;

save $prefix/central/vc/std/data/std_demo_${curryr}q${currqtr}, replace;
clear;

/** Pick up TXT file download from Foundation and convert into DTA **/

insheet using $prefix/central/vc/std/data/stdbase.txt;
save $prefix/central/vc/std/data/stdbase, replace;

/** Input file for "prelease" for propertyhistory "switching" code **/

use $prefix/central/vc/std/data/stdbase;
rename propertyid id;
keep id prelease;
gen prel1 = 0;
replace prel1 = 1 if prelease ~= "";
sort id;
by id: egen prel2 = mean(prel1);
drop if id == id[_n - 1];
gen str3 prelswitch = "No";
replace prelswitch = "Yes" if prel2 ~= 0;
keep id prelswitch;
sort id;
save $prefix/central/vc/std/data/propertyhistoryprelswitch, replace;
clear;

/** First pull last quarter breakouts to apply where no changes have occured **/

  local i = 1;
  local I : word count $metlist;
     while `i' <= `I' {;
     local j : word `i' of $metlist;
	 
use $prefix/central/square/data/std/production/msq/`j'msq;

sort id yr qtr currmon;
drop if id == id[_n+1];
keep id yr qtr currmon propuse code metcode subid propertytype totbeds totbedx totbedxM beds0x 
	beds0xM beds1x beds1xM beds2x beds2xM beds3x beds3xM beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM units4x units4xM;
	
global fill_list "propuse code metcode subid propertytype totbeds totbedx totbedxM beds0x 
	beds0xM beds1x beds1xM beds2x beds2xM beds3x beds3xM beds4x beds4xM totunits totunitx totunitxM units0x 
	units0xM units1x units1xM units2x units2xM units3x units3xM units4x units4xM";
	 
/**Fill structural data  **/	 
foreach x in $fill_list{;
	rename `x' prev_`x';
};
	
if `i' == 1 { save $prefix/central/nm/stdstruc, replace};
if `i' ~= 1 {;
	append using $prefix/central/nm/stdstruc;
	sort prev_metcode prev_subid id;
	save $prefix/central/nm/stdstruc, replace;
	};

drop _all;
local i = `i' + 1;

};
clear;



use $prefix/central/vc/std/data/stdbase;

/** Estimate STRUCTURALS **/

rename propertyid id;
rename msa metcode;
rename universitycode unicode;

sort metcode;
joinby metcode using $prefix/central/master-data/genmet, unmatched(master);
drop _merge;

/** Should anything be dropped?  Right now, bias is towards keeping EVERYTHING; drop stuff (P1291, demolished, from "MUSINGS") LATER**/

sort id;

/** First, generate "rent clues before keeping only the latest observation - as per NDN input "what if there was some rent survey at some
    point in the past that could indicate that there ought to be units or beds there?" Boom. **/

by id: egen curren0 = mean(braverage0);
by id: egen curren1 = mean(braverage1);
by id: egen curren2 = mean(braverage2);
by id: egen curren3 = mean(braverage3);
by id: egen curren4 = mean(braverage4);

by id: egen futren0 = mean(brfutureaverage0);
by id: egen futren1 = mean(brfutureaverage1);
by id: egen futren2 = mean(brfutureaverage2);
by id: egen futren3 = mean(brfutureaverage3);
by id: egen futren4 = mean(brfutureaverage4);

drop if id == id[_n - 1];
order unicode metcode id;
sort unicode metcode id;

rename bldgs bldgx;
rename floors flrsx;
gen bldgxM = 0;
replace bldgxM = 1 if bldgx == .;
gen flrsxM = 0;
replace flrsxM = 1 if flrsx == .;

/** Sum BEDS and UNITS / Test for internal consistency **/

rename studentbeds totbeds;
rename totalunits totunits;

gen beds0x = brbeds0;
gen beds1x = brbeds1;
gen beds2x = brbeds2;
gen beds3x = brbeds3;
gen beds4x = brbeds4;

gen beds0xM = 1;
gen beds1xM = 1;
gen beds2xM = 1;
gen beds3xM = 1;
gen beds4xM = 1;

replace beds0xM = 0 if brbeds0 ~= .;
replace beds1xM = 0 if brbeds1 ~= .;
replace beds2xM = 0 if brbeds2 ~= .;
replace beds3xM = 0 if brbeds3 ~= .;
replace beds4xM = 0 if brbeds4 ~= .;

replace beds0x = 0 if beds0xM == 1 & brbeds0 == .;
replace beds1x = 0 if beds1xM == 1 & brbeds1 == .;
replace beds2x = 0 if beds2xM == 1 & brbeds2 == .;
replace beds3x = 0 if beds3xM == 1 & brbeds3 == .;
replace beds4x = 0 if beds4xM == 1 & brbeds4 == .;

gen units0x = brunits0;
gen units1x = brunits1;
gen units2x = brunits2;
gen units3x = brunits3;
gen units4x = brunits4;

gen units0xM = 1;
gen units1xM = 1;
gen units2xM = 1;
gen units3xM = 1;
gen units4xM = 1;

replace units0xM = 0 if brunits0 ~= .;
replace units1xM = 0 if brunits1 ~= .;
replace units2xM = 0 if brunits2 ~= .;
replace units3xM = 0 if brunits3 ~= .;
replace units4xM = 0 if brunits4 ~= .;

replace units0x = 0 if units0xM == 1 & brunits0 == .;
replace units1x = 0 if units1xM == 1 & brunits1 == .;
replace units2x = 0 if units2xM == 1 & brunits2 == .;
replace units3x = 0 if units3xM == 1 & brunits3 == .;
replace units4x = 0 if units4xM == 1 & brunits4 == .;

/** Tests for internal consistency / totals and units **/

gen totunitx = totunits;
gen totbedx = totbeds;
gen totunitxM = 1;
gen totbedxM = 1;
replace totunitxM = 0 if totunits ~= .;
replace totbedxM = 0 if totbeds ~= .;

/** WTF totbeds = 0 / totunits = 0 **/

replace totunitx = . if totunits == 0;
replace totunitxM = 1 if totunits == 0;
replace totbedx = . if totbeds == 0;
replace totbedxM = 1 if totbeds == 0;

replace beds0x = 0 if beds0x == .;
replace beds1x = 0 if beds1x == .;
replace beds2x = 0 if beds2x == .;
replace beds3x = 0 if beds3x == .;
replace beds4x = 0 if beds4x == .;

replace units0x = 0 if units0x == .;
replace units1x = 0 if units1x == .;
replace units2x = 0 if units2x == .;
replace units3x = 0 if units3x == .;
replace units4x = 0 if units4x == .;

gen bedst = beds0x + beds1x + beds2x + beds3x + beds4x;
gen unitst = units0x + units1x + units2x + units3x + units4x;

gen str3 icb = "No";
gen str3 icu = "No";
replace icb = "Yes" if bedst == totbedx & totbedx ~= . & totbedx > 0;
replace icu = "Yes" if unitst == totunitx & totunitx ~= . & totunitx > 0;

/** Determine the "BUCKETS" for estimation, where you CAN and CANNOT put estimates for beds AND units 
    (Essentially, the program's "degrees of freedom") **/

gen str3 nddq0 = "No";
gen str3 nddq1 = "No";
gen str3 nddq2 = "No";
gen str3 nddq3 = "No";
gen str3 nddq4 = "No";

/** The clues are brbeds*, brunits*, brparity*, brbed_avgsf*, brunit_avgsf*, curren*, futren* **/

replace nddq0 = "Yes" if brbeds0 ~= .;
replace nddq1 = "Yes" if brbeds1 ~= .;
replace nddq2 = "Yes" if brbeds2 ~= .;
replace nddq3 = "Yes" if brbeds3 ~= .;
replace nddq4 = "Yes" if brbeds4 ~= .;

replace nddq0 = "Yes" if brunits0 ~= .;
replace nddq1 = "Yes" if brunits1 ~= .;
replace nddq2 = "Yes" if brunits2 ~= .;
replace nddq3 = "Yes" if brunits3 ~= .;
replace nddq4 = "Yes" if brunits4 ~= .;

replace nddq0 = "Yes" if brparity0 ~= "";
replace nddq1 = "Yes" if brparity1 ~= "";
replace nddq2 = "Yes" if brparity2 ~= "";
replace nddq3 = "Yes" if brparity3 ~= "";
replace nddq4 = "Yes" if brparity4 ~= "";

replace nddq0 = "Yes" if brbed_avgsf0 ~= .;
replace nddq1 = "Yes" if brbed_avgsf1 ~= .;
replace nddq2 = "Yes" if brbed_avgsf2 ~= .;
replace nddq3 = "Yes" if brbed_avgsf3 ~= .;
replace nddq4 = "Yes" if brbed_avgsf4 ~= .;

replace nddq0 = "Yes" if brunit_avgsf0 ~= .;
replace nddq1 = "Yes" if brunit_avgsf1 ~= .;
replace nddq2 = "Yes" if brunit_avgsf2 ~= .;
replace nddq3 = "Yes" if brunit_avgsf3 ~= .;
replace nddq4 = "Yes" if brunit_avgsf4 ~= .;

replace nddq0 = "Yes" if curren0 ~= .;
replace nddq1 = "Yes" if curren1 ~= .;
replace nddq2 = "Yes" if curren2 ~= .;
replace nddq3 = "Yes" if curren3 ~= .;
replace nddq4 = "Yes" if curren4 ~= .;

replace nddq0 = "Yes" if futren0 ~= .;
replace nddq1 = "Yes" if futren1 ~= .;
replace nddq2 = "Yes" if futren2 ~= .;
replace nddq3 = "Yes" if futren3 ~= .;
replace nddq4 = "Yes" if futren4 ~= .;

/** Begin estimating unit mix - observe constraints! **/

/** Before calculating using shares, first determine intuitive relationships **/

/** The easiest cases: "Where there are structural clues" **/

replace beds0x = units0x if renttype == "Unit" & beds0xM == 1 & icb == "No" & icu == "Yes" & nddq0 == "Yes";
replace beds1x = units1x if renttype == "Unit" & beds1xM == 1 & icb == "No" & icu == "Yes" & nddq1 == "Yes";
replace beds2x = units2x*2 if renttype == "Unit" & beds2xM == 1 & icb == "No" & icu == "Yes" & nddq2 == "Yes";
replace beds3x = units3x*3 if renttype == "Unit" & beds3xM == 1 & icb == "No" & icu == "Yes" & nddq3 == "Yes";
replace beds4x = units4x*4 if renttype == "Unit" & beds4xM == 1 & icb == "No" & icu == "Yes" & nddq4 == "Yes";

replace totbedx = beds0x + beds1x + beds2x + beds3x + beds4x if totbedxM == 1 & renttype == "Unit" & icb == "No" & icu == "Yes";

replace units0x = beds0x if renttype == "Bed" & units0xM == 1 & icu == "No" & icb == "Yes" & nddq0 == "Yes";
replace units1x = beds1x if renttype == "Bed" & units1xM == 1 & icu == "No" & icb == "Yes" & nddq1 == "Yes";
replace units2x = round(beds2x/2, 1) if renttype == "Bed" & units2xM == 1 & icu == "No" & icb == "Yes" & nddq2 == "Yes";
replace units3x = round(beds3x/3, 1) if renttype == "Bed" & units3xM == 1 & icu == "No" & icb == "Yes" & nddq3 == "Yes";
replace units4x = round(beds4x/4, 1) if renttype == "Bed" & units4xM == 1 & icu == "No" & icb == "Yes" & nddq4 == "Yes";

replace totunitx = units0x + units1x + units2x + units3x + units4x if totunitxM == 1 & renttype == "Bed" & icb == "Yes" & icu == "No";

/** 07/13/2015 - for cases like P114, structural clues and internal consistency should render xM = 1 as 0 on the OTHER SIDE, but preserve original
    survey assignments as xMOs! **/
	
gen beds0xMO = beds0xM;
gen beds1xMO = beds1xM;
gen beds2xMO = beds2xM;
gen beds3xMO = beds3xM;
gen beds4xMO = beds4xM;

gen units0xMO = units0xM;
gen units1xMO = units1xM;
gen units2xMO = units2xM;
gen units3xMO = units3xM;
gen units4xMO = units4xM;

replace beds0x = units0x if renttype == "Bed" & beds0xMO == 1 & units0x ~= . & units0xMO == 0 & nddq0 == "Yes";
replace beds1x = units1x if renttype == "Bed" & beds1xMO == 1 & units1x ~= . & units1xMO == 0 & nddq1 == "Yes";
replace beds2x = units2x*2 if renttype == "Bed" & beds2xMO == 1 & units2x ~= . & units2xMO == 0 & nddq2 == "Yes";
replace beds3x = units3x*3 if renttype == "Bed" & beds3xMO == 1 & units3x ~= . & units3xMO == 0 & nddq3 == "Yes";
replace beds4x = units4x*4 if renttype == "Bed" & beds4xMO == 1 & units4x ~= . & units4xMO == 0 & nddq4 == "Yes";

replace beds0xM = 0 if renttype == "Bed" & beds0xMO == 1 & units0x ~= . & units0xMO == 0 & nddq0 == "Yes";
replace beds1xM = 0 if renttype == "Bed" & beds1xMO == 1 & units1x ~= . & units1xMO == 0 & nddq1 == "Yes";
replace beds2xM = 0 if renttype == "Bed" & beds2xMO == 1 & units2x ~= . & units2xMO == 0 & nddq2 == "Yes";
replace beds3xM = 0 if renttype == "Bed" & beds3xMO == 1 & units3x ~= . & units3xMO == 0 & nddq3 == "Yes";
replace beds4xM = 0 if renttype == "Bed" & beds4xMO == 1 & units4x ~= . & units4xMO == 0 & nddq4 == "Yes";

replace units0x = beds0x if renttype == "Unit" & units0xMO == 1 & beds0x ~= . & beds0xMO == 0 & nddq0 == "Yes";
replace units1x = beds1x if renttype == "Unit" & units1xMO == 1 & beds1x ~= . & beds1xMO == 0 & nddq1 == "Yes";
replace units2x = round(beds2x/2, 1) if renttype == "Unit" & units2xMO == 1 & beds2x ~= . & beds2xMO == 2 & nddq0 == "Yes";
replace units3x = round(beds3x/3, 1) if renttype == "Unit" & units3xMO == 1 & beds3x ~= . & beds3xMO == 3 & nddq0 == "Yes";
replace units4x = round(beds4x/4, 1) if renttype == "Unit" & units4xMO == 1 & beds4x ~= . & beds4xMO == 4 & nddq0 == "Yes";

replace units0xM = 0 if renttype == "Unit" & units0xMO == 1 & beds0x ~= . & beds0xMO == 0 & nddq0 == "Yes";
replace units1xM = 0 if renttype == "Unit" & units1xMO == 1 & beds1x ~= . & beds1xMO == 0 & nddq1 == "Yes";
replace units2xM = 0 if renttype == "Unit" & units2xMO == 1 & beds2x ~= . & beds2xMO == 2 & nddq0 == "Yes";
replace units3xM = 0 if renttype == "Unit" & units3xMO == 1 & beds3x ~= . & beds3xMO == 3 & nddq0 == "Yes";
replace units4xM = 0 if renttype == "Unit" & units4xMO == 1 & beds4x ~= . & beds4xMO == 4 & nddq0 == "Yes";	

replace beds0x = units0x if beds0xMO == 1 & units0x ~= . & units0xMO == 0 & nddq0 == "Yes";
replace beds1x = units1x if beds1xMO == 1 & units1x ~= . & units1xMO == 0 & nddq1 == "Yes";
replace beds2x = units2x*2 if beds2xMO == 1 & units2x ~= . & units2xMO == 0 & nddq2 == "Yes";
replace beds3x = units3x*3 if beds3xMO == 1 & units3x ~= . & units3xMO == 0 & nddq3 == "Yes";
replace beds4x = units4x*4 if beds4xMO == 1 & units4x ~= . & units4xMO == 0 & nddq4 == "Yes";

replace beds0xM = 0 if beds0xMO == 1 & units0x ~= . & units0xMO == 0 & nddq0 == "Yes";
replace beds1xM = 0 if beds1xMO == 1 & units1x ~= . & units1xMO == 0 & nddq1 == "Yes";
replace beds2xM = 0 if beds2xMO == 1 & units2x ~= . & units2xMO == 0 & nddq2 == "Yes";
replace beds3xM = 0 if beds3xMO == 1 & units3x ~= . & units3xMO == 0 & nddq3 == "Yes";
replace beds4xM = 0 if beds4xMO == 1 & units4x ~= . & units4xMO == 0 & nddq4 == "Yes";

replace units0x = beds0x if units0xMO == 1 & beds0x ~= . & beds0xMO == 0 & nddq0 == "Yes";
replace units1x = beds1x if units1xMO == 1 & beds1x ~= . & beds1xMO == 0 & nddq1 == "Yes";
replace units2x = round(beds2x/2, 1) if units2xMO == 1 & beds2x ~= . & beds2xMO == 0 & nddq0 == "Yes";
replace units3x = round(beds3x/3, 1) if units3xMO == 1 & beds3x ~= . & beds3xMO == 0 & nddq0 == "Yes";
replace units4x = round(beds4x/4, 1) if units4xMO == 1 & beds4x ~= . & beds4xMO == 0 & nddq0 == "Yes";

replace units0xM = 0 if units0xMO == 1 & beds0x ~= . & beds0xMO == 0 & nddq0 == "Yes";
replace units1xM = 0 if units1xMO == 1 & beds1x ~= . & beds1xMO == 0 & nddq1 == "Yes";
replace units2xM = 0 if units2xMO == 1 & beds2x ~= . & beds2xMO == 0 & nddq0 == "Yes";
replace units3xM = 0 if units3xMO == 1 & beds3x ~= . & beds3xMO == 0 & nddq0 == "Yes";
replace units4xM = 0 if units4xMO == 1 & beds4x ~= . & beds4xMO == 0 & nddq0 == "Yes";

/** Cases where there are BOTH totunitx AND totbedx, but NO unit breakouts, only what nddq suggests! Ex: P803, P7742 **/

/** Conclusion after a few days of tinkering - need to relax at least one internal consistency constraint to render the estimation process tractable;
    Suppressing structural info on Rent Comps anyway unless it's an actual (consistent) property survey, but still need to estimate unit mix for internal
	calculation and consistency purposes.
	TRANSLATION: This shiznits is complex. VC note, 05/26/2015 **/
	
/** Resolve nddq* = "No" - case P11877 where nddq* = all No, but still estimating breakouts **/

replace beds0x = 0 if beds0xM == 1 & nddq0 == "No" & beds0x ~= 0;
replace beds1x = 0 if beds1xM == 1 & nddq1 == "No" & beds1x ~= 0;
replace beds2x = 0 if beds2xM == 1 & nddq2 == "No" & beds2x ~= 0;
replace beds3x = 0 if beds3xM == 1 & nddq3 == "No" & beds3x ~= 0;
replace beds4x = 0 if beds4xM == 1 & nddq4 == "No" & beds4x ~= 0;

replace units0x = 0 if units0xM == 1 & nddq0 == "No" & units0x ~= 0;
replace units1x = 0 if units1xM == 1 & nddq1 == "No" & units1x ~= 0;
replace units2x = 0 if units2xM == 1 & nddq2 == "No" & units2x ~= 0;
replace units3x = 0 if units3xM == 1 & nddq3 == "No" & units3x ~= 0;
replace units4x = 0 if units4xM == 1 & nddq4 == "No" & units4x ~= 0;
	
/** renttype == "Bed" -> estimate only bed counts, by nddq **/

/** Only 0, 1, 2, 3 or 4 **/

replace beds0x = totbeds if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds1x = totbeds if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds2x = totbeds if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds3x = totbeds if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds4x = totbeds if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
			   
/** Two slots **/			   
			   
/** 0/1 **/

replace beds0x = round(totbeds*0.40, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds1x = totbeds - beds0x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
			   
/** 0/2 **/

replace beds0x = round(totbeds*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds2x = totbeds - beds0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";

/** 0/3 **/

replace beds0x = round(totbeds*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds3x = totbeds - beds0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";

/** 0/4 **/

replace beds0x = round(totbeds*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds4x = totbeds - beds0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";

/** 1/2 **/

replace beds1x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds2x = totbeds - beds1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";

/** 1/3 **/

replace beds1x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds3x = totbeds - beds1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";

/** 1/4 **/

replace beds1x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds4x = totbeds - beds1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";

/** 2/3 **/

replace beds2x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds3x = totbeds - beds2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";

/** 2/4 **/

replace beds2x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds4x = totbeds - beds2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";

/** 3/4 **/

replace beds3x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds4x = totbeds - beds3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   

/** 0/1/2 **/

replace beds0x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds1x = round(totbeds*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds2x = totbeds - beds0x - beds1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";	
			   
/** 0/1/3 **/

replace beds0x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds1x = round(totbeds*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds3x = totbeds - beds0x - beds1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";				   
			   
/** 0/1/4 **/

replace beds0x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds1x = round(totbeds*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds4x = totbeds - beds0x - beds1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
			   
/** 1/2/3 **/

replace beds1x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds2x = round(totbeds*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds3x = totbeds - beds1x - beds2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
			   
/** 1/2/4 **/

replace beds1x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds2x = round(totbeds*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds4x = totbeds - beds1x - beds2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
			   
/** 1/3/4 **/

replace beds1x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds3x = round(totbeds*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds4x = totbeds - beds1x - beds3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";	
			   
/** 2/3/4 **/

replace beds2x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds3x = round(totbeds*0.30, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds4x = totbeds - beds2x - beds3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
			   
/** 0/2/3 **/			   
			   
replace beds0x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";	
replace beds2x = round(totbeds*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";				   
replace beds3x = totbedx - beds0x - beds2x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
			   
/** 0/1/2/3 **/

replace beds0x = round(totbeds*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds1x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds2x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds3x = totbeds - beds0x - beds1x - beds2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";	
			   
/** 0/1/2/4 **/

replace beds0x = round(totbeds*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds1x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds2x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds4x = totbeds - beds0x - beds1x - beds2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
			   
/** 0/1/3/4 **/

replace beds0x = round(totbeds*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds1x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds3x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds4x = totbeds - beds0x - beds1x - beds3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
			   
/** 0/2/3/4 **/

replace beds0x = round(totbeds*0.15, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds2x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds3x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds4x = totbeds - beds0x - beds2x - beds3x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
			   
/** 1/2/3/4 **/			   

replace beds1x = round(totbeds*0.15, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds2x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
replace beds3x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds4x = totbeds - beds1x - beds2x - beds3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
			   
/** 0/1/2/3/4 **/

replace beds0x = round(totbeds*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";		   
replace beds1x = round(totbeds*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds2x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds3x = round(totbeds*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";			   
replace beds4x = totbeds - beds0x - beds1x - beds2x - beds3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0 & renttype == "Bed" & icb == "No";
			   
/** renttype == "Unit" -> estimate only unit counts, by nddq **/

/** Only 0, 1, 2, 3 or 4 **/

replace units0x = totunits if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units1x = totunits if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units2x = totunits if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units3x = totunits if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units4x = totunits if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
			   
/** Two slots **/			   
			   
/** 0/1 **/

replace units0x = round(totunits*0.40, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units1x = totunits - units0x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
			   
/** 0/2 **/

replace units0x = round(totunits*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units2x = totunits - units0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";

/** 0/3 **/

replace units0x = round(totunits*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units3x = totunits - units0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";

/** 0/4 **/

replace units0x = round(totunits*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units4x = totunits - units0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";

/** 1/2 **/

replace units1x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units2x = totunits - units1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";

/** 1/3 **/

replace units1x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units3x = totunits - units1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";

/** 1/4 **/

replace units1x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units4x = totunits - units1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";

/** 2/3 **/

replace units2x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units3x = totunits - units2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";

/** 2/4 **/

replace units2x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units4x = totunits - units2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";

/** 3/4 **/

replace units3x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units4x = totunits - units3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   

/** 0/1/2 **/

replace units0x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units1x = round(totunits*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units2x = totunits - units0x - units1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";	
			   
/** 0/1/3 **/

replace units0x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units1x = round(totunits*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units3x = totunits - units0x - units1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";				   
			   
/** 0/1/4 **/

replace units0x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units1x = round(totunits*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units4x = totunits - units0x - units1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
			   
/** 1/2/3 **/

replace units1x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units2x = round(totunits*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units3x = totunits - units1x - units2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
			   
/** 1/2/4 **/

replace units1x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units2x = round(totunits*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units4x = totunits - units1x - units2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
			   
/** 1/3/4 **/

replace units1x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units3x = round(totunits*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units4x = totunits - units1x - units3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";	
			   
/** 2/3/4 **/

replace units2x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units3x = round(totunits*0.30, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units4x = totunits - units2x - units3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
			   
/** 0/2/3 **/			   
			   
replace units0x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";	
replace units2x = round(totunits*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";				   
replace units3x = totunitx - units0x - units2x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
			   
/** 0/1/2/3 **/

replace units0x = round(totunits*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units1x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units2x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units3x = totunits - units0x - units1x - units2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";	
			   
/** 0/1/2/4 **/

replace units0x = round(totunits*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units1x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units2x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units4x = totunits - units0x - units1x - units2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
			   
/** 0/1/3/4 **/

replace units0x = round(totunits*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units1x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units3x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units4x = totunits - units0x - units1x - units3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
			   
/** 0/2/3/4 **/

replace units0x = round(totunits*0.15, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units2x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units3x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units4x = totunits - units0x - units2x - units3x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
			   
/** 1/2/3/4 **/			   

replace units1x = round(totunits*0.15, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units2x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
replace units3x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units4x = totunits - units1x - units2x - units3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";
			   
/** 0/1/2/3/4 **/

replace units0x = round(totunits*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";		   
replace units1x = round(totunits*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units2x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units3x = round(totunits*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";			   
replace units4x = totunits - units0x - units1x - units2x - units3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0 & renttype == "Unit" & icu == "No";	
			   
/** What if renttype == ""? Same code as above, just generalize, but note where totbeds / totunits are "real" **/

/** Only 0, 1, 2, 3 or 4 **/

replace beds0x = totbeds if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds1x = totbeds if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds2x = totbeds if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds3x = totbeds if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds4x = totbeds if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** Two slots **/			   
			   
/** 0/1 **/

replace beds0x = round(totbeds*0.40, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds1x = totbeds - beds0x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** 0/2 **/

replace beds0x = round(totbeds*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds2x = totbeds - beds0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;

/** 0/3 **/

replace beds0x = round(totbeds*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds3x = totbeds - beds0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;

/** 0/4 **/

replace beds0x = round(totbeds*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds4x = totbeds - beds0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;

/** 1/2 **/

replace beds1x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds2x = totbeds - beds1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;

/** 1/3 **/

replace beds1x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds3x = totbeds - beds1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;

/** 1/4 **/

replace beds1x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds4x = totbeds - beds1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;

/** 2/3 **/

replace beds2x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds3x = totbeds - beds2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;

/** 2/4 **/

replace beds2x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds4x = totbeds - beds2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;

/** 3/4 **/

replace beds3x = round(totbeds*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds4x = totbeds - beds3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   

/** 0/1/2 **/

replace beds0x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds1x = round(totbeds*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds2x = totbeds - beds0x - beds1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;	
			   
/** 0/1/3 **/

replace beds0x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds1x = round(totbeds*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds3x = totbeds - beds0x - beds1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;				   
			   
/** 0/1/4 **/

replace beds0x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds1x = round(totbeds*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds4x = totbeds - beds0x - beds1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;	
			   
/** 0/2/4 **/

replace beds0x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds2x = round(totbeds*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds4x = totbeds - beds0x - beds2x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
			   
/** 0/3/4 **/

replace beds0x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds3x = round(totbeds*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds4x = totbeds - beds0x - beds3x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** 1/2/3 **/

replace beds1x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds2x = round(totbeds*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds3x = totbeds - beds1x - beds2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** 1/2/4 **/

replace beds1x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds2x = round(totbeds*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds4x = totbeds - beds1x - beds2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
			   
/** 1/3/4 **/

replace beds1x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds3x = round(totbeds*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds4x = totbeds - beds1x - beds3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;	
			   
/** 2/3/4 **/

replace beds2x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds3x = round(totbeds*0.30, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds4x = totbeds - beds2x - beds3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** 0/2/3 **/			   
			   
replace beds0x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;	
replace beds2x = round(totbeds*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;				   
replace beds3x = totbedx - beds0x - beds2x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** 0/1/2/3 **/

replace beds0x = round(totbeds*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds1x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds2x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds3x = totbeds - beds0x - beds1x - beds2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;	
			   
/** 0/1/2/4 **/

replace beds0x = round(totbeds*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds1x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds2x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds4x = totbeds - beds0x - beds1x - beds2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** 0/1/3/4 **/

replace beds0x = round(totbeds*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds1x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds3x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds4x = totbeds - beds0x - beds1x - beds3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** 0/2/3/4 **/

replace beds0x = round(totbeds*0.15, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds2x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds3x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds4x = totbeds - beds0x - beds2x - beds3x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** 1/2/3/4 **/			   

replace beds1x = round(totbeds*0.15, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds2x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
replace beds3x = round(totbeds*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds4x = totbeds - beds1x - beds2x - beds3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** 0/1/2/3/4 **/

replace beds0x = round(totbeds*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;		   
replace beds1x = round(totbeds*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds2x = round(totbeds*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds3x = round(totbeds*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;			   
replace beds4x = totbeds - beds0x - beds1x - beds2x - beds3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbeds ~= . & totbeds ~= 0;
			   
/** renttype == "Unit" -> estimate only unit counts, by nddq **/

/** Only 0, 1, 2, 3 or 4 **/

replace units0x = totunits if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units1x = totunits if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units2x = totunits if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units3x = totunits if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units4x = totunits if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
			   
/** Two slots **/			   
			   
/** 0/1 **/

replace units0x = round(totunits*0.40, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units1x = totunits - units0x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
			   
/** 0/2 **/

replace units0x = round(totunits*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units2x = totunits - units0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;

/** 0/3 **/

replace units0x = round(totunits*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units3x = totunits - units0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;

/** 0/4 **/

replace units0x = round(totunits*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units4x = totunits - units0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;

/** 1/2 **/

replace units1x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units2x = totunits - units1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;

/** 1/3 **/

replace units1x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units3x = totunits - units1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;

/** 1/4 **/

replace units1x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units4x = totunits - units1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;

/** 2/3 **/

replace units2x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units3x = totunits - units2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;

/** 2/4 **/

replace units2x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units4x = totunits - units2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;

/** 3/4 **/

replace units3x = round(totunits*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units4x = totunits - units3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   

/** 0/1/2 **/

replace units0x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units1x = round(totunits*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units2x = totunits - units0x - units1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;	
			   
/** 0/1/3 **/

replace units0x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units1x = round(totunits*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units3x = totunits - units0x - units1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;				   
			   
/** 0/1/4 **/

replace units0x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units1x = round(totunits*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units4x = totunits - units0x - units1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;	
			   
/** 0/2/4 **/

replace units0x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units2x = round(totunits*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units4x = totunits - units0x - units2x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
			   
/** 0/3/4 **/

replace units0x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units3x = round(totunits*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units4x = totunits - units0x - units3x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
			   
/** 1/2/3 **/

replace units1x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units2x = round(totunits*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units3x = totunits - units1x - units2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
			   
/** 1/2/4 **/

replace units1x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units2x = round(totunits*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units4x = totunits - units1x - units2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
			   
/** 1/3/4 **/

replace units1x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units3x = round(totunits*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units4x = totunits - units1x - units3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;	
			   
/** 2/3/4 **/

replace units2x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units3x = round(totunits*0.30, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units4x = totunits - units2x - units3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
			   
/** 0/2/3 **/			   
			   
replace units0x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;	
replace units2x = round(totunits*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;				   
replace units3x = totunits - units0x - units2x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
			   
/** 0/1/2/3 **/

replace units0x = round(totunits*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units1x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units2x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units3x = totunits - units0x - units1x - units2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;	
			   
/** 0/1/2/4 **/

replace units0x = round(totunits*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units1x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units2x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units4x = totunits - units0x - units1x - units2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
			   
/** 0/1/3/4 **/

replace units0x = round(totunits*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units1x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units3x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units4x = totunits - units0x - units1x - units3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
			   
/** 0/2/3/4 **/

replace units0x = round(totunits*0.15, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units2x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units3x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units4x = totunits - units0x - units2x - units3x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
			   
/** 1/2/3/4 **/			   

replace units1x = round(totunits*0.15, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units2x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
replace units3x = round(totunits*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units4x = totunits - units1x - units2x - units3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
			   
/** 0/1/2/3/4 **/

replace units0x = round(totunits*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;		   
replace units1x = round(totunits*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units2x = round(totunits*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units3x = round(totunits*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;			   
replace units4x = totunits - units0x - units1x - units2x - units3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunits ~= . & totunits ~= 0;
			   
/** Now, estimate totbedx and totunitx, by renttype, and estimate unit mix **/

xi: reg totbedx i.unicode i.renttype;
predict bed1, xb;
xi: reg totbedx i.renttype i.state;
predict bed2, xb;
xi: reg totbedx i.state;
predict bed3, xb;
			   
gen unif1 = uniform();
gen unif90 = unif1*(1.10 - 0.90) + 0.90;

replace bed1 = . if bed1 < 0;
replace bed2 = . if bed2 < 0;
replace bed3 = . if bed3 < 0;

gen estbed1 = bed1*0.30 + bed2*0.30 + bed3*0.40 if bed1 ~= . & bed2 ~= . & bed3 ~= .;
gen estbed2 = bed1*0.50 + bed3*0.50 if bed1 ~= . & bed2 == . & bed3 ~= .;
gen estbed3 = bed2*0.50 + bed3*0.50 if bed1 == . & bed2 ~= . & bed3 ~= .;

bysort state: egen stateavg = mean(estbed3);
sort id;
egen natavg = mean(estbed3);			

replace totbedx = round(estbed1*unif90, 1) if totbedx == . & totbedxM == 1 & renttype == "Bed"; 

/** Begin pooling for missing values **/

bysort unicode: egen bedpool1 = mean(totbedx);
bysort state: egen bedpool2 = mean(totbedx);
sort id;
egen bedpool3 = mean(totbedx);

replace totbedx = bedpool1*unif90 if totbedx == . & totbedxM == 1 & renttype == "Bed";
replace totbedx = bedpool2*unif90 if totbedx == . & totbedxM == 1 & renttype == "Bed"; 
replace totbedx = (bedpool2*0.5 + bedpool3*0.5)*unif90 if totbedx == . & totbedxM == 1;
replace totbedx = bedpool3*unif90 if totbedx == . & totbedxM == 1;
replace totbedx = round(totbedx, 1);

xi: reg totunitx totbedx i.unicode i.renttype;
predict unit1, xb;
xi: reg totunitx i.renttype i.state;
predict unit2, xb;
xi: reg totunitx i.state;
predict unit3, xb;

replace unit1 = . if unit1 < 0;
replace unit2 = . if unit2 < 0;
replace unit3 = . if unit3 < 0;

gen estun1 = unit1*0.30 + unit2*0.30 + unit3*0.40 if unit1 ~= . & unit2 ~= . & unit3 ~= .;
gen estun2 = unit1*0.50 + unit3*0.50 if unit1 ~= . & unit2 == . & unit3 ~= .;
gen estun3 = unit2*0.50 + unit3*0.50 if unit1 == . & unit2 ~= . & unit3 ~= .;

replace totunitx = round(estun1*unif90, 1) if totunitx == . & totunitxM == 1 & renttype == "Unit";

bysort unicode: egen unitpool1 = mean(totunitx);
bysort state: egen unitpool2 = mean(totunitx);
egen unitpool3 = mean(totunitx);

sort id;
replace totunitx = unitpool1*unif90 if totunitx == . & totunitxM == 1 & renttype == "Unit";
replace totunitx = (unitpool2*0.5 + unitpool3*0.5)*unif90 if totunitx == . & totunitxM == 1;
replace totunitx = unitpool3*unif90 if totunitx == . & totunitxM == 1;
replace totunitx = round(totunitx, 1);

/** Resolve nddq* = "No" - case P11877 where nddq* = all No, but still estimating breakouts **/

replace beds0x = 0 if beds0xM == 1 & nddq0 == "No" & beds0x ~= 0;
replace beds1x = 0 if beds1xM == 1 & nddq1 == "No" & beds1x ~= 0;
replace beds2x = 0 if beds2xM == 1 & nddq2 == "No" & beds2x ~= 0;
replace beds3x = 0 if beds3xM == 1 & nddq3 == "No" & beds3x ~= 0;
replace beds4x = 0 if beds4xM == 1 & nddq4 == "No" & beds4x ~= 0;

replace units0x = 0 if units0xM == 1 & nddq0 == "No" & units0x ~= 0;
replace units1x = 0 if units1xM == 1 & nddq1 == "No" & units1x ~= 0;
replace units2x = 0 if units2xM == 1 & nddq2 == "No" & units2x ~= 0;
replace units3x = 0 if units3xM == 1 & nddq3 == "No" & units3x ~= 0;
replace units4x = 0 if units4xM == 1 & nddq4 == "No" & units4x ~= 0;

/** These are PRELIMINARY regressions - now estimate unit mix and totals ACROSS Beds and Units SIMULTANEOUSLY, conforming to internal logic **/

gen bedchk1 = beds0x + beds1x + beds2x + beds3x + beds4x;
gen unchk1 = units0x + units1x + units2x + units3x + units4x;

/** The strange, sad case of P7242 - with a single piece of partial info for 2BR units, but NO totunitx, NO totbedx **/

replace totunitx = unchk1 if totunitxM == 1 & unchk1 > totunitx & renttype == "Unit";
replace beds0x = units0x if units0xM == 0 & beds0xM == 1 & nddq0 == "Yes";
replace beds1x = units1x if units1xM == 0 & beds1xM == 1 & nddq1 == "Yes";
replace beds2x = units2x*2 if units2xM == 0 & beds2xM == 1 & nddq2 == "Yes";
replace beds3x = units3x*3 if units3xM == 0 & beds3xM == 1 & nddq3 == "Yes";
replace beds4x = units4x*4 if units4xM == 0 & beds4xM == 1 & nddq4 == "Yes";

drop bedchk1 unchk1;

gen bedchk1 = beds0x + beds1x + beds2x + beds3x + beds4x;
gen unchk1 = units0x + units1x + units2x + units3x + units4x;

replace totbedx = bedchk1 if totbedxM == 1 & bedchk1 > totbedx;

/** The reverse case of P7242, where there is partial info for BEDS, but not for UNITS, and no totunitx/totbedx **/

replace units0x = beds0x if beds0xM == 0 & units0xM == 1 & nddq0 == "Yes";
replace units1x = beds1x if beds1xM == 0 & units1xM == 1 & nddq1 == "Yes";
replace units2x = round(beds0x/2, 1) if beds2xM == 0 & units2xM == 1 & nddq2 == "Yes";
replace units3x = round(beds3x/3, 1) if beds3xM == 0 & units3xM == 1 & nddq3 == "Yes";
replace units4x = round(beds4x/4, 1) if beds4xM == 0 & units4xM == 1 & nddq4 == "Yes";

drop bedchk1 unchk1;

gen bedchk1 = beds0x + beds1x + beds2x + beds3x + beds4x;
gen unchk1 = units0x + units1x + units2x + units3x + units4x;

replace totunitx = unchk1 if totunitxM == 1 & unchk1 > totunitx;

/** Final check for P7242 f*d up cases **/

gen unxMtest = units0xM + units1xM + units2xM + units3xM + units4xM;
gen bedxMtest = beds0xM + beds1xM + beds2xM + beds3xM + beds4xM;

replace totbedx = bedchk1 if totbedxM == 1 & (unxMtest ~= 5 | bedxMtest ~= 5);
replace totunitx = unchk1 if totunitxM == 1 & (unxMtest ~= 5 | bedxMtest ~= 5);

/** Apply same NDDQ estimation, this time for totbedxM = 1 / renttype = "Bed" and totunitxM = 1 / renttype = "Unit" **/

/** Only 0, 1, 2, 3 or 4 **/

replace beds0x = totbedx if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds1x = totbedx if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds2x = totbedx if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds3x = totbedx if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds4x = totbedx if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** Two slots **/			   
			   
/** 0/1 **/

replace beds0x = round(totbedx*0.40, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds1x = totbedx - beds0x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** 0/2 **/

replace beds0x = round(totbedx*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds2x = totbedx - beds0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;

/** 0/3 **/

replace beds0x = round(totbedx*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds3x = totbedx - beds0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;

/** 0/4 **/

replace beds0x = round(totbedx*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds4x = totbedx - beds0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;

/** 1/2 **/

replace beds1x = round(totbedx*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds2x = totbedx - beds1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;

/** 1/3 **/

replace beds1x = round(totbedx*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds3x = totbedx - beds1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;

/** 1/4 **/

replace beds1x = round(totbedx*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds4x = totbedx - beds1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;

/** 2/3 **/

replace beds2x = round(totbedx*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds3x = totbedx - beds2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;

/** 2/4 **/

replace beds2x = round(totbedx*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds4x = totbedx - beds2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;

/** 3/4 **/

replace beds3x = round(totbedx*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds4x = totbedx - beds3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   

/** 0/1/2 **/

replace beds0x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds1x = round(totbedx*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds2x = totbedx - beds0x - beds1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;	
			   
/** 0/1/3 **/

replace beds0x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds1x = round(totbedx*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds3x = totbedx - beds0x - beds1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;				   
			   
/** 0/1/4 **/

replace beds0x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds1x = round(totbedx*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds4x = totbedx - beds0x - beds1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** 0/2/4 **/

replace beds0x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds2x = round(totbedx*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds4x = totbedx - beds0x - beds2x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;	
			   
/** 0/3/4 **/

replace beds0x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds3x = round(totbedx*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds4x = totbedx - beds0x - beds3x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
			   
/** 1/2/3 **/

replace beds1x = round(totbedx*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds2x = round(totbedx*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds3x = totbedx - beds1x - beds2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** 1/2/4 **/

replace beds1x = round(totbedx*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds2x = round(totbedx*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds4x = totbedx - beds1x - beds2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
			   
/** 1/3/4 **/

replace beds1x = round(totbedx*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds3x = round(totbedx*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds4x = totbedx - beds1x - beds3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;	
			   
/** 2/3/4 **/

replace beds2x = round(totbedx*0.20, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds3x = round(totbedx*0.30, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds4x = totbedx - beds2x - beds3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** 0/2/3 **/			   
			   
replace beds0x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;	
replace beds2x = round(totbedx*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;				   
replace beds3x = totbedx - beds0x - beds2x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** 0/1/2/3 **/

replace beds0x = round(totbedx*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds1x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds2x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds3x = totbedx - beds0x - beds1x - beds2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;	
			   
/** 0/1/2/4 **/

replace beds0x = round(totbedx*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds1x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds2x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds4x = totbedx - beds0x - beds1x - beds2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** 0/1/3/4 **/

replace beds0x = round(totbedx*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds1x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds3x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds4x = totbedx - beds0x - beds1x - beds3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** 0/2/3/4 **/

replace beds0x = round(totbedx*0.15, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds2x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds3x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds4x = totbedx - beds0x - beds2x - beds3x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** 1/2/3/4 **/			   

replace beds1x = round(totbedx*0.15, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds2x = round(totbedx*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
replace beds3x = round(totbedx*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds4x = totbedx - beds1x - beds2x - beds3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** 0/1/2/3/4 **/

replace beds0x = round(totbedx*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;		   
replace beds1x = round(totbedx*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds2x = round(totbedx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds3x = round(totbedx*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;			   
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1& bedchk1 ~= totbedx & totbedxM == 1;
			   
/** renttype == "Unit" -> estimate only unit counts, by nddq **/

/** Only 0, 1, 2, 3 or 4 **/

replace units0x = totunitx if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units1x = totunitx if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units2x = totunitx if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units3x = totunitx if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units4x = totunitx if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
			   
/** Two slots **/			   
			   
/** 0/1 **/

replace units0x = round(totunitx*0.40, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units1x = totunitx - units0x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
			   
/** 0/2 **/

replace units0x = round(totunitx*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units2x = totunitx - units0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;

/** 0/3 **/

replace units0x = round(totunitx*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units3x = totunitx - units0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;

/** 0/4 **/

replace units0x = round(totunitx*0.40, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units4x = totunitx - units0x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;

/** 1/2 **/

replace units1x = round(totunitx*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units2x = totunitx - units1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;

/** 1/3 **/

replace units1x = round(totunitx*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units3x = totunitx - units1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;

/** 1/4 **/

replace units1x = round(totunitx*0.40, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units4x = totunitx - units1x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;

/** 2/3 **/

replace units2x = round(totunitx*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units3x = totunitx - units2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;

/** 2/4 **/

replace units2x = round(totunitx*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units4x = totunitx - units2x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;

/** 3/4 **/

replace units3x = round(totunitx*0.40, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units4x = totunitx - units3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   

/** 0/1/2 **/

replace units0x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units1x = round(totunitx*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units2x = totunitx - units0x - units1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;	
			   
/** 0/1/3 **/

replace units0x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units1x = round(totunitx*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units3x = totunitx - units0x - units1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;				   
			   
/** 0/1/4 **/

replace units0x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units1x = round(totunitx*0.30, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units4x = totunitx - units0x - units1x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;	
			   
/** 0/2/4 **/

replace units0x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units2x = round(totunitx*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units4x = totunitx - units0x - units2x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;	
			   
/** 0/3/4 **/

replace units0x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units3x = round(totunitx*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units4x = totunitx - units0x - units3x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
			   
/** 1/2/3 **/

replace units1x = round(totunitx*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units2x = round(totunitx*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units3x = totunitx - units1x - units2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
			   
/** 1/2/4 **/

replace units1x = round(totunitx*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units2x = round(totunitx*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units4x = totunitx - units1x - units2x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
			   
/** 1/3/4 **/

replace units1x = round(totunitx*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units3x = round(totunitx*0.30, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units4x = totunitx - units1x - units3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;	
			   
/** 2/3/4 **/

replace units2x = round(totunitx*0.20, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units3x = round(totunitx*0.30, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units4x = totunitx - units2x - units3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
			   
/** 0/2/3 **/			   
			   
replace units0x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;	
replace units2x = round(totunitx*0.30, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;				   
replace units3x = totbedx - units0x - units2x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
			   
/** 0/1/2/3 **/

replace units0x = round(totunitx*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units1x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units2x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units3x = totunitx - units0x - units1x - units2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;	
			   
/** 0/1/2/4 **/

replace units0x = round(totunitx*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units1x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units2x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units4x = totunitx - units0x - units1x - units2x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
			   
/** 0/1/3/4 **/

replace units0x = round(totunitx*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units1x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units3x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units4x = totunitx - units0x - units1x - units3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
			   
/** 0/2/3/4 **/

replace units0x = round(totunitx*0.15, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units2x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units3x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units4x = totunitx - units0x - units2x - units3x if nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
			   
/** 1/2/3/4 **/			   

replace units1x = round(totunitx*0.15, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units2x = round(totunitx*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
replace units3x = round(totunitx*0.20, 1) if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units4x = totunitx - units1x - units2x - units3x if nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;
			   
/** 0/1/2/3/4 **/

replace units0x = round(totunitx*0.15, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;		   
replace units1x = round(totunitx*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units2x = round(totunitx*0.20, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units3x = round(totunitx*0.25, 1) if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;			   
replace units4x = totunitx - units0x - units1x - units2x - units3x if nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" & 
               units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1& unchk1 ~= totunitx & totunitxM == 1;		   
			   
/** Cases where nddq* are indicative, but there are one or more surveys for unit types that need to be made consistent with a given/surveyed total (ex: P1574 in unicode UPA) **/

replace beds0x = 0 if beds0x == . & beds0xM == 1;
replace beds1x = 0 if beds1x == . & beds1xM == 1;
replace beds2x = 0 if beds2x == . & beds2xM == 1;
replace beds3x = 0 if beds3x == . & beds3xM == 1;
replace beds4x = 0 if beds4x == . & beds4xM == 1;

replace units0x = 0 if units0x == . & units0xM == 1;
replace units1x = 0 if units1x == . & units1xM == 1;
replace units2x = 0 if units2x == . & units2xM == 1;
replace units3x = 0 if units3x == . & units3xM == 1;
replace units4x = 0 if units4x == . & units4xM == 1;

gen bedtest0 = beds0x + beds1x + beds2x + beds3x + beds4x;
gen bdiff = totbedx - bedtest0;
gen untest0 = units0x + units1x + units2x + units3x + units4x;
gen udiff = totunitx - untest0;

/** Only in 0, 1, 2, 3 or 4, by Renttype and inconsistencies with given totals **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest0 ~= totbedx & bdiff > 0;				 

replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" & 
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" & 
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" & 
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest0 ~= totunitx & udiff > 0;	

/** 0/1, two cases **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;

/** 0/2 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;

/** 0/3 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;


/** 0/4 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest0 ~= totbedx & bdiff > 0;
replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest0 ~= totunitx & udiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;				 

/** 1/2 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest0 ~= totbedx & bdiff > 0;
replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest0 ~= totunitx & udiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;				 
				 

/** 1/3 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;					 

/** 1/4 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest0 ~= totbedx & bdiff > 0;
replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest0 ~= totunitx & udiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;				 

/** 2/3 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;				 

/** 2/4 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest0 ~= totbedx & bdiff > 0;
replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest0 ~= totunitx & udiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;				 

/** 3/4 **/		

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest0 ~= totbedx & bdiff > 0;
replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest0 ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest0 ~= totunitx & udiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest0 ~= totunitx & udiff > 0;
				 
/** THREE combinations, F*CK.  Can be 1/0/0, 0/1/0, 0/0/1, 1/1/0, 1/0/1, 0/1/1 **/

/** nddq 0/1/2 **/

/** 1/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 0/1/0 **/				 
				 
replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
				 
/** 0/0/1 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
				 
/** 1/1/0 **/

replace beds0x = beds0x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds1x = totbedx - beds0x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;					 
replace units0x = units0x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units1x = totunitx - units0x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
				 
/** 1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds2x = totbedx - beds0x - beds1x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;					 
replace units0x = units0x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units2x = totunitx - units0x - units1x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
				 
/** 0/1/1 **/

replace beds1x = beds1x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds2x = totbedx - beds0x - beds1x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;				 
replace units1x = units1x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units2x = totunitx - units0x - units1x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 
				 
/** nddq 0/1/3.  Can be 1/0/0, 0/1/0, 0/0/1, 1/1/0, 1/0/1, 0/1/1 **/

/** 1/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & bedtest ~= totunitx & udiff > 0;
				 
/** 0/1/0 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & bedtest ~= totunitx & udiff > 0;

/** 0/0/1 **/			

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & bedtest ~= totunitx & udiff > 0;	 

/** 1/1/0 **/

replace beds0x = beds0x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = totbedx - beds0x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units1x = totunitx - units0x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds1x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units1x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1 **/

replace beds1x = beds1x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds1x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;				 
replace units1x = units1x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units1x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 
				 
/** nddq 0/1/4.  Can be 1/0/0, 0/1/0, 0/0/1, 1/1/0, 1/0/1, 0/1/1 **/

/** 1/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
				 
/** 0/1/0 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/1 **/

replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0 **/

replace beds0x = beds0x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = totbedx - beds0x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units1x = totunitx - units0x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;					 

/** 1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	

/** 0/1/1 **/

replace beds1x = beds1x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units1x = units1x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	

/** nddq 0/2/3.  Can be 1/0/0, 0/1/0, 0/0/1, 1/1/0, 1/0/1, 0/1/1 **/

/** 1/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
				 
/** 0/1/0 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 0/0/1 **/

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0 **/

replace beds0x = beds0x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = totbedx - beds0x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units1x = totunitx - units0x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;	


/** 1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 0/1/1 **/

replace beds2x = beds2x + round(bdiff*0.50, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units2x = units2x + round(udiff*0.50, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** nddq 0/2/4.  Can be 1/0/0, 0/1/0, 0/0/1, 1/1/0, 1/0/1, 0/1/1 **/

/** 1/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/1 **/

replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds4xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units4x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0 **/

replace beds0x = beds0x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds4xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = totunitx - beds0x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds4xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units4xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = totunitx - units0x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units4xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;					 

/** 1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds4xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totunitx - beds0x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds4xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units4xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units4xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 

/** 0/1/1 **/

replace beds2x = beds2x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds4xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totunitx - beds0x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds4xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units2x = units2x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units4xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units4xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 

/** nddq 0/3/4.  Can be 1/0/0, 0/1/0, 0/0/1, 1/1/0, 1/0/1, 0/1/1 **/

/** 1/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0 **/

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/1 **/

replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0 **/

replace beds0x = beds0x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totunitx - beds0x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;				 
replace units0x = units0x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totunitx - beds0x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1 **/

replace beds3x = beds3x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totunitx - beds0x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** nddq 1/2/3.  Can be 1/0/0, 0/1/0, 0/0/1, 1/1/0, 1/0/1, 0/1/1 **/

/** 1/0/0 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 0/0/1 **/

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0 **/

replace beds1x = beds1x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = totbedx - beds1x - beds3x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units1x = units1x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = totunitx - units1x - units3x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 

/** 1/0/1 **/

replace beds1x = beds1x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds1x - beds2x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units1x - units2x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1 **/

replace beds2x = beds2x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds1x - beds2x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units1x - units2x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** nddq 1/2/4.  Can be 1/0/0, 0/1/0, 0/0/1, 1/1/0, 1/0/1, 0/1/1 **/

/** 1/0/0 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/1 **/

replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0 **/

replace beds1x = beds1x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = totbedx - beds1x - beds4x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;		
replace units1x = units1x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = totunitx - units1x - units4x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;					 

/** 1/0/1 **/

replace beds1x = beds1x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds1x - beds2x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units1x = units1x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units1x - units2x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1 **/

replace beds2x = beds2x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds1x - beds2x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units1x - units2x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 

/** nddq 2/3/4.  Can be 1/0/0, 0/1/0, 0/0/1, 1/1/0, 1/0/1, 0/1/1 **/

/** 1/0/0 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0 **/

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/1 **/

replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0 **/

replace beds2x = beds2x + round(bdiff*0.48, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds2x - beds4x if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units2x = units2x + round(udiff*0.48, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units2x - units4x if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;					 

/** 1/0/1 **/

replace beds2x = beds2x + round(bdiff*0.48, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds2x - beds3x if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + round(udiff*0.48, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units2x - units3x if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1 **/

replace beds3x = beds3x + round(bdiff*0.48, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds2x - beds3x if renttype == "Bed" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + round(udiff*0.48, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units2x - units3x if renttype == "Unit" & nddq0 == "No" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
				 
/** FOUR slots, five cases, 13 iterations each **/

/** Slots 0/1/2/3 **/

/** 1/0/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;		 

/** 0/1/0/0 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 0/0/1/0 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 0/0/0/1 **/

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0/0 **/

replace beds0x = beds0x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = totbedx - beds0x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units1x = totunitx - units0x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1/0 **/

replace beds0x = beds0x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = totbedx - beds0x - beds1x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = totunitx - units0x - units1x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/0/0/1 **/

replace beds0x = beds0x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 
				 
/** 0/1/0/1 **/

replace beds1x = beds1x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units1x = units1x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 
				 
/** 0/0/1/1 **/

replace beds2x = beds2x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units2x = units2x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 

/** 1/1/1/0 **/

replace beds0x = beds0x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds2x = totbedx - beds0x - beds1x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units2x = totunitx - units0x - units1x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 
				 
/** 1/1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds3x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units3x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1/1 **/

replace beds0x = beds0x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds3x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units3x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1/1 **/

replace beds1x = beds1x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds3x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units3x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "No" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** Slots 0/1/2/4 **/

/** 1/0/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0/0 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/1/0 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 10& units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/0/1 **/

replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0/0 **/

replace beds0x = beds0x + round(0.55*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = totbedx - beds0x - beds2x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;		
replace units0x = units0x + round(0.55*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units1x = totunitx - units0x - units2x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1/0 **/

replace beds0x = beds0x + round(0.55*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = totbedx - beds0x - beds1x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(0.55*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = totunitx - units0x - units1x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;					 

/** 1/0/0/1 **/

replace beds0x = beds0x + round(0.55*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(0.55*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0/1 **/

replace beds1x = beds1x + round(0.55*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(0.55*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/0/1/1 **/

replace beds2x = beds2x + round(0.55*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + round(0.55*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/1/1/0 **/

replace beds0x = beds0x + round(bdiff*0.17, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace beds2x = totbedx - beds0x - beds1x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.17, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;	
replace units2x = totunitx - units0x - units1x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;					 

/** 1/1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.17, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.17, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1/1 **/

replace beds0x = beds0x + round(bdiff*0.17, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.17, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1/1 **/

replace beds1x = beds1x + round(bdiff*0.17, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds1x - beds2x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.17, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units1x - units2x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "No" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** Slots 0/1/3/4 **/

/** 1/0/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 				 

/** 0/1/0/0 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;	

/** 0/0/1/0 **/

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/0/1 **/

replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 1/1/0/0 **/

replace beds0x = beds0x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = totbedx - beds0x - beds3x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units1x = totunitx - units0x - units3x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1/0 **/

replace beds0x = beds0x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds1x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units1x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 1/0/0/1 **/

replace beds0x = beds0x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0/1 **/

replace beds1x = beds1x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/0/1/1 **/

replace beds3x = beds3x + round(bdiff*0.45, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + round(udiff*0.45, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/1/1/0 **/

replace beds0x = beds0x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;					 
replace beds3x = totbedx - beds0x - beds1x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;					 
replace units3x = totunitx - units0x - units1x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;					 

/** 1/1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;					 
replace beds4x = totbedx - beds0x - beds1x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 
replace units4x = totunitx - units0x - units1x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1/1 **/

replace beds0x = beds0x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds2x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;					 
replace beds4x = totbedx - beds0x - beds1x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 
replace units4x = totunitx - units0x - units1x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1/1 **/

replace beds1x = beds1x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;					 
replace beds4x = totbedx - beds0x - beds1x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 
replace units4x = totunitx - units0x - units1x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "No" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** Slots 0/2/3/4 **/

/** 1/0/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0/0 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/1/0 **/

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/0/1 **/

replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0/0 **/

replace beds0x = beds0x + round(0.58*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = totbedx - beds0x - beds3x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;				 
replace units0x = units0x + round(0.58*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = totunitx - units0x - units3x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;		
				 
/** 1/0/1/0 **/

replace beds0x = beds0x + round(0.58*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds2x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(0.58*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units2x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 1/0/0/1 **/

replace beds0x = beds0x + round(0.58*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(0.58*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0/1 **/

replace beds2x = beds2x + round(0.58*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + round(0.58*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/0/1/1 **/

replace beds3x = beds3x + round(0.58*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + round(0.58*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/1/1/0 **/

replace beds0x = beds0x + round(0.22*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(0.20*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace beds3x = totbedx - beds0x - beds2x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;		
replace units0x = units0x + round(0.22*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(0.20*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;	
replace units3x = totunitx - units0x - units2x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;						 

/** 1/1/0/1 **/

replace beds0x = beds0x + round(0.22*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(0.20*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(0.22*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(0.20*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1/1 **/

replace beds0x = beds0x + round(0.22*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(0.20*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(0.22*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(0.20*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1/1 **/

replace beds2x = beds2x + round(0.22*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(0.20*bdiff, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + round(0.22*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(0.20*udiff, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "No" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** Slots 1/2/3/4 **/	

/** 1/0/0/0 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0/0 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/1/0 **/

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/0/1 **/

replace beds4x = beds4x + bdiff if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units4x = units4x + udiff if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0/0 **/

replace beds1x = beds1x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = totbedx - beds1x - beds3x - beds4x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units1x = units1x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = totunitx - units1x - units3x - units4x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 	 

/** 1/0/1/0 **/

replace beds1x = beds1x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds1x - beds2x - beds4x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units1x - units2x - units4x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 1/0/0/1 **/

replace beds1x = beds1x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0/1 **/

replace beds2x = beds2x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/0/1/1 **/

replace beds3x = beds3x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/1/1/0 **/

replace beds1x = beds1x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.22, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	 
replace beds3x = totbedx - beds1x - beds2x - beds4x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;		
replace units1x = units1x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.22, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;	 
replace units3x = totunitx - units1x - units2x - units4x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;					 

/** 1/1/0/1 **/

replace beds1x = beds1x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.22, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	 
replace beds4x = totbedx - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units1x = units1x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.22, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;	 
replace units4x = totunitx - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 

/** 1/0/1/1 **/

replace beds1x = beds1x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(bdiff*0.22, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	 
replace beds4x = totbedx - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units1x = units1x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(udiff*0.22, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	 
replace units4x = totunitx - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1/1 **/		

replace beds2x = beds2x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(bdiff*0.22, 1) if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	 
replace beds4x = totbedx - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units2x = units2x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(udiff*0.22, 1) if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	 
replace units4x = totunitx - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "No" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
				 
/** The nddq* = "Yes" for all cases **/

/** 1/0/0/0/0 **/

replace beds0x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 		 

/** 0/1/0/0/0 **/

replace beds1x = beds1x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/1/0/0 **/

replace beds2x = beds2x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/0/1/0 **/

replace beds3x = beds3x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;

/** 0/0/0/0/1 **/

replace beds4x = beds0x + bdiff if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units4x = units0x + udiff if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;

/** 1/1/0/0/0 **/

replace beds0x = beds0x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = totbedx - beds0x - beds2x - beds3x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units1x = totunitx - units0x - units2x - units3x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1/0/0 **/

replace beds0x = beds0x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = totbedx - beds0x - beds1x - beds3x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = totunitx - units0x - units1x - units3x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 
				 
/** 1/0/0/1/0 **/

replace beds0x = beds0x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds1x - beds2x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units1x - units2x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 
				 
/** 1/0/0/0/1 **/

replace beds0x = beds0x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1/0/0 **/

replace beds1x = beds1x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = totbedx - beds0x - beds1x - beds3x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = totunitx - units0x - units1x - units3x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 
				 
/** 0/1/0/1/0 **/

replace beds1x = beds1x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds1x - beds2x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units1x - units2x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0/0/1 **/

replace beds1x = beds1x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/0/1/1/0 **/

replace beds2x = beds2x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = totbedx - beds0x - beds1x - beds2x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units3x = totunitx - units0x - units1x - units2x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 0/0/1/0/1 **/

replace beds2x = beds2x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/0/0/1/1 **/

replace beds3x = beds3x + round(bdiff*0.55, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units3x = units3x + round(udiff*0.55, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/1/1/0/0 **/

replace beds0x = beds0x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace beds2x = totbedx - beds0x - beds1x - beds3x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;	
replace units2x = totunitx - units0x - units1x - units3x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 0 & untest ~= totunitx & udiff > 0;					 

/** 1/1/0/1/0 **/

replace beds0x = beds0x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace beds3x = totbedx - beds0x - beds1x - beds2x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;	
replace units3x = totunitx - units0x - units1x - units2x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 1/1/0/0/1 **/

replace beds0x = beds0x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/0/0/1/1 **/

replace beds0x = beds0x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/0/1/1 **/

replace beds1x = beds1x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/0/1/1/1 **/

replace beds2x = beds2x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units2x = units2x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1/1/0 **/

replace beds1x = beds1x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace beds3x = totbedx - beds0x - beds1x - beds2x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;	
replace units3x = totunitx - units0x - units1x - units2x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1/0/1 **/

replace beds1x = beds1x + round(bdiff*0.25, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.20, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units1x = units1x + round(udiff*0.25, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.20, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;	
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/1/1/1/0 **/

replace beds0x = beds0x + round(bdiff*0.17, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.16, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;				 
replace beds3x = totbedx - beds0x - beds1x - beds2x - beds4x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 0 & bedtest ~= totbedx & bdiff > 0;	
replace units0x = units0x + round(udiff*0.17, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.16, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 
replace units3x = totunitx - units0x - units1x - units2x - units4x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 0 & untest ~= totunitx & udiff > 0;				 

/** 1/1/1/0/1 **/

replace beds0x = beds0x + round(bdiff*0.17, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.16, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;				 
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 0 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.17, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.16, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 0 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/1/0/1/1 **/

replace beds0x = beds0x + round(bdiff*0.17, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds1x = beds1x + round(bdiff*0.16, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;				 
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 0 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.17, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units1x = units1x + round(udiff*0.16, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 1 & units2xM == 0 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 1/0/1/1/1 **/

replace beds0x = beds0x + round(bdiff*0.17, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.16, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;				 
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 1 & beds1xM == 0 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace units0x = units0x + round(udiff*0.17, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.16, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 1 & units1xM == 0 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 

/** 0/1/1/1/1 **/	

replace beds1x = beds1x + round(bdiff*0.17, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds2x = beds2x + round(bdiff*0.16, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;
replace beds3x = beds3x + round(bdiff*0.15, 1) if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;				 
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if renttype == "Bed" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 beds0xM == 0 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & bedtest ~= totbedx & bdiff > 0;	
replace units1x = units1x + round(udiff*0.17, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units2x = units2x + round(udiff*0.16, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;
replace units3x = units3x + round(udiff*0.15, 1) if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;				 
replace units4x = totunitx - units0x - units1x - units2x - units3x if renttype == "Unit" & nddq0 == "Yes" & nddq1 == "Yes" & nddq2 == "Yes" & nddq3 == "Yes" & nddq4 == "Yes" &
                 units0xM == 0 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & untest ~= totunitx & udiff > 0;					 
				 
/** The nddq* = "No" for all cases issue - in the absence of any info, assume relatively uniform distribution **/

replace beds0x = round(totbedx*0.18, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1;
replace beds1x = round(totbedx*0.15, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1;	
replace beds2x = round(totbedx*0.22, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1;				 
replace beds3x = round(totbedx*0.14, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1;			 
replace beds4x = totbedx - beds0x - beds1x - beds2x - beds3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1;
				 
replace units0x = round(totunitx*0.18, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1;
replace units1x = round(totunitx*0.15, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1;	
replace units2x = round(totunitx*0.22, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1;				 
replace units3x = round(totunitx*0.14, 1) if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1;			 
replace units4x = totunitx - units0x - units1x - units2x - units3x if nddq0 == "No" & nddq1 == "No" & nddq2 == "No" & nddq3 == "No" & nddq4 == "No" & 
                 units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1;
				 
/** BUT, if we KNOW that properties are all ONLY in bigger units, we should null out unit mix estimates anyway **/

sort id;

joinby id using $prefix/central/km/std/std_onlybigger, unmatched(master);
drop _merge;

/** Resolve nddq* = "No" - case P11877 where nddq* = all No, but still estimating breakouts **/

replace beds0x = 0 if beds0xM == 1 & nddq0 == "No" & beds0x ~= 0 & onlybigger == 1;
replace beds1x = 0 if beds1xM == 1 & nddq1 == "No" & beds1x ~= 0 & onlybigger == 1;
replace beds2x = 0 if beds2xM == 1 & nddq2 == "No" & beds2x ~= 0 & onlybigger == 1;
replace beds3x = 0 if beds3xM == 1 & nddq3 == "No" & beds3x ~= 0 & onlybigger == 1;
replace beds4x = 0 if beds4xM == 1 & nddq4 == "No" & beds4x ~= 0 & onlybigger == 1;

replace units0x = 0 if units0xM == 1 & nddq0 == "No" & units0x ~= 0 & onlybigger == 1;
replace units1x = 0 if units1xM == 1 & nddq1 == "No" & units1x ~= 0 & onlybigger == 1;
replace units2x = 0 if units2xM == 1 & nddq2 == "No" & units2x ~= 0 & onlybigger == 1;
replace units3x = 0 if units3xM == 1 & nddq3 == "No" & units3x ~= 0 & onlybigger == 1;
replace units4x = 0 if units4xM == 1 & nddq4 == "No" & units4x ~= 0 & onlybigger == 1;		 
				 
/** Primacy and consistency if totbedxM = 1 AND totunitxM = 1 **/

replace units0x = beds0x if renttype == "Bed" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1;
replace units1x = beds1x if renttype == "Bed" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1;
replace units2x = round(beds2x/2, 1) if renttype == "Bed" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1;
replace units3x = round(beds3x/3, 1) if renttype == "Bed" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1;
replace units4x = round(beds4x/4, 1) if renttype == "Bed" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1;
replace totunitx = units0x + units1x + units2x + units3x + units4x if renttype == "Bed" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1;

replace beds0x = units0x if renttype == "Unit" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1;
replace beds1x = units1x if renttype == "Unit" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1;
replace beds2x = units2x*2 if renttype == "Unit" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1;
replace beds3x = units3x*3 if renttype == "Unit" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1;
replace beds4x = units4x*4 if renttype == "Unit" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1;
replace totbedx = beds0x + beds1x + beds2x + beds3x + beds4x if renttype == "Unit" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1;	

/** Fascinating cases: ONE side internally consistent, totbedxM = 0 AND totunitxM = 0; P12263/P12264 **/

gen bedtester = beds0x + beds1x + beds2x + beds3x + beds4x;
gen untester = units0x + units1x + units2x + units3x + units4x;

replace units0x = beds0x if totbedx == bedtester & totbeds ~= . & totbedxM == 0 & totunits ~= . & totunitxM == 0 & untester ~= totunitx &
                  units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & renttype == "Unit";
replace units1x = beds1x if totbedx == bedtester & totbeds ~= . & totbedxM == 0 & totunits ~= . & totunitxM == 0 & untester ~= totunitx &
                  units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & renttype == "Unit";
replace units2x = round(beds2x/2, 1) if totbedx == bedtester & totbeds ~= . & totbedxM == 0 & totunits ~= . & totunitxM == 0 & untester ~= totunitx &
                  units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & renttype == "Unit";
replace units3x = round(beds3x/3, 1) if totbedx == bedtester & totbeds ~= . & totbedxM == 0 & totunits ~= . & totunitxM == 0 & untester ~= totunitx &
                  units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & renttype == "Unit";
replace units4x = round(beds4x/4, 1) if totbedx == bedtester & totbeds ~= . & totbedxM == 0 & totunits ~= . & totunitxM == 0 & untester ~= totunitx &
                  units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & renttype == "Unit";	
				  
replace beds0x = units0x if totunitx == untester & totunits ~= . & totunitxM == 0 & totbeds ~= . & totbedxM == 0 & bedtester ~= totbedx & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & renttype == "Bed";
replace beds1x = units1x if totunitx == untester & totunits ~= . & totunitxM == 0 & totbeds ~= . & totbedxM == 0 & bedtester ~= totbedx & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & renttype == "Bed";
replace beds2x = units2x*2 if totunitx == untester & totunits ~= . & totunitxM == 0 & totbeds ~= . & totbedxM == 0 & bedtester ~= totbedx & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & renttype == "Bed";
replace beds3x = units3x*3 if totunitx == untester & totunits ~= . & totunitxM == 0 & totbeds ~= . & totbedxM == 0 & bedtester ~= totbedx & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & renttype == "Bed";
replace beds4x = units4x*4 if totunitx == untester & totunits ~= . & totunitxM == 0 & totbeds ~= . & totbedxM == 0 & bedtester ~= totbedx & 
                 beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & renttype == "Bed";				 				 

/** Simplifying assumptions if renttype == "" **/

replace units0x = beds0x if renttype == "" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1 & totbedxM == 0;
replace units1x = beds1x if renttype == "" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1 & totbedxM == 0;
replace units2x = round(beds2x/2, 1) if renttype == "" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1 & totbedxM == 0;
replace units3x = round(beds3x/3, 1) if renttype == "" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1 & totbedxM == 0;
replace units4x = round(beds4x/4, 1) if renttype == "" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1 & totbedxM == 0;
replace totunitx = units0x + units1x + units2x + units3x + units4x if renttype == "" & units0xM == 1 & units1xM == 1 & units2xM == 1 & units3xM == 1 & units4xM == 1 & totunitxM == 1 & totbedxM == 0;	

replace beds0x = units0x if renttype == "" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1 & totunitxM == 0;
replace beds1x = units1x if renttype == "" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1 & totunitxM == 0;
replace beds2x = units2x*2 if renttype == "" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1 & totunitxM == 0;
replace beds3x = units3x*3 if renttype == "" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1 & totunitxM == 0;
replace beds4x = units4x*4 if renttype == "" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1 & totunitxM == 0;
replace totbedx = beds0x + beds1x + beds2x + beds3x + beds4x if renttype == "" & beds0xM == 1 & beds1xM == 1 & beds2xM == 1 & beds3xM == 1 & beds4xM == 1 & totbedxM == 1 & totunitxM == 0;	   

drop bedtester untester;

gen bedtester = beds0x + beds1x + beds2x + beds3x + beds4x;
gen untester = units0x + units1x + units2x + units3x + units4x;
	
order unicode metcode id bldgx bldgxM flrsx flrsxM totbeds totbedx totbedxM beds0x beds0xM beds1x beds1xM beds2x beds2xM beds3x beds3xM 
      beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM units4x units4xM;

/** Begin estimating bed/unit sizes **/

gen bed0sizex = .;
gen bed1sizex = .;
gen bed2sizex = .;
gen bed3sizex = .;
gen bed4sizex = .;

gen bed0sizexM = 1;
gen bed1sizexM = 1;
gen bed2sizexM = 1;
gen bed3sizexM = 1;
gen bed4sizexM = 1;

gen un0sizex = .;
gen un1sizex = .;
gen un2sizex = .;
gen un3sizex = .;
gen un4sizex = .;

gen un0sizexM = 1;
gen un1sizexM = 1;
gen un2sizexM = 1;
gen un3sizexM = 1;
gen un4sizexM = 1;

order unicode metcode id bldgx bldgxM flrsx flrsxM totbeds totbedx totbedxM beds0x beds0xM beds1x beds1xM beds2x beds2xM beds3x beds3xM 
      beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM units4x units4xM
	  bed0sizex bed0sizexM bed1sizex bed1sizexM bed2sizex bed2sizexM bed3sizex bed3sizexM bed4sizex bed4sizexM un0sizex un0sizexM un1sizex un1sizexM
	  un2sizex un2sizexM un3sizex un3sizexM un4sizex un4sizexM;
	  
replace bed0sizex = brbed_avgsf0 if brbed_avgsf0 ~= . & brbed_avgsf0 > 0;
replace bed1sizex = brbed_avgsf1 if brbed_avgsf1 ~= . & brbed_avgsf1 > 0;
replace bed2sizex = brbed_avgsf2 if brbed_avgsf2 ~= . & brbed_avgsf2 > 0;
replace bed3sizex = brbed_avgsf3 if brbed_avgsf3 ~= . & brbed_avgsf3 > 0;
replace bed4sizex = brbed_avgsf4 if brbed_avgsf4 ~= . & brbed_avgsf4 > 0;

replace bed0sizexM = 0 if brbed_avgsf0 ~= . & brbed_avgsf0 > 0;
replace bed1sizexM = 0 if brbed_avgsf1 ~= . & brbed_avgsf1 > 0;
replace bed2sizexM = 0 if brbed_avgsf2 ~= . & brbed_avgsf2 > 0;
replace bed3sizexM = 0 if brbed_avgsf3 ~= . & brbed_avgsf3 > 0;
replace bed4sizexM = 0 if brbed_avgsf4 ~= . & brbed_avgsf4 > 0;

replace un0sizex = brunit_avgsf0 if brunit_avgsf0 ~= . & brunit_avgsf0 > 0;
replace un1sizex = brunit_avgsf1 if brunit_avgsf1 ~= . & brunit_avgsf1 > 0;
replace un2sizex = brunit_avgsf2 if brunit_avgsf2 ~= . & brunit_avgsf2 > 0;
replace un3sizex = brunit_avgsf3 if brunit_avgsf3 ~= . & brunit_avgsf3 > 0;
replace un4sizex = brunit_avgsf4 if brunit_avgsf4 ~= . & brunit_avgsf4 > 0;

replace un0sizexM = 0 if brunit_avgsf0 ~= . & brunit_avgsf0 > 0;
replace un1sizexM = 0 if brunit_avgsf1 ~= . & brunit_avgsf1 > 0;
replace un2sizexM = 0 if brunit_avgsf2 ~= . & brunit_avgsf2 > 0;
replace un3sizexM = 0 if brunit_avgsf3 ~= . & brunit_avgsf3 > 0;
replace un4sizexM = 0 if brunit_avgsf4 ~= . & brunit_avgsf4 > 0;

/** By primacy of surveyed values, "rationalize" sizes and avoid internal inconsistencies **/

replace bed0sizex = un0sizex if bed0sizexM == 1 & un0sizexM == 0;
replace bed1sizex = un1sizex if bed1sizexM == 1 & un1sizexM == 0;
replace bed2sizex = un2sizex/2 if bed2sizexM == 1 & un2sizexM == 0;
replace bed3sizex = un3sizex/3 if bed3sizexM == 1 & un3sizexM == 0;
replace bed4sizex = un4sizex/4 if bed4sizexM == 1 & un4sizexM == 0;

replace un0sizex = bed0sizex if un0sizexM == 1 & bed0sizexM == 0;
replace un1sizex = bed1sizex if un0sizexM == 1 & bed0sizexM == 0;
replace un2sizex = bed2sizex*2 if un0sizexM == 1 & bed0sizexM == 0;
replace un3sizex = bed3sizex*3 if un0sizexM == 1 & bed0sizexM == 0;
replace un4sizex = bed4sizex*4 if un0sizexM == 1 & bed0sizexM == 0;
	  
/** Very sparse structural info here; need to pool and randomize **/

bysort unicode: egen bs0u = mean(bed0sizex);
bysort unicode: egen bs1u = mean(bed1sizex);
bysort unicode: egen bs2u = mean(bed2sizex);
bysort unicode: egen bs3u = mean(bed3sizex);
bysort unicode: egen bs4u = mean(bed4sizex);

bysort state: egen bs0s = mean(bed0sizex);
bysort state: egen bs1s = mean(bed1sizex);
bysort state: egen bs2s = mean(bed2sizex);
bysort state: egen bs3s = mean(bed3sizex);
bysort state: egen bs4s = mean(bed4sizex);

bysort r1to5: egen bs0r = mean(bed0sizex);
bysort r1to5: egen bs1r = mean(bed1sizex);
bysort r1to5: egen bs2r = mean(bed2sizex);
bysort r1to5: egen bs3r = mean(bed3sizex);
bysort r1to5: egen bs4r = mean(bed4sizex);

egen bs0n = mean(bed0sizex);
egen bs1n = mean(bed1sizex);
egen bs2n = mean(bed2sizex);
egen bs3n = mean(bed3sizex);
egen bs4n = mean(bed4sizex);

sort unicode metcode id;

gen bs0ref = bs0u;
gen bs1ref = bs1u;
gen bs2ref = bs2u;
gen bs3ref = bs3u;
gen bs4ref = bs4u;

replace bs0ref = bs0s if bs0ref == .;
replace bs1ref = bs1s if bs1ref == .;
replace bs2ref = bs2s if bs2ref == .;
replace bs3ref = bs3s if bs3ref == .;
replace bs4ref = bs4s if bs4ref == .;

replace bs0ref = bs0r if bs0ref == .;
replace bs1ref = bs1r if bs1ref == .;
replace bs2ref = bs2r if bs2ref == .;
replace bs3ref = bs3r if bs3ref == .;
replace bs4ref = bs4r if bs4ref == .;

replace bs0ref = bs0n if bs0ref == .;
replace bs1ref = bs1n if bs1ref == .;
replace bs2ref = bs2n if bs2ref == .;
replace bs3ref = bs3n if bs3ref == .;
replace bs4ref = bs4n if bs4ref == .;

bysort unicode: egen us0u = mean(un0sizex);
bysort unicode: egen us1u = mean(un1sizex);
bysort unicode: egen us2u = mean(un2sizex);
bysort unicode: egen us3u = mean(un3sizex);
bysort unicode: egen us4u = mean(un4sizex);

bysort state: egen us0s = mean(un0sizex);
bysort state: egen us1s = mean(un1sizex);
bysort state: egen us2s = mean(un2sizex);
bysort state: egen us3s = mean(un3sizex);
bysort state: egen us4s = mean(un4sizex);

bysort r1to5: egen us0r = mean(un0sizex);
bysort r1to5: egen us1r = mean(un1sizex);
bysort r1to5: egen us2r = mean(un2sizex);
bysort r1to5: egen us3r = mean(un3sizex);
bysort r1to5: egen us4r = mean(un4sizex);

egen us0n = mean(un0sizex);
egen us1n = mean(un1sizex);
egen us2n = mean(un2sizex);
egen us3n = mean(un3sizex);
egen us4n = mean(un4sizex);

sort unicode metcode id;

gen us0ref = us0u;
gen us1ref = us1u;
gen us2ref = us2u;
gen us3ref = us3u;
gen us4ref = us4u;

replace us0ref = us0s if us0ref == .;
replace us1ref = us1s if us1ref == .;
replace us2ref = us2s if us2ref == .;
replace us3ref = us3s if us3ref == .;
replace us4ref = us4s if us4ref == .;

replace us0ref = us0r if us0ref == .;
replace us1ref = us1r if us1ref == .;
replace us2ref = us2r if us2ref == .;
replace us3ref = us3r if us3ref == .;
replace us4ref = us4r if us4ref == .;

replace us0ref = us0n if us0ref == .;
replace us1ref = us1n if us1ref == .;
replace us2ref = us2n if us2ref == .;
replace us3ref = us3n if us3ref == .;
replace us4ref = us4n if us4ref == .;

/** Begin allocation/imputation - observe standard relations between bed sizes / unit sizes **/

replace bed0sizex = round(bs0ref*unif90, 1) if bed0sizex == . & bed0sizexM == 1;
replace bed1sizex = round(bs1ref*unif90, 1) if bed1sizex == . & bed1sizexM == 1;
replace bed2sizex = round(bs2ref*unif90, 1) if bed2sizex == . & bed2sizexM == 1;
replace bed3sizex = round(bs3ref*unif90, 1) if bed3sizex == . & bed3sizexM == 1;
replace bed4sizex = round(bs4ref*unif90, 1) if bed4sizex == . & bed4sizexM == 1;

replace bed3sizex = round(bed2sizex*0.95, 1) if bed3sizexM == 1 & bed3sizex > bed2sizex;
replace bed4sizex = round(bed3sizex*0.95, 1) if bed4sizexM == 1 & bed4sizex > bed3sizex;

replace un0sizex = round(us0ref*unif90, 1) if un0sizex == . & un0sizexM == 1;
replace un1sizex = round(us1ref*unif90, 1) if un1sizex == . & un1sizexM == 1;
replace un2sizex = round(us2ref*unif90, 1) if un2sizex == . & un2sizexM == 1;
replace un3sizex = round(us3ref*unif90, 1) if un3sizex == . & un3sizexM == 1;
replace un4sizex = round(us4ref*unif90, 1) if un4sizex == . & un4sizexM == 1;

replace un1sizex = round(un0sizex*1.05, 1) if un1sizexM == 1 & un1sizex < un0sizex;
replace un2sizex = round(un1sizex*1.05, 1) if un2sizexM == 1 & un2sizex < un1sizex;
replace un3sizex = round(un2sizex*1.05, 1) if un3sizexM == 1 & un3sizex < un2sizex;
replace un4sizex = round(un3sizex*1.05, 1) if un4sizexM == 1 & un4sizex < un3sizex;

/** By primacy of surveyed values, "rationalize" sizes and avoid internal inconsistencies **/

replace bed0sizex = un0sizex if bed0sizexM == 1 & renttype == "Unit";
replace bed1sizex = un1sizex if bed1sizexM == 1 & renttype == "Unit";
replace bed2sizex = un2sizex/2 if bed2sizexM == 1 & renttype == "Unit";
replace bed3sizex = un3sizex/3 if bed3sizexM == 1 & renttype == "Unit";
replace bed4sizex = un4sizex/4 if bed4sizexM == 1 & renttype == "Unit";

replace un0sizex = bed0sizex if un0sizexM == 1 & renttype == "Bed";
replace un1sizex = bed1sizex if un1sizexM == 1 & renttype == "Bed";
replace un2sizex = bed2sizex*2 if un2sizexM == 1 & renttype == "Bed";
replace un3sizex = bed3sizex*3 if un3sizexM == 1 & renttype == "Bed";
replace un4sizex = bed4sizex*4 if un4sizexM == 1 & renttype == "Bed";

/** NM update to carry over previous breakout where no changes to id occured **/

joinby id using $prefix/central/nm/stdstruc, unmatched(master);

/** for the case where total beds & total units is known **/

forval z = 0/4 {;

replace beds`z'x = prev_beds`z'x if totbeds == prev_totbeds & totbedx == prev_totbedx & totbedxM == prev_totbedxM & totunits == prev_totunits & 
	totunitx == prev_totunitx & totunitxM == prev_totunitxM & renttype == prev_renttype & doubleoccupancy == prev_doubleoccupancy & 
	tripleoccupancy == prev_tripleoccupancy & beds`z'x != prev_beds`z'x & prev_beds`z'x != .; 
replace units`z'x = prev_units`z'x if totbeds == prev_totbeds & totbedx == prev_totbedx & totbedxM == prev_totbedxM & totunits == prev_totunits & 
	totunitx == prev_totunitx & totunitxM == prev_totunitxM & renttype == prev_renttype & doubleoccupancy == prev_doubleoccupancy & 
	tripleoccupancy == prev_tripleoccupancy & units`z'x != prev_units`z'x & prev_units`z'x != .; 
	
};

/** for the case where total beds & total units is known **/

forval z = 0/4 {;

replace beds`z'x = prev_beds`z'x if renttype == prev_renttype & doubleoccupancy == prev_doubleoccupancy & tripleoccupancy == prev_tripleoccupancy & 
	beds`z'x != prev_beds`z'x & prev_beds`z'x != . & ((totbeds == . & totbedxM == prev_totbedxM & totbedxM == 1) | (totunits == . & totunitxM == prev_totunitxM & totunitxM == 1)); 
replace units`z'x = prev_units`z'x if renttype == prev_renttype & doubleoccupancy == prev_doubleoccupancy & tripleoccupancy == prev_tripleoccupancy & 
	units`z'x != prev_units`z'x & prev_units`z'x != . & ((totbeds == . & totbedxM == prev_totbedxM & totbedxM == 1) | (totunits == . & totunitxM == prev_totunitxM & totunitxM == 1)); 	

};

drop _merge - prev_tripleoccupancy;

/** Match with structural "presence" **/

replace bed0sizex = . if beds0x == 0;
replace bed1sizex = . if beds1x == 0;
replace bed2sizex = . if beds2x == 0;
replace bed3sizex = . if beds3x == 0;
replace bed4sizex = . if beds4x == 0;

replace bed0sizexM = . if beds0x == 0;
replace bed1sizexM = . if beds1x == 0;
replace bed2sizexM = . if beds2x == 0;
replace bed3sizexM = . if beds3x == 0;
replace bed4sizexM = . if beds4x == 0;

replace un0sizex = . if units0x == 0;
replace un1sizex = . if units1x == 0;
replace un2sizex = . if units2x == 0;
replace un3sizex = . if units3x == 0;
replace un4sizex = . if units4x == 0;

replace un0sizexM = . if units0x == 0;
replace un1sizexM = . if units1x == 0;
replace un2sizexM = . if units2x == 0;
replace un3sizexM = . if units3x == 0;
replace un4sizexM = . if units4x == 0;

/** Begin formatting for preliminary structural estimate file - "prep" file **/

rename latitude y;
rename longitude x;
rename msametro longmet;
rename universitystatus unistatus;
rename code propuse;
rename selectcode code;
rename selectcodeshortdescription codeshort;



/** Consistency test - drop if inconsistent sums, will be addressed with better info later **/

gen bedtest1 = beds0x + beds1x + beds2x + beds3x + beds4x;
gen untest1 = units0x + units1x + units2x + units3x + units4x;

/**
drop if bedtest1 ~= totbedx & renttype == "Bed";
drop if untest1 ~= totunitx & renttype == "Unit";
**/

order unicode university unistatus propuse code codeshort metcode longmet id name status propertytype purposebuilt oncampus universityowned distancetocampus
      streetaddress city county state zip x y yrbuilt monthbuilt bldgx bldgxM flrsx flrsxM totbeds totbedx totbedxM beds0x beds0xM beds1x beds1xM beds2x beds2xM beds3x beds3xM 
      beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM units4x units4xM
	  bed0sizex bed0sizexM bed1sizex bed1sizexM bed2sizex bed2sizexM bed3sizex bed3sizexM bed4sizex bed4sizexM un0sizex un0sizexM un1sizex un1sizexM
	  un2sizex un2sizexM un3sizex un3sizexM un4sizex un4sizexM brparity0 brparity1 brparity2 brparity3 brparity3;

save $prefix/central/vc/std/data/strucest_raw_${curryr}q${currqtr}, replace; 

**/

use $prefix/central/vc/std/data/strucest_raw_${curryr}q${currqtr}testn;
/** Create the three files required for std_consistency_for_rentcomps **/

/** 1.  std_consistent_ids - properties with ALL surveyed unit and bed breakouts AND surveyed totals for beds and units **/

gen marker = .;
replace marker = 1 if renttype ~= "" & unxMtest ~= 5 & bedxMtest ~= 5 & bedtester == totbedx & untester == totunitx;

keep if marker == 1;
keep id marker;

sort id;

save $prefix/central/vc/std/data/std_consistent_ids_${curryr}q${currqtr}testn, replace;
clear;

/** 2.  std_totalsize_available - properties where totbeds / totunits available **/

use $prefix/central/vc/std/data/strucest_raw_${curryr}q${currqtr}testn;

keep if (totbeds ~= . | totunits ~= .);
rename totbeds totbedsF;
rename totunits totunitsF;

keep id totbedsF totunitsF;

drop if totbedsF == 0;
drop if totunitsF == 0;
drop if totbedsF == . & totunitsF == .;

sort id;

save $prefix/central/vc/std/data/std_totalsize_available_${curryr}q${currqtr}testn, replace;
clear;

/** 3.  std_STFU - IDs which have fully surveyed Unit SFs **/

use $prefix/central/vc/std/data/strucest_raw_${curryr}q${currqtr}testn;

gen un0sizexMO = un0sizexM;
gen un1sizexMO = un1sizexM;
gen un2sizexMO = un2sizexM;
gen un3sizexMO = un3sizexM;
gen un4sizexMO = un4sizexM;

keep id un*sizexMO;

replace un0sizexMO = 0 if un0sizexMO == .;
replace un1sizexMO = 0 if un1sizexMO == .;
replace un2sizexMO = 0 if un2sizexMO == .;
replace un3sizexMO = 0 if un3sizexMO == .;
replace un4sizexMO = 0 if un4sizexMO == .;

gen untest = un0sizexMO + un1sizexMO + un2sizexMO + un3sizexMO + un4sizexMO;

keep if untest == 0;
sort id;
gen nounitsfests = 1;
keep id nounitsfests;

save $prefix/central/vc/std/data/std_STFU_${curryr}q${currqtr}testn, replace;
clear;

use $prefix/central/vc/std/data/strucest_raw_${curryr}q${currqtr}testn;
	  
sort unicode metcode id;	

keep unicode university unistatus propuse code codeshort metcode longmet id name status propertytype purposebuilt streetaddress city county state zip x y
      yrbuilt monthbuilt bldgx bldgxM flrsx flrsxM totbeds totbedx totbedxM beds0x beds0xM beds1x beds1xM beds2x beds2xM beds3x beds3xM 
      beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM units4x units4xM
	  bed0sizex bed0sizexM bed1sizex bed1sizexM bed2sizex bed2sizexM bed3sizex bed3sizexM bed4sizex bed4sizexM un0sizex un0sizexM un1sizex un1sizexM
	  un2sizex un2sizexM un3sizex un3sizexM un4sizex un4sizexM subid subname oncampus universityowned distancetocampus  
	  brparity0 brparity1 brparity2 brparity3 brparity4;	 
	  
save $prefix/central/vc/std/data/strucest_${curryr}q${currqtr}testn, replace;

/** Create time periods **/

/** 1.  Create years **/

expand $expper;
sort id;
gen yr = $begyr;
by id: gen ct = _n;
by id: gen ct2 = ct - 1;  
by id: replace yr = (yr + ct2);
drop ct ct2;

/** 2.  Create months **/

expand 12;
sort id yr;
by id yr: gen ct = _n;
gen currmon = ct;
drop if yr == $curryr & currmon > $currmo;

/** Designate quarters **/

gen qtr = 1;
replace qtr = 2 if currmon >= 4 & currmon <= 6;
replace qtr = 3 if currmon >= 7 & currmon <= 9;
replace qtr = 4 if currmon >= 10;

sort id yr qtr currmon;
drop ct;

order id yr qtr currmon unicode university unistatus propuse code codeshort metcode longmet subid subname name status propertytype purposebuilt 
      oncampus universityowned distancetocampus streetaddress city county state zip x y
      yrbuilt monthbuilt bldgx bldgxM flrsx flrsxM totbeds totbedx totbedxM beds0x beds0xM beds1x beds1xM beds2x beds2xM beds3x beds3xM 
      beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM units4x units4xM
	  bed0sizex bed0sizexM bed1sizex bed1sizexM bed2sizex bed2sizexM bed3sizex bed3sizexM bed4sizex bed4sizexM un0sizex un0sizexM un1sizex un1sizexM
	  un2sizex un2sizexM un3sizex un3sizexM un4sizex un4sizexM brparity0 brparity1 brparity2 brparity3 brparity4;	 
	  
save $prefix/central/vc/std/data/std_prep_${curryr}q${currqtr}testn, replace;
clear;

/** Prepare "LOG" files (performance data) **/

use $prefix/central/vc/std/data/stdbase;

rename propertyid id;
rename msa metcode;
rename universitycode unicode;
	  
gen str4 survyr = substr(surveydate,-4, 4);
gen str2 survmon = substr(surveydate,1,2);
destring survyr survmon, replace force;

gen yr = survyr;
gen qtr = 1;
replace qtr = 2 if survmon >= 4 & survmon <= 6;
replace qtr = 3 if survmon >= 7 & survmon <= 9;
replace qtr = 4 if survmon >= 10;	
gen currmon = survmon;
  
sort id yr qtr survmon;

/** Keep only the most recent survey WITHIN the MONTH **/

sort id yr qtr currmon;
by id yr qtr currmon: gen cttest = _n;
by id yr qtr currmon: egen ctlast = lastnm(cttest);
by id yr qtr currmon: egen ctmean = mean(cttest);

drop if ctmean ~= 1 & ctlast ~= cttest;
sort id yr qtr currmon;

order id yr qtr currmon survyr survmon surveydate unicode metcode averagerent freerentpercent leaseterm monthsfreerent percentpreleased percentrentutilities 
      percentstudents reducedfreerentpercent reducedleaseterm reducedrentdiscount renttype doubleoccupancy tripleoccupancy totalvacantbeds totalvacantunits 
	  braverage0 braverage1 braverage2 braverage3 braverage4 brfutureaverage0 brfutureaverage1 brfutureaverage2 brfutureaverage3 brfutureaverage4 leasingincentives
	  averagerent;
	  
keep id yr qtr currmon survyr survmon surveydate unicode metcode averagerent freerentpercent leaseterm monthsfreerent percentpreleased percentrentutilities 
      percentstudents reducedfreerentpercent reducedleaseterm reducedrentdiscount renttype doubleoccupancy tripleoccupancy totalvacantbeds totalvacantunits 
	  braverage0 braverage1 braverage2 braverage3 braverage4 brfutureaverage0 brfutureaverage1 brfutureaverage2 brfutureaverage3 brfutureaverage4 leasingincentives
	  averagerent;	  
	  
save $prefix/central/vc/std/data/std_log_${curryr}q${currqtr}testn, replace;
clear;


/** Begin squaring protocol **/

/** Step 1: Merge PREP (structural) and LOG (performance) data files **/

use $prefix/central/vc/std/data/std_prep_${curryr}q${currqtr}testn;
joinby id yr qtr currmon using $prefix/central/vc/std/data/std_log_${curryr}q${currqtr}testn, unmatched(master);
drop _merge;

sort metcode yr qtr currmon;
joinby metcode yr qtr currmon using $prefix/central/vc/std/data/std_demo_${curryr}q${currqtr}, unmatched(master);
drop _merge;
sort id yr qtr currmon;

/** genmet refs **/

sort metcode yr qtr currmon;
joinby metcode using $prefix/central/master-data/genmet, unmatched(master);
drop _merge;
sort id yr qtr currmon;

/** Estimate VACANCIES **/

/** Establish renttype **/
  
by id: gen cter = _n;
global y = cter*100;
forval i = 1/$y {;
  by id: replace renttype = renttype[_n + 1] if renttype == "";
  by id: replace renttype = renttype[_n - 1] if renttype == "";
  };

/** What if no assigned renttype? Analyze most common renttype per unicode, state (pool most common observations
    over larger geographic aggregations **/

gen typetest = .;
replace typetest = 1 if renttype == "Bed";
replace typetest = 2 if renttype == "Unit";
sort unicode id yr qtr currmon;

by unicode: egen bedct = count(typetest) if typetest == 1;
by unicode: egen bedctm = mean(bedct);
by unicode: egen unict = count(typetest) if typetest == 2;
by unicode: egen unictm = mean(unict);

sort state id yr qtr currmon;
by state: egen bedcts = count(typetest) if typetest == 1;
by state: egen unicts = count(typetest) if typetest == 2;
by state: egen bedctsm = mean(bedcts);
by state: egen unictsm = mean(unicts);

replace bedctm = bedctsm if bedctm == .;
replace unictm = unictsm if unictm == .;

sort id yr qtr currmon;
gen renttypexM = 0;
replace renttypexM = 1 if renttype == "";
replace renttype = "Bed" if renttype == "" & renttypexM == 1 & bedctm >= unictm;
replace renttype = "Unit" if renttype == "" & renttypexM == 1 & unictm > bedctm;

/** Finally, for "in betweens" like "renttype = Both", bucket to a specific Bed or Unit type **/

gen str5 renttypeO = renttype;
by id: egen str5 renttypeN = lastnm(renttype);

/** Replace renttype with last observed renttype **/

replace renttype = renttypeN;

/** For IDs that remain in "Both" use the same criterion as above **/

replace renttype = "Bed" if renttype == "Both" & bedctm >= unictm;
replace renttype = "Unit" if renttype == "Both" & unictm > bedctm;

gen availbedx = totalvacantbeds;
replace availbedx = . if availbedx < 0;
gen availunx =  totalvacantunits;
replace availunx = . if availunx < 0;

gen availbedxM = 1;
gen availunxM = 1;
replace availbedxM = 0 if totalvacantbeds ~= . & totalvacantbeds >= 0;
replace availunxM = 0 if totalvacantunits ~= . & totalvacantunits >= 0;

/** Begin squaring protocol **/

gen poprefg = -1*mpop2529d;
bysort r1to5 yr qtr currmon: egen poprefgr = mean(poprefg);
bysort yr qtr currmon: egen poprefgn = mean(poprefg);
sort unicode id yr qtr currmon;
replace poprefg = poprefgr if poprefg == .;
replace poprefg = poprefgn if poprefg == .;

/** Fill in by semester buckets, where surveys are available **/

sort id yr qtr currmon;

/** Broaden the base around surveyed levels, within semester buckets **/

replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 0 & availbedxM == 1 & (currmon == 2 | currmon == 6 | currmon == 10);
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 2] == 0 & currmon == 3;
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 2] == 0 & currmon == 7;
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 2] == 0 & currmon == 11;
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 3] == 0 & currmon == 4;
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 3] == 0 & currmon == 8;
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 3] == 0 & currmon == 12;

replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 0 & availbedxM == 1 & (currmon == 3 | currmon == 7 | currmon == 11);
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 2] == 0 & currmon == 4;
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 2] == 0 & currmon == 8;
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 2] == 0 & currmon == 12;

replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 0 & availbedxM == 1 & (currmon == 4 | currmon == 8 | currmon == 12);
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 2] == 0 & currmon == 5;
replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedxM[_n - 1] == 1 & availbedxM == 1 & availbedxM[_n - 2] == 0 & currmon == 9;

replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 2] == 0 & currmon == 4;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 3] == 0 & currmon == 3;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 4] == 0 & currmon == 2;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 2] == 0 & currmon == 8;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 3] == 0 & currmon == 7;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 4] == 0 & currmon == 6;

replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & (currmon == 2 | currmon == 6 | currmon == 10);
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 2] == 0 & currmon == 5;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 3] == 0 & currmon == 4;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 4] == 0 & currmon == 3;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 2] == 0 & currmon == 9;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 3] == 0 & currmon == 8;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 4] == 0 & currmon == 7;

replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & (currmon == 3 | currmon == 7 | currmon == 11);
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 2] == 0 & currmon == 6;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 3] == 0 & currmon == 5;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 4] == 0 & currmon == 4;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 2] == 0 & currmon == 10;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 3] == 0 & currmon == 11;
replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedxM[_n + 1] == 0 & availbedxM == 1 & availbedx[_n + 4] == 0 & currmon == 9;

replace availbedx = round(availbedx, 1);

/** Establish DBVAC levels by University and Region **/

gen dbbed = totbedx if availbedx ~= .;
gen sem = 1;
replace sem = 2 if currmon >= 5 & currmon <= 8;
replace sem = 3 if currmon >= 9;
bysort unicode yr sem: egen dbinv1 = sum(dbbed);
bysort unicode yr sem: egen dbava1 = sum(availbedx);
bysort unicode yr sem: egen dbct1 = count(availbedx);
sort id yr qtr currmon;
gen dbvac1 = dbava1/dbinv1;

bysort r1to5 yr sem: egen dbinv2 = sum(dbbed);
bysort r1to5 yr sem: egen dbava2 = sum(availbedx);
bysort r1to5 yr sem: egen dbct2 = count(availbedx);
sort id yr qtr currmon;
gen dbvac2 = dbava2/dbinv2;

/** For estimates, pick the lower vacancy figure **/

gen dbvac = dbvac1;
replace dbvac = dbvac2 if dbvac1 == .;
replace dbvac = dbvac2 if dbvac1 > 0.15 & dbvac2 < dbvac1;

/** Establish dbvac / availbedx levels for ZERO surveyed levels **/

sort id yr sem;
by id yr: egen avbedct = count(availbedx);
sort id yr qtr currmon;

gen unif1 = uniform();
gen unif90 = unif1*(1.10 - 0.90) + 0.90;
drop unif1;

by id: replace availbedx = round(totbedx*(dbvac*unif90), 1) if avbedct == 0 & availbedxM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);

/** Customize within semester/summer attributes **/

by id: replace availbedx = round(totbedx*(dbvac*unif90), 1) if availbedxM == 1 & (currmon == 1 | currmon == 9) & dbvac <= 0.07;
by id: replace availbedx = round(totbedx*(dbvac*unif90), 1) if availbedxM == 1 & currmon == 5 & dbvac > 0.07;

/** Fill in the rest **/

by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 2;
by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 3;  
by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 4;
by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 5;
by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 6;
by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 7;  
by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 8;
by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 9;
by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 10;
by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 11;  
by id: replace availbedx = availbedx[_n - 1]*(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 12;

by id: replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 3;
by id: replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 2;
by id: replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 1;

by id: replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 6;
by id: replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 7;
by id: replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 5;

by id: replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 11;
by id: replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 10;
by id: replace availbedx = availbedx[_n + 1]/(1 + poprefg) if availbedx == . & availbedxM == 1 & currmon == 9;

/** Final failsafe **/

by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 11;
by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 10;
by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 9;
by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 8;
by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 7;
by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 6;
by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 5;
by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 4;
by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 3;
by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 2;
by id: replace availbedx = availbedx[_n + 1] if availbedx == . & availbedxM == 1 & currmon == 1;

/** Ben Bloch feedback - carry over availbedx if surveyed observations exist from prior months **/

by id: replace availbedx = availbedx[_n - 1] if availbedxM == 1 & availbedxM[_n - 1] == 0;
by id: replace availbedx = availbedx[_n - 2] if availbedxM == 1 & availbedxM[_n - 1] == 1 & availbedxM[_n - 2] == 0;
by id: replace availbedx = availbedx[_n - 1] if availbedxM == 1 & availbedxM[_n - 1] == 0 & availbedxM[_n + 1] == 1;

replace availbedx = 0 if availbedxM == 1 & availbedx ~= . & availbedx < 0;
replace availbedx = totbedx if availbedxM == 1 & availbedx ~= . & availbedx > totbedx;

/** Replicate squaring protocol for UNITS **/

/** Broaden the base around surveyed levels, within semester buckets **/

replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 0 & availunxM == 1 & (currmon == 2 | currmon == 6 | currmon == 10);
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 2] == 0 & currmon == 3;
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 2] == 0 & currmon == 7;
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 2] == 0 & currmon == 11;
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 3] == 0 & currmon == 4;
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 3] == 0 & currmon == 8;
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 3] == 0 & currmon == 12;

replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 0 & availunxM == 1 & (currmon == 3 | currmon == 7 | currmon == 11);
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 2] == 0 & currmon == 4;
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 2] == 0 & currmon == 8;
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 2] == 0 & currmon == 12;

replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 0 & availunxM == 1 & (currmon == 4 | currmon == 8 | currmon == 12);
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 2] == 0 & currmon == 5;
replace availunx = availunx[_n - 1]*(1 + poprefg) if availunxM[_n - 1] == 1 & availunxM == 1 & availunxM[_n - 2] == 0 & currmon == 9;

replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 2] == 0 & currmon == 4;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 3] == 0 & currmon == 3;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 4] == 0 & currmon == 2;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 2] == 0 & currmon == 8;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 3] == 0 & currmon == 7;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 4] == 0 & currmon == 6;

replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & (currmon == 2 | currmon == 6 | currmon == 10);
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 2] == 0 & currmon == 5;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 3] == 0 & currmon == 4;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 4] == 0 & currmon == 3;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 2] == 0 & currmon == 9;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 3] == 0 & currmon == 8;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 4] == 0 & currmon == 7;

replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & (currmon == 3 | currmon == 7 | currmon == 11);
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 2] == 0 & currmon == 6;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 3] == 0 & currmon == 5;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 4] == 0 & currmon == 4;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 2] == 0 & currmon == 10;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 3] == 0 & currmon == 11;
replace availunx = availunx[_n + 1]/(1 + poprefg) if availunxM[_n + 1] == 0 & availunxM == 1 & availunx[_n + 4] == 0 & currmon == 9;

/** Establish DBVAC levels by University and Region **/

drop dbbed sem dbinv1 dbava1 dbct1 dbinv2 dbava2 dbct2 dbvac1 dbvac2;
rename dbvac dbvacbed;

gen dbun = totunitx if availunx ~= .;
gen sem = 1;
replace sem = 2 if currmon >= 5 & currmon <= 8;
replace sem = 3 if currmon >= 9;
bysort unicode yr sem: egen dbinv1 = sum(dbun);
bysort unicode yr sem: egen dbava1 = sum(availunx);
bysort unicode yr sem: egen dbct1 = count(availunx);
sort id yr qtr currmon;
gen dbvac1 = dbava1/dbinv1;

bysort r1to5 yr sem: egen dbinv2 = sum(dbun);
bysort r1to5 yr sem: egen dbava2 = sum(availunx);
bysort r1to5 yr sem: egen dbct2 = count(availunx);
sort id yr qtr currmon;
gen dbvac2 = dbava2/dbinv2;

/** For estimates, pick the lower vacancy figure **/

gen dbvac = dbvac1;
replace dbvac = dbvac2 if dbvac1 == .;
replace dbvac = dbvac2 if dbvac1 > 0.15 & dbvac2 < dbvac1;
rename dbvac dbvacun;

/** Establish dbvac / availunx levels for ZERO surveyed levels **/

sort id yr sem;
by id yr: egen avunct = count(availunx);
sort id yr qtr currmon;
by id: replace availunx = round(totunitx*(dbvacun*unif90), 1) if avunct == 0 & availunxM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);

/** Customize within semester/summer attributes **/
by id: replace availunx = round(totunitx*(dbvacun*unif90), 1) if availunxM == 1 & (currmon == 1 | currmon == 9) & dbvacun <= 0.07;
by id: replace availunx = round(totunitx*(dbvacun*unif90), 1) if availunxM == 1 & currmon == 5 & dbvacun > 0.07;


/** Fill in the rest **/

by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 2;
by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 3;  
by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 4;
by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 5;
by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 6;
by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 7;  
by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 8;
by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 9;
by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 10;
by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 11;  
by id: replace availunx = availunx[_n - 1]*(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 12;

by id: replace availunx = availunx[_n + 1]/(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 3;
by id: replace availunx = availunx[_n + 1]/(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 2;
by id: replace availunx = availunx[_n + 1]/(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 1;

by id: replace availunx = availunx[_n + 1]/(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 7;
by id: replace availunx = availunx[_n + 1]/(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 6;
by id: replace availunx = availunx[_n + 1]/(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 5;

by id: replace availunx = availunx[_n + 1]/(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 11;
by id: replace availunx = availunx[_n + 1]/(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 10;
by id: replace availunx = availunx[_n + 1]/(1 + poprefg) if availunx == . & availunxM == 1 & currmon == 9;

/** Final failsafe **/

by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 11;
by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 10;
by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 9;
by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 8;
by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 7;
by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 6;
by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 5;
by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 4;
by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 3;
by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 2;
by id: replace availunx = availunx[_n + 1] if availunx == . & availunxM == 1 & currmon == 1;

/** Ben Bloch feedback - carry over availbedx if surveyed observations exist from prior months **/

by id: replace availunx = availunx[_n - 1] if availunxM == 1 & availunxM[_n - 1] == 0;
by id: replace availunx = availunx[_n - 2] if availunxM == 1 & availunxM[_n - 1] == 1 & availunxM[_n - 2] == 0;
by id: replace availunx = availunx[_n - 1] if availunxM == 1 & availunxM[_n - 1] == 0 & availunxM[_n + 1] == 1;

replace availunx = 0 if availunxM == 1 & availunx ~= . & availunx < 0;
replace availunx = totunitx if availunxM == 1 & availunx ~= . & availunx > totunitx;

/** Format values **/

replace availbedx = int(availbedx) if availbedxM == 1;
replace availunx = int(availunx) if availunxM == 1;

/** Failsafe for renttype switching! WTF **/

by id: egen renttypeX = lastnm(renttype);

replace availbedx = . if renttypeX == "Unit";
replace availbedxM = . if renttypeX == "Unit";
replace availunx = . if renttypeX == "Bed";
replace availunxM = . if renttypeX == "Bed";

gen vacbedx = availbedx/totbedx;
gen vacunx = availunx/totunitx;

/** For future value estimates, take the average values from the prior leasing semester being estimated **/

/** 05/21/2015 note: NEED TO USE percentpreleased! Null if no prelease values (for the quarter's surveys) **/

/** Old code BELOW - active code HERE **/

#delimit;
sort id yr qtr currmon;
gen perc1 = percentpreleased/100;
by id yr qtr: egen perc2 = lastnm(perc1);
replace perc2 = . if yr < $curryr;
replace perc2 = . if yr == $curryr & qtr < $currqtr;
by id: egen percpx = mean(perc2);

gen fvacbedx = 1-percpx;
gen fvacunx = 1-percpx;

gen favailbedx = round(fvacbedx*totbedx, 1);
gen favailunx = round(fvacunx*totunitx, 1);

/**

gen percpx = percentpreleased/100;

by id: gen favailb1 = availbedx;
by id: gen favailu1 = availunx;

replace favailb1 = round(totbedx*percpx, 1) if percpx ~= .;
replace favailu1 = round(totunitx*percpx, 1) if percpx ~= .;

if $currmo >= 1 & $currmo <= 7 {;
   replace favailb1 = . if currmon <= 7;
   replace favailu1 = . if currmon <= 7;
   };
   
if $currmo >= 8 & $currmo <= 12 {;
   replace favailb1 = . if currmon > 7;
   replace favailu1 = . if currmon > 7;
   };       

 by id: egen favailb2 = mean(favailb1);
 by id: egen favailu2 = mean(favailu1);
 
 /** Take the composite average given the LAST known value **/
 
 by id: egen favailb3 = lastnm(availbedx);
 by id: egen favailu3 = lastnm(availunx);
 
 by id: gen favailbedx = 0.75*favailb3 + 0.25*favailb2;
 by id: gen favailunx = 0.75*favailu3 + 0.25*favailu2;
 
 by id: replace favailbedx = percpx*totbedx if percpx ~= .;
 by id: replace favailunx = percpx*totunitx if percpx ~= .;
 
 replace favailbedx = int(favailbedx);
 replace favailunx = int(favailunx);
 
 gen fvacbedx1 = favailbedx/totbedx;
 gen fvacunx1 = favailunx/totunitx;
 
 replace fvacbedx1 = percpx if percpx ~= .;
 replace fvacunx1 = percpx if percpx ~= .;
 
 by id: egen fvacbedx = lastnm(fvacbedx1);
 by id: egen fvacunx = lastnm(fvacunx1);
 
 **/
 

/** Begin squaring rent levels **/

/** Rationalize mcpid **/

bysort state yr qtr: egen mcpidst = mean(mcpid);
bysort r1to5 yr qtr: egen mcpidreg = mean(mcpid);
bysort yr qtr: egen mcpidnat = mean(mcpid);
replace mcpid = mcpidst if mcpid == .;
replace mcpid = mcpidreg if mcpid == .;
replace mcpid = mcpidnat if mcpid == .;

sort id yr qtr currmon;

gen bren0x = braverage0 if renttypeO == "Bed";
gen bren1x = braverage1 if renttypeO == "Bed";
gen bren2x = braverage2 if renttypeO == "Bed";
gen bren3x = braverage3 if renttypeO == "Bed";
gen bren4x = braverage4 if renttypeO == "Bed";

gen uren0x = braverage0 if renttypeO == "Unit";
gen uren1x = braverage1 if renttypeO == "Unit";
gen uren2x = braverage2 if renttypeO == "Unit";
gen uren3x = braverage3 if renttypeO == "Unit";
gen uren4x = braverage4 if renttypeO == "Unit";

replace bren0x = braverage0 if renttypeO == "Unit";
replace bren1x = braverage1 if renttypeO == "Unit";
replace bren2x = braverage2/2 if renttypeO == "Unit";
replace bren3x = braverage3/3 if renttypeO == "Unit";
replace bren4x = braverage4/4 if renttypeO == "Unit";

replace uren0x = braverage0 if renttypeO == "Bed";
replace uren1x = braverage1 if renttypeO == "Bed";
replace uren2x = braverage2*2 if renttypeO == "Bed";
replace uren3x = braverage3*3 if renttypeO == "Bed";
replace uren4x = braverage4*4 if renttypeO == "Bed";

gen bren0xM = 1;
gen bren1xM = 1;
gen bren2xM = 1;
gen bren3xM = 1;
gen bren4xM = 1;

gen uren0xM = 1;
gen uren1xM = 1;
gen uren2xM = 1;
gen uren3xM = 1;
gen uren4xM = 1;

replace bren0xM = 0 if braverage0 ~= . & braverage0 > 0 & renttypeO == "Bed";
replace bren1xM = 0 if braverage1 ~= . & braverage0 > 1 & renttypeO == "Bed";
replace bren2xM = 0 if braverage2 ~= . & braverage0 > 2 & renttypeO == "Bed";
replace bren3xM = 0 if braverage3 ~= . & braverage0 > 3 & renttypeO == "Bed";
replace bren4xM = 0 if braverage4 ~= . & braverage0 > 4 & renttypeO == "Bed";

replace uren0xM = 0 if braverage0 ~= . & braverage0 > 0 & renttypeO == "Unit";
replace uren1xM = 0 if braverage1 ~= . & braverage0 > 1 & renttypeO == "Unit";
replace uren2xM = 0 if braverage2 ~= . & braverage0 > 2 & renttypeO == "Unit";
replace uren3xM = 0 if braverage3 ~= . & braverage0 > 3 & renttypeO == "Unit";
replace uren4xM = 0 if braverage4 ~= . & braverage0 > 4 & renttypeO == "Unit";

replace bren0xM = 0 if braverage0 ~= . & braverage0 > 0 & renttypeO == "Unit";
replace bren1xM = 0 if braverage1 ~= . & braverage0 > 1 & renttypeO == "Unit";
replace bren2xM = 0 if braverage2 ~= . & braverage0 > 2 & renttypeO == "Unit";
replace bren3xM = 0 if braverage3 ~= . & braverage0 > 3 & renttypeO == "Unit";
replace bren4xM = 0 if braverage4 ~= . & braverage0 > 4 & renttypeO == "Unit";

replace uren0xM = 0 if braverage0 ~= . & braverage0 > 0 & renttypeO == "Bed";
replace uren1xM = 0 if braverage1 ~= . & braverage0 > 1 & renttypeO == "Bed";
replace uren2xM = 0 if braverage2 ~= . & braverage0 > 2 & renttypeO == "Bed";
replace uren3xM = 0 if braverage3 ~= . & braverage0 > 3 & renttypeO == "Bed";
replace uren4xM = 0 if braverage4 ~= . & braverage0 > 4 & renttypeO == "Bed";

gen avgrenx = averagerent;
gen avgrenxM = 1;
replace avgrenxM = 0 if averagerent ~= . & averagerent > 0;

/** Expand pool given surveyed levels **/

sort id yr qtr currmon;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 2] == 0 & currmon == 3;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 3] == 0 & currmon == 4;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 4] == 0 & currmon == 5;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 2] == 0 & currmon == 7;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 3] == 0 & currmon == 8;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 4] == 0 & currmon == 9;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 2] == 0 & currmon == 11;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 3] == 0 & currmon == 12;

by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 2] == 0 & currmon == 4;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 3] == 0 & currmon == 5;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 4] == 0 & currmon == 6;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 2] == 0 & currmon == 8;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 3] == 0 & currmon == 9;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 4] == 0 & currmon == 10;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 2] == 0 & currmon == 12;

by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 2] == 0 & currmon == 5;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 3] == 0 & currmon == 6;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 4] == 0 & currmon == 7;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 2] == 0 & currmon == 9;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 3] == 0 & currmon == 10;
by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenxM == 1 & avgrenxM[_n - 4] == 0 & currmon == 11;

by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 2] == 0 & currmon == 2;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 3] == 0 & currmon == 1;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 2] == 0 & currmon == 6;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 3] == 0 & currmon == 5;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 4] == 0 & currmon == 4;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 2] == 0 & currmon == 10;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 3] == 0 & currmon == 9;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 4] == 0 & currmon == 8;

by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 2] == 0 & currmon == 1;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 2] == 0 & currmon == 5;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 3] == 0 & currmon == 4;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 4] == 0 & currmon == 3;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 2] == 0 & currmon == 9;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 3] == 0 & currmon == 8;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 4] == 0 & currmon == 7;

by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 2] == 0 & currmon == 4;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 3] == 0 & currmon == 3;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 4] == 0 & currmon == 2;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 2] == 0 & currmon == 8;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 3] == 0 & currmon == 7;
by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1 & avgrenxM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace avgrenx = avgrenx[_n - 1]*0.5 + avgrenx[_n + 1]*0.5 if avgrenxM == 1 & avgrenxM[_n - 1] == 0 & avgrenxM[_n + 1] == 0;
by id: replace avgrenx = avgrenx[_n - 1]*0.7 + avgrenx[_n + 2]*0.3 if avgrenxM == 1 & avgrenxM[_n - 1] == 0 & avgrenxM[_n + 2] == 0;
by id: replace avgrenx = avgrenx[_n - 2]*0.3 + avgrenx[_n + 1]*0.7 if avgrenxM == 1 & avgrenxM[_n - 2] == 0 & avgrenxM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace avgrenx = avgrenx[_n - 1] if avgrenxM == 1 & avgrenxM[_n - 1] == 0;
by id: replace avgrenx = avgrenx[_n - 2] if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 0;
by id: replace avgrenx = avgrenx[_n - 1] if avgrenxM == 1 & avgrenxM[_n - 1] == 0 & avgrenxM[_n + 1] == 1;


/** Establish dbbrents by unicode, state, region **/

bysort unicode yr sem: egen dbaren = mean(avgrenx);
bysort state yr sem: egen dbarenstate = mean(avgrenx);
bysort state yr sem: egen dbarenreg = mean(avgrenx);
sort id yr qtr currmon;

/** bren0x **/

sort id yr qtr currmon;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 2] == 0 & currmon == 3;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 3] == 0 & currmon == 4;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 4] == 0 & currmon == 5;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 2] == 0 & currmon == 7;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 3] == 0 & currmon == 8;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 4] == 0 & currmon == 9;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 2] == 0 & currmon == 11;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 3] == 0 & currmon == 12;

by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 2] == 0 & currmon == 4;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 3] == 0 & currmon == 5;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 4] == 0 & currmon == 6;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 2] == 0 & currmon == 8;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 3] == 0 & currmon == 9;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 4] == 0 & currmon == 10;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 2] == 0 & currmon == 12;

by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 2] == 0 & currmon == 5;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 3] == 0 & currmon == 6;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 4] == 0 & currmon == 7;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 2] == 0 & currmon == 9;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 3] == 0 & currmon == 10;
by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0xM == 1 & bren0xM[_n - 4] == 0 & currmon == 11;

by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 2] == 0 & currmon == 2;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 3] == 0 & currmon == 1;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 2] == 0 & currmon == 6;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 3] == 0 & currmon == 5;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 4] == 0 & currmon == 4;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 2] == 0 & currmon == 10;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 3] == 0 & currmon == 9;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 4] == 0 & currmon == 8;

by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 2] == 0 & currmon == 1;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 2] == 0 & currmon == 5;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 3] == 0 & currmon == 4;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 4] == 0 & currmon == 3;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 2] == 0 & currmon == 9;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 3] == 0 & currmon == 8;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 4] == 0 & currmon == 7;

by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 2] == 0 & currmon == 4;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 3] == 0 & currmon == 3;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 4] == 0 & currmon == 2;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 2] == 0 & currmon == 8;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 3] == 0 & currmon == 7;
by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1 & bren0xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace bren0x = bren0x[_n - 1]*0.5 + bren0x[_n + 1]*0.5 if bren0xM == 1 & bren0xM[_n - 1] == 0 & bren0xM[_n + 1] == 0;
by id: replace bren0x = bren0x[_n - 1]*0.7 + bren0x[_n + 2]*0.3 if bren0xM == 1 & bren0xM[_n - 1] == 0 & bren0xM[_n + 2] == 0;
by id: replace bren0x = bren0x[_n - 2]*0.3 + bren0x[_n + 1]*0.7 if bren0xM == 1 & bren0xM[_n - 2] == 0 & bren0xM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace bren0x = bren0x[_n - 1] if bren0xM == 1 & bren0xM[_n - 1] == 0;
by id: replace bren0x = bren0x[_n - 2] if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 0;
by id: replace bren0x = bren0x[_n - 1] if bren0xM == 1 & bren0xM[_n - 1] == 0 & bren0xM[_n + 1] == 1;

/** Establish dbbrents by unicode, state, region **/

gen bren0xaggb = bren0x*beds0x;
replace bren0xaggb = . if beds0x == 0;
gen bren0xinvb = beds0x;
replace bren0xinvb = . if bren0xaggb == .;

bysort unicode yr sem: egen bren0a1 = sum(bren0xaggb);
bysort unicode yr sem: egen bren0inv1 = sum(bren0xinvb);
bysort unicode yr sem: gen db0brenuni = bren0a1/bren0inv1;

bysort state yr sem: egen bren0a2 = sum(bren0xaggb);
bysort state yr sem: egen bren0inv2 = sum(bren0xinvb);
bysort state yr sem: gen db0stateunibed = bren0a2/bren0inv2;

bysort r1to5 yr sem: egen bren0a3 = sum(bren0xaggb);
bysort r1to5 yr sem: egen bren0inv3 = sum(bren0xinvb);
bysort r1to5 yr sem: gen db0regunibed = bren0a3/bren0inv3;

sort id yr qtr currmon;

/** bren1x **/

sort id yr qtr currmon;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 2] == 0 & currmon == 3;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 3] == 0 & currmon == 4;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 4] == 0 & currmon == 5;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 2] == 0 & currmon == 7;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 3] == 0 & currmon == 8;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 4] == 0 & currmon == 9;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 2] == 0 & currmon == 11;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 3] == 0 & currmon == 12;

by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 2] == 0 & currmon == 4;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 3] == 0 & currmon == 5;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 4] == 0 & currmon == 6;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 2] == 0 & currmon == 8;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 3] == 0 & currmon == 9;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 4] == 0 & currmon == 10;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 2] == 0 & currmon == 12;

by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 2] == 0 & currmon == 5;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 3] == 0 & currmon == 6;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 4] == 0 & currmon == 7;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 2] == 0 & currmon == 9;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 3] == 0 & currmon == 10;
by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1xM == 1 & bren1xM[_n - 4] == 0 & currmon == 11;

by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 2] == 0 & currmon == 2;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 3] == 0 & currmon == 1;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 2] == 0 & currmon == 6;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 3] == 0 & currmon == 5;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 4] == 0 & currmon == 4;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 2] == 0 & currmon == 10;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 3] == 0 & currmon == 9;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 4] == 0 & currmon == 8;

by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 2] == 0 & currmon == 1;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 2] == 0 & currmon == 5;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 3] == 0 & currmon == 4;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 4] == 0 & currmon == 3;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 2] == 0 & currmon == 9;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 3] == 0 & currmon == 8;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 4] == 0 & currmon == 7;

by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 2] == 0 & currmon == 4;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 3] == 0 & currmon == 3;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 4] == 0 & currmon == 2;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 2] == 0 & currmon == 8;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 3] == 0 & currmon == 7;
by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1 & bren1xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace bren1x = bren1x[_n - 1]*0.5 + bren1x[_n + 1]*0.5 if bren1xM == 1 & bren1xM[_n - 1] == 0 & bren1xM[_n + 1] == 0;
by id: replace bren1x = bren1x[_n - 1]*0.7 + bren1x[_n + 2]*0.3 if bren1xM == 1 & bren1xM[_n - 1] == 0 & bren1xM[_n + 2] == 0;
by id: replace bren1x = bren1x[_n - 2]*0.3 + bren1x[_n + 1]*0.7 if bren1xM == 1 & bren1xM[_n - 2] == 0 & bren1xM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace bren1x = bren0x[_n - 1] if bren1xM == 1 & bren1xM[_n - 1] == 0;
by id: replace bren1x = bren0x[_n - 2] if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 0;
by id: replace bren1x = bren0x[_n - 1] if bren1xM == 1 & bren1xM[_n - 1] == 0 & bren1xM[_n + 1] == 1;

/** Establish dbbrents by unicode, state, region **/

gen bren1xaggb = bren1x*beds1x;
replace bren1xaggb = . if beds1x == 0;
gen bren1xinvb = beds1x;
replace bren1xinvb = . if bren1xaggb == .;

bysort unicode yr sem: egen bren1a1 = sum(bren1xaggb);
bysort unicode yr sem: egen bren1inv1 = sum(bren1xinvb);
bysort unicode yr sem: gen db1brenuni = bren1a1/bren1inv1;

bysort state yr sem: egen bren1a2 = sum(bren1xaggb);
bysort state yr sem: egen bren1inv2 = sum(bren1xinvb);
bysort state yr sem: gen db1stateunibed = bren1a2/bren1inv2;

bysort r1to5 yr sem: egen bren1a3 = sum(bren1xaggb);
bysort r1to5 yr sem: egen bren1inv3 = sum(bren1xinvb);
bysort r1to5 yr sem: gen db1regunibed = bren1a3/bren1inv3;

sort id yr qtr currmon;

/** bren2x **/

sort id yr qtr currmon;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 2] == 0 & currmon == 3;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 3] == 0 & currmon == 4;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 4] == 0 & currmon == 5;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 2] == 0 & currmon == 7;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 3] == 0 & currmon == 8;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 4] == 0 & currmon == 9;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 2] == 0 & currmon == 11;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 3] == 0 & currmon == 12;

by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 2] == 0 & currmon == 4;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 3] == 0 & currmon == 5;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 4] == 0 & currmon == 6;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 2] == 0 & currmon == 8;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 3] == 0 & currmon == 9;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 4] == 0 & currmon == 10;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 2] == 0 & currmon == 12;

by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 2] == 0 & currmon == 5;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 3] == 0 & currmon == 6;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 4] == 0 & currmon == 7;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 2] == 0 & currmon == 9;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 3] == 0 & currmon == 10;
by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2xM == 1 & bren2xM[_n - 4] == 0 & currmon == 11;

by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 2] == 0 & currmon == 2;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 3] == 0 & currmon == 1;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 2] == 0 & currmon == 6;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 3] == 0 & currmon == 5;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 4] == 0 & currmon == 4;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 2] == 0 & currmon == 10;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 3] == 0 & currmon == 9;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 4] == 0 & currmon == 8;

by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 2] == 0 & currmon == 1;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 2] == 0 & currmon == 5;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 3] == 0 & currmon == 4;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 4] == 0 & currmon == 3;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 2] == 0 & currmon == 9;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 3] == 0 & currmon == 8;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 4] == 0 & currmon == 7;

by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 2] == 0 & currmon == 4;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 3] == 0 & currmon == 3;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 4] == 0 & currmon == 2;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 2] == 0 & currmon == 8;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 3] == 0 & currmon == 7;
by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1 & bren2xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace bren2x = bren2x[_n - 1]*0.5 + bren2x[_n + 1]*0.5 if bren2xM == 1 & bren2xM[_n - 1] == 0 & bren2xM[_n + 1] == 0;
by id: replace bren2x = bren2x[_n - 1]*0.7 + bren2x[_n + 2]*0.3 if bren2xM == 1 & bren2xM[_n - 1] == 0 & bren2xM[_n + 2] == 0;
by id: replace bren2x = bren2x[_n - 2]*0.3 + bren2x[_n + 1]*0.7 if bren2xM == 1 & bren2xM[_n - 2] == 0 & bren2xM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace bren2x = bren2x[_n - 1] if bren2xM == 1 & bren2xM[_n - 1] == 0;
by id: replace bren2x = bren2x[_n - 2] if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 0;
by id: replace bren2x = bren2x[_n - 1] if bren2xM == 1 & bren2xM[_n - 1] == 0 & bren2xM[_n + 1] == 1;

/** Establish dbbrents by unicode, state, region **/

gen bren2xaggb = bren2x*beds2x;
replace bren2xaggb = . if beds2x == 0;
gen bren2xinvb = beds2x;
replace bren2xinvb = . if bren2xaggb == .;

bysort unicode yr sem: egen bren2a1 = sum(bren2xaggb);
bysort unicode yr sem: egen bren2inv1 = sum(bren2xinvb);
bysort unicode yr sem: gen db2brenuni = bren2a1/bren2inv1;

bysort state yr sem: egen bren2a2 = sum(bren2xaggb);
bysort state yr sem: egen bren2inv2 = sum(bren2xinvb);
bysort state yr sem: gen db2stateunibed = bren2a2/bren2inv2;

bysort r1to5 yr sem: egen bren2a3 = sum(bren2xaggb);
bysort r1to5 yr sem: egen bren2inv3 = sum(bren2xinvb);
bysort r1to5 yr sem: gen db2regunibed = bren2a3/bren2inv3;

sort id yr qtr currmon;

/** bren3x **/

sort id yr qtr currmon;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 2] == 0 & currmon == 3;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 3] == 0 & currmon == 4;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 4] == 0 & currmon == 5;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 2] == 0 & currmon == 7;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 3] == 0 & currmon == 8;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 4] == 0 & currmon == 9;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 2] == 0 & currmon == 11;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 3] == 0 & currmon == 12;

by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 2] == 0 & currmon == 4;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 3] == 0 & currmon == 5;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 4] == 0 & currmon == 6;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 2] == 0 & currmon == 8;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 3] == 0 & currmon == 9;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 4] == 0 & currmon == 10;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 2] == 0 & currmon == 12;

by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 2] == 0 & currmon == 5;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 3] == 0 & currmon == 6;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 4] == 0 & currmon == 7;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 2] == 0 & currmon == 9;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 3] == 0 & currmon == 10;
by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3xM == 1 & bren3xM[_n - 4] == 0 & currmon == 11;

by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 2] == 0 & currmon == 2;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 3] == 0 & currmon == 1;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 2] == 0 & currmon == 6;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 3] == 0 & currmon == 5;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 4] == 0 & currmon == 4;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 2] == 0 & currmon == 10;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 3] == 0 & currmon == 9;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 4] == 0 & currmon == 8;

by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 2] == 0 & currmon == 1;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 2] == 0 & currmon == 5;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 3] == 0 & currmon == 4;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 4] == 0 & currmon == 3;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 2] == 0 & currmon == 9;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 3] == 0 & currmon == 8;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 4] == 0 & currmon == 7;

by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 2] == 0 & currmon == 4;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 3] == 0 & currmon == 3;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 4] == 0 & currmon == 2;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 2] == 0 & currmon == 8;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 3] == 0 & currmon == 7;
by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1 & bren3xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace bren3x = bren3x[_n - 1]*0.5 + bren3x[_n + 1]*0.5 if bren3xM == 1 & bren3xM[_n - 1] == 0 & bren3xM[_n + 1] == 0;
by id: replace bren3x = bren3x[_n - 1]*0.7 + bren3x[_n + 2]*0.3 if bren3xM == 1 & bren3xM[_n - 1] == 0 & bren3xM[_n + 2] == 0;
by id: replace bren3x = bren3x[_n - 2]*0.3 + bren3x[_n + 1]*0.7 if bren3xM == 1 & bren3xM[_n - 2] == 0 & bren3xM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace bren3x = bren3x[_n - 1] if bren3xM == 1 & bren3xM[_n - 1] == 0;
by id: replace bren3x = bren3x[_n - 2] if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 0;
by id: replace bren3x = bren3x[_n - 1] if bren3xM == 1 & bren3xM[_n - 1] == 0 & bren3xM[_n + 1] == 1;

/** Establish dbbrents by unicode, state, region **/

gen bren3xaggb = bren3x*beds3x;
replace bren3xaggb = . if beds3x == 0;
gen bren3xinvb = beds3x;
replace bren3xinvb = . if bren3xaggb == .;

bysort unicode yr sem: egen bren3a1 = sum(bren3xaggb);
bysort unicode yr sem: egen bren3inv1 = sum(bren3xinvb);
bysort unicode yr sem: gen db3brenuni = bren3a1/bren3inv1;

bysort state yr sem: egen bren3a2 = sum(bren3xaggb);
bysort state yr sem: egen bren3inv2 = sum(bren3xinvb);
bysort state yr sem: gen db3stateunibed = bren3a2/bren3inv2;

bysort r1to5 yr sem: egen bren3a3 = sum(bren3xaggb);
bysort r1to5 yr sem: egen bren3inv3 = sum(bren3xinvb);
bysort r1to5 yr sem: gen db3regunibed = bren3a3/bren3inv3;

sort id yr qtr currmon;

/** bren4x **/

sort id yr qtr currmon;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 2] == 0 & currmon == 3;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 3] == 0 & currmon == 4;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 4] == 0 & currmon == 5;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 2] == 0 & currmon == 7;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 3] == 0 & currmon == 8;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 4] == 0 & currmon == 9;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 2] == 0 & currmon == 11;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 3] == 0 & currmon == 12;

by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 2] == 0 & currmon == 4;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 3] == 0 & currmon == 5;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 4] == 0 & currmon == 6;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 2] == 0 & currmon == 8;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 3] == 0 & currmon == 9;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 4] == 0 & currmon == 10;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 2] == 0 & currmon == 12;

by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 2] == 0 & currmon == 5;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 3] == 0 & currmon == 6;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 4] == 0 & currmon == 7;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 2] == 0 & currmon == 9;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 3] == 0 & currmon == 10;
by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4xM == 1 & bren4xM[_n - 4] == 0 & currmon == 11;

by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 2] == 0 & currmon == 2;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 3] == 0 & currmon == 1;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 2] == 0 & currmon == 6;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 3] == 0 & currmon == 5;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 4] == 0 & currmon == 4;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 2] == 0 & currmon == 10;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 3] == 0 & currmon == 9;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 4] == 0 & currmon == 8;

by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 2] == 0 & currmon == 1;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 2] == 0 & currmon == 5;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 3] == 0 & currmon == 4;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 4] == 0 & currmon == 3;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 2] == 0 & currmon == 9;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 3] == 0 & currmon == 8;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 4] == 0 & currmon == 7;

by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 2] == 0 & currmon == 4;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 3] == 0 & currmon == 3;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 4] == 0 & currmon == 2;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 2] == 0 & currmon == 8;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 3] == 0 & currmon == 7;
by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1 & bren4xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace bren4x = bren4x[_n - 1]*0.5 + bren4x[_n + 1]*0.5 if bren4xM == 1 & bren4xM[_n - 1] == 0 & bren4xM[_n + 1] == 0;
by id: replace bren4x = bren4x[_n - 1]*0.7 + bren4x[_n + 2]*0.3 if bren4xM == 1 & bren4xM[_n - 1] == 0 & bren4xM[_n + 2] == 0;
by id: replace bren4x = bren4x[_n - 2]*0.3 + bren4x[_n + 1]*0.7 if bren4xM == 1 & bren4xM[_n - 2] == 0 & bren4xM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace bren4x = bren4x[_n - 1] if bren4xM == 1 & bren4xM[_n - 1] == 0;
by id: replace bren4x = bren4x[_n - 2] if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 0;
by id: replace bren4x = bren4x[_n - 1] if bren4xM == 1 & bren4xM[_n - 1] == 0 & bren4xM[_n + 1] == 1;

/** Establish dbbrents by unicode, state, region **/

gen bren4xaggb = bren4x*beds4x;
replace bren4xaggb = . if beds4x == 0;
gen bren4xinvb = beds4x;
replace bren4xinvb = . if bren4xaggb == .;

bysort unicode yr sem: egen bren4a1 = sum(bren4xaggb);
bysort unicode yr sem: egen bren4inv1 = sum(bren4xinvb);
bysort unicode yr sem: gen db4brenuni = bren4a1/bren4inv1;

bysort state yr sem: egen bren4a2 = sum(bren4xaggb);
bysort state yr sem: egen bren4inv2 = sum(bren4xinvb);
bysort state yr sem: gen db4stateunibed = bren4a2/bren4inv2;

bysort r1to5 yr sem: egen bren4a3 = sum(bren4xaggb);
bysort r1to5 yr sem: egen bren4inv3 = sum(bren4xinvb);
bysort r1to5 yr sem: gen db4regunibed = bren4a3/bren4inv3;

sort id yr qtr currmon;

/** Rationalize DB brents **/

#delimit;
gen db0bren = db0brenuni;
gen db1bren = db1brenuni;
gen db2bren = db2brenuni;
gen db3bren = db3brenuni;
gen db4bren = db4brenuni;

gen dbavgren = dbaren;
replace dbavgren = dbarenstate if dbaren == .;
replace dbavgren = dbarenreg if dbaren == .;

replace db0bren = db0stateunibed if db0bren == .;
replace db1bren = db1stateunibed if db1bren == .;
replace db2bren = db2stateunibed if db2bren == .;
replace db3bren = db3stateunibed if db3bren == .;
replace db4bren = db4stateunibed if db4bren == .;

replace db0bren = db0regunibed if db0bren == .;
replace db1bren = db1regunibed if db1bren == .;
replace db2bren = db2regunibed if db2bren == .;
replace db3bren = db3regunibed if db3bren == .;
replace db4bren = db4regunibed if db4bren == .;

by id: replace db2bren = 0.95*db1bren if db2bren > db1bren;
by id: replace db3bren = 0.95*db2bren if db3bren > db2bren;
by id: replace db4bren = 0.95*db3bren if db4bren > db3bren;

/** Fill in values given dbbren assignments **/

/** Gen RAND **/
	 
gen unif1 = uniform();
gen unif95 = unif1*(1.05 - 0.95) + 0.95;

sort id yr sem;

by id: egen arenct = count(avgrenx);

by id: egen bren0xct = count(bren0x);
by id: egen bren1xct = count(bren1x);
by id: egen bren2xct = count(bren2x);
by id: egen bren3xct = count(bren3x);
by id: egen bren4xct = count(bren4x);

sort id yr qtr currmon;

by id: replace avgrenx = dbavgren*unif95 if arenct == 0 & avgrenxM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);

by id: replace bren0x = db0regunibed*unif95 if bren0xct == 0 & bren0xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace bren1x = db1regunibed*unif95 if bren1xct == 0 & bren1xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace bren2x = db2regunibed*unif95 if bren2xct == 0 & bren2xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace bren3x = db3regunibed*unif95 if bren3xct == 0 & bren3xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace bren4x = db4regunibed*unif95 if bren4xct == 0 & bren4xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);

/** Move that shiznits forward! **/   
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1;

     local d = `d' + 1;

   };
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1;

     local d = `d' + 1;

   };     
   
/** And backwardss! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenx == . & avgrenxM == 1;

     local d = `d' + 1;

   };
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0x == . & bren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1x == . & bren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2x == . & bren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3x == . & bren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4x == . & bren4xM == 1;

     local d = `d' + 1;

   };       
   
/** Moderate intersemestral changes **/

by id: replace avgrenx = avgrenx[_n - 1]*0.5 + avgrenx[_n + 1]*0.5 if avgrenxM == 1 & (currmon == 5 | currmon == 9);
by id: replace avgrenx = avgrenx[_n - 1]*0.5 + avgrenx[_n + 1]*0.5 if avgrenxM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace bren0x = bren0x[_n - 1]*0.5 + bren0x[_n + 1]*0.5 if bren0xM == 1 & (currmon == 5 | currmon == 9);
by id: replace bren0x = bren0x[_n - 1]*0.5 + bren0x[_n + 1]*0.5 if bren0xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace bren1x = bren1x[_n - 1]*0.5 + bren1x[_n + 1]*0.5 if bren1xM == 1 & (currmon == 5 | currmon == 9);
by id: replace bren1x = bren1x[_n - 1]*0.5 + bren1x[_n + 1]*0.5 if bren1xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace bren2x = bren2x[_n - 1]*0.5 + bren2x[_n + 1]*0.5 if bren2xM == 1 & (currmon == 5 | currmon == 9);
by id: replace bren2x = bren2x[_n - 1]*0.5 + bren2x[_n + 1]*0.5 if bren2xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace bren3x = bren3x[_n - 1]*0.5 + bren3x[_n + 1]*0.5 if bren3xM == 1 & (currmon == 5 | currmon == 9);
by id: replace bren3x = bren3x[_n - 1]*0.5 + bren3x[_n + 1]*0.5 if bren3xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace bren4x = bren4x[_n - 1]*0.5 + bren4x[_n + 1]*0.5 if bren4xM == 1 & (currmon == 5 | currmon == 9);
by id: replace bren4x = bren4x[_n - 1]*0.5 + bren4x[_n + 1]*0.5 if bren4xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

/** Moderate stretches of "no survey" **/

by id: replace avgrenx = avgrenx[_n - 1]*0.8 + avgrenx[_n + 3]*0.2 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n + 1] == 1 & avgrenxM[_n + 2] == 1 
       & avgrenxM[_n + 3] == 1 & currmon == 2;
by id: replace avgrenx = avgrenx[_n - 2]*0.5 + avgrenx[_n + 2]*0.5 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n + 1] == 1 
       & avgrenxM[_n + 2] == 1 & currmon == 3;   
by id: replace avgrenx = avgrenx[_n - 3]*0.2 + avgrenx[_n + 3]*0.8 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n - 3] == 1 
       & avgrenxM[_n + 1] == 1 & currmon == 4;  
by id: replace avgrenx = avgrenx[_n - 1]*0.8 + avgrenx[_n + 3]*0.2 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n + 1] == 1 & avgrenxM[_n + 2] == 1 
       & avgrenxM[_n + 3] == 1 & currmon == 4;
by id: replace avgrenx = avgrenx[_n - 2]*0.5 + avgrenx[_n + 2]*0.5 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n + 1] == 1 
       & avgrenxM[_n + 2] == 1 & currmon == 5;   
by id: replace avgrenx = avgrenx[_n - 3]*0.2 + avgrenx[_n + 3]*0.8 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n - 3] == 1 
       & avgrenxM[_n + 1] == 1 & currmon == 6;       
by id: replace avgrenx = avgrenx[_n - 1]*0.8 + avgrenx[_n + 3]*0.2 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n + 1] == 1 & avgrenxM[_n + 2] == 1 
       & avgrenxM[_n + 3] == 1 & currmon == 5;
by id: replace avgrenx = avgrenx[_n - 2]*0.5 + avgrenx[_n + 2]*0.5 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n + 1] == 1 
       & avgrenxM[_n + 2] == 1 & currmon == 6;   
by id: replace avgrenx = avgrenx[_n - 3]*0.2 + avgrenx[_n + 3]*0.8 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n - 3] == 1 
       & avgrenxM[_n + 1] == 1 & currmon == 7;
by id: replace avgrenx = avgrenx[_n - 1]*0.8 + avgrenx[_n + 3]*0.2 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n + 1] == 1 & avgrenxM[_n + 2] == 1 
       & avgrenxM[_n + 3] == 1 & currmon == 6;
by id: replace avgrenx = avgrenx[_n - 2]*0.5 + avgrenx[_n + 2]*0.5 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n + 1] == 1 
       & avgrenxM[_n + 2] == 1 & currmon == 7;   
by id: replace avgrenx = avgrenx[_n - 3]*0.2 + avgrenx[_n + 3]*0.8 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n - 3] == 1 
       & avgrenxM[_n + 1] == 1 & currmon == 8;       
by id: replace avgrenx = avgrenx[_n - 1]*0.8 + avgrenx[_n + 3]*0.2 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n + 1] == 1 & avgrenxM[_n + 2] == 1 
       & avgrenxM[_n + 3] == 1 & currmon == 7;
by id: replace avgrenx = avgrenx[_n - 2]*0.5 + avgrenx[_n + 2]*0.5 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n + 1] == 1 
       & avgrenxM[_n + 2] == 1 & currmon == 8;   
by id: replace avgrenx = avgrenx[_n - 3]*0.2 + avgrenx[_n + 3]*0.8 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n - 3] == 1 
       & avgrenxM[_n + 1] == 1 & currmon == 9;
by id: replace avgrenx = avgrenx[_n - 1]*0.8 + avgrenx[_n + 3]*0.2 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n + 1] == 1 & avgrenxM[_n + 2] == 1 
       & avgrenxM[_n + 3] == 1 & currmon == 8;
by id: replace avgrenx = avgrenx[_n - 2]*0.5 + avgrenx[_n + 2]*0.5 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n + 1] == 1 
       & avgrenxM[_n + 2] == 1 & currmon == 9;   
by id: replace avgrenx = avgrenx[_n - 3]*0.2 + avgrenx[_n + 3]*0.8 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n - 3] == 1 
       & avgrenxM[_n + 1] == 1 & currmon == 10;
by id: replace avgrenx = avgrenx[_n - 1]*0.8 + avgrenx[_n + 3]*0.2 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n + 1] == 1 & avgrenxM[_n + 2] == 1 
       & avgrenxM[_n + 3] == 1 & currmon == 9;
by id: replace avgrenx = avgrenx[_n - 2]*0.5 + avgrenx[_n + 2]*0.5 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n + 1] == 1 
       & avgrenxM[_n + 2] == 1 & currmon == 10;   
by id: replace avgrenx = avgrenx[_n - 3]*0.2 + avgrenx[_n + 3]*0.8 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n - 3] == 1 
       & avgrenxM[_n + 1] == 1 & currmon == 11;       
by id: replace avgrenx = avgrenx[_n - 1]*0.8 + avgrenx[_n + 3]*0.2 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n + 1] == 1 & avgrenxM[_n + 2] == 1 
       & avgrenxM[_n + 3] == 1 & currmon == 10;
by id: replace avgrenx = avgrenx[_n - 2]*0.5 + avgrenx[_n + 2]*0.5 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n + 1] == 1 
       & avgrenxM[_n + 2] == 1 & currmon == 11;   
by id: replace avgrenx = avgrenx[_n - 3]*0.2 + avgrenx[_n + 3]*0.8 if avgrenxM == 1 & avgrenxM[_n - 1] == 1 & avgrenxM[_n - 2] == 1 & avgrenxM[_n - 3] == 1 
       & avgrenxM[_n + 1] == 1 & currmon == 12; 

by id: replace bren0x = bren0x[_n - 1]*0.8 + bren0x[_n + 3]*0.2 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n + 1] == 1 & bren0xM[_n + 2] == 1 
       & bren0xM[_n + 3] == 1 & currmon == 2;
by id: replace bren0x = bren0x[_n - 2]*0.5 + bren0x[_n + 2]*0.5 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n + 1] == 1 
       & bren0xM[_n + 2] == 1 & currmon == 3;   
by id: replace bren0x = bren0x[_n - 3]*0.2 + bren0x[_n + 3]*0.8 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n - 3] == 1 
       & bren0xM[_n + 1] == 1 & currmon == 4;  
by id: replace bren0x = bren0x[_n - 1]*0.8 + bren0x[_n + 3]*0.2 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n + 1] == 1 & bren0xM[_n + 2] == 1 
       & bren0xM[_n + 3] == 1 & currmon == 4;
by id: replace bren0x = bren0x[_n - 2]*0.5 + bren0x[_n + 2]*0.5 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n + 1] == 1 
       & bren0xM[_n + 2] == 1 & currmon == 5;   
by id: replace bren0x = bren0x[_n - 3]*0.2 + bren0x[_n + 3]*0.8 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n - 3] == 1 
       & bren0xM[_n + 1] == 1 & currmon == 6;       
by id: replace bren0x = bren0x[_n - 1]*0.8 + bren0x[_n + 3]*0.2 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n + 1] == 1 & bren0xM[_n + 2] == 1 
       & bren0xM[_n + 3] == 1 & currmon == 5;
by id: replace bren0x = bren0x[_n - 2]*0.5 + bren0x[_n + 2]*0.5 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n + 1] == 1 
       & bren0xM[_n + 2] == 1 & currmon == 6;   
by id: replace bren0x = bren0x[_n - 3]*0.2 + bren0x[_n + 3]*0.8 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n - 3] == 1 
       & bren0xM[_n + 1] == 1 & currmon == 7;
by id: replace bren0x = bren0x[_n - 1]*0.8 + bren0x[_n + 3]*0.2 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n + 1] == 1 & bren0xM[_n + 2] == 1 
       & bren0xM[_n + 3] == 1 & currmon == 6;
by id: replace bren0x = bren0x[_n - 2]*0.5 + bren0x[_n + 2]*0.5 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n + 1] == 1 
       & bren0xM[_n + 2] == 1 & currmon == 7;   
by id: replace bren0x = bren0x[_n - 3]*0.2 + bren0x[_n + 3]*0.8 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n - 3] == 1 
       & bren0xM[_n + 1] == 1 & currmon == 8;       
by id: replace bren0x = bren0x[_n - 1]*0.8 + bren0x[_n + 3]*0.2 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n + 1] == 1 & bren0xM[_n + 2] == 1 
       & bren0xM[_n + 3] == 1 & currmon == 7;
by id: replace bren0x = bren0x[_n - 2]*0.5 + bren0x[_n + 2]*0.5 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n + 1] == 1 
       & bren0xM[_n + 2] == 1 & currmon == 8;   
by id: replace bren0x = bren0x[_n - 3]*0.2 + bren0x[_n + 3]*0.8 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n - 3] == 1 
       & bren0xM[_n + 1] == 1 & currmon == 9;
by id: replace bren0x = bren0x[_n - 1]*0.8 + bren0x[_n + 3]*0.2 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n + 1] == 1 & bren0xM[_n + 2] == 1 
       & bren0xM[_n + 3] == 1 & currmon == 8;
by id: replace bren0x = bren0x[_n - 2]*0.5 + bren0x[_n + 2]*0.5 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n + 1] == 1 
       & bren0xM[_n + 2] == 1 & currmon == 9;   
by id: replace bren0x = bren0x[_n - 3]*0.2 + bren0x[_n + 3]*0.8 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n - 3] == 1 
       & bren0xM[_n + 1] == 1 & currmon == 10;
by id: replace bren0x = bren0x[_n - 1]*0.8 + bren0x[_n + 3]*0.2 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n + 1] == 1 & bren0xM[_n + 2] == 1 
       & bren0xM[_n + 3] == 1 & currmon == 9;
by id: replace bren0x = bren0x[_n - 2]*0.5 + bren0x[_n + 2]*0.5 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n + 1] == 1 
       & bren0xM[_n + 2] == 1 & currmon == 10;   
by id: replace bren0x = bren0x[_n - 3]*0.2 + bren0x[_n + 3]*0.8 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n - 3] == 1 
       & bren0xM[_n + 1] == 1 & currmon == 11;       
by id: replace bren0x = bren0x[_n - 1]*0.8 + bren0x[_n + 3]*0.2 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n + 1] == 1 & bren0xM[_n + 2] == 1 
       & bren0xM[_n + 3] == 1 & currmon == 10;
by id: replace bren0x = bren0x[_n - 2]*0.5 + bren0x[_n + 2]*0.5 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n + 1] == 1 
       & bren0xM[_n + 2] == 1 & currmon == 11;   
by id: replace bren0x = bren0x[_n - 3]*0.2 + bren0x[_n + 3]*0.8 if bren0xM == 1 & bren0xM[_n - 1] == 1 & bren0xM[_n - 2] == 1 & bren0xM[_n - 3] == 1 
       & bren0xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace bren1x = bren1x[_n - 1]*0.8 + bren1x[_n + 3]*0.2 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n + 1] == 1 & bren1xM[_n + 2] == 1 
       & bren1xM[_n + 3] == 1 & currmon == 2;
by id: replace bren1x = bren1x[_n - 2]*0.5 + bren1x[_n + 2]*0.5 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n + 1] == 1 
       & bren1xM[_n + 2] == 1 & currmon == 3;   
by id: replace bren1x = bren1x[_n - 3]*0.2 + bren1x[_n + 3]*0.8 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n - 3] == 1 
       & bren1xM[_n + 1] == 1 & currmon == 4;  
by id: replace bren1x = bren1x[_n - 1]*0.8 + bren1x[_n + 3]*0.2 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n + 1] == 1 & bren1xM[_n + 2] == 1 
       & bren1xM[_n + 3] == 1 & currmon == 4;
by id: replace bren1x = bren1x[_n - 2]*0.5 + bren1x[_n + 2]*0.5 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n + 1] == 1 
       & bren1xM[_n + 2] == 1 & currmon == 5;   
by id: replace bren1x = bren1x[_n - 3]*0.2 + bren1x[_n + 3]*0.8 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n - 3] == 1 
       & bren1xM[_n + 1] == 1 & currmon == 6;       
by id: replace bren1x = bren1x[_n - 1]*0.8 + bren1x[_n + 3]*0.2 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n + 1] == 1 & bren1xM[_n + 2] == 1 
       & bren1xM[_n + 3] == 1 & currmon == 5;
by id: replace bren1x = bren1x[_n - 2]*0.5 + bren1x[_n + 2]*0.5 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n + 1] == 1 
       & bren1xM[_n + 2] == 1 & currmon == 6;   
by id: replace bren1x = bren1x[_n - 3]*0.2 + bren1x[_n + 3]*0.8 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n - 3] == 1 
       & bren1xM[_n + 1] == 1 & currmon == 7;
by id: replace bren1x = bren1x[_n - 1]*0.8 + bren1x[_n + 3]*0.2 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n + 1] == 1 & bren1xM[_n + 2] == 1 
       & bren1xM[_n + 3] == 1 & currmon == 6;
by id: replace bren1x = bren1x[_n - 2]*0.5 + bren1x[_n + 2]*0.5 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n + 1] == 1 
       & bren1xM[_n + 2] == 1 & currmon == 7;   
by id: replace bren1x = bren1x[_n - 3]*0.2 + bren1x[_n + 3]*0.8 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n - 3] == 1 
       & bren1xM[_n + 1] == 1 & currmon == 8;       
by id: replace bren1x = bren1x[_n - 1]*0.8 + bren1x[_n + 3]*0.2 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n + 1] == 1 & bren1xM[_n + 2] == 1 
       & bren1xM[_n + 3] == 1 & currmon == 7;
by id: replace bren1x = bren1x[_n - 2]*0.5 + bren1x[_n + 2]*0.5 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n + 1] == 1 
       & bren1xM[_n + 2] == 1 & currmon == 8;   
by id: replace bren1x = bren1x[_n - 3]*0.2 + bren1x[_n + 3]*0.8 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n - 3] == 1 
       & bren1xM[_n + 1] == 1 & currmon == 9;
by id: replace bren1x = bren1x[_n - 1]*0.8 + bren1x[_n + 3]*0.2 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n + 1] == 1 & bren1xM[_n + 2] == 1 
       & bren1xM[_n + 3] == 1 & currmon == 8;
by id: replace bren1x = bren1x[_n - 2]*0.5 + bren1x[_n + 2]*0.5 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n + 1] == 1 
       & bren1xM[_n + 2] == 1 & currmon == 9;   
by id: replace bren1x = bren1x[_n - 3]*0.2 + bren1x[_n + 3]*0.8 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n - 3] == 1 
       & bren1xM[_n + 1] == 1 & currmon == 10;
by id: replace bren1x = bren1x[_n - 1]*0.8 + bren1x[_n + 3]*0.2 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n + 1] == 1 & bren1xM[_n + 2] == 1 
       & bren1xM[_n + 3] == 1 & currmon == 9;
by id: replace bren1x = bren1x[_n - 2]*0.5 + bren1x[_n + 2]*0.5 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n + 1] == 1 
       & bren1xM[_n + 2] == 1 & currmon == 10;   
by id: replace bren1x = bren1x[_n - 3]*0.2 + bren1x[_n + 3]*0.8 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n - 3] == 1 
       & bren1xM[_n + 1] == 1 & currmon == 11;       
by id: replace bren1x = bren1x[_n - 1]*0.8 + bren1x[_n + 3]*0.2 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n + 1] == 1 & bren1xM[_n + 2] == 1 
       & bren1xM[_n + 3] == 1 & currmon == 10;
by id: replace bren1x = bren1x[_n - 2]*0.5 + bren1x[_n + 2]*0.5 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n + 1] == 1 
       & bren1xM[_n + 2] == 1 & currmon == 11;   
by id: replace bren1x = bren1x[_n - 3]*0.2 + bren1x[_n + 3]*0.8 if bren1xM == 1 & bren1xM[_n - 1] == 1 & bren1xM[_n - 2] == 1 & bren1xM[_n - 3] == 1 
       & bren1xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace bren2x = bren2x[_n - 1]*0.8 + bren2x[_n + 3]*0.2 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n + 1] == 1 & bren2xM[_n + 2] == 1 
       & bren2xM[_n + 3] == 1 & currmon == 2;
by id: replace bren2x = bren2x[_n - 2]*0.5 + bren2x[_n + 2]*0.5 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n + 1] == 1 
       & bren2xM[_n + 2] == 1 & currmon == 3;   
by id: replace bren2x = bren2x[_n - 3]*0.2 + bren2x[_n + 3]*0.8 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n - 3] == 1 
       & bren2xM[_n + 1] == 1 & currmon == 4;  
by id: replace bren2x = bren2x[_n - 1]*0.8 + bren2x[_n + 3]*0.2 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n + 1] == 1 & bren2xM[_n + 2] == 1 
       & bren2xM[_n + 3] == 1 & currmon == 4;
by id: replace bren2x = bren2x[_n - 2]*0.5 + bren2x[_n + 2]*0.5 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n + 1] == 1 
       & bren2xM[_n + 2] == 1 & currmon == 5;   
by id: replace bren2x = bren2x[_n - 3]*0.2 + bren2x[_n + 3]*0.8 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n - 3] == 1 
       & bren2xM[_n + 1] == 1 & currmon == 6;       
by id: replace bren2x = bren2x[_n - 1]*0.8 + bren2x[_n + 3]*0.2 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n + 1] == 1 & bren2xM[_n + 2] == 1 
       & bren2xM[_n + 3] == 1 & currmon == 5;
by id: replace bren2x = bren2x[_n - 2]*0.5 + bren2x[_n + 2]*0.5 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n + 1] == 1 
       & bren2xM[_n + 2] == 1 & currmon == 6;   
by id: replace bren2x = bren2x[_n - 3]*0.2 + bren2x[_n + 3]*0.8 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n - 3] == 1 
       & bren2xM[_n + 1] == 1 & currmon == 7;
by id: replace bren2x = bren2x[_n - 1]*0.8 + bren2x[_n + 3]*0.2 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n + 1] == 1 & bren2xM[_n + 2] == 1 
       & bren2xM[_n + 3] == 1 & currmon == 6;
by id: replace bren2x = bren2x[_n - 2]*0.5 + bren2x[_n + 2]*0.5 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n + 1] == 1 
       & bren2xM[_n + 2] == 1 & currmon == 7;   
by id: replace bren2x = bren2x[_n - 3]*0.2 + bren2x[_n + 3]*0.8 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n - 3] == 1 
       & bren2xM[_n + 1] == 1 & currmon == 8;       
by id: replace bren2x = bren2x[_n - 1]*0.8 + bren2x[_n + 3]*0.2 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n + 1] == 1 & bren2xM[_n + 2] == 1 
       & bren2xM[_n + 3] == 1 & currmon == 7;
by id: replace bren2x = bren2x[_n - 2]*0.5 + bren2x[_n + 2]*0.5 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n + 1] == 1 
       & bren2xM[_n + 2] == 1 & currmon == 8;   
by id: replace bren2x = bren2x[_n - 3]*0.2 + bren2x[_n + 3]*0.8 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n - 3] == 1 
       & bren2xM[_n + 1] == 1 & currmon == 9;
by id: replace bren2x = bren2x[_n - 1]*0.8 + bren2x[_n + 3]*0.2 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n + 1] == 1 & bren2xM[_n + 2] == 1 
       & bren2xM[_n + 3] == 1 & currmon == 8;
by id: replace bren2x = bren2x[_n - 2]*0.5 + bren2x[_n + 2]*0.5 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n + 1] == 1 
       & bren2xM[_n + 2] == 1 & currmon == 9;   
by id: replace bren2x = bren2x[_n - 3]*0.2 + bren2x[_n + 3]*0.8 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n - 3] == 1 
       & bren2xM[_n + 1] == 1 & currmon == 10;
by id: replace bren2x = bren2x[_n - 1]*0.8 + bren2x[_n + 3]*0.2 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n + 1] == 1 & bren2xM[_n + 2] == 1 
       & bren2xM[_n + 3] == 1 & currmon == 9;
by id: replace bren2x = bren2x[_n - 2]*0.5 + bren2x[_n + 2]*0.5 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n + 1] == 1 
       & bren2xM[_n + 2] == 1 & currmon == 10;   
by id: replace bren2x = bren2x[_n - 3]*0.2 + bren2x[_n + 3]*0.8 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n - 3] == 1 
       & bren2xM[_n + 1] == 1 & currmon == 11;       
by id: replace bren2x = bren2x[_n - 1]*0.8 + bren2x[_n + 3]*0.2 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n + 1] == 1 & bren2xM[_n + 2] == 1 
       & bren2xM[_n + 3] == 1 & currmon == 10;
by id: replace bren2x = bren2x[_n - 2]*0.5 + bren2x[_n + 2]*0.5 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n + 1] == 1 
       & bren2xM[_n + 2] == 1 & currmon == 11;   
by id: replace bren2x = bren2x[_n - 3]*0.2 + bren2x[_n + 3]*0.8 if bren2xM == 1 & bren2xM[_n - 1] == 1 & bren2xM[_n - 2] == 1 & bren2xM[_n - 3] == 1 
       & bren2xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace bren3x = bren3x[_n - 1]*0.8 + bren3x[_n + 3]*0.2 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n + 1] == 1 & bren3xM[_n + 2] == 1 
       & bren3xM[_n + 3] == 1 & currmon == 2;
by id: replace bren3x = bren3x[_n - 2]*0.5 + bren3x[_n + 2]*0.5 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n + 1] == 1 
       & bren3xM[_n + 2] == 1 & currmon == 3;   
by id: replace bren3x = bren3x[_n - 3]*0.2 + bren3x[_n + 3]*0.8 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n - 3] == 1 
       & bren3xM[_n + 1] == 1 & currmon == 4;  
by id: replace bren3x = bren3x[_n - 1]*0.8 + bren3x[_n + 3]*0.2 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n + 1] == 1 & bren3xM[_n + 2] == 1 
       & bren3xM[_n + 3] == 1 & currmon == 4;
by id: replace bren3x = bren3x[_n - 2]*0.5 + bren3x[_n + 2]*0.5 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n + 1] == 1 
       & bren3xM[_n + 2] == 1 & currmon == 5;   
by id: replace bren3x = bren3x[_n - 3]*0.2 + bren3x[_n + 3]*0.8 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n - 3] == 1 
       & bren3xM[_n + 1] == 1 & currmon == 6;       
by id: replace bren3x = bren3x[_n - 1]*0.8 + bren3x[_n + 3]*0.2 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n + 1] == 1 & bren3xM[_n + 2] == 1 
       & bren3xM[_n + 3] == 1 & currmon == 5;
by id: replace bren3x = bren3x[_n - 2]*0.5 + bren3x[_n + 2]*0.5 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n + 1] == 1 
       & bren3xM[_n + 2] == 1 & currmon == 6;   
by id: replace bren3x = bren3x[_n - 3]*0.2 + bren3x[_n + 3]*0.8 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n - 3] == 1 
       & bren3xM[_n + 1] == 1 & currmon == 7;
by id: replace bren3x = bren3x[_n - 1]*0.8 + bren3x[_n + 3]*0.2 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n + 1] == 1 & bren3xM[_n + 2] == 1 
       & bren3xM[_n + 3] == 1 & currmon == 6;
by id: replace bren3x = bren3x[_n - 2]*0.5 + bren3x[_n + 2]*0.5 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n + 1] == 1 
       & bren3xM[_n + 2] == 1 & currmon == 7;   
by id: replace bren3x = bren3x[_n - 3]*0.2 + bren3x[_n + 3]*0.8 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n - 3] == 1 
       & bren3xM[_n + 1] == 1 & currmon == 8;       
by id: replace bren3x = bren3x[_n - 1]*0.8 + bren3x[_n + 3]*0.2 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n + 1] == 1 & bren3xM[_n + 2] == 1 
       & bren3xM[_n + 3] == 1 & currmon == 7;
by id: replace bren3x = bren3x[_n - 2]*0.5 + bren3x[_n + 2]*0.5 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n + 1] == 1 
       & bren3xM[_n + 2] == 1 & currmon == 8;   
by id: replace bren3x = bren3x[_n - 3]*0.2 + bren3x[_n + 3]*0.8 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n - 3] == 1 
       & bren3xM[_n + 1] == 1 & currmon == 9;
by id: replace bren3x = bren3x[_n - 1]*0.8 + bren3x[_n + 3]*0.2 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n + 1] == 1 & bren3xM[_n + 2] == 1 
       & bren3xM[_n + 3] == 1 & currmon == 8;
by id: replace bren3x = bren3x[_n - 2]*0.5 + bren3x[_n + 2]*0.5 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n + 1] == 1 
       & bren3xM[_n + 2] == 1 & currmon == 9;   
by id: replace bren3x = bren3x[_n - 3]*0.2 + bren3x[_n + 3]*0.8 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n - 3] == 1 
       & bren3xM[_n + 1] == 1 & currmon == 10;
by id: replace bren3x = bren3x[_n - 1]*0.8 + bren3x[_n + 3]*0.2 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n + 1] == 1 & bren3xM[_n + 2] == 1 
       & bren3xM[_n + 3] == 1 & currmon == 9;
by id: replace bren3x = bren3x[_n - 2]*0.5 + bren3x[_n + 2]*0.5 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n + 1] == 1 
       & bren3xM[_n + 2] == 1 & currmon == 10;   
by id: replace bren3x = bren3x[_n - 3]*0.2 + bren3x[_n + 3]*0.8 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n - 3] == 1 
       & bren3xM[_n + 1] == 1 & currmon == 11;       
by id: replace bren3x = bren3x[_n - 1]*0.8 + bren3x[_n + 3]*0.2 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n + 1] == 1 & bren3xM[_n + 2] == 1 
       & bren3xM[_n + 3] == 1 & currmon == 10;
by id: replace bren3x = bren3x[_n - 2]*0.5 + bren3x[_n + 2]*0.5 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n + 1] == 1 
       & bren3xM[_n + 2] == 1 & currmon == 11;   
by id: replace bren3x = bren3x[_n - 3]*0.2 + bren3x[_n + 3]*0.8 if bren3xM == 1 & bren3xM[_n - 1] == 1 & bren3xM[_n - 2] == 1 & bren3xM[_n - 3] == 1 
       & bren3xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace bren4x = bren4x[_n - 1]*0.8 + bren4x[_n + 3]*0.2 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n + 1] == 1 & bren4xM[_n + 2] == 1 
       & bren4xM[_n + 3] == 1 & currmon == 2;
by id: replace bren4x = bren4x[_n - 2]*0.5 + bren4x[_n + 2]*0.5 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n + 1] == 1 
       & bren4xM[_n + 2] == 1 & currmon == 3;   
by id: replace bren4x = bren4x[_n - 3]*0.2 + bren4x[_n + 3]*0.8 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n - 3] == 1 
       & bren4xM[_n + 1] == 1 & currmon == 4;  
by id: replace bren4x = bren4x[_n - 1]*0.8 + bren4x[_n + 3]*0.2 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n + 1] == 1 & bren4xM[_n + 2] == 1 
       & bren4xM[_n + 3] == 1 & currmon == 4;
by id: replace bren4x = bren4x[_n - 2]*0.5 + bren4x[_n + 2]*0.5 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n + 1] == 1 
       & bren4xM[_n + 2] == 1 & currmon == 5;   
by id: replace bren4x = bren4x[_n - 3]*0.2 + bren4x[_n + 3]*0.8 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n - 3] == 1 
       & bren4xM[_n + 1] == 1 & currmon == 6;       
by id: replace bren4x = bren4x[_n - 1]*0.8 + bren4x[_n + 3]*0.2 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n + 1] == 1 & bren4xM[_n + 2] == 1 
       & bren4xM[_n + 3] == 1 & currmon == 5;
by id: replace bren4x = bren4x[_n - 2]*0.5 + bren4x[_n + 2]*0.5 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n + 1] == 1 
       & bren4xM[_n + 2] == 1 & currmon == 6;   
by id: replace bren4x = bren4x[_n - 3]*0.2 + bren4x[_n + 3]*0.8 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n - 3] == 1 
       & bren4xM[_n + 1] == 1 & currmon == 7;
by id: replace bren4x = bren4x[_n - 1]*0.8 + bren4x[_n + 3]*0.2 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n + 1] == 1 & bren4xM[_n + 2] == 1 
       & bren4xM[_n + 3] == 1 & currmon == 6;
by id: replace bren4x = bren4x[_n - 2]*0.5 + bren4x[_n + 2]*0.5 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n + 1] == 1 
       & bren4xM[_n + 2] == 1 & currmon == 7;   
by id: replace bren4x = bren4x[_n - 3]*0.2 + bren4x[_n + 3]*0.8 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n - 3] == 1 
       & bren4xM[_n + 1] == 1 & currmon == 8;       
by id: replace bren4x = bren4x[_n - 1]*0.8 + bren4x[_n + 3]*0.2 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n + 1] == 1 & bren4xM[_n + 2] == 1 
       & bren4xM[_n + 3] == 1 & currmon == 7;
by id: replace bren4x = bren4x[_n - 2]*0.5 + bren4x[_n + 2]*0.5 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n + 1] == 1 
       & bren4xM[_n + 2] == 1 & currmon == 8;   
by id: replace bren4x = bren4x[_n - 3]*0.2 + bren4x[_n + 3]*0.8 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n - 3] == 1 
       & bren4xM[_n + 1] == 1 & currmon == 9;
by id: replace bren4x = bren4x[_n - 1]*0.8 + bren4x[_n + 3]*0.2 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n + 1] == 1 & bren4xM[_n + 2] == 1 
       & bren4xM[_n + 3] == 1 & currmon == 8;
by id: replace bren4x = bren4x[_n - 2]*0.5 + bren4x[_n + 2]*0.5 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n + 1] == 1 
       & bren4xM[_n + 2] == 1 & currmon == 9;   
by id: replace bren4x = bren4x[_n - 3]*0.2 + bren4x[_n + 3]*0.8 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n - 3] == 1 
       & bren4xM[_n + 1] == 1 & currmon == 10;
by id: replace bren4x = bren4x[_n - 1]*0.8 + bren4x[_n + 3]*0.2 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n + 1] == 1 & bren4xM[_n + 2] == 1 
       & bren4xM[_n + 3] == 1 & currmon == 9;
by id: replace bren4x = bren4x[_n - 2]*0.5 + bren4x[_n + 2]*0.5 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n + 1] == 1 
       & bren4xM[_n + 2] == 1 & currmon == 10;   
by id: replace bren4x = bren4x[_n - 3]*0.2 + bren4x[_n + 3]*0.8 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n - 3] == 1 
       & bren4xM[_n + 1] == 1 & currmon == 11;       
by id: replace bren4x = bren4x[_n - 1]*0.8 + bren4x[_n + 3]*0.2 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n + 1] == 1 & bren4xM[_n + 2] == 1 
       & bren4xM[_n + 3] == 1 & currmon == 10;
by id: replace bren4x = bren4x[_n - 2]*0.5 + bren4x[_n + 2]*0.5 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n + 1] == 1 
       & bren4xM[_n + 2] == 1 & currmon == 11;   
by id: replace bren4x = bren4x[_n - 3]*0.2 + bren4x[_n + 3]*0.8 if bren4xM == 1 & bren4xM[_n - 1] == 1 & bren4xM[_n - 2] == 1 & bren4xM[_n - 3] == 1 
       & bren4xM[_n + 1] == 1 & currmon == 12; 	   
	   
/** Move that shiznits forward! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace avgrenx = avgrenx[_n + 1]/(1 + mcpid) if avgrenx == . & avgrenxM == 1;

     local d = `d' + 1;

   };
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren0x = bren0x[_n + 1]/(1 + mcpid) if bren0x == . & bren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren1x = bren1x[_n + 1]/(1 + mcpid) if bren1x == . & bren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren2x = bren2x[_n + 1]/(1 + mcpid) if bren2x == . & bren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren3x = bren3x[_n + 1]/(1 + mcpid) if bren3x == . & bren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren4x = bren4x[_n + 1]/(1 + mcpid) if bren4x == . & bren4xM == 1;

     local d = `d' + 1;

   };     
   
/** And backwardss! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace avgrenx = avgrenx[_n - 1]*(1 + mcpid) if avgrenx == . & avgrenxM == 1;

     local d = `d' + 1;

   };
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren0x = bren0x[_n - 1]*(1 + mcpid) if bren0x == . & bren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren1x = bren1x[_n - 1]*(1 + mcpid) if bren1x == . & bren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren2x = bren2x[_n - 1]*(1 + mcpid) if bren2x == . & bren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren3x = bren3x[_n - 1]*(1 + mcpid) if bren3x == . & bren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace bren4x = bren4x[_n - 1]*(1 + mcpid) if bren4x == . & bren4xM == 1;

     local d = `d' + 1;

   };   	   

   /** Expand pool given surveyed levels **/

/** uren0x **/

sort id yr qtr currmon;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 2] == 0 & currmon == 3;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 3] == 0 & currmon == 4;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 4] == 0 & currmon == 5;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 2] == 0 & currmon == 7;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 3] == 0 & currmon == 8;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 4] == 0 & currmon == 9;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 2] == 0 & currmon == 11;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 3] == 0 & currmon == 12;

by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 2] == 0 & currmon == 4;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 3] == 0 & currmon == 5;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 4] == 0 & currmon == 6;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 2] == 0 & currmon == 8;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 3] == 0 & currmon == 9;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 4] == 0 & currmon == 10;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 2] == 0 & currmon == 12;

by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 2] == 0 & currmon == 5;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 3] == 0 & currmon == 6;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 4] == 0 & currmon == 7;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 2] == 0 & currmon == 9;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 3] == 0 & currmon == 10;
by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0xM == 1 & uren0xM[_n - 4] == 0 & currmon == 11;

by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 2] == 0 & currmon == 2;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 3] == 0 & currmon == 1;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 2] == 0 & currmon == 6;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 3] == 0 & currmon == 5;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 4] == 0 & currmon == 4;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 2] == 0 & currmon == 10;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 3] == 0 & currmon == 9;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 4] == 0 & currmon == 8;

by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 2] == 0 & currmon == 1;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 2] == 0 & currmon == 5;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 3] == 0 & currmon == 4;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 4] == 0 & currmon == 3;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 2] == 0 & currmon == 9;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 3] == 0 & currmon == 8;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 4] == 0 & currmon == 7;

by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 2] == 0 & currmon == 4;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 3] == 0 & currmon == 3;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 4] == 0 & currmon == 2;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 2] == 0 & currmon == 8;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 3] == 0 & currmon == 7;
by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1 & uren0xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace uren0x = uren0x[_n - 1]*0.5 + uren0x[_n + 1]*0.5 if uren0xM == 1 & uren0xM[_n - 1] == 0 & uren0xM[_n + 1] == 0;
by id: replace uren0x = uren0x[_n - 1]*0.7 + uren0x[_n + 2]*0.3 if uren0xM == 1 & uren0xM[_n - 1] == 0 & uren0xM[_n + 2] == 0;
by id: replace uren0x = uren0x[_n - 2]*0.3 + uren0x[_n + 1]*0.7 if uren0xM == 1 & uren0xM[_n - 2] == 0 & uren0xM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace uren0x = uren0x[_n - 1] if uren0xM == 1 & uren0xM[_n - 1] == 0;
by id: replace uren0x = uren0x[_n - 2] if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 0;
by id: replace uren0x = uren0x[_n - 1] if uren0xM == 1 & uren0xM[_n - 1] == 0 & uren0xM[_n + 1] == 1;

/** Establish dburents by unicode, state, region **/

gen uren0xaggb = uren0x*units0x;
replace uren0xaggb = . if units0x == 0;
gen uren0xinvb = units0x;
replace uren0xinvb = . if uren0xaggb == .;

bysort unicode yr sem: egen uren0a1 = sum(uren0xaggb);
bysort unicode yr sem: egen uren0inv1 = sum(uren0xinvb);
bysort unicode yr sem: gen db0urenuni = uren0a1/uren0inv1;

bysort state yr sem: egen uren0a2 = sum(uren0xaggb);
bysort state yr sem: egen uren0inv2 = sum(uren0xinvb);
bysort state yr sem: gen db0stateuniunit = uren0a2/uren0inv2;

bysort r1to5 yr sem: egen uren0a3 = sum(uren0xaggb);
bysort r1to5 yr sem: egen uren0inv3 = sum(uren0xinvb);
bysort r1to5 yr sem: gen db0reguniunit = uren0a3/uren0inv3;

sort id yr qtr currmon;

/** uren1x **/

sort id yr qtr currmon;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 2] == 0 & currmon == 3;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 3] == 0 & currmon == 4;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 4] == 0 & currmon == 5;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 2] == 0 & currmon == 7;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 3] == 0 & currmon == 8;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 4] == 0 & currmon == 9;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 2] == 0 & currmon == 11;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 3] == 0 & currmon == 12;

by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 2] == 0 & currmon == 4;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 3] == 0 & currmon == 5;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 4] == 0 & currmon == 6;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 2] == 0 & currmon == 8;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 3] == 0 & currmon == 9;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 4] == 0 & currmon == 10;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 2] == 0 & currmon == 12;

by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 2] == 0 & currmon == 5;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 3] == 0 & currmon == 6;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 4] == 0 & currmon == 7;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 2] == 0 & currmon == 9;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 3] == 0 & currmon == 10;
by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1xM == 1 & uren1xM[_n - 4] == 0 & currmon == 11;

by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 2] == 0 & currmon == 2;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 3] == 0 & currmon == 1;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 2] == 0 & currmon == 6;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 3] == 0 & currmon == 5;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 4] == 0 & currmon == 4;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 2] == 0 & currmon == 10;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 3] == 0 & currmon == 9;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 4] == 0 & currmon == 8;

by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 2] == 0 & currmon == 1;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 2] == 0 & currmon == 5;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 3] == 0 & currmon == 4;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 4] == 0 & currmon == 3;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 2] == 0 & currmon == 9;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 3] == 0 & currmon == 8;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 4] == 0 & currmon == 7;

by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 2] == 0 & currmon == 4;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 3] == 0 & currmon == 3;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 4] == 0 & currmon == 2;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 2] == 0 & currmon == 8;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 3] == 0 & currmon == 7;
by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1 & uren1xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace uren1x = uren1x[_n - 1]*0.5 + uren1x[_n + 1]*0.5 if uren1xM == 1 & uren1xM[_n - 1] == 0 & uren1xM[_n + 1] == 0;
by id: replace uren1x = uren1x[_n - 1]*0.7 + uren1x[_n + 2]*0.3 if uren1xM == 1 & uren1xM[_n - 1] == 0 & uren1xM[_n + 2] == 0;
by id: replace uren1x = uren1x[_n - 2]*0.3 + uren1x[_n + 1]*0.7 if uren1xM == 1 & uren1xM[_n - 2] == 0 & uren1xM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace uren1x = uren1x[_n - 1] if uren1xM == 1 & uren1xM[_n - 1] == 0;
by id: replace uren1x = uren1x[_n - 2] if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 0;
by id: replace uren1x = uren1x[_n - 1] if uren1xM == 1 & uren1xM[_n - 1] == 0 & uren1xM[_n + 1] == 1;

/** Establish dburents by unicode, state, region **/

gen uren1xaggb = uren1x*units1x;
replace uren1xaggb = . if units1x == 0;
gen uren1xinvb = units1x;
replace uren1xinvb = . if uren1xaggb == .;

bysort unicode yr sem: egen uren1a1 = sum(uren1xaggb);
bysort unicode yr sem: egen uren1inv1 = sum(uren1xinvb);
bysort unicode yr sem: gen db1urenuni = uren1a1/uren1inv1;

bysort state yr sem: egen uren1a2 = sum(uren1xaggb);
bysort state yr sem: egen uren1inv2 = sum(uren1xinvb);
bysort state yr sem: gen db1stateuniunit = uren1a2/uren1inv2;

bysort r1to5 yr sem: egen uren1a3 = sum(uren1xaggb);
bysort r1to5 yr sem: egen uren1inv3 = sum(uren1xinvb);
bysort r1to5 yr sem: gen db1reguniunit = uren1a3/uren1inv3;

sort id yr qtr currmon;

/** uren2x **/

sort id yr qtr currmon;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 2] == 0 & currmon == 3;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 3] == 0 & currmon == 4;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 4] == 0 & currmon == 5;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 2] == 0 & currmon == 7;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 3] == 0 & currmon == 8;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 4] == 0 & currmon == 9;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 2] == 0 & currmon == 11;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 3] == 0 & currmon == 12;

by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 2] == 0 & currmon == 4;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 3] == 0 & currmon == 5;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 4] == 0 & currmon == 6;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 2] == 0 & currmon == 8;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 3] == 0 & currmon == 9;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 4] == 0 & currmon == 10;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 2] == 0 & currmon == 12;

by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 2] == 0 & currmon == 5;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 3] == 0 & currmon == 6;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 4] == 0 & currmon == 7;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 2] == 0 & currmon == 9;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 3] == 0 & currmon == 10;
by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2xM == 1 & uren2xM[_n - 4] == 0 & currmon == 11;

by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 2] == 0 & currmon == 2;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 3] == 0 & currmon == 1;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 2] == 0 & currmon == 6;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 3] == 0 & currmon == 5;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 4] == 0 & currmon == 4;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 2] == 0 & currmon == 10;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 3] == 0 & currmon == 9;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 4] == 0 & currmon == 8;

by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 2] == 0 & currmon == 1;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 2] == 0 & currmon == 5;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 3] == 0 & currmon == 4;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 4] == 0 & currmon == 3;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 2] == 0 & currmon == 9;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 3] == 0 & currmon == 8;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 4] == 0 & currmon == 7;

by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 2] == 0 & currmon == 4;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 3] == 0 & currmon == 3;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 4] == 0 & currmon == 2;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 2] == 0 & currmon == 8;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 3] == 0 & currmon == 7;
by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1 & uren2xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace uren2x = uren2x[_n - 1]*0.5 + uren2x[_n + 1]*0.5 if uren2xM == 1 & uren2xM[_n - 1] == 0 & uren2xM[_n + 1] == 0;
by id: replace uren2x = uren2x[_n - 1]*0.7 + uren2x[_n + 2]*0.3 if uren2xM == 1 & uren2xM[_n - 1] == 0 & uren2xM[_n + 2] == 0;
by id: replace uren2x = uren2x[_n - 2]*0.3 + uren2x[_n + 1]*0.7 if uren2xM == 1 & uren2xM[_n - 2] == 0 & uren2xM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace uren2x = uren2x[_n - 1] if uren2xM == 1 & uren2xM[_n - 1] == 0;
by id: replace uren2x = uren2x[_n - 2] if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 0;
by id: replace uren2x = uren2x[_n - 1] if uren2xM == 1 & uren2xM[_n - 1] == 0 & uren2xM[_n + 1] == 1;

/** Establish dburents by unicode, state, region **/

gen uren2xaggb = uren2x*units2x;
replace uren2xaggb = . if units2x == 0;
gen uren2xinvb = units2x;
replace uren2xinvb = . if uren2xaggb == .;

bysort unicode yr sem: egen uren2a1 = sum(uren2xaggb);
bysort unicode yr sem: egen uren2inv1 = sum(uren2xinvb);
bysort unicode yr sem: gen db2urenuni = uren2a1/uren2inv1;

bysort state yr sem: egen uren2a2 = sum(uren2xaggb);
bysort state yr sem: egen uren2inv2 = sum(uren2xinvb);
bysort state yr sem: gen db2stateuniunit = uren2a2/uren2inv2;

bysort r1to5 yr sem: egen uren2a3 = sum(uren2xaggb);
bysort r1to5 yr sem: egen uren2inv3 = sum(uren2xinvb);
bysort r1to5 yr sem: gen db2reguniunit = uren2a3/uren2inv3;

sort id yr qtr currmon;

/** uren3x **/

sort id yr qtr currmon;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 2] == 0 & currmon == 3;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 3] == 0 & currmon == 4;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 4] == 0 & currmon == 5;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 2] == 0 & currmon == 7;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 3] == 0 & currmon == 8;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 4] == 0 & currmon == 9;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 2] == 0 & currmon == 11;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 3] == 0 & currmon == 12;

by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 2] == 0 & currmon == 4;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 3] == 0 & currmon == 5;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 4] == 0 & currmon == 6;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 2] == 0 & currmon == 8;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 3] == 0 & currmon == 9;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 4] == 0 & currmon == 10;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 2] == 0 & currmon == 12;

by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 2] == 0 & currmon == 5;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 3] == 0 & currmon == 6;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 4] == 0 & currmon == 7;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 2] == 0 & currmon == 9;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 3] == 0 & currmon == 10;
by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3xM == 1 & uren3xM[_n - 4] == 0 & currmon == 11;

by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 2] == 0 & currmon == 2;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 3] == 0 & currmon == 1;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 2] == 0 & currmon == 6;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 3] == 0 & currmon == 5;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 4] == 0 & currmon == 4;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 2] == 0 & currmon == 10;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 3] == 0 & currmon == 9;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 4] == 0 & currmon == 8;

by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 2] == 0 & currmon == 1;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 2] == 0 & currmon == 5;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 3] == 0 & currmon == 4;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 4] == 0 & currmon == 3;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 2] == 0 & currmon == 9;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 3] == 0 & currmon == 8;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 4] == 0 & currmon == 7;

by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 2] == 0 & currmon == 4;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 3] == 0 & currmon == 3;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 4] == 0 & currmon == 2;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 2] == 0 & currmon == 8;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 3] == 0 & currmon == 7;
by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1 & uren3xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace uren3x = uren3x[_n - 1]*0.5 + uren3x[_n + 1]*0.5 if uren3xM == 1 & uren3xM[_n - 1] == 0 & uren3xM[_n + 1] == 0;
by id: replace uren3x = uren3x[_n - 1]*0.7 + uren3x[_n + 2]*0.3 if uren3xM == 1 & uren3xM[_n - 1] == 0 & uren3xM[_n + 2] == 0;
by id: replace uren3x = uren3x[_n - 2]*0.3 + uren3x[_n + 1]*0.7 if uren3xM == 1 & uren3xM[_n - 2] == 0 & uren3xM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace uren3x = uren3x[_n - 1] if uren3xM == 1 & uren3xM[_n - 1] == 0;
by id: replace uren3x = uren3x[_n - 2] if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 0;
by id: replace uren3x = uren3x[_n - 1] if uren3xM == 1 & uren3xM[_n - 1] == 0 & uren3xM[_n + 1] == 1;

/** Establish dburents by unicode, state, region **/

gen uren3xaggb = uren3x*units3x;
replace uren3xaggb = . if units3x == 0;
gen uren3xinvb = units3x;
replace uren3xinvb = . if uren3xaggb == .;

bysort unicode yr sem: egen uren3a1 = sum(uren3xaggb);
bysort unicode yr sem: egen uren3inv1 = sum(uren3xinvb);
bysort unicode yr sem: gen db3urenuni = uren3a1/uren3inv1;

bysort state yr sem: egen uren3a2 = sum(uren3xaggb);
bysort state yr sem: egen uren3inv2 = sum(uren3xinvb);
bysort state yr sem: gen db3stateuniunit = uren3a2/uren3inv2;

bysort r1to5 yr sem: egen uren3a3 = sum(uren3xaggb);
bysort r1to5 yr sem: egen uren3inv3 = sum(uren3xinvb);
bysort r1to5 yr sem: gen db3reguniunit = uren3a3/uren3inv3;

sort id yr qtr currmon;

/** uren4x **/

sort id yr qtr currmon;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 2] == 0 & currmon == 3;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 3] == 0 & currmon == 4;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 4] == 0 & currmon == 5;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 2] == 0 & currmon == 7;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 3] == 0 & currmon == 8;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 4] == 0 & currmon == 9;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 2] == 0 & currmon == 11;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 3] == 0 & currmon == 12;

by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 2] == 0 & currmon == 4;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 3] == 0 & currmon == 5;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 4] == 0 & currmon == 6;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 2] == 0 & currmon == 8;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 3] == 0 & currmon == 9;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 4] == 0 & currmon == 10;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 2] == 0 & currmon == 12;

by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 2] == 0 & currmon == 5;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 3] == 0 & currmon == 6;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 4] == 0 & currmon == 7;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 2] == 0 & currmon == 9;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 3] == 0 & currmon == 10;
by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4xM == 1 & uren4xM[_n - 4] == 0 & currmon == 11;

by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 2] == 0 & currmon == 2;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 3] == 0 & currmon == 1;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 2] == 0 & currmon == 6;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 3] == 0 & currmon == 5;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 4] == 0 & currmon == 4;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 2] == 0 & currmon == 10;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 3] == 0 & currmon == 9;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 4] == 0 & currmon == 8;

by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 2] == 0 & currmon == 1;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 2] == 0 & currmon == 5;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 3] == 0 & currmon == 4;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 4] == 0 & currmon == 3;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 2] == 0 & currmon == 9;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 3] == 0 & currmon == 8;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 4] == 0 & currmon == 7;

by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 2] == 0 & currmon == 4;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 3] == 0 & currmon == 3;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 4] == 0 & currmon == 2;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 2] == 0 & currmon == 8;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 3] == 0 & currmon == 7;
by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1 & uren4xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace uren4x = uren4x[_n - 1]*0.5 + uren4x[_n + 1]*0.5 if uren4xM == 1 & uren4xM[_n - 1] == 0 & uren4xM[_n + 1] == 0;
by id: replace uren4x = uren4x[_n - 1]*0.7 + uren4x[_n + 2]*0.3 if uren4xM == 1 & uren4xM[_n - 1] == 0 & uren4xM[_n + 2] == 0;
by id: replace uren4x = uren4x[_n - 2]*0.3 + uren4x[_n + 1]*0.7 if uren4xM == 1 & uren4xM[_n - 2] == 0 & uren4xM[_n + 1] == 0;

/** Ben Bloch feedback - carry over if surveyed observations exist from prior months **/

by id: replace uren4x = uren4x[_n - 1] if uren4xM == 1 & uren4xM[_n - 1] == 0;
by id: replace uren4x = uren4x[_n - 2] if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 0;
by id: replace uren4x = uren4x[_n - 1] if uren4xM == 1 & uren4xM[_n - 1] == 0 & uren4xM[_n + 1] == 1;

/** Establish dburents by unicode, state, region **/

gen uren4xaggb = uren4x*units4x;
replace uren4xaggb = . if units4x == 0;
gen uren4xinvb = units4x;
replace uren4xinvb = . if uren4xaggb == .;

bysort unicode yr sem: egen uren4a1 = sum(uren4xaggb);
bysort unicode yr sem: egen uren4inv1 = sum(uren4xinvb);
bysort unicode yr sem: gen db4urenuni = uren4a1/uren4inv1;

bysort state yr sem: egen uren4a2 = sum(uren4xaggb);
bysort state yr sem: egen uren4inv2 = sum(uren4xinvb);
bysort state yr sem: gen db4stateuniunit = uren4a2/uren4inv2;

bysort r1to5 yr sem: egen uren4a3 = sum(uren4xaggb);
bysort r1to5 yr sem: egen uren4inv3 = sum(uren4xinvb);
bysort r1to5 yr sem: gen db4reguniunit = uren4a3/uren4inv3;

sort id yr qtr currmon;

/** Rationalize DB urents **/

#delimit;
gen db0uren = db0urenuni;
gen db1uren = db1urenuni;
gen db2uren = db2urenuni;
gen db3uren = db3urenuni;
gen db4uren = db4urenuni;

replace db0uren = db0stateuniunit if db0uren == .;
replace db1uren = db1stateuniunit if db1uren == .;
replace db2uren = db2stateuniunit if db2uren == .;
replace db3uren = db3stateuniunit if db3uren == .;
replace db4uren = db4stateuniunit if db4uren == .;

replace db0uren = db0reguniunit if db0uren == .;
replace db1uren = db1reguniunit if db1uren == .;
replace db2uren = db2reguniunit if db2uren == .;
replace db3uren = db3reguniunit if db3uren == .;
replace db4uren = db4reguniunit if db4uren == .;

by id: replace db2uren = 0.95*db1uren if db2uren > db1uren;
by id: replace db3uren = 0.95*db2uren if db3uren > db2uren;
by id: replace db4uren = 0.95*db3uren if db4uren > db3uren;

/** Fill in values given dburen assignments **/

sort id yr sem;

by id: egen uren0xct = count(uren0x);
by id: egen uren1xct = count(uren1x);
by id: egen uren2xct = count(uren2x);
by id: egen uren3xct = count(uren3x);
by id: egen uren4xct = count(uren4x);

sort id yr qtr currmon;

by id: replace uren0x = db0uren*unif95 if uren0xct == 0 & uren0xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace uren1x = db1uren*unif95 if uren1xct == 0 & uren1xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace uren2x = db2uren*unif95 if uren2xct == 0 & uren2xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace uren3x = db3uren*unif95 if uren3xct == 0 & uren3xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace uren4x = db4uren*unif95 if uren4xct == 0 & uren4xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);


/** Move that shiznits forward! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1;

     local d = `d' + 1;

   };     
   
/** And backwards! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0x == . & uren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1x == . & uren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2x == . & uren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3x == . & uren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4x == . & uren4xM == 1;

     local d = `d' + 1;

   };    

/** Moderate intersemestral changes **/

by id: replace uren0x = uren0x[_n - 1]*0.5 + uren0x[_n + 1]*0.5 if uren0xM == 1 & (currmon == 5 | currmon == 9);
by id: replace uren0x = uren0x[_n - 1]*0.5 + uren0x[_n + 1]*0.5 if uren0xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace uren1x = uren1x[_n - 1]*0.5 + uren1x[_n + 1]*0.5 if uren1xM == 1 & (currmon == 5 | currmon == 9);
by id: replace uren1x = uren1x[_n - 1]*0.5 + uren1x[_n + 1]*0.5 if uren1xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace uren2x = uren2x[_n - 1]*0.5 + uren2x[_n + 1]*0.5 if uren2xM == 1 & (currmon == 5 | currmon == 9);
by id: replace uren2x = uren2x[_n - 1]*0.5 + uren2x[_n + 1]*0.5 if uren2xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace uren3x = uren3x[_n - 1]*0.5 + uren3x[_n + 1]*0.5 if uren3xM == 1 & (currmon == 5 | currmon == 9);
by id: replace uren3x = uren3x[_n - 1]*0.5 + uren3x[_n + 1]*0.5 if uren3xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace uren4x = uren4x[_n - 1]*0.5 + uren4x[_n + 1]*0.5 if uren4xM == 1 & (currmon == 5 | currmon == 9);
by id: replace uren4x = uren4x[_n - 1]*0.5 + uren4x[_n + 1]*0.5 if uren4xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

/** Moderate stretches of "no survey" **/

by id: replace uren0x = uren0x[_n - 1]*0.8 + uren0x[_n + 3]*0.2 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n + 1] == 1 & uren0xM[_n + 2] == 1 
       & uren0xM[_n + 3] == 1 & currmon == 2;
by id: replace uren0x = uren0x[_n - 2]*0.5 + uren0x[_n + 2]*0.5 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n + 1] == 1 
       & uren0xM[_n + 2] == 1 & currmon == 3;   
by id: replace uren0x = uren0x[_n - 3]*0.2 + uren0x[_n + 3]*0.8 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n - 3] == 1 
       & uren0xM[_n + 1] == 1 & currmon == 4;  
by id: replace uren0x = uren0x[_n - 1]*0.8 + uren0x[_n + 3]*0.2 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n + 1] == 1 & uren0xM[_n + 2] == 1 
       & uren0xM[_n + 3] == 1 & currmon == 4;
by id: replace uren0x = uren0x[_n - 2]*0.5 + uren0x[_n + 2]*0.5 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n + 1] == 1 
       & uren0xM[_n + 2] == 1 & currmon == 5;   
by id: replace uren0x = uren0x[_n - 3]*0.2 + uren0x[_n + 3]*0.8 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n - 3] == 1 
       & uren0xM[_n + 1] == 1 & currmon == 6;       
by id: replace uren0x = uren0x[_n - 1]*0.8 + uren0x[_n + 3]*0.2 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n + 1] == 1 & uren0xM[_n + 2] == 1 
       & uren0xM[_n + 3] == 1 & currmon == 5;
by id: replace uren0x = uren0x[_n - 2]*0.5 + uren0x[_n + 2]*0.5 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n + 1] == 1 
       & uren0xM[_n + 2] == 1 & currmon == 6;   
by id: replace uren0x = uren0x[_n - 3]*0.2 + uren0x[_n + 3]*0.8 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n - 3] == 1 
       & uren0xM[_n + 1] == 1 & currmon == 7;
by id: replace uren0x = uren0x[_n - 1]*0.8 + uren0x[_n + 3]*0.2 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n + 1] == 1 & uren0xM[_n + 2] == 1 
       & uren0xM[_n + 3] == 1 & currmon == 6;
by id: replace uren0x = uren0x[_n - 2]*0.5 + uren0x[_n + 2]*0.5 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n + 1] == 1 
       & uren0xM[_n + 2] == 1 & currmon == 7;   
by id: replace uren0x = uren0x[_n - 3]*0.2 + uren0x[_n + 3]*0.8 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n - 3] == 1 
       & uren0xM[_n + 1] == 1 & currmon == 8;       
by id: replace uren0x = uren0x[_n - 1]*0.8 + uren0x[_n + 3]*0.2 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n + 1] == 1 & uren0xM[_n + 2] == 1 
       & uren0xM[_n + 3] == 1 & currmon == 7;
by id: replace uren0x = uren0x[_n - 2]*0.5 + uren0x[_n + 2]*0.5 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n + 1] == 1 
       & uren0xM[_n + 2] == 1 & currmon == 8;   
by id: replace uren0x = uren0x[_n - 3]*0.2 + uren0x[_n + 3]*0.8 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n - 3] == 1 
       & uren0xM[_n + 1] == 1 & currmon == 9;
by id: replace uren0x = uren0x[_n - 1]*0.8 + uren0x[_n + 3]*0.2 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n + 1] == 1 & uren0xM[_n + 2] == 1 
       & uren0xM[_n + 3] == 1 & currmon == 8;
by id: replace uren0x = uren0x[_n - 2]*0.5 + uren0x[_n + 2]*0.5 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n + 1] == 1 
       & uren0xM[_n + 2] == 1 & currmon == 9;   
by id: replace uren0x = uren0x[_n - 3]*0.2 + uren0x[_n + 3]*0.8 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n - 3] == 1 
       & uren0xM[_n + 1] == 1 & currmon == 10;
by id: replace uren0x = uren0x[_n - 1]*0.8 + uren0x[_n + 3]*0.2 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n + 1] == 1 & uren0xM[_n + 2] == 1 
       & uren0xM[_n + 3] == 1 & currmon == 9;
by id: replace uren0x = uren0x[_n - 2]*0.5 + uren0x[_n + 2]*0.5 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n + 1] == 1 
       & uren0xM[_n + 2] == 1 & currmon == 10;   
by id: replace uren0x = uren0x[_n - 3]*0.2 + uren0x[_n + 3]*0.8 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n - 3] == 1 
       & uren0xM[_n + 1] == 1 & currmon == 11;       
by id: replace uren0x = uren0x[_n - 1]*0.8 + uren0x[_n + 3]*0.2 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n + 1] == 1 & uren0xM[_n + 2] == 1 
       & uren0xM[_n + 3] == 1 & currmon == 10;
by id: replace uren0x = uren0x[_n - 2]*0.5 + uren0x[_n + 2]*0.5 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n + 1] == 1 
       & uren0xM[_n + 2] == 1 & currmon == 11;   
by id: replace uren0x = uren0x[_n - 3]*0.2 + uren0x[_n + 3]*0.8 if uren0xM == 1 & uren0xM[_n - 1] == 1 & uren0xM[_n - 2] == 1 & uren0xM[_n - 3] == 1 
       & uren0xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace uren1x = uren1x[_n - 1]*0.8 + uren1x[_n + 3]*0.2 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n + 1] == 1 & uren1xM[_n + 2] == 1 
       & uren1xM[_n + 3] == 1 & currmon == 2;
by id: replace uren1x = uren1x[_n - 2]*0.5 + uren1x[_n + 2]*0.5 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n + 1] == 1 
       & uren1xM[_n + 2] == 1 & currmon == 3;   
by id: replace uren1x = uren1x[_n - 3]*0.2 + uren1x[_n + 3]*0.8 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n - 3] == 1 
       & uren1xM[_n + 1] == 1 & currmon == 4;  
by id: replace uren1x = uren1x[_n - 1]*0.8 + uren1x[_n + 3]*0.2 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n + 1] == 1 & uren1xM[_n + 2] == 1 
       & uren1xM[_n + 3] == 1 & currmon == 4;
by id: replace uren1x = uren1x[_n - 2]*0.5 + uren1x[_n + 2]*0.5 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n + 1] == 1 
       & uren1xM[_n + 2] == 1 & currmon == 5;   
by id: replace uren1x = uren1x[_n - 3]*0.2 + uren1x[_n + 3]*0.8 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n - 3] == 1 
       & uren1xM[_n + 1] == 1 & currmon == 6;       
by id: replace uren1x = uren1x[_n - 1]*0.8 + uren1x[_n + 3]*0.2 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n + 1] == 1 & uren1xM[_n + 2] == 1 
       & uren1xM[_n + 3] == 1 & currmon == 5;
by id: replace uren1x = uren1x[_n - 2]*0.5 + uren1x[_n + 2]*0.5 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n + 1] == 1 
       & uren1xM[_n + 2] == 1 & currmon == 6;   
by id: replace uren1x = uren1x[_n - 3]*0.2 + uren1x[_n + 3]*0.8 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n - 3] == 1 
       & uren1xM[_n + 1] == 1 & currmon == 7;
by id: replace uren1x = uren1x[_n - 1]*0.8 + uren1x[_n + 3]*0.2 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n + 1] == 1 & uren1xM[_n + 2] == 1 
       & uren1xM[_n + 3] == 1 & currmon == 6;
by id: replace uren1x = uren1x[_n - 2]*0.5 + uren1x[_n + 2]*0.5 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n + 1] == 1 
       & uren1xM[_n + 2] == 1 & currmon == 7;   
by id: replace uren1x = uren1x[_n - 3]*0.2 + uren1x[_n + 3]*0.8 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n - 3] == 1 
       & uren1xM[_n + 1] == 1 & currmon == 8;       
by id: replace uren1x = uren1x[_n - 1]*0.8 + uren1x[_n + 3]*0.2 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n + 1] == 1 & uren1xM[_n + 2] == 1 
       & uren1xM[_n + 3] == 1 & currmon == 7;
by id: replace uren1x = uren1x[_n - 2]*0.5 + uren1x[_n + 2]*0.5 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n + 1] == 1 
       & uren1xM[_n + 2] == 1 & currmon == 8;   
by id: replace uren1x = uren1x[_n - 3]*0.2 + uren1x[_n + 3]*0.8 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n - 3] == 1 
       & uren1xM[_n + 1] == 1 & currmon == 9;
by id: replace uren1x = uren1x[_n - 1]*0.8 + uren1x[_n + 3]*0.2 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n + 1] == 1 & uren1xM[_n + 2] == 1 
       & uren1xM[_n + 3] == 1 & currmon == 8;
by id: replace uren1x = uren1x[_n - 2]*0.5 + uren1x[_n + 2]*0.5 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n + 1] == 1 
       & uren1xM[_n + 2] == 1 & currmon == 9;   
by id: replace uren1x = uren1x[_n - 3]*0.2 + uren1x[_n + 3]*0.8 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n - 3] == 1 
       & uren1xM[_n + 1] == 1 & currmon == 10;
by id: replace uren1x = uren1x[_n - 1]*0.8 + uren1x[_n + 3]*0.2 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n + 1] == 1 & uren1xM[_n + 2] == 1 
       & uren1xM[_n + 3] == 1 & currmon == 9;
by id: replace uren1x = uren1x[_n - 2]*0.5 + uren1x[_n + 2]*0.5 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n + 1] == 1 
       & uren1xM[_n + 2] == 1 & currmon == 10;   
by id: replace uren1x = uren1x[_n - 3]*0.2 + uren1x[_n + 3]*0.8 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n - 3] == 1 
       & uren1xM[_n + 1] == 1 & currmon == 11;       
by id: replace uren1x = uren1x[_n - 1]*0.8 + uren1x[_n + 3]*0.2 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n + 1] == 1 & uren1xM[_n + 2] == 1 
       & uren1xM[_n + 3] == 1 & currmon == 10;
by id: replace uren1x = uren1x[_n - 2]*0.5 + uren1x[_n + 2]*0.5 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n + 1] == 1 
       & uren1xM[_n + 2] == 1 & currmon == 11;   
by id: replace uren1x = uren1x[_n - 3]*0.2 + uren1x[_n + 3]*0.8 if uren1xM == 1 & uren1xM[_n - 1] == 1 & uren1xM[_n - 2] == 1 & uren1xM[_n - 3] == 1 
       & uren1xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace uren2x = uren2x[_n - 1]*0.8 + uren2x[_n + 3]*0.2 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n + 1] == 1 & uren2xM[_n + 2] == 1 
       & uren2xM[_n + 3] == 1 & currmon == 2;
by id: replace uren2x = uren2x[_n - 2]*0.5 + uren2x[_n + 2]*0.5 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n + 1] == 1 
       & uren2xM[_n + 2] == 1 & currmon == 3;   
by id: replace uren2x = uren2x[_n - 3]*0.2 + uren2x[_n + 3]*0.8 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n - 3] == 1 
       & uren2xM[_n + 1] == 1 & currmon == 4;  
by id: replace uren2x = uren2x[_n - 1]*0.8 + uren2x[_n + 3]*0.2 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n + 1] == 1 & uren2xM[_n + 2] == 1 
       & uren2xM[_n + 3] == 1 & currmon == 4;
by id: replace uren2x = uren2x[_n - 2]*0.5 + uren2x[_n + 2]*0.5 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n + 1] == 1 
       & uren2xM[_n + 2] == 1 & currmon == 5;   
by id: replace uren2x = uren2x[_n - 3]*0.2 + uren2x[_n + 3]*0.8 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n - 3] == 1 
       & uren2xM[_n + 1] == 1 & currmon == 6;       
by id: replace uren2x = uren2x[_n - 1]*0.8 + uren2x[_n + 3]*0.2 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n + 1] == 1 & uren2xM[_n + 2] == 1 
       & uren2xM[_n + 3] == 1 & currmon == 5;
by id: replace uren2x = uren2x[_n - 2]*0.5 + uren2x[_n + 2]*0.5 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n + 1] == 1 
       & uren2xM[_n + 2] == 1 & currmon == 6;   
by id: replace uren2x = uren2x[_n - 3]*0.2 + uren2x[_n + 3]*0.8 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n - 3] == 1 
       & uren2xM[_n + 1] == 1 & currmon == 7;
by id: replace uren2x = uren2x[_n - 1]*0.8 + uren2x[_n + 3]*0.2 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n + 1] == 1 & uren2xM[_n + 2] == 1 
       & uren2xM[_n + 3] == 1 & currmon == 6;
by id: replace uren2x = uren2x[_n - 2]*0.5 + uren2x[_n + 2]*0.5 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n + 1] == 1 
       & uren2xM[_n + 2] == 1 & currmon == 7;   
by id: replace uren2x = uren2x[_n - 3]*0.2 + uren2x[_n + 3]*0.8 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n - 3] == 1 
       & uren2xM[_n + 1] == 1 & currmon == 8;       
by id: replace uren2x = uren2x[_n - 1]*0.8 + uren2x[_n + 3]*0.2 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n + 1] == 1 & uren2xM[_n + 2] == 1 
       & uren2xM[_n + 3] == 1 & currmon == 7;
by id: replace uren2x = uren2x[_n - 2]*0.5 + uren2x[_n + 2]*0.5 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n + 1] == 1 
       & uren2xM[_n + 2] == 1 & currmon == 8;   
by id: replace uren2x = uren2x[_n - 3]*0.2 + uren2x[_n + 3]*0.8 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n - 3] == 1 
       & uren2xM[_n + 1] == 1 & currmon == 9;
by id: replace uren2x = uren2x[_n - 1]*0.8 + uren2x[_n + 3]*0.2 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n + 1] == 1 & uren2xM[_n + 2] == 1 
       & uren2xM[_n + 3] == 1 & currmon == 8;
by id: replace uren2x = uren2x[_n - 2]*0.5 + uren2x[_n + 2]*0.5 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n + 1] == 1 
       & uren2xM[_n + 2] == 1 & currmon == 9;   
by id: replace uren2x = uren2x[_n - 3]*0.2 + uren2x[_n + 3]*0.8 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n - 3] == 1 
       & uren2xM[_n + 1] == 1 & currmon == 10;
by id: replace uren2x = uren2x[_n - 1]*0.8 + uren2x[_n + 3]*0.2 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n + 1] == 1 & uren2xM[_n + 2] == 1 
       & uren2xM[_n + 3] == 1 & currmon == 9;
by id: replace uren2x = uren2x[_n - 2]*0.5 + uren2x[_n + 2]*0.5 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n + 1] == 1 
       & uren2xM[_n + 2] == 1 & currmon == 10;   
by id: replace uren2x = uren2x[_n - 3]*0.2 + uren2x[_n + 3]*0.8 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n - 3] == 1 
       & uren2xM[_n + 1] == 1 & currmon == 11;       
by id: replace uren2x = uren2x[_n - 1]*0.8 + uren2x[_n + 3]*0.2 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n + 1] == 1 & uren2xM[_n + 2] == 1 
       & uren2xM[_n + 3] == 1 & currmon == 10;
by id: replace uren2x = uren2x[_n - 2]*0.5 + uren2x[_n + 2]*0.5 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n + 1] == 1 
       & uren2xM[_n + 2] == 1 & currmon == 11;   
by id: replace uren2x = uren2x[_n - 3]*0.2 + uren2x[_n + 3]*0.8 if uren2xM == 1 & uren2xM[_n - 1] == 1 & uren2xM[_n - 2] == 1 & uren2xM[_n - 3] == 1 
       & uren2xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace uren3x = uren3x[_n - 1]*0.8 + uren3x[_n + 3]*0.2 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n + 1] == 1 & uren3xM[_n + 2] == 1 
       & uren3xM[_n + 3] == 1 & currmon == 2;
by id: replace uren3x = uren3x[_n - 2]*0.5 + uren3x[_n + 2]*0.5 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n + 1] == 1 
       & uren3xM[_n + 2] == 1 & currmon == 3;   
by id: replace uren3x = uren3x[_n - 3]*0.2 + uren3x[_n + 3]*0.8 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n - 3] == 1 
       & uren3xM[_n + 1] == 1 & currmon == 4;  
by id: replace uren3x = uren3x[_n - 1]*0.8 + uren3x[_n + 3]*0.2 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n + 1] == 1 & uren3xM[_n + 2] == 1 
       & uren3xM[_n + 3] == 1 & currmon == 4;
by id: replace uren3x = uren3x[_n - 2]*0.5 + uren3x[_n + 2]*0.5 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n + 1] == 1 
       & uren3xM[_n + 2] == 1 & currmon == 5;   
by id: replace uren3x = uren3x[_n - 3]*0.2 + uren3x[_n + 3]*0.8 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n - 3] == 1 
       & uren3xM[_n + 1] == 1 & currmon == 6;       
by id: replace uren3x = uren3x[_n - 1]*0.8 + uren3x[_n + 3]*0.2 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n + 1] == 1 & uren3xM[_n + 2] == 1 
       & uren3xM[_n + 3] == 1 & currmon == 5;
by id: replace uren3x = uren3x[_n - 2]*0.5 + uren3x[_n + 2]*0.5 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n + 1] == 1 
       & uren3xM[_n + 2] == 1 & currmon == 6;   
by id: replace uren3x = uren3x[_n - 3]*0.2 + uren3x[_n + 3]*0.8 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n - 3] == 1 
       & uren3xM[_n + 1] == 1 & currmon == 7;
by id: replace uren3x = uren3x[_n - 1]*0.8 + uren3x[_n + 3]*0.2 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n + 1] == 1 & uren3xM[_n + 2] == 1 
       & uren3xM[_n + 3] == 1 & currmon == 6;
by id: replace uren3x = uren3x[_n - 2]*0.5 + uren3x[_n + 2]*0.5 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n + 1] == 1 
       & uren3xM[_n + 2] == 1 & currmon == 7;   
by id: replace uren3x = uren3x[_n - 3]*0.2 + uren3x[_n + 3]*0.8 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n - 3] == 1 
       & uren3xM[_n + 1] == 1 & currmon == 8;       
by id: replace uren3x = uren3x[_n - 1]*0.8 + uren3x[_n + 3]*0.2 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n + 1] == 1 & uren3xM[_n + 2] == 1 
       & uren3xM[_n + 3] == 1 & currmon == 7;
by id: replace uren3x = uren3x[_n - 2]*0.5 + uren3x[_n + 2]*0.5 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n + 1] == 1 
       & uren3xM[_n + 2] == 1 & currmon == 8;   
by id: replace uren3x = uren3x[_n - 3]*0.2 + uren3x[_n + 3]*0.8 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n - 3] == 1 
       & uren3xM[_n + 1] == 1 & currmon == 9;
by id: replace uren3x = uren3x[_n - 1]*0.8 + uren3x[_n + 3]*0.2 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n + 1] == 1 & uren3xM[_n + 2] == 1 
       & uren3xM[_n + 3] == 1 & currmon == 8;
by id: replace uren3x = uren3x[_n - 2]*0.5 + uren3x[_n + 2]*0.5 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n + 1] == 1 
       & uren3xM[_n + 2] == 1 & currmon == 9;   
by id: replace uren3x = uren3x[_n - 3]*0.2 + uren3x[_n + 3]*0.8 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n - 3] == 1 
       & uren3xM[_n + 1] == 1 & currmon == 10;
by id: replace uren3x = uren3x[_n - 1]*0.8 + uren3x[_n + 3]*0.2 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n + 1] == 1 & uren3xM[_n + 2] == 1 
       & uren3xM[_n + 3] == 1 & currmon == 9;
by id: replace uren3x = uren3x[_n - 2]*0.5 + uren3x[_n + 2]*0.5 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n + 1] == 1 
       & uren3xM[_n + 2] == 1 & currmon == 10;   
by id: replace uren3x = uren3x[_n - 3]*0.2 + uren3x[_n + 3]*0.8 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n - 3] == 1 
       & uren3xM[_n + 1] == 1 & currmon == 11;       
by id: replace uren3x = uren3x[_n - 1]*0.8 + uren3x[_n + 3]*0.2 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n + 1] == 1 & uren3xM[_n + 2] == 1 
       & uren3xM[_n + 3] == 1 & currmon == 10;
by id: replace uren3x = uren3x[_n - 2]*0.5 + uren3x[_n + 2]*0.5 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n + 1] == 1 
       & uren3xM[_n + 2] == 1 & currmon == 11;   
by id: replace uren3x = uren3x[_n - 3]*0.2 + uren3x[_n + 3]*0.8 if uren3xM == 1 & uren3xM[_n - 1] == 1 & uren3xM[_n - 2] == 1 & uren3xM[_n - 3] == 1 
       & uren3xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace uren4x = uren4x[_n - 1]*0.8 + uren4x[_n + 3]*0.2 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n + 1] == 1 & uren4xM[_n + 2] == 1 
       & uren4xM[_n + 3] == 1 & currmon == 2;
by id: replace uren4x = uren4x[_n - 2]*0.5 + uren4x[_n + 2]*0.5 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n + 1] == 1 
       & uren4xM[_n + 2] == 1 & currmon == 3;   
by id: replace uren4x = uren4x[_n - 3]*0.2 + uren4x[_n + 3]*0.8 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n - 3] == 1 
       & uren4xM[_n + 1] == 1 & currmon == 4;  
by id: replace uren4x = uren4x[_n - 1]*0.8 + uren4x[_n + 3]*0.2 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n + 1] == 1 & uren4xM[_n + 2] == 1 
       & uren4xM[_n + 3] == 1 & currmon == 4;
by id: replace uren4x = uren4x[_n - 2]*0.5 + uren4x[_n + 2]*0.5 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n + 1] == 1 
       & uren4xM[_n + 2] == 1 & currmon == 5;   
by id: replace uren4x = uren4x[_n - 3]*0.2 + uren4x[_n + 3]*0.8 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n - 3] == 1 
       & uren4xM[_n + 1] == 1 & currmon == 6;       
by id: replace uren4x = uren4x[_n - 1]*0.8 + uren4x[_n + 3]*0.2 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n + 1] == 1 & uren4xM[_n + 2] == 1 
       & uren4xM[_n + 3] == 1 & currmon == 5;
by id: replace uren4x = uren4x[_n - 2]*0.5 + uren4x[_n + 2]*0.5 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n + 1] == 1 
       & uren4xM[_n + 2] == 1 & currmon == 6;   
by id: replace uren4x = uren4x[_n - 3]*0.2 + uren4x[_n + 3]*0.8 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n - 3] == 1 
       & uren4xM[_n + 1] == 1 & currmon == 7;
by id: replace uren4x = uren4x[_n - 1]*0.8 + uren4x[_n + 3]*0.2 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n + 1] == 1 & uren4xM[_n + 2] == 1 
       & uren4xM[_n + 3] == 1 & currmon == 6;
by id: replace uren4x = uren4x[_n - 2]*0.5 + uren4x[_n + 2]*0.5 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n + 1] == 1 
       & uren4xM[_n + 2] == 1 & currmon == 7;   
by id: replace uren4x = uren4x[_n - 3]*0.2 + uren4x[_n + 3]*0.8 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n - 3] == 1 
       & uren4xM[_n + 1] == 1 & currmon == 8;       
by id: replace uren4x = uren4x[_n - 1]*0.8 + uren4x[_n + 3]*0.2 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n + 1] == 1 & uren4xM[_n + 2] == 1 
       & uren4xM[_n + 3] == 1 & currmon == 7;
by id: replace uren4x = uren4x[_n - 2]*0.5 + uren4x[_n + 2]*0.5 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n + 1] == 1 
       & uren4xM[_n + 2] == 1 & currmon == 8;   
by id: replace uren4x = uren4x[_n - 3]*0.2 + uren4x[_n + 3]*0.8 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n - 3] == 1 
       & uren4xM[_n + 1] == 1 & currmon == 9;
by id: replace uren4x = uren4x[_n - 1]*0.8 + uren4x[_n + 3]*0.2 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n + 1] == 1 & uren4xM[_n + 2] == 1 
       & uren4xM[_n + 3] == 1 & currmon == 8;
by id: replace uren4x = uren4x[_n - 2]*0.5 + uren4x[_n + 2]*0.5 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n + 1] == 1 
       & uren4xM[_n + 2] == 1 & currmon == 9;   
by id: replace uren4x = uren4x[_n - 3]*0.2 + uren4x[_n + 3]*0.8 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n - 3] == 1 
       & uren4xM[_n + 1] == 1 & currmon == 10;
by id: replace uren4x = uren4x[_n - 1]*0.8 + uren4x[_n + 3]*0.2 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n + 1] == 1 & uren4xM[_n + 2] == 1 
       & uren4xM[_n + 3] == 1 & currmon == 9;
by id: replace uren4x = uren4x[_n - 2]*0.5 + uren4x[_n + 2]*0.5 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n + 1] == 1 
       & uren4xM[_n + 2] == 1 & currmon == 10;   
by id: replace uren4x = uren4x[_n - 3]*0.2 + uren4x[_n + 3]*0.8 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n - 3] == 1 
       & uren4xM[_n + 1] == 1 & currmon == 11;       
by id: replace uren4x = uren4x[_n - 1]*0.8 + uren4x[_n + 3]*0.2 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n + 1] == 1 & uren4xM[_n + 2] == 1 
       & uren4xM[_n + 3] == 1 & currmon == 10;
by id: replace uren4x = uren4x[_n - 2]*0.5 + uren4x[_n + 2]*0.5 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n + 1] == 1 
       & uren4xM[_n + 2] == 1 & currmon == 11;   
by id: replace uren4x = uren4x[_n - 3]*0.2 + uren4x[_n + 3]*0.8 if uren4xM == 1 & uren4xM[_n - 1] == 1 & uren4xM[_n - 2] == 1 & uren4xM[_n - 3] == 1 
       & uren4xM[_n + 1] == 1 & currmon == 12; 
	   
/** Move that shiznits forward! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren0x = uren0x[_n + 1]/(1 + mcpid) if uren0x == . & uren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren1x = uren1x[_n + 1]/(1 + mcpid) if uren1x == . & uren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren2x = uren2x[_n + 1]/(1 + mcpid) if uren2x == . & uren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren3x = uren3x[_n + 1]/(1 + mcpid) if uren3x == . & uren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren4x = uren4x[_n + 1]/(1 + mcpid) if uren4x == . & uren4xM == 1;

     local d = `d' + 1;

   };     
   
/** And backwards! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren0x = uren0x[_n - 1]*(1 + mcpid) if uren0x == . & uren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren1x = uren1x[_n - 1]*(1 + mcpid) if uren1x == . & uren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren2x = uren2x[_n - 1]*(1 + mcpid) if uren2x == . & uren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren3x = uren3x[_n - 1]*(1 + mcpid) if uren3x == . & uren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace uren4x = uren4x[_n - 1]*(1 + mcpid) if uren4x == . & uren4xM == 1;

     local d = `d' + 1;

   };    	   


/** Format for internal consistency **/

/** Bed to Unit conversion - Case P5842 **/

by id: egen bren0xMa = mean(bren0xM);
by id: egen bren1xMa = mean(bren1xM);
by id: egen bren2xMa = mean(bren2xM);
by id: egen bren3xMa = mean(bren3xM);
by id: egen bren4xMa = mean(bren4xM);

by id: egen uren0xMa = mean(uren0xM);
by id: egen uren1xMa = mean(uren1xM);
by id: egen uren2xMa = mean(uren2xM);
by id: egen uren3xMa = mean(uren3xM);
by id: egen uren4xMa = mean(uren4xM);

by id: replace uren0x = bren0x if uren0xMa == 1;
by id: replace uren1x = bren1x if uren1xMa == 1;
by id: replace uren2x = bren2x*2 if uren2xMa == 1;
by id: replace uren3x = bren3x*3 if uren3xMa == 1;
by id: replace uren4x = bren4x*4 if uren4xMa == 1;

replace bren0x = round(bren0x, 0.1) if bren0xM == 1;
replace bren1x = round(bren1x, 0.1) if bren1xM == 1;
replace bren2x = round(bren2x, 0.1) if bren2xM == 1;
replace bren3x = round(bren3x, 0.1) if bren3xM == 1;
replace bren4x = round(bren4x, 0.1) if bren4xM == 1;

replace uren0x = round(uren0x, 0.1) if uren0xM == 1;
replace uren1x = round(uren1x, 0.1) if uren1xM == 1;
replace uren2x = round(uren2x, 0.1) if uren2xM == 1;
replace uren3x = round(uren3x, 0.1) if uren3xM == 1;
replace uren4x = round(uren4x, 0.1) if uren4xM == 1;

gen cbren0x = bren0x;
gen cbren1x = bren1x;
gen cbren2x = bren2x;
gen cbren3x = bren3x;
gen cbren4x = bren4x;

replace cbren0x = 0 if cbren0x == .;
replace cbren1x = 0 if cbren1x == .;
replace cbren2x = 0 if cbren2x == .;
replace cbren3x = 0 if cbren3x == .;

gen curen0x = uren0x;
gen curen1x = uren1x;
gen curen2x = uren2x;
gen curen3x = uren3x;
gen curen4x = uren4x;

replace curen0x = 0 if curen0x == .;
replace curen1x = 0 if curen1x == .;
replace curen2x = 0 if curen2x == .;
replace curen3x = 0 if curen3x == .;
replace curen4x = 0 if curen4x == .;
replace cbren4x = 0 if cbren4x == .; 

gen bren0tb = cbren0x*beds0x;
gen bren1tb = cbren1x*beds1x;
gen bren2tb = cbren2x*beds2x;
gen bren3tb = cbren3x*beds3x;
gen bren4tb = cbren4x*beds4x;

gen uren0tb = curen0x*units0x;
gen uren1tb = curen1x*units1x;
gen uren2tb = curen2x*units2x;
gen uren3tb = curen3x*units3x;
gen uren4tb = curen4x*units4x;

gen brentb = bren0tb + bren1tb + bren2tb + bren3tb + bren4tb;
gen urentb = uren0tb + uren1tb + uren2tb + uren3tb + uren4tb;
gen bedtb = beds0x + beds1x + beds2x + beds3x + beds4x;
gen bedtu = units0x + units1x + units2x + units3x + units4x;

gen avgrenxbed = round(brentb/bedtb, 0.1);
gen avgrenxun = round(urentb/bedtu, 0.1);

replace bren0x = . if beds0x == 0;
replace bren1x = . if beds1x == 0;
replace bren2x = . if beds2x == 0;
replace bren3x = . if beds3x == 0;
replace bren4x = . if beds4x == 0;

replace uren0x = . if units0x == 0;
replace uren1x = . if units1x == 0;
replace uren2x = . if units2x == 0;
replace uren3x = . if units3x == 0;
replace uren4x = . if units4x == 0;

replace bren0xM = . if beds0x == 0;
replace bren1xM = . if beds1x == 0;
replace bren2xM = . if beds2x == 0;
replace bren3xM = . if beds3x == 0;
replace bren4xM = . if beds4x == 0;

replace uren0xM = . if units0x == 0;
replace uren1xM = . if units1x == 0;
replace uren2xM = . if units2x == 0;
replace uren3xM = . if units3x == 0;
replace uren4xM = . if units4x == 0;

/** Gen FUTURE rents **/

sort id yr qtr currmon;

gen fbren0x = brfutureaverage0 if renttypeO == "Bed";
gen fbren1x = brfutureaverage1 if renttypeO == "Bed";
gen fbren2x = brfutureaverage2 if renttypeO == "Bed";
gen fbren3x = brfutureaverage3 if renttypeO == "Bed";
gen fbren4x = brfutureaverage4 if renttypeO == "Bed";

gen furen0x = brfutureaverage0 if renttypeO == "Unit";
gen furen1x = brfutureaverage1 if renttypeO == "Unit";
gen furen2x = brfutureaverage2 if renttypeO == "Unit";
gen furen3x = brfutureaverage3 if renttypeO == "Unit";
gen furen4x = brfutureaverage4 if renttypeO == "Unit";

gen fbren0xM = 1;
gen fbren1xM = 1;
gen fbren2xM = 1;
gen fbren3xM = 1;
gen fbren4xM = 1;

gen furen0xM = 1;
gen furen1xM = 1;
gen furen2xM = 1;
gen furen3xM = 1;
gen furen4xM = 1;

replace fbren0xM = 0 if brfutureaverage0 ~= . & brfutureaverage0 > 0 & renttypeO == "Bed";
replace fbren1xM = 0 if brfutureaverage1 ~= . & brfutureaverage0 > 1 & renttypeO == "Bed";
replace fbren2xM = 0 if brfutureaverage2 ~= . & brfutureaverage0 > 2 & renttypeO == "Bed";
replace fbren3xM = 0 if brfutureaverage3 ~= . & brfutureaverage0 > 3 & renttypeO == "Bed";
replace fbren4xM = 0 if brfutureaverage4 ~= . & brfutureaverage0 > 4 & renttypeO == "Bed";

replace furen0xM = 0 if brfutureaverage0 ~= . & brfutureaverage0 > 0 & renttypeO == "Unit";
replace furen1xM = 0 if brfutureaverage1 ~= . & brfutureaverage0 > 1 & renttypeO == "Unit";
replace furen2xM = 0 if brfutureaverage2 ~= . & brfutureaverage0 > 2 & renttypeO == "Unit";
replace furen3xM = 0 if brfutureaverage3 ~= . & brfutureaverage0 > 3 & renttypeO == "Unit";
replace furen4xM = 0 if brfutureaverage4 ~= . & brfutureaverage0 > 4 & renttypeO == "Unit";

/** DQ's input given BYU case P135 - make surveyed levels relevant only if it's in 2015 current month! **/

replace fbren0x = . if yr ~= $curryr & currmon ~= $currmo;
replace fbren0xM = 1 if yr ~= $curryr & currmon ~= $currmo;
replace fbren1x = . if yr ~= $curryr & currmon ~= $currmo;
replace fbren1xM = 1 if yr ~= $curryr & currmon ~= $currmo;
replace fbren2x = . if yr ~= $curryr & currmon ~= $currmo;
replace fbren2xM = 1 if yr ~= $curryr & currmon ~= $currmo;
replace fbren3x = . if yr ~= $curryr & currmon ~= $currmo;
replace fbren3xM = 1 if yr ~= $curryr & currmon ~= $currmo;
replace fbren4x = . if yr ~= $curryr & currmon ~= $currmo;
replace fbren4xM = 1 if yr ~= $curryr & currmon ~= $currmo;

replace furen0x = . if yr ~= $curryr & currmon ~= $currmo;
replace furen0xM = 1 if yr ~= $curryr & currmon ~= $currmo;
replace furen1x = . if yr ~= $curryr & currmon ~= $currmo;
replace furen1xM = 1 if yr ~= $curryr & currmon ~= $currmo;
replace furen2x = . if yr ~= $curryr & currmon ~= $currmo;
replace furen2xM = 1 if yr ~= $curryr & currmon ~= $currmo;
replace furen3x = . if yr ~= $curryr & currmon ~= $currmo;
replace furen3xM = 1 if yr ~= $curryr & currmon ~= $currmo;
replace furen4x = . if yr ~= $curryr & currmon ~= $currmo;
replace furen4xM = 1 if yr ~= $curryr & currmon ~= $currmo;

/** Expand pool given surveyed levels **/

/** fbren0x **/

sort id yr qtr currmon;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 2] == 0 & currmon == 3;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 3] == 0 & currmon == 4;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 4] == 0 & currmon == 5;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 2] == 0 & currmon == 7;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 3] == 0 & currmon == 8;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 4] == 0 & currmon == 9;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 2] == 0 & currmon == 11;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 3] == 0 & currmon == 12;

by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 2] == 0 & currmon == 4;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 3] == 0 & currmon == 5;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 4] == 0 & currmon == 6;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 2] == 0 & currmon == 8;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 3] == 0 & currmon == 9;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 4] == 0 & currmon == 10;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 2] == 0 & currmon == 12;

by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 2] == 0 & currmon == 5;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 3] == 0 & currmon == 6;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 4] == 0 & currmon == 7;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 2] == 0 & currmon == 9;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 3] == 0 & currmon == 10;
by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0xM == 1 & fbren0xM[_n - 4] == 0 & currmon == 11;

by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 2] == 0 & currmon == 2;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 3] == 0 & currmon == 1;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 2] == 0 & currmon == 6;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 3] == 0 & currmon == 5;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 4] == 0 & currmon == 4;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 2] == 0 & currmon == 10;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 3] == 0 & currmon == 9;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 4] == 0 & currmon == 8;

by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 2] == 0 & currmon == 1;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 2] == 0 & currmon == 5;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 3] == 0 & currmon == 4;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 4] == 0 & currmon == 3;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 2] == 0 & currmon == 9;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 3] == 0 & currmon == 8;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 4] == 0 & currmon == 7;

by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 2] == 0 & currmon == 4;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 3] == 0 & currmon == 3;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 4] == 0 & currmon == 2;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 2] == 0 & currmon == 8;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 3] == 0 & currmon == 7;
by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1 & fbren0xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace fbren0x = fbren0x[_n - 1]*0.5 + fbren0x[_n + 1]*0.5 if fbren0xM == 1 & fbren0xM[_n - 1] == 0 & fbren0xM[_n + 1] == 0;
by id: replace fbren0x = fbren0x[_n - 1]*0.7 + fbren0x[_n + 2]*0.3 if fbren0xM == 1 & fbren0xM[_n - 1] == 0 & fbren0xM[_n + 2] == 0;
by id: replace fbren0x = fbren0x[_n - 2]*0.3 + fbren0x[_n + 1]*0.7 if fbren0xM == 1 & fbren0xM[_n - 2] == 0 & fbren0xM[_n + 1] == 0;

/** Establish dbrents by unicode, state, region **/

gen fbren0xaggb = fbren0x*beds0x;
replace fbren0xaggb = . if beds0x == 0;
gen fbren0xinvb = beds0x;
replace fbren0xinvb = . if fbren0xaggb == .;

bysort unicode yr sem: egen fbren0a1 = sum(fbren0xaggb);
bysort unicode yr sem: egen fbren0inv1 = sum(fbren0xinvb);
bysort unicode yr sem: gen fdb0renuni = fbren0a1/fbren0inv1;

bysort state yr sem: egen fbren0a2 = sum(fbren0xaggb);
bysort state yr sem: egen fbren0inv2 = sum(fbren0xinvb);
bysort state yr sem: gen fdb0stateunibed = fbren0a2/fbren0inv2;

bysort r1to5 yr sem: egen fbren0a3 = sum(fbren0xaggb);
bysort r1to5 yr sem: egen fbren0inv3 = sum(fbren0xinvb);
bysort r1to5 yr sem: gen fdb0regunibed = fbren0a3/fbren0inv3;

sort id yr qtr currmon;

/** fbren1x **/

sort id yr qtr currmon;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 2] == 0 & currmon == 3;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 3] == 0 & currmon == 4;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 4] == 0 & currmon == 5;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 2] == 0 & currmon == 7;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 3] == 0 & currmon == 8;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 4] == 0 & currmon == 9;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 2] == 0 & currmon == 11;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 3] == 0 & currmon == 12;

by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 2] == 0 & currmon == 4;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 3] == 0 & currmon == 5;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 4] == 0 & currmon == 6;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 2] == 0 & currmon == 8;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 3] == 0 & currmon == 9;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 4] == 0 & currmon == 10;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 2] == 0 & currmon == 12;

by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 2] == 0 & currmon == 5;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 3] == 0 & currmon == 6;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 4] == 0 & currmon == 7;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 2] == 0 & currmon == 9;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 3] == 0 & currmon == 10;
by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1xM == 1 & fbren1xM[_n - 4] == 0 & currmon == 11;

by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 2] == 0 & currmon == 2;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 3] == 0 & currmon == 1;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 2] == 0 & currmon == 6;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 3] == 0 & currmon == 5;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 4] == 0 & currmon == 4;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 2] == 0 & currmon == 10;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 3] == 0 & currmon == 9;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 4] == 0 & currmon == 8;

by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 2] == 0 & currmon == 1;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 2] == 0 & currmon == 5;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 3] == 0 & currmon == 4;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 4] == 0 & currmon == 3;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 2] == 0 & currmon == 9;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 3] == 0 & currmon == 8;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 4] == 0 & currmon == 7;

by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 2] == 0 & currmon == 4;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 3] == 0 & currmon == 3;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 4] == 0 & currmon == 2;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 2] == 0 & currmon == 8;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 3] == 0 & currmon == 7;
by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1 & fbren1xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace fbren1x = fbren1x[_n - 1]*0.5 + fbren1x[_n + 1]*0.5 if fbren1xM == 1 & fbren1xM[_n - 1] == 0 & fbren1xM[_n + 1] == 0;
by id: replace fbren1x = fbren1x[_n - 1]*0.7 + fbren1x[_n + 2]*0.3 if fbren1xM == 1 & fbren1xM[_n - 1] == 0 & fbren1xM[_n + 2] == 0;
by id: replace fbren1x = fbren1x[_n - 2]*0.3 + fbren1x[_n + 1]*0.7 if fbren1xM == 1 & fbren1xM[_n - 2] == 0 & fbren1xM[_n + 1] == 0;

/** Establish dbrents by unicode, state, region **/

gen fbren1xaggb = fbren1x*beds1x;
replace fbren1xaggb = . if beds1x == 0;
gen fbren1xinvb = beds1x;
replace fbren1xinvb = . if fbren1xaggb == .;

bysort unicode yr sem: egen fbren1a1 = sum(fbren1xaggb);
bysort unicode yr sem: egen fbren1inv1 = sum(fbren1xinvb);
bysort unicode yr sem: gen fdb1renuni = fbren1a1/fbren1inv1;

bysort state yr sem: egen fbren1a2 = sum(fbren1xaggb);
bysort state yr sem: egen fbren1inv2 = sum(fbren1xinvb);
bysort state yr sem: gen fdb1stateunibed = fbren1a2/fbren1inv2;

bysort r1to5 yr sem: egen fbren1a3 = sum(fbren1xaggb);
bysort r1to5 yr sem: egen fbren1inv3 = sum(fbren1xinvb);
bysort r1to5 yr sem: gen fdb1regunibed = fbren1a3/fbren1inv3;

sort id yr qtr currmon;

/** fbren2x **/

sort id yr qtr currmon;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 2] == 0 & currmon == 3;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 3] == 0 & currmon == 4;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 4] == 0 & currmon == 5;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 2] == 0 & currmon == 7;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 3] == 0 & currmon == 8;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 4] == 0 & currmon == 9;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 2] == 0 & currmon == 11;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 3] == 0 & currmon == 12;

by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 2] == 0 & currmon == 4;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 3] == 0 & currmon == 5;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 4] == 0 & currmon == 6;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 2] == 0 & currmon == 8;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 3] == 0 & currmon == 9;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 4] == 0 & currmon == 10;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 2] == 0 & currmon == 12;

by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 2] == 0 & currmon == 5;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 3] == 0 & currmon == 6;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 4] == 0 & currmon == 7;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 2] == 0 & currmon == 9;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 3] == 0 & currmon == 10;
by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2xM == 1 & fbren2xM[_n - 4] == 0 & currmon == 11;

by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 2] == 0 & currmon == 2;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 3] == 0 & currmon == 1;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 2] == 0 & currmon == 6;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 3] == 0 & currmon == 5;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 4] == 0 & currmon == 4;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 2] == 0 & currmon == 10;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 3] == 0 & currmon == 9;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 4] == 0 & currmon == 8;

by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 2] == 0 & currmon == 1;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 2] == 0 & currmon == 5;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 3] == 0 & currmon == 4;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 4] == 0 & currmon == 3;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 2] == 0 & currmon == 9;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 3] == 0 & currmon == 8;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 4] == 0 & currmon == 7;

by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 2] == 0 & currmon == 4;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 3] == 0 & currmon == 3;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 4] == 0 & currmon == 2;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 2] == 0 & currmon == 8;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 3] == 0 & currmon == 7;
by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1 & fbren2xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace fbren2x = fbren2x[_n - 1]*0.5 + fbren2x[_n + 1]*0.5 if fbren2xM == 1 & fbren2xM[_n - 1] == 0 & fbren2xM[_n + 1] == 0;
by id: replace fbren2x = fbren2x[_n - 1]*0.7 + fbren2x[_n + 2]*0.3 if fbren2xM == 1 & fbren2xM[_n - 1] == 0 & fbren2xM[_n + 2] == 0;
by id: replace fbren2x = fbren2x[_n - 2]*0.3 + fbren2x[_n + 1]*0.7 if fbren2xM == 1 & fbren2xM[_n - 2] == 0 & fbren2xM[_n + 1] == 0;

/** Establish dbrents by unicode, state, region **/

gen fbren2xaggb = fbren2x*beds2x;
replace fbren2xaggb = . if beds2x == 0;
gen fbren2xinvb = beds2x;
replace fbren2xinvb = . if fbren2xaggb == .;

bysort unicode yr sem: egen fbren2a1 = sum(fbren2xaggb);
bysort unicode yr sem: egen fbren2inv1 = sum(fbren2xinvb);
bysort unicode yr sem: gen fdb2renuni = fbren2a1/fbren2inv1;

bysort state yr sem: egen fbren2a2 = sum(fbren2xaggb);
bysort state yr sem: egen fbren2inv2 = sum(fbren2xinvb);
bysort state yr sem: gen fdb2stateunibed = fbren2a2/fbren2inv2;

bysort r1to5 yr sem: egen fbren2a3 = sum(fbren2xaggb);
bysort r1to5 yr sem: egen fbren2inv3 = sum(fbren2xinvb);
bysort r1to5 yr sem: gen fdb2regunibed = fbren2a3/fbren2inv3;

sort id yr qtr currmon;

/** fbren3x **/

sort id yr qtr currmon;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 2] == 0 & currmon == 3;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 3] == 0 & currmon == 4;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 4] == 0 & currmon == 5;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 2] == 0 & currmon == 7;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 3] == 0 & currmon == 8;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 4] == 0 & currmon == 9;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 2] == 0 & currmon == 11;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 3] == 0 & currmon == 12;

by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 2] == 0 & currmon == 4;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 3] == 0 & currmon == 5;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 4] == 0 & currmon == 6;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 2] == 0 & currmon == 8;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 3] == 0 & currmon == 9;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 4] == 0 & currmon == 10;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 2] == 0 & currmon == 12;

by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 2] == 0 & currmon == 5;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 3] == 0 & currmon == 6;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 4] == 0 & currmon == 7;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 2] == 0 & currmon == 9;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 3] == 0 & currmon == 10;
by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3xM == 1 & fbren3xM[_n - 4] == 0 & currmon == 11;

by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 2] == 0 & currmon == 2;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 3] == 0 & currmon == 1;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 2] == 0 & currmon == 6;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 3] == 0 & currmon == 5;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 4] == 0 & currmon == 4;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 2] == 0 & currmon == 10;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 3] == 0 & currmon == 9;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 4] == 0 & currmon == 8;

by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 2] == 0 & currmon == 1;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 2] == 0 & currmon == 5;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 3] == 0 & currmon == 4;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 4] == 0 & currmon == 3;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 2] == 0 & currmon == 9;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 3] == 0 & currmon == 8;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 4] == 0 & currmon == 7;

by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 2] == 0 & currmon == 4;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 3] == 0 & currmon == 3;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 4] == 0 & currmon == 2;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 2] == 0 & currmon == 8;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 3] == 0 & currmon == 7;
by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1 & fbren3xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace fbren3x = fbren3x[_n - 1]*0.5 + fbren3x[_n + 1]*0.5 if fbren3xM == 1 & fbren3xM[_n - 1] == 0 & fbren3xM[_n + 1] == 0;
by id: replace fbren3x = fbren3x[_n - 1]*0.7 + fbren3x[_n + 2]*0.3 if fbren3xM == 1 & fbren3xM[_n - 1] == 0 & fbren3xM[_n + 2] == 0;
by id: replace fbren3x = fbren3x[_n - 2]*0.3 + fbren3x[_n + 1]*0.7 if fbren3xM == 1 & fbren3xM[_n - 2] == 0 & fbren3xM[_n + 1] == 0;

/** Establish dbrents by unicode, state, region **/

gen fbren3xaggb = fbren3x*beds3x;
replace fbren3xaggb = . if beds3x == 0;
gen fbren3xinvb = beds3x;
replace fbren3xinvb = . if fbren3xaggb == .;

bysort unicode yr sem: egen fbren3a1 = sum(fbren3xaggb);
bysort unicode yr sem: egen fbren3inv1 = sum(fbren3xinvb);
bysort unicode yr sem: gen fdb3renuni = fbren3a1/fbren3inv1;

bysort state yr sem: egen fbren3a2 = sum(fbren3xaggb);
bysort state yr sem: egen fbren3inv2 = sum(fbren3xinvb);
bysort state yr sem: gen fdb3stateunibed = fbren3a2/fbren3inv2;

bysort r1to5 yr sem: egen fbren3a3 = sum(fbren3xaggb);
bysort r1to5 yr sem: egen fbren3inv3 = sum(fbren3xinvb);
bysort r1to5 yr sem: gen fdb3regunibed = fbren3a3/fbren3inv3;

sort id yr qtr currmon;

/** fbren4x **/

sort id yr qtr currmon;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 2] == 0 & currmon == 3;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 3] == 0 & currmon == 4;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 4] == 0 & currmon == 5;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 2] == 0 & currmon == 7;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 3] == 0 & currmon == 8;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 4] == 0 & currmon == 9;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 2] == 0 & currmon == 11;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 3] == 0 & currmon == 12;

by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 2] == 0 & currmon == 4;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 3] == 0 & currmon == 5;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 4] == 0 & currmon == 6;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 2] == 0 & currmon == 8;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 3] == 0 & currmon == 9;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 4] == 0 & currmon == 10;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 2] == 0 & currmon == 12;

by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 2] == 0 & currmon == 5;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 3] == 0 & currmon == 6;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 4] == 0 & currmon == 7;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 2] == 0 & currmon == 9;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 3] == 0 & currmon == 10;
by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4xM == 1 & fbren4xM[_n - 4] == 0 & currmon == 11;

by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 2] == 0 & currmon == 2;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 3] == 0 & currmon == 1;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 2] == 0 & currmon == 6;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 3] == 0 & currmon == 5;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 4] == 0 & currmon == 4;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 2] == 0 & currmon == 10;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 3] == 0 & currmon == 9;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 4] == 0 & currmon == 8;

by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 2] == 0 & currmon == 1;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 2] == 0 & currmon == 5;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 3] == 0 & currmon == 4;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 4] == 0 & currmon == 3;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 2] == 0 & currmon == 9;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 3] == 0 & currmon == 8;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 4] == 0 & currmon == 7;

by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 2] == 0 & currmon == 4;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 3] == 0 & currmon == 3;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 4] == 0 & currmon == 2;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 2] == 0 & currmon == 8;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 3] == 0 & currmon == 7;
by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1 & fbren4xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace fbren4x = fbren4x[_n - 1]*0.5 + fbren4x[_n + 1]*0.5 if fbren4xM == 1 & fbren4xM[_n - 1] == 0 & fbren4xM[_n + 1] == 0;
by id: replace fbren4x = fbren4x[_n - 1]*0.7 + fbren4x[_n + 2]*0.3 if fbren4xM == 1 & fbren4xM[_n - 1] == 0 & fbren4xM[_n + 2] == 0;
by id: replace fbren4x = fbren4x[_n - 2]*0.3 + fbren4x[_n + 1]*0.7 if fbren4xM == 1 & fbren4xM[_n - 2] == 0 & fbren4xM[_n + 1] == 0;

/** Establish dbrents by unicode, state, region **/

gen fbren4xaggb = fbren4x*beds4x;
replace fbren4xaggb = . if beds4x == 0;
gen fbren4xinvb = beds4x;
replace fbren4xinvb = . if fbren4xaggb == .;

bysort unicode yr sem: egen fbren4a1 = sum(fbren4xaggb);
bysort unicode yr sem: egen fbren4inv1 = sum(fbren4xinvb);
bysort unicode yr sem: gen fdb4renuni = fbren4a1/fbren4inv1;

bysort state yr sem: egen fbren4a2 = sum(fbren4xaggb);
bysort state yr sem: egen fbren4inv2 = sum(fbren4xinvb);
bysort state yr sem: gen fdb4stateunibed = fbren4a2/fbren4inv2;

bysort r1to5 yr sem: egen fbren4a3 = sum(fbren4xaggb);
bysort r1to5 yr sem: egen fbren4inv3 = sum(fbren4xinvb);
bysort r1to5 yr sem: gen fdb4regunibed = fbren4a3/fbren4inv3;

sort id yr qtr currmon;

/** Rationalize DB rents **/

gen fdb0bren = fdb0renuni;
gen fdb1bren = fdb1renuni;
gen fdb2bren = fdb2renuni;
gen fdb3bren = fdb3renuni;
gen fdb4bren = fdb4renuni;

replace fdb0bren = fdb0stateunibed if fdb0bren == .;
replace fdb1bren = fdb1stateunibed if fdb1bren == .;
replace fdb2bren = fdb2stateunibed if fdb2bren == .;
replace fdb3bren = fdb3stateunibed if fdb3bren == .;
replace fdb4bren = fdb4stateunibed if fdb4bren == .;

replace fdb0bren = fdb0regunibed if fdb0bren == .;
replace fdb1bren = fdb1regunibed if fdb1bren == .;
replace fdb2bren = fdb2regunibed if fdb2bren == .;
replace fdb3bren = fdb3regunibed if fdb3bren == .;
replace fdb4bren = fdb4regunibed if fdb4bren == .;

by id: replace fdb2bren = 0.95*fdb1bren if fdb2bren > fdb1bren;
by id: replace fdb3bren = 0.95*fdb2bren if fdb3bren > fdb2bren;
by id: replace fdb4bren = 0.95*fdb3bren if fdb4bren > fdb3bren;

/** Fill in values given dbren assignments **/

sort id yr sem;

by id: egen fbren0xct = count(fbren0x);
by id: egen fbren1xct = count(fbren1x);
by id: egen fbren2xct = count(fbren2x);
by id: egen fbren3xct = count(fbren3x);
by id: egen fbren4xct = count(fbren4x);

sort id yr qtr currmon;

by id: replace fbren0x = fdb0regunibed*unif95 if fbren0xct == 0 & fbren0xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace fbren1x = fdb1regunibed*unif95 if fbren1xct == 0 & fbren1xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace fbren2x = fdb2regunibed*unif95 if fbren2xct == 0 & fbren2xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace fbren3x = fdb3regunibed*unif95 if fbren3xct == 0 & fbren3xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace fbren4x = fdb4regunibed*unif95 if fbren4xct == 0 & fbren4xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9); 

/** Move that shiznits forward! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1;

     local d = `d' + 1;

   };  
   
/** And backwards! **/


  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0x == . & fbren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1x == . & fbren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2x == . & fbren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3x == . & fbren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4x == . & fbren4xM == 1;

     local d = `d' + 1;

   };        

/** Moderate intersemestral changes **/

by id: replace fbren0x = fbren0x[_n - 1]*0.5 + fbren0x[_n + 1]*0.5 if fbren0xM == 1 & (currmon == 5 | currmon == 9);
by id: replace fbren0x = fbren0x[_n - 1]*0.5 + fbren0x[_n + 1]*0.5 if fbren0xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace fbren1x = fbren1x[_n - 1]*0.5 + fbren1x[_n + 1]*0.5 if fbren1xM == 1 & (currmon == 5 | currmon == 9);
by id: replace fbren1x = fbren1x[_n - 1]*0.5 + fbren1x[_n + 1]*0.5 if fbren1xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace fbren2x = fbren2x[_n - 1]*0.5 + fbren2x[_n + 1]*0.5 if fbren2xM == 1 & (currmon == 5 | currmon == 9);
by id: replace fbren2x = fbren2x[_n - 1]*0.5 + fbren2x[_n + 1]*0.5 if fbren2xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace fbren3x = fbren3x[_n - 1]*0.5 + fbren3x[_n + 1]*0.5 if fbren3xM == 1 & (currmon == 5 | currmon == 9);
by id: replace fbren3x = fbren3x[_n - 1]*0.5 + fbren3x[_n + 1]*0.5 if fbren3xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace fbren4x = fbren4x[_n - 1]*0.5 + fbren4x[_n + 1]*0.5 if fbren4xM == 1 & (currmon == 5 | currmon == 9);
by id: replace fbren4x = fbren4x[_n - 1]*0.5 + fbren4x[_n + 1]*0.5 if fbren4xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

      
       
/** Moderate stretches of "no survey" **/

by id: replace fbren0x = fbren0x[_n - 1]*0.8 + fbren0x[_n + 3]*0.2 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n + 1] == 1 & fbren0xM[_n + 2] == 1 
       & fbren0xM[_n + 3] == 1 & currmon == 2;
by id: replace fbren0x = fbren0x[_n - 2]*0.5 + fbren0x[_n + 2]*0.5 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n + 1] == 1 
       & fbren0xM[_n + 2] == 1 & currmon == 3;   
by id: replace fbren0x = fbren0x[_n - 3]*0.2 + fbren0x[_n + 3]*0.8 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n - 3] == 1 
       & fbren0xM[_n + 1] == 1 & currmon == 4;  
by id: replace fbren0x = fbren0x[_n - 1]*0.8 + fbren0x[_n + 3]*0.2 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n + 1] == 1 & fbren0xM[_n + 2] == 1 
       & fbren0xM[_n + 3] == 1 & currmon == 4;
by id: replace fbren0x = fbren0x[_n - 2]*0.5 + fbren0x[_n + 2]*0.5 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n + 1] == 1 
       & fbren0xM[_n + 2] == 1 & currmon == 5;   
by id: replace fbren0x = fbren0x[_n - 3]*0.2 + fbren0x[_n + 3]*0.8 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n - 3] == 1 
       & fbren0xM[_n + 1] == 1 & currmon == 6;       
by id: replace fbren0x = fbren0x[_n - 1]*0.8 + fbren0x[_n + 3]*0.2 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n + 1] == 1 & fbren0xM[_n + 2] == 1 
       & fbren0xM[_n + 3] == 1 & currmon == 5;
by id: replace fbren0x = fbren0x[_n - 2]*0.5 + fbren0x[_n + 2]*0.5 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n + 1] == 1 
       & fbren0xM[_n + 2] == 1 & currmon == 6;   
by id: replace fbren0x = fbren0x[_n - 3]*0.2 + fbren0x[_n + 3]*0.8 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n - 3] == 1 
       & fbren0xM[_n + 1] == 1 & currmon == 7;
by id: replace fbren0x = fbren0x[_n - 1]*0.8 + fbren0x[_n + 3]*0.2 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n + 1] == 1 & fbren0xM[_n + 2] == 1 
       & fbren0xM[_n + 3] == 1 & currmon == 6;
by id: replace fbren0x = fbren0x[_n - 2]*0.5 + fbren0x[_n + 2]*0.5 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n + 1] == 1 
       & fbren0xM[_n + 2] == 1 & currmon == 7;   
by id: replace fbren0x = fbren0x[_n - 3]*0.2 + fbren0x[_n + 3]*0.8 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n - 3] == 1 
       & fbren0xM[_n + 1] == 1 & currmon == 8;       
by id: replace fbren0x = fbren0x[_n - 1]*0.8 + fbren0x[_n + 3]*0.2 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n + 1] == 1 & fbren0xM[_n + 2] == 1 
       & fbren0xM[_n + 3] == 1 & currmon == 7;
by id: replace fbren0x = fbren0x[_n - 2]*0.5 + fbren0x[_n + 2]*0.5 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n + 1] == 1 
       & fbren0xM[_n + 2] == 1 & currmon == 8;   
by id: replace fbren0x = fbren0x[_n - 3]*0.2 + fbren0x[_n + 3]*0.8 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n - 3] == 1 
       & fbren0xM[_n + 1] == 1 & currmon == 9;
by id: replace fbren0x = fbren0x[_n - 1]*0.8 + fbren0x[_n + 3]*0.2 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n + 1] == 1 & fbren0xM[_n + 2] == 1 
       & fbren0xM[_n + 3] == 1 & currmon == 8;
by id: replace fbren0x = fbren0x[_n - 2]*0.5 + fbren0x[_n + 2]*0.5 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n + 1] == 1 
       & fbren0xM[_n + 2] == 1 & currmon == 9;   
by id: replace fbren0x = fbren0x[_n - 3]*0.2 + fbren0x[_n + 3]*0.8 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n - 3] == 1 
       & fbren0xM[_n + 1] == 1 & currmon == 10;
by id: replace fbren0x = fbren0x[_n - 1]*0.8 + fbren0x[_n + 3]*0.2 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n + 1] == 1 & fbren0xM[_n + 2] == 1 
       & fbren0xM[_n + 3] == 1 & currmon == 9;
by id: replace fbren0x = fbren0x[_n - 2]*0.5 + fbren0x[_n + 2]*0.5 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n + 1] == 1 
       & fbren0xM[_n + 2] == 1 & currmon == 10;   
by id: replace fbren0x = fbren0x[_n - 3]*0.2 + fbren0x[_n + 3]*0.8 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n - 3] == 1 
       & fbren0xM[_n + 1] == 1 & currmon == 11;       
by id: replace fbren0x = fbren0x[_n - 1]*0.8 + fbren0x[_n + 3]*0.2 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n + 1] == 1 & fbren0xM[_n + 2] == 1 
       & fbren0xM[_n + 3] == 1 & currmon == 10;
by id: replace fbren0x = fbren0x[_n - 2]*0.5 + fbren0x[_n + 2]*0.5 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n + 1] == 1 
       & fbren0xM[_n + 2] == 1 & currmon == 11;   
by id: replace fbren0x = fbren0x[_n - 3]*0.2 + fbren0x[_n + 3]*0.8 if fbren0xM == 1 & fbren0xM[_n - 1] == 1 & fbren0xM[_n - 2] == 1 & fbren0xM[_n - 3] == 1 
       & fbren0xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace fbren1x = fbren1x[_n - 1]*0.8 + fbren1x[_n + 3]*0.2 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n + 1] == 1 & fbren1xM[_n + 2] == 1 
       & fbren1xM[_n + 3] == 1 & currmon == 2;
by id: replace fbren1x = fbren1x[_n - 2]*0.5 + fbren1x[_n + 2]*0.5 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n + 1] == 1 
       & fbren1xM[_n + 2] == 1 & currmon == 3;   
by id: replace fbren1x = fbren1x[_n - 3]*0.2 + fbren1x[_n + 3]*0.8 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n - 3] == 1 
       & fbren1xM[_n + 1] == 1 & currmon == 4;  
by id: replace fbren1x = fbren1x[_n - 1]*0.8 + fbren1x[_n + 3]*0.2 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n + 1] == 1 & fbren1xM[_n + 2] == 1 
       & fbren1xM[_n + 3] == 1 & currmon == 4;
by id: replace fbren1x = fbren1x[_n - 2]*0.5 + fbren1x[_n + 2]*0.5 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n + 1] == 1 
       & fbren1xM[_n + 2] == 1 & currmon == 5;   
by id: replace fbren1x = fbren1x[_n - 3]*0.2 + fbren1x[_n + 3]*0.8 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n - 3] == 1 
       & fbren1xM[_n + 1] == 1 & currmon == 6;       
by id: replace fbren1x = fbren1x[_n - 1]*0.8 + fbren1x[_n + 3]*0.2 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n + 1] == 1 & fbren1xM[_n + 2] == 1 
       & fbren1xM[_n + 3] == 1 & currmon == 5;
by id: replace fbren1x = fbren1x[_n - 2]*0.5 + fbren1x[_n + 2]*0.5 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n + 1] == 1 
       & fbren1xM[_n + 2] == 1 & currmon == 6;   
by id: replace fbren1x = fbren1x[_n - 3]*0.2 + fbren1x[_n + 3]*0.8 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n - 3] == 1 
       & fbren1xM[_n + 1] == 1 & currmon == 7;
by id: replace fbren1x = fbren1x[_n - 1]*0.8 + fbren1x[_n + 3]*0.2 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n + 1] == 1 & fbren1xM[_n + 2] == 1 
       & fbren1xM[_n + 3] == 1 & currmon == 6;
by id: replace fbren1x = fbren1x[_n - 2]*0.5 + fbren1x[_n + 2]*0.5 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n + 1] == 1 
       & fbren1xM[_n + 2] == 1 & currmon == 7;   
by id: replace fbren1x = fbren1x[_n - 3]*0.2 + fbren1x[_n + 3]*0.8 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n - 3] == 1 
       & fbren1xM[_n + 1] == 1 & currmon == 8;       
by id: replace fbren1x = fbren1x[_n - 1]*0.8 + fbren1x[_n + 3]*0.2 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n + 1] == 1 & fbren1xM[_n + 2] == 1 
       & fbren1xM[_n + 3] == 1 & currmon == 7;
by id: replace fbren1x = fbren1x[_n - 2]*0.5 + fbren1x[_n + 2]*0.5 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n + 1] == 1 
       & fbren1xM[_n + 2] == 1 & currmon == 8;   
by id: replace fbren1x = fbren1x[_n - 3]*0.2 + fbren1x[_n + 3]*0.8 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n - 3] == 1 
       & fbren1xM[_n + 1] == 1 & currmon == 9;
by id: replace fbren1x = fbren1x[_n - 1]*0.8 + fbren1x[_n + 3]*0.2 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n + 1] == 1 & fbren1xM[_n + 2] == 1 
       & fbren1xM[_n + 3] == 1 & currmon == 8;
by id: replace fbren1x = fbren1x[_n - 2]*0.5 + fbren1x[_n + 2]*0.5 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n + 1] == 1 
       & fbren1xM[_n + 2] == 1 & currmon == 9;   
by id: replace fbren1x = fbren1x[_n - 3]*0.2 + fbren1x[_n + 3]*0.8 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n - 3] == 1 
       & fbren1xM[_n + 1] == 1 & currmon == 10;
by id: replace fbren1x = fbren1x[_n - 1]*0.8 + fbren1x[_n + 3]*0.2 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n + 1] == 1 & fbren1xM[_n + 2] == 1 
       & fbren1xM[_n + 3] == 1 & currmon == 9;
by id: replace fbren1x = fbren1x[_n - 2]*0.5 + fbren1x[_n + 2]*0.5 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n + 1] == 1 
       & fbren1xM[_n + 2] == 1 & currmon == 10;   
by id: replace fbren1x = fbren1x[_n - 3]*0.2 + fbren1x[_n + 3]*0.8 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n - 3] == 1 
       & fbren1xM[_n + 1] == 1 & currmon == 11;       
by id: replace fbren1x = fbren1x[_n - 1]*0.8 + fbren1x[_n + 3]*0.2 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n + 1] == 1 & fbren1xM[_n + 2] == 1 
       & fbren1xM[_n + 3] == 1 & currmon == 10;
by id: replace fbren1x = fbren1x[_n - 2]*0.5 + fbren1x[_n + 2]*0.5 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n + 1] == 1 
       & fbren1xM[_n + 2] == 1 & currmon == 11;   
by id: replace fbren1x = fbren1x[_n - 3]*0.2 + fbren1x[_n + 3]*0.8 if fbren1xM == 1 & fbren1xM[_n - 1] == 1 & fbren1xM[_n - 2] == 1 & fbren1xM[_n - 3] == 1 
       & fbren1xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace fbren2x = fbren2x[_n - 1]*0.8 + fbren2x[_n + 3]*0.2 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n + 1] == 1 & fbren2xM[_n + 2] == 1 
       & fbren2xM[_n + 3] == 1 & currmon == 2;
by id: replace fbren2x = fbren2x[_n - 2]*0.5 + fbren2x[_n + 2]*0.5 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n + 1] == 1 
       & fbren2xM[_n + 2] == 1 & currmon == 3;   
by id: replace fbren2x = fbren2x[_n - 3]*0.2 + fbren2x[_n + 3]*0.8 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n - 3] == 1 
       & fbren2xM[_n + 1] == 1 & currmon == 4;  
by id: replace fbren2x = fbren2x[_n - 1]*0.8 + fbren2x[_n + 3]*0.2 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n + 1] == 1 & fbren2xM[_n + 2] == 1 
       & fbren2xM[_n + 3] == 1 & currmon == 4;
by id: replace fbren2x = fbren2x[_n - 2]*0.5 + fbren2x[_n + 2]*0.5 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n + 1] == 1 
       & fbren2xM[_n + 2] == 1 & currmon == 5;   
by id: replace fbren2x = fbren2x[_n - 3]*0.2 + fbren2x[_n + 3]*0.8 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n - 3] == 1 
       & fbren2xM[_n + 1] == 1 & currmon == 6;       
by id: replace fbren2x = fbren2x[_n - 1]*0.8 + fbren2x[_n + 3]*0.2 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n + 1] == 1 & fbren2xM[_n + 2] == 1 
       & fbren2xM[_n + 3] == 1 & currmon == 5;
by id: replace fbren2x = fbren2x[_n - 2]*0.5 + fbren2x[_n + 2]*0.5 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n + 1] == 1 
       & fbren2xM[_n + 2] == 1 & currmon == 6;   
by id: replace fbren2x = fbren2x[_n - 3]*0.2 + fbren2x[_n + 3]*0.8 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n - 3] == 1 
       & fbren2xM[_n + 1] == 1 & currmon == 7;
by id: replace fbren2x = fbren2x[_n - 1]*0.8 + fbren2x[_n + 3]*0.2 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n + 1] == 1 & fbren2xM[_n + 2] == 1 
       & fbren2xM[_n + 3] == 1 & currmon == 6;
by id: replace fbren2x = fbren2x[_n - 2]*0.5 + fbren2x[_n + 2]*0.5 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n + 1] == 1 
       & fbren2xM[_n + 2] == 1 & currmon == 7;   
by id: replace fbren2x = fbren2x[_n - 3]*0.2 + fbren2x[_n + 3]*0.8 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n - 3] == 1 
       & fbren2xM[_n + 1] == 1 & currmon == 8;       
by id: replace fbren2x = fbren2x[_n - 1]*0.8 + fbren2x[_n + 3]*0.2 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n + 1] == 1 & fbren2xM[_n + 2] == 1 
       & fbren2xM[_n + 3] == 1 & currmon == 7;
by id: replace fbren2x = fbren2x[_n - 2]*0.5 + fbren2x[_n + 2]*0.5 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n + 1] == 1 
       & fbren2xM[_n + 2] == 1 & currmon == 8;   
by id: replace fbren2x = fbren2x[_n - 3]*0.2 + fbren2x[_n + 3]*0.8 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n - 3] == 1 
       & fbren2xM[_n + 1] == 1 & currmon == 9;
by id: replace fbren2x = fbren2x[_n - 1]*0.8 + fbren2x[_n + 3]*0.2 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n + 1] == 1 & fbren2xM[_n + 2] == 1 
       & fbren2xM[_n + 3] == 1 & currmon == 8;
by id: replace fbren2x = fbren2x[_n - 2]*0.5 + fbren2x[_n + 2]*0.5 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n + 1] == 1 
       & fbren2xM[_n + 2] == 1 & currmon == 9;   
by id: replace fbren2x = fbren2x[_n - 3]*0.2 + fbren2x[_n + 3]*0.8 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n - 3] == 1 
       & fbren2xM[_n + 1] == 1 & currmon == 10;
by id: replace fbren2x = fbren2x[_n - 1]*0.8 + fbren2x[_n + 3]*0.2 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n + 1] == 1 & fbren2xM[_n + 2] == 1 
       & fbren2xM[_n + 3] == 1 & currmon == 9;
by id: replace fbren2x = fbren2x[_n - 2]*0.5 + fbren2x[_n + 2]*0.5 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n + 1] == 1 
       & fbren2xM[_n + 2] == 1 & currmon == 10;   
by id: replace fbren2x = fbren2x[_n - 3]*0.2 + fbren2x[_n + 3]*0.8 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n - 3] == 1 
       & fbren2xM[_n + 1] == 1 & currmon == 11;       
by id: replace fbren2x = fbren2x[_n - 1]*0.8 + fbren2x[_n + 3]*0.2 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n + 1] == 1 & fbren2xM[_n + 2] == 1 
       & fbren2xM[_n + 3] == 1 & currmon == 10;
by id: replace fbren2x = fbren2x[_n - 2]*0.5 + fbren2x[_n + 2]*0.5 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n + 1] == 1 
       & fbren2xM[_n + 2] == 1 & currmon == 11;   
by id: replace fbren2x = fbren2x[_n - 3]*0.2 + fbren2x[_n + 3]*0.8 if fbren2xM == 1 & fbren2xM[_n - 1] == 1 & fbren2xM[_n - 2] == 1 & fbren2xM[_n - 3] == 1 
       & fbren2xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace fbren3x = fbren3x[_n - 1]*0.8 + fbren3x[_n + 3]*0.2 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n + 1] == 1 & fbren3xM[_n + 2] == 1 
       & fbren3xM[_n + 3] == 1 & currmon == 2;
by id: replace fbren3x = fbren3x[_n - 2]*0.5 + fbren3x[_n + 2]*0.5 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n + 1] == 1 
       & fbren3xM[_n + 2] == 1 & currmon == 3;   
by id: replace fbren3x = fbren3x[_n - 3]*0.2 + fbren3x[_n + 3]*0.8 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n - 3] == 1 
       & fbren3xM[_n + 1] == 1 & currmon == 4;  
by id: replace fbren3x = fbren3x[_n - 1]*0.8 + fbren3x[_n + 3]*0.2 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n + 1] == 1 & fbren3xM[_n + 2] == 1 
       & fbren3xM[_n + 3] == 1 & currmon == 4;
by id: replace fbren3x = fbren3x[_n - 2]*0.5 + fbren3x[_n + 2]*0.5 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n + 1] == 1 
       & fbren3xM[_n + 2] == 1 & currmon == 5;   
by id: replace fbren3x = fbren3x[_n - 3]*0.2 + fbren3x[_n + 3]*0.8 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n - 3] == 1 
       & fbren3xM[_n + 1] == 1 & currmon == 6;       
by id: replace fbren3x = fbren3x[_n - 1]*0.8 + fbren3x[_n + 3]*0.2 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n + 1] == 1 & fbren3xM[_n + 2] == 1 
       & fbren3xM[_n + 3] == 1 & currmon == 5;
by id: replace fbren3x = fbren3x[_n - 2]*0.5 + fbren3x[_n + 2]*0.5 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n + 1] == 1 
       & fbren3xM[_n + 2] == 1 & currmon == 6;   
by id: replace fbren3x = fbren3x[_n - 3]*0.2 + fbren3x[_n + 3]*0.8 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n - 3] == 1 
       & fbren3xM[_n + 1] == 1 & currmon == 7;
by id: replace fbren3x = fbren3x[_n - 1]*0.8 + fbren3x[_n + 3]*0.2 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n + 1] == 1 & fbren3xM[_n + 2] == 1 
       & fbren3xM[_n + 3] == 1 & currmon == 6;
by id: replace fbren3x = fbren3x[_n - 2]*0.5 + fbren3x[_n + 2]*0.5 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n + 1] == 1 
       & fbren3xM[_n + 2] == 1 & currmon == 7;   
by id: replace fbren3x = fbren3x[_n - 3]*0.2 + fbren3x[_n + 3]*0.8 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n - 3] == 1 
       & fbren3xM[_n + 1] == 1 & currmon == 8;       
by id: replace fbren3x = fbren3x[_n - 1]*0.8 + fbren3x[_n + 3]*0.2 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n + 1] == 1 & fbren3xM[_n + 2] == 1 
       & fbren3xM[_n + 3] == 1 & currmon == 7;
by id: replace fbren3x = fbren3x[_n - 2]*0.5 + fbren3x[_n + 2]*0.5 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n + 1] == 1 
       & fbren3xM[_n + 2] == 1 & currmon == 8;   
by id: replace fbren3x = fbren3x[_n - 3]*0.2 + fbren3x[_n + 3]*0.8 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n - 3] == 1 
       & fbren3xM[_n + 1] == 1 & currmon == 9;
by id: replace fbren3x = fbren3x[_n - 1]*0.8 + fbren3x[_n + 3]*0.2 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n + 1] == 1 & fbren3xM[_n + 2] == 1 
       & fbren3xM[_n + 3] == 1 & currmon == 8;
by id: replace fbren3x = fbren3x[_n - 2]*0.5 + fbren3x[_n + 2]*0.5 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n + 1] == 1 
       & fbren3xM[_n + 2] == 1 & currmon == 9;   
by id: replace fbren3x = fbren3x[_n - 3]*0.2 + fbren3x[_n + 3]*0.8 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n - 3] == 1 
       & fbren3xM[_n + 1] == 1 & currmon == 10;
by id: replace fbren3x = fbren3x[_n - 1]*0.8 + fbren3x[_n + 3]*0.2 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n + 1] == 1 & fbren3xM[_n + 2] == 1 
       & fbren3xM[_n + 3] == 1 & currmon == 9;
by id: replace fbren3x = fbren3x[_n - 2]*0.5 + fbren3x[_n + 2]*0.5 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n + 1] == 1 
       & fbren3xM[_n + 2] == 1 & currmon == 10;   
by id: replace fbren3x = fbren3x[_n - 3]*0.2 + fbren3x[_n + 3]*0.8 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n - 3] == 1 
       & fbren3xM[_n + 1] == 1 & currmon == 11;       
by id: replace fbren3x = fbren3x[_n - 1]*0.8 + fbren3x[_n + 3]*0.2 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n + 1] == 1 & fbren3xM[_n + 2] == 1 
       & fbren3xM[_n + 3] == 1 & currmon == 10;
by id: replace fbren3x = fbren3x[_n - 2]*0.5 + fbren3x[_n + 2]*0.5 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n + 1] == 1 
       & fbren3xM[_n + 2] == 1 & currmon == 11;   
by id: replace fbren3x = fbren3x[_n - 3]*0.2 + fbren3x[_n + 3]*0.8 if fbren3xM == 1 & fbren3xM[_n - 1] == 1 & fbren3xM[_n - 2] == 1 & fbren3xM[_n - 3] == 1 
       & fbren3xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace fbren4x = fbren4x[_n - 1]*0.8 + fbren4x[_n + 3]*0.2 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n + 1] == 1 & fbren4xM[_n + 2] == 1 
       & fbren4xM[_n + 3] == 1 & currmon == 2;
by id: replace fbren4x = fbren4x[_n - 2]*0.5 + fbren4x[_n + 2]*0.5 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n + 1] == 1 
       & fbren4xM[_n + 2] == 1 & currmon == 3;   
by id: replace fbren4x = fbren4x[_n - 3]*0.2 + fbren4x[_n + 3]*0.8 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n - 3] == 1 
       & fbren4xM[_n + 1] == 1 & currmon == 4;  
by id: replace fbren4x = fbren4x[_n - 1]*0.8 + fbren4x[_n + 3]*0.2 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n + 1] == 1 & fbren4xM[_n + 2] == 1 
       & fbren4xM[_n + 3] == 1 & currmon == 4;
by id: replace fbren4x = fbren4x[_n - 2]*0.5 + fbren4x[_n + 2]*0.5 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n + 1] == 1 
       & fbren4xM[_n + 2] == 1 & currmon == 5;   
by id: replace fbren4x = fbren4x[_n - 3]*0.2 + fbren4x[_n + 3]*0.8 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n - 3] == 1 
       & fbren4xM[_n + 1] == 1 & currmon == 6;       
by id: replace fbren4x = fbren4x[_n - 1]*0.8 + fbren4x[_n + 3]*0.2 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n + 1] == 1 & fbren4xM[_n + 2] == 1 
       & fbren4xM[_n + 3] == 1 & currmon == 5;
by id: replace fbren4x = fbren4x[_n - 2]*0.5 + fbren4x[_n + 2]*0.5 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n + 1] == 1 
       & fbren4xM[_n + 2] == 1 & currmon == 6;   
by id: replace fbren4x = fbren4x[_n - 3]*0.2 + fbren4x[_n + 3]*0.8 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n - 3] == 1 
       & fbren4xM[_n + 1] == 1 & currmon == 7;
by id: replace fbren4x = fbren4x[_n - 1]*0.8 + fbren4x[_n + 3]*0.2 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n + 1] == 1 & fbren4xM[_n + 2] == 1 
       & fbren4xM[_n + 3] == 1 & currmon == 6;
by id: replace fbren4x = fbren4x[_n - 2]*0.5 + fbren4x[_n + 2]*0.5 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n + 1] == 1 
       & fbren4xM[_n + 2] == 1 & currmon == 7;   
by id: replace fbren4x = fbren4x[_n - 3]*0.2 + fbren4x[_n + 3]*0.8 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n - 3] == 1 
       & fbren4xM[_n + 1] == 1 & currmon == 8;       
by id: replace fbren4x = fbren4x[_n - 1]*0.8 + fbren4x[_n + 3]*0.2 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n + 1] == 1 & fbren4xM[_n + 2] == 1 
       & fbren4xM[_n + 3] == 1 & currmon == 7;
by id: replace fbren4x = fbren4x[_n - 2]*0.5 + fbren4x[_n + 2]*0.5 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n + 1] == 1 
       & fbren4xM[_n + 2] == 1 & currmon == 8;   
by id: replace fbren4x = fbren4x[_n - 3]*0.2 + fbren4x[_n + 3]*0.8 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n - 3] == 1 
       & fbren4xM[_n + 1] == 1 & currmon == 9;
by id: replace fbren4x = fbren4x[_n - 1]*0.8 + fbren4x[_n + 3]*0.2 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n + 1] == 1 & fbren4xM[_n + 2] == 1 
       & fbren4xM[_n + 3] == 1 & currmon == 8;
by id: replace fbren4x = fbren4x[_n - 2]*0.5 + fbren4x[_n + 2]*0.5 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n + 1] == 1 
       & fbren4xM[_n + 2] == 1 & currmon == 9;   
by id: replace fbren4x = fbren4x[_n - 3]*0.2 + fbren4x[_n + 3]*0.8 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n - 3] == 1 
       & fbren4xM[_n + 1] == 1 & currmon == 10;
by id: replace fbren4x = fbren4x[_n - 1]*0.8 + fbren4x[_n + 3]*0.2 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n + 1] == 1 & fbren4xM[_n + 2] == 1 
       & fbren4xM[_n + 3] == 1 & currmon == 9;
by id: replace fbren4x = fbren4x[_n - 2]*0.5 + fbren4x[_n + 2]*0.5 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n + 1] == 1 
       & fbren4xM[_n + 2] == 1 & currmon == 10;   
by id: replace fbren4x = fbren4x[_n - 3]*0.2 + fbren4x[_n + 3]*0.8 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n - 3] == 1 
       & fbren4xM[_n + 1] == 1 & currmon == 11;       
by id: replace fbren4x = fbren4x[_n - 1]*0.8 + fbren4x[_n + 3]*0.2 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n + 1] == 1 & fbren4xM[_n + 2] == 1 
       & fbren4xM[_n + 3] == 1 & currmon == 10;
by id: replace fbren4x = fbren4x[_n - 2]*0.5 + fbren4x[_n + 2]*0.5 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n + 1] == 1 
       & fbren4xM[_n + 2] == 1 & currmon == 11;   
by id: replace fbren4x = fbren4x[_n - 3]*0.2 + fbren4x[_n + 3]*0.8 if fbren4xM == 1 & fbren4xM[_n - 1] == 1 & fbren4xM[_n - 2] == 1 & fbren4xM[_n - 3] == 1 
       & fbren4xM[_n + 1] == 1 & currmon == 12; 	   

/** Move that shiznits forward! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren0x = fbren0x[_n + 1]/(1 + mcpid) if fbren0x == . & fbren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren1x = fbren1x[_n + 1]/(1 + mcpid) if fbren1x == . & fbren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren2x = fbren2x[_n + 1]/(1 + mcpid) if fbren2x == . & fbren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren3x = fbren3x[_n + 1]/(1 + mcpid) if fbren3x == . & fbren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren4x = fbren4x[_n + 1]/(1 + mcpid) if fbren4x == . & fbren4xM == 1;

     local d = `d' + 1;

   };  
   
/** And backwards! **/


  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren0x = fbren0x[_n - 1]*(1 + mcpid) if fbren0x == . & fbren0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren1x = fbren1x[_n - 1]*(1 + mcpid) if fbren1x == . & fbren1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren2x = fbren2x[_n - 1]*(1 + mcpid) if fbren2x == . & fbren2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren3x = fbren3x[_n - 1]*(1 + mcpid) if fbren3x == . & fbren3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace fbren4x = fbren4x[_n - 1]*(1 + mcpid) if fbren4x == . & fbren4xM == 1;

     local d = `d' + 1;

   };       	   
	   
	   
/** Finally, the "FUTURE" represents only ONE number, so just take the latest figure **/

by id: egen fbren0xl = lastnm(fbren0x);
by id: egen fbren1xl = lastnm(fbren1x);
by id: egen fbren2xl = lastnm(fbren2x);
by id: egen fbren3xl = lastnm(fbren3x);
by id: egen fbren4xl = lastnm(fbren4x);

/** Expand pool given surveyed levels **/

/** furen0x **/

sort id yr qtr currmon;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 2] == 0 & currmon == 3;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 3] == 0 & currmon == 4;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 4] == 0 & currmon == 5;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 2] == 0 & currmon == 7;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 3] == 0 & currmon == 8;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 4] == 0 & currmon == 9;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 2] == 0 & currmon == 11;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 3] == 0 & currmon == 12;

by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 2] == 0 & currmon == 4;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 3] == 0 & currmon == 5;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 4] == 0 & currmon == 6;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 2] == 0 & currmon == 8;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 3] == 0 & currmon == 9;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 4] == 0 & currmon == 10;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 2] == 0 & currmon == 12;

by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 2] == 0 & currmon == 5;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 3] == 0 & currmon == 6;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 4] == 0 & currmon == 7;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 2] == 0 & currmon == 9;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 3] == 0 & currmon == 10;
by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0xM == 1 & furen0xM[_n - 4] == 0 & currmon == 11;

by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 2] == 0 & currmon == 2;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 3] == 0 & currmon == 1;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 2] == 0 & currmon == 6;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 3] == 0 & currmon == 5;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 4] == 0 & currmon == 4;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 2] == 0 & currmon == 10;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 3] == 0 & currmon == 9;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 4] == 0 & currmon == 8;

by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 2] == 0 & currmon == 1;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 2] == 0 & currmon == 5;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 3] == 0 & currmon == 4;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 4] == 0 & currmon == 3;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 2] == 0 & currmon == 9;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 3] == 0 & currmon == 8;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 4] == 0 & currmon == 7;

by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 2] == 0 & currmon == 4;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 3] == 0 & currmon == 3;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 4] == 0 & currmon == 2;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 2] == 0 & currmon == 8;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 3] == 0 & currmon == 7;
by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1 & furen0xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace furen0x = furen0x[_n - 1]*0.5 + furen0x[_n + 1]*0.5 if furen0xM == 1 & furen0xM[_n - 1] == 0 & furen0xM[_n + 1] == 0;
by id: replace furen0x = furen0x[_n - 1]*0.7 + furen0x[_n + 2]*0.3 if furen0xM == 1 & furen0xM[_n - 1] == 0 & furen0xM[_n + 2] == 0;
by id: replace furen0x = furen0x[_n - 2]*0.3 + furen0x[_n + 1]*0.7 if furen0xM == 1 & furen0xM[_n - 2] == 0 & furen0xM[_n + 1] == 0;

/** Establish dbrents by unicode, state, region **/

gen furen0xaggb = furen0x*beds0x;
replace furen0xaggb = . if beds0x == 0;
gen furen0xinvb = beds0x;
replace furen0xinvb = . if furen0xaggb == .;

bysort unicode yr sem: egen furen0a1 = sum(furen0xaggb);
bysort unicode yr sem: egen furen0inv1 = sum(furen0xinvb);
bysort unicode yr sem: gen fdb0urenuni = furen0a1/furen0inv1;

bysort state yr sem: egen furen0a2 = sum(furen0xaggb);
bysort state yr sem: egen furen0inv2 = sum(furen0xinvb);
bysort state yr sem: gen fdb0stateuniunit = furen0a2/furen0inv2;

bysort r1to5 yr sem: egen furen0a3 = sum(furen0xaggb);
bysort r1to5 yr sem: egen furen0inv3 = sum(furen0xinvb);
bysort r1to5 yr sem: gen fdb0reguniunit = furen0a3/furen0inv3;

sort id yr qtr currmon;

/** furen1x **/

sort id yr qtr currmon;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 2] == 0 & currmon == 3;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 3] == 0 & currmon == 4;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 4] == 0 & currmon == 5;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 2] == 0 & currmon == 7;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 3] == 0 & currmon == 8;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 4] == 0 & currmon == 9;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 2] == 0 & currmon == 11;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 3] == 0 & currmon == 12;

by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 2] == 0 & currmon == 4;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 3] == 0 & currmon == 5;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 4] == 0 & currmon == 6;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 2] == 0 & currmon == 8;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 3] == 0 & currmon == 9;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 4] == 0 & currmon == 10;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 2] == 0 & currmon == 12;

by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 2] == 0 & currmon == 5;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 3] == 0 & currmon == 6;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 4] == 0 & currmon == 7;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 2] == 0 & currmon == 9;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 3] == 0 & currmon == 10;
by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1xM == 1 & furen1xM[_n - 4] == 0 & currmon == 11;

by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 2] == 0 & currmon == 2;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 3] == 0 & currmon == 1;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 2] == 0 & currmon == 6;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 3] == 0 & currmon == 5;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 4] == 0 & currmon == 4;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 2] == 0 & currmon == 10;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 3] == 0 & currmon == 9;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 4] == 0 & currmon == 8;

by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 2] == 0 & currmon == 1;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 2] == 0 & currmon == 5;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 3] == 0 & currmon == 4;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 4] == 0 & currmon == 3;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 2] == 0 & currmon == 9;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 3] == 0 & currmon == 8;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 4] == 0 & currmon == 7;

by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 2] == 0 & currmon == 4;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 3] == 0 & currmon == 3;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 4] == 0 & currmon == 2;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 2] == 0 & currmon == 8;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 3] == 0 & currmon == 7;
by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1 & furen1xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace furen1x = furen1x[_n - 1]*0.5 + furen1x[_n + 1]*0.5 if furen1xM == 1 & furen1xM[_n - 1] == 0 & furen1xM[_n + 1] == 0;
by id: replace furen1x = furen1x[_n - 1]*0.7 + furen1x[_n + 2]*0.3 if furen1xM == 1 & furen1xM[_n - 1] == 0 & furen1xM[_n + 2] == 0;
by id: replace furen1x = furen1x[_n - 2]*0.3 + furen1x[_n + 1]*0.7 if furen1xM == 1 & furen1xM[_n - 2] == 0 & furen1xM[_n + 1] == 0;

/** Establish dbrents by unicode, state, region **/

gen furen1xaggb = furen1x*beds1x;
replace furen1xaggb = . if beds1x == 0;
gen furen1xinvb = beds1x;
replace furen1xinvb = . if furen1xaggb == .;

bysort unicode yr sem: egen furen1a1 = sum(furen1xaggb);
bysort unicode yr sem: egen furen1inv1 = sum(furen1xinvb);
bysort unicode yr sem: gen fdb1urenuni = furen1a1/furen1inv1;

bysort state yr sem: egen furen1a2 = sum(furen1xaggb);
bysort state yr sem: egen furen1inv2 = sum(furen1xinvb);
bysort state yr sem: gen fdb1stateuniunit = furen1a2/furen1inv2;

bysort r1to5 yr sem: egen furen1a3 = sum(furen1xaggb);
bysort r1to5 yr sem: egen furen1inv3 = sum(furen1xinvb);
bysort r1to5 yr sem: gen fdb1reguniunit = furen1a3/furen1inv3;

sort id yr qtr currmon;

/** furen2x **/

sort id yr qtr currmon;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 2] == 0 & currmon == 3;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 3] == 0 & currmon == 4;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 4] == 0 & currmon == 5;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 2] == 0 & currmon == 7;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 3] == 0 & currmon == 8;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 4] == 0 & currmon == 9;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 2] == 0 & currmon == 11;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 3] == 0 & currmon == 12;

by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 2] == 0 & currmon == 4;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 3] == 0 & currmon == 5;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 4] == 0 & currmon == 6;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 2] == 0 & currmon == 8;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 3] == 0 & currmon == 9;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 4] == 0 & currmon == 10;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 2] == 0 & currmon == 12;

by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 2] == 0 & currmon == 5;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 3] == 0 & currmon == 6;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 4] == 0 & currmon == 7;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 2] == 0 & currmon == 9;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 3] == 0 & currmon == 10;
by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2xM == 1 & furen2xM[_n - 4] == 0 & currmon == 11;

by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 2] == 0 & currmon == 2;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 3] == 0 & currmon == 1;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 2] == 0 & currmon == 6;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 3] == 0 & currmon == 5;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 4] == 0 & currmon == 4;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 2] == 0 & currmon == 10;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 3] == 0 & currmon == 9;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 4] == 0 & currmon == 8;

by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 2] == 0 & currmon == 1;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 2] == 0 & currmon == 5;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 3] == 0 & currmon == 4;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 4] == 0 & currmon == 3;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 2] == 0 & currmon == 9;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 3] == 0 & currmon == 8;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 4] == 0 & currmon == 7;

by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 2] == 0 & currmon == 4;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 3] == 0 & currmon == 3;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 4] == 0 & currmon == 2;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 2] == 0 & currmon == 8;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 3] == 0 & currmon == 7;
by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1 & furen2xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace furen2x = furen2x[_n - 1]*0.5 + furen2x[_n + 1]*0.5 if furen2xM == 1 & furen2xM[_n - 1] == 0 & furen2xM[_n + 1] == 0;
by id: replace furen2x = furen2x[_n - 1]*0.7 + furen2x[_n + 2]*0.3 if furen2xM == 1 & furen2xM[_n - 1] == 0 & furen2xM[_n + 2] == 0;
by id: replace furen2x = furen2x[_n - 2]*0.3 + furen2x[_n + 1]*0.7 if furen2xM == 1 & furen2xM[_n - 2] == 0 & furen2xM[_n + 1] == 0;

/** Establish dbrents by unicode, state, region **/

gen furen2xaggb = furen2x*beds2x;
replace furen2xaggb = . if beds2x == 0;
gen furen2xinvb = beds2x;
replace furen2xinvb = . if furen2xaggb == .;

bysort unicode yr sem: egen furen2a1 = sum(furen2xaggb);
bysort unicode yr sem: egen furen2inv1 = sum(furen2xinvb);
bysort unicode yr sem: gen fdb2urenuni = furen2a1/furen2inv1;

bysort state yr sem: egen furen2a2 = sum(furen2xaggb);
bysort state yr sem: egen furen2inv2 = sum(furen2xinvb);
bysort state yr sem: gen fdb2stateuniunit = furen2a2/furen2inv2;

bysort r1to5 yr sem: egen furen2a3 = sum(furen2xaggb);
bysort r1to5 yr sem: egen furen2inv3 = sum(furen2xinvb);
bysort r1to5 yr sem: gen fdb2reguniunit = furen2a3/furen2inv3;

sort id yr qtr currmon;

/** furen3x **/

sort id yr qtr currmon;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 2] == 0 & currmon == 3;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 3] == 0 & currmon == 4;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 4] == 0 & currmon == 5;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 2] == 0 & currmon == 7;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 3] == 0 & currmon == 8;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 4] == 0 & currmon == 9;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 2] == 0 & currmon == 11;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 3] == 0 & currmon == 12;

by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 2] == 0 & currmon == 4;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 3] == 0 & currmon == 5;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 4] == 0 & currmon == 6;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 2] == 0 & currmon == 8;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 3] == 0 & currmon == 9;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 4] == 0 & currmon == 10;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 2] == 0 & currmon == 12;

by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 2] == 0 & currmon == 5;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 3] == 0 & currmon == 6;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 4] == 0 & currmon == 7;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 2] == 0 & currmon == 9;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 3] == 0 & currmon == 10;
by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3xM == 1 & furen3xM[_n - 4] == 0 & currmon == 11;

by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 2] == 0 & currmon == 2;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 3] == 0 & currmon == 1;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 2] == 0 & currmon == 6;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 3] == 0 & currmon == 5;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 4] == 0 & currmon == 4;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 2] == 0 & currmon == 10;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 3] == 0 & currmon == 9;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 4] == 0 & currmon == 8;

by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 2] == 0 & currmon == 1;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 2] == 0 & currmon == 5;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 3] == 0 & currmon == 4;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 4] == 0 & currmon == 3;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 2] == 0 & currmon == 9;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 3] == 0 & currmon == 8;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 4] == 0 & currmon == 7;

by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 2] == 0 & currmon == 4;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 3] == 0 & currmon == 3;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 4] == 0 & currmon == 2;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 2] == 0 & currmon == 8;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 3] == 0 & currmon == 7;
by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1 & furen3xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace furen3x = furen3x[_n - 1]*0.5 + furen3x[_n + 1]*0.5 if furen3xM == 1 & furen3xM[_n - 1] == 0 & furen3xM[_n + 1] == 0;
by id: replace furen3x = furen3x[_n - 1]*0.7 + furen3x[_n + 2]*0.3 if furen3xM == 1 & furen3xM[_n - 1] == 0 & furen3xM[_n + 2] == 0;
by id: replace furen3x = furen3x[_n - 2]*0.3 + furen3x[_n + 1]*0.7 if furen3xM == 1 & furen3xM[_n - 2] == 0 & furen3xM[_n + 1] == 0;

/** Establish dbrents by unicode, state, region **/

gen furen3xaggb = furen3x*beds3x;
replace furen3xaggb = . if beds3x == 0;
gen furen3xinvb = beds3x;
replace furen3xinvb = . if furen3xaggb == .;

bysort unicode yr sem: egen furen3a1 = sum(furen3xaggb);
bysort unicode yr sem: egen furen3inv1 = sum(furen3xinvb);
bysort unicode yr sem: gen fdb3urenuni = furen3a1/furen3inv1;

bysort state yr sem: egen furen3a2 = sum(furen3xaggb);
bysort state yr sem: egen furen3inv2 = sum(furen3xinvb);
bysort state yr sem: gen fdb3stateuniunit = furen3a2/furen3inv2;

bysort r1to5 yr sem: egen furen3a3 = sum(furen3xaggb);
bysort r1to5 yr sem: egen furen3inv3 = sum(furen3xinvb);
bysort r1to5 yr sem: gen fdb3reguniunit = furen3a3/furen3inv3;

sort id yr qtr currmon;

/** furen4x **/

sort id yr qtr currmon;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10);
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 2] == 0 & currmon == 3;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 3] == 0 & currmon == 4;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 4] == 0 & currmon == 5;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 2] == 0 & currmon == 7;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 3] == 0 & currmon == 8;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 4] == 0 & currmon == 9;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 2] == 0 & currmon == 11;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 3] == 0 & currmon == 12;

by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 2] == 0 & currmon == 4;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 3] == 0 & currmon == 5;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 4] == 0 & currmon == 6;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 2] == 0 & currmon == 8;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 3] == 0 & currmon == 9;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 4] == 0 & currmon == 10;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 2] == 0 & currmon == 12;

by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 1] == 0 & (currmon == 4 | currmon == 8 | currmon == 12);
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 2] == 0 & currmon == 5;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 3] == 0 & currmon == 6;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 4] == 0 & currmon == 7;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 2] == 0 & currmon == 9;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 3] == 0 & currmon == 10;
by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4xM == 1 & furen4xM[_n - 4] == 0 & currmon == 11;

by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 1] == 0 & (currmon == 3 | currmon == 7 | currmon == 11);
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 2] == 0 & currmon == 2;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 3] == 0 & currmon == 1;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 2] == 0 & currmon == 6;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 3] == 0 & currmon == 5;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 4] == 0 & currmon == 4;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 2] == 0 & currmon == 10;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 3] == 0 & currmon == 9;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 4] == 0 & currmon == 8;

by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 1] == 0 & (currmon == 2 | currmon == 6 | currmon == 10); 
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 2] == 0 & currmon == 1;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 2] == 0 & currmon == 5;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 3] == 0 & currmon == 4;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 4] == 0 & currmon == 3;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 2] == 0 & currmon == 9;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 3] == 0 & currmon == 8;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 4] == 0 & currmon == 7;

by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 1] == 0 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 2] == 0 & currmon == 4;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 3] == 0 & currmon == 3;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 4] == 0 & currmon == 2;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 2] == 0 & currmon == 8;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 3] == 0 & currmon == 7;
by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1 & furen4xM[_n + 4] == 0 & currmon == 6;

/** C-A-T issues **/

by id: replace furen4x = furen4x[_n - 1]*0.5 + furen4x[_n + 1]*0.5 if furen4xM == 1 & furen4xM[_n - 1] == 0 & furen4xM[_n + 1] == 0;
by id: replace furen4x = furen4x[_n - 1]*0.7 + furen4x[_n + 2]*0.3 if furen4xM == 1 & furen4xM[_n - 1] == 0 & furen4xM[_n + 2] == 0;
by id: replace furen4x = furen4x[_n - 2]*0.3 + furen4x[_n + 1]*0.7 if furen4xM == 1 & furen4xM[_n - 2] == 0 & furen4xM[_n + 1] == 0;

/** Establish dbrents by unicode, state, region **/

gen furen4xaggb = furen4x*beds4x;
replace furen4xaggb = . if beds4x == 0;
gen furen4xinvb = beds4x;
replace furen4xinvb = . if furen4xaggb == .;

bysort unicode yr sem: egen furen4a1 = sum(furen4xaggb);
bysort unicode yr sem: egen furen4inv1 = sum(furen4xinvb);
bysort unicode yr sem: gen fdb4urenuni = furen4a1/furen4inv1;

bysort state yr sem: egen furen4a2 = sum(furen4xaggb);
bysort state yr sem: egen furen4inv2 = sum(furen4xinvb);
bysort state yr sem: gen fdb4stateuniunit = furen4a2/furen4inv2;

bysort r1to5 yr sem: egen furen4a3 = sum(furen4xaggb);
bysort r1to5 yr sem: egen furen4inv3 = sum(furen4xinvb);
bysort r1to5 yr sem: gen fdb4reguniunit = furen4a3/furen4inv3;

sort id yr qtr currmon;

/** Rationalize DB rents **/

gen fdb0uren = fdb0urenuni;
gen fdb1uren = fdb1urenuni;
gen fdb2uren = fdb2urenuni;
gen fdb3uren = fdb3urenuni;
gen fdb4uren = fdb4urenuni;

replace fdb0uren = fdb0stateuniunit if fdb0uren == .;
replace fdb1uren = fdb1stateuniunit if fdb1uren == .;
replace fdb2uren = fdb2stateuniunit if fdb2uren == .;
replace fdb3uren = fdb3stateuniunit if fdb3uren == .;
replace fdb4uren = fdb4stateuniunit if fdb4uren == .;

replace fdb0uren = fdb0reguniunit if fdb0uren == .;
replace fdb1uren = fdb1reguniunit if fdb1uren == .;
replace fdb2uren = fdb2reguniunit if fdb2uren == .;
replace fdb3uren = fdb3reguniunit if fdb3uren == .;
replace fdb4uren = fdb4reguniunit if fdb4uren == .;

by id: replace fdb2uren = 0.95*fdb1uren if fdb2uren > fdb1uren;
by id: replace fdb3uren = 0.95*fdb2uren if fdb3uren > fdb2uren;
by id: replace fdb4uren = 0.95*fdb3uren if fdb4uren > fdb3uren;

/** Fill in values given dbren assignments **/

sort id yr sem;

by id: egen furen0xct = count(furen0x);
by id: egen furen1xct = count(furen1x);
by id: egen furen2xct = count(furen2x);
by id: egen furen3xct = count(furen3x);
by id: egen furen4xct = count(furen4x);

sort id yr qtr currmon;

by id: replace furen0x = fdb0uren*unif95 if furen0xct == 0 & furen0xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace furen1x = fdb1uren*unif95 if furen1xct == 0 & furen1xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace furen2x = fdb2uren*unif95 if furen2xct == 0 & furen2xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace furen3x = fdb3uren*unif95 if furen3xct == 0 & furen3xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);
by id: replace furen4x = fdb4uren*unif95 if furen4xct == 0 & furen4xM == 1 & (currmon == 1 | currmon == 5 | currmon == 9);        
   
/** Move that shiznits forward! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1;

     local d = `d' + 1;

   };  
   
/** And backwards! **/


  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0x == . & furen0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1x == . & furen1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2x == . & furen2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3x == . & furen3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4x == . & furen4xM == 1;

     local d = `d' + 1;

   };           

/** Moderate intersemestral changes **/

by id: replace furen0x = furen0x[_n - 1]*0.5 + furen0x[_n + 1]*0.5 if furen0xM == 1 & (currmon == 5 | currmon == 9);
by id: replace furen0x = furen0x[_n - 1]*0.5 + furen0x[_n + 1]*0.5 if furen0xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace furen1x = furen1x[_n - 1]*0.5 + furen1x[_n + 1]*0.5 if furen1xM == 1 & (currmon == 5 | currmon == 9);
by id: replace furen1x = furen1x[_n - 1]*0.5 + furen1x[_n + 1]*0.5 if furen1xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace furen2x = furen2x[_n - 1]*0.5 + furen2x[_n + 1]*0.5 if furen2xM == 1 & (currmon == 5 | currmon == 9);
by id: replace furen2x = furen2x[_n - 1]*0.5 + furen2x[_n + 1]*0.5 if furen2xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace furen3x = furen3x[_n - 1]*0.5 + furen3x[_n + 1]*0.5 if furen3xM == 1 & (currmon == 5 | currmon == 9);
by id: replace furen3x = furen3x[_n - 1]*0.5 + furen3x[_n + 1]*0.5 if furen3xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

by id: replace furen4x = furen4x[_n - 1]*0.5 + furen4x[_n + 1]*0.5 if furen4xM == 1 & (currmon == 5 | currmon == 9);
by id: replace furen4x = furen4x[_n - 1]*0.5 + furen4x[_n + 1]*0.5 if furen4xM == 1 & currmon == 1 & yr == $curryr & yr[_n - 1] == ($curryr - 1);

      
       
/** Moderate stretches of "no survey" **/

by id: replace furen0x = furen0x[_n - 1]*0.8 + furen0x[_n + 3]*0.2 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n + 1] == 1 & furen0xM[_n + 2] == 1 
       & furen0xM[_n + 3] == 1 & currmon == 2;
by id: replace furen0x = furen0x[_n - 2]*0.5 + furen0x[_n + 2]*0.5 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n + 1] == 1 
       & furen0xM[_n + 2] == 1 & currmon == 3;   
by id: replace furen0x = furen0x[_n - 3]*0.2 + furen0x[_n + 3]*0.8 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n - 3] == 1 
       & furen0xM[_n + 1] == 1 & currmon == 4;  
by id: replace furen0x = furen0x[_n - 1]*0.8 + furen0x[_n + 3]*0.2 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n + 1] == 1 & furen0xM[_n + 2] == 1 
       & furen0xM[_n + 3] == 1 & currmon == 4;
by id: replace furen0x = furen0x[_n - 2]*0.5 + furen0x[_n + 2]*0.5 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n + 1] == 1 
       & furen0xM[_n + 2] == 1 & currmon == 5;   
by id: replace furen0x = furen0x[_n - 3]*0.2 + furen0x[_n + 3]*0.8 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n - 3] == 1 
       & furen0xM[_n + 1] == 1 & currmon == 6;       
by id: replace furen0x = furen0x[_n - 1]*0.8 + furen0x[_n + 3]*0.2 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n + 1] == 1 & furen0xM[_n + 2] == 1 
       & furen0xM[_n + 3] == 1 & currmon == 5;
by id: replace furen0x = furen0x[_n - 2]*0.5 + furen0x[_n + 2]*0.5 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n + 1] == 1 
       & furen0xM[_n + 2] == 1 & currmon == 6;   
by id: replace furen0x = furen0x[_n - 3]*0.2 + furen0x[_n + 3]*0.8 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n - 3] == 1 
       & furen0xM[_n + 1] == 1 & currmon == 7;
by id: replace furen0x = furen0x[_n - 1]*0.8 + furen0x[_n + 3]*0.2 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n + 1] == 1 & furen0xM[_n + 2] == 1 
       & furen0xM[_n + 3] == 1 & currmon == 6;
by id: replace furen0x = furen0x[_n - 2]*0.5 + furen0x[_n + 2]*0.5 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n + 1] == 1 
       & furen0xM[_n + 2] == 1 & currmon == 7;   
by id: replace furen0x = furen0x[_n - 3]*0.2 + furen0x[_n + 3]*0.8 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n - 3] == 1 
       & furen0xM[_n + 1] == 1 & currmon == 8;       
by id: replace furen0x = furen0x[_n - 1]*0.8 + furen0x[_n + 3]*0.2 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n + 1] == 1 & furen0xM[_n + 2] == 1 
       & furen0xM[_n + 3] == 1 & currmon == 7;
by id: replace furen0x = furen0x[_n - 2]*0.5 + furen0x[_n + 2]*0.5 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n + 1] == 1 
       & furen0xM[_n + 2] == 1 & currmon == 8;   
by id: replace furen0x = furen0x[_n - 3]*0.2 + furen0x[_n + 3]*0.8 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n - 3] == 1 
       & furen0xM[_n + 1] == 1 & currmon == 9;
by id: replace furen0x = furen0x[_n - 1]*0.8 + furen0x[_n + 3]*0.2 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n + 1] == 1 & furen0xM[_n + 2] == 1 
       & furen0xM[_n + 3] == 1 & currmon == 8;
by id: replace furen0x = furen0x[_n - 2]*0.5 + furen0x[_n + 2]*0.5 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n + 1] == 1 
       & furen0xM[_n + 2] == 1 & currmon == 9;   
by id: replace furen0x = furen0x[_n - 3]*0.2 + furen0x[_n + 3]*0.8 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n - 3] == 1 
       & furen0xM[_n + 1] == 1 & currmon == 10;
by id: replace furen0x = furen0x[_n - 1]*0.8 + furen0x[_n + 3]*0.2 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n + 1] == 1 & furen0xM[_n + 2] == 1 
       & furen0xM[_n + 3] == 1 & currmon == 9;
by id: replace furen0x = furen0x[_n - 2]*0.5 + furen0x[_n + 2]*0.5 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n + 1] == 1 
       & furen0xM[_n + 2] == 1 & currmon == 10;   
by id: replace furen0x = furen0x[_n - 3]*0.2 + furen0x[_n + 3]*0.8 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n - 3] == 1 
       & furen0xM[_n + 1] == 1 & currmon == 11;       
by id: replace furen0x = furen0x[_n - 1]*0.8 + furen0x[_n + 3]*0.2 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n + 1] == 1 & furen0xM[_n + 2] == 1 
       & furen0xM[_n + 3] == 1 & currmon == 10;
by id: replace furen0x = furen0x[_n - 2]*0.5 + furen0x[_n + 2]*0.5 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n + 1] == 1 
       & furen0xM[_n + 2] == 1 & currmon == 11;   
by id: replace furen0x = furen0x[_n - 3]*0.2 + furen0x[_n + 3]*0.8 if furen0xM == 1 & furen0xM[_n - 1] == 1 & furen0xM[_n - 2] == 1 & furen0xM[_n - 3] == 1 
       & furen0xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace furen1x = furen1x[_n - 1]*0.8 + furen1x[_n + 3]*0.2 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n + 1] == 1 & furen1xM[_n + 2] == 1 
       & furen1xM[_n + 3] == 1 & currmon == 2;
by id: replace furen1x = furen1x[_n - 2]*0.5 + furen1x[_n + 2]*0.5 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n + 1] == 1 
       & furen1xM[_n + 2] == 1 & currmon == 3;   
by id: replace furen1x = furen1x[_n - 3]*0.2 + furen1x[_n + 3]*0.8 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n - 3] == 1 
       & furen1xM[_n + 1] == 1 & currmon == 4;  
by id: replace furen1x = furen1x[_n - 1]*0.8 + furen1x[_n + 3]*0.2 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n + 1] == 1 & furen1xM[_n + 2] == 1 
       & furen1xM[_n + 3] == 1 & currmon == 4;
by id: replace furen1x = furen1x[_n - 2]*0.5 + furen1x[_n + 2]*0.5 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n + 1] == 1 
       & furen1xM[_n + 2] == 1 & currmon == 5;   
by id: replace furen1x = furen1x[_n - 3]*0.2 + furen1x[_n + 3]*0.8 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n - 3] == 1 
       & furen1xM[_n + 1] == 1 & currmon == 6;       
by id: replace furen1x = furen1x[_n - 1]*0.8 + furen1x[_n + 3]*0.2 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n + 1] == 1 & furen1xM[_n + 2] == 1 
       & furen1xM[_n + 3] == 1 & currmon == 5;
by id: replace furen1x = furen1x[_n - 2]*0.5 + furen1x[_n + 2]*0.5 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n + 1] == 1 
       & furen1xM[_n + 2] == 1 & currmon == 6;   
by id: replace furen1x = furen1x[_n - 3]*0.2 + furen1x[_n + 3]*0.8 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n - 3] == 1 
       & furen1xM[_n + 1] == 1 & currmon == 7;
by id: replace furen1x = furen1x[_n - 1]*0.8 + furen1x[_n + 3]*0.2 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n + 1] == 1 & furen1xM[_n + 2] == 1 
       & furen1xM[_n + 3] == 1 & currmon == 6;
by id: replace furen1x = furen1x[_n - 2]*0.5 + furen1x[_n + 2]*0.5 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n + 1] == 1 
       & furen1xM[_n + 2] == 1 & currmon == 7;   
by id: replace furen1x = furen1x[_n - 3]*0.2 + furen1x[_n + 3]*0.8 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n - 3] == 1 
       & furen1xM[_n + 1] == 1 & currmon == 8;       
by id: replace furen1x = furen1x[_n - 1]*0.8 + furen1x[_n + 3]*0.2 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n + 1] == 1 & furen1xM[_n + 2] == 1 
       & furen1xM[_n + 3] == 1 & currmon == 7;
by id: replace furen1x = furen1x[_n - 2]*0.5 + furen1x[_n + 2]*0.5 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n + 1] == 1 
       & furen1xM[_n + 2] == 1 & currmon == 8;   
by id: replace furen1x = furen1x[_n - 3]*0.2 + furen1x[_n + 3]*0.8 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n - 3] == 1 
       & furen1xM[_n + 1] == 1 & currmon == 9;
by id: replace furen1x = furen1x[_n - 1]*0.8 + furen1x[_n + 3]*0.2 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n + 1] == 1 & furen1xM[_n + 2] == 1 
       & furen1xM[_n + 3] == 1 & currmon == 8;
by id: replace furen1x = furen1x[_n - 2]*0.5 + furen1x[_n + 2]*0.5 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n + 1] == 1 
       & furen1xM[_n + 2] == 1 & currmon == 9;   
by id: replace furen1x = furen1x[_n - 3]*0.2 + furen1x[_n + 3]*0.8 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n - 3] == 1 
       & furen1xM[_n + 1] == 1 & currmon == 10;
by id: replace furen1x = furen1x[_n - 1]*0.8 + furen1x[_n + 3]*0.2 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n + 1] == 1 & furen1xM[_n + 2] == 1 
       & furen1xM[_n + 3] == 1 & currmon == 9;
by id: replace furen1x = furen1x[_n - 2]*0.5 + furen1x[_n + 2]*0.5 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n + 1] == 1 
       & furen1xM[_n + 2] == 1 & currmon == 10;   
by id: replace furen1x = furen1x[_n - 3]*0.2 + furen1x[_n + 3]*0.8 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n - 3] == 1 
       & furen1xM[_n + 1] == 1 & currmon == 11;       
by id: replace furen1x = furen1x[_n - 1]*0.8 + furen1x[_n + 3]*0.2 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n + 1] == 1 & furen1xM[_n + 2] == 1 
       & furen1xM[_n + 3] == 1 & currmon == 10;
by id: replace furen1x = furen1x[_n - 2]*0.5 + furen1x[_n + 2]*0.5 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n + 1] == 1 
       & furen1xM[_n + 2] == 1 & currmon == 11;   
by id: replace furen1x = furen1x[_n - 3]*0.2 + furen1x[_n + 3]*0.8 if furen1xM == 1 & furen1xM[_n - 1] == 1 & furen1xM[_n - 2] == 1 & furen1xM[_n - 3] == 1 
       & furen1xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace furen2x = furen2x[_n - 1]*0.8 + furen2x[_n + 3]*0.2 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n + 1] == 1 & furen2xM[_n + 2] == 1 
       & furen2xM[_n + 3] == 1 & currmon == 2;
by id: replace furen2x = furen2x[_n - 2]*0.5 + furen2x[_n + 2]*0.5 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n + 1] == 1 
       & furen2xM[_n + 2] == 1 & currmon == 3;   
by id: replace furen2x = furen2x[_n - 3]*0.2 + furen2x[_n + 3]*0.8 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n - 3] == 1 
       & furen2xM[_n + 1] == 1 & currmon == 4;  
by id: replace furen2x = furen2x[_n - 1]*0.8 + furen2x[_n + 3]*0.2 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n + 1] == 1 & furen2xM[_n + 2] == 1 
       & furen2xM[_n + 3] == 1 & currmon == 4;
by id: replace furen2x = furen2x[_n - 2]*0.5 + furen2x[_n + 2]*0.5 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n + 1] == 1 
       & furen2xM[_n + 2] == 1 & currmon == 5;   
by id: replace furen2x = furen2x[_n - 3]*0.2 + furen2x[_n + 3]*0.8 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n - 3] == 1 
       & furen2xM[_n + 1] == 1 & currmon == 6;       
by id: replace furen2x = furen2x[_n - 1]*0.8 + furen2x[_n + 3]*0.2 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n + 1] == 1 & furen2xM[_n + 2] == 1 
       & furen2xM[_n + 3] == 1 & currmon == 5;
by id: replace furen2x = furen2x[_n - 2]*0.5 + furen2x[_n + 2]*0.5 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n + 1] == 1 
       & furen2xM[_n + 2] == 1 & currmon == 6;   
by id: replace furen2x = furen2x[_n - 3]*0.2 + furen2x[_n + 3]*0.8 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n - 3] == 1 
       & furen2xM[_n + 1] == 1 & currmon == 7;
by id: replace furen2x = furen2x[_n - 1]*0.8 + furen2x[_n + 3]*0.2 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n + 1] == 1 & furen2xM[_n + 2] == 1 
       & furen2xM[_n + 3] == 1 & currmon == 6;
by id: replace furen2x = furen2x[_n - 2]*0.5 + furen2x[_n + 2]*0.5 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n + 1] == 1 
       & furen2xM[_n + 2] == 1 & currmon == 7;   
by id: replace furen2x = furen2x[_n - 3]*0.2 + furen2x[_n + 3]*0.8 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n - 3] == 1 
       & furen2xM[_n + 1] == 1 & currmon == 8;       
by id: replace furen2x = furen2x[_n - 1]*0.8 + furen2x[_n + 3]*0.2 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n + 1] == 1 & furen2xM[_n + 2] == 1 
       & furen2xM[_n + 3] == 1 & currmon == 7;
by id: replace furen2x = furen2x[_n - 2]*0.5 + furen2x[_n + 2]*0.5 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n + 1] == 1 
       & furen2xM[_n + 2] == 1 & currmon == 8;   
by id: replace furen2x = furen2x[_n - 3]*0.2 + furen2x[_n + 3]*0.8 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n - 3] == 1 
       & furen2xM[_n + 1] == 1 & currmon == 9;
by id: replace furen2x = furen2x[_n - 1]*0.8 + furen2x[_n + 3]*0.2 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n + 1] == 1 & furen2xM[_n + 2] == 1 
       & furen2xM[_n + 3] == 1 & currmon == 8;
by id: replace furen2x = furen2x[_n - 2]*0.5 + furen2x[_n + 2]*0.5 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n + 1] == 1 
       & furen2xM[_n + 2] == 1 & currmon == 9;   
by id: replace furen2x = furen2x[_n - 3]*0.2 + furen2x[_n + 3]*0.8 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n - 3] == 1 
       & furen2xM[_n + 1] == 1 & currmon == 10;
by id: replace furen2x = furen2x[_n - 1]*0.8 + furen2x[_n + 3]*0.2 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n + 1] == 1 & furen2xM[_n + 2] == 1 
       & furen2xM[_n + 3] == 1 & currmon == 9;
by id: replace furen2x = furen2x[_n - 2]*0.5 + furen2x[_n + 2]*0.5 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n + 1] == 1 
       & furen2xM[_n + 2] == 1 & currmon == 10;   
by id: replace furen2x = furen2x[_n - 3]*0.2 + furen2x[_n + 3]*0.8 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n - 3] == 1 
       & furen2xM[_n + 1] == 1 & currmon == 11;       
by id: replace furen2x = furen2x[_n - 1]*0.8 + furen2x[_n + 3]*0.2 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n + 1] == 1 & furen2xM[_n + 2] == 1 
       & furen2xM[_n + 3] == 1 & currmon == 10;
by id: replace furen2x = furen2x[_n - 2]*0.5 + furen2x[_n + 2]*0.5 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n + 1] == 1 
       & furen2xM[_n + 2] == 1 & currmon == 11;   
by id: replace furen2x = furen2x[_n - 3]*0.2 + furen2x[_n + 3]*0.8 if furen2xM == 1 & furen2xM[_n - 1] == 1 & furen2xM[_n - 2] == 1 & furen2xM[_n - 3] == 1 
       & furen2xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace furen3x = furen3x[_n - 1]*0.8 + furen3x[_n + 3]*0.2 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n + 1] == 1 & furen3xM[_n + 2] == 1 
       & furen3xM[_n + 3] == 1 & currmon == 2;
by id: replace furen3x = furen3x[_n - 2]*0.5 + furen3x[_n + 2]*0.5 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n + 1] == 1 
       & furen3xM[_n + 2] == 1 & currmon == 3;   
by id: replace furen3x = furen3x[_n - 3]*0.2 + furen3x[_n + 3]*0.8 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n - 3] == 1 
       & furen3xM[_n + 1] == 1 & currmon == 4;  
by id: replace furen3x = furen3x[_n - 1]*0.8 + furen3x[_n + 3]*0.2 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n + 1] == 1 & furen3xM[_n + 2] == 1 
       & furen3xM[_n + 3] == 1 & currmon == 4;
by id: replace furen3x = furen3x[_n - 2]*0.5 + furen3x[_n + 2]*0.5 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n + 1] == 1 
       & furen3xM[_n + 2] == 1 & currmon == 5;   
by id: replace furen3x = furen3x[_n - 3]*0.2 + furen3x[_n + 3]*0.8 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n - 3] == 1 
       & furen3xM[_n + 1] == 1 & currmon == 6;       
by id: replace furen3x = furen3x[_n - 1]*0.8 + furen3x[_n + 3]*0.2 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n + 1] == 1 & furen3xM[_n + 2] == 1 
       & furen3xM[_n + 3] == 1 & currmon == 5;
by id: replace furen3x = furen3x[_n - 2]*0.5 + furen3x[_n + 2]*0.5 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n + 1] == 1 
       & furen3xM[_n + 2] == 1 & currmon == 6;   
by id: replace furen3x = furen3x[_n - 3]*0.2 + furen3x[_n + 3]*0.8 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n - 3] == 1 
       & furen3xM[_n + 1] == 1 & currmon == 7;
by id: replace furen3x = furen3x[_n - 1]*0.8 + furen3x[_n + 3]*0.2 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n + 1] == 1 & furen3xM[_n + 2] == 1 
       & furen3xM[_n + 3] == 1 & currmon == 6;
by id: replace furen3x = furen3x[_n - 2]*0.5 + furen3x[_n + 2]*0.5 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n + 1] == 1 
       & furen3xM[_n + 2] == 1 & currmon == 7;   
by id: replace furen3x = furen3x[_n - 3]*0.2 + furen3x[_n + 3]*0.8 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n - 3] == 1 
       & furen3xM[_n + 1] == 1 & currmon == 8;       
by id: replace furen3x = furen3x[_n - 1]*0.8 + furen3x[_n + 3]*0.2 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n + 1] == 1 & furen3xM[_n + 2] == 1 
       & furen3xM[_n + 3] == 1 & currmon == 7;
by id: replace furen3x = furen3x[_n - 2]*0.5 + furen3x[_n + 2]*0.5 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n + 1] == 1 
       & furen3xM[_n + 2] == 1 & currmon == 8;   
by id: replace furen3x = furen3x[_n - 3]*0.2 + furen3x[_n + 3]*0.8 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n - 3] == 1 
       & furen3xM[_n + 1] == 1 & currmon == 9;
by id: replace furen3x = furen3x[_n - 1]*0.8 + furen3x[_n + 3]*0.2 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n + 1] == 1 & furen3xM[_n + 2] == 1 
       & furen3xM[_n + 3] == 1 & currmon == 8;
by id: replace furen3x = furen3x[_n - 2]*0.5 + furen3x[_n + 2]*0.5 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n + 1] == 1 
       & furen3xM[_n + 2] == 1 & currmon == 9;   
by id: replace furen3x = furen3x[_n - 3]*0.2 + furen3x[_n + 3]*0.8 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n - 3] == 1 
       & furen3xM[_n + 1] == 1 & currmon == 10;
by id: replace furen3x = furen3x[_n - 1]*0.8 + furen3x[_n + 3]*0.2 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n + 1] == 1 & furen3xM[_n + 2] == 1 
       & furen3xM[_n + 3] == 1 & currmon == 9;
by id: replace furen3x = furen3x[_n - 2]*0.5 + furen3x[_n + 2]*0.5 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n + 1] == 1 
       & furen3xM[_n + 2] == 1 & currmon == 10;   
by id: replace furen3x = furen3x[_n - 3]*0.2 + furen3x[_n + 3]*0.8 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n - 3] == 1 
       & furen3xM[_n + 1] == 1 & currmon == 11;       
by id: replace furen3x = furen3x[_n - 1]*0.8 + furen3x[_n + 3]*0.2 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n + 1] == 1 & furen3xM[_n + 2] == 1 
       & furen3xM[_n + 3] == 1 & currmon == 10;
by id: replace furen3x = furen3x[_n - 2]*0.5 + furen3x[_n + 2]*0.5 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n + 1] == 1 
       & furen3xM[_n + 2] == 1 & currmon == 11;   
by id: replace furen3x = furen3x[_n - 3]*0.2 + furen3x[_n + 3]*0.8 if furen3xM == 1 & furen3xM[_n - 1] == 1 & furen3xM[_n - 2] == 1 & furen3xM[_n - 3] == 1 
       & furen3xM[_n + 1] == 1 & currmon == 12; 
	   
by id: replace furen4x = furen4x[_n - 1]*0.8 + furen4x[_n + 3]*0.2 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n + 1] == 1 & furen4xM[_n + 2] == 1 
       & furen4xM[_n + 3] == 1 & currmon == 2;
by id: replace furen4x = furen4x[_n - 2]*0.5 + furen4x[_n + 2]*0.5 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n + 1] == 1 
       & furen4xM[_n + 2] == 1 & currmon == 3;   
by id: replace furen4x = furen4x[_n - 3]*0.2 + furen4x[_n + 3]*0.8 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n - 3] == 1 
       & furen4xM[_n + 1] == 1 & currmon == 4;  
by id: replace furen4x = furen4x[_n - 1]*0.8 + furen4x[_n + 3]*0.2 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n + 1] == 1 & furen4xM[_n + 2] == 1 
       & furen4xM[_n + 3] == 1 & currmon == 4;
by id: replace furen4x = furen4x[_n - 2]*0.5 + furen4x[_n + 2]*0.5 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n + 1] == 1 
       & furen4xM[_n + 2] == 1 & currmon == 5;   
by id: replace furen4x = furen4x[_n - 3]*0.2 + furen4x[_n + 3]*0.8 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n - 3] == 1 
       & furen4xM[_n + 1] == 1 & currmon == 6;       
by id: replace furen4x = furen4x[_n - 1]*0.8 + furen4x[_n + 3]*0.2 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n + 1] == 1 & furen4xM[_n + 2] == 1 
       & furen4xM[_n + 3] == 1 & currmon == 5;
by id: replace furen4x = furen4x[_n - 2]*0.5 + furen4x[_n + 2]*0.5 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n + 1] == 1 
       & furen4xM[_n + 2] == 1 & currmon == 6;   
by id: replace furen4x = furen4x[_n - 3]*0.2 + furen4x[_n + 3]*0.8 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n - 3] == 1 
       & furen4xM[_n + 1] == 1 & currmon == 7;
by id: replace furen4x = furen4x[_n - 1]*0.8 + furen4x[_n + 3]*0.2 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n + 1] == 1 & furen4xM[_n + 2] == 1 
       & furen4xM[_n + 3] == 1 & currmon == 6;
by id: replace furen4x = furen4x[_n - 2]*0.5 + furen4x[_n + 2]*0.5 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n + 1] == 1 
       & furen4xM[_n + 2] == 1 & currmon == 7;   
by id: replace furen4x = furen4x[_n - 3]*0.2 + furen4x[_n + 3]*0.8 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n - 3] == 1 
       & furen4xM[_n + 1] == 1 & currmon == 8;       
by id: replace furen4x = furen4x[_n - 1]*0.8 + furen4x[_n + 3]*0.2 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n + 1] == 1 & furen4xM[_n + 2] == 1 
       & furen4xM[_n + 3] == 1 & currmon == 7;
by id: replace furen4x = furen4x[_n - 2]*0.5 + furen4x[_n + 2]*0.5 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n + 1] == 1 
       & furen4xM[_n + 2] == 1 & currmon == 8;   
by id: replace furen4x = furen4x[_n - 3]*0.2 + furen4x[_n + 3]*0.8 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n - 3] == 1 
       & furen4xM[_n + 1] == 1 & currmon == 9;
by id: replace furen4x = furen4x[_n - 1]*0.8 + furen4x[_n + 3]*0.2 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n + 1] == 1 & furen4xM[_n + 2] == 1 
       & furen4xM[_n + 3] == 1 & currmon == 8;
by id: replace furen4x = furen4x[_n - 2]*0.5 + furen4x[_n + 2]*0.5 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n + 1] == 1 
       & furen4xM[_n + 2] == 1 & currmon == 9;   
by id: replace furen4x = furen4x[_n - 3]*0.2 + furen4x[_n + 3]*0.8 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n - 3] == 1 
       & furen4xM[_n + 1] == 1 & currmon == 10;
by id: replace furen4x = furen4x[_n - 1]*0.8 + furen4x[_n + 3]*0.2 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n + 1] == 1 & furen4xM[_n + 2] == 1 
       & furen4xM[_n + 3] == 1 & currmon == 9;
by id: replace furen4x = furen4x[_n - 2]*0.5 + furen4x[_n + 2]*0.5 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n + 1] == 1 
       & furen4xM[_n + 2] == 1 & currmon == 10;   
by id: replace furen4x = furen4x[_n - 3]*0.2 + furen4x[_n + 3]*0.8 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n - 3] == 1 
       & furen4xM[_n + 1] == 1 & currmon == 11;       
by id: replace furen4x = furen4x[_n - 1]*0.8 + furen4x[_n + 3]*0.2 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n + 1] == 1 & furen4xM[_n + 2] == 1 
       & furen4xM[_n + 3] == 1 & currmon == 10;
by id: replace furen4x = furen4x[_n - 2]*0.5 + furen4x[_n + 2]*0.5 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n + 1] == 1 
       & furen4xM[_n + 2] == 1 & currmon == 11;   
by id: replace furen4x = furen4x[_n - 3]*0.2 + furen4x[_n + 3]*0.8 if furen4xM == 1 & furen4xM[_n - 1] == 1 & furen4xM[_n - 2] == 1 & furen4xM[_n - 3] == 1 
       & furen4xM[_n + 1] == 1 & currmon == 12; 	   

/** Move that shiznits forward! **/

  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen0x = furen0x[_n + 1]/(1 + mcpid) if furen0x == . & furen0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen1x = furen1x[_n + 1]/(1 + mcpid) if furen1x == . & furen1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen2x = furen2x[_n + 1]/(1 + mcpid) if furen2x == . & furen2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen3x = furen3x[_n + 1]/(1 + mcpid) if furen3x == . & furen3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen4x = furen4x[_n + 1]/(1 + mcpid) if furen4x == . & furen4xM == 1;

     local d = `d' + 1;

   };  
   
/** And backwards! **/


  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen0x = furen0x[_n - 1]*(1 + mcpid) if furen0x == . & furen0xM == 1;

     local d = `d' + 1;

   };  
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen1x = furen1x[_n - 1]*(1 + mcpid) if furen1x == . & furen1xM == 1;

     local d = `d' + 1;

   };    
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen2x = furen2x[_n - 1]*(1 + mcpid) if furen2x == . & furen2xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen3x = furen3x[_n - 1]*(1 + mcpid) if furen3x == . & furen3xM == 1;

     local d = `d' + 1;

   };     
   
  local d = 1;
  local D = (($curryr - $begyr + 1)*24);
     while `d' <= `D' {;

     by id: replace furen4x = furen4x[_n - 1]*(1 + mcpid) if furen4x == . & furen4xM == 1;

     local d = `d' + 1;

   };
	   
/** Finally, the "FUTURE" represents only ONE number, so just take the latest figure **/

by id: egen furen0xl = lastnm(furen0x);
by id: egen furen1xl = lastnm(furen1x);
by id: egen furen2xl = lastnm(furen2x);
by id: egen furen3xl = lastnm(furen3x);
by id: egen furen4xl = lastnm(furen4x);

/** Format for internal consistency **/

/** P6736 case - tie future rent estimates to CURRENT rent estimates if xM_avg = 1! **/

by id: egen fbren0xMa = mean(fbren0xM);
by id: egen fbren1xMa = mean(fbren1xM);
by id: egen fbren2xMa = mean(fbren2xM);
by id: egen fbren3xMa = mean(fbren3xM);
by id: egen fbren4xMa = mean(fbren4xM);

by id: egen furen0xMa = mean(furen0xM);
by id: egen furen1xMa = mean(furen1xM);
by id: egen furen2xMa = mean(furen2xM);
by id: egen furen3xMa = mean(furen3xM);
by id: egen furen4xMa = mean(furen4xM);

replace fbren0x = bren0x*(1 - 0.02*unif95) if fbren0xMa == 1 & fbren0x < 0.97*bren0x;
replace fbren1x = bren1x*(1 - 0.02*unif95) if fbren1xMa == 1 & fbren1x < 0.97*bren1x;
replace fbren2x = bren2x*(1 - 0.02*unif95) if fbren2xMa == 1 & fbren2x < 0.97*bren2x;
replace fbren3x = bren3x*(1 - 0.02*unif95) if fbren3xMa == 1 & fbren3x < 0.97*bren3x;
replace fbren4x = bren4x*(1 - 0.02*unif95) if fbren4xMa == 1 & fbren4x < 0.97*bren4x;

replace fbren0x = bren0x*(1 + 0.02*unif95) if fbren0xMa == 1 & fbren0x > 1.03*bren0x;
replace fbren1x = bren1x*(1 + 0.02*unif95) if fbren1xMa == 1 & fbren1x > 1.03*bren1x;
replace fbren2x = bren2x*(1 + 0.02*unif95) if fbren2xMa == 1 & fbren2x > 1.03*bren2x;
replace fbren3x = bren3x*(1 + 0.02*unif95) if fbren3xMa == 1 & fbren3x > 1.03*bren3x;
replace fbren4x = bren4x*(1 + 0.02*unif95) if fbren4xMa == 1 & fbren4x > 1.03*bren4x;

/** Bed to Unit conversion - Case P5842 **/

by id: replace furen0x = fbren0x if furen0xMa == 1;
by id: replace furen1x = fbren1x if furen1xMa == 1;
by id: replace furen2x = fbren2x*2 if furen2xMa == 1;
by id: replace furen3x = fbren3x*3 if furen3xMa == 1;
by id: replace furen4x = fbren4x*4 if furen4xMa == 1;

replace furen0x = uren0x*(1 - 0.02*unif95) if furen0xMa == 1 & furen0x < 0.97*uren0x;
replace furen1x = uren1x*(1 - 0.02*unif95) if furen1xMa == 1 & furen1x < 0.97*uren1x;
replace furen2x = uren2x*(1 - 0.02*unif95) if furen2xMa == 1 & furen2x < 0.97*uren2x;
replace furen3x = uren3x*(1 - 0.02*unif95) if furen3xMa == 1 & furen3x < 0.97*uren3x;
replace furen4x = uren4x*(1 - 0.02*unif95) if furen4xMa == 1 & furen4x < 0.97*uren4x;

replace furen0x = uren0x*(1 + 0.02*unif95) if furen0xMa == 1 & furen0x > 1.03*uren0x;
replace furen1x = uren1x*(1 + 0.02*unif95) if furen1xMa == 1 & furen1x > 1.03*uren1x;
replace furen2x = uren2x*(1 + 0.02*unif95) if furen2xMa == 1 & furen2x > 1.03*uren2x;
replace furen3x = uren3x*(1 + 0.02*unif95) if furen3xMa == 1 & furen3x > 1.03*uren3x;
replace furen4x = uren4x*(1 + 0.02*unif95) if furen4xMa == 1 & furen4x > 1.03*uren4x;

/** But what about the REVERSE?  Case P10820, analyzed on 07/30/2015 - what if it's FUTURE rent levels that are tied to surveyed levels,  
    and CURRENT rent levels that are estimated?  Will require adjustments up top too **/
	
replace bren0x = fbren0x*(1 - 0.02*unif95) if fbren0xMa ~= 1 & bren0xMa == 1;
replace bren1x = fbren1x*(1 - 0.02*unif95) if fbren1xMa ~= 1 & bren1xMa == 1;
replace bren2x = fbren2x*(1 - 0.02*unif95) if fbren2xMa ~= 1 & bren2xMa == 1;
replace bren3x = fbren3x*(1 - 0.02*unif95) if fbren3xMa ~= 1 & bren3xMa == 1;
replace bren4x = fbren4x*(1 - 0.02*unif95) if fbren4xMa ~= 1 & bren4xMa == 1;

replace uren0x = furen0x*(1 - 0.02*unif95) if furen0xMa ~= 1 & uren0xMa == 1;
replace uren1x = furen1x*(1 - 0.02*unif95) if furen1xMa ~= 1 & uren1xMa == 1;
replace uren2x = furen2x*(1 - 0.02*unif95) if furen2xMa ~= 1 & uren2xMa == 1;
replace uren3x = furen3x*(1 - 0.02*unif95) if furen3xMa ~= 1 & uren3xMa == 1;
replace uren4x = furen4x*(1 - 0.02*unif95) if furen4xMa ~= 1 & uren4xMa == 1;

/** Formatting **/

replace bren0x = round(bren0x, 0.1) if bren0xM == 1;
replace bren1x = round(bren1x, 0.1) if bren1xM == 1;
replace bren2x = round(bren2x, 0.1) if bren2xM == 1;
replace bren3x = round(bren3x, 0.1) if bren3xM == 1;
replace bren4x = round(bren4x, 0.1) if bren4xM == 1;

replace uren0x = round(uren0x, 0.1) if uren0xM == 1;
replace uren1x = round(uren1x, 0.1) if uren1xM == 1;
replace uren2x = round(uren2x, 0.1) if uren2xM == 1;
replace uren3x = round(uren3x, 0.1) if uren3xM == 1;
replace uren4x = round(uren4x, 0.1) if uren4xM == 1;

/** Format for prior years/periods, especially m9, where m8 is coded as a survey **/

by id: replace bren0x = bren0x[_n - 1] if bren0xM == 1 & bren0xM[_n - 1] == 0 & yr < $curryr & (currmon == 3 | currmon == 6 | currmon == 9);
by id: replace bren1x = bren1x[_n - 1] if bren1xM == 1 & bren1xM[_n - 1] == 0 & yr < $curryr & (currmon == 3 | currmon == 6 | currmon == 9);
by id: replace bren2x = bren2x[_n - 1] if bren2xM == 1 & bren2xM[_n - 1] == 0 & yr < $curryr & (currmon == 3 | currmon == 6 | currmon == 9);
by id: replace bren3x = bren3x[_n - 1] if bren3xM == 1 & bren3xM[_n - 1] == 0 & yr < $curryr & (currmon == 3 | currmon == 6 | currmon == 9);
by id: replace bren4x = bren4x[_n - 1] if bren4xM == 1 & bren4xM[_n - 1] == 0 & yr < $curryr & (currmon == 3 | currmon == 6 | currmon == 9);

by id: replace uren0x = uren0x[_n - 1] if uren0xM == 1 & uren0xM[_n - 1] == 0 & yr < $curryr & (currmon == 3 | currmon == 6 | currmon == 9);
by id: replace uren1x = uren1x[_n - 1] if uren1xM == 1 & uren1xM[_n - 1] == 0 & yr < $curryr & (currmon == 3 | currmon == 6 | currmon == 9);
by id: replace uren2x = uren2x[_n - 1] if uren2xM == 1 & uren2xM[_n - 1] == 0 & yr < $curryr & (currmon == 3 | currmon == 6 | currmon == 9);
by id: replace uren3x = uren3x[_n - 1] if uren3xM == 1 & uren3xM[_n - 1] == 0 & yr < $curryr & (currmon == 3 | currmon == 6 | currmon == 9);
by id: replace uren4x = uren4x[_n - 1] if uren4xM == 1 & uren4xM[_n - 1] == 0 & yr < $curryr & (currmon == 3 | currmon == 6 | currmon == 9);

drop cbren0x-cbren4x curen0x-curen4x bren0tb-bren4tb uren0tb-uren4tb brentb urentb bedtb bedtu;

gen cbren0x = bren0x;
gen cbren1x = bren1x;
gen cbren2x = bren2x;
gen cbren3x = bren3x;
gen cbren4x = bren4x;

replace cbren0x = 0 if cbren0x == .;
replace cbren1x = 0 if cbren1x == .;
replace cbren2x = 0 if cbren2x == .;
replace cbren3x = 0 if cbren3x == .;

gen curen0x = uren0x;
gen curen1x = uren1x;
gen curen2x = uren2x;
gen curen3x = uren3x;
gen curen4x = uren4x;

replace curen0x = 0 if curen0x == .;
replace curen1x = 0 if curen1x == .;
replace curen2x = 0 if curen2x == .;
replace curen3x = 0 if curen3x == .;
replace curen4x = 0 if curen4x == .;
replace cbren4x = 0 if cbren4x == .; 

gen bren0tb = cbren0x*beds0x;
gen bren1tb = cbren1x*beds1x;
gen bren2tb = cbren2x*beds2x;
gen bren3tb = cbren3x*beds3x;
gen bren4tb = cbren4x*beds4x;

gen uren0tb = curen0x*units0x;
gen uren1tb = curen1x*units1x;
gen uren2tb = curen2x*units2x;
gen uren3tb = curen3x*units3x;
gen uren4tb = curen4x*units4x;

gen brentb = bren0tb + bren1tb + bren2tb + bren3tb + bren4tb;
gen urentb = uren0tb + uren1tb + uren2tb + uren3tb + uren4tb;
gen bedtb = beds0x + beds1x + beds2x + beds3x + beds4x;
gen bedtu = units0x + units1x + units2x + units3x + units4x;

replace avgrenxbed = round(brentb/bedtb, 0.1);
replace avgrenxun = round(urentb/bedtu, 0.1);

replace bren0x = . if beds0x == 0;
replace bren1x = . if beds1x == 0;
replace bren2x = . if beds2x == 0;
replace bren3x = . if beds3x == 0;
replace bren4x = . if beds4x == 0;

replace uren0x = . if units0x == 0;
replace uren1x = . if units1x == 0;
replace uren2x = . if units2x == 0;
replace uren3x = . if units3x == 0;
replace uren4x = . if units4x == 0;

replace bren0xM = . if beds0x == 0;
replace bren1xM = . if beds1x == 0;
replace bren2xM = . if beds2x == 0;
replace bren3xM = . if beds3x == 0;
replace bren4xM = . if beds4x == 0;

replace uren0xM = . if units0x == 0;
replace uren1xM = . if units1x == 0;
replace uren2xM = . if units2x == 0;
replace uren3xM = . if units3x == 0;
replace uren4xM = . if units4x == 0;
	
/** End fix, P10820 **/
	
drop furen*xl fbren*xl;

by id: egen fbren0xl = lastnm(fbren0x);
by id: egen fbren1xl = lastnm(fbren1x);
by id: egen fbren2xl = lastnm(fbren2x);
by id: egen fbren3xl = lastnm(fbren3x);
by id: egen fbren4xl = lastnm(fbren4x);

by id: egen furen0xl = lastnm(furen0x);
by id: egen furen1xl = lastnm(furen1x);
by id: egen furen2xl = lastnm(furen2x);
by id: egen furen3xl = lastnm(furen3x);
by id: egen furen4xl = lastnm(furen4x);

replace fbren0x = round(fbren0x, 0.1) if fbren0xM == 1;
replace fbren1x = round(fbren1x, 0.1) if fbren1xM == 1;
replace fbren2x = round(fbren2x, 0.1) if fbren2xM == 1;
replace fbren3x = round(fbren3x, 0.1) if fbren3xM == 1;
replace fbren4x = round(fbren4x, 0.1) if fbren4xM == 1;

replace furen0x = round(furen0x, 0.1) if furen0xM == 1;
replace furen1x = round(furen1x, 0.1) if furen1xM == 1;
replace furen2x = round(furen2x, 0.1) if furen2xM == 1;
replace furen3x = round(furen3x, 0.1) if furen3xM == 1;
replace furen4x = round(furen4x, 0.1) if furen4xM == 1;

gen cfbren0x = fbren0x;
gen cfbren1x = fbren1x;
gen cfbren2x = fbren2x;
gen cfbren3x = fbren3x;
gen cfbren4x = fbren4x;

replace cfbren0x = 0 if cfbren0x == .;
replace cfbren1x = 0 if cfbren1x == .;
replace cfbren2x = 0 if cfbren2x == .;
replace cfbren3x = 0 if cfbren3x == .;
replace cfbren4x = 0 if cfbren4x == .;

gen cfuren0x = furen0x;
gen cfuren1x = furen1x;
gen cfuren2x = furen2x;
gen cfuren3x = furen3x;
gen cfuren4x = furen4x;

replace cfuren0x = 0 if cfuren0x == .;
replace cfuren1x = 0 if cfuren1x == .;
replace cfuren2x = 0 if cfuren2x == .;
replace cfuren3x = 0 if cfuren3x == .;
replace cfuren4x = 0 if cfuren4x == .;

gen fbren0tb = cfbren0x*beds0x;
gen fbren1tb = cfbren1x*beds1x;
gen fbren2tb = cfbren2x*beds2x;
gen fbren3tb = cfbren3x*beds3x;
gen fbren4tb = cfbren4x*beds4x;

replace fbren0tb = 0 if fbren0tb == .;
replace fbren1tb = 0 if fbren1tb == .;
replace fbren2tb = 0 if fbren2tb == .;
replace fbren3tb = 0 if fbren3tb == .;
replace fbren4tb = 0 if fbren4tb == .;

gen fbrentb = fbren0tb + fbren1tb + fbren2tb + fbren3tb + fbren4tb;
gen fbedtb = beds0x + beds1x + beds2x + beds3x + beds4x;

gen avgfrenxbed = round(fbrentb/fbedtb, 0.1);
by id: egen avgfrenxbedl = lastnm(avgfrenxbed);

gen furen0tu = cfuren0x*units0x;
gen furen1tu = cfuren1x*units1x;
gen furen2tu = cfuren2x*units2x;
gen furen3tu = cfuren3x*units3x;
gen furen4tu = cfuren4x*units4x;

replace furen0tu = 0 if furen0tu == .;
replace furen1tu = 0 if furen1tu == .;
replace furen2tu = 0 if furen2tu == .;
replace furen3tu = 0 if furen3tu == .;
replace furen4tu = 0 if furen4tu == .;

gen furentu = furen0tu + furen1tu + furen2tu + furen3tu + furen4tu;
gen fbedtu = units0x + units1x + units2x + units3x + units4x;

gen avgfrenxun = round(furentu/fbedtu, 0.1);
by id: egen avgfrenxunl = lastnm(avgfrenxun);

replace fbren0x = . if beds0x == 0;
replace fbren1x = . if beds1x == 0;
replace fbren2x = . if beds2x == 0;
replace fbren3x = . if beds3x == 0;
replace fbren4x = . if beds4x == 0;

replace fbren0xl = . if beds0x == 0;
replace fbren1xl = . if beds1x == 0;
replace fbren2xl = . if beds2x == 0;
replace fbren3xl = . if beds3x == 0;
replace fbren4xl = . if beds4x == 0;

replace fbren0xM = . if beds0x == 0;
replace fbren1xM = . if beds1x == 0;
replace fbren2xM = . if beds2x == 0;
replace fbren3xM = . if beds3x == 0;
replace fbren4xM = . if beds4x == 0;

replace furen0x = . if units0x == 0;
replace furen1x = . if units1x == 0;
replace furen2x = . if units2x == 0;
replace furen3x = . if units3x == 0;
replace furen4x = . if units4x == 0;

replace furen0xl = . if units0x == 0;
replace furen1xl = . if units1x == 0;
replace furen2xl = . if units2x == 0;
replace furen3xl = . if units3x == 0;
replace furen4xl = . if units4x == 0;

replace furen0xM = . if units0x == 0;
replace furen1xM = . if units1x == 0;
replace furen2xM = . if units2x == 0;
replace furen3xM = . if units3x == 0;
replace furen4xM = . if units4x == 0;

/** Regenerate OLD format of ren*x / ren*xM / fren*x / fren*xM **/

gen ren0x = .;
gen ren1x = .;
gen ren2x = .;
gen ren3x = .;
gen ren4x = .;

gen ren0xM = .;
gen ren1xM = .;
gen ren2xM = .;
gen ren3xM = .;
gen ren4xM = .;

gen fren0x = .;
gen fren1x = .;
gen fren2x = .;
gen fren3x = .;
gen fren4x = .;

gen fren0xM = .;
gen fren1xM = .;
gen fren2xM = .;
gen fren3xM = .;
gen fren4xM = .;

replace ren0x = bren0x if renttype == "Bed";
replace ren1x = bren1x if renttype == "Bed";
replace ren2x = bren2x if renttype == "Bed";
replace ren3x = bren3x if renttype == "Bed";
replace ren4x = bren4x if renttype == "Bed";

replace ren0xM = bren0xM if renttype == "Bed";
replace ren1xM = bren1xM if renttype == "Bed";
replace ren2xM = bren2xM if renttype == "Bed";
replace ren3xM = bren3xM if renttype == "Bed";
replace ren4xM = bren4xM if renttype == "Bed";

replace ren0x = uren0x if renttype == "Unit";
replace ren1x = uren1x if renttype == "Unit";
replace ren2x = uren2x if renttype == "Unit";
replace ren3x = uren3x if renttype == "Unit";
replace ren4x = uren4x if renttype == "Unit";

replace ren0xM = uren0xM if renttype == "Unit";
replace ren1xM = uren1xM if renttype == "Unit";
replace ren2xM = uren2xM if renttype == "Unit";
replace ren3xM = uren3xM if renttype == "Unit";
replace ren4xM = uren4xM if renttype == "Unit";

replace fren0x = fbren0x if renttype == "Bed";
replace fren1x = fbren1x if renttype == "Bed";
replace fren2x = fbren2x if renttype == "Bed";
replace fren3x = fbren3x if renttype == "Bed";
replace fren4x = fbren4x if renttype == "Bed";

replace fren0xM = fbren0xM if renttype == "Bed";
replace fren1xM = fbren1xM if renttype == "Bed";
replace fren2xM = fbren2xM if renttype == "Bed";
replace fren3xM = fbren3xM if renttype == "Bed";
replace fren4xM = fbren4xM if renttype == "Bed";

replace fren0x = furen0x if renttype == "Unit";
replace fren1x = furen1x if renttype == "Unit";
replace fren2x = furen2x if renttype == "Unit";
replace fren3x = furen3x if renttype == "Unit";
replace fren4x = furen4x if renttype == "Unit";

replace fren0xM = furen0xM if renttype == "Unit";
replace fren1xM = furen1xM if renttype == "Unit";
replace fren2xM = furen2xM if renttype == "Unit";
replace fren3xM = furen3xM if renttype == "Unit";
replace fren4xM = furen4xM if renttype == "Unit";

/** Where no subid's are assigned, assign subid = 69 **/

replace subid = 69 if subid == .;
replace subname = "Not Submarketed - TB" if subname == "";

/** The LEXINGTON protocol - IDs that have floor plans with only 5BRs/Units or more **/

	replace beds0x = 0 if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace beds1x = 0 if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace beds2x = 0 if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace beds3x = 0 if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace beds4x = totbedx if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
					
	replace units0x = 0 if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace units1x = 0 if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace units2x = 0 if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace units3x = 0 if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace units4x = totunitx if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
					
	replace bed0sizex = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace bed1sizex = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace bed2sizex = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace bed3sizex = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
					
	replace bed0sizexM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace bed1sizexM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace bed2sizexM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace bed3sizexM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					
					
	replace un0sizex = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace un1sizex = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace un2sizex = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace un3sizex = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");	
					
	replace un0sizexM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace un1sizexM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace un2sizexM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace un3sizexM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");		
					
	replace ren0x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace ren1x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace ren2x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace ren3x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");

	replace ren0xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace ren1xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace ren2xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace ren3xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
					
	replace fren0x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace fren1x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace fren2x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace fren3x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");

	replace fren0xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace fren1xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace fren2xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace fren3xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					
					
	replace bren0x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace bren1x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace bren2x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace bren3x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");

	replace bren0xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace bren1xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace bren2xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace bren3xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
					
	replace uren0x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace uren1x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace uren2x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace uren3x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");

	replace uren0xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace uren1xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace uren2xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace uren3xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
					
	replace fbren0x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace fbren1x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace fbren2x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace fbren3x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
					
	replace fbren0xl = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace fbren1xl = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace fbren2xl = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace fbren3xl = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					

	replace fbren0xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace fbren1xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace fbren2xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace fbren3xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
					
	replace furen0x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace furen1x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace furen2x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace furen3x = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
					
	replace furen0xl = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace furen1xl = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace furen2xl = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace furen3xl = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					

	replace furen0xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace furen1xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					 
	replace furen2xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");
	replace furen3xM = . if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");					

	replace avgrenxbed = bren4x if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");	
	replace avgrenxun = uren4x if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");	
	replace avgfrenxbed = fbren4x if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");	
	replace avgfrenxun = furen4x if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");	
	replace avgfrenxunl = furen4xl if (id == "P3568" | id == "P11897" | id == "P12258" | id == "P2944" | id == "P6381" | 
                    id == "P4087" | id == "P5602" | id == "P569" | id == "P6456" | id == "P3125" | 
					id == "P3668" | id == "P925" | id == "P2342" | id == "P11303" | id == "P5682" | 
					id == "P1326" | id == "P12267" | id == "P6462" | id == "P5402" | id == "P11882" | 
					id == "P2175" | id == "P6426" | id == "P2123" | id == "P6421" | id == "P6577" | 
					id == "P6586" | id == "P6592" | id == "P6596");	

order id yr qtr currmon unicode university unistatus propuse code codeshort metcode longmet subid subname name status propertytype purposebuilt 
      oncampus universityowned distancetocampus streetaddress 
      city county state zip x y yrbuilt monthbuilt bldgx bldgxM flrsx flrsxM totbeds totbedx totbedxM beds0x beds0xM beds1x beds1xM beds2x 
	  beds2xM beds3x beds3xM beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM 
	  units4x units4xM bed0sizex bed0sizexM bed1sizex bed1sizexM bed2sizex bed2sizexM bed3sizex bed3sizexM bed4sizex bed4sizexM 
	  un0sizex un0sizexM un1sizex un1sizexM un2sizex un2sizexM un3sizex un3sizexM un4sizex un4sizexM survyr survmon surveydate 
	  averagerent freerentpercent leaseterm monthsfreerent percentpreleased percentrentutilities percentstudents reducedfreerentpercent 
	  reducedleaseterm reducedrentdiscount renttype renttypexM doubleoccupancy tripleoccupancy availbedx availbedxM vacbedx dbvacbed availunx availunxM vacunx dbvacun
	  favailbedx fvacbedx favailunx fvacunx 
	  ren0x ren0xM ren1x ren1xM ren2x ren2xM ren3x ren3xM ren4x ren4xM avgrenxbed avgrenxun avgrenx avgrenxM
	  fren0x fren0xM fren1x fren1xM fren2x fren2xM fren3x fren3xM fren4x fren4xM avgfrenxbed avgfrenxbedl avgfrenxun avgfrenxunl	  
	  bren0x bren0xM bren1x bren1xM bren2x bren2xM bren3x bren3xM bren4x bren4xM
	  uren0x uren0xM uren1x uren1xM uren2x uren2xM uren3x uren3xM uren4x uren4xM
	  totalvacantbeds totalvacantunits 
	  fbren0x fbren0xM fbren0xl fbren1x fbren1xl fbren1xM fbren2x fbren2xl fbren2xM fbren3x fbren3xl fbren3xM fbren4x fbren4xl fbren4xM 
	  furen0x furen0xM furen0xl furen1x furen1xl furen1xM furen2x furen2xl furen2xM furen3x furen3xl furen3xM furen4x furen4xl furen4xM 
	  braverage0 braverage1 braverage2 braverage3 braverage4 
	  brfutureaverage0 brfutureaverage1 brfutureaverage2 brfutureaverage3 brfutureaverage4 leasingincentives  brparity0 brparity1 brparity2 brparity3 brparity4;

save $prefix/central/vc/std/data/std_rawcalcs_${curryr}q${currqtr}testn, replace;

order id yr qtr currmon unicode university unistatus propuse code codeshort metcode longmet subid subname name status propertytype purposebuilt 
      oncampus universityowned distancetocampus streetaddress 
      city county state zip x y yrbuilt monthbuilt bldgx bldgxM flrsx flrsxM totbeds totbedx totbedxM beds0x beds0xM beds1x beds1xM beds2x 
	  beds2xM beds3x beds3xM beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM 
	  units4x units4xM bed0sizex bed0sizexM bed1sizex bed1sizexM bed2sizex bed2sizexM bed3sizex bed3sizexM bed4sizex bed4sizexM 
	  un0sizex un0sizexM un1sizex un1sizexM un2sizex un2sizexM un3sizex un3sizexM un4sizex un4sizexM survyr survmon surveydate 
	  averagerent freerentpercent leaseterm monthsfreerent percentpreleased percentrentutilities percentstudents reducedfreerentpercent 
	  reducedleaseterm reducedrentdiscount renttype renttypexM doubleoccupancy tripleoccupancy availbedx availbedxM vacbedx dbvacbed availunx availunxM vacunx dbvacun
	  favailbedx fvacbedx favailunx fvacunx 
	  ren0x ren0xM ren1x ren1xM ren2x ren2xM ren3x ren3xM ren4x ren4xM avgrenxbed avgrenxun avgrenx avgrenxM
	  fren0x fren0xM fren1x fren1xM fren2x fren2xM fren3x fren3xM fren4x fren4xM avgfrenxbed avgfrenxbedl avgfrenxun avgfrenxunl	  
	  bren0x bren0xM bren1x bren1xM bren2x bren2xM bren3x bren3xM bren4x bren4xM
	  uren0x uren0xM uren1x uren1xM uren2x uren2xM uren3x uren3xM uren4x uren4xM
	  totalvacantbeds totalvacantunits 
	  fbren0x fbren0xM fbren0xl fbren1x fbren1xl fbren1xM fbren2x fbren2xl fbren2xM fbren3x fbren3xl fbren3xM fbren4x fbren4xl fbren4xM 
	  furen0x furen0xM furen0xl furen1x furen1xl furen1xM furen2x furen2xl furen2xM furen3x furen3xl furen3xM furen4x furen4xl furen4xM 
	  braverage0 braverage1 braverage2 braverage3 braverage4 
	  brfutureaverage0 brfutureaverage1 brfutureaverage2 brfutureaverage3 brfutureaverage4 leasingincentives  brparity0 brparity1 brparity2 brparity3 brparity4;
	  
	  /** Formatting for existsx **/
	  
	  gen yearx = yrbuilt;
	  gen monthx = monthbuilt;
	  sort unicode subid yr currmon;
	  by unicode subid: egen yearxm = mean(yearx);
	  sort id yr currmon;
	  replace yearx = round(yearxm, 1) if yearx == .;
	  gen yearxM = 0;
	  replace yearxM = 1 if yrbuilt == .;
	  gen monthxM = 0;
	  replace monthx = 12 if monthbuilt == .;
	  replace monthxM = 1 if monthbuilt == .;
	  
	  gen existsx = 1;
	  replace existsx = 0 if yr < yearx;
	  replace existsx = 0 if yr == yearx & currmon < monthx;
	  
	  /** Allowance for propuse = "ConventionalDorm" and "DormSuite" **/
	  
	  replace ren0x = . if propuse == "ConventionalDorm";
	  replace ren1x = . if propuse == "ConventionalDorm";
	  replace ren2x = . if propuse == "ConventionalDorm";
	  replace ren3x = . if propuse == "ConventionalDorm";
	  replace ren4x = . if propuse == "ConventionalDorm";
	  
	  replace ren0xM = . if propuse == "ConventionalDorm";
	  replace ren1xM = . if propuse == "ConventionalDorm";
	  replace ren2xM = . if propuse == "ConventionalDorm";
	  replace ren3xM = . if propuse == "ConventionalDorm";
	  replace ren4xM = . if propuse == "ConventionalDorm";
	  
	  replace bren0x = . if propuse == "ConventionalDorm";
	  replace bren1x = . if propuse == "ConventionalDorm";
	  replace bren2x = . if propuse == "ConventionalDorm";
	  replace bren3x = . if propuse == "ConventionalDorm";
	  replace bren4x = . if propuse == "ConventionalDorm";	
	  
	  replace bren0xM = . if propuse == "ConventionalDorm";
	  replace bren1xM = . if propuse == "ConventionalDorm";
	  replace bren2xM = . if propuse == "ConventionalDorm";
	  replace bren3xM = . if propuse == "ConventionalDorm";
	  replace bren4xM = . if propuse == "ConventionalDorm";		
	  
	  replace uren0x = . if propuse == "ConventionalDorm";
	  replace uren1x = . if propuse == "ConventionalDorm";
	  replace uren2x = . if propuse == "ConventionalDorm";
	  replace uren3x = . if propuse == "ConventionalDorm";
	  replace uren4x = . if propuse == "ConventionalDorm";	
	  
	  replace uren0xM = . if propuse == "ConventionalDorm";
	  replace uren1xM = . if propuse == "ConventionalDorm";
	  replace uren2xM = . if propuse == "ConventionalDorm";
	  replace uren3xM = . if propuse == "ConventionalDorm";
	  replace uren4xM = . if propuse == "ConventionalDorm";	
	  
      replace beds0x = . if propuse == "ConventionalDorm";
      replace beds1x = . if propuse == "ConventionalDorm";
	  replace beds2x = . if propuse == "ConventionalDorm";
	  replace beds3x = . if propuse == "ConventionalDorm";
	  replace beds4x = . if propuse == "ConventionalDorm";
	  
      replace beds0xM = . if propuse == "ConventionalDorm";
      replace beds1xM = . if propuse == "ConventionalDorm";
	  replace beds2xM = . if propuse == "ConventionalDorm";
	  replace beds3xM = . if propuse == "ConventionalDorm";
	  replace beds4xM = . if propuse == "ConventionalDorm";	  
      	  
      replace units0x = . if propuse == "ConventionalDorm";
      replace units1x = . if propuse == "ConventionalDorm";
	  replace units2x = . if propuse == "ConventionalDorm";
	  replace units3x = . if propuse == "ConventionalDorm";
	  replace units4x = . if propuse == "ConventionalDorm";
	  
      replace units0xM = . if propuse == "ConventionalDorm";
      replace units1xM = . if propuse == "ConventionalDorm";
	  replace units2xM = . if propuse == "ConventionalDorm";
	  replace units3xM = . if propuse == "ConventionalDorm";
	  replace units4xM = . if propuse == "ConventionalDorm";
	  
	  replace fren0x = . if propuse == "ConventionalDorm";
	  replace fren1x = . if propuse == "ConventionalDorm";
	  replace fren2x = . if propuse == "ConventionalDorm";
	  replace fren3x = . if propuse == "ConventionalDorm";
	  replace fren4x = . if propuse == "ConventionalDorm";
	  
	  replace fren0xM = . if propuse == "ConventionalDorm";
	  replace fren1xM = . if propuse == "ConventionalDorm";
	  replace fren2xM = . if propuse == "ConventionalDorm";
	  replace fren3xM = . if propuse == "ConventionalDorm";
	  replace fren4xM = . if propuse == "ConventionalDorm";
	  
	  replace fbren0x = . if propuse == "ConventionalDorm";
	  replace fbren1x = . if propuse == "ConventionalDorm";
	  replace fbren2x = . if propuse == "ConventionalDorm";
	  replace fbren3x = . if propuse == "ConventionalDorm";
	  replace fbren4x = . if propuse == "ConventionalDorm";	
	  
	  replace fbren0xM = . if propuse == "ConventionalDorm";
	  replace fbren1xM = . if propuse == "ConventionalDorm";
	  replace fbren2xM = . if propuse == "ConventionalDorm";
	  replace fbren3xM = . if propuse == "ConventionalDorm";
	  replace fbren4xM = . if propuse == "ConventionalDorm";		
	  
	  replace furen0x = . if propuse == "ConventionalDorm";
	  replace furen1x = . if propuse == "ConventionalDorm";
	  replace furen2x = . if propuse == "ConventionalDorm";
	  replace furen3x = . if propuse == "ConventionalDorm";
	  replace furen4x = . if propuse == "ConventionalDorm";	
	  
	  replace furen0xM = . if propuse == "ConventionalDorm";
	  replace furen1xM = . if propuse == "ConventionalDorm";
	  replace furen2xM = . if propuse == "ConventionalDorm";
	  replace furen3xM = . if propuse == "ConventionalDorm";
	  replace furen4xM = . if propuse == "ConventionalDorm";	
	  
	  replace avgfrenxbed = . if propuse == "ConventionalDorm";
	  replace avgfrenxun = . if propuse == "ConventionalDorm";
	  
	  replace avgrenx = round(avgrenx, 0.1);
	  replace avgrenxbed = avgrenx if propuse == "ConventionalDorm";
	  replace avgrenxun = avgrenx if propuse == "ConventionalDorm";
	  
	  replace ren0x = . if propuse == "DormSuite";
	  replace ren1x = . if propuse == "DormSuite";
	  replace ren2x = . if propuse == "DormSuite";
	  replace ren3x = . if propuse == "DormSuite";
	  replace ren4x = . if propuse == "DormSuite";
	  
	  replace ren0xM = . if propuse == "DormSuite";
	  replace ren1xM = . if propuse == "DormSuite";
	  replace ren2xM = . if propuse == "DormSuite";
	  replace ren3xM = . if propuse == "DormSuite";
	  replace ren4xM = . if propuse == "DormSuite";
	  
	  replace bren0x = . if propuse == "DormSuite";
	  replace bren1x = . if propuse == "DormSuite";
	  replace bren2x = . if propuse == "DormSuite";
	  replace bren3x = . if propuse == "DormSuite";
	  replace bren4x = . if propuse == "DormSuite";	
	  
	  replace bren0xM = . if propuse == "DormSuite";
	  replace bren1xM = . if propuse == "DormSuite";
	  replace bren2xM = . if propuse == "DormSuite";
	  replace bren3xM = . if propuse == "DormSuite";
	  replace bren4xM = . if propuse == "DormSuite";		
	  
	  replace uren0x = . if propuse == "DormSuite";
	  replace uren1x = . if propuse == "DormSuite";
	  replace uren2x = . if propuse == "DormSuite";
	  replace uren3x = . if propuse == "DormSuite";
	  replace uren4x = . if propuse == "DormSuite";	
	  
	  replace uren0xM = . if propuse == "DormSuite";
	  replace uren1xM = . if propuse == "DormSuite";
	  replace uren2xM = . if propuse == "DormSuite";
	  replace uren3xM = . if propuse == "DormSuite";
	  replace uren4xM = . if propuse == "DormSuite";	
	  
      replace beds0x = . if propuse == "DormSuite";
      replace beds1x = . if propuse == "DormSuite";
	  replace beds2x = . if propuse == "DormSuite";
	  replace beds3x = . if propuse == "DormSuite";
	  replace beds4x = . if propuse == "DormSuite";
	  
      replace beds0xM = . if propuse == "DormSuite";
      replace beds1xM = . if propuse == "DormSuite";
	  replace beds2xM = . if propuse == "DormSuite";
	  replace beds3xM = . if propuse == "DormSuite";
	  replace beds4xM = . if propuse == "DormSuite";	  
      	  
      replace units0x = . if propuse == "DormSuite";
      replace units1x = . if propuse == "DormSuite";
	  replace units2x = . if propuse == "DormSuite";
	  replace units3x = . if propuse == "DormSuite";
	  replace units4x = . if propuse == "DormSuite";
	  
      replace units0xM = . if propuse == "DormSuite";
      replace units1xM = . if propuse == "DormSuite";
	  replace units2xM = . if propuse == "DormSuite";
	  replace units3xM = . if propuse == "DormSuite";
	  replace units4xM = . if propuse == "DormSuite";
	  
	  replace fren0x = . if propuse == "DormSuite";
	  replace fren1x = . if propuse == "DormSuite";
	  replace fren2x = . if propuse == "DormSuite";
	  replace fren3x = . if propuse == "DormSuite";
	  replace fren4x = . if propuse == "DormSuite";
	  
	  replace fren0xM = . if propuse == "DormSuite";
	  replace fren1xM = . if propuse == "DormSuite";
	  replace fren2xM = . if propuse == "DormSuite";
	  replace fren3xM = . if propuse == "DormSuite";
	  replace fren4xM = . if propuse == "DormSuite";
	  
	  replace fbren0x = . if propuse == "DormSuite";
	  replace fbren1x = . if propuse == "DormSuite";
	  replace fbren2x = . if propuse == "DormSuite";
	  replace fbren3x = . if propuse == "DormSuite";
	  replace fbren4x = . if propuse == "DormSuite";	
	  
	  replace fbren0xM = . if propuse == "DormSuite";
	  replace fbren1xM = . if propuse == "DormSuite";
	  replace fbren2xM = . if propuse == "DormSuite";
	  replace fbren3xM = . if propuse == "DormSuite";
	  replace fbren4xM = . if propuse == "DormSuite";		
	  
	  replace furen0x = . if propuse == "DormSuite";
	  replace furen1x = . if propuse == "DormSuite";
	  replace furen2x = . if propuse == "DormSuite";
	  replace furen3x = . if propuse == "DormSuite";
	  replace furen4x = . if propuse == "DormSuite";	
	  
	  replace furen0xM = . if propuse == "DormSuite";
	  replace furen1xM = . if propuse == "DormSuite";
	  replace furen2xM = . if propuse == "DormSuite";
	  replace furen3xM = . if propuse == "DormSuite";
	  replace furen4xM = . if propuse == "DormSuite";	
	  
	  replace avgfrenxbed = . if propuse == "DormSuite";
	  replace avgfrenxun = . if propuse == "DormSuite";
	  
	  replace avgrenx = round(avgrenx, 0.1);
	  replace avgrenxbed = avgrenx if propuse == "DormSuite";
	  replace avgrenxun = avgrenx if propuse == "DormSuite";
	  
keep id yr qtr currmon unicode university unistatus propuse code codeshort metcode longmet subid subname name status propertytype purposebuilt 
      oncampus universityowned distancetocampus streetaddress 
      city county state zip x y yrbuilt monthbuilt bldgx bldgxM flrsx flrsxM totbeds totbedx totbedxM beds0x beds0xM beds1x beds1xM beds2x 
	  beds2xM beds3x beds3xM beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM 
	  units4x units4xM bed0sizex bed0sizexM bed1sizex bed1sizexM bed2sizex bed2sizexM bed3sizex bed3sizexM bed4sizex bed4sizexM 
	  un0sizex un0sizexM un1sizex un1sizexM un2sizex un2sizexM un3sizex un3sizexM un4sizex un4sizexM survyr survmon surveydate 
	  averagerent freerentpercent leaseterm monthsfreerent percentpreleased percentrentutilities percentstudents reducedfreerentpercent 
	  reducedleaseterm reducedrentdiscount renttype renttypexM doubleoccupancy tripleoccupancy availbedx availbedxM vacbedx dbvacbed availunx availunxM vacunx dbvacun
      favailbedx fvacbedx favailunx fvacunx 
	  ren0x ren0xM ren1x ren1xM ren2x ren2xM ren3x ren3xM ren4x ren4xM avgrenxbed avgrenxun avgrenx avgrenxM
	  fren0x fren0xM fren1x fren1xM fren2x fren2xM fren3x fren3xM fren4x fren4xM avgfrenxbed avgfrenxbedl avgfrenxun avgfrenxunl	  
	  bren0x bren0xM bren1x bren1xM bren2x bren2xM bren3x bren3xM bren4x bren4xM
	  uren0x uren0xM uren1x uren1xM uren2x uren2xM uren3x uren3xM uren4x uren4xM  
	  fbren0x fbren0xM fbren0xl fbren1x fbren1xl fbren1xM fbren2x fbren2xl fbren2xM fbren3x fbren3xl fbren3xM fbren4x fbren4xl fbren4xM 
	  furen0x furen0xM furen0xl furen1x furen1xl furen1xM furen2x furen2xl furen2xM furen3x furen3xl furen3xM furen4x furen4xl furen4xM	  
	  yearx yearxM monthx monthxM existsx leasingincentives  brparity0 brparity1 brparity2 brparity3 brparity4;
	  
order id yr qtr currmon unicode university unistatus propuse code codeshort metcode longmet subid subname name status propertytype purposebuilt 
      oncampus universityowned distancetocampus streetaddress 
      city county state zip x y yrbuilt monthbuilt bldgx bldgxM flrsx flrsxM totbeds totbedx totbedxM beds0x beds0xM beds1x beds1xM beds2x 
	  beds2xM beds3x beds3xM beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM 
	  units4x units4xM bed0sizex bed0sizexM bed1sizex bed1sizexM bed2sizex bed2sizexM bed3sizex bed3sizexM bed4sizex bed4sizexM 
	  un0sizex un0sizexM un1sizex un1sizexM un2sizex un2sizexM un3sizex un3sizexM un4sizex un4sizexM survyr survmon surveydate 
	  averagerent freerentpercent leaseterm monthsfreerent percentpreleased percentrentutilities percentstudents reducedfreerentpercent 
	  reducedleaseterm reducedrentdiscount renttype renttypexM doubleoccupancy tripleoccupancy availbedx availbedxM vacbedx dbvacbed availunx availunxM vacunx dbvacun
      favailbedx fvacbedx favailunx fvacunx
	  ren0x ren0xM ren1x ren1xM ren2x ren2xM ren3x ren3xM ren4x ren4xM avgrenxbed avgrenxun avgrenx avgrenxM
	  fren0x fren0xM fren1x fren1xM fren2x fren2xM fren3x fren3xM fren4x fren4xM avgfrenxbed avgfrenxbedl avgfrenxun avgfrenxunl	  
	  bren0x bren0xM bren1x bren1xM bren2x bren2xM bren3x bren3xM bren4x bren4xM
	  uren0x uren0xM uren1x uren1xM uren2x uren2xM uren3x uren3xM uren4x uren4xM  
	  fbren0x fbren0xM fbren0xl fbren1x fbren1xl fbren1xM fbren2x fbren2xl fbren2xM fbren3x fbren3xl fbren3xM fbren4x fbren4xl fbren4xM 
	  furen0x furen0xM furen0xl furen1x furen1xl furen1xM furen2x furen2xl furen2xM furen3x furen3xl furen3xM furen4x furen4xl furen4xM	  
	  yearx yearxM monthx monthxM existsx leasingincentives  brparity0 brparity1 brparity2 brparity3 brparity4;
	  
	  rename avgrenx avgrenEST;
	  rename avgrenxM avgrenESTxM;
	  
save $prefix/central/vc/std/data/std_rawcalcs_formatted_${curryr}q${currqtr}testn, replace;	  
clear;

/** Generate MSQs for FO **/
	 
  local i = 1;
  local I : word count $metlist;
     while `i' <= `I' {;
     local j : word `i' of $metlist;
	 
     use $prefix/central/vc/std/data/std_rawcalcs_formatted_${curryr}q${currqtr}testn;
	 
	 gen str3 metcode_sm = lower(unicode);
	 keep if metcode_sm == "`j'";
	 drop metcode_sm;
	 
	 /** 2015-05-12: DQ says "these don't belong in the MSQs" - wow, poor properties. Thanks, DQ! **/
	 
	 drop if codeshort == "New Construction";
	 drop if codeshort == "NEW CONSTRUCTION";	 
	 drop if codeshort == "Type Change";
	 drop if codeshort == "I.A.G.";
	 drop if codeshort == "Pending";
	 drop if codeshort == "Quarantine";	
	 drop if codeshort == "Non Competitive" & propuse == "";
	 

	 if `i' == 1 {save $prefix/central/square/data/std/production/msq/`j'msqtestn, replace};
     if `i' ~= 1 {;
	     save $prefix/central/square/data/std/production/msq/`j'msqtestn, replace;
	             };

     drop _all;
     local i = `i' + 1;

     };	 
     
if $curryr == 2016 & $currqtr == 4 & $currmo == 12 {;


  local i = 1;
  local I : word count $metlist;
     while `i' <= `I' {;
     local j : word `i' of $metlist;
	 
     use $prefix/central/square/data/std/production/msq/`j'msqtestn;
	 
     sort id yr qtr currmon;
     
     /** Ben Bloch patch - Early 2017 research, only active for 2016Q4 **/
     
        joinby id yr qtr currmon using $prefix/central/vc/std/data/std_BB_patch_2016q4.dta, unmatched(master);
     
        replace fren0x = fren0xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & fren0xBB ~= .;
        replace fren1x = fren1xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & fren1xBB ~= .;
        replace fren2x = fren2xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & fren2xBB ~= .;
        replace fren3x = fren3xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & fren3xBB ~= .;
        replace fren4x = fren4xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & fren4xBB ~= .;
     
        replace fbren0x = fbren0xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & fbren0xBB ~= .;
        replace fbren1x = fbren1xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & fbren1xBB ~= .;
        replace fbren2x = fbren2xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & fbren2xBB ~= .;
        replace fbren3x = fbren3xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & fbren3xBB ~= .;
        replace fbren4x = fbren4xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & fbren4xBB ~= .;  
        
        replace furen0x = furen0xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & furen0xBB ~= .;
        replace furen1x = furen1xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & furen1xBB ~= .;
        replace furen2x = furen2xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & furen2xBB ~= .;
        replace furen3x = furen3xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & furen3xBB ~= .;
        replace furen4x = furen4xBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & furen4xBB ~= .;    
        
        replace avgfrenxbed = avgfrenxbedBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & avgfrenxbedBB ~= .;
        replace avgfrenxun = avgfrenxunBB if _merge == 3 & yr == 2016 & qtr == 4 & currmon == 12 & avgfrenxunBB ~= .;
        
     keep id yr qtr currmon unicode university unistatus propuse code codeshort metcode longmet subid subname name status propertytype purposebuilt 
           oncampus universityowned distancetocampus streetaddress 
           city county state zip x y yrbuilt monthbuilt bldgx bldgxM flrsx flrsxM totbeds totbedx totbedxM beds0x beds0xM beds1x beds1xM beds2x 
     	  beds2xM beds3x beds3xM beds4x beds4xM totunits totunitx totunitxM units0x units0xM units1x units1xM units2x units2xM units3x units3xM 
     	  units4x units4xM bed0sizex bed0sizexM bed1sizex bed1sizexM bed2sizex bed2sizexM bed3sizex bed3sizexM bed4sizex bed4sizexM 
     	  un0sizex un0sizexM un1sizex un1sizexM un2sizex un2sizexM un3sizex un3sizexM un4sizex un4sizexM survyr survmon surveydate 
     	  averagerent freerentpercent leaseterm monthsfreerent percentpreleased percentrentutilities percentstudents reducedfreerentpercent 
     	  reducedleaseterm reducedrentdiscount renttype renttypexM doubleoccupancy tripleoccupancy availbedx availbedxM vacbedx dbvacbed availunx availunxM vacunx dbvacun
           favailbedx fvacbedx favailunx fvacunx
     	  ren0x ren0xM ren1x ren1xM ren2x ren2xM ren3x ren3xM ren4x ren4xM avgrenxbed avgrenxun avgrenEST avgrenESTxM
     	  fren0x fren0xM fren1x fren1xM fren2x fren2xM fren3x fren3xM fren4x fren4xM avgfrenxbed avgfrenxbedl avgfrenxun avgfrenxunl	  
     	  bren0x bren0xM bren1x bren1xM bren2x bren2xM bren3x bren3xM bren4x bren4xM
     	  uren0x uren0xM uren1x uren1xM uren2x uren2xM uren3x uren3xM uren4x uren4xM  
     	  fbren0x fbren0xM fbren0xl fbren1x fbren1xl fbren1xM fbren2x fbren2xl fbren2xM fbren3x fbren3xl fbren3xM fbren4x fbren4xl fbren4xM 
     	  furen0x furen0xM furen0xl furen1x furen1xl furen1xM furen2x furen2xl furen2xM furen3x furen3xl furen3xM furen4x furen4xl furen4xM	  
     	  yearx yearxM monthx monthxM existsx leasingincentives  brparity0 brparity1 brparity2 brparity3 brparity4;   

	 if `i' == 1 {save $prefix/central/square/data/std/production/msq/`j'msqtestn, replace};
     if `i' ~= 1 {;
	     save $prefix/central/square/data/std/production/msq/`j'msqtestn, replace;
	             };

     drop _all;
     local i = `i' + 1;

     };	 
     
     };
	 
	  


	  
	  
	  
	  
