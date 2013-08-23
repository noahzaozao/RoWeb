package inoah.game.td.modules.map.view.mediators
{
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import inoah.core.Global;
    import inoah.core.base.BaseObject;
    import inoah.core.characters.gpu.MonsterViewGpu;
    import inoah.core.consts.ConstsActions;
    import inoah.core.infos.BattleCharacterInfo;
    import inoah.game.ro.modules.map.view.events.SceneEvent;
    import inoah.game.ro.modules.map.view.mediators.BaseSceneMediator;
    import inoah.game.ro.objects.MonsterObject;
    import inoah.game.td.objects.TowerObject;
    import inoah.interfaces.character.IMonsterObject;
    import inoah.interfaces.controller.IMonsterController;
    import inoah.interfaces.managers.IAssetMgr;
    import inoah.interfaces.managers.ITextureMgr;
    import inoah.interfaces.map.ITDSceneMediator;
    import inoah.interfaces.tower.ITowerController;
    import inoah.interfaces.tower.ITowerObject;
    import inoah.utils.Counter;
    import inoah.utils.QTree;
    
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.ILogger;
    
    import starling.display.Sprite;
    
    public class TDSceneMediator extends BaseSceneMediator implements ITDSceneMediator
    {
        [Inject]
        public var injector:IInjector; 
        
        [Inject]
        public var logger:ILogger;
        
        [Inject]
        public var assetMgr:IAssetMgr;
        
        [Inject]
        public var textureMgr:ITextureMgr;
        
        [Inject]
        public var monsterController:IMonsterController;
        
        [Inject]
        public var towerController:ITowerController;
        
        protected var _monsterObjList:Vector.<IMonsterObject>;
        protected var _towersList:Vector.<ITowerObject>;
        protected var _monsterList:Vector.<MonsterViewGpu>;
        
        public function TDSceneMediator()
        {
            super();
        }
        
        override public function initialize():void
        {
            _orderCounter = new Counter();
            _orderCounter.initialize();
            _orderCounter.reset( Global.ORDER_TIME );
            _unitContainer = displayMgr.unitLevel;
            _mapContainer = displayMgr.mapLevel;
            _unitList = new Vector.<BaseObject>();
            _screenObj = new Vector.<BaseObject>();
            _qTree = new QTree(new Rectangle(0,0,Global.MAP_W,Global.MAP_H), 3 );
            
            //            _newMonsterCounter = new Counter();
            //            _newMonsterCounter.initialize();
            //            _newMonsterCounter.reset( 3 );
            _monsterObjList = new Vector.<IMonsterObject>();
            _towersList = new Vector.<ITowerObject>();
            _monsterList = new Vector.<MonsterViewGpu>(); 
            monsterController.monsterList = _monsterObjList; 
            
            towerController.towersList = _towersList;
            towerController.monsterList = _monsterObjList;
            
            var loader:URLLoader = new URLLoader();
            loader.addEventListener( flash.events.Event.COMPLETE , onMapLoadComplete );
            loader.load( new URLRequest( "map/map003.json" ));
            
            ( scene as Sprite ).addEventListener( SceneEvent.MAP_TOUCH, onTouch );
            
            //            var bmp:Bitmap = (assetMgr.getRes( "battle/light.png" ) as JpgLoader).displayObj as Bitmap;
            //            var texture:Texture = Texture.fromBitmap( bmp );
            //            var img:Image = new Image( texture );
            //            img.x = 400;
            //            img.y = 400;
            //            displayMgr.unitLevel.addChild( img );
        }
        
        private function onTouch( e:SceneEvent ):void
        {
            logger.debug( "TouchMap " + e.touchGrid );
            
            
            var towerObj:TowerObject = new TowerObject();
            towerObj.viewObject = scene.addBuilding( e.touchGrid.x , e.touchGrid.y , 10000 , "17" );
            var pt : Point = scene.GridToView( e.touchGrid.x , e.touchGrid.y ); 
            towerObj.posX = pt.x - Global.TILE_W / 2;
            towerObj.posY = pt.y - Global.TILE_H  * 7 / 2  ; 
            _towersList.push( towerObj );
            addObject( towerObj );
        }
        
        override protected function onMapLoadComplete( e:flash.events.Event):void
        {
            super.onMapLoadComplete( e );
            
            var pos:Point;
            pos = scene.GridToView( 19, 1 );
            createMonser( pos.x , pos.y  );
        }
        
        public function createMonser(posx:uint,posy:uint,camp:uint = 2):void
        {
            var monsterInfo:BattleCharacterInfo = new BattleCharacterInfo();
            monsterInfo.name = (randMonster==0)?"poring":(randMonster==1)?"porpring":"ghostpring";
            monsterInfo.hpMax = 100;
            monsterInfo.spMax = 50;
            monsterInfo.hpCurrent = monsterInfo.hpMax;
            monsterInfo.spCurrent = monsterInfo.spMax;
            monsterInfo.atk = 5;
            var randMonster:int =  int(Math.random() * 3);
            if( randMonster == 0 )
            {
                monsterInfo.init(  "" , "data/sprite/monsters/poring.tpc" , false );
            }
            else if( randMonster == 1 )
            {
                monsterInfo.init( "" , "data/sprite/monsters/poporing.tpc", false );
            }
            else 
            {
                monsterInfo.init( "" , "data/sprite/monsters/ghostring.tpc", false );
            }
            
            var monsterView:MonsterViewGpu = new MonsterViewGpu();
            monsterView.touchable = false;
            injector.injectInto(monsterView);
            monsterView.initInfo( monsterInfo );
            _monsterList[ _monsterList.length ] = monsterView
            
            var monster:MonsterObject = new MonsterObject();
            injector.injectInto(monster);
            _monsterObjList[ _monsterObjList.length ] = monster;
            
            monster.viewObject = monsterView;
            monster.posX = posx
            monster.posY = posy;
            monster.info = monsterInfo;
            monster.action = ConstsActions.Wait;
            
            this.addObject(monster);
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
            var len:int = _monsterList.length;
            
            if( monsterController )
            {
                monsterController.tick( delta );
            }
            
            for( var i:int = 0;i<len;i++)
            {
                _monsterObjList[i].tick( delta );
            }
            
            len = _towersList.length;
            
            if( towerController )
            {
                towerController.tick( delta );
            }
            for( i=0;i<len;i++)
            {
                _towersList[i].tick( delta );
            }
            
            //            _newMonsterCounter.tick( delta );
            //            if( _newMonsterCounter.expired )
            //            {
            //                if( _monsterObjList.length < 250 )
            //                {
            //                    createMonser( 1800 * Math.random() + 200, 1800 * Math.random() + 200 );
            //                    facade.sendNotification( GameCommands.RECV_CHAT, [ "<font color='#ffff00'>A monster appear!</font>"] );
            //                }
            //                _newMonsterCounter.reset( 3 );
            //            }
        }
    }
}