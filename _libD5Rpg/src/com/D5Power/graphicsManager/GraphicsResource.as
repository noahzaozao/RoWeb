package com.D5Power.graphicsManager
{
    import flash.display.BitmapData;
    
    public class GraphicsResource extends GraphicsBasic
    {
        public static function get MIRROR_EXT():String
        {
            return MIRROR;
        }
        public function GraphicsResource(data:*,resname:String='', _framesTotal:int = 1,_framesLayer:int=1,
                                         _fps:Number = 0, mirror:Boolean=false)
        {
            super(mirror);
        }
        
        public static function get DEFAULT_BD():BitmapData
        {
            return GraphicsBasic.DEFAULT_BD;
        }
        
        public function get resName():String
        {
            return getGD(_nowAction).resNameList[0];
        }
    }
}