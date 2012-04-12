<?php defined('SYSPATH') OR die('No direct access allowed.');

class Controller_Generic extends Xsltcontroller
{

	public function before()
	{
		// Get all categories
		$this->xml_content_categories = $this->xml_content->appendChild($this->dom->createElement('categories'));
		xml::to_XML(Galleries::get_categories_for_xml(), $this->xml_content_categories, 'category');

		// Get all galleries
		$this->xml_content_galleries = $this->xml_content->appendChild($this->dom->createElement('galleries'));
		xml::to_XML(Galleries::get_for_xml(), $this->xml_content_galleries, 'gallery');

		// We need to put some HTML in from our transformator
		// The reason for all this mess is that we must inject this directly in to the DOM, or else the <> will get destroyed
		$XPath = new DOMXpath($this->dom);
		foreach ($XPath->query('/root/content/galleries/gallery/description') as $raw_content_node)
		{
			$html_content = call_user_func(Kohana::$config->load('content.content_transformator'), $raw_content_node->nodeValue);
			$html_node    = $raw_content_node->parentNode->appendChild($this->dom->createElement('description_html'));
			xml::xml_to_DOM_node($html_content, $html_node);
		}
	}

	public function action_category()
	{
		$this->xslt_stylesheet = 'generic';
		$category              = $this->request->param('category');
		xml::to_XML(array('category_name' => $category), $this->xml_content);
	}

	public function action_gallery()
	{
		$this->xslt_stylesheet = 'generic';
		$gallery_name          = $this->request->param('gallery');
		if ($gallery_name == NULL) $gallery_name = 'all';
		xml::to_XML(array('gallery_name' => $gallery_name), $this->xml_content);
	}

}
