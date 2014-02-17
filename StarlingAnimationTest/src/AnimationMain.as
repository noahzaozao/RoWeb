package
{
    import flash.display.BitmapData;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.utils.setTimeout;
    
    import inoah.core.starlingMain;
    
    import starling.core.Starling;
    import starling.display.QuadBatch;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;
    
    public class AnimationMain extends starlingMain
    {
        public function AnimationMain()
        {
            super();
            TextureClip.NULL_TEXTURE = Texture.fromBitmapData(new BitmapData(1,1,true,0));
        }
        
        override protected function addedToStageHandler( e:Event ):void
        {
            super.addedToStageHandler( e );
        }
        
        protected var _tcCount:int;
        protected var _quadBatch:QuadBatch;
        protected var _moveX:int;
        protected var _moveY:int;
        protected var _container:Sprite;
        protected var _unitContainer:Sprite;
        
        [Embed(source="circle.png")]
        private var circle:Class;
        
        private var mParticleSystem:PDParticleSystem;
        
        public function init():void
        {
            var psConfig:XML = xml;
            var psTexture:Texture = Texture.fromBitmap(new circle());
            
            //创建粒子系统
            mParticleSystem = new PDParticleSystem(psConfig, psTexture);
            mParticleSystem.emitterX = 32;
            mParticleSystem.emitterY = 24;
            
            //添加粒子系统到舞台和juggler
            addChild(mParticleSystem);
            Starling.juggler.add(mParticleSystem);
            
            //开始发射粒子
            mParticleSystem.start();
            
            //停止发射粒子
//            mParticleSystem.stop();
            
            //            _container = new Sprite();
            //            addChild( _container );
            //            _unitContainer = new Sprite();
            //            addChild( _unitContainer );
            //            //            var image:Image;
            //            //            _quadBatch = new QuadBatch();
            //            //            _container.addChild( _quadBatch );
            //            
            //            //            for( var j:int = 0;j< 90;j++ )
            //            //            {
            //            //                for( var i:int = 0;i< 90;i++)
            //            //                {
            //            //                    image = new Image( StarlingAnimationTest._textureAtlas.getTexture( "0" ) );
            //            //                    image.x =  i * 30;
            //            //                    image.y = j * 75;
            //            //                    _quadBatch.addImage( image );
            //            //                }
            //            //            }
            //            //            
            //            //            _container.touchable = false;
            //            //            _container.flatten();
            
            //            _unitContainer.touchable = false;
            
            //            createTextureClip();
            
            //            Starling.current.nativeStage.addEventListener( KeyboardEvent.KEY_DOWN , onKeyUpDown );
            //            Starling.current.nativeStage.addEventListener( KeyboardEvent.KEY_UP , onKeyUpDown );
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
            if( _container )
            {
                _container.x += _moveX;
                _container.y += _moveY;
            }
            if( _unitContainer )
            {
                _unitContainer.x += _moveX;
                _unitContainer.y += _moveY;
            }
        }
        
        private function onKeyUpDown( e:KeyboardEvent ):void
        {
            var spd:int = 15;
            if( e.type == KeyboardEvent.KEY_DOWN )
            {
                switch( e.keyCode )
                {
                    case Keyboard.W:
                    {
                        _moveY = spd;
                        break;
                    }
                    case Keyboard.S:
                    {
                        _moveY = -spd;
                        break;
                    }
                    case Keyboard.A:
                    {
                        _moveX = spd;
                        break;
                    }
                    case Keyboard.D:
                    {
                        _moveX = -spd;
                        break;
                    }
                }
            }
            else 
            {
                _moveX = 0;
                _moveY = 0;
            }
        }
        
        private function createTextureClip():void
        {
            var textureClip:TextureClip;
            textureClip = new TextureClip();
            
            var num:int = Math.random()*3;
            textureClip.initAct( StarlingAnimationTest._tpcLoaderList[num].cact );
            textureClip.initTpc( "1001" , StarlingAnimationTest._tpcLoaderList[num].textureAtlas );
            
            _unitContainer.addChild( textureClip );
            
            textureClip.play();
            
            Starling.juggler.add( textureClip );
            textureClip.x = ( _tcCount % 30 ) * 30; 
            textureClip.y = int( _tcCount / 30 ) * 75 
            _tcCount++;
            
            if( _tcCount < 500 )
            {
                setTimeout( function():void
                {
                    createTextureClip();
                } , 1 );
            }
        }
        
        private var xml:XML = XML(
<particleEmitterConfig>
  <maxParticles value="100"/>
  <particleLifeSpan value="1"/>
  <particleLifespanVariance value="1"/>
  <startParticleSize value="10"/>
  <startParticleSizeVariance value="1"/>
  <finishParticleSize value="10"/>
  <FinishParticleSizeVariance value="1"/>
  <angle value="270"/>
  <angleVariance value="2"/>
  <rotationStart value="0"/>
  <rotationStartVariance value="0"/>
  <rotationEnd value="0"/>
  <rotationEndVariance value="0"/>
  <startColor alpha="0.6" red="1" green="0.27" blue="0"/>
  <startColorVariance alpha="0" red="0" green="0" blue="0"/>
  <finishColor alpha="0" red="1" green="0.27" blue="0"/>
  <finishColorVariance alpha="0" red="0" green="0" blue="0"/>
  <blendFuncSource value="770"/>
  <blendFuncDestination value="1"/>
  <emitterType value="1"/>
  <sourcePositionVariance x="0" y="0"/>
  <speed value="100"/>
  <speedVariance value="30"/>
  <gravity x="0" y="0"/>
  <radialAcceleration value="0"/>
  <radialAccelVariance value="0"/>
  <tangentialAcceleration value="0"/>
  <tangentialAccelVariance value="0"/>
  <maxRadius value="20"/>
  <maxRadiusVariance value="0"/>
  <minRadius value="0"/>
  <rotatePerSecond value="0"/>
  <rotatePerSecondVariance value="0"/>
</particleEmitterConfig>
        );
    }
}