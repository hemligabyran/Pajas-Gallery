<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="default_template">
		<xsl:param name="title" />
		<xsl:param name="h2" />

		<html lang="sv">
			<head>
				<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
				<base href="http://{/root/meta/domain}{/root/meta/base}" />

				<script type="text/javascript" src="js/jquery-1.7.1.min.js" />
				<script type="text/javascript" src="js/jquery.lightbox-0.5.js" />
				<script type="text/javascript">
					$(function() {
						$('a.gallery').lightBox({
							txtImage: '<xsl:value-of select="/root/content/galleries/gallery[URI = 'all']/description" /><br />',
						});

						$('a.new_window').click(function(event){
							event.preventDefault();
							window.open(this.href);
						});
					});
				</script>

				<link rel="stylesheet" type="text/css" href="css/main.css" />
				<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />

				<title>
					<xsl:if test="$title != ''">
						<xsl:value-of select="$title" />
						<xsl:text> | </xsl:text>
					</xsl:if>

					<xsl:text>Gallery</xsl:text>
				</title>

			</head>
			<body>

				<h1><a href="/">Gallery</a></h1>

				<xsl:if test="/root/content/frontimage">
					<img src="user_content/images/{/root/content/frontimage}?height=531" alt="" id="start_img" />
				</xsl:if>

				<div class="leftmenu">
					<div class="colright">

						<div class="col1wrap">
							<div class="col1">
								<xsl:apply-templates select="/root/content" />
							</div>
						</div>

						<!-- Menu -->
						<div class="col2">
							<ul>
								<li>
									<xsl:if test="/root/content/gallery_name = 'all'">
										<strong>All</strong>
									</xsl:if>
									<xsl:if test="not(/root/content/gallery_name = 'all')">
										<a href="all">All</a>
									</xsl:if>
								</li>

								<!-- Loop through all categories and display them -->
								<xsl:for-each select="/root/content/categories/category">
									<xsl:sort select="sort" data-type="number" />

									<li>
										<xsl:if test="/root/content/category_name = URI">
											<strong><xsl:value-of select="name" /></strong>
										</xsl:if>
										<xsl:if test="not(/root/content/category_name = URI)">
											<a href="{URI}">
												<xsl:value-of select="name" />
											</a>
										</xsl:if>
									</li>

									<!-- Loop through all galleries that belongs to this category -->
									<xsl:if test="/root/content/category_name = URI or /root/content/galleries/gallery[category = current()/name and URI = /root/content/gallery_name]										">
										<xsl:for-each select="/root/content/galleries/gallery[category = current()/name]">
											<xsl:sort select="@sort" data-type="number" />

											<xsl:if test="show_in_menu = 'yes'">
												<li class="sub">
													<xsl:if test="/root/content/gallery_name = URI">
														<strong><xsl:value-of select="name" /></strong>
													</xsl:if>
													<xsl:if test="not(/root/content/gallery_name = URI)">
														<a href="{URI}"><xsl:value-of select="name" /></a>
													</xsl:if>
												</li>
											</xsl:if>

										</xsl:for-each>
									</xsl:if>
								</xsl:for-each>

								<xsl:for-each select="/root/content/galleries/gallery[not(category != '') and URI != 'all']">
									<xsl:sort select="@sort" data-type="number" />
									<li>
										<xsl:if test="/root/content/gallery_name = URI">
											<strong><xsl:value-of select="name" /></strong>
										</xsl:if>
										<xsl:if test="not(/root/content/gallery_name = URI)">
											<a href="{URI}"><xsl:value-of select="name" /></a>
										</xsl:if>
									</li>
								</xsl:for-each>

							</ul>
						</div>
						<!-- End of menu -->

					</div>
				</div>
				<xsl:if test="$h2 = ''">
					<div style="height: 350px; clear: both;"></div>
				</xsl:if>

			</body>
		</html>

	</xsl:template>

</xsl:stylesheet>
