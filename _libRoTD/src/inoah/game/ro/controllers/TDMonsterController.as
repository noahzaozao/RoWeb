package inoah.game.ro.controllers
{
    import flash.geom.Point;
    
    import inoah.core.Global;
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
        
        protected var _roadStep:int = 1;
        protected var _isMoving:Boolean;
        protected var _nextTarget:Point;
        
        public function TDMonsterController()
        {

        }
        
        override public function initialize():void
        {
            _scene = injector.getInstance(IBattleSceneMediator) as IBattleSceneMediator;
        }
        
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
            
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
        
        /**
         * 自动移动 
         */        
        protected function calMove( currentMonsterObj:IMonsterObject , index:int , delta:Number ):void
        {
            var currentPos:Point = scene.ViewToGrid( currentMonsterObj.posX , currentMonsterObj.posY );
            
            if( _roadStep>=scene.roadMap.length )
            {
                    _isMoving = false;
                    currentMonsterObj.action = ConstsActions.Wait;
            }
            else
            {
                if(_roadStep>=scene.roadMap.length )
                {
                    return;
                }
                var nextPos:Point = scene.roadMap[_roadStep];
                _nextTarget = scene.GridToView( nextPos.x , nextPos.y );
                _nextTarget.y += Global.TILE_H / 2;
                if( !_isMoving )
                {
                    _isMoving = true;
                    var radian:Number = GMath.getPointAngle( _nextTarget.x - currentMonsterObj.posX , _nextTarget.y -  currentMonsterObj.posY );
                    var angle:int = GMath.R2A(radian)+90;
                    currentMonsterObj.changeDirectionByAngle( angle );
                    currentMonsterObj.action = ConstsActions.Run;
                    currentMonsterObj.moveTo( _nextTarget.x , _nextTarget.y );
                }
                else if( currentMonsterObj.posX == _nextTarget.x && currentMonsterObj.posY == _nextTarget.y )
                {
                    _roadStep++;
                    _isMoving = false;
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