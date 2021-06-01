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
package org.kuali.rice.core.api.util;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.builder.HashCodeBuilder;

import java.lang.reflect.Field;
import java.util.Calendar;

/**
 * Class of static utility methods used to aid in the generation of hashcode values and equals comparisons of objects
 * for corner cases that EqualsBuilder and HashCodeBuilder of commons-lang cannot cover.
 */
public final class EqualsAndHashCodeUtils {

    private EqualsAndHashCodeUtils(){
        throw new UnsupportedOperationException("do not call");
    }

    /**
     * This method provides an equals comparison of two objects by evaluating the results of compareTo across specified
     * internal fields of the class of the two objects being compared.
     * <p/>
     * This method should be used where evaluating equality on fields of two instances of type T using .equals() yields
     * false, but for the purposes of determining equality of the two instances of type T, should be true.  An example
     * is where a class has internal fields of type Calendar that need equality determined using only its time value
     * and not other internal fields of Calendar.
     *
     * @param o1         The first object used in an equality operation using compareTo
     * @param o2         The second object used in an equality operation using compareTo
     * @param fieldNames All field names within type T that should be determined equal or not using compareTo
     * @param <T>        Type of both o1 and o2 parameters.  Guarantees both o1 and o2 are the same reference type.
     * @return true if (o1.field.compareTo(o2.field) == 0) is true for all passed in fieldNames.  Otherwise false
     *         is returned.  False is also returned if any fields specified in fieldNames are not of type Comparable or if one
     *         (but not both) of the passed in objects are null references.
     */
    public static <T> boolean equalsUsingCompareToOnFields(T o1, T o2, String... fieldNames) {
        if (o1 == o2) {
            return true;
        }
        if (o1 == null || o2 == null) {
            return false;
        }

        boolean isEqual = true;
        Class<?> targetClass = o1.getClass();
        try {
            for (String fieldName : fieldNames) {
                Field field = targetClass.getDeclaredField(fieldName);
                field.setAccessible(true);
                Class<?> fieldClass = field.getType();

                if (ArrayUtils.contains(fieldClass.getInterfaces(), Comparable.class)) {
                    @SuppressWarnings("unchecked") Comparable<Object> c1 = (Comparable<Object>) field.get(o1);
                    @SuppressWarnings("unchecked") Comparable<Object> c2 = (Comparable<Object>) field.get(o2);
                    if (c1 == c2) {
                        continue;
                    }
                    if (c1 == null || c2 == null) {
                        isEqual = false;
                    } else {
                        isEqual = (c1.compareTo(c2) == 0);
                    }
                } else {
                    isEqual = false;
                }

                if (!isEqual) {
                    break;
                }
            }

            return isEqual;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Generates an int hashcode from all calendars passed in.  This is a convenience method for hashcode methods
     * to call if they have to generate hashcodes from fields of type Calendar when those Calendar fields
     * have equality evaluated using compareTo and not equals within the equals method of the container class.
     *
     * @param calendars
     * @return int hashcode value generated by using the long value returned from each Calendar.getTimeInMillis()
     */
    public static int hashCodeForCalendars(Calendar... calendars) {
        HashCodeBuilder hcb = new HashCodeBuilder();
        for (Calendar calendar : calendars) {
            if (calendar != null) {
                hcb.append(calendar.getTimeInMillis());
            }
        }
        return hcb.toHashCode();
    }
}
