package com.godstroke.erenTank {
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.Collada;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;

	import flash.events.Event;

	/**
	 * @author godstroke
	 */
	
	
	 
	public class Main extends BasicView {
		private var model : Collada;
		private var terrain : Plane;
		
		public function Main() {
			super(300,300);
			viewport.autoScaleToStage = true;
			
			var ml:MaterialsList = new MaterialsList();
			ml.addMaterial(new ColorMaterial(0xFF0000));
			model = new Collada("erentank.dae",ml);
			
			scene.addChild(model);
			
			startRendering();
			
			var segs:Number = 40;
			var grass:BitmapFileMaterial = new BitmapFileMaterial("grass.jpg",true);
			grass.tiled = true;
			grass.maxV = grass.maxU = 40;
			var scale:Number = 2000;
			terrain = new Plane(grass,scale,scale,segs,segs);
			
			terrain.pitch(90);
			scene.addChild(terrain);
			trace("lol");
			
			camera.y = 150;
			//model.yaw(90);
		}

		override protected function onRenderTick(event:Event = null):void
		{
			renderer.renderScene(scene, _camera, viewport);
			
			camera.x = model.x;
			camera.z = model.z + 300;
		}
	}
}
