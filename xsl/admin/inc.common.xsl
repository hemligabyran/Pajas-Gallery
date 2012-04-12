<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="header">
		<div id="header">
			<p id="logo">lenagranefelt.com</p>
			<p class="info">
				<!--LARV IT AB [<a href="#">edit</a>] <span>|</span> -->

				<xsl:if test="/root/meta/user_data">
					<xsl:text>Logged in as: </xsl:text><xsl:value-of select="/root/meta/user_data/username" /> [<a href="logout">logout</a>]
				</xsl:if>
			</p>
		</div>
	</xsl:template>

	<!-- The small tab thingies in the top of every admin page -->
	<xsl:template name="tab">
		<xsl:param name="href" />
		<xsl:param name="action">index</xsl:param>
		<xsl:param name="text"><xsl:value-of select="$href" /></xsl:param>
		<xsl:param name="url_param">yesyeswhatever</xsl:param>

		<li>
			<a href="{$href}">
				<xsl:if test="
					/root/meta/action = $action and
					(
						(
							$url_param = '' and not(/root/meta/url_params/*)
						) or
						/root/meta/url_params[local-name() = $url_param] or
						$url_param = 'yesyeswhatever'
					)
				">
					<xsl:attribute name="class">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$text" />
			</a>
		</li>
	</xsl:template>

	<xsl:template name="form_line">
		<xsl:param name="id" /><!-- This should always be set -->
		<xsl:param name="name" />
		<xsl:param name="value" />
		<xsl:param name="label" />

		<!-- This -->
		<xsl:param name="options" />

		<!-- OR this, not both -->
		<xsl:param name="option_ids" />
		<xsl:param name="option_values" />

		<xsl:param name="error" />
		<xsl:param name="disabled" />
		<xsl:param name="placeholder" />

		<xsl:param name="type">text</xsl:param>

		<!-- Only used if type is textarea -->
		<xsl:param name="rows" />
		<xsl:param name="cols" />

		<label for="{$id}">
			<xsl:value-of select="$label" />

			<!-- Options is not available, that means this is either an input or a textarea -->
			<xsl:if test="(not($options) or not($options/*)) and not($option_ids) and not($option_ids)">

				<!-- Textarea -->
				<xsl:if test="$type = 'textarea'">
					<textarea id="{$id}" name="{$name}">

						<xsl:if test="$rows">
							<xsl:attribute name="rows">
								<xsl:value-of select="$rows" />
							</xsl:attribute>
						</xsl:if>

						<xsl:if test="$disabled">
							<xsl:attribute name="disabled">disabled</xsl:attribute>
						</xsl:if>

						<xsl:for-each select="/root/content/errors/form_errors/*">
							<xsl:if test="name(.) = $id">
								<xsl:attribute name="class">error</xsl:attribute>
							</xsl:if>
						</xsl:for-each>

						<xsl:attribute name="name">
							<xsl:if test="$name = ''">
								<xsl:value-of select="$id" />
							</xsl:if>
							<xsl:if test="$name != ''">
								<xsl:value-of select="$name" />
							</xsl:if>
						</xsl:attribute>

						<xsl:if test="$value = '' and /root/content/formdata/field[@id = $id]">
							<xsl:value-of select="/root/content/formdata/field[@id = $id]" />
						</xsl:if>
						<xsl:if test="not($value = '' and /root/content/formdata/field[@id = $id])">
							<xsl:value-of select="$value" />
						</xsl:if>

					</textarea>
				</xsl:if>

				<!-- No input field, just plain text -->
				<xsl:if test="$type = 'none'">
					<span class="instead_of_input">
						<xsl:value-of select="$value" />
					</span>
				</xsl:if>

				<!-- All other input types -->
				<xsl:if test="$type != 'textarea' and $type != 'none'">
					<input type="{$type}" id="{$id}">

						<xsl:if test="$disabled">
							<xsl:attribute name="disabled">disabled</xsl:attribute>
						</xsl:if>

						<xsl:for-each select="/root/content/errors/form_errors/*">
							<xsl:if test="name(.) = $id">
								<xsl:attribute name="class">error</xsl:attribute>
							</xsl:if>
						</xsl:for-each>

						<xsl:attribute name="name">
							<xsl:if test="$name = ''">
								<xsl:value-of select="$id" />
							</xsl:if>
							<xsl:if test="$name != ''">
								<xsl:value-of select="$name" />
							</xsl:if>
						</xsl:attribute>

						<xsl:if test="$type != 'password' and $type != 'checkbox'">

							<xsl:attribute name="value">
								<xsl:if test="$value = '' and /root/content/formdata/field[@id = $id]">
									<xsl:value-of select="/root/content/formdata/field[@id = $id]" />
								</xsl:if>
								<xsl:if test="not($value = '' and /root/content/formdata/field[@id = $id])">
									<xsl:value-of select="$value" />
								</xsl:if>
							</xsl:attribute>

							<xsl:if test="$placeholder != ''">
								<xsl:attribute name="placeholder">
									<xsl:value-of select="$placeholder" />
								</xsl:attribute>
							</xsl:if>

						</xsl:if>

						<xsl:if test="
							$type = 'checkbox' and
							/root/content/formdata/field[@id = $id] and
							/root/content/formdata/field[@id = $id] != '0'
						">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>

						<xsl:if test="$type = 'radio' and /root/content/formdata/field[@id = $id] = $value">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>

					</input>
				</xsl:if>
			</xsl:if>

			<!-- If options is present, this should be a select-input -->
			<xsl:if test="$options or ($option_ids and $option_values)">

				<select id="{$id}">

					<xsl:if test="$disabled">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>

					<xsl:attribute name="name">
						<xsl:if test="$name = ''">
							<xsl:value-of select="$id" />
						</xsl:if>
						<xsl:if test="$name != ''">
							<xsl:value-of select="$name" />
						</xsl:if>
					</xsl:attribute>

					<xsl:if test="$options">
						<xsl:for-each select="$options/option">
							<xsl:sort select="@sorting" />

							<option value="{@value}">

								<xsl:if test="($value != '' and $value = @value) or ($value = '' and @value = /root/content/formdata/field[@id = $id])">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>

								<xsl:value-of select="." />

							</option>

						</xsl:for-each>

					</xsl:if>

					<xsl:if test="$option_ids and $option_values">

						<xsl:for-each select="$option_ids">
							<option value="{.}">

								<xsl:if test="($value != '' and $value = .) or ($value = '' and . = /root/content/formdata/field[@id = $id])">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>

								<xsl:call-template name="form_line_option">
									<xsl:with-param name="position" select="position()" />
									<xsl:with-param name="option_values" select="$option_values" />
								</xsl:call-template>
							</option>
						</xsl:for-each>

					</xsl:if>

				</select>

			</xsl:if>

		</label>

		<!-- Error message -->
		<p class="error">
			<xsl:if test="$error != ''">
				<xsl:value-of select="$error" />
			</xsl:if>
			<xsl:if test="$error = '' and /root/content/errors/form_errors/*[local-name() = $id]/message">
				<xsl:value-of select="/root/content/errors/form_errors/*[local-name() = $id]/message" />
			</xsl:if>
			<xsl:text>&#160;</xsl:text>
		</p>

	</xsl:template>
	<xsl:template name="form_line_option">
		<xsl:param name="position" />
		<xsl:param name="option_values" />
		<xsl:for-each select="$option_values">
			<xsl:if test="position() = $position">
				<xsl:value-of select="." />
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="form_button">
		<xsl:param name="value" />
		<xsl:param name="id" />
		<xsl:param name="name" />

		<label>
			<input type="submit" class="button" value="{$value}">
				<xsl:if test="$id">
					<xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute>
					<xsl:attribute name="name">
						<xsl:if test="$name = ''">
							<xsl:value-of select="$id" />
						</xsl:if>
						<xsl:if test="$name != ''">
							<xsl:value-of select="$name" />
						</xsl:if>
					</xsl:attribute>
				</xsl:if>
			</input>
		</label>
	</xsl:template>

	<xsl:template name="input_field">
		<xsl:param name="id" />
		<xsl:param name="name" />
		<xsl:param name="value" />
		<xsl:param name="class" />
		<xsl:param name="options" />

		<xsl:param name="type">text</xsl:param>

		<xsl:if test="not($options) or not($options/*)">
			<input type="{$type}">

				<xsl:if test="$id != ''">
					<xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute>
				</xsl:if>

				<xsl:if test="$name != ''">
					<xsl:attribute name="name"><xsl:value-of select="$name" /></xsl:attribute>
				</xsl:if>

				<xsl:if test="$value != '' and $type != 'password'">
					<xsl:attribute name="value"><xsl:value-of select="$value" /></xsl:attribute>
				</xsl:if>
				<xsl:if test="$value = '' and $type != 'password'">
					<xsl:attribute name="value"><xsl:value-of select="/root/content/formdata/field[@name = $name]" /></xsl:attribute>
				</xsl:if>

				<xsl:if test="$class != ''">
					<xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute>
				</xsl:if>

				<xsl:if test="$class = ''">
					<xsl:for-each select="/root/content/errors/form_errors/*">
						<xsl:if test="name(.) = $name">
							<xsl:attribute name="class">error</xsl:attribute>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>

			</input>
		</xsl:if>

		<xsl:if test="$options">
			<xsl:if test="$options/*">
				<select>
					<xsl:if test="$id != ''">
						<xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute>
					</xsl:if>

					<xsl:if test="$name != ''">
						<xsl:attribute name="name"><xsl:value-of select="$name" /></xsl:attribute>
					</xsl:if>

					<xsl:for-each select="$options/option">
						<xsl:sort select="@sorting" />

						<option value="{@value}">

							<xsl:if test="($value != '' and $value = @value) or ($value = '' and @value = /root/content/formdata/field[@name = $name])">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>

							<xsl:value-of select="." />
						</option>

					</xsl:for-each>

				</select>
			</xsl:if>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>
