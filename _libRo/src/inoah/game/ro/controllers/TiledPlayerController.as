package inoah.game.ro.controllers
{
    import flash.ui.Keyboard;
    
    import inoah.core.Global;
    import inoah.core.consts.ConstsActions;
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.managers.KeyMgr;
    import inoah.core.managers.MainMgr;

    public class TiledPlayerController extends PlayerController
    {
        public function TiledPlayerController()
        {
            super();
        }
        
        override protected function moveCheck(delta:Number):void
        {
            var keyMgr:KeyMgr = MainMgr.instance.getMgr( MgrTypeConsts.KEY_MGR ) as KeyMgr;
            var speed:Number = 200;
            
            if( keyMgr.isDown( Keyboard.D ) && !keyMgr.isDown( Keyboard.A ) || _joyStickRight && !_joyStickLeft )
            {
                _me.posX +=speed * delta;
                if( _me.posX > Global.MAP_W ) _me.posX = Global.MAP_W;
                if( keyMgr.isDown( Keyboard.W ) || _joyStickUp )
                {
                    _me.posY -= speed * delta * 0.5;
                    if( _me.posY < 0 ) _me.posY = 0;
                    _me.direction = _me.directions.RightUp;
                }
                else if( keyMgr.isDown( Keyboard.S ) || _joyStickDown )
                {
                    _me.posY +=speed * delta * 0.5;
                    if( _me.posY > Global.MAP_H ) _me.posY = Global.MAP_H;
                    _me.direction = _me.directions.RightDown;
                }
                else
                {
                    _me.direction = _me.directions.Right;
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
                    _me.direction = _me.directions.LeftUp;
                }
                else if( keyMgr.isDown( Keyboard.S ) || _joyStickDown )
                {
                    _me.posY +=speed * delta * 0.5;
                    if( _me.posY > Global.MAP_H ) _me.posY = Global.MAP_H;
                    _me.direction = _me.directions.LeftDown;
                }
                else
                {
                    _me.direction = _me.directions.Left;
                }
                _me.action = ConstsActions.Run;
            }
            else if( keyMgr.isDown( Keyboard.W ) && !keyMgr.isDown( Keyboard.S ) || _joyStickUp && !_joyStickDown )
            {
                _me.posY -=speed * delta * 0.5;
                if( _me.posY < 0 ) _me.posY = 0;
                _me.direction = _me.directions.Up;
                _me.action = ConstsActions.Run;
            }
            else if( keyMgr.isDown( Keyboard.S ) && !keyMgr.isDown( Keyboard.W ) || _joyStickDown && !_joyStickUp )
            {
                _me.posY +=speed * delta * 0.5;
                if( _me.posY > Global.MAP_H ) _me.posY = Global.MAP_H;
                _me.direction = _me.directions.Down;
                _me.action = ConstsActions.Run;
            }
            else
            {
                _me.action = ConstsActions.Wait;
            }    
        }
    }
}