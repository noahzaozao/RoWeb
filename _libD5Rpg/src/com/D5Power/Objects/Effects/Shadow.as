package com.D5Power.Objects.Effects
{
    import com.D5Power.Objects.GameObject;
    import com.D5Power.Objects.MovieObject;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.GradientType;
    import flash.display.Shape;
    import flash.geom.Matrix;
    
    /**
     * 影子
     */ 
    public class Shadow
    {
        public var ypos:Number=0;
        protected var _alpha:Number=0;
        protected var _resource:Bitmap;
        protected var _target:GameObject;
        
        /**
         * @param	target	影子的主人
         * @param	h		影子到素材底部偏移距离
         * @param	zoom	缩放比，可根据素材尺寸进行影子的缩放调整
         * @param	alpha	透明的最大值
         */ 
        public function Shadow(target:MovieObject,h:Number=0,zoom:Number=.8,alpha:Number=0.6)
        {
            ypos = h;
            
            _alpha = alpha;
            _target = target;
            buildShadow(target.graphicsRes.frameWidth*zoom);
        }
        
        protected function buildShadow(width:Number):void
        {
            width = int(width);
            
            if(Global.resPool.getResource('D5Shadow_'+width)==undefined)
            {
                var sp:Shape = new Shape();
                var matr:Matrix = new Matrix();
                matr.createGradientBox(width, width);
                sp.graphics.beginGradientFill(GradientType.RADIAL,[0,0],[_alpha,0],[127,255],matr);
                sp.graphics.drawRect(0,0,width,width);
                sp.graphics.endFill();
                
                
                var buff:BitmapData=new BitmapData(sp.width,sp.height,true,0x00000000);
                buff.draw(sp,new Matrix(1,0,0,.3));
                sp.graphics.clear();
                sp=null;
                
                Global.resPool.addResource('D5Shadow_'+width,buff);
            }
            _resource = new Bitmap(Global.resPool.getResource('D5Shadow_'+width));
            _resource.x = -_resource.width*.5;
            _resource.y = ypos;
            _target.addChild(_resource);
            _target.setChildIndex(_resource,0);
        }
    }
}