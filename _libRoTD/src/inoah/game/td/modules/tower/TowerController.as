package inoah.game.td.modules.tower
{
    import flash.geom.Point;
    
    import inoah.core.Global;
    import inoah.core.base.BaseController;
    import inoah.core.consts.ConstsActions;
    import inoah.core.infos.BattleCharacterInfo;
    import inoah.game.ro.objects.BattleCharacterObject;
    import inoah.interfaces.character.IMonsterObject;
    import inoah.interfaces.character.IPlayerObject;
    import inoah.interfaces.map.IBattleSceneMediator;
    import inoah.interfaces.tower.ITowerController;
    import inoah.interfaces.tower.ITowerObject;
    import inoah.utils.Counter;
    import inoah.utils.QTree;
    
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.ILogger;
    
    public class TowerController extends BaseController implements ITowerController
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var logger:ILogger;
        
        protected var _towersList:Vector.<ITowerObject>;
        protected var _monsterList:Vector.<IMonsterObject>;
        protected var _atkTargetList:Vector.<BattleCharacterObject>;
        protected var _moveCounterList:Vector.<Counter>;
        protected var _atkCounterList:Vector.<Counter>;
        protected var _fightModeList:Vector.<int>;
        protected var _scene:IBattleSceneMediator;
        
        public function TowerController()
        {
            _atkTargetList = new Vector.<BattleCharacterObject>( Global.MAX_MONSTER_NUM );
            _moveCounterList = new Vector.<Counter>( Global.MAX_MONSTER_NUM );
            _atkCounterList = new Vector.<Counter>( Global.MAX_MONSTER_NUM );
            _fightModeList = new Vector.<int>( Global.MAX_MONSTER_NUM );
        }
        
        override public function initialize():void
        {
            _scene = injector.getInstance(IBattleSceneMediator) as IBattleSceneMediator;
        }
        
        override public function tick(delta:Number):void
        {
            super.tick( delta );
            
            var len:int = _towersList.length;
            var currentObj:ITowerObject;
            for ( var i:int = 0;i<len;i++)
            {
                currentObj = _towersList[i];
                calAttack( currentObj , i , delta );
            }
        }
        
        private function calAttack( currentObj:ITowerObject, index:int, delta:Number):void
        {
            var atkTarget:BattleCharacterObject = _atkTargetList[index];
            if( !atkTarget )
            {
                calFindTarget( currentObj,  index , delta );
            }
            var fightMode:int = _fightModeList[index];
            
            if( atkTarget )
            {
                // 先判断攻击距离
                if( fightMode==1 && posCheck( currentObj , index, currentObj.atkRange ) )
                {
                    // 走入攻击范围，开始攻击
                    fightMode = 2;
                }
                else
                {
                    _fightModeList[index] = 1;
                }
                
                if( fightMode==2 && posCheck( currentObj , index, currentObj.atkRange ) )
                {
                    var atkCounter:Counter = _atkCounterList[index];
                    if( atkCounter == null )
                    {
                        _atkCounterList[index] = new Counter();
                        atkCounter = _atkCounterList[index];
                        atkCounter.initialize();
                        atkCounter.reset( currentObj.atkCd );
                    }
                    atkCounter.tick( delta );
                    if( atkCounter.expired )
                    {
                        var atkTargetInfo:BattleCharacterInfo = atkTarget.info as BattleCharacterInfo;
                        if( atkTarget.action == ConstsActions.Wait )
                        {
                            atkTarget.action = ConstsActions.BeAtk;
                        }
                        
                        logger.debug( "attack" );
                        
                        if( atkTargetInfo.hpCurrent==0)
                        {
                            _scene.removeObject(atkTarget);
                            _atkTargetList[index] = null;
                        }
                        atkCounter.reset( currentObj.atkCd );
                    }
                }
                else
                {
                    _fightModeList[index]==1;
                }
            }
        }
        
        protected function calFindTarget( currentObj:ITowerObject , index:int, delta:Number ):void
        {
            var objList:Vector.<BattleCharacterObject> = new Vector.<BattleCharacterObject>();
            var i:int;
            var len:int;
            
            //遍历16区域
            var top:QTree = currentObj.qTree.parent.parent;
            objList = objList.concat( getAllDataFromTree( top ) );
            
            //临时随机找怪，随后可以根据面向找四象限的怪
            len = objList.length;
            for ( i = 0 ; i< len;i++ )
            {
                if( _fightModeList[index]==0  && Point.distance( objList[i].POS , currentObj.POS ) <= currentObj.atkRange )
                {
                    if( !(objList[i] as ITowerObject) && !(objList[i] as IPlayerObject) )
                    {
                        if( !objList[i].isDead )
                        {
                            _atkTargetList[index] = objList[i];
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
        
        protected function posCheck( currentMonsterObj:ITowerObject  , index:int , value:int ):Boolean
        {
            var atkTarget:BattleCharacterObject = _atkTargetList[index];
            return int(Point.distance(atkTarget.POS,currentMonsterObj.POS))<=value;
        }
        
        public function get towersList():Vector.<ITowerObject>
        {
            return _towersList;
        }
        
        public function set towersList( value:Vector.<ITowerObject> ):void
        {
            _towersList = value;
        }
        
        public function set monsterList( value:Vector.<IMonsterObject> ):void
        {
            _monsterList = value;
        }
        
        public function get monsterList():Vector.<IMonsterObject>
        {
            return _monsterList;
        }
    }
}