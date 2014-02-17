package inoah.game.td.modules.tower
{
    import flash.geom.Point;
    
    import inoah.core.Global;
    import inoah.core.base.BaseController;
    import inoah.core.consts.ConstsActions;
    import inoah.core.infos.BattleCharacterInfo;
    import inoah.game.ro.objects.BattleCharacterObject;
    import inoah.game.ro.objects.CharacterObject;
    import inoah.game.td.ConstsParticle;
    import inoah.interfaces.ICamera;
    import inoah.interfaces.IUserModel;
    import inoah.interfaces.character.IMonsterObject;
    import inoah.interfaces.character.IPlayerObject;
    import inoah.interfaces.managers.IDisplayMgr;
    import inoah.interfaces.map.ISceneMediator;
    import inoah.interfaces.tower.ITowerController;
    import inoah.interfaces.tower.ITowerObject;
    import inoah.utils.Counter;
    import inoah.utils.QTree;
    
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.ILogger;
    
    import starling.animation.Tween;
    import starling.display.Image;
    import starling.textures.Texture;
    
    public class TowerController extends BaseController implements ITowerController
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var logger:ILogger;
        
        [Inject]
        public var displayMgr:IDisplayMgr;
        
        [Inject]
        public var userModel:IUserModel;
        
        protected var camera:ICamera;
        
        protected var _towersList:Vector.<ITowerObject>;
        protected var _monsterList:Vector.<IMonsterObject>;
        protected var _atkTargetList:Vector.<BattleCharacterObject>;
        protected var _moveCounterList:Vector.<Counter>;
        protected var _atkCounterList:Vector.<Counter>;
        
        protected var _scene:ISceneMediator;
        
        public function TowerController()
        {
            _atkTargetList = new Vector.<BattleCharacterObject>( Global.MAX_MONSTER_NUM );
            _moveCounterList = new Vector.<Counter>( Global.MAX_MONSTER_NUM );
            _atkCounterList = new Vector.<Counter>( Global.MAX_MONSTER_NUM );
        }
        
        override public function initialize():void
        {
            _scene = injector.getInstance(ISceneMediator) as ISceneMediator;
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
                atkCounter.reset( currentObj.atkCd );
                
                calFindTarget( currentObj,  index , delta );
                var atkTarget:BattleCharacterObject = _atkTargetList[index];
                if( atkTarget )
                {
                    if( posCheck( currentObj , index, currentObj.atkRange ) )
                    {
                        var atkTargetInfo:BattleCharacterInfo = atkTarget.info as BattleCharacterInfo;
                        if( atkTarget.action == ConstsActions.Wait )
                        {
                            atkTarget.action = ConstsActions.BeAtk;
                        }
                        showAttack( currentObj , atkTarget );
                    }
                }
            }
        }
        
        private function showAttack( currentObj:ITowerObject , atkTarget:BattleCharacterObject ):void
        {
            if( !camera )
            {
                camera = injector.getInstance( ICamera );
            }
            
            var effectImg:Image = new Image( Texture.fromBitmap(new ConstsParticle.CIRCLE() ));
            displayMgr.unitLevel.addChild( effectImg );
            effectImg.x = currentObj.posX - camera.zeroX + Global.TILE_W / 4;
            effectImg.y = currentObj.posY - camera.zeroY + Global.TILE_H;
            
            var distance:int = Point.distance( new Point( effectImg.x , effectImg.y ) ,
                new Point( atkTarget.posX - camera.zeroX + Global.TILE_W / 4 , atkTarget.posY - camera.zeroY ) );
            var tween:Tween = new Tween( effectImg , distance / 250 );
            tween.animate("x" , atkTarget.posX - camera.zeroX + Global.TILE_W / 4 );
            tween.animate("y" , atkTarget.posY- camera.zeroY );
            tween.onComplete = onShowAttackComplete;
            tween.onCompleteArgs = [effectImg , atkTarget];
            appendAnimateUnit( tween );
        }
        
        private function onShowAttackComplete( effectImg:Image , atkTarget:BattleCharacterObject):void
        {
            effectImg.parent.removeChild( effectImg );
            effectImg.dispose();
            
            if( atkTarget.hp > 0 )
            {
                atkTarget.hp -= 10;
            }
            else
            {
                return;
            }
            if( atkTarget.hp == 0 )
            {
                userModel.info.zeny += 50;
                atkTarget.action = ConstsActions.Die;
                atkTarget.isDead = true;
                var tween:Tween = new Tween( atkTarget.viewObject, 3 );
                tween.fadeTo( 0 );
                tween.onComplete = onRemoveAtkTarget;
                tween.onCompleteArgs = [atkTarget];
                appendAnimateUnit( tween );
            }
        }
        
        private function onRemoveAtkTarget( atkTarget:CharacterObject ):void
        {
            _scene.removeObject(atkTarget);
        }
        
        protected function calFindTarget( currentObj:ITowerObject , index:int, delta:Number ):void
        {
            _atkTargetList[index] = null;
            
            var objList:Vector.<BattleCharacterObject> = new Vector.<BattleCharacterObject>();
            var i:int;
            var len:int;
            
            //遍历16区域
            var top:QTree = currentObj.qTree.parent.parent;
            objList = objList.concat( getAllDataFromTree( top ) );
            
            //临时随机找怪，随后可以根据面向找四象限的怪
            len = objList.length;
            var curDistance:Number;
            var tmpDistance:Number = int.MAX_VALUE;
            for ( i = 0 ; i< len;i++ )
            {
                curDistance = Point.distance( objList[i].POS , currentObj.POS );
                if( curDistance <= currentObj.atkRange )
                {
                    if( !(objList[i] as ITowerObject) && !(objList[i] as IPlayerObject) )
                    {
                        if( !objList[i].isDead )
                        {
                            if( tmpDistance > curDistance )
                            {
                                tmpDistance = curDistance;
                                _atkTargetList[index] = objList[i];
                            }
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