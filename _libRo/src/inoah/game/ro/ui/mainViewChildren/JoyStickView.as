package inoah.game.ro.ui.mainViewChildren
{
    import flash.display.Bitmap;
    
    import feathers.controls.Button;
    
    import inoah.core.Global;
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.interfaces.ILoader;
    import inoah.core.loaders.JpgLoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.MainMgr;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.TouchEvent;
    import starling.textures.Texture;
    
    public class JoyStickView extends Sprite
    {
        private static var DIR_X:int;
        private static var DIR_Y:int;
        private static var DIR_W:uint;
        private static var DIR_H:uint;
        
        private var _dirBtn:Button;
        private var _atkBtn:Button;
        
        private var _dirBg:Image;
        private var _dirDownBg:Image;
        private var _atkBg:Image;
        private var _atkDownBg:Image;
        
        public function JoyStickView()
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            assetMgr.getRes( "ui/joyStickDirMain.png" , onLoadHandler );
        }
        
        private function onLoadHandler( loader:ILoader ):void
        {
            var texture:Texture = Texture.fromBitmap( (loader as JpgLoader).content as Bitmap, false );
            _dirBg = new Image( texture );
            _dirBg.alpha = 0.5;
            _dirDownBg = new Image( texture );
            DIR_W = _dirBg.texture.width;
            DIR_H = _dirBg.texture.height;
            DIR_X = 30;
            DIR_Y = Global.SCREEN_H - DIR_H - 30;
            
            _dirBtn = new Button();
            _dirBtn.x = DIR_X;
            _dirBtn.y = DIR_Y;
            _dirBtn.upSkin = _dirBg;
            _dirBtn.hoverSkin = _dirDownBg;
            _dirBtn.downSkin = _dirDownBg;
            _dirBtn.addEventListener( starling.events.TouchEvent.TOUCH, onDirTouch );
            addChild( _dirBtn );
            
            _atkBg = new Image( texture );
            _atkBg.alpha = 0.5;
            _atkDownBg = new Image( texture );
            
            _atkBtn = new Button();
            _atkBtn.x = Global.SCREEN_W - _atkBg.texture.width - 30;;
            _atkBtn.y = Global.SCREEN_H - _atkBg.texture.height - 30;
            _atkBtn.upSkin = _atkBg;
            _atkBtn.hoverSkin = _atkDownBg;
            _atkBtn.downSkin = _atkDownBg;
            _atkBtn.addEventListener( starling.events.TouchEvent.TOUCH, onAtkTouch );
            addChild( _atkBtn );
        }
        
        private function onDirTouch( e:starling.events.TouchEvent ):void
        {
            //            var isDown:Boolean;
            //            var touch:Touch;
            //            var touchX:int;
            //            var touchY:int;
            //            var facade:IFacade;
            //            for( var i:int = 0;i<e.touches.length;i++)
            //            {
            //                touch = e.touches[i];
            //                if( touch )
            //                {
            //                    if( touch.phase == TouchPhase.ENDED || touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED )
            //                    {
            //                        facade = Facade.getInstance();
            //                        switch( touch.phase )
            //                        {
            //                            case TouchPhase.ENDED:
            //                            {
            //                                isDown = false;
            //                                break;
            //                            }
            //                            case TouchPhase.BEGAN:
            //                            case TouchPhase.MOVED:
            //                            {
            //                                isDown = true;
            //                                break;
            //                            }
            //                        }
            //                        touchX = touch.previousGlobalX;
            //                        touchY = touch.previousGlobalY;
            //                        if( touchX > 0 + DIR_X && touchX < DIR_W / 3 + DIR_X )
            //                        {
            //                            if( touchY > 0 + DIR_Y && touchY < DIR_H / 3 + DIR_Y )
            //                            {
            //                                facade.sendNotification( GameCommands.JOY_STICK_UP_LEFT , [isDown] );
            //                            }
            //                            else if( touchY > DIR_H / 3 + DIR_Y && touchY < 2 * DIR_H / 3 + DIR_Y )
            //                            {
            //                                facade.sendNotification( GameCommands.JOY_STICK_LEFT , [isDown] );
            //                            }
            //                            else if( touchY > 2 * DIR_H / 3 + DIR_Y && touchY < DIR_H + DIR_Y )
            //                            {
            //                                facade.sendNotification( GameCommands.JOY_STICK_DOWN_LEFT , [isDown] );
            //                            }
            //                        }
            //                        else if( touchX > DIR_W / 3 + DIR_X && touchX < 2 * DIR_W / 3 + DIR_X )
            //                        {
            //                            if( touchY > 0 + DIR_Y && touchY < DIR_H / 3 + DIR_Y )
            //                            {
            //                                facade.sendNotification( GameCommands.JOY_STICK_UP , [isDown] );
            //                            }
            //                            else if( touchY > DIR_H / 3 + DIR_Y && touchY < 2 * DIR_H / 3 + DIR_Y )
            //                            {
            //                            }
            //                            else if( touchY > 2 * DIR_H / 3 + DIR_Y && touchY < DIR_H + DIR_Y )
            //                            {
            //                                facade.sendNotification( GameCommands.JOY_STICK_DOWN , [isDown] );   
            //                            }
            //                        }
            //                        else if( touchX > 2 * DIR_W / 3 + DIR_X && touchX < DIR_W + DIR_X )
            //                        {
            //                            if( touchY > 0 + DIR_Y && touchY < DIR_H / 3 + DIR_Y )
            //                            {
            //                                facade.sendNotification( GameCommands.JOY_STICK_UP_RIGHT , [isDown] );   
            //                            }
            //                            else if( touchY > DIR_H / 3 + DIR_Y && touchY < 2 * DIR_H / 3 + DIR_Y )
            //                            {
            //                                facade.sendNotification( GameCommands.JOY_STICK_RIGHT , [isDown] );   
            //                            }
            //                            else if( touchY > 2 * DIR_H / 3 + DIR_Y && touchY < DIR_H + DIR_Y )
            //                            {
            //                                facade.sendNotification( GameCommands.JOY_STICK_DOWN_RIGHT , [isDown] );   
            //                            }
            //                        }
            //                    }
            //                }
            //            }
        }
        
        private function onAtkTouch( e:starling.events.TouchEvent ):void
        {
            //            var touch:Touch;
            //            var isDown:Boolean;
            //            var facade:IFacade;
            //            for( var i:int = 0;i<e.touches.length;i++)
            //            {
            //                touch = e.touches[i];
            //                if( touch )
            //                {
            //                    if( touch.phase == TouchPhase.ENDED || touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED )
            //                    {
            //                        facade = Facade.getInstance();
            //                        if( touch.phase == TouchPhase.ENDED )
            //                        {
            //                            isDown = false;
            //                        }
            //                        else if( touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED )
            //                        {
            //                            isDown = true;
            //                        }
            //                        facade.sendNotification( GameCommands.JOY_STICK_ATTACK , [isDown] );
            //                    }
            //                }
            //            }
        }
    }
}