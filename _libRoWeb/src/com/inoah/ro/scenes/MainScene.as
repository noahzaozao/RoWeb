package com.inoah.ro.scenes 
{
    import com.D5Power.Controler.Actions;
    import com.D5Power.Stuff.HSpbar;
    import com.D5Power.scene.BaseScene;
    import com.inoah.ro.characters.MonsterView;
    import com.inoah.ro.controllers.MonsterController;
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.objects.PlayerObject;
    import com.inoah.ro.uis.TopText;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    
    public class MainScene extends BaseScene
    {
        private var _monsterObjList:Vector.<PlayerObject>;
        private var _monsterList:Vector.<MonsterView>;
        private var _newMonsterCounter:Counter;
        
        public function MainScene(stg:Stage, container:DisplayObjectContainer)
        {
            _newMonsterCounter = new Counter();
            _newMonsterCounter.initialize();
            _newMonsterCounter.reset( 3 );
            _monsterObjList = new Vector.<PlayerObject>();
            _monsterList = new Vector.<MonsterView>(); 
            super(stg, container);
        }
        
        public function createMonser(posx:uint,posy:uint,camp:uint = 2):void
        {
            var monsterInfo:CharacterInfo = new CharacterInfo();
            if( int(Math.random() * 2) > 0 )
            {
                monsterInfo.init( "" , "" , "data/sprite/阁胶磐/poring.act" , "" ,100 );
            }
            else
            {
                monsterInfo.init( "" , "" , "data/sprite/阁胶磐/poporing.act", "" , 200 );
            }
            //            charInfo.init( "可爱的早早", "data/sprite/牢埃练/赣府烹/咯/2_咯.act", "data/sprite/牢埃练/个烹/巢/檬焊磊_咯.act" );
            var monsterView:MonsterView = new MonsterView( monsterInfo );
            monsterView.x = 400;
            monsterView.y = 400;
            _monsterList[ _monsterList.length ] = monsterView
            
            var ctrl:com.inoah.ro.controllers.MonsterController = new MonsterController(perc);
            var player:PlayerObject = new PlayerObject(ctrl);
            _monsterObjList[ _monsterObjList.length ] = player;
            
            player.displayer = monsterView;
            player.setPos(posx,posy);
            player.speed = 2.5;
            player.camp = camp;// 阵营
            player.setName(
                (camp==2 ? "波利" : "D5机器人-"+int(Math.random()*100)),
                (camp==2 ? 0xff0000 : 0xffff00),
                0,
                -130
            );
            player.action = Actions.Wait;
            if(camp==2)
            {
                player.hp = 50;
                player.hpMax = 50;
                player.hpBar = new HSpbar(player,'hp','hpMax',10 , 0x33ff33);
                player.sp = 50;
                player.spMax = 50;
                player.spBar = new HSpbar(player,'sp','spMax',14 , 0x2868FF);
            }
            
//            container.addChild( monsterView );
            
            addObject(player);
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
                if( _monsterObjList.length < 20 )
                {
                    createMonser( 1200 * Math.random() + 100, 1200 * Math.random() + 100 );
                    TopText.show( "出现一个怪物！" );
                }
                _newMonsterCounter.reset( 3 );
            }
        }
    }
}