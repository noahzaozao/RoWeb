package com.inoah.ro 
{
    import com.D5Power.D5Game;
    import com.D5Power.Controler.Actions;
    import com.D5Power.Controler.CharacterControler;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Stuff.HSpbar;
    import com.inoah.ro.characters.PlayerView;
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.scenes.MainScene;
    
    import flash.display.Stage;
    import flash.events.Event;
    
    import com.inoah.ro.objects.PlayerObject;
    
    import com.inoah.ro.controllers.PlayerController;
    
    public class RoGame extends D5Game
    {
        private var _playerView:PlayerView;
        private var _player:CharacterObject;
        
        public function RoGame(config:String, stg:Stage, openGPU:uint=0)
        {
            super(config, stg, openGPU);
        }
        
        override protected function buildScene():void
        {
            _scene = new MainScene(_stg,this);
        }
        
        override protected function init(e:Event=null):void
        {
            super.init();
            
            var charInfo:CharacterInfo = new CharacterInfo();
            charInfo.init( "", "data/sprite/牢埃练/赣府烹/巢/2_巢.act", "data/sprite/牢埃练/个烹/巢/檬焊磊_巢.act", "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_1207.act" );
            //            charInfo.init( "可爱的早早", "data/sprite/牢埃练/赣府烹/咯/2_咯.act", "data/sprite/牢埃练/个烹/巢/檬焊磊_咯.act" );
            _playerView = new PlayerView( charInfo );
            _playerView.x = 400;
            _playerView.y = 400;
            
            _player = new PlayerObject(null);
            _player.changeController( new PlayerController( _scene.perc , CharacterControler.MOUSE ));
            _player.ID=1;
            _player.displayer = _playerView;
            _player.setPos(500,500);
            _player.speed = 4.5;
            _player.setName("可爱的早早",-1,0,-130);
            _player.action = Actions.Wait;
            
//            _player.hp = 150;
//            _player.hpMax = 150;
//            _player.hpBar = new HSpbar( _player,'hp','hpMax',10 , 0x009900 );
            
            _scene.createPlayer(_player);
            _camera.focus(_player);
            
            for( var i:int = 0;i< 10; i++ )
            {
                (_scene as MainScene).createMonser( 1200 * Math.random() + 100, 1200 * Math.random() + 100 );
            }
        }
        
        public function tick( delta:Number ):void
        {
            if( _playerView )
            {
                _playerView.x = _player.x;
                _playerView.y = _player.y;
                _playerView.tick( delta );
            }
            if( _scene )
            {
                (_scene as MainScene).tick( delta );
            }
        }
    }
}