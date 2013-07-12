package com.inoah.ro.controllers
{
    import com.D5Power.D5Game;
    import com.D5Power.Controler.Actions;
    import com.D5Power.Controler.CharacterControler;
    import com.D5Power.Controler.Perception;
    import com.D5Power.GMath.GMath;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Objects.GameObject;
    
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
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
                
                if(_fightMode==2 && posCheck( 100 ) )
                {
                    if( _endTarget )
                    {
                        _endTarget = null;
                        stopMove();
                    }
                    if(Global.Timer-_lastHurt>_atkCd )
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
            super.calcAction();
        }
        
        private function onAttacked( atkTarget:CharacterObject ):void
        {
            (atkTarget.controler as MonsterController).fightTo(_me);
            
            if( atkTarget.action != Actions.Attack && atkTarget.action != Actions.Die )
            {
                atkTarget.action = Actions.BeAtk;
            }
            _me.action = Actions.Wait;
            
            var textField:TextField = new TextField();
            var tf:TextFormat = new TextFormat( "宋体" , 28 , 0xffffff );
            textField.defaultTextFormat = tf;
            textField.text = "10";
            textField.filters = [new GlowFilter( 0, 1, 2, 2, 5, 1)];
            textField.y = -50;
            textField.x = - textField.textWidth >> 1;
            atkTarget.addChild( textField );
            var tween:Tween = new Tween( textField , 0.6 );
            tween.moveTo( - textField.textWidth >> 1, - 150 );
            tween.onComplete = onBlooded;
            tween.onCompleteArgs = [textField];
            appendAnimateUnit( tween );
            
            atkTarget.hp-=10; 
            
            if(atkTarget.hp==0)
            {
                atkTarget.action = Actions.Die;
                tween = new Tween( atkTarget, 5 );
                tween.fadeTo( 0 );
                tween.onComplete = onRemoveAtkTarget;
                tween.onCompleteArgs = [atkTarget];
                appendAnimateUnit( tween );
                //                D5Game.me.scene.removeObject(atkTarget);
                //                            (Global.userdata as UserData).item = 2;
                _atkTarget = null;
                _chooseTarget.setChooseCircle( false );
                _chooseTarget = null;
            }
        }
        
        private function onRemoveAtkTarget( atkTarget:CharacterObject ):void
        {
            D5Game.me.scene.removeObject(atkTarget);
        }
        
        private function onBlooded( textField:TextField ):void
        {
            textField.parent.removeChild( textField );
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