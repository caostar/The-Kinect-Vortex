package effects
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flintparticles.common.actions.*;
	import org.flintparticles.common.counters.*;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.*;
	import org.flintparticles.twoD.actions.*;
	import org.flintparticles.twoD.activities.FollowDisplayObject;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.*;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.zones.*;
	
	public class followHands extends Sprite
	{
		[Embed(source="assets/imgs/estrela.png")]
		protected static const caosStar:Class;
		public var caosStarBMP:Bitmap = new caosStar();
		//
		private var rightHand:Sprite = new Sprite;
		private var leftHand:Sprite = new Sprite;
		//
		private var stageWidth:Number;
		private var stageHeight:Number;
		
		public function followHands(_stageWidth:Number, _stageHeight:Number)
		{
			super();
			//
			stageWidth = _stageWidth;
			stageHeight = _stageHeight
			createFollower(rightHand);
			createFollower(leftHand);
			//
			
			
		}
		public function followHand(rightX:Number, rightY:Number, leftX:Number, leftY:Number) : void
		{
			TweenLite.to(rightHand, 1, {x:rightX, y:rightY, ease:Expo.easeOut});
			
			TweenLite.to(leftHand, 1, {x:leftX, y:leftY, ease:Expo.easeOut});	
			
			//lifetime.maxLifetime+= 0.01;
		}
		private var lifetime:Lifetime = new Lifetime(0.1,1);
		private function createFollower(spr:Sprite):void{
			var emitter:Emitter2D = new Emitter2D();
			emitter.counter=new Steady(50);
			emitter.addInitializer(new SharedImage( caosStarBMP  ));
			//emitter.addInitializer(new SharedImage(new RadialDot(5)));
			//emitter.addInitializer(new ColorInit(0xFF0000, 0xFFFFFF));
			//emitter.addInitializer(new Velocity(new DiscZone(new Point(0, 0), 150, 150)));
			emitter.addInitializer(lifetime);
			emitter.addAction(new Age());
			emitter.addAction(new Move());
			//emitter.addAction(new RotateToDirection());
			//emitter.addAction(new Accelerate(0,100));
			emitter.addAction(new Fade(1,0));
			
			var zone:PointZone = new PointZone( new Point( 0, 0 ) );
			var position:Position = new Position( zone );
			emitter.addInitializer( position );
			//
			var zone2:PointZone = new PointZone( new Point( 0, 150 ) );
			var zone3:DiscZone = new DiscZone(new Point(0, 0), 50, 50);
			var velocity:Velocity = new Velocity( zone3 );
			//
			var drift:RandomDrift = new RandomDrift( 600, 600 );
			emitter.addAction( drift );
			//
			emitter.addInitializer( velocity );
			
			
			
			emitter.start();
			
			var renderer:BitmapRenderer = new BitmapRenderer(new Rectangle(  0, 0, stageWidth, stageHeight ));
			renderer.addFilter( new BlurFilter( 2, 2, 1 ) );
			//renderer.addFilter(new BlurFilter(8,8,1));
			//renderer.addFilter(new ColorMatrixFilter([1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0.92,0]));
			renderer.addEmitter(emitter);
			addChild(renderer);
			emitter.addActivity(new FollowDisplayObject(spr, renderer));
			
			addChild(spr);
			
		}
	}
}