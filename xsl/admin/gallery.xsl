<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="tpl.default.xsl" />

	<xsl:template name="tabs">
	</xsl:template>

	<xsl:template match="/">
		<xsl:if test="/root/meta/action = 'index'">
			<xsl:call-template name="template">
				<xsl:with-param name="title" select="'Admin - Gallery'" />
				<xsl:with-param name="h1" select="'Gallery'" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="content[../meta/action = 'index']">

		<script>
			$(function() {
				$("ul.gallery").sortable({cancel: '.uploader'});
				$("ul.gallery").disableSelection();

				$("ul.gallery").bind("sortstop", function(event, ui) {
					$.post(window.location.href, $("#gallery_form").serialize());
				});

				$(".show_in_all").click(function(e){
					$.post(window.location.href, $("#gallery_form").serialize());
				});
			});
		</script>

		<form method="post">

			<label>
				<xsl:text>URL: </xsl:text>
				<span class="instead_of_input"><xsl:value-of select="/root/meta/url_params/uri" /></span>
			</label>

			<label>
				<xsl:text>Gallery name: </xsl:text>
				<input type="text" name="name" value="{gallery_real_name}" />
			</label>

			<label>
				<xsl:text>Category: </xsl:text>
				<input type="text" name="category" value="{gallery_category}" />
			</label>

			<label>
				<xsl:text>Show in menu: </xsl:text>
				<input type="checkbox" name="show_in_menu">
					<xsl:if test="gallery_show_in_menu = 'yes'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
			</label>

			<label class="textarea">
				<xsl:text>Gallery text</xsl:text>
				<textarea name="description"><xsl:value-of select="gallery_description" /></textarea>
			</label>

			<label>
				<input type="submit" value="Save changes" />
			</label>

		</form>

		<form method="post" enctype="multipart/form-data" id="gallery_form">
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
					<xsl:sort select="sort" data-type="number" />

					<li class="movable">
						<input type="hidden" name="sort[]" value="{name}" />
						<label for="name_{name}">Show in all:</label>
						<input type="checkbox" name="show_in_all[]" id="name_{name}" value="{name}" class="show_in_all">
							<xsl:if test="all = '1'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<a href="gallery?uri={/root/meta/url_params/uri}&amp;rm={name}" class="delete"><img src="../img/cross-icon.png" alt="Delete" /></a>
						<img class="image" src="../user_content/images/{name}?height=150" alt="" />
					</li>
				</xsl:for-each>

			</ul>
		</form>

	</xsl:template>

</xsl:stylesheet>
