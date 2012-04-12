<?php defined('SYSPATH') OR die('No direct access allowed.');

class Controller_Admin_Frontimages extends Admincontroller
{

	public function before()
	{
		$this->xslt_stylesheet = 'admin/frontimages';
		xml::to_XML(array('admin_page' => 'Frontimages'), $this->xml_meta);
	}

	public function action_index()
	{

		// Remove an image
		if (isset($_GET['rm']))
		{
			$image = new Content_Image($_GET['rm']);
			$image->rm_image();
			$this->redirect();
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
						$filename     = 'frontimage.'.strtolower($pathinfo['extension']);
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
									         'width'      => array(imagesx($gd_img_object)),
									         'height'     => array(imagesy($gd_img_object)),
									         'frontimage' => NULL,
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
		foreach (Content_image::get_images(NULL, array('frontimage' => TRUE)) as $image_name => $image_data)
		{
			$images[] = array('name' => $image_name);
		}
		$this->xml_content_images = $this->xml_content->appendChild($this->dom->createElement('images'));
		xml::to_XML($images, $this->xml_content_images, 'image');
	}

}
