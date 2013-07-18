package com.inoah.ro.scenes 
{
    import com.D5Power.Controler.Actions;
    import com.D5Power.scene.BaseScene;
    import com.inoah.ro.characters.MonsterView;
    import com.inoah.ro.controllers.MonsterController;
    import com.inoah.ro.infos.BattleCharacterInfo;
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.objects.MonsterObject;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    
    public class MainScene extends BaseScene
    {
        private var _monsterObjList:Vector.<MonsterObject>;
        private var _monsterList:Vector.<MonsterView>;
        private var _newMonsterCounter:Counter;
        
        public function MainScene(stg:Stage, container:DisplayObjectContainer)
        {
            _newMonsterCounter = new Counter();
            _newMonsterCounter.initialize();
            _newMonsterCounter.reset( 3 );
            _monsterObjList = new Vector.<MonsterObject>();
            _monsterList = new Vector.<MonsterView>(); 
            super(stg, container);
        }
        
        public function createMonser(posx:uint,posy:uint,camp:uint = 2):void
        {
            var monsterInfo:CharacterInfo = new CharacterInfo();
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
            //            charInfo.init( "可爱的早早", "data/sprite/牢埃练/赣府烹/咯/2_咯.act", "data/sprite/牢埃练/个烹/巢/檬焊磊_咯.act" );
            var monsterView:MonsterView = new MonsterView( monsterInfo );
            monsterView.x = 400;
            monsterView.y = 400;
            _monsterList[ _monsterList.length ] = monsterView
            
            var ctrl:com.inoah.ro.controllers.MonsterController = new MonsterController(perc);
            var monster:MonsterObject = new MonsterObject(ctrl);
            _monsterObjList[ _monsterObjList.length ] = monster;
            
            monster.displayer = monsterView;
            monster.setPos(posx,posy);
            monster.speed = 2.5;
            monster.camp = camp;// 阵营
            monster.action = Actions.Wait;
            var info:BattleCharacterInfo = new BattleCharacterInfo();
            info.name = (randMonster==0)?"poring":(randMonster==1)?"porpring":"ghostpring";
            info.hpMax = 50;
            info.spMax = 50;
            info.hpCurrent = info.hpMax;
            info.spCurrent = info.spMax;
            info.atk = 1;
            monster.info = info;
            
            addObject(monster);
        }
        
        public function tick( delta:Number ):void
        {
            var len:int = _monsterList.length;
            for( var i:int = 0;i<len;i++)
            {
                _monsterList[i].x = _monsterObjList[i].x;
                _monsterList[i].y = _monsterObjList[i].y;
                _monsterList[i].tick( delta );
                (_monsterObjList[i].controler as MonsterController).tick( delta );
            }
            
            _newMonsterCounter.tick( delta );
            if( _newMonsterCounter.expired )
            {
                if( _monsterObjList.length < 10 )
                {
                    createMonser( 800 * Math.random() + 100, 800 * Math.random() + 100 );
                    trace( "a monster appear!" );
                }
                _newMonsterCounter.reset( 3 );
            }
        }
    }
}