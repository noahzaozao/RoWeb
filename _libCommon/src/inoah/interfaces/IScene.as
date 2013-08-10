package inoah.interfaces
{
    import starling.display.DisplayObjectContainer;

    public interface IScene
    {
        function tick( delta:Number ):void;
        function initScene( container:DisplayObjectContainer , mapInfo:IMapInfo ):void;
    }
}