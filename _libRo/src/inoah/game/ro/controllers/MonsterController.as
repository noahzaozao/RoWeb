package inoah.game.ro.controllers
{
    import flash.geom.Point;
    
    import inoah.core.Global;
    import inoah.core.base.BaseController;
    import inoah.core.consts.ConstsActions;
    import inoah.core.infos.BattleCharacterInfo;
    import inoah.core.utils.GMath;
    import inoah.game.ro.objects.BattleCharacterObject;
    import inoah.game.ro.objects.MonsterObject;
    import inoah.interfaces.ISceneMediator;
    import inoah.utils.Counter;
    
    import starling.animation.Tween;
    
    
    public class MonsterController extends BaseController
    {
        protected var _monsterList:Vector.<MonsterObject>;
        protected var _atkTargetList:Vector.<BattleCharacterObject>;
        protected var _moveCounterList:Vector.<Counter>;
        protected var _atkCounterList:Vector.<Counter>;
        /**
         * 战斗模式，0无，1追击，2攻击 
         */        
        protected var _fightModeList:Vector.<int>;
        protected var _scene:ISceneMediator;
        
        public function MonsterController( scene:ISceneMediator )
        {
            //            super( ConstsGame.MONSTER_CONTROLLER );
            //            _scene = scene;
            //            _atkTargetList = new Vector.<BattleCharacterObject>( Global.MAX_MONSTER_NUM );
            //            _moveCounterList = new Vector.<Counter>( Global.MAX_MONSTER_NUM );
            //            _atkCounterList = new Vector.<Counter>( Global.MAX_MONSTER_NUM );
            //            _fightModeList = new Vector.<int>( Global.MAX_MONSTER_NUM );
        }
        
        public function fightTo( monster:MonsterObject ,  obj:BattleCharacterObject ):void
        {
            var index:int = _monsterList.indexOf( monster );
            var atkTarget:BattleCharacterObject = _atkTargetList[index];
            if( atkTarget != obj )
            {
                var a:Number = GMath.getPointAngle( monster.posX-obj.posX, monster.posY-obj.posY);
                a = GMath.R2A(a)-90;
                monster.changeDirectionByAngle(a);
                _atkTargetList[index] = obj;
                var atkCounter:Counter = _atkCounterList[index];
                if( atkCounter == null )
                {
                    atkCounter = new Counter();
                    atkCounter.initialize();
                }
                atkCounter.reset( monster.atkCd / 2 );
            }
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
            
            var len:int = _monsterList.length;
            var currentMonsterObj:MonsterObject;
            for ( var i:int = 0;i<len;i++)
            {
                currentMonsterObj = _monsterList[i];
                if( currentMonsterObj.isDead )
                {
                    continue;
                }
                if( _fightModeList[i] == 0 )
                {
                    calMove( currentMonsterObj , i , delta );
                }
                calAttackMove( currentMonsterObj, i, delta );
                calAttack( currentMonsterObj, i, delta );
            }
        }
        
        /**
         * 自动移动 
         */        
        protected function calMove( currentMonsterObj:MonsterObject , index:int , delta:Number ):void
        {
            var atkTarget:BattleCharacterObject = _atkTargetList[index];
            var isMove:Boolean = Math.random() * 10 < 3;
            if( atkTarget == null && isMove)
            {
                var moveCounter:Counter = _moveCounterList[index];
                if( moveCounter == null )
                {
                    _moveCounterList[index] = new Counter();
                    moveCounter = _moveCounterList[index];
                    moveCounter.initialize();
                    moveCounter.reset( currentMonsterObj.moveCd );
                }
                moveCounter.tick( delta );
                if( moveCounter.expired )
                {
                    // 自动移动
                    var nextX:int = Math.random()>0.5 ? currentMonsterObj.posX+int(Math.random()*50) : currentMonsterObj.posX-int(Math.random()*50);
                    var nextY:int = Math.random()>0.5 ? currentMonsterObj.posY+int(Math.random()*50) : currentMonsterObj.posY-int(Math.random()*50);
                    // 不可移出屏幕
                    if(nextX>Global.MAP_W || nextX<0) return;
                    if(nextY>Global.MAP_H || nextY<0) return;
                    // 不可移动到地图非0区域
                    
                    currentMonsterObj.action = ConstsActions.Run;
                    currentMonsterObj.moveTo(nextX,nextY);
                    moveCounter.reset( currentMonsterObj.moveCd );
                }
            }
        }
        
        /**
         * 攻击移动判定
         */        
        protected function calAttackMove( currentMonsterObj:MonsterObject , index:int , delta:Number ):void
        {
            var atkTarget:BattleCharacterObject = _atkTargetList[index];
            var fightMode:int = _fightModeList[index];
            if( atkTarget )
            {
                // 先判断攻击距离
                if( fightMode==0 && posCheck( currentMonsterObj , index, currentMonsterObj.atkRange ) )
                {
                    if( currentMonsterObj.endTarget )
                    {
                        currentMonsterObj.endTarget = null;
                        currentMonsterObj.stopMove();
                    }
                    _fightModeList[index] = 2;
                }
                else
                {
                    _fightModeList[index] = 1;
                }
            }
        }
        
        protected function posCheck( currentMonsterObj:MonsterObject  , index:int , value:int ):Boolean
        {
            var atkTarget:BattleCharacterObject = _atkTargetList[index];
            return int(Point.distance(atkTarget.POS,currentMonsterObj.POS))<=value;
        }
        
        protected function calAttack( currentMonsterObj:MonsterObject , index:int , delta:Number ):void
        {
            var atkTarget:BattleCharacterObject = _atkTargetList[index];
            var fightMode:int = _fightModeList[index];
            if( atkTarget )
            {
                if( fightMode==1 && posCheck( currentMonsterObj , index, currentMonsterObj.atkRange ) )
                {
                    // 走入攻击范围，开始攻击
                    if( currentMonsterObj.endTarget )
                    {
                        currentMonsterObj.endTarget = null;
                        currentMonsterObj.stopMove();
                    }
                    fightMode = 2;
                }
                else
                {
                    currentMonsterObj.action = ConstsActions.Run;
                    currentMonsterObj.moveTo( atkTarget.posX , atkTarget.posY );
                }
                
                if( fightMode==2 && posCheck( currentMonsterObj , index, currentMonsterObj.atkRange ) )
                {
                    if( currentMonsterObj.action == ConstsActions.Run )
                    {
                        currentMonsterObj.action = ConstsActions.Wait;
                    }
                    if( currentMonsterObj.endTarget )
                    {
                        currentMonsterObj.endTarget = null;
                        currentMonsterObj.stopMove();
                    }
                    var atkCounter:Counter = _atkCounterList[index];
                    if( atkCounter == null )
                    {
                        _atkCounterList[index] = new Counter();
                        atkCounter = _atkCounterList[index];
                        atkCounter.initialize();
                        atkCounter.reset( currentMonsterObj.atkCd );
                    }
                    atkCounter.tick( delta );
                    if( atkCounter.expired )
                    {
                        var radian:Number = GMath.getPointAngle(atkTarget.posX-currentMonsterObj.posX,atkTarget.posY-currentMonsterObj.posY);
                        var angle:int = GMath.R2A(radian)+90;
                        currentMonsterObj.changeDirectionByAngle( angle );
                        
                        currentMonsterObj.action = ConstsActions.Attack;
                        var tween:Tween = new Tween( atkTarget , 0.4 );
                        tween.onComplete = onAttacked;
                        tween.onCompleteArgs = [currentMonsterObj , index];
                        appendAnimateUnit( tween );
                        
                        atkCounter.reset( currentMonsterObj.atkCd );
                    }
                }
                else
                {
                    _fightModeList[index]==1;
                }
            }
        }
        
        protected function onAttacked( currentMonsterObj:BattleCharacterObject , index:int ):void
        {
            var atkTarget:BattleCharacterObject = _atkTargetList[index];
            var atkTargetInfo:BattleCharacterInfo = atkTarget.info as BattleCharacterInfo;
            if( atkTarget.action == ConstsActions.Wait )
            {
                atkTarget.action = ConstsActions.BeAtk;
            }
            currentMonsterObj.action = ConstsActions.Wait;
            
            //            facade.sendNotification( BattleCommands.MONSTER_ATTACK , [currentMonsterObj, atkTarget] );
            
            if( atkTargetInfo.hpCurrent==0)
            {
                scene.removeObject(atkTarget);
                _atkTargetList[index] = null;
            }
        }
        
        public function get scene():ISceneMediator
        {
            return _scene;
        }
        
        public function set monsterList( value:Vector.<MonsterObject> ):void
        {
            _monsterList = value;
        }
        
        public function get monsterList():Vector.<MonsterObject>
        {
            return _monsterList;
        }
    }
}