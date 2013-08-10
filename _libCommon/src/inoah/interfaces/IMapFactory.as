package inoah.interfaces
{
    public interface IMapFactory
    {
        function newMap( mapId:int ):IScene;
        function newMapMediator( mapId:int ):ISceneMediator;
        function newCamera():ICamera;
    }
}