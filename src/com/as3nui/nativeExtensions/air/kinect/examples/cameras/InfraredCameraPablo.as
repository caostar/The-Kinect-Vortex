package com.as3nui.nativeExtensions.air.kinect.examples.cameras
{
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.examples.DemoBase;
	import com.as3nui.nativeExtensions.air.kinect.frameworks.openni.OpenNIKinect;
	import com.as3nui.nativeExtensions.air.kinect.frameworks.openni.OpenNIKinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.frameworks.openni.events.OpenNICameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	public class InfraredCameraPablo extends DemoBase
	{
		private var infraredBitmap:Bitmap;
		private var device:OpenNIKinect;
		//
		private var objContainer:Sprite;
		
		override protected function startDemoImplementation():void
		{
			if(Kinect.isSupported())
			{
				device = Kinect.getDeviceByClass(OpenNIKinect) as OpenNIKinect;
				if(device.capabilities.hasInfraredSupport)
				{
					infraredBitmap = new Bitmap();
					addChild(infraredBitmap);
					//
					objContainer = new Sprite();
					addChild(objContainer);
					
					device.addEventListener(OpenNICameraImageEvent.INFRARED_IMAGE_UPDATE, infraredImageUpdateHandler, false, 0, true);
					device.addEventListener(DeviceEvent.STARTED, kinectStartedHandler, false, 0, true);
					device.addEventListener(DeviceEvent.STOPPED, kinectStoppedHandler, false, 0, true);
					//
					addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
					
					var config:OpenNIKinectSettings = new OpenNIKinectSettings();
					config.infraredEnabled = true;
					config.infraredResolution = CameraResolution.RESOLUTION_640_480;
					//
					config.depthEnabled = true;
					config.skeletonEnabled = true;
					
					device.start(config);					
				}
			}
		}
		
		protected function kinectStartedHandler(event:DeviceEvent):void
		{
			trace("[InfraredCameraDemo] device started");
		}
		
		protected function kinectStoppedHandler(event:DeviceEvent):void
		{
			trace("[InfraredCameraDemo] device stopped");
		}
		
		override protected function stopDemoImplementation():void
		{
			if(device != null)
			{
				device.stop();
				device.removeEventListener(OpenNICameraImageEvent.INFRARED_IMAGE_UPDATE, infraredImageUpdateHandler);
				device.removeEventListener(DeviceEvent.STARTED, kinectStartedHandler);
				device.removeEventListener(DeviceEvent.STOPPED, kinectStoppedHandler);
			}
		}
		protected function enterFrameHandler(event:Event):void
		{
			objContainer.graphics.clear();
			for each(var user:User in device.users){
				//trace(user.head.position);
				trace(device.users.length);
				objContainer.graphics.beginFill(0xFF0000);
				objContainer.graphics.drawCircle(user.head.depthPosition.x + infraredBitmap.x , user.head.depthPosition.y + infraredBitmap.y, 10);
				objContainer.graphics.endFill();
			}
		}
		protected function infraredImageUpdateHandler(event:OpenNICameraImageEvent):void
		{
			infraredBitmap.bitmapData = event.imageData;
			layout();
		}
		
		override protected function layout():void
		{
			if(infraredBitmap){
				infraredBitmap.x = (explicitWidth - infraredBitmap.width) * .5;
				infraredBitmap.y = (explicitHeight - infraredBitmap.height) * .5;
			}
		}
	}
}