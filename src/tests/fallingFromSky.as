package tests
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flintparticles.common.counters.*;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.*;
	import org.flintparticles.twoD.actions.*;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.*;
	import org.flintparticles.twoD.renderers.*;
	import org.flintparticles.twoD.zones.*;
	
	public class fallingFromSky extends Sprite
	{
		[Embed(source="assets/estrela.png")]
		protected static const caosStar:Class;
		public var caosStarBMP:Bitmap = new caosStar();
		
		[Embed(source="assets/surprise.png")]
		protected static const theSurprise:Class;
		public var theSurpriseBMP:Bitmap = new theSurprise();
		
		private var topY:Number = -200;
		
		private var emitter:Emitter2D;
		private var steady:Steady = new Steady( 1 );
		private var drift:RandomDrift = new RandomDrift( 200, 200 );
		public function fallingFromSky(_stageWidth:Number, _stageHeight:Number)
		{
			emitter = new Emitter2D();
			
			//var renderer:DisplayObjectRenderer = new DisplayObjectRenderer();
			var renderer:BitmapRenderer = new BitmapRenderer( new Rectangle(  0, 0, _stageWidth, _stageHeight ) );
			renderer.addFilter( new BlurFilter( 2, 2, 1 ) );
			//renderer.addFilter( new ColorMatrixFilter( [ 1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.95,0 ] ) );
			
			addChild( renderer );
			renderer.addEmitter( emitter );
			
			emitter.counter = steady;
			
			//
			var imgClass:SharedImage = new SharedImage( caosStarBMP  );
			//var imgClass:SharedImage = new SharedImage( RadialDot, [2] );
			emitter.addInitializer( imgClass );
			//
			emitter.addInitializer( new ColorInit( 0xFFFFCC00, 0xFFFF5678 ) );
			//emitter.addInitializer( new Velocity( new DiscZone( new Point( 0, 0 ), 350, 200 ) ) );
			//emitter.addInitializer( new Lifetime( 0.2, 0.4 ) );
			//
			var zone:LineZone = new LineZone( new Point( -100, topY ), new Point( _stageWidth+30, -30 ) );
			var position:Position = new Position( zone );
			emitter.addInitializer( position );
			//
			var zone2:PointZone = new PointZone( new Point( 0, 65 ) );
			var velocity:Velocity = new Velocity( zone2 );
			emitter.addInitializer( velocity );
			//
			var move:Move = new Move();
			emitter.addAction( move );
			//
			var dzone:RectangleZone = new RectangleZone( -100, topY, _stageWidth+30, _stageHeight+30 );
			var deathZone:DeathZone = new DeathZone( dzone, true );
			emitter.addAction( deathZone );
			//
			var scaleImage:ScaleImageInit = new ScaleImageInit( 0.5, 2 );
			emitter.addInitializer( scaleImage );
			//
			
			emitter.addAction( drift );
			//
			emitter.start();
			//emitter.runAhead( 10 );
			//
			theSurpriseBMP.x = (_stageWidth - theSurpriseBMP.width) >> 1;
			theSurpriseBMP.y = (_stageHeight - theSurpriseBMP.height);
			addChild(theSurpriseBMP);
			//
			addEventListener(MouseEvent.CLICK, fim, false, 0, true);
			TweenLite.delayedCall( timer, increaseCounter );
		}
		private var keep:Boolean = true;
		private var timer:uint = 10;
		public function increaseCounter():void{
			steady.rate += 1;
			trace(steady.rate);
			if(steady.rate<35){
				TweenLite.delayedCall( timer, increaseCounter );
			}else{
				drift.driftY = 15;
			}
		}
		public function fim(e:MouseEvent):void{
			stopSky();
		}
		public function stopSky():void{
			//emitter.stop();
			emitter.counter = new Steady( 0 );
		}
	}
}