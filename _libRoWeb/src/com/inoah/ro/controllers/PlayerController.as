package com.inoah.ro.controllers
{
    import com.inoah.ro.RoGlobal;
    import com.inoah.ro.characters.Actions;
    import com.inoah.ro.consts.BattleCommands;
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.managers.KeyMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.maps.QTree;
    import com.inoah.ro.objects.BattleCharacterObject;
    import com.inoah.ro.objects.PlayerObject;
    
    import flash.geom.Point;
    import flash.ui.Keyboard;
    
    import as3.interfaces.INotification;
    
    import starling.animation.Tween;
    
    public class PlayerController extends BaseController
    {
        protected var _joyStickUp:Boolean;
        protected var _joyStickDown:Boolean;
        protected var _joyStickLeft:Boolean;
        protected var _joyStickRight:Boolean;
        protected var _joyStickAttack:Boolean;
        
        protected var _isAttacking:Boolean;
        protected var _fightMode:uint = 0;
        protected var _atkTarget:BattleCharacterObject;
        protected var _chooseTarget:BattleCharacterObject;
        
        public function PlayerController()
        {
            super( GameConsts.PLAYER_CONTROLLER );
        }
        
        //        override protected function onClick(e:MouseEvent):void
        //        {
        //            _atkTarget = null;
        //            if( _chooseTarget  )
        //            {
        //                _chooseTarget.setChooseCircle( false );
        //                _chooseTarget = null;
        //            }
        //            super.onClick(e);
        //            
        //        }
        //        
        //        override protected function clickSomeBody(o:GameObject):void
        //        {
        //            //if(o is NCharacterObject) Main.me.talk2NPC((o as NCharacterObject).uid)
        //            if(o.camp!=Global.userdata.camp)
        //            {
        //                // 敌人，设置为攻击目标
        //                _atkTarget = o as CharacterObject;
        //                _fightMode = 0;
        //            }
        //            if( o != _me )
        //            {
        //                _chooseTarget = o as CharacterObject;
        //                _chooseTarget.setChooseCircle( true );
        //                
        //            }
        //            super.clickSomeBody(o);
        //        }
        //        
        //        override public function calcAction():void
        //        {
        //            if(_atkTarget!=null)
        //            {
        //                calAttackMove();
        //                calAttack();
        //            }
        //            calRecover();
        //            super.calcAction();
        //        }
        //        
        //        private function calAttackMove():void
        //        {
        //            // 先判断攻击距离
        //            if(_fightMode==0 && posCheck( 100 ) )
        //            {
        //                if( _endTarget )
        //                {
        //                    _endTarget = null;
        //                    stopMove();
        //                }
        //                _fightMode = 2;
        //            }
        //            else 
        //            {
        //                _fightMode = 1;
        //            }
        //            
        //            if(_fightMode==1 && posCheck( 100 ))
        //            {
        //                // 走入攻击范围，开始攻击
        //                (_atkTarget.controler as MonsterController).fightTo(_me);
        //                if( _endTarget )
        //                {
        //                    _endTarget = null;
        //                    stopMove();
        //                }
        //                _fightMode = 2;
        //            }
        //            else
        //            {
        //                _endTarget = new Point( _atkTarget.PosX , _atkTarget.PosY );
        //                walk2Target();
        //            }
        //        }
        //        
        //        private function calAttack():void
        //        {
        //            if(_fightMode==2 && posCheck( 100 ) )
        //            {
        //                if( _endTarget )
        //                {
        //                    _endTarget = null;
        //                    stopMove();
        //                }
        //                if( Global.Timer - _lastHurt > atkCd )
        //                {
        //                    if( _atkTarget.action == Actions.Die )
        //                    {
        //                        _atkTarget = null;
        //                        return;
        //                    }
        //                    var radian:Number = GMath.getPointAngle(_atkTarget.PosX-_me.PosX,_atkTarget.PosY-_me.PosY);
        //                    var angle:int = GMath.R2A(radian)+90;
        //                    changeDirectionByAngle( angle );
        //                    
        //                    _me.action = Actions.Attack;
        //                    _lastHurt = Global.Timer;
        //                    var tween:Tween = new Tween( _atkTarget , 0.4 );
        //                    tween.onComplete = onAttacked;
        //                    tween.onCompleteArgs = [_atkTarget]
        //                    appendAnimateUnit( tween );
        //                }
        //            }
        //            else
        //            {
        //                _fightMode = 1;
        //            }
        //        }
        //        
        //        private function calRecover():void
        //        {
        //            if( Global.Timer - _lastRecover > _recoverCd )
        //            {
        //                (_me as PlayerObject).hp += 1;
        //                (_me as PlayerObject).sp += 1;
        //                _lastRecover = Global.Timer;
        //            }
        //        }
        //        
        //        private function onAttacked( atkTarget:CharacterObject ):void
        //        {
        //            (atkTarget.controler as MonsterController).fightTo(_me);
        //            
        //            if( atkTarget.action != Actions.Attack && atkTarget.action != Actions.Die )
        //            {
        //                atkTarget.action = Actions.BeAtk;
        //            }
        //            _me.action = Actions.Wait;
        //            
        //            Facade.getInstance().sendNotification( BattleCommands.ATTACK , [_me, atkTarget] );
        //            
        //            if(atkTarget.hp==0)
        //            {
        //                _atkTarget = null;
        //                if( _chooseTarget )
        //                {
        //                    _chooseTarget.setChooseCircle( false );
        //                    _chooseTarget = null;
        //                }
        //            }
        //        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( GameCommands.JOY_STICK_UP );
            arr.push( GameCommands.JOY_STICK_DOWN );
            arr.push( GameCommands.JOY_STICK_LEFT );
            arr.push( GameCommands.JOY_STICK_RIGHT );
            arr.push( GameCommands.JOY_STICK_UP_LEFT );
            arr.push( GameCommands.JOY_STICK_UP_RIGHT );
            arr.push( GameCommands.JOY_STICK_DOWN_LEFT );
            arr.push( GameCommands.JOY_STICK_DOWN_RIGHT );
            arr.push( GameCommands.JOY_STICK_ATTACK );
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            var arr:Array = notification.getBody() as Array;
            _joyStickUp = false;
            _joyStickDown = false;
            _joyStickLeft = false;
            _joyStickRight = false;
            _joyStickAttack = false;
            switch( notification.getName() )
            {
                case GameCommands.JOY_STICK_ATTACK:
                {
                    _joyStickAttack = arr[0];
                    break;
                }
                case GameCommands.JOY_STICK_UP:
                {
                    _joyStickUp = arr[0];
                    break;
                }
                case GameCommands.JOY_STICK_DOWN:
                {
                    _joyStickDown = arr[0];
                    break;
                }
                case GameCommands.JOY_STICK_LEFT:
                {
                    _joyStickLeft = arr[0];
                    break;
                }
                case GameCommands.JOY_STICK_RIGHT:
                {
                    _joyStickRight = arr[0];
                    break;
                }
                case GameCommands.JOY_STICK_UP_LEFT:
                {
                    _joyStickUp = arr[0];
                    _joyStickLeft = arr[0];
                    break;
                }
                case GameCommands.JOY_STICK_UP_RIGHT:
                {
                    _joyStickUp = arr[0];
                    _joyStickRight = arr[0];
                    break;
                }
                case GameCommands.JOY_STICK_DOWN_LEFT:
                {
                    _joyStickDown = arr[0];
                    _joyStickLeft = arr[0];
                    break;
                }
                case GameCommands.JOY_STICK_DOWN_RIGHT:
                {
                    _joyStickDown = arr[0];
                    _joyStickRight = arr[0];
                    break;
                }
            }
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
            
            var speed:Number = 200;
            var keyMgr:KeyMgr = MainMgr.instance.getMgr( MgrTypeConsts.KEY_MGR ) as KeyMgr;
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
                _isAttacking = true;
                _me.playRate = 1;
                _me.action = Actions.Attack;
                var tween:Tween = new Tween( _me , 0.6 );
                tween.onComplete = onAttacked;
                appendAnimateUnit( tween );
                
                if( _atkTarget && _atkTarget.isDead )
                {
                    _atkTarget = null;
                }
                if( !_atkTarget )
                {
                    var objList:Vector.<BattleCharacterObject> = new Vector.<BattleCharacterObject>();
                    var mqTree:QTree;
                    var len:int;
                    var i:int;
                    mqTree = _me.qTree.parent.q1;
                    len = mqTree.data.length;
                    for ( i = 0 ; i< len;i++ )
                    {
                        objList.push( mqTree.data[i] );
                    }
                    mqTree = _me.qTree.parent.q2;
                    len = mqTree.data.length;
                    for ( i = 0 ; i< len;i++ )
                    {
                        objList.push( mqTree.data[i] );
                    }
                    mqTree = _me.qTree.parent.q3;
                    len = mqTree.data.length;
                    for ( i = 0 ; i< len;i++ )
                    {
                        objList.push( mqTree.data[i] );
                    }
                    mqTree = _me.qTree.parent.q4;
                    len = mqTree.data.length;
                    for ( i = 0 ; i< len;i++ )
                    {
                        objList.push( mqTree.data[i] );
                    }
                    
                    //临时随机找怪，随后可以根据面向找四象限的怪
                    len = objList.length;
                    for ( i = 0 ; i< len;i++ )
                    {
                        if( _fightMode==0  && Point.distance( objList[i].POS , _me.POS ) <= (_me as PlayerObject).atkRange )
                        {
                            if( objList[i] != _me && !objList[i].isDead )
                            {
                                _atkTarget = objList[i];
                                break;
                            }
                        }
                    }
                }
                
                if( _atkTarget )
                {
                    facade.sendNotification( BattleCommands.PLAYER_ATTACK , [_me , _atkTarget]); 
                }
            }
                //攻击控制逻辑结束
                
                //八方向移动控制逻辑
            else if( keyMgr.isDown( Keyboard.D ) && !keyMgr.isDown( Keyboard.A ) || _joyStickRight && !_joyStickLeft )
            {
                _me.posX +=speed * delta;
                if( _me.posX > RoGlobal.MAP_W ) _me.posX = RoGlobal.MAP_W;
                if( keyMgr.isDown( Keyboard.W ) || _joyStickUp )
                {
                    _me.posY -=speed * delta;
                    if( _me.posY < 0 ) _me.posY = 0;
                    _me.direction = _me.directions.RightUp;
                }
                else if( keyMgr.isDown( Keyboard.S ) || _joyStickDown )
                {
                    _me.posY +=speed * delta;
                    if( _me.posY > RoGlobal.MAP_H ) _me.posY = RoGlobal.MAP_H;
                    _me.direction = _me.directions.RightDown;
                }
                else
                {
                    _me.direction = _me.directions.Right;
                }
                _me.action = Actions.Run;
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
                    if( _me.posY > RoGlobal.MAP_H ) _me.posY = RoGlobal.MAP_H;
                    _me.direction = _me.directions.LeftDown;
                }
                else
                {
                    _me.direction = _me.directions.Left;
                }
                _me.action = Actions.Run;
            }
            else if( keyMgr.isDown( Keyboard.W ) && !keyMgr.isDown( Keyboard.S ) || _joyStickUp && !_joyStickDown )
            {
                _me.posY -=speed * delta;
                if( _me.posY < 0 ) _me.posY = 0;
                _me.direction = _me.directions.Up;
                _me.action = Actions.Run;
            }
            else if( keyMgr.isDown( Keyboard.S ) && !keyMgr.isDown( Keyboard.W ) || _joyStickDown && !_joyStickUp )
            {
                _me.posY +=speed * delta;
                if( _me.posY > RoGlobal.MAP_H ) _me.posY = RoGlobal.MAP_H;
                _me.direction = _me.directions.Down;
                _me.action = Actions.Run;
            }
            else
            {
                _me.action = Actions.Wait;
            }
            //八方向移动控制逻辑结束
        }
        
        protected function onAttacked():void
        {
            _isAttacking = false;
            _me.action = Actions.Wait;
        }
    }
}