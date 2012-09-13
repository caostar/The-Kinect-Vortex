package tests
{
    import com.greensock.*;
    import com.greensock.easing.*;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import flash.utils.Dictionary;
    
    import org.osflash.signals.Signal;
    
    import sound.trilha;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.extensions.PDParticleSystem;
    import starling.extensions.ParticleSystem;
    import starling.textures.RenderTexture;
    import starling.textures.Texture;
    import starling.utils.deg2rad;
    
    public class Demo extends Sprite
    {
		private var tuSound:Tu = new Tu();
		private var tumSound:Tum = new Tum();
		private var explosion:Explosion = new Explosion();
		private var fireball:Fireball = new Fireball();
		private var blade:Blade = new Blade();
		private var udinbakSound:UdinbakSound = new UdinbakSound();
		
		private var timelineHeart:TimelineMax;
		private var velo:Number = 0.75;
		
		
		//[Embed(source="assets/starlingParticles/handsCaosStarTexture.png")]
		[Embed(source="assets/starlingParticles/rebuleCaosStar.png")]
		protected static const caosStarParticle:Class;
		[Embed(source="assets/starlingParticles/handsCaosStarLow.pex", mimeType="application/octet-stream")]
		private static const caosStarConfig:Class;
		
		[Embed(source="assets/starlingParticles/basicTexture.png")]
		protected static const basicParticle:Class;
		[Embed(source="assets/starlingParticles/fireTraceLow.pex", mimeType="application/octet-stream")]
		private static const fireTraceConfig:Class;
		
		[Embed(source="assets/starlingParticles/rebule.png")]
		protected static const rebuleParticle:Class;
		[Embed(source="assets/starlingParticles/rebuleSigil.pex", mimeType="application/octet-stream")]
		private static const rebuleConfig:Class;
		
		[Embed(source="assets/rebuleCaosStarBig.png")]
		protected static const rebuleCaosStarClass:Class;
		private var rebuleCaosStarBMP:Bitmap = new rebuleCaosStarClass();
		private var rebuleCaosStarTexture:Texture;
		private var rebuleCaosStar:Image;
		private var rebuleCaosStarHolder:Sprite = new Sprite;
		
		/*[Embed(source="assets/starlingParticles/handsCaosStarTexture.png")]
		protected static const caosStarMarker:Class;*/
		private var caosStarMarkerBMP:Bitmap = new rebuleParticle();
		private var caosStarMarkerTexture:Texture;
		private var caosStarMarkerImage:Image;
		
		//[Embed(source="assets/symbols.png")]
		[Embed(source="assets/symbols2.png")]
		protected static const symbolClass:Class;
		private var symbolBMP:Bitmap = new symbolClass();
		private var symbolTexture:Texture;
		public var symbolImage:Image;
		
		private var anyRight:PDParticleSystem;
		private var anyLeft:PDParticleSystem;
		
		private var rebuleParticlesRight:PDParticleSystem;
		private var rebuleParticlesLeft:PDParticleSystem;
		
        private var righHandParticles:PDParticleSystem;
		private var leftHandParticles:PDParticleSystem;
		
		private var XIQUAL_UDINBAK_Particles:PDParticleSystem;
		private var UZARFE_DKYENG_Particles:PDParticleSystem;
		private var KUDEX_EACHT_Particles:PDParticleSystem;
		private var ASHARA_DIJOW_Particles:PDParticleSystem;
		private var THALDOMA_NOBO_Particles:PDParticleSystem;
		
		private var psConfig:XML = XML(new caosStarConfig());
		private var psTexture:Texture = Texture.fromBitmap(new caosStarParticle());
		private var fireConfig:XML = XML(new fireTraceConfig());
		private var basicTexture:Texture = Texture.fromBitmap(new basicParticle());
		private var psRebuleConfig:XML = XML(new rebuleConfig());
		private var rebuleTexture:Texture = Texture.fromBitmap(new rebuleParticle());
		
		private var arrowSize:int = 500;
		private var particlesDict:Dictionary = new Dictionary();
		private var rebuleDict:Dictionary = new Dictionary();
		
		
		public var moveHandsSignal:Signal = new Signal(Number,Number,Number,Number);
		public var elbowGesture:Signal = new Signal(Number,Number,Number,Number);
		public var shoulderGesture:Signal = new Signal(String);
		//
		public var XIQUAL_UDINBAK_Gesture:Signal = new Signal(String);
		public var UZARFE_DKYENG_Gesture:Signal = new Signal(String);
		public var KUDEX_EACHT_Gesture:Signal = new Signal(String);
		public var ASHARA_DIJOW_Gesture:Signal = new Signal(String);
		public var THALDOMA_NOBO_Gesture:Signal = new Signal(String);
		public var ONGATHAWAS_Gesture:Signal = new Signal(String);
		public var AEPALIZAGE_Gesture:Signal = new Signal(String);
		
		public var theEndSignal:Signal = new Signal();
		//
		private var mRenderTexture:RenderTexture; 
		private var mBrush:Image;
		        
        public function Demo()
        {
          
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
		public function renderMagician(bmp:BitmapData):void{
			
			mBrush.texture.dispose();
			mBrush.texture.base.dispose();
			mBrush.texture = Texture.fromBitmapData(bmp);
			
			//flash.display3D.textures.Texture(mBrush.texture.base).uploadFromBitmapData(bmp);
			
			mRenderTexture.draw(mBrush);
			//
			
			
		}
		public function drawCaosStars(_x:Number, _y:Number):void{
			
			mBrush.x = _x; 
			mBrush.y = _y;
			mRenderTexture.draw(mBrush);
			
		}
		
        private function onAddedToStage(event:Event):void
        {
			//if I want draw with my hands
			/*var brush:Bitmap = new basicParticle();
			var texture:Texture = Texture.fromBitmap(brush);*/
			//if I want to draw the camera
			var ttt:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight,false);
			var texture:Texture = Texture.fromBitmapData(ttt);
			//
			mBrush = new Image(texture);
			mRenderTexture = new RenderTexture(stage.stageWidth, stage.stageHeight);
			var canvas:Image = new Image(mRenderTexture);
			addChildAt(canvas,0);
			/////
			caosStarMarkerTexture = Texture.fromBitmap(caosStarMarkerBMP);
			caosStarMarkerImage = new Image(caosStarMarkerTexture);
			caosStarMarkerImage.pivotX = caosStarMarkerImage.width >> 1; 
			caosStarMarkerImage.pivotY = caosStarMarkerImage.height >> 1;
			addChild(caosStarMarkerImage);
			caosStarMarkerImage.alpha = 0.5;
			caosStarMarkerImage.visible = false;
			caosStarMarkerImage.y = stage.stageHeight - caosStarMarkerImage.height/2;
			caosStarMarkerImage.x = stage.stageWidth/2;
			//
			symbolTexture = Texture.fromBitmap(symbolBMP);
			symbolImage = new Image(symbolTexture);
			symbolImage.pivotX = symbolImage.width >> 1; 
			symbolImage.pivotY = symbolImage.height >> 1;
			addChild(symbolImage);
			symbolImage.y = stage.stageHeight/2;
			symbolImage.x = stage.stageWidth/2;
						
			rebuleCaosStarTexture = Texture.fromBitmap(rebuleCaosStarBMP);
			rebuleCaosStar = new Image(rebuleCaosStarTexture);
			rebuleCaosStar.pivotX = rebuleCaosStar.width >> 1; 
			rebuleCaosStar.pivotY = rebuleCaosStar.height >> 1;
			//
			timelineHeart = new TimelineMax({repeat:-1, yoyo:true});
			//timelineHeart.append( TweenMax.to(rebuleCaosStar, velo, {scaleX:1, scaleY:1, ease:Expo.easeOut}));
			timelineHeart.append( TweenMax.to(rebuleCaosStar, velo, {scaleX:1.1, scaleY:1.1, ease:Expo.easeIn, onStart:playBeat, onStartParams:[tuSound], onComplete:playBeat, onCompleteParams:[tumSound]}));
			//timelineHeart.append( TweenMax.to(rebuleCaosStar, velo, {scaleX:1, scaleY:1, ease:Expo.easeOut}));
			timelineHeart.stop();
			//
			rebuleCaosStarHolder.pivotX = rebuleCaosStarHolder.width >> 1; 
			rebuleCaosStarHolder.pivotY = rebuleCaosStarHolder.height >> 1;
			rebuleCaosStarHolder.x = stage.stageWidth/2;
			rebuleCaosStarHolder.y = stage.stageHeight/2;
			rebuleCaosStarHolder.addChild(rebuleCaosStar);
						
			rebuleParticlesRight = new PDParticleSystem(psRebuleConfig, rebuleTexture);
			addChild(rebuleParticlesRight);
			rebuleParticlesLeft = new PDParticleSystem(psRebuleConfig, rebuleTexture);
			addChild(rebuleParticlesLeft);
			////
			righHandParticles = new PDParticleSystem(psConfig, psTexture);
			addChild(righHandParticles);
			leftHandParticles = new PDParticleSystem(psConfig, psTexture);
			addChild(leftHandParticles);
			//
			anyRight = righHandParticles;
			anyLeft = leftHandParticles;
			//
			XIQUAL_UDINBAK_Particles = new PDParticleSystem(fireConfig, basicTexture);
			XIQUAL_UDINBAK_Particles.x = stage.stageWidth/2;
			XIQUAL_UDINBAK_Particles.y = stage.stageHeight/2;
			addChild(XIQUAL_UDINBAK_Particles);
			XIQUAL_UDINBAK_Particles.emitterXVariance = 0;
			//XIQUAL_UDINBAK_Particles.rotation = deg2rad(90);
				
			
			UZARFE_DKYENG_Particles = new PDParticleSystem(fireConfig, basicTexture);
			UZARFE_DKYENG_Particles.x = stage.stageWidth/2;
			UZARFE_DKYENG_Particles.y = stage.stageHeight/2;
			addChild(UZARFE_DKYENG_Particles);
			UZARFE_DKYENG_Particles.emitterXVariance = 0;
			UZARFE_DKYENG_Particles.rotation = deg2rad(90);
			
			KUDEX_EACHT_Particles = new PDParticleSystem(fireConfig, basicTexture);
			KUDEX_EACHT_Particles.x = stage.stageWidth/2;
			KUDEX_EACHT_Particles.y = stage.stageHeight/2;
			addChild(KUDEX_EACHT_Particles);
			KUDEX_EACHT_Particles.emitterXVariance = 0;
			KUDEX_EACHT_Particles.rotation = deg2rad(180);
			
			ASHARA_DIJOW_Particles = new PDParticleSystem(fireConfig, basicTexture);
			ASHARA_DIJOW_Particles.x = stage.stageWidth/2;
			ASHARA_DIJOW_Particles.y = stage.stageHeight/2;
			addChild(ASHARA_DIJOW_Particles);
			ASHARA_DIJOW_Particles.emitterXVariance = 0;
			ASHARA_DIJOW_Particles.rotation = deg2rad(45);
			
			THALDOMA_NOBO_Particles = new PDParticleSystem(fireConfig, basicTexture);
			THALDOMA_NOBO_Particles.x = stage.stageWidth/2;
			THALDOMA_NOBO_Particles.y = stage.stageHeight/2;
			addChild(THALDOMA_NOBO_Particles);
			THALDOMA_NOBO_Particles.emitterXVariance = 0;
			THALDOMA_NOBO_Particles.rotation = deg2rad(-45);
			
			//righHandParticles.scaleX = righHandParticles.scaleY = leftHandParticles.scaleX = leftHandParticles.scaleY = 0.6;
			
			////
			//stage.addEventListener(TouchEvent.TOUCH, onTouch);
            Starling.juggler.add(righHandParticles);
			Starling.juggler.add(leftHandParticles);
			Starling.juggler.add(rebuleParticlesLeft);
			Starling.juggler.add(rebuleParticlesRight);
			Starling.juggler.add(XIQUAL_UDINBAK_Particles);
			Starling.juggler.add(UZARFE_DKYENG_Particles);
			Starling.juggler.add(KUDEX_EACHT_Particles);
			Starling.juggler.add(ASHARA_DIJOW_Particles);
			Starling.juggler.add(THALDOMA_NOBO_Particles);
			//
			particlesDict["XIQUAL_UDINBAK_Gesture"] = XIQUAL_UDINBAK_Particles;
			particlesDict["UZARFE_DKYENG_Gesture"] = UZARFE_DKYENG_Particles;
			particlesDict["KUDEX_EACHT_Gesture"] = KUDEX_EACHT_Particles;
			particlesDict["ASHARA_DIJOW_Gesture"] = ASHARA_DIJOW_Particles;
			particlesDict["THALDOMA_NOBO_Gesture"] = THALDOMA_NOBO_Particles;
			
			rebuleDict["right"] = rebuleParticlesRight;
			rebuleDict["left"] = rebuleParticlesLeft;
						
			/*enlargeArrow("UZARFE_DKYENG_Gesture", 1);
			enlargeArrow("KUDEX_EACHT_Gesture", 3);
			enlargeArrow("ASHARA_DIJOW_Gesture", 5);
			enlargeArrow("THALDOMA_NOBO_Gesture", 7);*/
						
			/*righHandParticles.start();
			leftHandParticles.start();
			XIQUAL_UDINBAK_Particles.start();
			UZARFE_DKYENG_Particles.start();
			KUDEX_EACHT_Particles.start();
			ASHARA_DIJOW_Particles.start();
			THALDOMA_NOBO_Particles.start();*/
			
			//TweenLite.delayedCall( 2, startHands,[300,300,600,300] );
			elbowGesture.addOnce(startHands);
			//
			XIQUAL_UDINBAK_Gesture.addOnce(startArrows);
			//
			UZARFE_DKYENG_Gesture.addOnce(enlargeArrow);
			KUDEX_EACHT_Gesture.addOnce(enlargeArrow);
			ASHARA_DIJOW_Gesture.addOnce(enlargeArrow);
			THALDOMA_NOBO_Gesture.addOnce(enlargeArrow);
			//
			ONGATHAWAS_Gesture.addOnce(explodeCaosStar);
			
			//showRebuleCaosStar();
			
        }
		
		//handleHands
		public function startHands(tweenRightX:Number,tweenRightY:Number, tweenLeftX:Number,tweenLeftY:Number):void{
			anyRight.emitterX = 0;
			anyRight.emitterY = 0;
			anyLeft.emitterX = stage.stageWidth;
			anyLeft.emitterY = 0;
			anyRight.start();
			anyLeft.start();
			TweenLite.to(anyRight, .75, {emitterX:tweenRightX, emitterY:tweenRightY, onComplete:startMovingHands});
			TweenLite.to(anyLeft, .75, {emitterX:tweenLeftX, emitterY:tweenLeftY});
			//
			playBeat(fireball);
		}
		
		public var isRebule:Boolean = false;
		public function stopHands():void{
			anyRight.stop();
			anyLeft.stop();
			moveHandsSignal.remove(moveHands);
			//
			anyRight = rebuleParticlesRight ;
			anyLeft = rebuleParticlesLeft;
			isRebule = true;
			//
			if(toFinish){
				timelineHeart.stop();
				//AEPALIZAGE_Gesture.addOnce(finishVortex);
				TweenLite.delayedCall( 10, AEPALIZAGE_Gesture.addOnce,[finishVortex] );
			}
		}
		public function finishVortex(str:String):void{
			TweenLite.to(rebuleCaosStarHolder, 7.5, {alpha:0, scaleX:.1, scaleY:.1, onComplete:theVortexEnd, ease:Bounce.easeIn});
		}
		public var music:trilha = new trilha();
		public function theVortexEnd():void{
			theEndSignal.dispatch();
			
		}
		public function startMovingHands():void{
			moveHandsSignal.add(moveHands);
			//
			if(isRebule)TweenLite.delayedCall( 3, XIQUAL_UDINBAK_Gesture.addOnce,[countRebule] );
					
		}
		public var howManyRebules:int = 0;
		public var toFinish:Boolean = false;
		public function countRebule(str:String):void{
			caosStarMarkerImage.visible = true;
			switch(howManyRebules){
			case 0:
			case 1:
			case 2:
				hardIncreaseRebule();
				TweenLite.delayedCall( 10, XIQUAL_UDINBAK_Gesture.addOnce,[countRebule] );
				timeScale+=1;
				timelineHeart.timeScale(timeScale);
				caosStarMarkerImage.rotation = deg2rad(44*howManyRebules);
				break;
			case 3:
				hardIncreaseRebule();
				toFinish = true;
				TweenLite.delayedCall( 15, stopHands);
				caosStarMarkerImage.visible = false;
				break;
			//
			
			}
			
			howManyRebules++;
			//trace("howManyRebule: " + howManyRebules);
			
		}
		public function hardIncreaseRebule():void{
			for each (var particle:PDParticleSystem in rebuleDict){
				
				//
				//particle.speedVariance+=_sV
				//
				//0-10
				particle.lifespan += 1;
				//0-2000
				particle.maxNumParticles += 150;
				//0-512
				particle.startSize += 40;
				
			}
		}
		public function explodeRebule():void{
			var spr:Sprite = new Sprite();
			TweenLite.to(spr, 10, {x:500, onUpdate:increaseRebule});
			
		}
		
		private var liferebule:Number = 0;
		private var maxParsrebule:Number = 0;
		public function increaseRebule():void{
			liferebule+=0.1;
			maxParsrebule+=15;
			for each (var particle:PDParticleSystem in rebuleDict){
				
				//
				//particle.speedVariance+=_sV
				//
				//0-10
				particle.lifespan += _sV/100;
				//0-2000
				particle.maxNumParticles += 2;
				//0-512
				particle.startSize += maxParsrebule/10;
				
			}
		}
		
		
		
		
		public function moveHands(tweenRightX:Number,tweenRightY:Number, tweenLeftX:Number,tweenLeftY:Number):void{
			anyRight.emitterX = tweenRightX;
			anyRight.emitterY = tweenRightY;
			anyLeft.emitterX = tweenLeftX;
			anyLeft.emitterY = tweenLeftY;			
		}
		
		//handleArrows
		public function startArrows(particles:String):void{
			XIQUAL_UDINBAK_Particles.start();
			UZARFE_DKYENG_Particles.start();
			KUDEX_EACHT_Particles.start();
			ASHARA_DIJOW_Particles.start();
			THALDOMA_NOBO_Particles.start();
			//
			playBeat(udinbakSound);
		}
		public function showArrow(particles:String):void{
			particlesDict[particles].start();
		}		
		public function enlargeArrow(particles:String, _delay:Number = 0, func:Function = null, funcParams:Array = null):void{
			particlesDict[particles].start();
			TweenLite.to(particlesDict[particles], 1, {emitterXVariance:arrowSize, delay:_delay, onComplete:func, onCompleteParams:funcParams});
			playBeat(blade);
		}
		public var timeToExplode:Number = 15;
		public function explodeCaosStar(particles:String):void{
			var spr:Sprite = new Sprite();
			TweenLite.to(spr, timeToExplode, {x:500, onUpdate:rotateStar, onComplete:showRebuleCaosStar});
			TweenLite.delayedCall( timeToExplode/2, stopHands);
		}
		private var rot:Number = 0;
		private var _sV:Number = 0;
		public function rotateStar():void{
			rot+=0.2;
			_sV+=0.2;
			for each (var particle:PDParticleSystem in particlesDict){
				particle.rotation-=deg2rad(rot);
				//
				particle.speedVariance+=_sV
				//
				//particle.lifespan += _sV;
				//particle.maxNumParticles += 2;
				particle.startSize += _sV/10;
					
			}
		}
		private var timeScale:Number = 1.5;
		public function showRebuleCaosStar():void{
			for each (var particle:PDParticleSystem in particlesDict){
				particle.stop();
				
			}
			playBeat(explosion);
			addChildAt(rebuleCaosStarHolder,0);
			rebuleCaosStarHolder.alpha = 0;
			TweenLite.fromTo(rebuleCaosStarHolder, timeToExplode/1.5, {alpha:0, scaleX:.1, scaleY:.1}, {alpha:1, scaleX:1, scaleY:1, onComplete:returnHands});
			//TweenMax.to(rebuleCaosStar, 1.1, {scaleX:1.1, scaleY:1.1, repeat:-1, yoyo:true, repeatDelay:0});
			timelineHeart.play();
			timelineHeart.timeScale(timeScale);
			
		}
		public function returnHands():void{
			elbowGesture.addOnce(startHands);
		}
        
        private function onRemovedFromStage(event:Event):void
        {
            stage.removeEventListener(TouchEvent.TOUCH, onTouch);
            Starling.juggler.remove(anyRight);
        }
        
       
		private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(stage);
            if (touch && touch.phase != TouchPhase.MOVED)
            {
				//moveHands(touch.globalX,touch.globalY, touch.globalX+250,touch.globalY);
				
				/*anyRight.lifespan += 0.1;
				anyRight.maxNumParticles += 20;
				anyRight.startSize += 1;*/
				
				//rot+=0.2;
				//rotateStar(rot, rot);


				
            }
        }
		private var tocou:Boolean = false;
		private function playBeat(bum:Sound):void{
			//bumChannel = bum.play(0,0);
			bum.play();
			
		}
		private function playBum(bum:Sound, bumChannel:SoundChannel, bumChannelNao:SoundChannel, bumChannelNao2:SoundChannel):void{
			if(tocou == false){
				SoundMixer.stopAll();
				bumChannel = bum.play(0, 999999);
				/*bumChannelNao.stop();
				bumChannelNao2.stop();*/
				tocou = true;
			}
		}
		public static function get current():Demo {
			if (Starling.current == null || Starling.current.stage == null ||
				Starling.current.stage.numChildren == 0) return null;
			return Starling.current.stage.getChildAt(0) as Demo;
		}
		
    }
}