package com.godstroke.erenTank {
	import com.iainlobb.Gamepad;
	import com.iainlobb.GamepadView;

	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.Collada;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;

	import flash.events.Event;

	/**
	 * @author godstroke
	 */
	
	public class Main extends BasicView {
		private var turret : Collada;
		private var tankPivot:DisplayObject3D;
		private var terrain : Plane;
		private var hull:Collada;
		
		
		
		private var $camera:Camera3D;
		private var gamepad:Gamepad;
		private var gamepadView:GamepadView;
		private var gamepad_turret:Gamepad;

		public function Main() {
			super(400,400,true,false,CameraType.TARGET);
			
			$camera = cameraAsCamera3D;
			
			tankPivot = new DisplayObject3D(); scene.addChild(tankPivot);
			
			turret = new Collada("erentank_head.dae"); tankPivot.addChild(turret);
			hull = new Collada("erentank_hull.dae"); tankPivot.addChild(hull);
			
			$camera.focus = 20;
			$camera.target= tankPivot;
			
			var segs:Number = 40;
			var grass:BitmapFileMaterial = new BitmapFileMaterial("grass.jpg",true);
			grass.precise = true;
			grass.tiled = true;
			grass.maxV = grass.maxU = 1;
			
			
			
			var scale:Number = 2000;
			terrain = new Plane(grass,scale,scale,segs,segs);
			
			terrain.pitch(90);
			scene.addChild(terrain);
			
			$camera.y = 250;
			$camera.x = 520;
			
			camera.x = turret.x;
			camera.z = turret.z + 300;
			
			
			// Interactions
			gamepad = new Gamepad(stage,true);
			gamepad.useWASD();
			
			//gamepad_turret = new Gamepad(stage, true);
			

			gamepadView = new GamepadView();
			gamepadView.init(gamepad,0x1b1b1b);
			addChild(gamepadView);
			
			gamepadView.x =  gamepadView.y =50;
			
			startRendering();
		}

		override protected function onRenderTick(event:Event = null):void {
			
			
			tankPivot.localRotationY+= -gamepad.x;
			var ang:Number = -tankPivot.localRotationY * (Math.PI / 180);
			
			//tankPivot.z+=gamepad.y*5;			tankPivot.x += Math.sin(ang) * gamepad.y * 8;
			tankPivot.z += Math.cos(ang) * gamepad.y * 8;
			
			renderer.renderScene(scene, _camera, viewport);
		}
	}
}
