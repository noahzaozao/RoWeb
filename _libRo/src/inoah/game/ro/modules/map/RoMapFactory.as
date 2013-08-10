package inoah.game.ro.modules.map
{
    import inoah.core.GameCamera;
    import inoah.game.ro.modules.map.view.BaseScene;
    import inoah.game.ro.modules.map.view.mediators.BaseSceneMediator;
    import inoah.interfaces.ICamera;
    import inoah.interfaces.IMapFactory;
    import inoah.interfaces.IScene;
    import inoah.interfaces.ISceneMediator;
    
    import robotlegs.bender.framework.api.IInjector;
    
    public class RoMapFactory implements IMapFactory
    {
        [Inject]
        public var injector:IInjector;
        
        public function RoMapFactory()
        {
        }
        
        public function newMap( mapId:int ):IScene
        {
            var scene:BaseScene = new BaseScene();
            injector.injectInto(scene);
            injector.map(IScene).toValue(scene);
            return scene;
        }
        
        public function newMapMediator( mapId:int ):ISceneMediator
        {
            var sceneMediator:BaseSceneMediator = new BaseSceneMediator();
            injector.injectInto(sceneMediator);
            injector.map(ISceneMediator).toValue(sceneMediator);
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