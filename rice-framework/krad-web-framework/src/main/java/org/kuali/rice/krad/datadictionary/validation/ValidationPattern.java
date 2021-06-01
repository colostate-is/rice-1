/**
 * Copyright 2005-2018 The Kuali Foundation
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
package org.kuali.rice.krad.datadictionary.validation;

import org.kuali.rice.core.api.exception.RiceRuntimeException;
import org.kuali.rice.krad.datadictionary.exporter.ExportMap;

import java.io.Serializable;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Abstraction of the regular expressions used to validate attribute values.
 *
 * The validationPattern element defines the allowable character-level
 * or field-level values for an attribute.
 *
 * JSTL: validationPattern is a Map which is accessed using a key
 * of "validationPattern". Each entry may contain some of the keys
 * listed below.  The keys that may be present for a given attribute
 * are dependent upon the type of validationPattern.
 *
 * maxLength (String)
 * exactLength
 * type
 * allowWhitespace
 * allowUnderscore
 * allowPeriod
 * validChars
 * precision
 * scale
 * allowNegative
 *
 * The allowable keys (in addition to type) for each type are:
 * ***Type****    ***Keys***
 * alphanumeric    exactLength
 * maxLength
 * allowWhitespace
 * allowUnderscore
 * allowPeriod
 *
 * alpha           exactLength
 * maxLength
 * allowWhitespace
 *
 * anyCharacter    exactLength
 * maxLength
 * allowWhitespace
 *
 * charset         validChars
 *
 * numeric         exactLength
 * maxLength
 *
 * fixedPoint      allowNegative
 * precision
 * scale
 *
 * floatingPoint   allowNegative
 *
 * date            n/a
 * emailAddress    n/a
 * javaClass       n/a
 * month           n/a
 * phoneNumber     n/a
 * timestamp       n/a
 * year            n/a
 * zipcode         n/a
 *
 * Note: maxLength and exactLength are mutually exclusive.
 * If one is entered, the other may not be entered.
 *
 * Note:  See ApplicationResources.properties for
 * exact regex patterns.
 * e.g. validationPatternRegex.date for regex used in date validation.
 */
@Deprecated
abstract public class ValidationPattern implements Serializable {
    // TODO: UNIT TEST: compile all patterns to test

    /**
     * @return regular expression Pattern generated by the individual ValidationPattern subclass
     */
    abstract public Pattern getRegexPattern();

    /**
     * @return String version of regular expression base, suitable for modification with length-specifiers and used
     *         internally by
     *         getRegexPattern
     */
    abstract protected String getRegexString();

    /**
     * Determines if an input string matches the pattern.
     * 
     * @param input input string
     * @return true if the given String matches this pattern
     */
    public boolean matches(String input) {
        Pattern p = getRegexPattern();

        Matcher m = p.matcher(input);

        return m.matches();
    }

    /**
     * Builds an export map describing the subclass instance. 
     * @param exportKey
     * 
     * @return export map
     */
    abstract public ExportMap buildExportMap(String exportKey);

    abstract public String getValidationErrorMessageKey();

    public String[] getValidationErrorMessageParameters(String attributeLabel) {
        return new String[]{attributeLabel};
    }

    /**
     * This method throws an exception if it is not configured properly
     * @throws ValidationPatternException 
     */
    public void completeValidation() throws ValidationPatternException {
    }

    /**
     * exception thrown when a ValidationPattern is in an incorrect state.
     */
    public static class ValidationPatternException extends RiceRuntimeException {

        private static final long serialVersionUID = 2012770642382150523L;

        public ValidationPatternException(String message) {
            super(message);
        }

        public ValidationPatternException() {
            super();
        }

        public ValidationPatternException(String message, Throwable cause) {
            super(message, cause);
        }

        public ValidationPatternException(Throwable cause) {
            super(cause);
        }
    }
}
