<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="tpl.default.xsl" />

	<xsl:template name="tabs">
	</xsl:template>

	<xsl:template match="/">
		<xsl:if test="/root/meta/action = 'index'">
			<xsl:call-template name="template">
				<xsl:with-param name="title" select="'Admin - Galleries'" />
				<xsl:with-param name="h1" select="'Galleries'" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="content[../meta/action = 'index']">

		<script type="text/javascript">
			$(document).ready(function() {
				$("a.show_hide_link").click(function(event) {
					event.preventDefault();
					$(this).parent().children("ul.galleries").toggle("fast");
				});

				$(".sortable").sortable();
				$(".sortable").disableSelection();

				$(".sortable").bind("sortstop", function(event, ui) {
					$.post(window.location.pathname, $("#gallery_form").serialize());
				});

			});
		</script>

		<form method="post" id="gallery_form">

			<div id="new_gallery">
				<span><strong>New gallery:</strong></span>
				<span><input type="text" name="new_gallery_name" id="new_gallery_name" value="" /></span>
				<span><input type="submit" value="Add" id="add_button" /></span>
			</div>

			<ul class="categories sortable">
				<xsl:for-each select="categories/category">
					<xsl:sort select="sort" data-type="number" />

					<li>
						<xsl:value-of select="name" /><a href="#" class="show_hide_link">Show/Hide</a>
						<input type="hidden" name="category[]" value="{name}" />

						<ul class="galleries sortable">
							<xsl:for-each select="/root/content/galleries/gallery[category = current()/name]">
								<xsl:sort select="@sort" data-type="number" />

								<li>
									<a href="gallery?uri={URI}"><xsl:value-of select="name" /></a>
									<input type="hidden" name="gallery[]" value="{URI}" />
								</li>
							</xsl:for-each>
						</ul>

					</li>
				</xsl:for-each>
			</ul>

			<ul class="galleries sortable">
				<xsl:for-each select="galleries/gallery[URI != 'all' and not(category != '')]">
					<xsl:sort select="@sort" data-type="number" />
					<li>
						<a href="gallery?uri={URI}"><xsl:value-of select="name" /></a>
						<input type="hidden" name="gallery[]" value="{URI}" />
					</li>
				</xsl:for-each>
			</ul>

		</form>

	</xsl:template>

</xsl:stylesheet>
