package inoah.game.ro.modules.map.view.mediators
{
    import flash.events.Event;
    import flash.geom.Point;
    
    import inoah.core.characters.gpu.MonsterViewGpu;
    import inoah.core.consts.ConstsActions;
    import inoah.core.infos.BattleCharacterInfo;
    import inoah.game.ro.objects.MonsterObject;
    import inoah.interfaces.character.IMonsterObject;
    import inoah.interfaces.controller.IMonsterController;
    import inoah.interfaces.map.IBattleSceneMediator;
    import inoah.utils.Counter;
    
    import robotlegs.bender.framework.api.IInjector;
    
    public class BattleSceneMediator extends BaseSceneMediator implements IBattleSceneMediator
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var monsterController:IMonsterController;
        
        protected var _monsterObjList:Vector.<IMonsterObject>;
        protected var _monsterList:Vector.<MonsterViewGpu>;
        protected var _newMonsterCounter:Counter;
        
        public function BattleSceneMediator()
        {
            super();
        }
        
        override public function initialize():void
        {
            _newMonsterCounter = new Counter();
            _newMonsterCounter.initialize();
            _newMonsterCounter.reset( 3 );
            _monsterObjList = new Vector.<IMonsterObject>();
            _monsterList = new Vector.<MonsterViewGpu>(); 
            monsterController.monsterList = _monsterObjList; 
            super.initialize();
        }
        
        override protected function onMapLoadComplete( e:flash.events.Event):void
        {
            super.onMapLoadComplete( e );
            
            var pos:Point;
            for( var i:int = 0;i<10;i++)
            {
                for( var j:int = 0;j<10;j++)
                {
                    pos = scene.GridToView( j + 20 , i );
                    createMonser( pos.x , pos.y  );
                }
            }
            pos = scene.GridToView( 25, 2 );
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
            injector.injectInto(monsterView);
            monsterView.initInfo( monsterInfo );
            _monsterList[ _monsterList.length ] = monsterView
            
            var monster:MonsterObject = new MonsterObject();
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