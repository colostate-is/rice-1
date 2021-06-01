--
-- Copyright 2005-2018 The Kuali Foundation
--
-- Licensed under the Educational Community License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.opensource.org/licenses/ecl2.php
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

-----------------------------------------------------------------------------
-- KRMS_ATTR_DEFN_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_ATTR_DEFN_T (ACTV,ATTR_DEFN_ID,DESC_TXT,LBL,NM,NMSPC_CD,VER_NBR)
  VALUES ('Y','T1000','null','Context 1 Qualifier','Context1Qualifier','KR-RULE-TEST',1)
/
INSERT INTO KRMS_ATTR_DEFN_T (ACTV,ATTR_DEFN_ID,DESC_TXT,LBL,NM,NMSPC_CD,VER_NBR)
  VALUES ('Y','T1001','null','Event Name','Event','KR-RULE-TEST',1)
/
INSERT INTO KRMS_ATTR_DEFN_T (ACTV,ATTR_DEFN_ID,DESC_TXT,LBL,NM,NMSPC_CD,VER_NBR)
  VALUES ('Y','T1002','this is an optional attribute for testing','label','Optional Test Attribute','KR-RULE-TEST',0)
/
INSERT INTO KRMS_ATTR_DEFN_T (ACTV,ATTR_DEFN_ID,DESC_TXT,LBL,NM,NMSPC_CD,VER_NBR)
  VALUES ('Y','T1003','the campus which this agenda is valid for','campus label','Campus','KR-RULE-TEST',0)
/

-----------------------------------------------------------------------------
-- KRMS_TYP_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_TYP_T (ACTV,NM,NMSPC_CD,TYP_ID,VER_NBR)
  VALUES ('Y','TermResolver','KR-RULE-TEST','T1000',1)
/
INSERT INTO KRMS_TYP_T (ACTV,NM,NMSPC_CD,SRVC_NM,TYP_ID,VER_NBR)
  VALUES ('Y','CAMPUS','KR-RULE-TEST','myCampusService','T1001',1)
/
INSERT INTO KRMS_TYP_T (ACTV,NM,NMSPC_CD,SRVC_NM,TYP_ID,VER_NBR)
  VALUES ('Y','KrmsActionResolverType','KR-RULE-TEST','testActionTypeService','T1002',1)
/
INSERT INTO KRMS_TYP_T (ACTV,NM,NMSPC_CD,TYP_ID,VER_NBR)
  VALUES ('Y','CONTEXT','KR-RULE-TEST','T1003',1)
/
INSERT INTO KRMS_TYP_T (ACTV,NM,NMSPC_CD,TYP_ID,VER_NBR)
  VALUES ('Y','AGENDA','KR-RULE-TEST','T1004',1)
/
INSERT INTO KRMS_TYP_T (ACTV,NM,NMSPC_CD,SRVC_NM,TYP_ID,VER_NBR)
  VALUES ('Y','Campus Agenda','KR-RULE-TEST','campusAgendaTypeService','T1005',1)
/

-----------------------------------------------------------------------------
-- KRMS_TYP_ATTR_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_TYP_ATTR_T (ACTV,ATTR_DEFN_ID,SEQ_NO,TYP_ATTR_ID,TYP_ID,VER_NBR)
  VALUES ('Y','T1000',1,'T1000','T1003',1)
/
INSERT INTO KRMS_TYP_ATTR_T (ACTV,ATTR_DEFN_ID,SEQ_NO,TYP_ATTR_ID,TYP_ID,VER_NBR)
  VALUES ('Y','T1002',2,'T1001','T1005',0)
/
INSERT INTO KRMS_TYP_ATTR_T (ACTV,ATTR_DEFN_ID,SEQ_NO,TYP_ATTR_ID,TYP_ID,VER_NBR)
  VALUES ('Y','T1003',1,'T1002','T1005',0)
/

-----------------------------------------------------------------------------
-- KRMS_CNTXT_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_CNTXT_T (ACTV,CNTXT_ID,DESC_TXT,NM,NMSPC_CD,TYP_ID,VER_NBR)
  VALUES ('Y','CONTEXT1','null','Context1','KR-RULE-TEST','T1003',1)
/
INSERT INTO KRMS_CNTXT_T (ACTV,CNTXT_ID,DESC_TXT,NM,NMSPC_CD,TYP_ID,VER_NBR)
  VALUES ('Y','CONTEXT_NO_PERMISSION','null','Context with no premissions','KRMS_TEST_VOID','T1003',1)
/
INSERT INTO KRMS_CNTXT_T (ACTV,CNTXT_ID,DESC_TXT,NM,NMSPC_CD,TYP_ID,VER_NBR)
  VALUES ('Y','trav-acct-test-ctxt','null','Travel Account','KR-SAP','T4',1)
/

-----------------------------------------------------------------------------
-- KRMS_CNTXT_ATTR_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_CNTXT_ATTR_T (ATTR_DEFN_ID,ATTR_VAL,CNTXT_ATTR_ID,CNTXT_ID,VER_NBR)
  VALUES ('T1000','BLAH','T1000','CONTEXT1',1)
/

-----------------------------------------------------------------------------
-- KRMS_PROP_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('is campus bloomington','S','T1000','T1000',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('is campus bloomington','S','T1001','T1001',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('is campus bloomington','S','T1002','T1002',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('is campus bloomington','S','T1003','T1003',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('is campus bloomington','S','T1004','T1004',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('is campus bloomington','S','T1005','T1005',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('is campus bloomington','S','T1006','T1006',1)
/
INSERT INTO KRMS_PROP_T (CMPND_OP_CD,DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('&','a compound prop','C','T1007','T1007',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('a simple child to a compound prop','S','T1008','T1007',1)
/
INSERT INTO KRMS_PROP_T (CMPND_SEQ_NO,DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES (2,'2nd simple child to a compound prop ','S','T1009','T1007',1)
/
INSERT INTO KRMS_PROP_T (CMPND_SEQ_NO,DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES (3,'3nd simple child to a compound prop ','S','T1010','T1007',1)
/
INSERT INTO KRMS_PROP_T (CMPND_OP_CD,DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('&','is purchase special','C','T1011','T1008',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('is purchase order value large','S','T1012','T1008',1)
/
INSERT INTO KRMS_PROP_T (CMPND_OP_CD,DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('|','is purchased item controlled','C','T1013','T1008',1)
/
INSERT INTO KRMS_PROP_T (CMPND_OP_CD,DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('&','is it for a special event','C','T1014','T1008',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('is item purchased animal','S','T1015','T1008',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('is purchased item radioactive','S','T1016','T1008',1)
/
INSERT INTO KRMS_PROP_T (CMPND_SEQ_NO,DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES (3,'is it medicinal','S','T1017','T1008',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('charged to Kuali','S','T1018','T1008',1)
/
INSERT INTO KRMS_PROP_T (DESC_TXT,DSCRM_TYP_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('Party at Travis House','S','T1019','T1008',1)
/

-----------------------------------------------------------------------------
-- KRMS_PROP_PARM_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1002','T1000','T1000',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','BL','T1000','T1001',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1000','T1002',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1002','T1001','T1003',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','BL','T1001','T1004',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1001','T1005',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1002','T1002','T1006',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','BL','T1002','T1007',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1002','T1008',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1002','T1003','T1009',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','BL','T1003','T1010',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1003','T1011',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1002','T1004','T1012',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','BL','T1004','T1013',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1004','T1014',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1002','T1005','T1015',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','BL','T1005','T1016',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1005','T1017',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1002','T1006','T1018',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','BL','T1006','T1019',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1006','T1020',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1002','T1008','T1021',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','Muir','T1008','T1022',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1008','T1023',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1002','T1009','T1024',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','Revelle','T1009','T1025',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1009','T1026',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1002','T1010','T1027',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','Warren','T1010','T1028',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1010','T1029',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1004','T1012','T1030',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','5500.00','T1012','T1031',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','>','T1012','T1032',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1005','T1015','T1033',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','ANIMAL','T1015','T1034',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1015','T1035',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1005','T1016','T1036',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','RADIOACTIVE','T1016','T1037',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1016','T1038',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1005','T1017','T1039',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','ALCOHOL BEVERAGE','T1017','T1040',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1017','T1041',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1006','T1018','T1042',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','KUALI SLUSH FUND','T1018','T1043',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1018','T1044',3,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('T','T1007','T1019','T1045',1,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('C','Christmas Party','T1019','T1046',2,1)
/
INSERT INTO KRMS_PROP_PARM_T (PARM_TYP_CD,PARM_VAL,PROP_ID,PROP_PARM_ID,SEQ_NO,VER_NBR)
  VALUES ('O','=','T1019','T1047',3,1)
/

-----------------------------------------------------------------------------
-- KRMS_CMPND_PROP_PROPS_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1007','T1008')
/
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1007','T1009')
/
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1007','T1010')
/
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1011','T1012')
/
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1011','T1013')
/
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1011','T1014')
/
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1013','T1015')
/
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1013','T1016')
/
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1013','T1017')
/
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1014','T1018')
/
INSERT INTO KRMS_CMPND_PROP_PROPS_T (CMPND_PROP_ID,PROP_ID)
  VALUES ('T1014','T1019')
/

-----------------------------------------------------------------------------
-- KRMS_RULE_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_RULE_T (ACTV,DESC_TXT,NM,NMSPC_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('Y','stub rule lorem ipsum','Rule1','KR-RULE-TEST','T1000','T1000',1)
/
INSERT INTO KRMS_RULE_T (ACTV,DESC_TXT,NM,NMSPC_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('Y','Frog specimens bogus rule foo','Rule2','KR-RULE-TEST','T1001','T1001',1)
/
INSERT INTO KRMS_RULE_T (ACTV,DESC_TXT,NM,NMSPC_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('Y','Bloomington campus code rule','Rule3','KR-RULE-TEST','T1002','T1002',1)
/
INSERT INTO KRMS_RULE_T (ACTV,DESC_TXT,NM,NMSPC_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('Y','check for possible BBQ ingiter hazard','Rule4','KR-RULE-TEST','T1003','T1003',1)
/
INSERT INTO KRMS_RULE_T (ACTV,DESC_TXT,NM,NMSPC_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('Y','remembered to wear socks','Rule5','KR-RULE-TEST','T1004','T1004',1)
/
INSERT INTO KRMS_RULE_T (ACTV,DESC_TXT,NM,NMSPC_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('Y','good behavior at carnival','Rule6','KR-RULE-TEST','T1005','T1005',1)
/
INSERT INTO KRMS_RULE_T (ACTV,DESC_TXT,NM,NMSPC_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('Y','is KRMS in da haus','Rule7','KR-RULE-TEST','T1006','T1006',1)
/
INSERT INTO KRMS_RULE_T (ACTV,DESC_TXT,NM,NMSPC_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('Y','For testing compound props','CmpdTestRule','KR-RULE-TEST','T1007','T1007',1)
/
INSERT INTO KRMS_RULE_T (ACTV,DESC_TXT,NM,NMSPC_CD,PROP_ID,RULE_ID,VER_NBR)
  VALUES ('Y','Does PO require my approval','Going Away Party for Travis','KR-RULE-TEST','T1011','T1008',1)
/

-----------------------------------------------------------------------------
-- KRMS_ACTN_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_ACTN_T (ACTN_ID,DESC_TXT,NM,NMSPC_CD,RULE_ID,SEQ_NO,TYP_ID,VER_NBR)
  VALUES ('T1000','Action Stub for Testing','testAction','KR-RULE-TEST','T1000',1,'T1002',1)
/

-----------------------------------------------------------------------------
-- KRMS_AGENDA_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_AGENDA_T (ACTV,AGENDA_ID,CNTXT_ID,INIT_AGENDA_ITM_ID,NM,VER_NBR)
  VALUES ('Y','T1000','CONTEXT1','T1000','My Fabulous Agenda',1)
/
INSERT INTO KRMS_AGENDA_T (ACTV,AGENDA_ID,CNTXT_ID,INIT_AGENDA_ITM_ID,NM,TYP_ID,VER_NBR)
  VALUES ('Y','T1001','CONTEXT1','T1007','SimpleAgendaCompoundProp','T1004',1)
/
INSERT INTO KRMS_AGENDA_T (ACTV,AGENDA_ID,CNTXT_ID,INIT_AGENDA_ITM_ID,NM,TYP_ID,VER_NBR)
  VALUES ('Y','T1002','CONTEXT1','T1008','One Big Rule','T1004',1)
/

-----------------------------------------------------------------------------
-- KRMS_AGENDA_ITM_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_AGENDA_ITM_T (AGENDA_ID,AGENDA_ITM_ID,RULE_ID,VER_NBR)
  VALUES ('T1000','T1003','T1003',1)
/
INSERT INTO KRMS_AGENDA_ITM_T (AGENDA_ID,AGENDA_ITM_ID,RULE_ID,VER_NBR)
  VALUES ('T1000','T1004','T1004',1)
/
INSERT INTO KRMS_AGENDA_ITM_T (AGENDA_ID,AGENDA_ITM_ID,RULE_ID,VER_NBR)
  VALUES ('T1000','T1005','T1005',1)
/
INSERT INTO KRMS_AGENDA_ITM_T (AGENDA_ID,AGENDA_ITM_ID,RULE_ID,VER_NBR)
  VALUES ('T1000','T1006','T1006',1)
/
INSERT INTO KRMS_AGENDA_ITM_T (AGENDA_ID,AGENDA_ITM_ID,RULE_ID,VER_NBR)
  VALUES ('T1001','T1007','T1007',1)
/
INSERT INTO KRMS_AGENDA_ITM_T (AGENDA_ID,AGENDA_ITM_ID,RULE_ID,VER_NBR)
  VALUES ('T1002','T1008','T1008',1)
/
INSERT INTO KRMS_AGENDA_ITM_T (AGENDA_ID,AGENDA_ITM_ID,ALWAYS,RULE_ID,VER_NBR,WHEN_FALSE)
  VALUES ('T1000','T1002','T1003','T1002',1,'T1006')
/
INSERT INTO KRMS_AGENDA_ITM_T (AGENDA_ID,AGENDA_ITM_ID,ALWAYS,RULE_ID,VER_NBR)
  VALUES ('T1000','T1001','T1002','T1001',1)
/
INSERT INTO KRMS_AGENDA_ITM_T (AGENDA_ID,AGENDA_ITM_ID,ALWAYS,RULE_ID,VER_NBR,WHEN_FALSE,WHEN_TRUE)
  VALUES ('T1000','T1000','T1005','T1000',1,'T1004','T1001')
/

-----------------------------------------------------------------------------
-- KRMS_CTGRY_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_CTGRY_T (CTGRY_ID,NM,NMSPC_CD,VER_NBR)
  VALUES ('T1000','misc','KR-RULE-TEST',0)
/

-----------------------------------------------------------------------------
-- KRMS_TERM_SPEC_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_TERM_SPEC_T (ACTV,DESC_TXT,NM,NMSPC_CD,TERM_SPEC_ID,TYP,VER_NBR)
  VALUES ('Y','Size in # of students of the campus','campusSize','KR-RULE-TEST','T1000','java.lang.Integer',1)
/
INSERT INTO KRMS_TERM_SPEC_T (ACTV,DESC_TXT,NM,NMSPC_CD,TERM_SPEC_ID,TYP,VER_NBR)
  VALUES ('Y','is the principal in the organization','orgMember','KR-RULE-TEST','T1001','java.lang.Boolean',1)
/
INSERT INTO KRMS_TERM_SPEC_T (ACTV,DESC_TXT,NM,NMSPC_CD,TERM_SPEC_ID,TYP,VER_NBR)
  VALUES ('Y','null','Campus Code','KR-RULE-TEST','T1002','java.lang.String',1)
/
INSERT INTO KRMS_TERM_SPEC_T (ACTV,DESC_TXT,NM,NMSPC_CD,TERM_SPEC_ID,TYP,VER_NBR)
  VALUES ('Y','null','bogusFundTermSpec','KR-RULE-TEST','T1003','java.lang.String',1)
/
INSERT INTO KRMS_TERM_SPEC_T (ACTV,DESC_TXT,NM,NMSPC_CD,TERM_SPEC_ID,TYP,VER_NBR)
  VALUES ('Y','Purchase Order Value','PO Value','KR-RULE-TEST','T1004','java.lang.Integer',1)
/
INSERT INTO KRMS_TERM_SPEC_T (ACTV,DESC_TXT,NM,NMSPC_CD,TERM_SPEC_ID,TYP,VER_NBR)
  VALUES ('Y','Purchased Item Type','PO Item Type','KR-RULE-TEST','T1005','java.lang.String',1)
/
INSERT INTO KRMS_TERM_SPEC_T (ACTV,DESC_TXT,NM,NMSPC_CD,TERM_SPEC_ID,TYP,VER_NBR)
  VALUES ('Y','Charged To Account','Account','KR-RULE-TEST','T1006','java.lang.String',1)
/
INSERT INTO KRMS_TERM_SPEC_T (ACTV,DESC_TXT,NM,NMSPC_CD,TERM_SPEC_ID,TYP,VER_NBR)
  VALUES ('Y','Special Event','Occasion','KR-RULE-TEST','T1007','java.lang.String',1)
/
INSERT INTO KRMS_TERM_SPEC_T (ACTV,DESC_TXT,NM,NMSPC_CD,TERM_SPEC_ID,TYP,VER_NBR)
  VALUES ('Y','null','campusCode','KR-RULE-TEST','T1008','java.lang.String',1)
/

-----------------------------------------------------------------------------
-- KRMS_TERM_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_TERM_T (DESC_TXT,TERM_ID,TERM_SPEC_ID,VER_NBR)
  VALUES ('Bloomington Campus Size','T1000','T1000',1)
/
INSERT INTO KRMS_TERM_T (TERM_ID,TERM_SPEC_ID,VER_NBR)
  VALUES ('T1002','T1002',1)
/
INSERT INTO KRMS_TERM_T (DESC_TXT,TERM_ID,TERM_SPEC_ID,VER_NBR)
  VALUES ('Fund Name','T1003','T1003',1)
/
INSERT INTO KRMS_TERM_T (DESC_TXT,TERM_ID,TERM_SPEC_ID,VER_NBR)
  VALUES ('PO Value','T1004','T1004',1)
/
INSERT INTO KRMS_TERM_T (DESC_TXT,TERM_ID,TERM_SPEC_ID,VER_NBR)
  VALUES ('PO Item Type','T1005','T1005',1)
/
INSERT INTO KRMS_TERM_T (DESC_TXT,TERM_ID,TERM_SPEC_ID,VER_NBR)
  VALUES ('Account','T1006','T1006',1)
/
INSERT INTO KRMS_TERM_T (DESC_TXT,TERM_ID,TERM_SPEC_ID,VER_NBR)
  VALUES ('Occasion','T1007','T1007',1)
/

-----------------------------------------------------------------------------
-- KRMS_TERM_PARM_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_TERM_PARM_T (NM,TERM_ID,TERM_PARM_ID,VAL,VER_NBR)
  VALUES ('Campus Code','T1000','T1000','BL',1)
/

-----------------------------------------------------------------------------
-- KRMS_TERM_RSLVR_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_TERM_RSLVR_T (ACTV,NM,NMSPC_CD,OUTPUT_TERM_SPEC_ID,TERM_RSLVR_ID,TYP_ID,VER_NBR)
  VALUES ('Y','campusSizeResolver','KR-RULE-TEST','T1000','T1000','T1000',1)
/
INSERT INTO KRMS_TERM_RSLVR_T (ACTV,NM,NMSPC_CD,OUTPUT_TERM_SPEC_ID,TERM_RSLVR_ID,TYP_ID,VER_NBR)
  VALUES ('Y','orgMemberResolver','KR-RULE-TEST','T1001','T1001','T1000',1)
/

-----------------------------------------------------------------------------
-- KRMS_TERM_RSLVR_PARM_SPEC_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_TERM_RSLVR_PARM_SPEC_T (NM,TERM_RSLVR_ID,TERM_RSLVR_PARM_SPEC_ID,VER_NBR)
  VALUES ('Campus Code','T1000','T1000',1)
/
INSERT INTO KRMS_TERM_RSLVR_PARM_SPEC_T (NM,TERM_RSLVR_ID,TERM_RSLVR_PARM_SPEC_ID,VER_NBR)
  VALUES ('Org Code','T1001','T1001',1)
/
INSERT INTO KRMS_TERM_RSLVR_PARM_SPEC_T (NM,TERM_RSLVR_ID,TERM_RSLVR_PARM_SPEC_ID,VER_NBR)
  VALUES ('Principal ID','T1001','T1002',1)
/

-----------------------------------------------------------------------------
-- KRMS_CNTXT_VLD_ACTN_TYP_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_CNTXT_VLD_ACTN_TYP_T (ACTN_TYP_ID,CNTXT_ID,CNTXT_VLD_ACTN_ID,VER_NBR)
  VALUES ('T1002','CONTEXT1','T1000',1)
/
INSERT INTO KRMS_CNTXT_VLD_ACTN_TYP_T (ACTN_TYP_ID,CNTXT_ID,CNTXT_VLD_ACTN_ID,VER_NBR)
  VALUES ('1000','CONTEXT1','T1001',1)
/
INSERT INTO KRMS_CNTXT_VLD_ACTN_TYP_T (ACTN_TYP_ID,CNTXT_ID,CNTXT_VLD_ACTN_ID,VER_NBR)
  VALUES ('1001','CONTEXT1','T1002',1)
/
INSERT INTO KRMS_CNTXT_VLD_ACTN_TYP_T (ACTN_TYP_ID,CNTXT_ID,CNTXT_VLD_ACTN_ID,VER_NBR)
  VALUES ('1003','CONTEXT1','T1003',1)
/

-----------------------------------------------------------------------------
-- KRMS_CNTXT_VLD_AGENDA_TYP_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_CNTXT_VLD_AGENDA_TYP_T (AGENDA_TYP_ID,CNTXT_ID,CNTXT_VLD_AGENDA_ID,VER_NBR)
  VALUES ('T1005','CONTEXT1','T1000',1)
/

-----------------------------------------------------------------------------
-- KRMS_CNTXT_VLD_RULE_TYP_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_CNTXT_VLD_RULE_TYP_T (CNTXT_ID,CNTXT_VLD_RULE_ID,RULE_TYP_ID,VER_NBR)
  VALUES ('CONTEXT1','T1000','1002',1)
/

-----------------------------------------------------------------------------
-- KRMS_CNTXT_VLD_TERM_SPEC_T
-----------------------------------------------------------------------------
INSERT INTO KRMS_CNTXT_VLD_TERM_SPEC_T (CNTXT_ID,CNTXT_TERM_SPEC_PREREQ_ID,PREREQ,TERM_SPEC_ID)
  VALUES ('CONTEXT1','T1000','N','T1002')
/
INSERT INTO KRMS_CNTXT_VLD_TERM_SPEC_T (CNTXT_ID,CNTXT_TERM_SPEC_PREREQ_ID,PREREQ,TERM_SPEC_ID)
  VALUES ('CONTEXT1','T1001','N','T1003')
/
INSERT INTO KRMS_CNTXT_VLD_TERM_SPEC_T (CNTXT_ID,CNTXT_TERM_SPEC_PREREQ_ID,PREREQ,TERM_SPEC_ID)
  VALUES ('CONTEXT1','T1002','N','T1004')
/
INSERT INTO KRMS_CNTXT_VLD_TERM_SPEC_T (CNTXT_ID,CNTXT_TERM_SPEC_PREREQ_ID,PREREQ,TERM_SPEC_ID)
  VALUES ('CONTEXT1','T1003','N','T1005')
/
INSERT INTO KRMS_CNTXT_VLD_TERM_SPEC_T (CNTXT_ID,CNTXT_TERM_SPEC_PREREQ_ID,PREREQ,TERM_SPEC_ID)
  VALUES ('CONTEXT1','T1004','N','T1006')
/
INSERT INTO KRMS_CNTXT_VLD_TERM_SPEC_T (CNTXT_ID,CNTXT_TERM_SPEC_PREREQ_ID,PREREQ,TERM_SPEC_ID)
  VALUES ('CONTEXT1','T1005','N','T1007')
/
INSERT INTO KRMS_CNTXT_VLD_TERM_SPEC_T (CNTXT_ID,CNTXT_TERM_SPEC_PREREQ_ID,PREREQ,TERM_SPEC_ID)
  VALUES ('CONTEXT1','T1006','N','T1000')
/
INSERT INTO KRMS_CNTXT_VLD_TERM_SPEC_T (CNTXT_ID,CNTXT_TERM_SPEC_PREREQ_ID,PREREQ,TERM_SPEC_ID)
  VALUES ('CONTEXT1','T1007','N','T1001')
/
