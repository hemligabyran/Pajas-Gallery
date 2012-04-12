<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="tpl.default.xsl" />

	<xsl:template name="tabs">
	</xsl:template>

	<xsl:template match="/">
		<xsl:if test="/root/meta/action = 'index'">
			<xsl:call-template name="template">
				<xsl:with-param name="title" select="'Admin - Front images'" />
				<xsl:with-param name="h1" select="'Front images'" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="content[../meta/action = 'index']">

		<form method="post" enctype="multipart/form-data">
			<ul class="gallery">

				<li class="uploader">
					<h2>Upload new image</h2>
					<p>Select JPG or PNG:</p>
					<p><input type="file" name="image[]" /></p>
					<p><input type="file" name="image[]" /></p>
					<p><input type="file" name="image[]" /></p>
					<p><input type="file" name="image[]" /></p>
					<p><input type="file" name="image[]" /></p>
					<p><input type="submit" name="upload_image" value="Upload!" /></p>
				</li>

				<xsl:for-each select="images/image">
					<li>
						<a href="frontimages?uri={/root/meta/url_params/uri}&amp;rm={name}" class="delete"><img src="../img/cross-icon.png" alt="Delete" /></a>
						<img class="image" src="../user_content/images/{name}?height=150" alt="" />
					</li>
				</xsl:for-each>

			</ul>
		</form>

	</xsl:template>

</xsl:stylesheet>
