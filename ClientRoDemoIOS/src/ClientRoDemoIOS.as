package
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageOrientation;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    import inoah.core.CoreBundle;
    import inoah.core.Global;
    import inoah.game.ro.RoConfig;
    import inoah.game.ro.RoGameMediator;
    
    import robotlegs.bender.bundles.mvcs.MVCSBundle;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.impl.Context;
    
    [SWF(width="960",height="640",frameRate="60",backgroundColor="#000000")]
    public class ClientRoDemoIOS extends Sprite
    {
        private var _lastTimeStamp:Number;
        
        private var _context:IContext;
        
        private var _roGameMediator:RoGameMediator;
        
        public function ClientRoDemoIOS()
        {
            addEventListener( Event.ADDED_TO_STAGE , init );
        }
        
        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE , init );
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.setOrientation( StageOrientation.ROTATED_RIGHT );
            
            Global.IS_MOBILE = true;
            Global.ENABLE_LUA = false;
            Global.SCREEN_W = 960;
            Global.SCREEN_H = 640;
            
            Global.MAP_W = 6400;
            Global.MAP_H = 3200;
            Global.TILE_W = 128;
            Global.TILE_H = 64;
            
            _context = new Context()
                .install( MVCSBundle )
                .install( CoreBundle )
                .configure( RoConfig )
                .configure( new ContextView( this ) );
            _context.initialize( onInitialize );
        }
        
        private function onInitialize():void
        {
            _roGameMediator = _context.injector.getInstance(RoGameMediator) as RoGameMediator;
            _roGameMediator.initialize();
            
            _lastTimeStamp = new Date().time;
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
        }
        
        protected function onEnterFrameHandler( e:Event):void
        {
            var currentTimeStamp:Number = new Date().time;
            var delta:Number = (currentTimeStamp - _lastTimeStamp)/1000;
            _lastTimeStamp = currentTimeStamp;
            
            if( _roGameMediator )
            {
                _roGameMediator.tick( delta );
            }
        }
    }
}