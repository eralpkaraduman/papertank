package com.godstroke.erenTank {
	import com.iainlobb.Gamepad;
	import com.iainlobb.GamepadView;

	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.Collada;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.QuadrantRenderEngine;
	import org.papervision3d.view.BasicView;

	import flash.events.Event;

	/**
	 * @author godstroke
	 */

	public class Main extends BasicView {
		private var turret : Collada;
		private var tankPivot : DisplayObject3D;
		private var terrain : Plane;
		private var hull : Collada;

		private var $camera : Camera3D;
		private var gamepad : Gamepad;
		private var gamepadView : GamepadView;
		private var gamepad_turret : Gamepad;
		private var grass : BitmapFileMaterial;
		private var turretController : Gamepad;
		private var turretControllerView : GamepadView;

		public function Main() {
			super(400, 400, false, false, CameraType.TARGET);
			
			$camera = cameraAsCamera3D;
			
			stage.frameRate = 32;
			
			//renderer = new QuadrantRenderEngine(QuadrantRenderEngine.ALL_FILTERS);
			
			tankPivot = new DisplayObject3D(); 
			scene.addChild(tankPivot);
			
			turret = new Collada("erentank_head.dae"); 
			tankPivot.addChild(turret);
			hull = new Collada("erentank_hull.dae"); 
			tankPivot.addChild(hull);
			
			$camera.focus = 15;
			$camera.target = tankPivot;
			
			grass = new BitmapFileMaterial("grass.jpg", true);
			grass.addEventListener(FileLoadEvent.LOAD_COMPLETE, grassLoadedListener);
			
			$camera.y = 250;
			$camera.x = 520;
			
			camera.x = turret.x;
			camera.z = turret.z + 300;
			
			// Interactions
			gamepad = new Gamepad(stage, false);
			gamepad.useWASD();
			turretController = new Gamepad(stage, false)
			turretController.useArrows();
			
			turretControllerView = new GamepadView();
			turretControllerView.init(turretController, 0xFF0000);
			addChild(turretControllerView);
			
			gamepadView = new GamepadView();
			gamepadView.init(gamepad, 0x0000FF);
			addChild(gamepadView);
			turretControllerView.x = 330;
			
			turretControllerView.scaleX = turretControllerView.scaleY = gamepadView.scaleX = gamepadView.scaleY = 0.7;
			gamepadView.x = 120;
			gamepadView.y =  turretControllerView.y = 40;
			
			startRendering();
		}

		private function grassLoadedListener(event : FileLoadEvent) : void {
			var $bmfm : BitmapFileMaterial = event.target as BitmapFileMaterial;
			$bmfm.smooth = true;
			
			var segs : Number = 60;
			var scale : Number = 2000;
			
			terrain = new Plane(grass, scale, scale, segs, segs);
			scene.addChild(terrain);
			
			terrain.pitch(90);
		}

		override protected function onRenderTick(event : Event = null) : void {
			
			turret.localRotationY+= -turretController.x*2;
			turret.localRotationX+= -turretController.y/2;
			var verticalTurretLimit:Number = 5;
			
			if( Math.abs(turret.localRotationX) > verticalTurretLimit ){
				var sign:Number = turret.localRotationX/Math.abs(turret.localRotationX);
				turret.localRotationX = sign*verticalTurretLimit;
			}
			
//			var min:Number = -7;
//			var max:Number = 2;
//			if(turret.localRotationX < min){
//				turret.localRotationX = min;	
//			}else if(turret.localRotationX > max){
//				turret.localRotationX = max;
//			}
			
			tankPivot.localRotationY += -gamepad.x * 1.5;
			var ang : Number = -tankPivot.localRotationY * (Math.PI / 180);
			
			//tankPivot.z+=gamepad.y*5;			tankPivot.x += Math.sin(ang) * gamepad.y * 11;
			tankPivot.z += Math.cos(ang) * gamepad.y * 11;
			
			renderer.renderScene(scene, _camera, viewport);
		}
	}
}
