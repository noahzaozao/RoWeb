package inoah.interfaces.map
{
    import inoah.interfaces.ICamera;

    public interface IMapFactory
    {
        function newScene( mapId:int ):IScene;
        function newSceneMediator( mapId:int ):ISceneMediator;
        function newBattleSceneMediator( mapId:int ):IBattleSceneMediator;
        function newCamera():ICamera;
    }
}