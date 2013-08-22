package inoah.interfaces.map
{
    import inoah.interfaces.ICamera;

    public interface IMapFactory
    {
        function newScene( mapId:int ):IScene;
        function newSceneMediator( mapId:int , mapType:int ):ISceneMediator;
        function newCamera():ICamera;
    }
}