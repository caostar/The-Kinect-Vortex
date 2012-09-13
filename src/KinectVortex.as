package
{
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.examples.DemoBase;
	import com.as3nui.nativeExtensions.air.kinect.frameworks.openni.OpenNIKinect;
	import com.as3nui.nativeExtensions.air.kinect.frameworks.openni.OpenNIKinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.frameworks.openni.events.OpenNICameraImageEvent;
	import com.bit101.components.Label;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel; 
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.ui.Mouse;
	
	import org.osflash.signals.Signal;
	
	import sound.trilha;
	
	import starling.core.Starling;
	
	import tests.*;
	
	import utils.bitmap.resizeBitmap;
	import utils.number.getKAngle;
	
	
	[SWF(frameRate="60", width="1024", height="768", backgroundColor="#000000")]
	public class KinectVortex extends Sprite
	{
		private var DEBUG:Boolean = true;
		//private var DEBUG:Boolean = false;
		private var mStarling:Starling;
		private var device:Kinect;
		
		private var showMagician:Boolean = true;
		//private var showMagician:Boolean = false;
		
		private var rgbImage:Bitmap;
		private var rgbSkeletonContainer:Sprite;
		private var skeletonContainer:Sprite;
		
		private var errorLabel:Label;
		
		private var msgLabel:Label;
		private var msgLabel2:Label;
		private var msgLabel3:Label;
		
		public var elbowGesture:Signal = new Signal(String);
		public var shoulderGesture:Signal = new Signal(String);
		//
		public var XIQUAL_UDINBAK_Gesture:Signal = new Signal(String);
		public var UZARFE_DKYENG_Gesture:Signal = new Signal(String);
		public var KUDEX_EACHT_Gesture:Signal = new Signal(String);
		public var ASHARA_DIJOW_Gesture:Signal = new Signal(String);
		public var THALDOMA_NOBO_Gesture:Signal = new Signal(String);
		public var ONGATHAWAS_Gesture:Signal = new Signal(String);
		//
		public var AEPALIZAGE_Gesture:Signal = new Signal(String);
		//
		public var SHOULDER_ELBOW_DEGREES:Number = 85;
		public var XIQUAL_UDINBAK_DEGREES_MIN:Number = 70;
		public var XIQUAL_UDINBAK_DEGREES_MAX:Number = 95;
		public var KUDEX_EACHT_DEGREES_MIN:Number = -40; //-20
		public var KUDEX_EACHT_DEGREES_MAX:Number = 40; //20
		public var ASHARA_DIJOW_DEGREES_MIN:Number = 10; //35
		public var ASHARA_DIJOW_DEGREES_MAX:Number = 85; //80
		//
		//o máximo é 4500
		//o ideal é 2000
		public var MAX_USER_DISTANCE:Number = 3500;
		//
		private var bmp:Bitmap;
		
		public function KinectVortex()
		{
			if(!DEBUG)Mouse.hide();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			//
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			//
			
			if(DEBUG)startDemoImplementation();
			
		}
		private var isRunning:Boolean = false;
		private  function keyDownListener(e:KeyboardEvent):void {
			toggleFullScreen();
			//
			if(!isRunning){
				startDemoImplementation();
			}
			
			
		}
		private  function toggleFullScreen():void {
			stage.displayState = ( stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE ) ?
				StageDisplayState.NORMAL :
				StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		//
		
		private function startDemoImplementation():void
		{
			if(!DEBUG)Mouse.hide();
			
			mStarling = new Starling(Demo, stage);
			mStarling.enableErrorChecking = false;
			if(DEBUG)mStarling.showStats = true;
			mStarling.start(); 	
			mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void
			{
				Demo.current.theEndSignal.addOnce(theVortexEnd);
				if(DEBUG)Demo.current.timeToExplode = 1;
				
			});
			
			//
			isRunning = true;
			if(Kinect.isSupported())
			{
				device = Kinect.getDevice();
				//check if we have joint rotation info
				if(device.capabilities.hasJointOrientationSupport)
				{
										
					if(DEBUG){
						rgbSkeletonContainer = new Sprite();
						addChild(rgbSkeletonContainer);
						
						skeletonContainer = new Sprite();
						addChild(skeletonContainer);
					}
					
					var settings:OpenNIKinectSettings = new OpenNIKinectSettings();
					settings.skeletonEnabled = true;
					//settings.rgbEnabled = true;
					//settings.depthEnabled = true;
					//settings.infraredEnabled = true;
					//settings.infraredResolution = CameraResolution.RESOLUTION_320_240;
					//
					if(showMagician || DEBUG){
						settings.userMaskEnabled = true;
						settings.userMaskResolution = CameraResolution.RESOLUTION_320_240;
						bmp = new Bitmap(new BitmapData(settings.userMaskResolution.x, settings.userMaskResolution.y, true, 0));
						bmp.scaleX = stage.stageWidth/settings.userMaskResolution.x;
						bmp.scaleY = stage.stageHeight/settings.userMaskResolution.y;
						bmp.blendMode = BlendMode.INVERT;
						bmp.alpha = 0.1;
						addChild(bmp);
					}
					//
					//Set settings.chooseSkeletonsEnabled to true, call device.chooseSkeletons(_vector_of_tracking_ids_) when the device is running
					//
					device.start(settings);
					//
					elbowGesture.addOnce(reactToelbowGesture);
					//
					addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
					//
					
					
					//device.addEventListener(OpenNICameraImageEvent.INFRARED_IMAGE_UPDATE, infraredImageUpdateHandler, false, 0, true);
					if(DEBUG){
					//
						rgbImage = new Bitmap();
						addChildAt(rgbImage,0);
						//device.addEventListener(OpenNICameraImageEvent.INFRARED_IMAGE_UPDATE, infraredImageUpdateHandler, false, 0, true);
						//
						msgLabel = new Label(this,0,0,"Number");
						msgLabel.scaleX = msgLabel.scaleY = 10;
						msgLabel2 = new Label(this,0,100,"Number2");
						msgLabel2.scaleX = msgLabel2.scaleY = 10;
						msgLabel3 = new Label(this,0,200,"Number3");
						msgLabel3.scaleX = msgLabel3.scaleY = 10;
						
						addChild(skeletonContainer);
					////END DEBUG
					}
				}
				else
				{
					errorLabel = new Label(this, 0, 0, "Your device / driver does not support joint orientations");
					
				}
			}else{
				trace("no kinect found!");
			}
		}
		//
		private var isPlaying:Boolean = false;
		private function playMusic():void{
			if(!isPlaying){
				isPlaying = true;
				Demo.current.music.init("./assets/sound/trilhaVortex.mp3");
				TweenLite.to(Demo.current.symbolImage, .75, {autoAlpha:0});
			}
		}
		private function enterFrameHandler(event:Event):void
		{
			if(DEBUG){
				rgbSkeletonContainer.graphics.clear();
				skeletonContainer.graphics.clear();
				
				var joint:SkeletonJoint;
				var rotationVector:Vector3D;
			}
			
			
			//trace(device.usersWithSkeleton.length);
			if(device.usersWithSkeleton.length > 0){
				
				
				var user:User = device.usersWithSkeleton[0];
				/*for each(var user:User in device.users)
				//for each(var user:User in device.usersWithSkeleton)
				{*/
					//if(user.position.z)
					if(user.position.z  < MAX_USER_DISTANCE)
					//if(user.hasSkeleton && user.position.z  < MAX_USER_DISTANCE)
					{
						if(showMagician || DEBUG)drawShadow(user);
						playMusic();
						//we must check the depth of the user to make it elegible for detection
						//+- 1.7 na user.positionRelative.z
						//+- 2.200 na user.position.z
						
						//we must do it only for one user?
						
						/*elbowGesture.dispatch("elbowGesture");
						Demo.current.elbowGesture.dispatch(user.rightHand.depthRelativePosition.x * stage.stageWidth, user.rightHand.depthRelativePosition.y * stage.stageHeight, user.leftHand.depthRelativePosition.x * stage.stageWidth, user.leftHand.depthRelativePosition.y * stage.stageHeight );
						shoulderGesture.dispatch("shoulderGesture");
						XIQUAL_UDINBAK_Gesture.dispatch("XIQUAL_UDINBAK_Gesture");
						ONGATHAWAS_Gesture.dispatch("ONGATHAWAS_Gesture");
						UZARFE_DKYENG_Gesture.dispatch("UZARFE_DKYENG_Gesture");
						KUDEX_EACHT_Gesture.dispatch("KUDEX_EACHT_Gesture");
						ASHARA_DIJOW_Gesture.dispatch("ASHARA_DIJOW_Gesture");
						THALDOMA_NOBO_Gesture.dispatch("THALDOMA_NOBO_Gesture");*/
						
						if(getKAngle(user.leftElbow.orientation.z) < -SHOULDER_ELBOW_DEGREES 
							&& getKAngle(user.rightElbow.orientation.z) > SHOULDER_ELBOW_DEGREES 
							/*&& getKAngle(user.leftShoulder.orientation.z) > SHOULDER_ELBOW_DEGREES 
							&& getKAngle(user.rightShoulder.orientation.z) < -SHOULDER_ELBOW_DEGREES*/
						){
							elbowGesture.dispatch("elbowGesture");
							Demo.current.elbowGesture.dispatch(user.rightHand.depthRelativePosition.x * stage.stageWidth, user.rightHand.depthRelativePosition.y * stage.stageHeight, user.leftHand.depthRelativePosition.x * stage.stageWidth, user.leftHand.depthRelativePosition.y * stage.stageHeight );
						}
						if(getKAngle(user.leftShoulder.orientation.z) < -SHOULDER_ELBOW_DEGREES && getKAngle(user.rightShoulder.orientation.z) > SHOULDER_ELBOW_DEGREES && getKAngle(user.leftElbow.orientation.z) < -SHOULDER_ELBOW_DEGREES && getKAngle(user.rightElbow.orientation.z) > SHOULDER_ELBOW_DEGREES){
							shoulderGesture.dispatch("shoulderGesture");
						}
						//
						if(user.rightHand.depthRelativePosition.y > user.head.depthRelativePosition.y 
							&& user.leftHand.depthRelativePosition.y > user.head.depthRelativePosition.y 
							&& getKAngle(user.rightShoulder.orientation.y) > XIQUAL_UDINBAK_DEGREES_MIN 
							&& getKAngle(user.rightShoulder.orientation.y) < XIQUAL_UDINBAK_DEGREES_MAX 
							&& getKAngle(user.leftShoulder.orientation.y) < -XIQUAL_UDINBAK_DEGREES_MIN 
							&& getKAngle(user.leftShoulder.orientation.y) > -XIQUAL_UDINBAK_DEGREES_MAX
							/*&& getKAngle(user.rightElbow.orientation.y) > XIQUAL_UDINBAK_DEGREES_MIN 
							&& getKAngle(user.rightElbow.orientation.y) < XIQUAL_UDINBAK_DEGREES_MAX 
							&& getKAngle(user.leftElbow.orientation.y) < -XIQUAL_UDINBAK_DEGREES_MIN 
							&& getKAngle(user.leftElbow.orientation.y) > -XIQUAL_UDINBAK_DEGREES_MAX*/
						)
						{
							XIQUAL_UDINBAK_Gesture.dispatch("XIQUAL_UDINBAK_Gesture");
							if(Demo.current.isRebule)Demo.current.XIQUAL_UDINBAK_Gesture.dispatch("XIQUAL_UDINBAK_Gesture");
							ONGATHAWAS_Gesture.dispatch("ONGATHAWAS_Gesture");
						}
						if(getKAngle(user.leftShoulder.orientation.z) > SHOULDER_ELBOW_DEGREES && getKAngle(user.rightShoulder.orientation.z) > SHOULDER_ELBOW_DEGREES){
							UZARFE_DKYENG_Gesture.dispatch("UZARFE_DKYENG_Gesture");
						}
						if(getKAngle(user.leftShoulder.orientation.z) > KUDEX_EACHT_DEGREES_MIN && getKAngle(user.leftShoulder.orientation.z) < KUDEX_EACHT_DEGREES_MAX && getKAngle(user.rightShoulder.orientation.z) > KUDEX_EACHT_DEGREES_MIN && getKAngle(user.rightShoulder.orientation.z) < KUDEX_EACHT_DEGREES_MAX){
							KUDEX_EACHT_Gesture.dispatch("KUDEX_EACHT_Gesture");
						}
						//if(getKAngle(user.leftShoulder.orientation.z) > ASHARA_DIJOW_DEGREES_MIN && getKAngle(user.leftShoulder.orientation.z) < ASHARA_DIJOW_DEGREES_MAX && getKAngle(user.rightShoulder.orientation.z) > ASHARA_DIJOW_DEGREES_MIN && getKAngle(user.rightShoulder.orientation.z) < ASHARA_DIJOW_DEGREES_MAX){
						if(user.head.depthPosition.y < user.leftHand.depthPosition.y && user.head.depthPosition.y > user.rightHand.depthPosition.y){
							ASHARA_DIJOW_Gesture.dispatch("ASHARA_DIJOW_Gesture");
						}
						//if(getKAngle(user.leftShoulder.orientation.z) < -ASHARA_DIJOW_DEGREES_MIN && getKAngle(user.leftShoulder.orientation.z) > -ASHARA_DIJOW_DEGREES_MAX && getKAngle(user.rightShoulder.orientation.z) < -ASHARA_DIJOW_DEGREES_MIN && getKAngle(user.rightShoulder.orientation.z) > -ASHARA_DIJOW_DEGREES_MAX){
						if(user.head.depthPosition.y > user.leftHand.depthPosition.y && user.head.depthPosition.y < user.rightHand.depthPosition.y){
							THALDOMA_NOBO_Gesture.dispatch("THALDOMA_NOBO_Gesture");
						}
						//if(getKAngle(user.rightShoulder.orientation.y) > XIQUAL_UDINBAK_DEGREES_MIN && getKAngle(user.rightShoulder.orientation.y) < XIQUAL_UDINBAK_DEGREES_MAX && getKAngle(user.leftShoulder.orientation.y) > -10 && getKAngle(user.leftElbow.orientation.y) > -10){
						if(user.torso.depthPosition.y < user.leftHand.depthPosition.y && user.torso.depthPosition.y > user.rightHand.depthPosition.y){
							AEPALIZAGE_Gesture.dispatch("AEPALIZAGE_Gesture");
							Demo.current.AEPALIZAGE_Gesture.dispatch("AEPALIZAGE_Gesture");
						}
						
						if(DEBUG){
							
							/*msgLabel2.text = "right: " + String(getKAngle(user.rightShoulder.orientation.y));
							msgLabel3.text = "left: " + String(getKAngle(user.leftShoulder.orientation.y)); 
							*/
							/*msgLabel2.text = "rightHand: " + String(user.rightHand.depthRelativePosition.y);
							msgLabel3.text = "head: " + String(user.head.depthRelativePosition.y); */
							
							var gg:Boolean;
							if(user.head.depthPosition.y > user.leftHand.depthPosition.y && user.head.depthPosition.y < user.rightHand.depthPosition.y){
								gg=true;
							}else{
								gg=false
							}
							msgLabel.text = gg.toString();
							/*msgLabel2.text = "rightHand: " + String(user.rightHand.depthPosition.y);
							msgLabel3.text = "leftHand: " + String(user.leftHand.depthPosition.y);*/
							msgLabel2.text = "position: " + String(user.position.z);
							
							
							//
							for each(joint in user.skeletonJoints)
							{
								//rgb overlay
								rgbSkeletonContainer.graphics.beginFill(0xFF0000);
								//rgbSkeletonContainer.graphics.drawCircle(joint.rgbPosition.x, joint.rgbPosition.y, 5);
								rgbSkeletonContainer.graphics.drawCircle(joint.depthRelativePosition.x * stage.stageWidth, joint.depthRelativePosition.y * stage.stageHeight, 10);
								rgbSkeletonContainer.graphics.endFill();
							}
						}
						
						
						//Demo.current.drawCaosStars(user.rightHand.depthRelativePosition.x * stage.stageWidth, user.rightHand.depthRelativePosition.y * stage.stageHeight)
						
						Demo.current.moveHandsSignal.dispatch(user.rightHand.depthRelativePosition.x * stage.stageWidth, user.rightHand.depthRelativePosition.y * stage.stageHeight, user.leftHand.depthRelativePosition.x * stage.stageWidth, user.leftHand.depthRelativePosition.y * stage.stageHeight );
						
						
					}
				
				//fim do for each	
				//}
				
			//fim do if(device.usersWithSkeleton.length > 0){
			}else{
				
			}
		}
		//
		private var zeroPoint:Point = new Point(0,0);
		protected function drawShadow(user:User):void
		{
			bmp.bitmapData.lock();
			bmp.bitmapData.fillRect(bmp.bitmapData.rect, 0);
			
				if(user.userMaskData != null)
				{
					//user.userMaskData.copyChannel(user.userMaskData, user.userMaskData.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.RED);
					bmp.bitmapData.copyPixels(user.userMaskData, user.userMaskData.rect,zeroPoint);	
					
				}
			
			bmp.bitmapData.unlock();
		}
		private function rgbImageUpdateHandler(event:CameraImageEvent):void
		{
			rgbImage.bitmapData = event.imageData;
			
			
		}
		protected function infraredImageUpdateHandler(event:OpenNICameraImageEvent):void
		{
			/*var scalex:Number = stage.stageWidth/640;
			var scaley:Number = stage.stageHeight/480;
			var matrix:Matrix = new Matrix();
			matrix.scale(scalex, scaley);
			
			//rgbImage.bitmapData = event.imageData;
			rgbImage.bitmapData.draw(event.imageData,matrix);*/
			
			//rgbImage.bitmapData = event.imageData;
			
			Demo.current.renderMagician(event.imageData);
			
		}
		//
		private function reactToelbowGesture(gesture:String):void{
			if(DEBUG)msgLabel.text = String("GO AntiBraços!");
			//shoulderGesture.addOnce(reactToshoulderGesture);
			XIQUAL_UDINBAK_Gesture.addOnce(reactToXIQUAL_UDINBAK_Gesture);
		}
		private function reactToshoulderGesture(gesture:String):void{
			if(DEBUG)msgLabel.text = String("GO Braços!");
			XIQUAL_UDINBAK_Gesture.addOnce(reactToXIQUAL_UDINBAK_Gesture);
		}
		private function reactToXIQUAL_UDINBAK_Gesture(gesture:String):void{
			if(DEBUG)msgLabel.text = String("GO XIQUAL_UDINBAK_Gesture!");
			UZARFE_DKYENG_Gesture.addOnce(reactToUZARFE_DKYENG_Gesture);
			//
			Demo.current.XIQUAL_UDINBAK_Gesture.dispatch("XIQUAL_UDINBAK_Gesture");
		}
		private function reactToUZARFE_DKYENG_Gesture(gesture:String):void{
			if(DEBUG)msgLabel.text = String("GO UZARFE_DKYENG_Gesture!");
			KUDEX_EACHT_Gesture.addOnce(reactToKUDEX_EACHT_Gesture);
			//
			Demo.current.UZARFE_DKYENG_Gesture.dispatch("UZARFE_DKYENG_Gesture");
		}
		private function reactToKUDEX_EACHT_Gesture(gesture:String):void{
			if(DEBUG)msgLabel.text = String("GO KUDEX_EACHT_Gesture!");
			//ASHARA_DIJOW_Gesture.addOnce(reactToASHARA_DIJOW_Gesture);
			TweenLite.delayedCall( 3, ASHARA_DIJOW_Gesture.addOnce,[reactToASHARA_DIJOW_Gesture] );
			//
			Demo.current.KUDEX_EACHT_Gesture.dispatch("KUDEX_EACHT_Gesture");
		}
		private function reactToASHARA_DIJOW_Gesture(gesture:String):void{
			if(DEBUG)msgLabel.text = String("GO ASHARA_DIJOW_Gesture!");
			//THALDOMA_NOBO_Gesture.addOnce(reactToTHALDOMA_NOBO_Gesture);
			TweenLite.delayedCall( 3, THALDOMA_NOBO_Gesture.addOnce,[reactToTHALDOMA_NOBO_Gesture] );
			//
			Demo.current.ASHARA_DIJOW_Gesture.dispatch("ASHARA_DIJOW_Gesture");
		}
		private function reactToTHALDOMA_NOBO_Gesture(gesture:String):void{
			if(DEBUG)msgLabel.text = String("GO THALDOMA_NOBO_Gesture!");
			ONGATHAWAS_Gesture.addOnce(reactToONGATHAWAS_Gesture);
			//
			Demo.current.THALDOMA_NOBO_Gesture.dispatch("THALDOMA_NOBO_Gesture");
		}
		private function reactToONGATHAWAS_Gesture(gesture:String):void{
			if(DEBUG)msgLabel.text = String("GO ONGATHAWAS_Gesture!");
			
			//
			Demo.current.ONGATHAWAS_Gesture.dispatch("ONGATHAWAS_Gesture");
		}
		
		
		//AEPALIZAGE_Gesture.addOnce(reactToAEPALIZAGE_Gesture);
		private function reactToAEPALIZAGE_Gesture(gesture:String):void{
			if(DEBUG)msgLabel.text = String("GO AEPALIZAGE_Gesture!");
			
		}
		
		public var finalMeditation:fallingFromSky;
		public function theVortexEnd():void{
			if(showMagician || DEBUG){
				TweenLite.to(bmp, 1, {alpha:0, onComplete:initFinalMeditation});
				showMagician = false;
			}else{
				initFinalMeditation();
			}
			
		}
		public function initFinalMeditation():void{
			finalMeditation = new fallingFromSky(stage.stageWidth,stage.stageHeight)
			addChild(finalMeditation);
			THALDOMA_NOBO_Gesture.addOnce(finishItAll);
		}
		public function finishItAll(str:String):void{
			finalMeditation.stopSky();
			TweenLite.delayedCall( 20, Demo.current.music.stopMusic );
		}
		
		/*private function reactToGesture(gesture:String):void{
			
			switch(gesture){
				case "elbowGesture": 
					msgLabel.text = String("GO AntiBraços!");
					shoulderGesture.addOnce(reactToGesture);
				break;
				//
				case "shoulderGesture": 
					msgLabel.text = String("GO Braços!");
					XIQUAL_UDINBAK_Gesture.addOnce(reactToGesture);
				break;
				//
				case "XIQUAL_UDINBAK_Gesture":
					msgLabel.text = String("GO XIQUAL_UDINBAK_Gesture!");
					UZARFE_DKYENG_Gesture.addOnce(reactToGesture);
				break;
				//
				case "UZARFE_DKYENG_Gesture":
					msgLabel.text = String("GO UZARFE_DKYENG_Gesture!");
					KUDEX_EACHT_Gesture.addOnce(reactToGesture);
				break;
				//
				case "KUDEX_EACHT_Gesture":
					msgLabel.text = String("GO KUDEX_EACHT_Gesture!");
					ASHARA_DIJOW_Gesture.addOnce(reactToGesture);
				break;
				//
				case "ASHARA_DIJOW_Gesture":
					msgLabel.text = String("GO ASHARA_DIJOW_Gesture!");
				break;
				//
				case "THALDOMA_NOBO_Gesture":
					msgLabel.text = String("GO THALDOMA_NOBO_Gesture!");
					THALDOMA_NOBO_Gesture.addOnce(reactToGesture);
				break;
				//
				case "AEPALIZAGE_Gesture":
					msgLabel.text = String("GO AEPALIZAGE_Gesture!");
					AEPALIZAGE_Gesture.addOnce(reactToGesture);
				break;
			}
		}*/
		
		
		////
	}
}