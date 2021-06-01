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
package org.kuali.rice.krms.framework.engine;

import org.kuali.rice.krms.api.engine.ExecutionEnvironment;

/**
 * Interface for defining the execution and appliesTo of @{link ExecutionEnvironment}s for an Agenda.
 * @author Kuali Rice Team (rice.collab@kuali.org)
 */
public interface Agenda {

    /**
     * Execute with the given {@link ExecutionEnvironment}
     * @param environment {@link ExecutionEnvironment} to execute with
     */
	public void execute(ExecutionEnvironment environment);

    /**
     * Return if the Agenda applies to the given environment
     * @param environment {@link ExecutionEnvironment} to check if the Agenda applies to.
     * @return true, if this Agenda applies to the given {@link ExecutionEnvironment}
     */
	public boolean appliesTo(ExecutionEnvironment environment);
	
}
