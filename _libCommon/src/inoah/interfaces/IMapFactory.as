package inoah.interfaces
{
    public interface IMapFactory
    {
        function newMap( mapId:int ):IScene;
        function newSceneMediator( mapId:int ):ISceneMediator;
        function newBattleSceneMediator( mapId:int ):IBattleSceneMediator;
        function newCamera():ICamera;
    }
}