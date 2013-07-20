package com.inoah.ro.controllers
{
    //    import com.D5Power.D5Game;
    //    import com.D5Power.Controler.Actions;
    //    import com.D5Power.Controler.NCharacterControler;
    //    import com.D5Power.Controler.Perception;
    //    import com.D5Power.GMath.GMath;
    //    import com.D5Power.Objects.CharacterObject;
    //    import com.D5Power.Objects.GameObject;
    //    import com.D5Power.map.WorldMap;
    //    import com.inoah.ro.consts.BattleCommands;
    //    import com.inoah.ro.objects.PlayerObject;
    //    
    //    import flash.filters.GlowFilter;
    //    import flash.geom.Point;
    //    import flash.text.TextField;
    //    import flash.text.TextFormat;
    //    
    //    import as3.patterns.facade.Facade;
    //    
    //    import starling.animation.IAnimatable;
    //    import starling.animation.Tween;
    //    
    public class MonsterController //extends NCharacterControler
    {
        //        private var _fightMode:int;
        //        private var _atkTarget:CharacterObject;
        //        
        //        private var _isDie:Boolean;
        //
        //        private var _lastHurt:uint;
        //        private var _atkCd:uint = 3000;
        //        private var _lastAutoMove:int;
        //        private var _movCd:uint = 3000;
        //        protected var _lastRecover:uint; 
        //        protected var _recoverCd:uint = 5000;
        //
        //        protected var _animationUnitList:Vector.<IAnimatable>;
        //        
        //        public function get atkCd():uint
        //        {
        //            var rate:Number = 1- (_me as PlayerObject).info.aspd / 100;
        //            if( rate >=  1 )
        //            {
        //                rate = 0.01;
        //            }
        //            return _atkCd * rate;
        //        }
        //        
        public function MonsterController()//pec:Perception)
        {
            //            _animationUnitList = new Vector.<IAnimatable>();
            //            super(pec);
        }
        //        
        //        protected function posCheck( value:int ):Boolean
        //        {
        //            return int(Point.distance(_atkTarget._POS,_me._POS))<=value;
        //        }
        //        
        //        public function appendAnimateUnit(animateUnit:IAnimatable):void
        //        {
        //            if(_animationUnitList.indexOf(animateUnit)<0)
        //            {
        //                _animationUnitList.push(animateUnit);
        //            }
        //        }
        //        
        //        public function closeAutoMove():void
        //        {
        //            _lastAutoMove=-1;
        //        }
        //        
        //        public function fightTo(obj:GameObject):void
        //        {
        //            if( _atkTarget != obj )
        //            {
        //                var a:Number = GMath.getPointAngle(_me.PosX-obj.PosX,_me.PosY-obj.PosY);
        //                a = GMath.R2A(a)-90;
        //                changeDirectionByAngle(a);
        //                closeAutoMove();
        //                _atkTarget = obj as CharacterObject;
        //                _lastHurt = Global.Timer - _atkCd / 2;
        //            }
        //        }
        //        
        //        public function tick( delta:Number ):void
        //        {
        //            var len:int = _animationUnitList.length;
        //            var animateUnit:IAnimatable;
        //            
        //            for(var i:int = 0; i<len; i++)
        //            {
        //                animateUnit = _animationUnitList[i];
        //                animateUnit.advanceTime(delta);
        //                
        //                if((animateUnit as Object).hasOwnProperty("isComplete") == true &&
        //                    animateUnit["isComplete"] == true )
        //                {
        //                    _animationUnitList.splice(i,1);
        //                    len--;
        //                    i--;
        //                    continue;
        //                }
        //            }
        //        }
        //        
        //        override public function calcAction():void
        //        {
        //            if( _me.action == Actions.Die )
        //            {
        //                _isDie = true;
        //                return;
        //            }
        //            if( _isDie )
        //            {
        //                return;
        //            }
        //            
        //            calMove();
        //            if(_atkTarget!=null)
        //            {
        //                calAttackMove();
        //                calAttack();
        //            }
        //            calRecover();
        //            super.calcAction();
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
        //        private function calAttack():void
        //        {
        //            if(_fightMode==1 && posCheck( 100 ) )
        //            {
        //                // 走入攻击范围，开始攻击
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
        //            
        //            if(_fightMode==2 && posCheck( 100 ) )
        //            {
        //                if( _endTarget )
        //                {
        //                    _endTarget = null;
        //                    stopMove();
        //                }
        //                if(Global.Timer-_lastHurt>_atkCd )
        //                {
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
        //                    return;
        //                }
        //            }
        //            else
        //            {
        //                _fightMode==1;
        //            }
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
        //        }
        //        
        //        private function calMove():void
        //        {
        //            if( _atkTarget == null && _lastAutoMove!=-1 && Global.Timer-_lastAutoMove>_movCd)
        //            {
        //                // 自动移动
        //                _lastAutoMove = Global.Timer;
        //                var nextX:int = Math.random()>0.5 ? _me.PosX+int(Math.random()*30) : _me.PosX-int(Math.random()*30);
        //                var nextY:int = Math.random()>0.5 ? _me.PosY+int(Math.random()*30) : _me.PosY-int(Math.random()*30);
        //                // 不可移出屏幕
        //                if(nextX>Global.MAPSIZE.x || nextX<0) return;
        //                if(nextY>Global.MAPSIZE.y || nextY<0) return;
        //                // 不可移动到地图非0区域
        //                var p:Point = WorldMap.me.Postion2Tile(nextX,nextY);
        //                if(WorldMap.me.roadMap && WorldMap.me.roadMap[p.y] && WorldMap.me.roadMap[p.y][p.x]!=0) return;
        //                
        //                moveTo(nextX,nextY);
        //            }
        //        }
        //        
        //        private function onAttacked( atkTarget:CharacterObject ):void
        //        {
        //            if( atkTarget.action == Actions.Wait )
        //            {
        //                atkTarget.action = Actions.BeAtk;
        //            }
        //            _me.action = Actions.Wait;
        //
        //            Facade.getInstance().sendNotification( BattleCommands.ATTACK , [_me, _atkTarget] );
        //            
        //            if(atkTarget.hp==0)
        //            {
        //                D5Game.me.scene.removeObject(atkTarget);
        //                _atkTarget = null;
        //            }
        //        }
    }
}