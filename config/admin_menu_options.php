<?php defined('SYSPATH') or die('No direct script access.');

return array(
	// Users admin pages
  'galleries' => array(
    'name'        => 'Galleries',
    '@category'   => 'Galleries',
    'description' => 'List galleries',
		'href'        => 'galleries',
		'position'    => 1,
  ),
  'frontimages' => array(
    'name'        => 'Front images',
    '@category'   => 'Galleries',
    'description' => 'Images on the front page',
		'href'        => 'frontimages',
		'position'    => 2,
  ),
);
