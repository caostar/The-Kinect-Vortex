﻿package utils.camera{		import flash.media.*;	import flash.display.*;	import flash.geom.*;	//	import utils.capabilities.*;	import utilsMine;	//							public function getCamera(position:String):Camera		{		 		  for (var i:uint = 0; i < Camera.names.length; ++i)		  {				var cam:Camera = Camera.getCamera(String(i));				CONFIG::IPAD				{					if(cam.position){						if (cam.position == position) return cam;					}				}		  }		  return Camera.getCamera();		}		//					}