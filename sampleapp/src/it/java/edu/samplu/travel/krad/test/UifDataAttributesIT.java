/*
 * Copyright 2006-2012 The Kuali Foundation
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
package edu.samplu.travel.krad.test;

import com.thoughtworks.selenium.DefaultSelenium;
import com.thoughtworks.selenium.Selenium;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.logging.Log;
import org.junit.After;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

/**
 *  Tests that the data attributes are rendered as expected for all controls and widgets
 * 
 * @author Kuali Rice Team (rice.collab@kuali.org)
 */
public class UifDataAttributesIT {
    private Selenium selenium;
    private  Log log = LogFactory.getLog(getClass());

    @Before
    public void setUp() throws Exception {
        selenium = new DefaultSelenium("localhost", 4444, "*firefox", System.getProperty("remote.public.url"));
        selenium.start();
    }

    /*@Test
    @Ignore("test was created in the process of clarifying implementation details")*/
    /**
     * Tests that the data attributes are rendered as expected for all controls
     */
    public void testDataAttributesPresent() throws Exception {

        selenium.open(System.getProperty("remote.public.url"));
        assertEquals("Login", selenium.getTitle());
        selenium.type("__login_user", "admin");
        selenium.click("//input[@value='Login']");
        selenium.waitForPageToLoad("50000");
        assertEquals("Kuali Portal Index", selenium.getTitle());
        selenium.open(
                "/kr-dev/kr-krad/data-attributes-test-uif-controller?viewId=dataAttributesView_selenium&methodToCall=start");
        selenium.waitForPageToLoad("50000");

        //create a map that will specify in which html tag to look for simple attributes
        Map<String, String[]> tagAndElements = new HashMap<String, String[]>();
        // elements whose simple attributes are set in the wrapping div
        String[] divWrappedElements = {"textInputField", "textAreaInputField", "datePicker", "checkBox", "radioButton", "fileUpload"};
        // elements whose simple attributes are set in an anchor tag
        String[] anchorElements = {"navigationLink", "actionLink-noImage", "actionLink-imageRight", "actionLink-imageLeft", "linkField"};
        // elements whose simple attributes are set in an img tag
        String[] imgElements = {"imageField"};
        // elements whose simple attributes are set in button tag
        String[] buttonElements = {"buttonImageOnly", "buttonImageBottom", "buttonImageLeft", "buttonImageTop", "buttonImageRight"};
        // elements whose simple attributes are set in an input tag
        String[] inputElements = {"imageAction"};
        // elements whose simple attributes are set in a span tag
        String[] spanElements = {"messageField"};
        
        tagAndElements.put("div", divWrappedElements);
        tagAndElements.put("a", anchorElements);
        tagAndElements.put("img", imgElements);
        tagAndElements.put("button", buttonElements);
        tagAndElements.put("input", inputElements);
        tagAndElements.put("span", spanElements);

        // a map to hold the tags where the simple attributes are affixed
        // if a tag is not here, a empty string will be used for the suffix
        Map<String, String> simpleTagIdSuffix = new HashMap<String, String>();
        simpleTagIdSuffix.put("a", "_link");
        simpleTagIdSuffix.put("button", "_button");
        simpleTagIdSuffix.put("span", "_span");


        for (String tag: tagAndElements.keySet()) {
            String[] elementIds = tagAndElements.get(tag);
            for (int i=0; i<elementIds.length; i++) {
                String tagId = elementIds[i];
                // String controlId = beanIds[i] + UifConstants.IdSuffixes.CONTROL;
                // check for complex attributes
                assertTrue(tagId + ": script does not contain expected code", verifyComplexAttributes(tagId, ""));

                // check for simple attributes
                // determine whether we are using a tag id suffix for the simple attributes
                String tagIdSuffix = "";
                if (simpleTagIdSuffix.containsKey(tag)) {
                    tagIdSuffix = simpleTagIdSuffix.get(tag);
                    // link field has no suffix
                    if (tagId.equalsIgnoreCase("linkField")) {
                        tagIdSuffix = "";
                    }
                }
                verifySimpleAttributes(tag, tagId, tagIdSuffix);
            }
        }
    }

    /**
     * verify that a tag has simple data attributes
     * @param tag - html tag e.g. img or a
     * @param tagId - derived from the bean id set in the view
     * @param tagIdSuffix - where applicable, a suffix that is appended to the control by krad e.g. _control
     */
    private void verifySimpleAttributes(String tag, String tagId, String tagIdSuffix) {
        // test the attributes that are set via the data attributes list
        tagId = tagId + tagIdSuffix;
        String simpleAttributesXpath="//" + tag + "[(@id='" + tagId + "') and (@data-iconTemplateName='cool-icon-%s.png') and (@data-transitions='3')]";
        assertTrue(tagId + " does not have simple data attributes (via list) present", selenium.isElementPresent(simpleAttributesXpath));

        // test the attributes that are set via the data*Attribute properties
        simpleAttributesXpath="//" + tag + "[(@id='" + tagId + "')"
                + " and (@data-role='role') and (@data-type='type') and (@data-meta='meta')]";
        assertTrue(tagId + " does not have simple data attributes (via data*Attribute) properties present",
                selenium.isElementPresent(simpleAttributesXpath));
    }

    /**
     * check that complex attributes exist in the script
     * @param tagId - the expected tag id
     * @param suffix - the expected suffix e.g. _button
     */
    private boolean verifyComplexAttributes(String tagId, String suffix) {
        tagId = tagId + suffix;
        String complexAttributesXpath="//input[(@type='hidden') and (@data-for='"+ tagId +  "')]";
        assertTrue(tagId + ": complex data attributes script not found", selenium.isElementPresent(complexAttributesXpath));

        // the message field does not support complex attributes
        //if (!tagId.equalsIgnoreCase("messageField")) {
            String scriptValue = selenium.getAttribute(complexAttributesXpath + "@value");
            assertNotNull("script value is null",scriptValue);
            // log.info("scriptValue for " + divId + " is " + scriptValue);
            return scriptValue.contains("jQuery('#" + tagId + "').data('capitals', {kenya:'nairobi', uganda:'kampala', tanzania:'dar'});")
                    && scriptValue.contains("jQuery('#" + tagId + "').data('intervals', {short:2, medium:5, long:13});");
        //}
    }

    /**
     * check that all attributes exist in the script
     * @param tagId - the expected tag id
     * @param suffix - the expected suffix e.g. _control
     * @return true if all attributes were found in script, false otherwise
     */
    private boolean verifyAllAttributesInScript(String tagId, String suffix) {
        tagId = tagId + suffix;
        String complexAttributesXpath="//input[(@type='hidden') and (@data-for='"+ tagId +  "')]";
        assertTrue(tagId + ": complex data attributes script not found", selenium.isElementPresent(complexAttributesXpath));

        // the message field does not support complex attributes
        String scriptValue = selenium.getAttribute(complexAttributesXpath + "@value");
        assertNotNull("script value is null",scriptValue);
        // log.info("scriptValue for " + tagId + " is " + scriptValue);
        return scriptValue.contains("jQuery('#" + tagId + "').data('transitions', 3);") &&
                scriptValue.contains("jQuery('#" + tagId + "').data('iconTemplateName', 'cool-icon-%s.png');") &&
                scriptValue.contains("jQuery('#" + tagId + "').data('capitals', {kenya:'nairobi', uganda:'kampala', tanzania:'dar'});") &&
                scriptValue.contains("jQuery('#" + tagId + "').data('intervals', {short:2, medium:5, long:13});");
    }


    /**
     * Tests that the data attributes are rendered as expected for all controls
     */
    @Test
    public void testDataAttributesPresentInControls () {
        selenium.open(System.getProperty("remote.public.url"));
        assertEquals("Login", selenium.getTitle());
        selenium.type("__login_user", "admin");
        selenium.click("//input[@value='Login']");
        selenium.waitForPageToLoad("50000");
        assertEquals("Kuali Portal Index", selenium.getTitle());
        selenium.open(
                "/kr-dev/kr-krad/data-attributes-test-uif-controller?viewId=dataAttributesView_selenium&methodToCall=start");
        selenium.waitForPageToLoad("50000");
        // input fields, whose controls are implemented as spring form tags, will have both simple and complex attributes set via a script
        String[] inputControls = {"textInputField", "textAreaInputField", "dropDown", "datePicker", "fileUpload", "userControl", "spinnerControl"};//"checkBox", "radioButton",
        for (int i=0; i<inputControls.length; i++) {
            assertTrue(inputControls[i] + ": script does not contain expected code", verifyAllAttributesInScript(inputControls[i], "_attrs_control"));
        }
        // these controls allow for simple attributes on the tag and complex attributes via js
        Map<String, String[]> otherControlsMap = new HashMap<String, String[]>();
        // elements whose simple attributes are set in an img tag
        String[] imgControls = {"imageField_attrs_control"};
        // elements whose simple attributes are set in an anchor tag
        String[] anchorFields = {"navigationLink", "actionLink-noImage", "actionLink-imageRight", "actionLink-imageLeft", "linkField"};

        otherControlsMap.put("img", imgControls);
        otherControlsMap.put("a", anchorFields);

        // a map to hold the tags where the simple attributes are affixed
        // if a tag is not here, a empty string will be used for the suffix
        Map<String, String> simpleTagIdSuffix = new HashMap<String, String>();
        simpleTagIdSuffix.put("a", "_attrs");
        simpleTagIdSuffix.put("button", "_button");
        simpleTagIdSuffix.put("span", "_span");

        for (String tag: otherControlsMap.keySet()) {
            String[] controlIds = otherControlsMap.get(tag);
            for (int i=0; i<controlIds.length; i++) {
                String tagId = controlIds[i];

                // determine whether we are using a tag id suffix for the simple attributes
                String tagIdSuffix = "";
                if (simpleTagIdSuffix.containsKey(tag)) {
                    tagIdSuffix = simpleTagIdSuffix.get(tag);
                    // link field has no suffix
                    /*if (tagId.equalsIgnoreCase("linkField")) {
                        tagIdSuffix = "";
                    }*/
                }
                // check for complex attributes
                assertTrue(tagId + ": script does not contain expected code", verifyComplexAttributes(tagId, tagIdSuffix));

                // check for simple attributes
                verifySimpleAttributes(tag, tagId, tagIdSuffix);
            }
        }
    }

    @After
    public void tearDown() throws Exception {
        selenium.stop();
    }
    

}
