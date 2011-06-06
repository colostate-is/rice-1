/*
 * Copyright 2006-2011 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl2.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.rice.kew.role;

import org.junit.Test;
import org.kuali.rice.core.util.AttributeSet;
import org.kuali.rice.kew.dto.ActionRequestDTO;
import org.kuali.rice.kew.dto.RouteNodeInstanceDTO;
import org.kuali.rice.kew.exception.WorkflowException;
import org.kuali.rice.kew.service.WorkflowDocument;
import org.kuali.rice.kew.service.WorkflowInfo;
import org.kuali.rice.kew.test.KEWTestCase;
import org.kuali.rice.kew.util.KEWConstants;
import org.kuali.rice.kim.api.services.KimApiServiceLocator;
import org.kuali.rice.kim.bo.Role;
import org.kuali.rice.kim.bo.entity.KimPrincipal;
import org.kuali.rice.kim.bo.impl.RoleImpl;
import org.kuali.rice.kim.bo.role.dto.KimRoleInfo;
import org.kuali.rice.kim.bo.role.dto.RoleMembershipInfo;
import org.kuali.rice.kim.bo.role.impl.KimDelegationImpl;
import org.kuali.rice.kim.bo.role.impl.KimDelegationMemberImpl;
import org.kuali.rice.kim.bo.role.impl.RoleMemberAttributeDataImpl;
import org.kuali.rice.kim.bo.role.impl.RoleMemberImpl;
import org.kuali.rice.kim.bo.role.impl.RoleResponsibilityActionImpl;
import org.kuali.rice.kim.bo.role.impl.RoleResponsibilityImpl;
import org.kuali.rice.kim.impl.common.attribute.KimAttributeBo;
import org.kuali.rice.kim.impl.responsibility.ResponsibilityAttributeBo;
import org.kuali.rice.kim.impl.responsibility.ResponsibilityBo;
import org.kuali.rice.kim.impl.responsibility.ResponsibilityTemplateBo;
import org.kuali.rice.kim.impl.type.KimTypeAttributeBo;
import org.kuali.rice.kim.impl.type.KimTypeBo;
import org.kuali.rice.kns.service.KNSServiceLocator;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

/**
 * Tests Role-based routing integration between KEW and KIM.
 *
 * @author Kuali Rice Team (rice.collab@kuali.org)
 *
 */

public class RoleRouteModuleTest extends KEWTestCase {

	private static final String NAMESPACE = KEWConstants.KEW_NAMESPACE;
	private static final String ROLE_NAME = "RoleRouteModuleTestRole";
	
	private static boolean suiteDataInitialized = false;
	private static boolean suiteCreateDelegateInitialized = false;

	protected void loadTestData() throws Exception {
        loadXmlFile("RoleRouteModuleTestConfig.xml");

        // only create this data once per suite!
        
        if (suiteDataInitialized) {
        	return;
        }
        
        /**
         * First we need to set up:
         *
         * 1) KimAttributes for both chart and org
         * 2) The KimType for "chart/org"
         * 3) The KimTypeAttributes for chart and org to define relationship between KimType and it's KimAttributes
         */

        // create "chart" KimAttribute
        Long chartAttributeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ATTR_DEFN_ID_S");
        KimAttributeBo chartAttribute = new KimAttributeBo();
        chartAttribute.setId("" + chartAttributeId);
        chartAttribute.setAttributeName("chart");
        chartAttribute.setNamespaceCode(NAMESPACE);
        chartAttribute.setAttributeLabel("chart");
        chartAttribute.setActive(true);
        chartAttribute = (KimAttributeBo) KNSServiceLocator.getBusinessObjectService().save(chartAttribute);

        // create "org" KimAttribute
        Long orgAttributeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ATTR_DEFN_ID_S");
        KimAttributeBo orgAttribute = new KimAttributeBo();
        orgAttribute.setId("" + orgAttributeId);
        orgAttribute.setAttributeName("org");
        orgAttribute.setNamespaceCode(NAMESPACE);
        orgAttribute.setAttributeLabel("org");
        orgAttribute.setActive(true);
        orgAttribute = (KimAttributeBo) KNSServiceLocator.getBusinessObjectService().save(orgAttribute);

        // create KimType
        Long kimTypeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_TYP_ID_S");
        KimTypeBo kimType = new KimTypeBo();
        kimType.setId("" + kimTypeId);
        kimType.setName("ChartOrg");
        kimType.setNamespaceCode(NAMESPACE);
        kimType.setServiceName("testBaseRoleTypeService"); // do we need to set the kim type service yet? we shall see...
        kimType.setActive(true);
        kimType = (KimTypeBo) KNSServiceLocator.getBusinessObjectService().save(kimType);

        // create chart KimTypeAttribute
        Long chartTypeAttributeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_TYP_ATTR_ID_S");
        KimTypeAttributeBo chartTypeAttribute = new KimTypeAttributeBo();
        chartTypeAttribute.setId("" + chartTypeAttributeId);
        chartTypeAttribute.setActive(true);
        chartTypeAttribute.setKimAttributeId(chartAttribute.getId());
        chartTypeAttribute.setKimTypeId(kimType.getId());
        chartTypeAttribute = (KimTypeAttributeBo) KNSServiceLocator.getBusinessObjectService().save(chartTypeAttribute);

        // create org KimTypeAttribute
        Long orgTypeAttributeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_TYP_ATTR_ID_S");
        KimTypeAttributeBo orgTypeAttribute = new KimTypeAttributeBo();
        orgTypeAttribute.setId("" + orgTypeAttributeId);
        orgTypeAttribute.setActive(true);
        orgTypeAttribute.setKimAttributeId(orgAttribute.getId());
        orgTypeAttribute.setKimTypeId(kimType.getId());
        orgTypeAttribute = (KimTypeAttributeBo) KNSServiceLocator.getBusinessObjectService().save(orgTypeAttribute);

        /**
         * New let's create the Role
         */

        String roleId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_ID_S");
        RoleImpl role = new RoleImpl();
        role.setRoleId(roleId);
        role.setNamespaceCode(NAMESPACE);
        role.setRoleDescription("");
        role.setRoleName(ROLE_NAME);
        role.setActive(true);
        role.setKimTypeId(kimType.getId());

        String roleMemberId1 = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_ID_S");
        RoleMemberImpl adminRolePrincipal = new RoleMemberImpl();
        adminRolePrincipal.setRoleMemberId(roleMemberId1);
        adminRolePrincipal.setRoleId(roleId);
        KimPrincipal adminPrincipal = KimApiServiceLocator.getIdentityManagementService().getPrincipalByPrincipalName("admin");
        assertNotNull(adminPrincipal);
        adminRolePrincipal.setMemberId(adminPrincipal.getPrincipalId());
        adminRolePrincipal.setMemberTypeCode( Role.PRINCIPAL_MEMBER_TYPE );

        String roleMemberId2 = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_ID_S");
        RoleMemberImpl user2RolePrincipal = new RoleMemberImpl();
        user2RolePrincipal.setRoleMemberId(roleMemberId2);
        user2RolePrincipal.setRoleId(roleId);
        KimPrincipal user2Principal = KimApiServiceLocator.getIdentityManagementService().getPrincipalByPrincipalName("user2");
        assertNotNull(user2Principal);
        user2RolePrincipal.setMemberId(user2Principal.getPrincipalId());
        user2RolePrincipal.setMemberTypeCode( Role.PRINCIPAL_MEMBER_TYPE );

        String roleMemberId3 = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_ID_S");
        RoleMemberImpl user1RolePrincipal = new RoleMemberImpl();
        user1RolePrincipal.setRoleMemberId(roleMemberId3);
        user1RolePrincipal.setRoleId(roleId);
        KimPrincipal user1Principal = KimApiServiceLocator.getIdentityManagementService().getPrincipalByPrincipalName("user1");
        assertNotNull(user1Principal);
        user1RolePrincipal.setMemberId(user1Principal.getPrincipalId());
        user1RolePrincipal.setMemberTypeCode( Role.PRINCIPAL_MEMBER_TYPE );

        List<RoleMemberImpl> memberPrincipals = new ArrayList<RoleMemberImpl>();
        memberPrincipals.add(adminRolePrincipal);
        memberPrincipals.add(user2RolePrincipal);
        memberPrincipals.add(user1RolePrincipal);

        role.setMembers(memberPrincipals);

        /**
         * Let's create qualifiers for chart and org for our role members
         */

        String dataId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_GRP_ATTR_DATA_ID_S");
        RoleMemberAttributeDataImpl chartDataBL = new RoleMemberAttributeDataImpl();
        chartDataBL.setId(dataId);
        chartDataBL.setAttributeValue("BL");
        chartDataBL.setKimAttribute(chartAttribute);
        chartDataBL.setKimAttributeId(chartAttribute.getId());
        chartDataBL.setKimTypeId(kimType.getId());
        chartDataBL.setAssignedToId(adminRolePrincipal.getRoleMemberId());

        dataId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_GRP_ATTR_DATA_ID_S");
        RoleMemberAttributeDataImpl chartDataBL2 = new RoleMemberAttributeDataImpl();
        chartDataBL2.setId(dataId);
        chartDataBL2.setAttributeValue("BL");
        chartDataBL2.setKimAttribute(chartAttribute);
        chartDataBL2.setKimAttributeId(chartAttribute.getId());
        chartDataBL2.setKimTypeId(kimType.getId());
        chartDataBL2.setAssignedToId(user2RolePrincipal.getRoleMemberId());

        dataId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_GRP_ATTR_DATA_ID_S");
        RoleMemberAttributeDataImpl orgDataBUS = new RoleMemberAttributeDataImpl();
        orgDataBUS.setId(dataId);
        orgDataBUS.setAttributeValue("BUS");
        orgDataBUS.setKimAttribute(orgAttribute);
        orgDataBUS.setKimAttributeId(orgAttribute.getId());
        orgDataBUS.setKimTypeId(kimType.getId());
        orgDataBUS.setAssignedToId(adminRolePrincipal.getRoleMemberId());

        dataId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_GRP_ATTR_DATA_ID_S");
        RoleMemberAttributeDataImpl orgDataBUS2 = new RoleMemberAttributeDataImpl();
        orgDataBUS2.setId(dataId);
        orgDataBUS2.setAttributeValue("BUS");
        orgDataBUS2.setKimAttribute(orgAttribute);
        orgDataBUS2.setKimAttributeId(orgAttribute.getId());
        orgDataBUS2.setKimTypeId(kimType.getId());
        orgDataBUS2.setAssignedToId(user2RolePrincipal.getRoleMemberId());


        dataId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_GRP_ATTR_DATA_ID_S");
        RoleMemberAttributeDataImpl chartDataIN = new RoleMemberAttributeDataImpl();
        chartDataIN.setId(dataId);
        chartDataIN.setAttributeValue("IN");
        chartDataIN.setKimAttribute(chartAttribute);
        chartDataIN.setKimAttributeId(chartAttribute.getId());
        chartDataIN.setKimTypeId(kimType.getId());
        chartDataIN.setAssignedToId(user1RolePrincipal.getRoleMemberId());

        dataId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_GRP_ATTR_DATA_ID_S");
        RoleMemberAttributeDataImpl orgDataMED = new RoleMemberAttributeDataImpl();
        orgDataMED.setId(dataId);
        orgDataMED.setAttributeValue("MED");
        orgDataMED.setKimAttribute(orgAttribute);
        orgDataMED.setKimAttributeId(orgAttribute.getId());
        orgDataMED.setKimTypeId(kimType.getId());
        orgDataMED.setAssignedToId(user1RolePrincipal.getRoleMemberId());

        List<RoleMemberAttributeDataImpl> user1Attributes = new ArrayList<RoleMemberAttributeDataImpl>();
        user1Attributes.add(chartDataIN);
        user1Attributes.add(orgDataMED);
        user1RolePrincipal.setAttributes(user1Attributes);

        List<RoleMemberAttributeDataImpl> user2Attributes = new ArrayList<RoleMemberAttributeDataImpl>();
        user2Attributes.add(chartDataBL2);
        user2Attributes.add(orgDataBUS2);
        user2RolePrincipal.setAttributes(user2Attributes);

        List<RoleMemberAttributeDataImpl> adminAttributes = new ArrayList<RoleMemberAttributeDataImpl>();
        adminAttributes.add(chartDataBL);
        adminAttributes.add(orgDataBUS);
        adminRolePrincipal.setAttributes(adminAttributes);


        /**
         * Now we can save the role!
         */

        role = (RoleImpl) KNSServiceLocator.getBusinessObjectService().save(role);


        /**
         * Let's set up attributes for responsibility details
         */

        // create "documentType" KimAttribute
        Long documentTypeAttributeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ATTR_DEFN_ID_S");
        KimAttributeBo documentTypeAttribute = new KimAttributeBo();
        documentTypeAttribute.setId("" + documentTypeAttributeId);
        documentTypeAttribute.setAttributeName(KEWConstants.DOCUMENT_TYPE_NAME_DETAIL);
        documentTypeAttribute.setNamespaceCode(NAMESPACE);
        documentTypeAttribute.setAttributeLabel("documentType");
        documentTypeAttribute.setActive(true);
        documentTypeAttribute = (KimAttributeBo) KNSServiceLocator.getBusinessObjectService().save(documentTypeAttribute);

        // create "node name" KimAttribute
        Long nodeNameAttributeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ATTR_DEFN_ID_S");
        KimAttributeBo nodeNameAttribute = new KimAttributeBo();
        nodeNameAttribute.setId("" + nodeNameAttributeId);
        nodeNameAttribute.setAttributeName(KEWConstants.ROUTE_NODE_NAME_DETAIL);
        nodeNameAttribute.setNamespaceCode(NAMESPACE);
        nodeNameAttribute.setAttributeLabel("nodeName");
        nodeNameAttribute.setActive(true);
        nodeNameAttribute = (KimAttributeBo) KNSServiceLocator.getBusinessObjectService().save(nodeNameAttribute);

        // create KimType for responsibility details
        Long kimRespTypeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_TYP_ID_S");
        KimTypeBo kimRespType = new KimTypeBo();
        kimRespType.setId("" + kimRespTypeId);
        kimRespType.setName("RespDetails");
        kimRespType.setNamespaceCode(NAMESPACE);
        kimRespType.setServiceName("testBaseResponsibilityTypeService");
        kimRespType.setActive(true);
        kimRespType = (KimTypeBo) KNSServiceLocator.getBusinessObjectService().save(kimRespType);

        // create document type KimTypeAttribute
        Long documentTypeTypeAttributeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_TYP_ATTR_ID_S");
        KimTypeAttributeBo documentTypeTypeAttribute = new KimTypeAttributeBo();
        documentTypeTypeAttribute.setId("" + documentTypeTypeAttributeId);
        documentTypeTypeAttribute.setActive(true);
        documentTypeTypeAttribute.setKimAttributeId(chartAttribute.getId());
        documentTypeTypeAttribute.setKimTypeId(kimType.getId());
        documentTypeTypeAttribute = (KimTypeAttributeBo) KNSServiceLocator.getBusinessObjectService().save(documentTypeTypeAttribute);

        // create nodeNameType KimTypeAttribute
        Long nodeNameTypeAttributeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_TYP_ATTR_ID_S");
        KimTypeAttributeBo nodeNameTypeAttribute = new KimTypeAttributeBo();
        nodeNameTypeAttribute.setId("" + nodeNameTypeAttributeId);
        nodeNameTypeAttribute.setActive(true);
        nodeNameTypeAttribute.setKimAttributeId(orgAttribute.getId());
        nodeNameTypeAttribute.setKimTypeId(kimType.getId());
        nodeNameTypeAttribute = (KimTypeAttributeBo) KNSServiceLocator.getBusinessObjectService().save(nodeNameTypeAttribute);

        createResponsibilityForRoleRouteModuleTest1(role, documentTypeAttribute, nodeNameAttribute, kimRespType, user1RolePrincipal, user2RolePrincipal, adminRolePrincipal);
        createResponsibilityForRoleRouteModuleTest2(role, documentTypeAttribute, nodeNameAttribute, kimRespType, user1RolePrincipal, user2RolePrincipal, adminRolePrincipal);

        suiteDataInitialized = true;
    }

	private void createResponsibilityForRoleRouteModuleTest1(RoleImpl role, KimAttributeBo documentTypeAttribute, KimAttributeBo nodeNameAttribute, KimTypeBo kimRespType, RoleMemberImpl user1RolePrincipal, RoleMemberImpl user2RolePrincipal, RoleMemberImpl adminRolePrincipal) {

		/**
         * Create the responsibility template
         */

        String templateId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_RSP_TMPL_ID_S");
    	ResponsibilityTemplateBo template = new ResponsibilityTemplateBo();
        template.setId(templateId);
        template.setNamespaceCode(NAMESPACE);
        template.setName("Review");
        template.setKimTypeId(kimRespType.getId());
        template.setActive(true);
        template.setDescription("description");

        template = (ResponsibilityTemplateBo) KNSServiceLocator.getBusinessObjectService().save(template);


        /**
         * Create the responsibility details for RoleRouteModuleTest1
         */

        String responsibilityId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_RSP_ID_S");

        String dataId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_GRP_ATTR_DATA_ID_S");
        ResponsibilityAttributeBo documentTypeDetail = new ResponsibilityAttributeBo();
        documentTypeDetail.setId(dataId);
        documentTypeDetail.setAttributeValue("RoleRouteModuleTest1");
        documentTypeDetail.setKimAttribute(documentTypeAttribute);
        documentTypeDetail.setKimAttributeId(documentTypeAttribute.getId());
        documentTypeDetail.setKimTypeId(kimRespType.getId());
        documentTypeDetail.setAssignedToId(responsibilityId);

        dataId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_GRP_ATTR_DATA_ID_S");
        ResponsibilityAttributeBo nodeNameDetail = new ResponsibilityAttributeBo();
        nodeNameDetail.setId(dataId);
        nodeNameDetail.setAttributeValue("Role1");
        nodeNameDetail.setKimAttribute(nodeNameAttribute);
        nodeNameDetail.setKimAttributeId(nodeNameAttribute.getId());
        nodeNameDetail.setKimTypeId(kimRespType.getId());
        nodeNameDetail.setAssignedToId(responsibilityId);



        /**
         * Create the responsibility
         */

        List<ResponsibilityAttributeBo> detailObjects = new ArrayList<ResponsibilityAttributeBo>();
        detailObjects.add(documentTypeDetail);
        detailObjects.add(nodeNameDetail);

        ResponsibilityBo responsibility = new ResponsibilityBo();
        responsibility.setActive(true);
        responsibility.setDescription("resp1");
        responsibility.setAttributeDetails(detailObjects);
        responsibility.setName("VoluntaryReview");
        responsibility.setNamespaceCode(NAMESPACE);
        responsibility.setId(responsibilityId);
        responsibility.setTemplate(template);
        responsibility.setTemplateId(template.getId());

        responsibility = (ResponsibilityBo) KNSServiceLocator.getBusinessObjectService().save(responsibility);

        /**
         * Create the RoleResponsibility
         */

        String roleResponsibilityId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_RSP_ID_S");
        RoleResponsibilityImpl roleResponsibility = new RoleResponsibilityImpl();
        roleResponsibility.setRoleResponsibilityId(roleResponsibilityId);
        roleResponsibility.setActive(true);
        roleResponsibility.setResponsibilityId(responsibilityId);
        roleResponsibility.setRoleId(role.getRoleId());

        roleResponsibility = (RoleResponsibilityImpl) KNSServiceLocator.getBusinessObjectService().save(roleResponsibility);

        /**
         * Create the various responsibility actions
         */
        String roleResponsibilityActionId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_RSP_ACTN_ID_S");
        RoleResponsibilityActionImpl roleResponsibilityAction1 = new RoleResponsibilityActionImpl();
        roleResponsibilityAction1.setRoleResponsibilityActionId(roleResponsibilityActionId);
        roleResponsibilityAction1.setRoleResponsibilityId(roleResponsibilityId);
        roleResponsibilityAction1.setRoleMemberId(user1RolePrincipal.getRoleMemberId());
        roleResponsibilityAction1.setActionTypeCode(KEWConstants.ACTION_REQUEST_APPROVE_REQ);
        roleResponsibilityAction1.setActionPolicyCode(KEWConstants.APPROVE_POLICY_FIRST_APPROVE);
        roleResponsibilityAction1.setPriorityNumber(1);
        roleResponsibilityAction1 = (RoleResponsibilityActionImpl) KNSServiceLocator.getBusinessObjectService().save(roleResponsibilityAction1);

        roleResponsibilityActionId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_RSP_ACTN_ID_S");
        RoleResponsibilityActionImpl roleResponsibilityAction2 = new RoleResponsibilityActionImpl();
        roleResponsibilityAction2.setRoleResponsibilityActionId(roleResponsibilityActionId);
        roleResponsibilityAction2.setRoleResponsibilityId(roleResponsibilityId);
        roleResponsibilityAction2.setRoleMemberId(user2RolePrincipal.getRoleMemberId());
        roleResponsibilityAction2.setActionTypeCode(KEWConstants.ACTION_REQUEST_APPROVE_REQ);
        roleResponsibilityAction2.setActionPolicyCode(KEWConstants.APPROVE_POLICY_FIRST_APPROVE);
        roleResponsibilityAction2.setPriorityNumber(1);
        roleResponsibilityAction2 = (RoleResponsibilityActionImpl) KNSServiceLocator.getBusinessObjectService().save(roleResponsibilityAction2);

        roleResponsibilityActionId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_RSP_ACTN_ID_S");
        RoleResponsibilityActionImpl roleResponsibilityAction3 = new RoleResponsibilityActionImpl();
        roleResponsibilityAction3.setRoleResponsibilityActionId(roleResponsibilityActionId);
        roleResponsibilityAction3.setRoleResponsibilityId(roleResponsibilityId);
        roleResponsibilityAction3.setRoleMemberId(adminRolePrincipal.getRoleMemberId());
        roleResponsibilityAction3.setActionTypeCode(KEWConstants.ACTION_REQUEST_APPROVE_REQ);
        roleResponsibilityAction3.setActionPolicyCode(KEWConstants.APPROVE_POLICY_FIRST_APPROVE);
        roleResponsibilityAction3.setPriorityNumber(1);
        roleResponsibilityAction3 = (RoleResponsibilityActionImpl) KNSServiceLocator.getBusinessObjectService().save(roleResponsibilityAction3);

	}

	private void createResponsibilityForRoleRouteModuleTest2(RoleImpl role, KimAttributeBo documentTypeAttribute, KimAttributeBo nodeNameAttribute, KimTypeBo kimRespType, RoleMemberImpl user1RolePrincipal, RoleMemberImpl user2RolePrincipal, RoleMemberImpl adminRolePrincipal) {

		/**
         * Create the responsibility template
         */

        String templateId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_RSP_TMPL_ID_S");
    	ResponsibilityTemplateBo template = new ResponsibilityTemplateBo();
        template.setId(templateId);
        template.setNamespaceCode(NAMESPACE);
        template.setName("AllApproveReview");
        template.setKimTypeId(kimRespType.getId());
        template.setActive(true);
        template.setDescription("description");

        template = (ResponsibilityTemplateBo) KNSServiceLocator.getBusinessObjectService().save(template);

        /**
         * Create the responsibility details for RoleRouteModuleTest2
         */

        String responsibilityId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_RSP_ID_S");

        String dataId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_GRP_ATTR_DATA_ID_S");
        ResponsibilityAttributeBo documentTypeDetail = new ResponsibilityAttributeBo();
        documentTypeDetail.setId(dataId);
        documentTypeDetail.setAttributeValue("RoleRouteModuleTest2");
        documentTypeDetail.setKimAttribute(documentTypeAttribute);
        documentTypeDetail.setKimAttributeId(documentTypeAttribute.getId());
        documentTypeDetail.setKimTypeId(kimRespType.getId());
        documentTypeDetail.setAssignedToId(responsibilityId);

        dataId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_GRP_ATTR_DATA_ID_S");
        ResponsibilityAttributeBo nodeNameDetail = new ResponsibilityAttributeBo();
        nodeNameDetail.setId(dataId);
        nodeNameDetail.setAttributeValue("Role1");
        nodeNameDetail.setKimAttribute(nodeNameAttribute);
        nodeNameDetail.setKimAttributeId(nodeNameAttribute.getId());
        nodeNameDetail.setKimTypeId(kimRespType.getId());
        nodeNameDetail.setAssignedToId(responsibilityId);



        /**
         * Create the responsibility
         */

        List<ResponsibilityAttributeBo> detailObjects = new ArrayList<ResponsibilityAttributeBo>();
        detailObjects.add(documentTypeDetail);
        detailObjects.add(nodeNameDetail);

        ResponsibilityBo responsibility = new ResponsibilityBo();
        responsibility.setActive(true);
        responsibility.setDescription("resp2");
        responsibility.setAttributeDetails(detailObjects);
        responsibility.setName("VoluntaryReview");
        responsibility.setNamespaceCode(NAMESPACE);
        responsibility.setId(responsibilityId);
        responsibility.setTemplate(template);
        responsibility.setTemplateId(template.getId());

        responsibility = (ResponsibilityBo) KNSServiceLocator.getBusinessObjectService().save(responsibility);

        /**
         * Create the RoleResponsibility
         */

        String roleResponsibilityId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_RSP_ID_S");
        RoleResponsibilityImpl roleResponsibility = new RoleResponsibilityImpl();
        roleResponsibility.setRoleResponsibilityId(roleResponsibilityId);
        roleResponsibility.setActive(true);
        roleResponsibility.setResponsibilityId(responsibilityId);
        roleResponsibility.setRoleId(role.getRoleId());

        roleResponsibility = (RoleResponsibilityImpl) KNSServiceLocator.getBusinessObjectService().save(roleResponsibility);

        /**
         * Create the various responsibility actions
         */
        String roleResponsibilityActionId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_RSP_ACTN_ID_S");
        RoleResponsibilityActionImpl roleResponsibilityAction1 = new RoleResponsibilityActionImpl();
        roleResponsibilityAction1.setRoleResponsibilityActionId(roleResponsibilityActionId);
        roleResponsibilityAction1.setRoleResponsibilityId(roleResponsibilityId);
        roleResponsibilityAction1.setRoleMemberId(user1RolePrincipal.getRoleMemberId());
        roleResponsibilityAction1.setActionTypeCode(KEWConstants.ACTION_REQUEST_APPROVE_REQ);
        roleResponsibilityAction1.setActionPolicyCode(KEWConstants.APPROVE_POLICY_ALL_APPROVE);
        roleResponsibilityAction1.setPriorityNumber(1);
        roleResponsibilityAction1 = (RoleResponsibilityActionImpl) KNSServiceLocator.getBusinessObjectService().save(roleResponsibilityAction1);

        roleResponsibilityActionId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_RSP_ACTN_ID_S");
        RoleResponsibilityActionImpl roleResponsibilityAction2 = new RoleResponsibilityActionImpl();
        roleResponsibilityAction2.setRoleResponsibilityActionId(roleResponsibilityActionId);
        roleResponsibilityAction2.setRoleResponsibilityId(roleResponsibilityId);
        roleResponsibilityAction2.setRoleMemberId(user2RolePrincipal.getRoleMemberId());
        roleResponsibilityAction2.setActionTypeCode(KEWConstants.ACTION_REQUEST_APPROVE_REQ);
        roleResponsibilityAction2.setActionPolicyCode(KEWConstants.APPROVE_POLICY_ALL_APPROVE);
        roleResponsibilityAction2.setPriorityNumber(1);
        roleResponsibilityAction2 = (RoleResponsibilityActionImpl) KNSServiceLocator.getBusinessObjectService().save(roleResponsibilityAction2);

        roleResponsibilityActionId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_ROLE_RSP_ACTN_ID_S");
        RoleResponsibilityActionImpl roleResponsibilityAction3 = new RoleResponsibilityActionImpl();
        roleResponsibilityAction3.setRoleResponsibilityActionId(roleResponsibilityActionId);
        roleResponsibilityAction3.setRoleResponsibilityId(roleResponsibilityId);
        roleResponsibilityAction3.setRoleMemberId(adminRolePrincipal.getRoleMemberId());
        roleResponsibilityAction3.setActionTypeCode(KEWConstants.ACTION_REQUEST_APPROVE_REQ);
        roleResponsibilityAction3.setActionPolicyCode(KEWConstants.APPROVE_POLICY_ALL_APPROVE);
        roleResponsibilityAction3.setPriorityNumber(1);
        roleResponsibilityAction3 = (RoleResponsibilityActionImpl) KNSServiceLocator.getBusinessObjectService().save(roleResponsibilityAction3);
	}

	private void createDelegate(){

		if (suiteCreateDelegateInitialized) {
			return;
		}

		// create delegation KimType
        Long kimDlgnTypeId = KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_TYP_ID_S");
        KimTypeBo kimDlgnType = new KimTypeBo();
        kimDlgnType.setId("" + kimDlgnTypeId);
        kimDlgnType.setName("TestBaseDelegationType");
        kimDlgnType.setNamespaceCode(NAMESPACE);
        kimDlgnType.setServiceName("testBaseDelegationTypeService");
        kimDlgnType.setActive(true);
        kimDlgnType = (KimTypeBo) KNSServiceLocator.getBusinessObjectService().save(kimDlgnType);

		/*
		 * Manually create a delegate
		 */
		String id = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_DLGN_MBR_ID_S");
		KimDelegationImpl delegate = new KimDelegationImpl();

		delegate.setDelegationId(id);
		delegate.setDelegationTypeCode(KEWConstants.DELEGATION_PRIMARY);
		delegate.setActive(true);
		delegate.setKimTypeId("" + kimDlgnTypeId);
		/*
		 * Assign it a role that was created above.  This should mean that every
		 * principle in the role can have the delegate added below as a delegate
		 */
		KimRoleInfo role = KimApiServiceLocator.getRoleService().getRoleByName(NAMESPACE, ROLE_NAME);
		assertNotNull("Role should exist.", role);
		delegate.setRoleId(role.getRoleId());
		delegate = (KimDelegationImpl) KNSServiceLocator.getBusinessObjectService().save(delegate);

		// BC of the way the jpa is handled we have to create the delagate, then the members
		String delgMemberId = "" + KNSServiceLocator.getSequenceAccessorService().getNextAvailableSequenceNumber("KRIM_DLGN_MBR_ID_S");
	    KimDelegationMemberImpl user1RoleDelegate = new KimDelegationMemberImpl();
	    user1RoleDelegate.setDelegationMemberId(delgMemberId);
	    // This is the user the delegation requests should be sent to.
	    KimPrincipal kPrincipal = KimApiServiceLocator.getIdentityManagementService().getPrincipalByPrincipalName("ewestfal");
	    assertNotNull(kPrincipal);
	    user1RoleDelegate.setMemberId(kPrincipal.getPrincipalId());
	    /*
	     * this is checked when adding delegates in both the ActionRequestFactory
	     * and RoleServiceImpl
	     */
	    user1RoleDelegate.setMemberTypeCode( Role.PRINCIPAL_MEMBER_TYPE );

	    // attach it to the delegate we created above
	    user1RoleDelegate.setDelegationId(delegate.getDelegationId());

	    user1RoleDelegate = (KimDelegationMemberImpl) KNSServiceLocator.getBusinessObjectService().save(user1RoleDelegate);

	    suiteCreateDelegateInitialized = true;
	    
	}


	@Test
	public void testRoleRouteModule_FirstApprove() throws Exception {
		
		WorkflowDocument document = WorkflowDocument.createDocument(getPrincipalIdForName("ewestfal"), "RoleRouteModuleTest1");
		document.routeDocument("");

		// in this case we should have a first approve role that contains admin and user2, we
		// should also have a first approve role that contains just user1

		document = WorkflowDocument.loadDocument(getPrincipalIdForName("admin"), document.getDocumentId());
		assertTrue("Approval should be requested.", document.isApprovalRequested());
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("user1"), document.getDocumentId());
		assertTrue("Approval should be requested.", document.isApprovalRequested());
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("user2"), document.getDocumentId());
		assertTrue("Approval should be requested.", document.isApprovalRequested());

		// examine the action requests
		ActionRequestDTO[] actionRequests = new WorkflowInfo().getActionRequests(document.getDocumentId());
		// there should be 2 root action requests returned here, 1 containing the 2 requests for "BL", and one containing the request for "IN"
		assertEquals("Should have 3 action requests.", 3, actionRequests.length);
		int numRoots = 0;
		for (ActionRequestDTO actionRequest : actionRequests) {
			// each of these should be "first approve"
			if (actionRequest.getApprovePolicy() != null) {
				assertEquals(KEWConstants.APPROVE_POLICY_FIRST_APPROVE, actionRequest.getApprovePolicy());
			}
			if (actionRequest.getParentActionRequestId() == null) {
				numRoots++;
			}
		}
		assertEquals("There should have been 3 root requests.", 3, numRoots);

		// let's approve as "user1" and verify the document is still ENROUTE
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("user1"), document.getDocumentId());
		document.approve("");
		assertTrue("Document should be ENROUTE.", document.stateIsEnroute());

		// verify that admin and user2 still have requests
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("admin"), document.getDocumentId());
		assertTrue("Approval should be requested.", document.isApprovalRequested());
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("user2"), document.getDocumentId());
		assertTrue("Approval should be requested.", document.isApprovalRequested());

		// let's approve as "user2" and verify the document is still ENROUTE
		document.approve("");
		assertTrue("Document should be ENROUTE.", document.stateIsEnroute());

		// let's approve as "admin" and verify the document has gone FINAL
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("admin"), document.getDocumentId());
		document.approve("");
		assertTrue("Document should be FINAL.", document.stateIsFinal());
	}

	@Test
	public void testRoleRouteModule_AllApprove() throws Exception {

		WorkflowDocument document = WorkflowDocument.createDocument(getPrincipalIdForName("ewestfal"), "RoleRouteModuleTest2");
		document.routeDocument("");

		// in this case we should have all approve roles for admin, user1 and user2

		document = WorkflowDocument.loadDocument(getPrincipalIdForName("admin"), document.getDocumentId());
		assertTrue("Approval should be requested.", document.isApprovalRequested());
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("user1"), document.getDocumentId());
		assertTrue("Approval should be requested.", document.isApprovalRequested());
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("user2"), document.getDocumentId());
		assertTrue("Approval should be requested.", document.isApprovalRequested());

		// examine the action requests
		ActionRequestDTO[] actionRequests = new WorkflowInfo().getActionRequests(document.getDocumentId());
		assertEquals("Should have 3 action requests.", 3, actionRequests.length);
		int numRoots = 0;
		for (ActionRequestDTO actionRequest : actionRequests) {
			if (actionRequest.getApprovePolicy() != null) {
				assertEquals(KEWConstants.APPROVE_POLICY_ALL_APPROVE, actionRequest.getApprovePolicy());
			}
			if (actionRequest.getParentActionRequestId() == null) {
				numRoots++;
			}
		}
		assertEquals("There should have been 3 root requests.", 3, numRoots);

		// let's approve as "user1" and verify the document does NOT go FINAL
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("user1"), document.getDocumentId());
		document.approve("");
		assertTrue("Document should still be enroute.", document.stateIsEnroute());

		// verify that admin and user2 still have requests
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("admin"), document.getDocumentId());
		assertTrue("Approval should be requested.", document.isApprovalRequested());
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("user2"), document.getDocumentId());
		assertTrue("Approval should be requested.", document.isApprovalRequested());

		// approve as "user2" and verify document is still ENROUTE
		document.approve("");
		assertTrue("Document should be ENROUTE.", document.stateIsEnroute());

		// now approve as "admin", coument should be FINAL
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("admin"), document.getDocumentId());
		document.approve("");
		assertTrue("Document should be FINAL.", document.stateIsFinal());
	}

	@Test
    public void testDelegate() throws Exception{
		this.createDelegate();
		
        WorkflowDocument document = WorkflowDocument.createDocument(getPrincipalIdForName("rkirkend"), "RoleRouteModuleTest2");
        document.routeDocument("");

        String ewestfalPrincipalId = getPrincipalIdForName("ewestfal");

        // now our fancy new delegate should have an action request
        document = WorkflowDocument.loadDocument(getPrincipalIdForName("ewestfal"), document.getDocumentId());
        assertTrue("ewestfal should be able to approve", document.isApprovalRequested());

        // let's look at the action requests
        ActionRequestDTO[] actionRequests = document.getActionRequests();

        boolean ewestfalHasRequest = false;
        boolean ewestfalHasDelegateRequest = false;
        for (ActionRequestDTO actionRequest : actionRequests) {
        	if (ewestfalPrincipalId.equals(actionRequest.getPrincipalId())) {
        		ewestfalHasRequest = true;
        		if (actionRequest.getParentActionRequestId() != null) {
        			ewestfalHasDelegateRequest = true;
        			assertEquals("Delegation type should been PRIMARY", KEWConstants.DELEGATION_PRIMARY, actionRequest.getDelegationType());
        		}
        	}
        }
        assertTrue("ewestfal should have had a request", ewestfalHasRequest);
        assertTrue("ewestfal should have had a delegate request", ewestfalHasDelegateRequest);
    }

	@Test
	public void testDelegateApproval() throws Exception{
		this.createDelegate();

		WorkflowDocument document = WorkflowDocument.createDocument(getPrincipalIdForName("rkirkend"), "RoleRouteModuleTest2");
		document.routeDocument("");

		// See if the delegate can approve the document
		document = WorkflowDocument.loadDocument(getPrincipalIdForName("ewestfal"), document.getDocumentId());
		assertTrue("ewestfal should have an approval request", document.isApprovalRequested());
		document.approve("");

		assertTrue("Document should have been approved by the delegate.", document.stateIsFinal());
	}
	
	@Test
	public void testRoleWithNoMembers() throws Exception {
		getTransactionTemplate().execute(new TransactionCallback() {
			public Object doInTransaction(TransactionStatus status) {
				
				try {
				
					// first let's clear all of the members out of our role
				
					KimRoleInfo role = KimApiServiceLocator.getRoleManagementService().getRoleByName(NAMESPACE, ROLE_NAME);
					Map<String, String> criteria = new HashMap<String, String>();
					criteria.put("roleId", role.getRoleId());
					List<RoleMemberImpl> roleMembers = (List<RoleMemberImpl>) KNSServiceLocator.getBusinessObjectService().findMatching(RoleMemberImpl.class, criteria);
					assertFalse("role member list should not currently be empty", roleMembers.isEmpty());
					for (RoleMemberImpl roleMember : roleMembers) {
						//String roleMemberId = roleMember.getRoleMemberId();
						//RoleMemberImpl roleMemberImpl = KNSServiceLocatorInternal.getBusinessObjectService().findBySinglePrimaryKey(RoleMemberImpl.class, roleMemberId);
						assertNotNull("Role Member should exist.", roleMember);
						KNSServiceLocator.getBusinessObjectService().delete(roleMember);
					}
				
					List<RoleMembershipInfo> roleMemberInfos = KimApiServiceLocator.getRoleService().getRoleMembers(Collections.singletonList(role.getRoleId()), new AttributeSet());
					assertEquals("role member list should be empty now", 0, roleMemberInfos.size());
				
					// now that we've removed all members from the Role, let's trying routing the doc!
					WorkflowDocument document = WorkflowDocument.createDocument(getPrincipalIdForName("ewestfal"), "RoleRouteModuleTest1");
					document.routeDocument("");
					
					// the document should be final now, because the role has no members so all nodes should have been skipped for routing purposes
					
					assertTrue("document should now be in final status", document.stateIsFinal());
					
					// verify that the document went through the appropriate route path
					
					RouteNodeInstanceDTO[] routeNodeInstances = document.getRouteNodeInstances();
					assertEquals("Document should have 2 route node instances", 2, routeNodeInstances.length);
					
					return null;
				} catch (WorkflowException e) {
					throw new RuntimeException(e);
				} finally {
					status.setRollbackOnly();
				}
			}
		});
		
	}

}
