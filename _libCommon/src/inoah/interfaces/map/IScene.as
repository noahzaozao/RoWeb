package inoah.interfaces.map
{
    
    import flash.geom.Point;
    
    import inoah.interfaces.IViewObject;
    
    import starling.display.DisplayObjectContainer;

    public interface IScene
    {
        function tick( delta:Number ):void;
        function initScene( container:DisplayObjectContainer , mapInfo:IMapInfo ):void;
        function GridToView( xpos:int, ypos:int ):Point;
        function ViewToGrid( xpos:Number, ypos:Number ):Point;
        function get roadMap():Vector.<Point>;
        function addBuilding( _XX:int , _YY:int , id:int , textureStr:String ):IViewObject;
    }
}