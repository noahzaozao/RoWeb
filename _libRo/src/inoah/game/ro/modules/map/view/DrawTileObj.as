package inoah.game.ro.modules.map.view
{
    import flash.geom.Point;
    
    import starling.display.Image;
    import starling.textures.RenderTexture;

    public class DrawTileObj
    {
        public var textureIndex:int;
        public var mapDataArr:Vector.<uint>;
        public var bw:int;
        public var bh:int;
        public var w:int;
        public var h:int;
        public var pointList:Vector.<Point>;
        public var tmpRenderTexture:Vector.<RenderTexture>;
        public var i:int;
        public var j:int;
        public var image:Image;
        
        public function DrawTileObj()
        {
        }
    }
}