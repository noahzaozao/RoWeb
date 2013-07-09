package com.D5Power.Stuff
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
    
    /**
     * 背景音乐播放器
     */ 
    public class BackgroundMusicPlayer
    {
        public var path:String = '';
        
        protected static var soundChannle:SoundChannel;
        protected static var sound:Sound;
        protected var _soundPlayStatus:Boolean=false;
        
        public function BackgroundMusicPlayer()
        {
        }
        
        /**
         * 播放某背景音乐
         * @param	p	音乐路径
         */ 
        public function play(p:String):void
        {
            // 不播放一样的音乐
            if(p=='' || p==null || p==path) return;
            
            path = p;
            if(sound!=null)
            {
                stop();
            }
            
            sound = new Sound(new URLRequest(p));
            sound.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
            
            restarSound();
        }
        
        /**
         * 停止音乐的播放
         */ 
        public function stop():void
        {
            try{
                sound.close();
            }catch(e:Error){}
            
            soundChannle.stop();
        }
        
        /**
         * 设置音量
         * @param		v	 0（静音）-1（最大音量）
         */ 
        public function setVolume(v:Number):void
        {
            soundChannle.soundTransform.volume = v;
        }
        
        /**
         * 循环播放
         */ 
        private function restarSound(e:Event=null):void
        {
            if(soundChannle!=null && soundChannle.hasEventListener(Event.SOUND_COMPLETE)) soundChannle.removeEventListener(Event.SOUND_COMPLETE,restarSound);
            
            soundChannle = sound.play(0);
            try
            {
                soundChannle.addEventListener(Event.SOUND_COMPLETE,restarSound);
                _soundPlayStatus=true;
            }catch(e:Error){}
        }
        
        private function onIoError(e:IOErrorEvent):void
        {
            trace("[未找到音乐文件"+path+"]");
        }
    }
}