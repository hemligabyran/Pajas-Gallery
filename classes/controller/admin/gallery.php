<?php defined('SYSPATH') OR die('No direct access allowed.');

class Controller_Admin_Gallery extends Admincontroller
{

	public function before()
	{
		$this->xslt_stylesheet = 'admin/gallery';
		xml::to_XML(array('admin_page' => 'Gallery'), $this->xml_meta);
	}

	public function action_index()
	{
		if ($_GET['uri'] == 'all') $this->redirect();

		// Set all-gallery-settings and sort
		if (isset($_POST['show_in_all']) && isset($_POST['sort']))
		{
			foreach ($_POST['sort'] as $order => $name)
			{
				$image = new Content_Image($name);
				$tags  = array(
					'sort'    => array($order),
					'gallery' => array($_GET['uri']),
				);

				if (in_array($name, $_POST['show_in_all']))
					$tags['gallery'][] = 'all';

				$image->set_data($tags);
			}
		}

		// Remove an image
		if (isset($_GET['rm']))
		{
			$image = new Content_Image($_GET['rm']);
			$image->rm_image();
			$this->redirect();
		}

		// Set gallery name
		if (isset($_POST['name']))
		{
			$contents = Content_Content::get_contents_by_tags(array('gallery' => $_GET['uri'], 'type' => 'name'));
			if (count($contents))
			{
				list($name_content_id)      = array_keys($contents);
				list($name_content_content) = array_values($contents);
				$content                    = new Content_Content($name_content_id);
				$content->update_content($_POST['name']);
			}
			else
			{
				Content_Content::new_content($_POST['name'], array('gallery' => array($_GET['uri']), 'type' => array('name')));
			}
		}

		// Set gallery category
		if (isset($_POST['category']))
		{
			$contents = Content_Content::get_contents_by_tags(array('gallery' => $_GET['uri'], 'type' => 'category'));
			if (count($contents))
			{
				list($category_content_id)      = array_keys($contents);
				list($category_content_content) = array_values($contents);
				$content                        = new Content_Content($category_content_id);
				$content->update_content($_POST['category']);
			}
			else
			{
				Content_Content::new_content($_POST['category'], array('gallery' => array($_GET['uri']), 'type' => array('category')));
			}
		}

		// Set gallery description
		if (isset($_POST['description']))
		{
			$contents = Content_Content::get_contents_by_tags(array('gallery' => $_GET['uri'], 'type' => 'description'));
			if (count($contents))
			{
				list($description_content_id)      = array_keys($contents);
				list($description_content_content) = array_values($contents);
				$content                           = new Content_Content($description_content_id);
				$content->update_content($_POST['description']);
			}
			else
			{
				Content_Content::new_content($_POST['description'], array('gallery' => array($_GET['uri']), 'type' => array('description')));
			}
		}

		// Set show in menu
		if (isset($_POST['show_in_menu']))
		{
			$contents = Content_Content::get_contents_by_tags(array('gallery' => $_GET['uri'], 'type' => 'show_in_menu'));
			if (count($contents))
			{
				list($description_content_id)      = array_keys($contents);
				list($description_content_content) = array_values($contents);
				$content                           = new Content_Content($description_content_id);
				$content->update_content('yes');
			}
			else
			{
				Content_Content::new_content('yes', array('gallery' => array($_GET['uri']), 'type' => array('show_in_menu')));
			}
		}
		elseif ( ! empty($_POST))
		{
			$contents = Content_Content::get_contents_by_tags(array('gallery' => $_GET['uri'], 'type' => 'show_in_menu'));
			if (count($contents))
			{
				list($description_content_id)      = array_keys($contents);
				list($description_content_content) = array_values($contents);
				$content                           = new Content_Content($description_content_id);
				$content->update_content('no');
			}
			else
			{
				Content_Content::new_content('no', array('gallery' => array($_GET['uri']), 'type' => array('show_in_menu')));
			}
		}

		// Add image
		if (isset($_POST['upload_image']))
		{
			foreach ($_FILES['image']['name'] as $nr => $name)
			{
				if ($name != '')
				{
					$pathinfo = pathinfo($_FILES['image']['name'][$nr]);
					if (strtolower($pathinfo['extension']) == 'jpg' || strtolower($pathinfo['extension']) == 'png')
					{
						$filename     = URL::title($_GET['uri'], '-', TRUE).'.'.strtolower($pathinfo['extension']);
						$new_filename = $filename;
						$counter      = 1;
						while ( ! Content_Image::image_name_available($new_filename))
						{
							$new_filename = substr($filename, 0, strlen($filename) - 4).'_'.$counter.'.'.strtolower($pathinfo['extension']);
							$counter++;
						}
						if (move_uploaded_file($_FILES['image']['tmp_name'][$nr], APPPATH.'/user_content/images/'.$new_filename))
						{

							if (strtolower($pathinfo['extension']) == 'jpg')
								$gd_img_object = ImageCreateFromJpeg(Kohana::$config->load('user_content.dir').'/images/'.$new_filename);
							elseif (strtolower($pathinfo['extension']) == 'png')
								$gd_img_object = ImageCreateFromPng(Kohana::$config->load('user_content.dir').'/images/'.$new_filename);

							$details = array(
									         'width'   => array(imagesx($gd_img_object)),
									         'height'  => array(imagesy($gd_img_object)),
									         'gallery' => array('all', URL::title($_GET['uri'], '-', TRUE)),
									       );

							Content_Image::new_image($new_filename, $details);
						}
						else $this->add_error('Unknown error uploading image(s)');
					}
				}
			}
		}


		// Images
		$images = array();
		foreach (Content_image::get_images(NULL, array('gallery' => array($_GET['uri']))) as $image_name => $image_data)
		{
			$images[] = array(
				'name' => $image_name,
				'sort' => @$image_data['sort'][0],
				'all'  => strval((@in_array('all', $image_data['gallery']))),
			);
		}
		$this->xml_content_images = $this->xml_content->appendChild($this->dom->createElement('images'));
		xml::to_XML($images, $this->xml_content_images, 'image');

		// Get some content
		$contents = Content_Content::get_contents_by_tags(array('gallery' => $_GET['uri']));
		foreach ($contents as $content)
		{
			if     ($content['tags']['type'][0] == 'name')
				xml::to_XML(array('gallery_real_name'    => $content['content']), $this->xml_content);
			elseif ($content['tags']['type'][0] == 'description')
				xml::to_XML(array('gallery_description'  => $content['content']), $this->xml_content);
			elseif ($content['tags']['type'][0] == 'category')
				xml::to_XML(array('gallery_category'     => $content['content']), $this->xml_content);
			elseif ($content['tags']['type'][0] == 'show_in_menu')
				xml::to_XML(array('gallery_show_in_menu' => $content['content']), $this->xml_content);
		}

	}

}
