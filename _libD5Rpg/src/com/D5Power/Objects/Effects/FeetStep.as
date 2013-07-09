package com.D5Power.Objects.Effects
{
    import com.D5Power.GMath.GMath;
    import com.D5Power.Objects.GameObject;
    import com.D5Power.graphicsManager.GraphicsResource;
    import com.D5Power.scene.BaseScene;
    
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    /**
     * 脚印
     */ 
    public class FeetStep extends EffectObject
    {
        /**
         * @param		scene
         * @param		sourceName	资源名
         * @param		target		脚印主人
         * @param		lor			是左脚还是右脚
         */ 
        public function FeetStep(scene:BaseScene,sourceName:String,target:GameObject,lor:Boolean)
        {
            super(scene);
            buildFeetStep(sourceName,target,lor);
            _zOrderF=-100;
        }
        
        protected function buildFeetStep(source:String,target:GameObject,lor:Boolean):void
        {
            
            if(Global.resPool.getResource(source)==null)
            {
                Global.resPool.addResource(source,Global.getCharacterRes(source));
            }
            var bitmap:BitmapData = Global.resPool.getResource(source);
            
            var temp:BitmapData = new BitmapData(bitmap.height*1.2,bitmap.height*1.2,true,0x00000000);
            _buffer = new BitmapData(bitmap.height*1.2,bitmap.height*1.2,true,0x00000000);
            
            var rect:Rectangle = lor ? new Rectangle(0,0,bitmap.width/2,bitmap.height) : new Rectangle(bitmap.width/2,0,bitmap.width/2,bitmap.height);
            var fly_x:Number = lor ? rect.width*0.3 : -rect.width*0.3;
            temp.copyPixels(bitmap,rect,new Point(int((temp.width-bitmap.width/2)/2)+fly_x,0));
            
            
            var box:Matrix = new Matrix()
            box.translate(-bitmap.width/2,-bitmap.height/2);
            box.rotate(GMath.A2R(target.Angle));
            box.translate(bitmap.width/2,bitmap.height/2);
            
            _buffer.draw(temp,box,null,null,null,true);
            temp.dispose();
            bitmap=null;
            temp=null;
            
            _graphics = new GraphicsResource(_buffer);
            pos = new Point(target.PosX,target.PosY);
        }
        
        /**
         * 脚印停留时间
         */ 
        public function set stayTime(v:uint):void
        {
            _stayTime = v*Global.TPF;
        }
        
        override protected function enterFrame():Boolean
        {
            if(!super.enterFrame()) return false;
            
            if(_stayTime<=0)
            {
                if(_alpha>0)
                {
                    _alpha-=0.05;
                    _colorPan.alphaMultiplier=0.95;
                }else{
                    _scene.removeObject(this);
                    return true;
                }
            }
            _stayTime--;
            
            return true;
        }
        
        override public function dispose():void
        {
            _graphics = null;
            
            _buffer.dispose();
            _buffer=null;
            
            super.dispose();
        }
    }
}