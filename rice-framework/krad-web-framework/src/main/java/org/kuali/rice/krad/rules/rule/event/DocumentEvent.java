/**
 * Copyright 2005-2019 The Kuali Foundation
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
package org.kuali.rice.krad.rules.rule.event;

import org.kuali.rice.krad.document.Document;

/**
 * Parent interface of all document-related events, which are used to drive the business rules evaluation process.
 *
 * @author Kuali Rice Team (rice.collab@kuali.org)
 */
public interface DocumentEvent extends RuleEvent {

    /**
     * @return Document The document associated with this event
     */
    Document getDocument();
}
