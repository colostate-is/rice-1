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

CREATE TABLE KREW_STUCK_DOC_INCIDENT_T
  (
      STUCK_DOC_INCIDENT_ID VARCHAR2(40) NOT NULL,
      DOC_HDR_ID VARCHAR2(40) NOT NULL,
      START_DT DATE NOT NULL,
      END_DT DATE,
      STATUS VARCHAR2(20) NOT NULL,
      CONSTRAINT KREW_STUCK_DOC_INCIDENT_TP1 PRIMARY KEY(STUCK_DOC_INCIDENT_ID),
      CONSTRAINT KREW_STUCK_DOC_INCIDENT_TR1 FOREIGN KEY (DOC_HDR_ID) REFERENCES KREW_DOC_HDR_T(DOC_HDR_ID)
  )
/

CREATE SEQUENCE KREW_STUCK_DOC_INCIDENT_S INCREMENT BY 1 START WITH 1000 NOMAXVALUE NOCYCLE NOCACHE ORDER
/

CREATE TABLE KREW_STUCK_DOC_FIX_ATTMPT_T
(
      STUCK_DOC_FIX_ATTMPT_ID VARCHAR2(40) NOT NULL,
      STUCK_DOC_INCIDENT_ID VARCHAR2(40) NOT NULL,
      ATTMPT_TS DATE NOT NULL,
      CONSTRAINT KREW_STUCK_DOC_FIX_ATTMPT_TP1 PRIMARY KEY(STUCK_DOC_FIX_ATTMPT_ID),
      CONSTRAINT KREW_STUCK_DOC_FIX_ATTMPTT_TR1 FOREIGN KEY (STUCK_DOC_INCIDENT_ID) REFERENCES KREW_STUCK_DOC_INCIDENT_T(STUCK_DOC_INCIDENT_ID)
)
/

CREATE SEQUENCE KREW_STUCK_DOC_FIX_ATTMPT_S INCREMENT BY 1 START WITH 1000 NOMAXVALUE NOCYCLE NOCACHE ORDER
/
