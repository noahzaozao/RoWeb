package inoah.game.td.controllers
{
    import flash.geom.Point;
    
    import inoah.core.base.BaseController;
    import inoah.core.consts.ConstsActions;
    import inoah.core.utils.GMath;
    import inoah.interfaces.character.IMonsterObject;
    import inoah.interfaces.controller.IMonsterController;
    import inoah.interfaces.map.IBattleSceneMediator;
    import inoah.interfaces.map.IScene;
    
    import robotlegs.bender.framework.api.IInjector;
    
    
    public class TDMonsterController extends BaseController implements IMonsterController
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var scene:IScene;
        
        protected var _monsterList:Vector.<IMonsterObject>;
        protected var _scene:IBattleSceneMediator;
        
        protected var _roadStepList:Vector.<int>;
        protected var _nextTargetList:Vector.<Point>;
        protected var _isMovingList:Vector.<Boolean>;
        protected var _couldTick:Boolean;
        
        public function TDMonsterController()
        {
            reset();
        }
        
        override public function reset():void
        {
            _roadStepList = new Vector.<int>();
            _nextTargetList = new Vector.<Point>();
            _isMovingList = new Vector.<Boolean>();
            _couldTick = true;           
        }
        
        override public function initialize():void
        {
            _scene = injector.getInstance(IBattleSceneMediator) as IBattleSceneMediator;
            
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
            if( _couldTick )
            {
                var len:int = _monsterList.length;
                var currentMonsterObj:IMonsterObject;
                for ( var i:int = 0;i<len;i++)
                {
                    currentMonsterObj = _monsterList[i];
                    if( currentMonsterObj.isDead )
                    {
                        continue;
                    }
                    calMove( currentMonsterObj , i , delta );
                }
            }
        }
        
        /**
         * 自动移动 
         */        
        protected function calMove( currentMonsterObj:IMonsterObject , index:int , delta:Number ):void
        {
            var currentPos:Point = scene.ViewToGrid( currentMonsterObj.posX , currentMonsterObj.posY );
            
            if( _roadStepList.length <= index )
            {
                _roadStepList[index] = 1;
                _isMovingList[index] = false;
            }
            if( _roadStepList[index] >=scene.roadMap.length )
            {
                _isMovingList[index] = false;
                currentMonsterObj.action = ConstsActions.Wait;
            }
            else
            {
                if( _roadStepList[index] >= scene.roadMap.length )
                {
                    return;
                }
                var nextPos:Point = scene.roadMap[ _roadStepList[index] ];
                _nextTargetList[index] = scene.GridToView( nextPos.x , nextPos.y );
                if( !_isMovingList[index] )
                {
                    _isMovingList[index] = true;
                    var radian:Number = GMath.getPointAngle( _nextTargetList[index].x - currentMonsterObj.posX , _nextTargetList[index].y -  currentMonsterObj.posY );
                    var angle:int = GMath.R2A(radian)+90;
                    currentMonsterObj.changeDirectionByAngle( angle );
                    currentMonsterObj.action = ConstsActions.Run;
                    currentMonsterObj.moveTo( _nextTargetList[index].x , _nextTargetList[index].y );
                }
                else if( currentMonsterObj.posX == _nextTargetList[index].x && currentMonsterObj.posY == _nextTargetList[index].y )
                {
                    _roadStepList[index] ++;
                    _isMovingList[index] = false;
                }
            }
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