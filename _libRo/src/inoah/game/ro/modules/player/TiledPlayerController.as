package inoah.game.ro.modules.player
{
    import flash.ui.Keyboard;
    
    import inoah.core.Global;
    import inoah.core.consts.ConstsActions;
    import inoah.core.consts.ConstsDirIndex;

    public class TiledPlayerController extends PlayerController
    {
        public function TiledPlayerController()
        {
            super();
        }
        
        override protected function moveCheck(delta:Number):void
        {
            var speed:Number = 300;
            
            if( keyMgr.isDown( Keyboard.D ) && !keyMgr.isDown( Keyboard.A ) || _joyStickRight && !_joyStickLeft )
            {
                _me.posX +=speed * delta;
                if( _me.posX > Global.MAP_W ) _me.posX = Global.MAP_W;
                if( keyMgr.isDown( Keyboard.W ) || _joyStickUp )
                {
                    _me.posY -= speed * delta * 0.5;
                    if( _me.posY < 0 ) _me.posY = 0;
                    _me.direction = ConstsDirIndex.UP_RIGHT;
                }
                else if( keyMgr.isDown( Keyboard.S ) || _joyStickDown )
                {
                    _me.posY +=speed * delta * 0.5;
                    if( _me.posY > Global.MAP_H ) _me.posY = Global.MAP_H;
                    _me.direction = ConstsDirIndex.DOWN_RIGHT;
                }
                else
                {
                    _me.direction = ConstsDirIndex.RIGHT;
                }
                _me.action = ConstsActions.Run;
            }
            else if( keyMgr.isDown( Keyboard.A ) && !keyMgr.isDown( Keyboard.D ) || _joyStickLeft && !_joyStickRight )
            {
                _me.posX -=speed * delta;
                if( _me.posX < 0 )  _me.posX = 0;
                if( keyMgr.isDown( Keyboard.W ) || _joyStickUp )
                {
                    _me.posY -=speed * delta * 0.5;
                    if( _me.posY < 0 ) _me.posY = 0;
                    _me.direction = ConstsDirIndex.UP_LIFT;
                }
                else if( keyMgr.isDown( Keyboard.S ) || _joyStickDown )
                {
                    _me.posY +=speed * delta * 0.5;
                    if( _me.posY > Global.MAP_H ) _me.posY = Global.MAP_H;
                    _me.direction = ConstsDirIndex.DOWN_LEFT;
                }
                else
                {
                    _me.direction = ConstsDirIndex.LEFT;
                }
                _me.action = ConstsActions.Run;
            }
            else if( keyMgr.isDown( Keyboard.W ) && !keyMgr.isDown( Keyboard.S ) || _joyStickUp && !_joyStickDown )
            {
                _me.posY -=speed * delta * 0.5;
                if( _me.posY < 0 ) _me.posY = 0;
                _me.direction = ConstsDirIndex.UP;
                _me.action = ConstsActions.Run;
            }
            else if( keyMgr.isDown( Keyboard.S ) && !keyMgr.isDown( Keyboard.W ) || _joyStickDown && !_joyStickUp )
            {
                _me.posY +=speed * delta * 0.5;
                if( _me.posY > Global.MAP_H ) _me.posY = Global.MAP_H;
                _me.direction = ConstsDirIndex.DOWN;
                _me.action = ConstsActions.Run;
            }
            else
            {
                _me.action = ConstsActions.Wait;
            }    
        }
    }
}