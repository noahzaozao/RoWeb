package inoah.interfaces.map
{
    
    import flash.geom.Point;
    
    import starling.display.DisplayObjectContainer;
    import starling.textures.TextureAtlas;

    public interface IScene
    {
        function tick( delta:Number ):void;
        function initScene( container:DisplayObjectContainer , mapInfo:IMapInfo ):void;
        function GridToView( xpos:int, ypos:int ):Point;
        function ViewToGrid( xpos:Number, ypos:Number ):Point;
        function get roadMap():Vector.<Point>;
        function get currentTextureAtlasList():Vector.<TextureAtlas>;
    }
}