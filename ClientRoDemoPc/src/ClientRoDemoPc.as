package
{
    import com.inoah.ro.mediators.GameMediator;
    
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    import inoah.game.Global;
    import inoah.game.interfaces.ITickable;
    
    import pureMVC.interfaces.IFacade;
    import pureMVC.interfaces.IMediator;
    import pureMVC.patterns.facade.Facade;
    
    [SWF(width="960",height="640",frameRate="60",backgroundColor="#000000")]
    public class ClientRoDemoPc extends VersionSprite
    {
        private var _lastTimeStamp:Number;
        private var _gameMediator:ITickable;
        
        public function ClientRoDemoPc()
        {
            addEventListener( Event.ADDED_TO_STAGE , init );
        }
        
        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE , init );
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            Global.SCREEN_W = stage.stageWidth;
            Global.SCREEN_H = stage.stageHeight;
            
            var facade:IFacade = Facade.getInstance();
            _gameMediator = new GameMediator( stage , this );
            facade.registerMediator( _gameMediator as IMediator );
            
            _lastTimeStamp = new Date().time;
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
        }
        
        protected function onEnterFrameHandler( e:Event):void
        {
            var currentTimeStamp:Number = new Date().time;
            var delta:Number = (currentTimeStamp - _lastTimeStamp)/1000;
            _lastTimeStamp = currentTimeStamp;
            
            if( _gameMediator )
            {
                _gameMediator.tick( delta );
            }
        }
    }
}