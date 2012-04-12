<?php defined('SYSPATH') OR die('No direct access allowed.');

class Galleries
{

	public static function get_categories_for_xml()
	{
		$categories    = array();
		$galleries     = array();
		$gallery_names = array();
		foreach (Content_Image::get_tags() as $tag)
		{
			if ($tag['name'] == 'gallery')
			{
				foreach ($tag['values'] as $tag_value)
				{
					if ( ! in_array($tag_value, $gallery_names))
					{
						$category = '';
						$contents = Content_Content::get_contents_by_tags(array('gallery' => $tag_value, 'type' => 'category'));
						foreach ($contents as $content) $category = $content['content'];

						if ($category != '')
						{
							if ( ! in_array($category, $categories)) $categories[] = $category;
						}
					}
					$gallery_names[] = $tag_value;
				}
			}
		}

		// Fetch sort flags
		foreach ($categories as $nr => $category)
		{
			$categories[$category] = 0;

			$contents = Content_Content::get_contents_by_tags(array('category' => $category, 'type' => 'sort'));
			foreach ($contents as $content) $categories[$category] = $content['content'];

			unset($categories[$nr]);
		}

		// Organize for XML
		foreach ($categories as $category => $sort)
		{
			$categories[] = array(
				'name'         => $category,
				'URI'          => URL::title($category, '-', TRUE),
				'sort'         => $sort,
			);
			unset($categories[$category]);
		}

		return $categories;
	}

	public static function get_for_xml()
	{
		$galleries     = array();
		$gallery_names = array();
		foreach (Content_Image::get_tags() as $tag)
		{
			if ($tag['name'] == 'gallery')
			{
				foreach ($tag['values'] as $tag_value)
				{
					if ( ! in_array($tag_value, $gallery_names))
					{
						$name         = '';
						$sort         = 0;
						$show_in_menu = 'no';
						$category     = '';

						// Get some content
						$contents = Content_Content::get_contents_by_tags(array('gallery' => $tag_value));
						foreach ($contents as $content)
						{
							if     ($content['tags']['type'][0] == 'name')         $name         = $content['content'];
							elseif ($content['tags']['type'][0] == 'sort')         $sort         = $content['content'];
							elseif ($content['tags']['type'][0] == 'category')     $category     = $content['content'];
							elseif ($content['tags']['type'][0] == 'description')  $description  = $content['content'];
							elseif ($content['tags']['type'][0] == 'show_in_menu') $show_in_menu = $content['content'];
						}

						if ($name == '') $name = $tag_value;

						$images  = array();
						$counter = 0;
						foreach (Content_image::get_images(NULL, array('gallery' => array($tag_value))) as $image_name => $image_data)
						{
							@$tmp_image_sort = intval($image_data['sort'][0]);

							if ($tag_value == 'all')
							{

								$tmp_sort = 0;

								foreach ($image_data['gallery'] as $tmp_gallery_name)
								{
									if ($tmp_gallery_name != 'all')
									{
										$tmp_contents = Content_Content::get_contents_by_tags(array('gallery' => $tmp_gallery_name, 'type' => 'sort'));
										foreach ($tmp_contents as $tmp_content)
											$tmp_sort = $tmp_content['content'];
									}
								}

								$image_sort = (intval($tmp_sort) * 10000) + $tmp_image_sort;

							}
							else
								$image_sort = $tmp_image_sort;


							$images[$counter.'image'] = array(
								'name'  => $image_name,
								'@sort' => $image_sort,
							);
							$counter++;
						}

						$galleries[] = array(
							'URI'          => $tag_value,
							'name'         => $name,
							'description'  => $description,
							'show_in_menu' => $show_in_menu,
							'@sort'        => $sort,
							'category'     => $category,
							'images'       => $images,
						);
					}
					$gallery_names[] = $tag_value;
				}
			}
		}

		return $galleries;
	}

}
