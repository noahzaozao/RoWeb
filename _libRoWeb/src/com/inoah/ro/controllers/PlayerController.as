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
    
    public class PlayerController extends CharacterControler
    {
        private var _atkTarget:CharacterObject;
        private var _fightMode:uint = 0; // 攻击模式 0-无  1-追击 2-攻击
        private var _lastHurt:uint; 
        /**
         * 攻击CD 
         */        
        private var _atkCd:uint = 500;
        
        public function PlayerController(pec:Perception, ctrl:uint=2)
        {
            super(pec, ctrl);
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
                    _me.action = Actions.Attack;
                    
                    (_atkTarget.controler as MonsterController).fightTo(_me);
                    _fightMode = 2;
                }
                
                if(_fightMode==2)
                {
                    if(Global.Timer-_lastHurt>_atkCd )
                    {
                        _lastHurt = Global.Timer;
                        _atkTarget.hp-=10;
                        
                        (_me as CharacterObject).hp-=5;
                        if(_atkTarget.hp==0)
                        {
                            D5Game.me.scene.removeObject(_atkTarget);
                            //                            (Global.userdata as UserData).item = 2;
                            _me.action = Actions.Wait;
                            _atkTarget = null;
                        }
                    }
                    
                }
            }
            super.calcAction();
        }
    }
}