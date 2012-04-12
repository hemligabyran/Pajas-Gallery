<?php defined('SYSPATH') or die('No direct script access.');

// Get all galleries
$galleries  = array();
$categories = array();
foreach (Content_Image::get_tags() as $tag)
{
	if ($tag['name'] == 'gallery')
	{
		foreach ($tag['values'] as $tag_value)
		{
			if ( ! in_array($tag_value, $galleries))
			{
				$galleries[] = $tag_value;
				$category = '';
				$contents = Content_Content::get_contents_by_tags(array('gallery' => $tag_value, 'type' => 'category'));
				foreach ($contents as $content) $category = URL::title($content['content'], '-', TRUE);

				if ($category != '')
				{
					if ( ! in_array($category, $categories)) $categories[] = $category;
				}
			}
		}
	}
}

if (count($galleries))
{
	Route::set('galleries', '<gallery>', array('gallery' => implode('|', $galleries)))
			->defaults(array(
				'controller' => 'generic',
				'action'     => 'gallery',
			));
}

if (count($categories))
{
	Route::set('categories', '<category>', array('category' => implode('|', $categories)))
			->defaults(array(
				'controller' => 'generic',
				'action'     => 'category',
			));
}
