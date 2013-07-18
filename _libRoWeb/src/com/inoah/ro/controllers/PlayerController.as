package com.inoah.ro.controllers
{
    import com.D5Power.D5Game;
    import com.D5Power.Controler.Actions;
    import com.D5Power.Controler.CharacterControler;
    import com.D5Power.Controler.Perception;
    import com.D5Power.GMath.GMath;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Objects.GameObject;
    import com.inoah.ro.consts.BattleCommands;
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.objects.PlayerObject;
    
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import as3.patterns.facade.Facade;
    
    import starling.animation.IAnimatable;
    import starling.animation.Tween;
    
    public class PlayerController extends CharacterControler
    {
        protected var _fightMode:uint = 0; // 攻击模式 0-无  1-追击 2-攻击
        protected var _atkTarget:CharacterObject;
        protected var _chooseTarget:CharacterObject;

        protected var _lastHurt:uint; 
        protected var _atkCd:uint = 2000;
        
        protected var _lastRecover:uint; 
        protected var _recoverCd:uint = 3000;
        
        protected var _animationUnitList:Vector.<IAnimatable>;

        public function get atkCd():uint
        {
            var rate:Number = 1- (_me as PlayerObject).info.aspd / 100;
            if( rate >=  1 )
            {
                rate = 0.01;
            }
            return _atkCd * rate;
        }
        
        public function PlayerController(pec:Perception, ctrl:uint=2)
        {
            _animationUnitList = new Vector.<IAnimatable>();
            super(pec, ctrl);
        }
        
        protected function posCheck( value:int ):Boolean
        {
            return int(Point.distance(_atkTarget._POS,_me._POS))<=value;
        }
        
        public function appendAnimateUnit(animateUnit:IAnimatable):void
        {
            if(_animationUnitList.indexOf(animateUnit)<0)
            {
                _animationUnitList.push(animateUnit);
            }
        }
        
        override protected function onClick(e:MouseEvent):void
        {
            _atkTarget = null;
            if( _chooseTarget  )
            {
                _chooseTarget.setChooseCircle( false );
                _chooseTarget = null;
            }
            super.onClick(e);
            
        }
        
        override protected function clickSomeBody(o:GameObject):void
        {
            //if(o is NCharacterObject) Main.me.talk2NPC((o as NCharacterObject).uid)
            if(o.camp!=Global.userdata.camp)
            {
                // 敌人，设置为攻击目标
                _atkTarget = o as CharacterObject;
                _fightMode = 0;
            }
            if( o != _me )
            {
                _chooseTarget = o as CharacterObject;
                _chooseTarget.setChooseCircle( true );
                
            }
            super.clickSomeBody(o);
        }
        
        override public function calcAction():void
        {
            if(_atkTarget!=null)
            {
                calAttackMove();
                calAttack();
            }
            calRecover();
            super.calcAction();
        }
        
        private function calAttackMove():void
        {
            // 先判断攻击距离
            if(_fightMode==0 && posCheck( 100 ) )
            {
                if( _endTarget )
                {
                    _endTarget = null;
                    stopMove();
                }
                _fightMode = 2;
            }
            else 
            {
                _fightMode = 1;
            }
            
            if(_fightMode==1 && posCheck( 100 ))
            {
                // 走入攻击范围，开始攻击
                (_atkTarget.controler as MonsterController).fightTo(_me);
                if( _endTarget )
                {
                    _endTarget = null;
                    stopMove();
                }
                _fightMode = 2;
            }
            else
            {
                _endTarget = new Point( _atkTarget.PosX , _atkTarget.PosY );
                walk2Target();
            }
        }
        
        private function calAttack():void
        {
            if(_fightMode==2 && posCheck( 100 ) )
            {
                if( _endTarget )
                {
                    _endTarget = null;
                    stopMove();
                }
                if( Global.Timer - _lastHurt > atkCd )
                {
                    if( _atkTarget.action == Actions.Die )
                    {
                        _atkTarget = null;
                        return;
                    }
                    var radian:Number = GMath.getPointAngle(_atkTarget.PosX-_me.PosX,_atkTarget.PosY-_me.PosY);
                    var angle:int = GMath.R2A(radian)+90;
                    changeDirectionByAngle( angle );
                    
                    _me.action = Actions.Attack;
                    _lastHurt = Global.Timer;
                    var tween:Tween = new Tween( _atkTarget , 0.4 );
                    tween.onComplete = onAttacked;
                    tween.onCompleteArgs = [_atkTarget]
                    appendAnimateUnit( tween );
                }
            }
            else
            {
                _fightMode = 1;
            }
        }
        
        private function calRecover():void
        {
            if( Global.Timer - _lastRecover > _recoverCd )
            {
                (_me as PlayerObject).hp += 1;
                (_me as PlayerObject).sp += 1;
                _lastRecover = Global.Timer;
            }
        }
        
        private function onAttacked( atkTarget:CharacterObject ):void
        {
            (atkTarget.controler as MonsterController).fightTo(_me);
            
            if( atkTarget.action != Actions.Attack && atkTarget.action != Actions.Die )
            {
                atkTarget.action = Actions.BeAtk;
            }
            _me.action = Actions.Wait;
            
            Facade.getInstance().sendNotification( BattleCommands.ATTACK , [_me, _atkTarget] );
            
            if(atkTarget.hp==0)
            {
                _atkTarget = null;
                if( _chooseTarget )
                {
                    _chooseTarget.setChooseCircle( false );
                    _chooseTarget = null;
                }
            }
        }
        
        public function tick( delta:Number ):void
        {
            var len:int = _animationUnitList.length;
            var animateUnit:IAnimatable;
            
            for(var i:int = 0; i<len; i++)
            {
                animateUnit = _animationUnitList[i];
                animateUnit.advanceTime(delta);
                
                if((animateUnit as Object).hasOwnProperty("isComplete") == true &&
                    animateUnit["isComplete"] == true )
                {
                    _animationUnitList.splice(i,1);
                    len--;
                    i--;
                    continue;
                }
            }
        }
    }
}