package inoah.game.ro.modules.player
{
    
    import inoah.interfaces.IPlayerController;
    import inoah.interfaces.IPlayerFactory;
    
    import robotlegs.bender.framework.api.IInjector;
    
    public class RoPlayerFactory implements IPlayerFactory
    {
        [Inject]
        public var injector:IInjector;
        
        public function RoPlayerFactory()
        {
        }
        
//        public function newPlayer():IPlayerController
//        {
//            var player:PlayerObject = PlayerObject();
//            return null;
//        }
        
        public function newPlayerController():IPlayerController
        {
            var playerController:PlayerController = new PlayerController();
            injector.injectInto(playerController);
            injector.map(IPlayerController).toValue(playerController);
            return playerController;
        }
        public function newTiledPlayerController():IPlayerController
        {
            var playerController:TiledPlayerController = new TiledPlayerController();
            injector.injectInto(playerController);
            injector.map(IPlayerController).toValue(playerController);
            return playerController;
        }
    }
}