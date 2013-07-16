package com.inoah.ro.controllers
{
    import com.D5Power.D5Game;
    import com.D5Power.Controler.Actions;
    import com.D5Power.Controler.NCharacterControler;
    import com.D5Power.Controler.Perception;
    import com.D5Power.GMath.GMath;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Objects.GameObject;
    import com.D5Power.map.WorldMap;
    
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import starling.animation.IAnimatable;
    import starling.animation.Tween;
    
    public class MonsterController extends NCharacterControler
    {
        private var _lastAutoMove:int;
        private var _atkTarget:CharacterObject;
        private var _fightMode:int;
        private var _lastHurt:uint;
        private var _movCd:uint = 3000;
        private var _atkCd:uint = 3000;
        protected var _animationUnitList:Vector.<IAnimatable>;
        private var _isDie:Boolean;
        
        public function MonsterController(pec:Perception)
        {
            _animationUnitList = new Vector.<IAnimatable>();
            super(pec);
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
        
        public function closeAutoMove():void
        {
            _lastAutoMove=-1;
        }
        
        public function fightTo(obj:GameObject):void
        {
            var a:Number = GMath.getPointAngle(_me.PosX-obj.PosX,_me.PosY-obj.PosY);
            a = GMath.R2A(a)-90;
            changeDirectionByAngle(a);
            closeAutoMove();
            _atkTarget = obj as CharacterObject;
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
        
        override public function calcAction():void
        {
            if( _me.action == Actions.Die )
            {
                _isDie = true;
                return;
            }
            if( _isDie )
            {
                return;
            }
                
            if( _atkTarget == null && _lastAutoMove!=-1 && Global.Timer-_lastAutoMove>_movCd)
            {
                // 自动移动
                _lastAutoMove = Global.Timer;
                var nextX:int = Math.random()>0.5 ? _me.PosX+int(Math.random()*30) : _me.PosX-int(Math.random()*30);
                var nextY:int = Math.random()>0.5 ? _me.PosY+int(Math.random()*30) : _me.PosY-int(Math.random()*30);
                // 不可移出屏幕
                if(nextX>Global.MAPSIZE.x || nextX<0) return;
                if(nextY>Global.MAPSIZE.y || nextY<0) return;
                // 不可移动到地图非0区域
                var p:Point = WorldMap.me.Postion2Tile(nextX,nextY);
                if(WorldMap.me.roadMap && WorldMap.me.roadMap[p.y] && WorldMap.me.roadMap[p.y][p.x]!=0) return;
                
                moveTo(nextX,nextY);
            }
            
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
                
                if(_fightMode==1 && posCheck( 100 ) )
                {
                    // 走入攻击范围，开始攻击
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
                        var radian:Number = GMath.getPointAngle(_atkTarget.PosX-_me.PosX,_atkTarget.PosY-_me.PosY);
                        var angle:int = GMath.R2A(radian)+90;
                        changeDirectionByAngle( angle );
                        
                        _me.action = Actions.Attack;
                        _lastHurt = Global.Timer;
                        var tween:Tween = new Tween( _atkTarget , 0.4 );
                        tween.onComplete = onAttacked;
                        tween.onCompleteArgs = [_atkTarget]
                        appendAnimateUnit( tween );
                        return;
                    }
                }
                else
                {
                    _fightMode==1;
                }
            }
            super.calcAction();
        }
        
        private function onAttacked( atkTarget:CharacterObject ):void
        {
            if( atkTarget.action == Actions.Wait )
            {
                atkTarget.action = Actions.BeAtk;
            }
            _me.action = Actions.Wait;

            var textField:TextField = new TextField();
            var tf:TextFormat = new TextFormat( "宋体" , 28 , 0xff0000 , true );
            textField.defaultTextFormat = tf;
            textField.text = "2";
            textField.filters = [new GlowFilter( 0, 1, 2, 2, 5, 1)];
            textField.y = -50;
            textField.x = - textField.textWidth >> 1;
            atkTarget.addChild( textField );
            var tween:Tween = new Tween( textField , 0.6 );
            tween.moveTo( - textField.textWidth >> 1, - 150 );
            tween.onComplete = onBlooded;
            tween.onCompleteArgs = [textField];
            appendAnimateUnit( tween );
            
            atkTarget.hp-=2;    
            
            if(atkTarget.hp==0)
            {
                D5Game.me.scene.removeObject(atkTarget);
                _atkTarget = null;
            }
        }
        
        private function onBlooded( textField:TextField ):void
        {
            textField.parent.removeChild( textField );
        }
    }
}