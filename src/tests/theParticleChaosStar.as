package tests
{
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
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.PixelRenderer;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.LinearDrag;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.BitmapDataZone;
	import org.flintparticles.twoD.zones.DiscZone;
	
	public class theParticleChaosStar extends Sprite
	{
		[Embed(source="assets/estrela.png")]
		protected static const caosStar:Class;
		public var caosStarBMP:Bitmap = new caosStar();
		
		[Embed(source="assets/estrelaBig.png")]
		protected static const caosStarBig:Class;
		public var caosStarBigBMP:Bitmap = new caosStarBig();
		
		private var topY:Number = -200;
		
		public function theParticleChaosStar(_stageWidth:Number, _stageHeight:Number)
		{
			super();
			//
			var emitter:Emitter2D = new Emitter2D();
			
			emitter.counter = new Blast( 4000 );
			
			emitter.addInitializer( new ColorInit( 0xFFFF3300, 0xFFFFFF00 ) );
			emitter.addInitializer( new Lifetime( 6 ) );
			emitter.addInitializer( new Position( new DiscZone( new Point( 0, 0 ), 10 ) ) );
			emitter.addInitializer( new Velocity( new BitmapDataZone( caosStarBigBMP.bitmapData ) ) );
			
			emitter.addAction( new Age( Quadratic.easeIn ) );
			emitter.addAction( new Fade( 1.0, 0 ) );
			emitter.addAction( new Move() );
			emitter.addAction( new LinearDrag( 0.5 ) );
			emitter.addAction( new Accelerate( 0, 70 ) );
			
			emitter.addEventListener( EmitterEvent.EMITTER_EMPTY, restart, false, 0, true );
			
			var renderer:PixelRenderer = new PixelRenderer( new Rectangle( 0, 0, _stageWidth, _stageHeight ) );
			renderer.addFilter( new BlurFilter( 2, 2, 1 ) );
			renderer.addFilter( new ColorMatrixFilter( [ 1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.96,0 ] ) );
			renderer.addEmitter( emitter );
			addChild( renderer );
			
			/*emitter.x = 250;
			emitter.y = 300;*/
			emitter.start( );
		}
		//
		public function restart( ev:EmitterEvent ):void
		{
			Emitter2D( ev.target ).start();
		}
	}
}