package robotlegs.bender.extensions.keyMgrExtension
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.utils.ByteArray;
    
    import interfaces.IKeyMgr;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.ILogger;
    
    /**
     * 键盘管理器 
     * @author inoah
     */    
    public class KeyMgr extends Mediator implements IKeyMgr
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var mediatorMap:IMediatorMap;
        
        [Inject]
        public var commandMap:IEventCommandMap;
        
        [Inject]
        public var logger:ILogger;
        
        [Inject]
        public var contextView:ContextView;
        
        private var states:ByteArray;
        private var dispObj:DisplayObject;
        private var _isDisposed:Boolean;
        
        public function KeyMgr()
        {
        }
        
        override public function initialize():void
        {
            states = new ByteArray();
            states.writeUnsignedInt( 0 );
            states.writeUnsignedInt( 0 );
            states.writeUnsignedInt( 0 );
            states.writeUnsignedInt( 0 );
            states.writeUnsignedInt( 0 );
            states.writeUnsignedInt( 0 );
            states.writeUnsignedInt( 0 );
            states.writeUnsignedInt( 0 );
            dispObj = contextView.view;
            dispObj.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true );
            dispObj.addEventListener( KeyboardEvent.KEY_UP, keyUpListener, false, 0, true );
            dispObj.addEventListener( Event.ACTIVATE, activateListener, false, 0, true );
            dispObj.addEventListener( Event.DEACTIVATE, deactivateListener, false, 0, true );
        }
        
        private function keyDownListener( ev:KeyboardEvent ):void
        {
            states[ ev.keyCode >>> 3 ] |= 1 << (ev.keyCode & 7);
        }
        
        private function keyUpListener( ev:KeyboardEvent ):void
        {
            states[ ev.keyCode >>> 3 ] &= ~(1 << (ev.keyCode & 7));
        }
        
        private function activateListener( ev:Event ):void
        {
            for ( var i:int = 0; i < 32; ++i )
            {
                states[ i ] = 0;
            }
        }
        
        private function deactivateListener( ev:Event ):void
        {
            for ( var i:int = 0; i < 32; ++i )
            {
                states[ i ] = 0;
            }
        }
        
        public function isDown( keyCode:uint ):Boolean
        {
            return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) != 0;
        }
        
        public function isUp( keyCode:uint ):Boolean
        {
            return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) == 0;
        }
        
        public function dispose():void
        {
            if( !isDisposed )
            {
                _isDisposed = true;
            }
        }
        
        public function get isDisposed():Boolean
        {
            return _isDisposed;
        }
    }
}
