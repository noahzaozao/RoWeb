package com.inoah.ro.maps
{
    import com.inoah.ro.characters.Actions;
    import com.inoah.ro.characters.MonsterView;
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.controllers.MonsterController;
    import com.inoah.ro.infos.BattleCharacterInfo;
    import com.inoah.ro.objects.MonsterObject;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.DisplayObjectContainer;
    
    import as3.patterns.facade.Facade;
    
    import starling.display.DisplayObjectContainer;
    
    public class BattleMap extends BaseMap
    {
        protected var _monsterController:MonsterController;
        protected var _monsterObjList:Vector.<MonsterObject>;
        protected var _monsterList:Vector.<MonsterView>;
        protected var _newMonsterCounter:Counter;
        
        public function BattleMap(unitContainer:flash.display.DisplayObjectContainer , mapContainer:starling.display.DisplayObjectContainer)
        {
            mediatorName = GameConsts.BATTLE_MAP;
            _newMonsterCounter = new Counter();
            _newMonsterCounter.initialize();
            _newMonsterCounter.reset( 3 );
            _monsterObjList = new Vector.<MonsterObject>();
            _monsterList = new Vector.<MonsterView>(); 
            _monsterController = new MonsterController( this );
            Facade.getInstance().registerMediator( _monsterController );
            _monsterController.monsterList = _monsterObjList; 
            super(unitContainer , mapContainer);
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
                monsterInfo.init(  "" , "data/sprite/阁胶磐/poring.act" , false );
            }
            else if( randMonster == 1 )
            {
                monsterInfo.init( "" , "data/sprite/阁胶磐/poporing.act", false );
            }
            else 
            {
                monsterInfo.init( "" , "data/sprite/阁胶磐/ghostring.act", false );
            }
            var monsterView:MonsterView = new MonsterView( monsterInfo );
            _monsterList[ _monsterList.length ] = monsterView
            
            var monster:MonsterObject = new MonsterObject();
            _monsterObjList[ _monsterObjList.length ] = monster;
            
            monster.viewObject = monsterView;
            monster.posX = posx
            monster.posY = posy;
            monster.info = monsterInfo;
            monster.action = Actions.Wait;
            
            this.addObject(monster);
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
            var len:int = _monsterList.length;
            
            if( _monsterController )
            {
                _monsterController.tick( delta );
            }
            for( var i:int = 0;i<len;i++)
            {
                _monsterObjList[i].tick( delta );
            }
            
            _newMonsterCounter.tick( delta );
            if( _newMonsterCounter.expired )
            {
                if( _monsterObjList.length < 50 )
                {
                    createMonser( 1200 * Math.random() + 100, 1200 * Math.random() + 100 );
                    facade.sendNotification( GameCommands.RECV_CHAT, [ "<font color='#ffff00'>A monster appear!</font>"] );
                }
                _newMonsterCounter.reset( 3 );
            }
        }
    }
}