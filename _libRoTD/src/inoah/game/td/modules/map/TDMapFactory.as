package inoah.game.td.modules.map
{
    import inoah.game.ro.modules.map.RoMapFactory;
    import inoah.game.ro.modules.map.view.mediators.BaseSceneMediator;
    import inoah.game.ro.modules.map.view.mediators.BattleSceneMediator;
    import inoah.game.td.modules.map.view.mediators.TDSceneMediator;
    import inoah.interfaces.map.IBattleSceneMediator;
    import inoah.interfaces.map.ISceneMediator;
    import inoah.interfaces.map.ITDSceneMediator;
    
    public class TDMapFactory extends RoMapFactory
    {
        public function TDMapFactory()
        {
        }
        
        override public function newSceneMediator(mapId:int, mapType:int):ISceneMediator
        {
            //            super.newSceneMediator(
            var sceneMediator:BaseSceneMediator;
            switch( mapType )
            {
                case 0:
                {
                    sceneMediator = new BaseSceneMediator();
                    injector.map(ISceneMediator).toValue(sceneMediator);
                    break;
                }
                case 1:
                {
                    sceneMediator = new BattleSceneMediator();
                    injector.map(ISceneMediator).toValue(sceneMediator);
                    injector.map(IBattleSceneMediator).toValue(sceneMediator);
                    break;
                }
                case 2:
                {
                    sceneMediator = new TDSceneMediator();
                    injector.map(ISceneMediator).toValue(sceneMediator);
                    injector.map(ITDSceneMediator).toValue(sceneMediator);
                    break;
                }
            }
            injector.injectInto(sceneMediator);
            sceneMediator.initialize();
            return sceneMediator;
        }
    }
}