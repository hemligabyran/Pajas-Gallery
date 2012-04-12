<?php defined('SYSPATH') OR die('No direct access allowed.');

class Controller_Welcome extends Xsltcontroller
{

	public function action_index()
	{
		$this->xslt_stylesheet = 'generic';

		// Get all categories
		$this->xml_content_categories = $this->xml_content->appendChild($this->dom->createElement('categories'));
		xml::to_XML(Galleries::get_categories_for_xml(), $this->xml_content_categories, 'category');

		// Get all galleries
		$this->xml_content_galleries = $this->xml_content->appendChild($this->dom->createElement('galleries'));
		xml::to_XML(Galleries::get_for_xml(), $this->xml_content_galleries, 'gallery');

		$images = array();
		foreach (Content_image::get_images(NULL, array('frontimage' => TRUE)) as $image_name => $image_data)
			$images[] = $image_name;

		if (count($images))
			xml::to_XML(array('frontimage' => $images[rand(0, count($images) - 1)]), $this->xml_content);
	}

}
