<?php defined('SYSPATH') OR die('No direct access allowed.');

class Controller_Admin_Galleries extends Admincontroller
{

	public function action_index()
	{
		$this->xslt_stylesheet = 'admin/galleries';
		xml::to_XML(array('admin_page' => 'Galleries'), $this->xml_meta);

		if ( ! empty($_POST))
		{

			if ( ! empty($_POST['gallery']))
			{
				foreach ($_POST['gallery'] as $counter => $gallery_URI)
				{
					$contents = Content_Content::get_contents_by_tags(array('gallery' => $gallery_URI, 'type' => 'sort'));
					if (count($contents))
					{
						list($sort_content_id)      = array_keys($contents);
						list($sort_content_content) = array_values($contents);
						$content                    = new Content_Content($sort_content_id);
						$content->update_content($counter);
					}
					else
					{
						Content_Content::new_content($counter, array('gallery' => array($gallery_URI), 'type' => array('sort')));
					}
				}

				foreach ($_POST['category'] as $counter => $category_name)
				{
					$contents = Content_Content::get_contents_by_tags(array('category' => $category_name, 'type' => 'sort'));
					if (count($contents))
					{
						list($sort_content_id)      = array_keys($contents);
						list($sort_content_content) = array_values($contents);
						$content                    = new Content_Content($sort_content_id);
						$content->update_content($counter);
					}
					else
					{
						Content_Content::new_content($counter, array('category' => array($category_name), 'type' => array('sort')));
					}
				}
			}

			if ( ! empty($_POST['new_gallery_name']))
			{
				$this->redirect('admin/gallery?uri='.url::title($_POST['new_gallery_name'], '-', TRUE));
			}

		}

		// Get all galleries
		$galleries     = array();
		$gallery_names = array();
		$categories    = array();
		foreach (Content_Image::get_tags() as $tag)
		{
			if ($tag['name'] == 'gallery')
			{
				foreach ($tag['values'] as $tag_value)
				{
					if ( ! in_array($tag_value, $gallery_names))
					{
						$name     = '';
						$sort     = 0;
						$category = '';
						// Get some content
						$contents = Content_Content::get_contents_by_tags(array('gallery' => $tag_value));
						foreach ($contents as $content)
						{
							if     ($content['tags']['type'][0] == 'name')     $name     = $content['content'];
							elseif ($content['tags']['type'][0] == 'sort')     $sort     = $content['content'];
							elseif ($content['tags']['type'][0] == 'category') $category = $content['content'];
						}

						if ($name == '')                         $name         = $tag_value;
						if ( ! in_array($category, $categories)) $categories[] = $category;

						$galleries[] = array(
							'URI'      => $tag_value,
							'name'     => $name,
							'@sort'    => $sort,
							'category' => $category,
						);
					}
					$gallery_names[] = $tag_value;
				}
			}
		}
		$this->xml_content_galleries = $this->xml_content->appendChild($this->dom->createElement('galleries'));
		xml::to_XML($galleries, $this->xml_content_galleries, 'gallery');

		foreach ($categories as $nr => $category_real_name)
		{
			if ($category_real_name != '')
			{
				$sort = 0;
				foreach (Content_Content::get_contents_by_tags(array('category' => $category_real_name, 'type' => 'sort')) as $content)
					$sort = $content['content'];

				$categories[$nr.'category'] = array(
					'URI'  => URL::title($category_real_name, '-', TRUE),
					'name' => $category_real_name,
					'sort' => $sort,
				);
			}
			unset($categories[$nr]);
		}
		$this->xml_content_categories = $this->xml_content->appendChild($this->dom->createElement('categories'));
		xml::to_XML($categories, $this->xml_content_categories);

	}

}
