package
{
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    import inoah.core.CoreBundle;
    import inoah.core.Global;
    import inoah.game.ro.RoConfig;
    import inoah.game.ro.RoGameMediator;
    
    import robotlegs.bender.bundles.mvcs.MVCSBundle;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.luaExtension.LuaExtension;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.impl.Context;
    
    [SWF(width="960",height="640",frameRate="60",backgroundColor="#000000")]
    public class Client extends VersionSprite
    {
        private var _lastTimeStamp:Number;
        
        private var _context:IContext;
        
        private var _roGameMediator:RoGameMediator;
        
        public function Client()
        {
            addEventListener( Event.ADDED_TO_STAGE , init );
        }
        
        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE , init );
            
            stage.frameRate = 60;
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            tabChildren = false;
            tabEnabled = false;
            
            Global.IS_MOBILE = false;
            Global.ENABLE_LUA = true;
            Global.SCREEN_W = stage.stageWidth;
            Global.SCREEN_H = stage.stageHeight;
            Global.MAP_W = 6400;
            Global.MAP_H = 3200;
            Global.TILE_W = 128;
            Global.TILE_H = 64;
            Global.PLAYER_POSX = 1800;
            Global.PLAYER_POSY = 1000;
            
            _context = new Context()
                .install( MVCSBundle )
                .install( CoreBundle )
                .install( LuaExtension )
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