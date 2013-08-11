package inoah.game.ro.modules.player
{
    import flash.geom.Point;
    import flash.ui.Keyboard;
    
    import inoah.core.Global;
    import inoah.core.base.BaseController;
    import inoah.core.base.BaseObject;
    import inoah.core.consts.ConstsActions;
    import inoah.core.utils.GMath;
    import inoah.game.ro.modules.main.view.events.JoyStickEvent;
    import inoah.game.ro.objects.BattleCharacterObject;
    import inoah.game.ro.objects.PlayerObject;
    import inoah.interfaces.controller.IPlayerController;
    import inoah.interfaces.managers.IKeyMgr;
    import inoah.utils.Counter;
    import inoah.utils.QTree;
    
    import robotlegs.bender.framework.api.IContext;
    
    import starling.animation.Tween;
    
    public class PlayerController extends BaseController implements IPlayerController
    {
        [Inject]
        public var context:IContext;
        
        [Inject]
        public var keyMgr:IKeyMgr;
        
        protected var _joyStickUp:Boolean;
        protected var _joyStickDown:Boolean;
        protected var _joyStickLeft:Boolean;
        protected var _joyStickRight:Boolean;
        protected var _joyStickAttack:Boolean;
        
        protected var _isAttacking:Boolean;
        protected var _fightMode:uint = 0;
        protected var _atkTarget:BattleCharacterObject;
        protected var _chooseTarget:BattleCharacterObject;
        protected var _recoverCounter:Counter;
        
        public function PlayerController()
        {
        }
        
        override public function initialize():void
        {
            addContextListener( JoyStickEvent.JOY_STICK_ATTACK , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_DOWN , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_DOWN_LEFT , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_DOWN_RIGHT , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_LEFT , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_RIGHT , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_UP , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_UP_LEFT , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_UP_RIGHT , onJoyStick , JoyStickEvent );
        }
        
        override public function set me(value:BaseObject):void
        {
            super.me = value;
            _recoverCounter = new Counter();
            _recoverCounter.initialize();
            _recoverCounter.reset( (_me as PlayerObject).recoverCd );
        }
        
        public function onJoyStick( e:JoyStickEvent ):void
        {
            _joyStickUp = false;
            _joyStickDown = false;
            _joyStickLeft = false;
            _joyStickRight = false;
            _joyStickAttack = false;
            switch( e.type )
            {
                case JoyStickEvent.JOY_STICK_ATTACK:
                {
                    _joyStickAttack = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_UP:
                {
                    _joyStickUp = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_DOWN:
                {
                    _joyStickDown = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_LEFT:
                {
                    _joyStickLeft = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_RIGHT:
                {
                    _joyStickRight = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_UP_LEFT:
                {
                    _joyStickUp = e.isDown;
                    _joyStickLeft = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_UP_RIGHT:
                {
                    _joyStickUp = e.isDown;
                    _joyStickRight = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_DOWN_LEFT:
                {
                    _joyStickDown = e.isDown;
                    _joyStickLeft = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_DOWN_RIGHT:
                {
                    _joyStickDown = e.isDown;
                    _joyStickRight = e.isDown;
                    break;
                }
            }
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
            
            if( !super.me )
            {
                return;
            }
            
            calRecover( delta );
            attackCheck( delta )
            if( _isAttacking )
            {
                
            }
            else
            {
                moveCheck( delta );
            }
        }
        
        
        protected function attackCheck( delta:Number ):void
        {
            //攻击控制逻辑
            if( !_isAttacking )
            {
                _me.playRate = 1;
            }
            if( _isAttacking )
            {
                
            }
            else if( keyMgr.isDown( Keyboard.J ) || _joyStickAttack )
            {
                if( _atkTarget && _atkTarget.isDead )
                {
                    _atkTarget = null;
                }
                if( !_atkTarget )
                {
                    calFindTarget();
                }
                
                if( _atkTarget )
                {
                    _chooseTarget = _atkTarget;
                    _chooseTarget.viewObject.setChooseCircle( true );
                    
                    calAttack( delta );
                }
            }
        }
        
        protected function moveCheck(delta:Number):void
        {
            var speed:Number = 200;
            
            if( keyMgr.isDown( Keyboard.D ) && !keyMgr.isDown( Keyboard.A ) || _joyStickRight && !_joyStickLeft )
            {
                _me.posX +=speed * delta;
                if( _me.posX > Global.MAP_W ) _me.posX = Global.MAP_W;
                if( keyMgr.isDown( Keyboard.W ) || _joyStickUp )
                {
                    _me.posY -=speed * delta;
                    if( _me.posY < 0 ) _me.posY = 0;
                    _me.direction = _me.directions.RightUp;
                }
                else if( keyMgr.isDown( Keyboard.S ) || _joyStickDown )
                {
                    _me.posY +=speed * delta;
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
                    _me.posY -=speed * delta;
                    if( _me.posY < 0 ) _me.posY = 0;
                    _me.direction = _me.directions.LeftUp;
                }
                else if( keyMgr.isDown( Keyboard.S ) || _joyStickDown )
                {
                    _me.posY +=speed * delta;
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
                _me.posY -=speed * delta;
                if( _me.posY < 0 ) _me.posY = 0;
                _me.direction = _me.directions.Up;
                _me.action = ConstsActions.Run;
            }
            else if( keyMgr.isDown( Keyboard.S ) && !keyMgr.isDown( Keyboard.W ) || _joyStickDown && !_joyStickUp )
            {
                _me.posY +=speed * delta;
                if( _me.posY > Global.MAP_H ) _me.posY = Global.MAP_H;
                _me.direction = _me.directions.Down;
                _me.action = ConstsActions.Run;
            }
            else
            {
                _me.action = ConstsActions.Wait;
            }    
        }
        
        protected function calFindTarget():void
        {
            var objList:Vector.<BattleCharacterObject> = new Vector.<BattleCharacterObject>();
            var i:int;
            var len:int;
            
            //遍历16区域
            var top:QTree = _me.qTree.parent.parent;
            objList = objList.concat( getAllDataFromTree( top ) );
            
            //临时随机找怪，随后可以根据面向找四象限的怪
            len = objList.length;
            for ( i = 0 ; i< len;i++ )
            {
                if( _fightMode==0  && Point.distance( objList[i].POS , _me.POS ) <= (_me as PlayerObject).atkRange )
                {
                    if( objList[i] != _me )
                    {
                        if( !objList[i].isDead )
                        {
                            _atkTarget = objList[i];
                            break;
                        }
                    }
                }
            }
        }
        
        protected function getAllDataFromTree( top:QTree ):Vector.<BattleCharacterObject>
        {
            var objList:Vector.<BattleCharacterObject> = new Vector.<BattleCharacterObject>();
            var i:int;
            var len:int;
            var mqTree:QTree;
            mqTree = top.q1;
            len = mqTree.data.length;
            for ( i = 0 ; i< len;i++ )
            {
                objList.push( mqTree.data[i] );
            }
            mqTree = top.q2;
            len = mqTree.data.length;
            for ( i = 0 ; i< len;i++ )
            {
                objList.push( mqTree.data[i] );
            }
            mqTree = top.q3;
            len = mqTree.data.length;
            for ( i = 0 ; i< len;i++ )
            {
                objList.push( mqTree.data[i] );
            }
            mqTree = top.q4;
            len = mqTree.data.length;
            for ( i = 0 ; i< len;i++ )
            {
                objList.push( mqTree.data[i] );
            }
            if( top.q1.hasChildren )
            {
                objList = objList.concat( getAllDataFromTree( top.q1 ) );
            }
            if( top.q2.hasChildren )
            {
                objList= objList.concat( getAllDataFromTree( top.q2 ) );
            }
            if( top.q3.hasChildren )
            {
                objList = objList.concat( getAllDataFromTree( top.q3 ) );
            }
            if( top.q4.hasChildren )
            {
                objList = objList.concat( getAllDataFromTree( top.q4 ) );
            }
            return objList;
        }
        
        protected function calAttack( delta:Number ):void
        {
            if( _atkTarget.action == ConstsActions.Die )
            {
                _atkTarget = null;
                return;
            }
            var radian:Number = GMath.getPointAngle(_atkTarget.posX-_me.posX,_atkTarget.posY-_me.posY);
            var angle:int = GMath.R2A(radian)+90;
            (_me as PlayerObject).changeDirectionByAngle( angle );
            
            radian = GMath.getPointAngle(_me.posX - _atkTarget.posX,_me.posY - _atkTarget.posY);
            angle = GMath.R2A(radian)+90;
            _atkTarget.changeDirectionByAngle( angle );
            
            _isAttacking = true;
            _me.playRate = 1;
            _me.action = ConstsActions.Attack;
            var tween:Tween = new Tween( _me , 0.4 );
            tween.onComplete = onAttacked;
            tween.onCompleteArgs = [_atkTarget];
            appendAnimateUnit( tween );
        }
        
        protected function onAttacked( atkTarget:BattleCharacterObject ):void
        {
            _isAttacking = false;
            _me.action = ConstsActions.Wait;
            
            if( atkTarget.action != ConstsActions.Attack && atkTarget.action != ConstsActions.Die )
            {
                atkTarget.action = ConstsActions.BeAtk;
            }
            _me.action = ConstsActions.Wait;
            
            //            facade.sendNotification( BattleCommands.PLAYER_ATTACK , [_me , _atkTarget]); 
            
            if(atkTarget.hp==0)
            {
                _atkTarget = null;
                if( _chooseTarget )
                {
                    _chooseTarget.viewObject.setChooseCircle( false );
                    _chooseTarget = null;
                }
            }
        }
        
        protected function calRecover( delta:Number ):void
        {
            _recoverCounter.tick( delta );
            if(_recoverCounter.expired)
            {
                (_me as PlayerObject).hp += 1;
                (_me as PlayerObject).sp += 1;
                _recoverCounter.reset( (_me as PlayerObject).recoverCd );
            }
        }
    }
}