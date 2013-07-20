package com.inoah.ro.ui.mainViewChildren
{
    import com.inoah.ro.consts.GameCommands;
    
    import flash.events.MouseEvent;
    import flash.events.TouchEvent;
    
    import as3.interfaces.IFacade;
    import as3.patterns.facade.Facade;
    
    import game.ui.mainViewChildren.joystickUI;
    
    public class JoyStickView
    {
        private var _joyStick:joystickUI;
        
        public function JoyStickView( joyStick:joystickUI )
        {
            _joyStick = joyStick; 
            
            _joyStick.btnUp.addEventListener( MouseEvent.ROLL_OVER , onKeyDownHandler );
            _joyStick.btnDown.addEventListener( MouseEvent.ROLL_OVER , onKeyDownHandler );
            _joyStick.btnLeft.addEventListener( MouseEvent.ROLL_OVER , onKeyDownHandler );
            _joyStick.btnRight.addEventListener( MouseEvent.ROLL_OVER , onKeyDownHandler );
            _joyStick.btnUpLeft.addEventListener( MouseEvent.ROLL_OVER , onKeyDownHandler );
            _joyStick.btnUpRight.addEventListener( MouseEvent.ROLL_OVER , onKeyDownHandler );
            _joyStick.btnDownLeft.addEventListener( MouseEvent.ROLL_OVER , onKeyDownHandler );
            _joyStick.btnDownRight.addEventListener( MouseEvent.ROLL_OVER , onKeyDownHandler );
            _joyStick.btnAttack.addEventListener( MouseEvent.ROLL_OVER , onKeyDownHandler );

            _joyStick.btnUp.addEventListener( MouseEvent.ROLL_OUT , onKeyDownHandler );
            _joyStick.btnDown.addEventListener( MouseEvent.ROLL_OUT , onKeyDownHandler );
            _joyStick.btnLeft.addEventListener( MouseEvent.ROLL_OUT , onKeyDownHandler );
            _joyStick.btnRight.addEventListener( MouseEvent.ROLL_OUT , onKeyDownHandler );
            _joyStick.btnUpLeft.addEventListener( MouseEvent.ROLL_OUT , onKeyDownHandler );
            _joyStick.btnUpRight.addEventListener( MouseEvent.ROLL_OUT , onKeyDownHandler );
            _joyStick.btnDownLeft.addEventListener( MouseEvent.ROLL_OUT , onKeyDownHandler );
            _joyStick.btnDownRight.addEventListener( MouseEvent.ROLL_OUT , onKeyDownHandler );
            _joyStick.btnAttack.addEventListener( MouseEvent.ROLL_OUT , onKeyDownHandler );

            _joyStick.btnUp.addEventListener( TouchEvent.TOUCH_OVER , onKeyDownHandler );
            _joyStick.btnDown.addEventListener( TouchEvent.TOUCH_OVER , onKeyDownHandler );
            _joyStick.btnLeft.addEventListener( TouchEvent.TOUCH_OVER , onKeyDownHandler );
            _joyStick.btnRight.addEventListener( TouchEvent.TOUCH_OVER , onKeyDownHandler );
            _joyStick.btnUpLeft.addEventListener( TouchEvent.TOUCH_OVER , onKeyDownHandler );
            _joyStick.btnUpRight.addEventListener( TouchEvent.TOUCH_OVER , onKeyDownHandler );
            _joyStick.btnDownLeft.addEventListener( TouchEvent.TOUCH_OVER , onKeyDownHandler );
            _joyStick.btnDownRight.addEventListener( TouchEvent.TOUCH_OVER , onKeyDownHandler );
            _joyStick.btnAttack.addEventListener( TouchEvent.TOUCH_OVER , onKeyDownHandler );

            _joyStick.btnUp.addEventListener( TouchEvent.TOUCH_END , onKeyDownHandler );
            _joyStick.btnDown.addEventListener( TouchEvent.TOUCH_END , onKeyDownHandler );
            _joyStick.btnLeft.addEventListener( TouchEvent.TOUCH_END , onKeyDownHandler );
            _joyStick.btnRight.addEventListener( TouchEvent.TOUCH_END , onKeyDownHandler );
            _joyStick.btnUpLeft.addEventListener( TouchEvent.TOUCH_END , onKeyDownHandler );
            _joyStick.btnUpRight.addEventListener( TouchEvent.TOUCH_END , onKeyDownHandler );
            _joyStick.btnDownLeft.addEventListener( TouchEvent.TOUCH_END , onKeyDownHandler );
            _joyStick.btnDownRight.addEventListener( TouchEvent.TOUCH_END , onKeyDownHandler );
            _joyStick.btnAttack.addEventListener( TouchEvent.TOUCH_END , onKeyDownHandler );
        }
        
        protected function onKeyDownHandler( e:* ):void
        {
            var isDown:Boolean;
            if( e.type == MouseEvent.ROLL_OVER || e.type == TouchEvent.TOUCH_OVER)
            {
                isDown = true;
            }
            else if( e.type == MouseEvent.ROLL_OUT || e.type == TouchEvent.TOUCH_END )
            {
                isDown = false;
            }
            var facade:IFacade = Facade.getInstance();
            switch( e.currentTarget )
            {
                case _joyStick.btnAttack:
                {
                    facade.sendNotification( GameCommands.JOY_STICK_ATTACK , [isDown] );
                    break;
                }
                case _joyStick.btnUp:
                {
                    facade.sendNotification( GameCommands.JOY_STICK_UP , [isDown] );
                    break;
                }
                case _joyStick.btnDown:
                {
                    facade.sendNotification( GameCommands.JOY_STICK_DOWN , [isDown] );
                    break;
                }
                case _joyStick.btnLeft:
                {
                    facade.sendNotification( GameCommands.JOY_STICK_LEFT , [isDown] );
                    break;
                }
                case _joyStick.btnRight:
                {
                    facade.sendNotification( GameCommands.JOY_STICK_RIGHT , [isDown] );
                    break;
                }
                case _joyStick.btnUpLeft:
                {
                    facade.sendNotification( GameCommands.JOY_STICK_UP_LEFT , [isDown] );
                    break;
                }
                case _joyStick.btnUpRight:
                {
                    facade.sendNotification( GameCommands.JOY_STICK_UP_RIGHT , [isDown] );
                    break;
                }
                case _joyStick.btnDownLeft:
                {
                    facade.sendNotification( GameCommands.JOY_STICK_DOWN_LEFT , [isDown] );
                    break;
                }
                case _joyStick.btnDownRight:
                {
                    facade.sendNotification( GameCommands.JOY_STICK_DOWN_RIGHT , [isDown] );
                    break;
                }
            }
        }
    }
}