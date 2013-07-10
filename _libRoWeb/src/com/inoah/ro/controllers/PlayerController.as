package com.inoah.ro.controllers
{
    import com.D5Power.D5Game;
    import com.D5Power.Controler.Actions;
    import com.D5Power.Controler.CharacterControler;
    import com.D5Power.Controler.Perception;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Objects.GameObject;
    
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import starling.animation.IAnimatable;
    import starling.animation.Tween;
    
    public class PlayerController extends CharacterControler
    {
        protected var _chooseTarget:CharacterObject;
        protected var _atkTarget:CharacterObject;
        protected var _fightMode:uint = 0; // 攻击模式 0-无  1-追击 2-攻击
        protected var _lastHurt:uint; 
        protected var _animationUnitList:Vector.<IAnimatable>;
        /**
         * 攻击CD 
         */        
        private var _atkCd:uint = 2000;
        
        public function PlayerController(pec:Perception, ctrl:uint=2)
        {
            _animationUnitList = new Vector.<IAnimatable>();
            super(pec, ctrl);
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
            super.onClick(e);
        }
        
        override protected function clickSomeBody(o:GameObject):void
        {
            //if(o is NCharacterObject) Main.me.talk2NPC((o as NCharacterObject).uid)
            if(o.camp!=Global.userdata.camp)
            {
                // 敌人，设置为攻击目标
                _atkTarget = o as CharacterObject;
            }
            if( _chooseTarget  )
            {
                _chooseTarget.setChooseCircle( false );
                _chooseTarget = null;
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
                // 先判断攻击距离
                if(_fightMode==0 && Point.distance(_atkTarget._POS,_me._POS)>200)
                {
                    _endTarget = _atkTarget.PosX>_me.PosX ? new Point(_atkTarget.PosX-80,_atkTarget.PosY) : new Point(_atkTarget.PosX-80,_atkTarget.PosY);
                    walk2Target();
                    _fightMode = 1;
                }
                else
                {
                    _fightMode = 1;
                }
                
                if(_fightMode==1 && Point.distance(_atkTarget._POS,_me._POS)<=200)
                {
                    // 走入攻击范围，开始攻击
                    (_atkTarget.controler as MonsterController).fightTo(_me);
                    _fightMode = 2;
                }
                
                if(_fightMode==2)
                {
                    if(Global.Timer-_lastHurt>_atkCd )
                    {
                        _me.action = Actions.Attack;
                        _lastHurt = Global.Timer;
                        var tween:Tween = new Tween( _atkTarget , 0.4 );
                        tween.onComplete = onAttacked;
                        tween.onCompleteArgs = [_atkTarget]
                        appendAnimateUnit( tween );
                    }
                }
            }
            super.calcAction();
        }
        
        private function onAttacked( atkTarget:CharacterObject ):void
        {
            if( atkTarget.action != Actions.Attack )
            {
                atkTarget.action = Actions.BeAtk;
            }
            _me.action = Actions.Wait;

            atkTarget.hp-=10;    
            if(atkTarget.hp==0)
            {
                D5Game.me.scene.removeObject(atkTarget);
                //                            (Global.userdata as UserData).item = 2;
                _atkTarget = null;
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