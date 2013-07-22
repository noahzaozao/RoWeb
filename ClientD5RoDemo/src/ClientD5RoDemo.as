package
{
    import com.inoah.ro.RoGlobal;
    import com.inoah.ro.interfaces.ITickable;
    import com.inoah.ro.mediators.GameMediator;
    
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    import as3.interfaces.IFacade;
    import as3.interfaces.IMediator;
    import as3.patterns.facade.Facade;
    
    [SWF(width="960",height="640",frameRate="60",backgroundColor="#000000")]
    public class ClientD5RoDemo extends VersionSprite
    {
        private var _lastTimeStamp:Number;
        private var _gameMediator:ITickable;
        
        public function ClientD5RoDemo()
        {
            addEventListener( Event.ADDED_TO_STAGE , init );
        }
        
        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE , init );
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            //            RoGlobal.isIPhone = true;
            RoGlobal.W = stage.stageWidth;
            RoGlobal.H = stage.stageHeight;
            
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