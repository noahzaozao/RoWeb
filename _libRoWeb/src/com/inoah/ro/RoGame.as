package com.inoah.ro 
{
    //    import com.D5Power.D5Game;
    //    import com.D5Power.Controler.Actions;
    //    import com.D5Power.Controler.CharacterControler;
    //    import com.D5Power.Objects.CharacterObject;
    //    import com.D5Power.Objects.NCharacterObject;
    //    import com.D5Power.mission.EventData;
    //    import com.inoah.ro.characters.PlayerView;
    //    import com.inoah.ro.consts.MgrTypeConsts;
    //    import com.inoah.ro.controllers.PlayerController;
    //    import com.inoah.ro.infos.UserInfo;
    //    import com.inoah.ro.managers.BattleMgr;
    //    import com.inoah.ro.managers.DisplayMgr;
    //    import com.inoah.ro.managers.MainMgr;
    //    import com.inoah.ro.objects.PlayerObject;
    //    import com.inoah.ro.scenes.MainScene;
    //    import com.inoah.ro.ui.NPCDialog;
    //    import com.inoah.ro.utils.UserData;
    //    
    //    import flash.display.Stage;
    //    import flash.events.Event;
    //    
    public class RoGame //extends D5Game
    {
        //        public static var inited:Boolean
        //        private var _playerView:PlayerView;
        //        private var _player:CharacterObject;
        //        
        //        private var _npcDialogBox:NPCDialog;
        //        
        public function RoGame()//config:String, stg:Stage, openGPU:uint=0)
        {
            //            super(config, stg, openGPU);
        }
        
        //        override protected function buildScene():void
        //        {
        //            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
        //            _scene = new MainScene(_stg , displayMgr.mapLevel);
        //        }
        //        
        //        override protected function init(e:Event=null):void
        //        {
        //            super.init();
        //            
        //            
        //            
        ////            var nObj:NCharacterObject =  new NCharacterObject( new NCharacterControler( scene.perc ));
        ////            nObj.uid = 1;
        ////            npcWindow( "hey, guys, welcome to my village!" , new EventData(), nObj, 0 );
        //            
        //            var userInfo:UserInfo = (Global.userdata as UserData).userInfo;
        //            _playerView = new PlayerView( userInfo );
        //            _playerView.x = 400;
        //            _playerView.y = 400;
        //            
        //            _player = new PlayerObject(null);
        //            _player.changeController( new PlayerController( _scene.perc , CharacterControler.MOUSE ));
        //            _player.ID=1;
        //            _player.displayer = _playerView;
        //            _player.setPos(500,500);
        //            _player.speed = 4.5;
        //            _player.action = Actions.Wait;
        //            
        //            (_player as PlayerObject).info = userInfo;
        //            
        //            _scene.createPlayer(_player);
        //            _camera.focus(_player);
        //            
        //            for( var i:int = 0;i< 50; i++ )
        //            {
        //                (_scene as MainScene).createMonser( 800 * Math.random() + 100, 800 * Math.random() + 100 );
        //            }
        //        }
        //        
        //        public function tick( delta:Number ):void
        //        {
        //            if( _playerView )
        //            {
        //                _playerView.x = _player.x;
        //                _playerView.y = _player.y;
        //                _playerView.tick( delta );
        //                (_player.controler as PlayerController).tick( delta );
        //            }
        //            if( _scene )
        //            {
        //                (_scene as MainScene).tick( delta );
        //            }
        //            var battleMgr:BattleMgr = MainMgr.instance.getMgr( MgrTypeConsts.BATTLE_MGR ) as BattleMgr;
        //            if( battleMgr )
        //            {
        //                battleMgr.tick( delta );
        //            }
        //        }
        //        
        //        public function npcWindow(say:String,event:EventData,npc:NCharacterObject,misid:uint,type:uint=0,complate:Boolean=false):void
        //        {
        //            if(_npcDialogBox==null)
        //            {
        //                _npcDialogBox = new NPCDialog();
        //            }
        //            
        //            _npcDialogBox.config(say,npc,misid,type,complate);
        //            if(!contains(_npcDialogBox))
        //            {
        //                _stg.addChild(_npcDialogBox);
        //            }
        //        }
    }
}