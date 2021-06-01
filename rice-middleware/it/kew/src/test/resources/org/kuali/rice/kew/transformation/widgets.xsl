<!--

    Copyright 2005-2014 The Kuali Foundation

    Licensed under the Educational Community License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.opensource.org/licenses/ecl2.php

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="readOnly" select="/documentContent/documentState/editable != 'true'"/>
	<xsl:strip-space elements="*"/>
	<xsl:template name="widget_render">
		<xsl:param name="fieldName"/>
		<xsl:param name="renderCmd"/>
		<xsl:param name="align"/>
		<xsl:for-each select="//fieldDef[@name=$fieldName]">
			<xsl:choose>
				<xsl:when test="position() != 1">
					<h4>
						<font color="#FF0000"> fieldDef Name:  <xsl:value-of select="$fieldName"/> is  duplicated ! </font>
					</h4>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="input_type" select="display/type"/>
					<xsl:variable name="render">
						<xsl:choose>
							<xsl:when test="$renderCmd">
								<xsl:value-of select="$renderCmd"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'all'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="vAlign">
						<xsl:choose>
							<xsl:when test="$align">
								<xsl:value-of select="$align"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'horizontal'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:comment> For JavaScript validation</xsl:comment>
					<xsl:variable name="fieldDisplayName">
						<xsl:choose>
							<xsl:when test="@title">
								<xsl:value-of select="@title"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@name"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="regex" select="validation/regex"/>
					<xsl:variable name="validation_required" select="validation/@required = 'true'"/>
					<xsl:variable name="message">
						<!-- <xsl:if test="//edlContent/data/version[@current='true']/field[@name=current()/@name]"> -->
						<xsl:choose>
							<xsl:when test="//edlContent/data/version[@current='true']/field[@name=current()/@name]/errorMessage">
								<xsl:value-of select="//edlContent/data/version[@current='true']/field[@name=current()/@name]/errorMessage"/>
							</xsl:when>
							<xsl:when test="validation/message">
								<xsl:value-of select="validation/message"/>
							</xsl:when>
							<xsl:when test="validation/regex">
								<xsl:value-of select="$fieldDisplayName"/>
                    				(<xsl:value-of select="@name"/>)
                    				<xsl:text> does not match '</xsl:text>
								<xsl:value-of select="$regex"/>
								<xsl:text>'</xsl:text>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
						<!-- </xsl:if> -->
					</xsl:variable>
					<xsl:variable name="custommessage">
						<xsl:choose>
							<xsl:when test="//edlContent/data/version[@current='true']/field[@name=current()/@name]/errorMessage">
								<xsl:value-of select="//edlContent/data/version[@current='true']/field[@name=current()/@name]/errorMessage"/>
							</xsl:when>
							<xsl:otherwise>NONE</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:comment>
              		custom message: <xsl:value-of select="$custommessage"/>
              		validation/message: <xsl:value-of select="validation/message"/>
              		 message: <xsl:value-of select="$message"/>
					</xsl:comment>
					<xsl:variable name="invalid" select="//edlContent/data/version[@current='true']/field[@name=current()/@name]/@invalid"/>
					<!-- determine value to display: use the value specified in the current version
               		if it exists, otherwise use the 'default' value defined in the field -->
					<xsl:variable name="userValue" select="//edlContent/data/version[@current='true']/field[@name=current()/@name]/value"/>
					<xsl:variable name="hasUserValue" select="boolean($userValue)"/>
					<xsl:variable name="value">
						<xsl:choose>
							<xsl:when test="$hasUserValue">
								<xsl:value-of select="$userValue"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="value"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- message row -->
					<xsl:variable name="type">
						<xsl:choose>
							<xsl:when test="$invalid and $validation_required">error</xsl:when>
							<xsl:when test="$invalid and not($validation_required)">warning</xsl:when>
							<xsl:otherwise>empty</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- 
			<tr class="{$type}_messageRow" id="{@name}_messageRow" xmlns="http://www.w3.org/1999/xhtml">
				<td class="{$type}_messageHeaderCell" id="{@name}_messageHeaderCell">
					<xsl:value-of select="$type"/>
				</td>
				<td class="{$type}_messageDataCell" id="{@name}_messageDataCell">
					<span id="{@name}_message">
						<xsl:value-of select="$message"/>
					</span>
				</td>
			</tr>
			-->
					<xsl:choose>
						<xsl:when test="$input_type='text'">
							<xsl:call-template name="textbox_render">
								<xsl:with-param name="fieldName" select="$fieldName"/>
								<xsl:with-param name="renderCmd" select="$render"/>
								<xsl:with-param name="align" select="$vAlign"/>
								<xsl:with-param name="hasUserValue" select="$hasUserValue"/>
								<xsl:with-param name="value" select="$value"/>
								<xsl:with-param name="invalid" select="$invalid"/>
								<xsl:with-param name="regex" select="$regex"/>
								<xsl:with-param name="message" select="$message"/>
								<xsl:with-param name="validation_required" select="$validation_required"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$input_type='password'">
							<xsl:call-template name="textbox_render">
								<xsl:with-param name="fieldName" select="$fieldName"/>
								<xsl:with-param name="renderCmd" select="$render"/>
								<xsl:with-param name="align" select="$vAlign"/>
								<xsl:with-param name="hasUserValue" select="$hasUserValue"/>
								<xsl:with-param name="value" select="$value"/>
								<xsl:with-param name="invalid" select="$invalid"/>
								<xsl:with-param name="regex" select="$regex"/>
								<xsl:with-param name="message" select="$message"/>
								<xsl:with-param name="validation_required" select="$validation_required"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$input_type='radio'">
							<xsl:call-template name="radio_render">
								<xsl:with-param name="fieldName" select="$fieldName"/>
								<xsl:with-param name="renderCmd" select="$render"/>
								<xsl:with-param name="align" select="$vAlign"/>
								<xsl:with-param name="hasUserValue" select="$hasUserValue"/>
								<xsl:with-param name="value" select="$value"/>
								<xsl:with-param name="invalid" select="$invalid"/>
								<xsl:with-param name="regex" select="$regex"/>
								<xsl:with-param name="message" select="$message"/>
								<xsl:with-param name="validation_required" select="$validation_required"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$input_type='checkbox'">
							<xsl:call-template name="checkbox_render">
								<xsl:with-param name="fieldName" select="$fieldName"/>
								<xsl:with-param name="renderCmd" select="$render"/>
								<xsl:with-param name="align" select="$vAlign"/>
								<xsl:with-param name="hasUserValue" select="$hasUserValue"/>
								<xsl:with-param name="value" select="$value"/>
								<xsl:with-param name="invalid" select="$invalid"/>
								<xsl:with-param name="regex" select="$regex"/>
								<xsl:with-param name="message" select="$message"/>
								<xsl:with-param name="validation_required" select="$validation_required"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$input_type='select'">
							<xsl:call-template name="select_input">
								<xsl:with-param name="fieldName" select="$fieldName"/>
								<xsl:with-param name="renderCmd" select="$render"/>
								<xsl:with-param name="align" select="$vAlign"/>
								<xsl:with-param name="hasUserValue" select="$hasUserValue"/>
								<xsl:with-param name="value" select="$value"/>
								<xsl:with-param name="invalid" select="$invalid"/>
								<xsl:with-param name="regex" select="$regex"/>
								<xsl:with-param name="message" select="$message"/>
								<xsl:with-param name="validation_required" select="$validation_required"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$input_type='textarea'">
							<xsl:call-template name="textarea_input">
								<xsl:with-param name="fieldName" select="$fieldName"/>
								<xsl:with-param name="renderCmd" select="$renderCmd"/>
								<xsl:with-param name="align" select="$align"/>
								<xsl:with-param name="hasUserValue" select="$hasUserValue"/>
								<xsl:with-param name="value" select="$value"/>
								<xsl:with-param name="invalid" select="$invalid"/>
								<xsl:with-param name="regex" select="$regex"/>
								<xsl:with-param name="message" select="$message"/>
								<xsl:with-param name="validation_required" select="$validation_required"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$input_type='button'">
							<xsl:call-template name="button_input">
								<xsl:with-param name="fieldName" select="$fieldName"/>
								<xsl:with-param name="renderCmd" select="$renderCmd"/>
								<xsl:with-param name="align" select="$align"/>
								<xsl:with-param name="hasUserValue" select="$hasUserValue"/>
								<xsl:with-param name="value" select="$value"/>
								<xsl:with-param name="invalid" select="$invalid"/>
								<xsl:with-param name="regex" select="$regex"/>
								<xsl:with-param name="message" select="$message"/>
								<xsl:with-param name="validation_required" select="$validation_required"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$input_type='submit button'">
							<xsl:call-template name="submitbutton_input">
								<xsl:with-param name="fieldName" select="$fieldName"/>
								<xsl:with-param name="renderCmd" select="$renderCmd"/>
								<xsl:with-param name="align" select="$align"/>
								<xsl:with-param name="hasUserValue" select="$hasUserValue"/>
								<xsl:with-param name="value" select="$value"/>
								<xsl:with-param name="invalid" select="$invalid"/>
								<xsl:with-param name="regex" select="$regex"/>
								<xsl:with-param name="message" select="$message"/>
								<xsl:with-param name="validation_required" select="$validation_required"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$input_type='hidden field'">
							<xsl:call-template name="hidden_input">
								<xsl:with-param name="fieldName" select="$fieldName"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="$renderCmd='all' or $renderCmd='input'">
						<span id="{@name}_messageHeaderCell" class="{$type}Message">
							<xsl:value-of select="$type"/>
						</span>
						<span id="{@name}_message" class="{$type}Message">
							<xsl:value-of select="$message"/>
						</span>
						<xsl:if test="validation/regex or validation[@required='true']">
							<script type="text/javascript">
                    		// register field
                    		register("<xsl:value-of select="@name"/>","<xsl:value-of select="$fieldDisplayName"/>","<xsl:value-of select="$regex"/>","<xsl:value-of select="$message"/>","<xsl:value-of select="$validation_required"/>");
                    		// end comment
                  		</script>
						</xsl:if>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="textbox_render">
		<xsl:param name="fieldName"/>
		<xsl:param name="renderCmd"/>
		<xsl:param name="align"/>
		<xsl:param name="value"/>
		<xsl:param name="regex"/>
		<xsl:param name="message"/>
		<xsl:param name="validation_required"/>
		<xsl:if test="$renderCmd='all' or  $renderCmd='title'">
			<xsl:value-of select="current()/@title"/>
		</xsl:if>
		<xsl:if test="$renderCmd='all'">
			<xsl:if test="$align ='horizontal'">
				<xsl:text>          </xsl:text>
			</xsl:if>
			<xsl:if test="$align='vertical'">
				<br/>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$renderCmd='all' or $renderCmd='input'">
			<input value="{$value}">
				<xsl:if test="$readOnly = 'true'">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="type"><xsl:value-of select="current()/display/type"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="$fieldName"/></xsl:attribute>
				<xsl:for-each select="current()/display/meta">
					<xsl:variable name="attrName">
						<xsl:value-of select="name"/>
					</xsl:variable>
					<xsl:variable name="attrValue">
						<xsl:value-of select="value"/>
					</xsl:variable>
					<xsl:attribute name="{$attrName}"><xsl:value-of select="$attrValue"/></xsl:attribute>
				</xsl:for-each>
			</input>
		</xsl:if>
	</xsl:template>
	<xsl:template name="radio_render">
		<xsl:param name="fieldName"/>
		<xsl:param name="renderCmd"/>
		<xsl:param name="align"/>
		<xsl:param name="hasUserValue"/>
		<xsl:param name="value"/>
		<xsl:if test="$renderCmd='all' or  $renderCmd='title'">
			<xsl:value-of select="current()/@title"/>
		</xsl:if>
		<xsl:if test="$renderCmd='all'">
			<xsl:if test="$align ='horizontal'">
				<xsl:text>            </xsl:text>
			</xsl:if>
			<xsl:if test="$align='vertical'">
				<br/>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$renderCmd='all' or $renderCmd='input'">
			<xsl:for-each select="current()/display/values">
				<xsl:variable name="title">
					<xsl:choose>
						<xsl:when test="@title">
							<xsl:value-of select="@title"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@name"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="optionName">
					<xsl:value-of select="../../@name"/>
				</xsl:variable>
				<input name="{$optionName}" title="{$title}" type="{../type}" value="{.}" xmlns="http://www.w3.org/1999/xhtml">
					<xsl:if test="$readOnly = 'true'">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$hasUserValue">
							<xsl:if test="//edlContent/data/version[@current='true']/field[@name=current()/../../@name and value=current()]">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<!-- use the default if no user values are specified -->
							<xsl:if test=". = ../../value">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</input>
				<xsl:value-of select="$title"/>
				<xsl:if test="$align ='horizontal'">
					<xsl:text>           </xsl:text>
				</xsl:if>
				<xsl:if test="$align='vertical'">
					<br/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="checkbox_render">
		<xsl:param name="fieldName"/>
		<xsl:param name="renderCmd"/>
		<xsl:param name="align"/>
		<xsl:param name="hasUserValue"/>
		<xsl:param name="value"/>
		<xsl:if test="$renderCmd='all' or  $renderCmd='title'">
			<xsl:value-of select="current()/@title"/>
		</xsl:if>
		<xsl:if test="$renderCmd='all'">
			<xsl:if test="$align ='horizontal'">
				<xsl:text>          </xsl:text>
			</xsl:if>
			<xsl:if test="$align='vertical'">
				<br/>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$renderCmd='all' or $renderCmd='input'">
			<xsl:for-each select="current()/display/items">
				<xsl:variable name="name">
					<xsl:value-of select="@name"/>
				</xsl:variable>
				<xsl:variable name="checked">
					<xsl:value-of select="@checked"/>
				</xsl:variable>
				<input name="{$name}" type="{../type}" value="{.}" xmlns="http://www.w3.org/1999/xhtml">
					<xsl:if test="$readOnly = 'true'">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$hasUserValue">
							<xsl:if test="//edlContent/data/version[@current='true']/field[@name=current()/../../@name and value=current()]">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<!-- use the default if no user values are specified -->
							<xsl:if test=". = ../../value">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</input>
				<xsl:value-of select="."/>
				<xsl:if test="$align ='horizontal'">
					<xsl:text>             </xsl:text>
				</xsl:if>
				<xsl:if test="$align='vertical'">
					<br/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="select_input">
		<xsl:param name="fieldName"/>
		<xsl:param name="renderCmd"/>
		<xsl:param name="align"/>
		<xsl:param name="hasUserValue"/>
		<xsl:param name="value"/>
		<xsl:if test="$renderCmd='title' or $renderCmd='all'">
			<xsl:value-of select="current()/@title"/>
		</xsl:if>
		<xsl:if test="$renderCmd='all'">
			<xsl:choose>
				<xsl:when test="$align='horizontal'">
					<xsl:text>       </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<br/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$renderCmd='input' or $renderCmd='all'">
			<select name="{$fieldName}">
				<xsl:if test="$readOnly = 'true'">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
				<xsl:for-each select="current()/display/values">
					<xsl:variable name="title">
						<xsl:choose>
							<xsl:when test="@title">
								<xsl:value-of select="@title"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@name"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<option title="{$title}" value="{.}">
						<xsl:choose>
							<xsl:when test="$hasUserValue">
								<xsl:if test="//edlContent/data/version[@current='true']/field[@name=current()/../../@name and value=current()]">
									<!-- <xsl:if test="$value = current()"> -->
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<!-- use the default if no user values are specified -->
								<xsl:if test=". = ../../value">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test=". = ../../value">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$title"/>
					</option>
				</xsl:for-each>
			</select>
		</xsl:if>
	</xsl:template>
	<xsl:template name="textarea_input">
		<xsl:param name="fieldName"/>
		<xsl:param name="renderCmd"/>
		<xsl:param name="align"/>
		<xsl:param name="value"/>
		<xsl:param name="regex"/>
		<xsl:param name="message"/>
		<xsl:param name="validation_required"/>
		<xsl:if test="$renderCmd='title' or $renderCmd='all'">
			<xsl:value-of select="current()/@title"/>
		</xsl:if>
		<xsl:if test="$renderCmd='all'">
			<xsl:choose>
				<xsl:when test="$align='horizontal'">
					<xsl:text>       </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<br/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$renderCmd='input' or $renderCmd='all'">
			<xsl:variable name="metaCols" select="display/meta[name='cols']/value"/>
			<xsl:variable name="cols">
				<xsl:choose>
					<xsl:when test="$metaCols">
						<xsl:value-of select="$metaCols"/>
					</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="metaRows" select="display/meta[name='rows']/value"/>
			<xsl:variable name="rows">
				<xsl:choose>
					<xsl:when test="$metaRows">
						<xsl:value-of select="$metaRows"/>
					</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<textarea cols="{$cols}" name="{@name}" rows="{$rows}" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:if test="$readOnly = 'true'">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
				<!-- force a space if value is empty, or browsers (firefox)
               set the rest of the literal body content as the value
               if the tag is a short-form close tag (!) -->
				<xsl:choose>
					<xsl:when test="string-length($value) > 0">
						<xsl:value-of select="$value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>  </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</textarea>
		</xsl:if>
	</xsl:template>
	<xsl:template name="button_input">
		<xsl:param name="fieldName"/>
		<xsl:param name="renderCmd"/>
		<xsl:param name="align"/>
		<xsl:if test="$renderCmd='title' or $renderCmd='all'">
			<xsl:value-of select="current()/@title"/>
		</xsl:if>
		<xsl:if test="$renderCmd='all'">
			<xsl:choose>
				<xsl:when test="$align='horizontal'">
					<xsl:text>    </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<br/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$renderCmd='input' or $renderCmd='all'">
			<button name="{$fieldName}">
				<xsl:variable name="value" select="value"/>
				<xsl:if test="$value">
					<xsl:attribute name="value"><xsl:value-of select="$value"/></xsl:attribute>
				</xsl:if>
				<xsl:for-each select="current()/display/meta">
					<xsl:variable name="attr_name">
						<xsl:value-of select="name"/>
					</xsl:variable>
					<xsl:variable name="attr_value">
						<xsl:value-of select="value"/>
					</xsl:variable>
					<xsl:attribute name="{$attr_name}"><xsl:value-of select="$attr_value"/></xsl:attribute>
				</xsl:for-each>
				<xsl:value-of select="$value"/>
			</button>
		</xsl:if>
	</xsl:template>
	<xsl:template name="submitbutton_input">
		<xsl:param name="fieldName"/>
		<xsl:param name="renderCmd"/>
		<xsl:param name="align"/>
		<xsl:if test="$renderCmd='title' or $renderCmd='all'">
			<xsl:value-of select="current()/@title"/>
		</xsl:if>
		<xsl:if test="$renderCmd='all'">
			<xsl:choose>
				<xsl:when test="$align='horizontal'">
					<xsl:text>    </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<br/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$renderCmd='input' or $renderCmd='all'">
			<input type="submit" name="{$fieldName}">
				<xsl:variable name="value" select="value"/>
				<xsl:if test="$value">
					<xsl:attribute name="value"><xsl:value-of select="$value"/></xsl:attribute>
				</xsl:if>
				<xsl:for-each select="current()/display/meta">
					<xsl:variable name="attr_name">
						<xsl:value-of select="name"/>
					</xsl:variable>
					<xsl:variable name="attr_value">
						<xsl:value-of select="value"/>
					</xsl:variable>
					<xsl:attribute name="{$attr_name}"><xsl:value-of select="$attr_value"/></xsl:attribute>
				</xsl:for-each>
			</input>
		</xsl:if>
	</xsl:template>
	<xsl:template name="hidden_input">
		<xsl:param name="fieldName"/>
		<input type="hidden" name="{$fieldName}">
			<xsl:variable name="value" select="value"/>
			<xsl:if test="$value">
				<xsl:attribute name="value"><xsl:value-of select="$value"/></xsl:attribute>
			</xsl:if>
			<xsl:for-each select="current()/display/meta">
				<xsl:variable name="attr_name">
					<xsl:value-of select="name"/>
				</xsl:variable>
				<xsl:variable name="attr_value">
					<xsl:value-of select="value"/>
				</xsl:variable>
				<xsl:attribute name="{$attr_name}"><xsl:value-of select="$attr_value"/></xsl:attribute>
			</xsl:for-each>
		</input>
	</xsl:template>
	<xsl:template name="header">
		<table border="0" cellpadding="0" cellspacing="0" class="headertable" width="100%">
			<tr>
				<td align="left" valign="top" width="10%">
					<img alt="Workflow" height="21" hspace="5" src="images/wf-logo.gif" vspace="5" width="150"/>
				</td>
				<td align="right">
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td align="right" class="thnormal">Document Type Name:</td>
							<td class="datacell1">
								<xsl:value-of select="/documentContent/documentState/docType"/>
							</td>
						</tr>
						<tr>
							<td align="right" class="thnormal">Document Status:</td>
							<td class="datacell1" width="50">
								<xsl:value-of select="//documentState/workflowDocumentState/status"/>
							</td>
						</tr>
						<tr>
							<td align="right" class="thnormal">Create Date:</td>
							<td class="datacell1">
								<xsl:comment>[transient start]</xsl:comment>
								<xsl:value-of select="//documentState/workflowDocumentState/createDate"/>
								<xsl:comment>[transient end]</xsl:comment>
							</td>
						</tr>
						<tr>
							<td align="right" class="thnormal">Document ID:</td>
							<td class="datacell1">
								<nobr>
									<xsl:comment>[transient start]</xsl:comment>
									<xsl:value-of select="/documentContent/documentState/docId"/>
									<xsl:comment>[transient end]</xsl:comment>
								</nobr>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="htmlHead">
		<!-- whether the FIELDS can be edited -->
		<!-- <xsl:variable name="readOnly" select="/documentContent/documentState/editable != 'true'"/>-->
		<!-- whether the form can be acted upon -->
		<xsl:variable name="actionable" select="/documentContent/documentState/actionable = 'true'"/>
		<xsl:variable name="docId" select="/documentContent/documentState/docId"/>
		<xsl:variable name="def" select="/documentContent/documentState/definition"/>
		<xsl:variable name="docType" select="/documentContent/documentState/docType"/>
		<xsl:variable name="style" select="/documentContent/documentState/style"/>
		<xsl:variable name="annotatable" select="/documentContent/documentState/annotatable = 'true'"/>
		<xsl:variable name="docTitle">
			<xsl:choose>
				<xsl:when test="//edlContent/edl/@title">
					<xsl:value-of select="//edlContent/edl/@title"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//edlContent/edl/@name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="pageTitle">
			<xsl:choose>
				<xsl:when test="$readOnly = 'true'">
                					Viewing
              				</xsl:when>
				<xsl:otherwise>
                					Editing 
              				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$docTitle"/>
            						(<xsl:value-of select="$docType"/>)
          			</xsl:variable>
		<title>
			<xsl:value-of select="$pageTitle"/> document
              		</title>
		<xsl:comment>
              				  Meta data block for automation/testing
                				[var editable_value=<xsl:value-of select="//documentState/editable"/>]
                				[var annotatable_value=<xsl:value-of select="//documentState/annotatable"/>]
                				[var readonly=<xsl:value-of select="$readOnly"/>]
                				[var annotatable=<xsl:value-of select="$annotatable"/>]
             					[var annotation=<xsl:value-of select="//edlContent/data/version[@current='true']/annotation"/>]
                				[transient start]
                				[var docid=<xsl:value-of select="$docId"/>]
                				[transient end]
                				[var doctype=<xsl:value-of select="$docType"/>]
               			 	[var def=<xsl:value-of select="$def"/>]
                				[var style=<xsl:value-of select="$style"/>]
             			 </xsl:comment>
		<link href="css/screen.css" rel="stylesheet" type="text/css"/>
		<link href="css/edoclite1.css" rel="stylesheet" type="text/css"/>
		<script src="scripts/edoclite1.js" type="text/javascript"/>
	</xsl:template>
	<xsl:template name="instructions">
		<!-- <xsl:variable name="readOnly" select="/documentContent/documentState/editable != 'true'"/> -->
		<xsl:variable name="docType" select="/documentContent/documentState/docType"/>
		<xsl:variable name="docTitle">
			<xsl:choose>
				<xsl:when test="//edlContent/edl/@title">
					<xsl:value-of select="//edlContent/edl/@title"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//edlContent/edl/@name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="instructions">
			<xsl:choose>
				<xsl:when test="//edlContent/edl/instructions">
					<xsl:value-of select="//edlContent/edl/instructions"/>
				</xsl:when>
				<xsl:otherwise>
                    				Review <xsl:value-of select="$docTitle"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="createInstructions">
			<xsl:choose>
				<xsl:when test="//edlContent/edl/createInstructions">
					<xsl:value-of select="//edlContent/edl/createInstructions"/>
				</xsl:when>
				<xsl:otherwise>
                   						 Fill out new <xsl:value-of select="$docTitle"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="pageTitle">
			<xsl:choose>
				<xsl:when test="$readOnly = 'true'">
                					 Viewing
              				</xsl:when>
				<xsl:otherwise>
                					 Editing 
              				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$docTitle"/>
            						(<xsl:value-of select="$docType"/>)
          			</xsl:variable>
		<table align="center" border="0" cellpadding="10" cellspacing="0" width="80%">
			<tr>
				<td>
					<strong>
						<xsl:value-of select="$pageTitle"/>
					</strong>
				</td>
			</tr>
			<tr>
				<td>
					<!-- let's just assume that if create action is present that this is
                     prior to creation and nothing else is present (that wouldn't really
                     make sense). -->
					<xsl:choose>
						<xsl:when test="//documentState/actionsPossible/create">
							<xsl:value-of select="$createInstructions"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$instructions"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="errors">
		<!--<style type="text/css">
			.error-message {
    				color: red;
    				 text-align: center;
				}
		</style> -->
		<table align="center" border="0" cellpadding="10" cellspacing="0" width="80%">
			<xsl:for-each select="//documentState/error">
				<tr>
					<td>
						<div class="error-message">
							<xsl:value-of select="."/>
						</div>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	<xsl:template name="footer">
		<xsl:if test="//documentState/userSession/backdoorUser">
			<center>
              User
              <xsl:choose>
					<xsl:when test="//documentState/userSession/loggedInUser/displayName">
						<xsl:value-of select="//documentState/userSession/loggedInUser/displayName"/>
					</xsl:when>
					<xsl:when test="//documentState/userSession/loggedInUser/networkId">
						<xsl:value-of select="//documentState/userSession/loggedInUser/networkId"/>
					</xsl:when>
					<xsl:otherwise>
                  				??Unknown user??
               			 </xsl:otherwise>
				</xsl:choose>
              standing in for user
              <xsl:choose>
					<xsl:when test="//documentState/userSession/backdoorUser/backdoorDisplayName">
						<xsl:value-of select="//documentState/userSession/backdoorUser/backdoorDisplayName"/>
					</xsl:when>
					<xsl:when test="//documentState/userSession/backdoorUser/backdoorNetworkId">
						<xsl:value-of select="//documentState/userSession/backdoorUser/backdoorNetworkId"/>
					</xsl:when>
					<xsl:otherwise>
                 				 ??Unknown user??
                			</xsl:otherwise>
				</xsl:choose>
			</center>
		</xsl:if>
	</xsl:template>
	<xsl:template name="hidden-params">
		<xsl:comment>hide this nastiness so we can concentrate on formating above</xsl:comment>
		<xsl:variable name="docId" select="/documentContent/documentState/docId"/>
		<xsl:variable name="def" select="/documentContent/documentState/definition"/>
		<xsl:variable name="docType" select="/documentContent/documentState/docType"/>
		<xsl:variable name="style" select="/documentContent/documentState/style"/>
		<div style="display: none">
			<xsl:choose>
				<xsl:when test="$docId">
					<!-- preserve the data for comparison without transient value -->
					<xsl:comment>input name="docId" type="hidden"</xsl:comment>
					<!-- mark the entire input element transient because we can't insert
                     comments in the middle of a tag just to omit a certain attribute -->
					<xsl:comment>[transient start]</xsl:comment>
					<input name="docId" type="hidden" value="{$docId}"/>
					<xsl:comment>[transient end]</xsl:comment>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$docType">
						<input name="docType" type="hidden" value="{$docType}"/>
					</xsl:if>
					<xsl:if test="$def">
						<input name="def" type="hidden" value="{$def}"/>
					</xsl:if>
					<xsl:if test="$style">
						<input name="style" type="hidden" value="{$style}"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template name="annotation">
		<xsl:variable name="annotation" select="//edlContent/data/version[@current='true']/annotation"/>
		<xsl:variable name="annotatable" select="/documentContent/documentState/annotatable = 'true'"/>
		<xsl:if test="$annotatable or $annotation">
			<table align="center" border="0" cellpadding="0" cellspacing="0" class="bord-r-t" width="80%">
				<tr>
					<td align="center" class="thnormal" colspan="2">
						<xsl:if test="$annotation">
                      				Current annotation: <xsl:value-of select="$annotation"/>
							<br/>
						</xsl:if>
						<xsl:if test="$annotatable">
                      					Set annotation:<br/>
							<textarea name="annotation">
                      					</textarea>
						</xsl:if>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template name="buttons">
		<xsl:variable name="actionable" select="/documentContent/documentState/actionable = 'true'"/>
		<xsl:if test="//documentState/actionsPossible/*">
			<table align="center" border="0" cellpadding="0" cellspacing="0" class="bord-r-t" width="80%">
				<tr>
					<td align="center" class="thnormal" colspan="2">
						<xsl:text>
               				 </xsl:text>
						<xsl:for-each select="//documentState/actionsPossible/*[. != 'returnToPrevious']">
							<xsl:variable name="actionTitle">
								<xsl:choose>
									<xsl:when test="@title">
										<xsl:value-of select="@title"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="local-name()"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<input name="action" title="{$actionTitle}" type="submit" value="{local-name()}">
								<xsl:if test="not($actionable)">
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:if>
							</input>
							<xsl:text>
                  					</xsl:text>
						</xsl:for-each>
						<xsl:if test="//documentState/actionsPossible/returnToPrevious">
							<select name="previousNode">
								<xsl:if test="not($actionable)">
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:if>
								<xsl:for-each select="//documentState/previousNodes/node">
									<option value="{@name}">
										<xsl:value-of select="@name"/>
									</option>
								</xsl:for-each>
							</select>
							<xsl:text>
                 					 </xsl:text>
						</xsl:if>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$overrideMain='true'">
				<xsl:call-template name="mainForm"/>
			</xsl:when>
			<xsl:otherwise>
				<html>
					<head>
						<xsl:call-template name="htmlHead"/>
					</head>
					<body onload="onPageLoad()">
						<xsl:call-template name="header"/>
						<xsl:call-template name="instructions"/>
						<xsl:call-template name="errors"/>
						<xsl:variable name="formTarget" select="'EDocLite'"/>
						<form action="{$formTarget}" id="edoclite" method="post" enctype="multipart/form-data" onsubmit="return validateOnSubmit()">
							<xsl:call-template name="hidden-params"/>
							<xsl:call-template name="mainBody"/>
							<xsl:call-template name="annotation"/>
							<xsl:call-template name="buttons"/>
							<br/>
							<xsl:call-template name="notes"/>
						</form>
						<xsl:call-template name="footer"/>
					</body>
				</html>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="notes">
		<xsl:if test="//NoteForm">
			<xsl:variable name="showEdit" select="//NoteForm/showEdit"/>
			<xsl:variable name="showAdd" select="//NoteForm/showAdd"/>
			<input type="hidden" name="showEdit">
				<xsl:attribute name="value"><xsl:value-of select="//NoteForm/showEdit"/></xsl:attribute>
			</input>
			<input type="hidden" name="showAdd">
				<xsl:attribute name="value"><xsl:value-of select="//NoteForm/showAdd"/></xsl:attribute>
			</input>
			<input type="hidden" name="methodToCall"/>
			<input type="hidden" name="sortNotes">
				<xsl:attribute name="value"><xsl:value-of select="//NoteForm/sortNotes"/></xsl:attribute>
			</input>
			<input type="hidden" name="noteIdNumber">
				<xsl:attribute name="value"><xsl:value-of select="//NoteForm/noteIdNumber"/></xsl:attribute>
			</input>
			<!-- <input type="hidden" name="docId">
				<xsl:attribute name="value"><xsl:value-of select="//NoteForm/docId"/></xsl:attribute>
			</input>-->
			<table align="center" border="0" cellpadding="0" cellspacing="0" class="bord-r-t" width="80%">
				<xsl:if test="$showAdd = 'true'">
					<tr>
						<td colspan="4" class="thnormal2" scope="col" align="center">
							<b>Create Note </b>
						</td>
					</tr>
					<tr>
						<td scope="col" class="thnormal">
							<div align="center">Author</div>
						</td>
						<td scope="col" class="thnormal">
							<div align="center">Date</div>
						</td>
						<td scope="col" class="thnormal">
							<div align="center">Note</div>
						</td>
						<td scope="col" class="thnormal">
							<div align="center">Action</div>
						</td>
					</tr>
					<tr valign="top">
						<td class="datacell">
							<xsl:value-of select="//NoteForm/currentUserName"/>
						</td>
						<td class="datacell">
							<xsl:value-of select="//NoteForm/currentDate"/>
						</td>
						<td class="datacell">
							<xsl:choose>
								<xsl:when test="$showEdit = 'yes'">
									<textarea name="addText" rows="3" cols="60" disabled="true"/>
									<br/>
										Attachment:	<input type="file" name="file" disabled="true"/>
								</xsl:when>
								<xsl:otherwise>
									<textarea name="addText" rows="3" cols="60">
										<xsl:if test="$readOnly = 'true'">
											<xsl:attribute name="disabled">disabled</xsl:attribute>
										</xsl:if>
									</textarea>
									<br/>
										Attachment:	
										<input type="file" name="file">
										<xsl:if test="$readOnly = 'true'">
											<xsl:attribute name="disabled">disabled</xsl:attribute>
										</xsl:if>
									</input>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="datacell">
							<xsl:choose>
								<xsl:when test="$showEdit = 'yes'">
									<div align="center">
										<img src="images/tinybutton-save-disable.gif" width="45" height="15" hspace="3" vspace="3"/>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div align="center">
										<xsl:choose>
											<xsl:when test="$readOnly = 'true'">
												<img src="images/tinybutton-save-disable.gif" width="45" height="15" hspace="3" vspace="3"/>
											</xsl:when>
											<xsl:otherwise>
												<img src="images/tinybutton-save.gif" width="45" height="15" hspace="3" vspace="3" border="0" onclick="document.forms[0].methodToCall.value='save'; document.forms[0].submit();"/>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="//NoteForm/numberOfNotes >0">
						<tr>
							<td colspan="4" class="thnormal2" scope="col" align="center">
								<b>View Notes </b>
							</td>
						</tr>
						<tr>
							<td scope="col" class="thnormal">
								<div align="center">Author</div>
							</td>
							<td scope="col" class="thnormal">
								<div align="center">
									<xsl:choose>
										<xsl:when test="$readOnly = 'true'">
								       	Date
								       </xsl:when>
										<xsl:otherwise>
											<a href="javascript: document.forms[0].elements['methodToCall'].value = 'sort'; document.forms[0].elements['sortNotes'].value = 'true'; document.forms[0].submit();">
															Date</a>
											<img src="images/arrow-expcol-down.gif" width="9" height="5"/>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</td>
							<td scope="col" class="thnormal">
								<div align="center">Note</div>
							</td>
							<td scope="col" class="thnormal">
								<div align="center">Action</div>
							</td>
						</tr>
						<xsl:for-each select="//NoteForm/Notes/Note">
							<tr valign="top">
								<td class="datacell">
									<xsl:value-of select="noteAuthorFullName"/>
								</td>
								<td class="datacell">
									<xsl:value-of select="formattedCreateDate"/>
									<br/>
									<xsl:value-of select="formattedCreateTime"/>
								</td>
								<td class="datacell">
									<xsl:choose>
										<xsl:when test="editingNote = 'true' and authorizedToEdit = 'true'">
											<textarea rows="3" cols="60" name="noteText">
												<xsl:if test="$readOnly = 'true'">
													<xsl:attribute name="disabled">disabled</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="noteText"/>
											</textarea>
											<br/>
											<xsl:choose>
												<xsl:when test="attachments/attachment">
													<xsl:for-each select="attachments/attachment">
														<xsl:value-of select="fileName"/>  &#160;
                    												<input type="hidden" name="idInEdit">
															<xsl:attribute name="value"><xsl:value-of select="../../noteId"/></xsl:attribute>
														</input>
														<xsl:if test="$readOnly ! = 'true'">
															<a href="javascript: document.forms[0].elements['methodToCall'].value = 'deleteAttachment'; document.forms[0].submit();">

delete</a> 
                    												 &#160;
                    												<xsl:variable name="hrefStr">attachment?attachmentId=<xsl:value-of select="attachmentId"/>
															</xsl:variable>
															<a href="{$hrefStr}">
                     										 		download</a>
														</xsl:if>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<br/>
																Attachment:	
																<input type="file" name="file">
														<xsl:if test="$readOnly = 'true'">
															<xsl:attribute name="disabled">disabled</xsl:attribute>
														</xsl:if>
													</input>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="noteText"/>
											<br/>
											<br/>
											<xsl:for-each select="attachments/attachment">
												<xsl:if test="$readOnly ! = 'true'">
													<xsl:value-of select="fileName"/>  &#160;
                    												<xsl:variable name="hrefStr">attachment?attachmentId=<xsl:value-of select="attachmentId"/>
													</xsl:variable>
													<a href="{$hrefStr}">
                    												download</a>
												</xsl:if>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="datacell">
									<xsl:choose>
										<xsl:when test="editingNote = 'true' and authorizedToEdit = 'true' and $readOnly != 'true'">
											<div align="center">
												<img src="images/tinybutton-save.gif" width="40" height="15" hspace="3" vspace="3" border="0">
													<xsl:attribute name="onclick">document.forms[0].elements['methodToCall'].value = 'save';
  	                        											document.forms[0].elements['noteIdNumber'].value = <xsl:value-of select="noteId"/>;
  	                        											document.forms[0].submit();
  	                        										</xsl:attribute>
												</img>
												<img src="images/tinybutton-cancel.gif" width="40" height="15" hspace="3" vspace="3" border="0" onclick="document.forms[0].elements['methodToCall'].value = 'cancel'; document.forms[0].submit();"/>
											</div>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="../../showEdit != 'yes' and authorizedToEdit = 'true' and $readOnly !='true'">
													<div align="center">
														<img src="images/tinybutton-edit1.gif" width="40" height="15" hspace="3" vspace="3" border="0">
															<xsl:attribute name="onclick">document.forms[0].elements['methodToCall'].value = 'edit';
  	                        												document.forms[0].elements['noteIdNumber'].value = <xsl:value-of select="noteId"/>;
  	                        												document.forms[0].submit();
  	                        												</xsl:attribute>
														</img>
														<img src="images/tinybutton-delete1.gif" width="40" height="15" hspace="3" vspace="3" border="0">
															<xsl:attribute name="onclick">document.forms[0].elements['methodToCall'].value = 'delete';
  	                        												document.forms[0].elements['noteIdNumber'].value = <xsl:value-of select="noteId"/>;
  	                        												document.forms[0].submit();
  	                        												</xsl:attribute>
														</img>
													</div>
												</xsl:when>
												<xsl:otherwise>
													<div align="center">
														<img src="images/tinybutton-edit1-disable.gif" width="40" height="15" hspace="3" vspace="3"/>
														<img src="images/tinybutton-delete1-disabled.gif" width="40" height="15" vspace="3"/>
													</div>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="//NoteForm/showAdd != 'true'">
							<tr>
								<td class="thnormal2">
									<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td align="center" valign="middle" class="spacercell">
													<div align="center">
														<br/>
														<br/>
														<br/>
														<p>No notes available </p>
														<xsl:if test="//NoteForm/authorizedToAdd = 'true'">
															<p>
																<img src="images/tinybutton-addnote.gif" width="66" height="15" hspace="3" vspace="3" border="0" onclick="document.forms[0].elements['methodToCall'].value = 'add'; document.forms[0].submit();"/>
															</p>
														</xsl:if>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</table>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
