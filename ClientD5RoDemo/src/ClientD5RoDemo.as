package
{
    import com.inoah.ro.RoGlobal;
    import com.inoah.ro.mediators.GameMediator;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.utils.getTimer;
    
    import as3.interfaces.IFacade;
    import as3.patterns.facade.Facade;
    
    [SWF(width="960",height="560",frameRate="60",backgroundColor="#000000")]
    public class ClientD5RoDemo extends Sprite
    {
        //        private var npcDialogBox:NPCDialog;
        private var lastTimeStamp:int;
        
        private var _gameMediator:GameMediator;
        
        public function ClientD5RoDemo()
        {
            addEventListener( Event.ADDED_TO_STAGE , init );
        }
        
        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE , init );
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            lastTimeStamp = getTimer();
            
            RoGlobal.W = stage.stageWidth;
            RoGlobal.H = stage.stageHeight;
            
            var facade:IFacade = Facade.getInstance();
            _gameMediator = new GameMediator( stage , this );
            facade.registerMediator( _gameMediator );
            
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
        }
        
        protected function onEnterFrameHandler( e:Event):void
        {
            var timeNow:uint = getTimer();
            var delta:Number = (timeNow - lastTimeStamp) / 1000;
            lastTimeStamp = timeNow;
            if( _gameMediator )
            {
                _gameMediator.tick( delta );
            }
        }
    }
}