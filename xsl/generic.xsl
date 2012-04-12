<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output
		method="html"
		encoding="utf-8"
		omit-xml-declaration="yes"
		doctype-system="about:legacy-compat"
	/>

	<xsl:include href="inc.elements.xsl" />
	<xsl:include href="inc.default.xsl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="/root/content/category_name">
				<xsl:call-template name="default_template">
					<xsl:with-param name="h2"><xsl:value-of select="/root/content/categories/category[URI = /root/content/category_name]/name" /></xsl:with-param>
					<xsl:with-param name="title"><xsl:value-of select="/root/content/categories/category[URI = /root/content/category_name]/name" /></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="/root/content/gallery_name">
				<xsl:call-template name="default_template">
					<xsl:with-param name="h2"><xsl:value-of select="/root/content/galleries/gallery[URI = /root/content/gallery_name]/name" /></xsl:with-param>
					<xsl:with-param name="title"><xsl:value-of select="/root/content/galleries/gallery[URI = /root/content/gallery_name]/name" /></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="/root/content/page">
				<xsl:call-template name="default_template">
					<xsl:with-param name="h2"><xsl:value-of select="/root/content/page" /></xsl:with-param>
					<xsl:with-param name="title"><xsl:value-of select="/root/content/page" /></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="default_template" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/root/content">

		<xsl:if test="gallery_name">

			<!-- Normal gallery page -->
			<xsl:if test="galleries/gallery[URI = /root/content/gallery_name]/description_html/p">
				<div class="box text_box">
					<h4>
						<xsl:apply-templates select="galleries/gallery[URI = /root/content/gallery_name]/description_html/p" mode="elements" />
					</h4>
				</div>
			</xsl:if>

			<xsl:for-each select="galleries/gallery[URI = /root/content/gallery_name]/images/image">
				<xsl:sort select="@sort" data-type="number" />

				<div class="box image_box">
					<a href="user_content/images/{name}" class="gallery">
						<img src="user_content/images/{name}?height=150" alt="{../../../gallery[images/image/name = current()/name and URI != 'all']/name}" />
					</a>
				</div>
			</xsl:for-each>

		</xsl:if>

		<xsl:if test="category_name">
			<!-- Category -->

			<xsl:for-each select="galleries/gallery[category = /root/content/categories/category[URI = /root/content/category_name]/name]">
				<xsl:sort select="@sort" data-type="number" />

				<xsl:if test="description_html/p and /root/content/category_name != 'books'">
					<div class="box text_box">
						<h4>
							<xsl:apply-templates select="description_html/p" mode="elements" />
						</h4>
					</div>
				</xsl:if>

				<xsl:for-each select="images/image">
					<xsl:sort select="@sort" data-type="number" />

					<div class="box image_box">
						<a href="user_content/images/{name}" class="gallery">
							<img src="user_content/images/{name}?height=150" alt="{../../../gallery[images/image/name = current()/name and URI != 'all']/name}" />
						</a>
					</div>
				</xsl:for-each>

			</xsl:for-each>

		</xsl:if>

		<xsl:if test="page">
			<div id="first_page_spacer"></div>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>
