package inoah.game.ro.modules.map
{
    import inoah.core.GameCamera;
    import inoah.game.ro.modules.map.view.BaseScene;
    import inoah.game.ro.modules.map.view.mediators.BaseSceneMediator;
    import inoah.game.ro.modules.map.view.mediators.BattleSceneMediator;
    import inoah.interfaces.ICamera;
    import inoah.interfaces.map.IBattleSceneMediator;
    import inoah.interfaces.map.IMapFactory;
    import inoah.interfaces.map.IScene;
    import inoah.interfaces.map.ISceneMediator;
    
    import robotlegs.bender.framework.api.IInjector;
    
    public class RoMapFactory implements IMapFactory
    {
        [Inject]
        public var injector:IInjector;
        
        public function RoMapFactory()
        {
        }
        
        public function newScene( mapId:int ):IScene
        {
            var scene:BaseScene = new BaseScene();
            injector.injectInto(scene);
            injector.map(IScene).toValue(scene);
            return scene;
        }
        
        public function newSceneMediator( mapId:int , mapType:int ):ISceneMediator
        {
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
            }
            injector.injectInto(sceneMediator);
            sceneMediator.initialize();
            return sceneMediator;
        }
        
        public function newCamera():ICamera
        {
            var camera:GameCamera = new GameCamera();
            injector.injectInto(camera);
            injector.map(ICamera).toValue(camera);
            return camera;
        }
    }
}