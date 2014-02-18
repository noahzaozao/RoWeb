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
    import inoah.game.ro.modules.map.view.BaseScene;
    import inoah.game.ro.modules.map.view.TileBuilding;
    import inoah.game.ro.modules.map.view.events.SceneEvent;
    import inoah.game.ro.modules.map.view.mediators.BaseSceneMediator;
    import inoah.game.ro.objects.MonsterObject;
    import inoah.game.td.objects.TowerObject;
    import inoah.interfaces.ICamera;
    import inoah.interfaces.character.IMonsterObject;
    import inoah.interfaces.controller.IMonsterController;
    import inoah.interfaces.managers.IAssetMgr;
    import inoah.interfaces.managers.ITextureMgr;
    import inoah.interfaces.map.ITDSceneMediator;
    import inoah.interfaces.tower.ITowerController;
    import inoah.interfaces.tower.ITowerObject;
    import inoah.utils.Counter;
    import inoah.utils.QTree;
    
    import robotlegs.bender.extensions.tdMapMgrExtension.MapEvent;
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.ILogger;
    
    import starling.display.Sprite;
    import starling.events.Event;
    
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
        
        protected var camera:ICamera;
        
        protected var _monsterObjList:Vector.<IMonsterObject>;
        protected var _monsterList:Vector.<MonsterViewGpu>;
        
        protected var _towerObjList:Vector.<ITowerObject>;
        protected var _towerList:Vector.<TileBuilding>;
        protected var _towerPosList:Vector.<String>;
        
        protected var _newMonsterCounter:Counter;
        protected var _towerSelectPanel:TowerSelecter;
        private var _pt:Point;
        
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
            
            _newMonsterCounter = new Counter();
            _newMonsterCounter.initialize();
            _newMonsterCounter.reset( 1 );
            
            _monsterObjList = new Vector.<IMonsterObject>();
            _monsterList = new Vector.<MonsterViewGpu>(); 
            _towerObjList = new Vector.<ITowerObject>();
            _towerList = new Vector.<TileBuilding>();
            _towerPosList = new Vector.<String>();
            
            monsterController.monsterList = _monsterObjList; 
            
            towerController.initialize();
            towerController.towersList = _towerObjList;
            towerController.monsterList = _monsterObjList;
            
            var loader:URLLoader = new URLLoader();
            loader.addEventListener( flash.events.Event.COMPLETE , onMapLoadComplete );
            loader.load( new URLRequest( "map/map004.json" ));
            
            ( scene as Sprite ).addEventListener( SceneEvent.MAP_TOUCH, onTouch );
            
            //            var bmp:Bitmap = (assetMgr.getRes( "battle/light.png" ) as JpgLoader).displayObj as Bitmap;
            //            var texture:Texture = Texture.fromBitmap( bmp );
            //            var img:Image = new Image( texture );
            //            img.x = 400;
            //            img.y = 400;
            //            displayMgr.unitLevel.addChild( img );
        }
        
        override public function reset():void
        {
            super.reset();
            monsterController.reset();
            _newMonsterCounter.reset( 1 );
        }
        
        override protected function cleanScene():void
        {
            super.cleanScene();

            for( var i:int = 0; i<_monsterObjList.length;i++)
            {
                _monsterObjList.splice( i , 1 );
                i--;
            }
            for( i = 0; i<_monsterList.length;i++)
            {
                _monsterList[i].dispose();
                _monsterList.splice( i , 1 );
                i--;
            }
            for( i = 0; i<_towerObjList.length;i++)
            {
                _towerObjList.splice( i , 1 );
                i--;
            }
            for( i = 0; i<_towerList.length;i++)
            {
                _towerList[i].dispose();
                _towerList.splice( i , 1 );
                _towerPosList.splice( i , 1 );
                i--;
            }
        }
        
        private function onTouch( e:SceneEvent ):void
        {
            testBuildTower( 1 , new Point( 960 , 480 ) );

            return;
            
            if( !camera )
            {
                camera = injector.getInstance( ICamera );
            }
            
            logger.debug( "TouchMap " + e.touchGrid );
            
            _pt = scene.GridToView( e.touchGrid.x , e.touchGrid.y ); 
            
            if( !_towerSelectPanel )
            {
                _towerSelectPanel = new TowerSelecter();
                injector.injectInto( _towerSelectPanel );
                _towerSelectPanel.initialize();
                _towerSelectPanel.addEventListener( MapEvent.BUILD_TOWER , onBuildTower );
            }
            if( _towerSelectPanel )
            {
                if( _towerSelectPanel.parent )
                {
                    displayMgr.joyStickLevel.removeChild( _towerSelectPanel );
                }
                else
                {
                    _towerSelectPanel.x = _pt.x - camera.zeroX;
                    _towerSelectPanel.y = _pt.y - camera.zeroY;
                    displayMgr.joyStickLevel.addChild( _towerSelectPanel );
                }
            }
        }
        
        private function onBuildTower( e:starling.events.Event ):void
        {
            displayMgr.joyStickLevel.removeChild( _towerSelectPanel );
            
            //非寻路层位置
            if( scene.checkPath( _pt ) )
            {
                //非建造过的位置
                if( _towerPosList.indexOf( _pt.x + "_" + _pt.y ) == -1 )
                {
                    //判断金钱，并扣钱
                    if( userModel.info.zeny > 100 )
                    {
                        userModel.info.zeny -= 100;
                        testBuildTower( uint( e.data ) , _pt );
                    }
                }
            }
        }
        
        public function testBuildTower( towerType:uint , pt:Point  ):void
        {
            var towerObj:TowerObject = new TowerObject();
            var towerView:TileBuilding = new TileBuilding( 10000 , scene.currentTextureAtlasList[1].getTexture( (17 + towerType).toString() ) );
            towerView.x = -128;
            towerView.y = -128;
            towerView.touchable = false;
            towerObj.viewObject = towerView;
            _towerList.push( towerView );
            towerObj.posX = pt.x - Global.TILE_W / 4;
            towerObj.posY = pt.y - Global.TILE_H  * 3 / 2 ; 
            _towerPosList.push( pt.x + "_" + pt.y );
            _towerObjList.push( towerObj );
            addObject( towerObj );
        }
        
        override protected function onMapLoadComplete( e:flash.events.Event):void
        {
            super.onMapLoadComplete( e );
            
            var pos:Point;
            pos = scene.GridToView(  ( scene as BaseScene).startPos.x ,  ( scene as BaseScene).startPos.y );
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
            //            var randMonster:int =  int(Math.random() * 3);
            var randMonster:int =  0;//int(Math.random() * 3);
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
            
            len = _towerObjList.length;
            
            if( towerController )
            {
                towerController.tick( delta );
            }
            for( i=0;i<len;i++)
            {
                _towerObjList[i].tick( delta );
            }
            
            _newMonsterCounter.tick( delta );
            if( _newMonsterCounter.expired )
            {
                if( _monsterObjList.length < 100 )
                {
                    var pos:Point;
                    pos = scene.GridToView(  ( scene as BaseScene).startPos.x ,  ( scene as BaseScene).startPos.y);
                    createMonser( pos.x , pos.y  );
                    
                    //                    facade.sendNotification( GameCommands.RECV_CHAT, [ "<font color='#ffff00'>A monster appear!</font>"] );
                }
                _newMonsterCounter.reset( 1 );
            }
        }
    }
}