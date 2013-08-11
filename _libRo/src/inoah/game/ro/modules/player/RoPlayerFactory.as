package inoah.game.ro.modules.player
{
    import inoah.game.ro.objects.PlayerObject;
    import inoah.interfaces.character.IPlayerObject;
    import inoah.interfaces.factory.IPlayerFactory;
    
    import robotlegs.bender.framework.api.IInjector;
    
    public class RoPlayerFactory implements IPlayerFactory
    {
        [Inject]
        public var injector:IInjector;
        
        public function RoPlayerFactory()
        {
        }
        
        public function newPlayerObject():IPlayerObject
        {
            var player:PlayerObject = new PlayerObject();
            
            return player;
        }
    }
}