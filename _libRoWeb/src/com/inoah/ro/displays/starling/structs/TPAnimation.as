package com.inoah.ro.displays.starling.structs
{
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.displays.actspr.structs.CACT;
    import com.inoah.ro.displays.actspr.structs.acth.AnyActAnyPat;
    import com.inoah.ro.events.TPAnimationEvent;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.managers.TextureMgr;
    
    import flash.display.BitmapData;
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import flash.system.System;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    public class TPAnimation extends EventDispatcher
    {
        protected var _cact:CACT;
        
        protected var _actionIndex:uint;
        /**
         * 待解析的配置序列 
         */        
        private var _remainTextureSettingAnimation:Vector.<String>;
        
        /**
         * ATF数据列表
         */        
        private var _atfDatasList:Vector.<ByteArray>;
        
        /**
         * texture atlas的透明度列表
         */        
        private var _textureCollideList:Vector.<BitmapData>;
        
        /**
         * texture atlas的贴图列表
         */        
        private var _textureList:Vector.<Texture>;
        
        /**
         * textureAtlas的列表
         */        
        private var _textureAtlasList:Vector.<TextureAtlas>;
        /**
         *  贴图索引
         */        
        private var _textureNameSet:Vector.<Vector.<String>>;
        
        /**
         * textureAtlas的配置
         */        
        private var _textureAtlasSettingList:Vector.<XML>;
        
        /**
         * 动作序列数据列表 
         */        
        
        /**
         * 帧序列何位置偏移列表
         */        
        private var _textureOffsetList:Vector.<Point>;
        
        /**
         * 帧序列何位置偏移索引
         */        
        private var _textureOffsetIndex:Vector.<String>;
        
        /**
         * 是否已经释放
         */        
        private var _isDisposed:Boolean;
        
        private var _tpaId:String;
        private var _currentAaapList:Vector.<AnyActAnyPat>;
        
        /**
         * 构造
         * @param threshold        (默认值255)判断可点区域的透明度, 范围是0~255
         */        
        public function TPAnimation( id:String = "" )
        {
            
        }
        
        public function get currentAction():uint
        {
            return _actionIndex;
        }
        
        /**
         * 解析tpa文件 
         * @param data      tpa文件字节流
         */        
        public function decode(data:ByteArray):void
        {
            data.inflate();
            
            var cactData:ByteArray = new ByteArray();
            cactData.endian = Endian.BIG_ENDIAN;
            data.readBytes( cactData , 0 , data.readInt() );
            _cact = new CACT( cactData );
            
            var compressData:ByteArray = new ByteArray();
            data.readBytes(compressData, 0, data.readInt());
            
            compressData.inflate();
            
            var len:int = compressData.readByte();
            
            _textureNameSet = new Vector.<Vector.<String>>();
            _textureCollideList = new Vector.<BitmapData>();
            
            _atfDatasList = new Vector.<ByteArray>(len);
            _textureList = new Vector.<Texture>(len);
            _textureAtlasList = new Vector.<TextureAtlas>(len);
            _remainTextureSettingAnimation = new Vector.<String>(len);
            
            var nodeData:ByteArray;
            for(var i:int = 0; i<len; i++)
            {
                nodeData = new ByteArray()//atf data (bytearray)
                compressData.readBytes(nodeData, 0, compressData.readInt()); 
                _atfDatasList[i] = nodeData;
                _remainTextureSettingAnimation[i] = decodeURI(compressData.readUTFBytes(compressData.readInt()));
            }
            ///start init animation sequences//////////////////////////////////////////
            var sequenceList:XMLList;
            var action:XML;
            var sequenceCollection:Vector.<SequenceData>;
            var sequence:XML;
            var j:int;
            var k:int
            
            ///end init animation sequences//////////////////////////////////////////
            _textureOffsetIndex = new Vector.<String>();
            _textureOffsetList = new Vector.<Point>();
            _textureAtlasSettingList = new Vector.<XML>();
            
            prepareTextureData();
        }
        
        /**
         * 按帧数字顺排序帧序列
         * @param sequenceA     序列帧A
         * @param sequenceB     序列帧B
         * @return 
         */        
        protected function sortSequence(sequenceA:SequenceData, sequenceB:SequenceData):Number
        {
            return sequenceA.frame - sequenceB.frame;
        }
        
        protected function prepareTextureData():void
        {
            if( _remainTextureSettingAnimation.length == 0 )
            {
                dispatchEvent(new TPAnimationEvent(TPAnimationEvent.INITIALIZED));
                return;
            }
            //parse subtexture setting;
            var sourceSetting:XML = XML(_remainTextureSettingAnimation[0]);
            var sourceAssetWidth:int = int(sourceSetting.@width)*.5;
            var sourceAssetHeight:int = int(sourceSetting.@height)*.5;
            var sourceList:XMLList = sourceSetting.sequence;
            
            var atlasSetting:XML = XML(<altasSetting></altasSetting>);
            var sequenceSetting:XML;
            var subTexture:XML;
            var len:int = sourceList.length();
            
            var textureOffsetList:Vector.<Point> = new Vector.<Point>(len);
            var textureOffsetIndex:Vector.<String> = new Vector.<String>(len);
            var subTextureName:String;
            var textureOffsetPoint:Point;
            var textureNameList:Vector.<String> = new Vector.<String>(len);
            
            for(var i:int = 0; i<len; i++)
            {
                sequenceSetting = sourceList[i];
                subTexture = XML(<SubTexture />);
                
                subTextureName = sequenceSetting.@name;
                subTexture.@name = subTextureName
                subTexture.@width = sequenceSetting.@width;
                subTexture.@height = sequenceSetting.@height;
                subTexture.@x = sequenceSetting.@x;
                subTexture.@y = sequenceSetting.@y;
                textureOffsetPoint = new Point( 0 , 0 );
//                textureOffsetPoint = new Point(sourceAssetWidth-int(sequenceSetting.@xOffset),sourceAssetHeight-int(sequenceSetting.@yOffset));
                
                subTexture.@frameX = 0;
                subTexture.@frameY = 0;
                subTexture.@frameWidth = sequenceSetting.@width;
                subTexture.@frameHeight = sequenceSetting.@height;
                
                textureNameList[i] = subTextureName;
                textureOffsetList[i] = textureOffsetPoint;
                textureOffsetIndex[i] = subTextureName;
                atlasSetting.appendChild(subTexture);
            }
            
            //保存贴图配置数据
            _textureOffsetIndex = _textureOffsetIndex.concat(textureOffsetIndex);
            _textureOffsetList = _textureOffsetList.concat(textureOffsetList);
            _textureAtlasSettingList.push(atlasSetting);
            _textureNameSet.push(textureNameList);
            
            System.disposeXML(subTexture);
            System.disposeXML(sourceSetting);
            
            _remainTextureSettingAnimation.splice(0,1);
            
            prepareTextureData();
        }
        
        /**
         * 根据序列帧名取贴图 
         * @param name      序列帧名
         * @return          目标贴图,如果找不到则返回空
         */        
        protected function getTextureByName(name:String):Texture
        {
            if(name == "")
            {
                return null;
            }
            var findTexture:Boolean;
            var len:int = _textureNameSet.length;
            for(var i:int = 0; i<len;i++)
            {
                if(_textureNameSet[i].indexOf(name)<0)
                {
                    continue;   
                }
                findTexture = true;
                break
            }
            
            if(findTexture == false)
            {
                return null;
            }
            
            var texture:Texture;
            var textureAtlas:TextureAtlas;
            var textureMgr:TextureMgr = MainMgr.instance.getMgr( MgrTypeConsts.TEXTURE_MGR ) as TextureMgr;
            textureAtlas = _textureAtlasList[i];
            if(textureAtlas == null)
            {
                texture = textureMgr.getTexture(_tpaId+"_"+i+"",  _atfDatasList[i], onTextureUploaded );
                textureAtlas = new TextureAtlas(texture, _textureAtlasSettingList[i]);
                _textureAtlasList[i] = textureAtlas;
                _textureList[i] = texture;
            }
            
            texture = textureAtlas.getTexture(name);
            
            return texture;
        }
        
        protected function onTextureUploaded(texture:Texture):void
        {
            
        }
        
        /**
         * 释放 
         */        
        public function dispose():void
        {
            if(_isDisposed == false)
            {
                _isDisposed = true;
                distruct();
            }
        }
        /**
         * 释放显存中的贴图
         */		
        public function disposeTexture():void
        {
//            var textureServ:TextureManagerService = Service.instance.getService( ServiceGuids.TEXTURE_MANAGER_SERVICE ) as TextureManagerService;
//            
//            var len:int = _textureList.length;  
//            for(var i:int =0; i<len; i++)
//            {
//                if(_textureAtlasList[i] != null)
//                {
//                    //					_textureAtlasList[i].dispose();
//                    _textureAtlasList[i] = null;
//                }
//                
//                if(_textureList[i] != null)
//                {
//                    textureServ.disposeTexture( _textureList[i] ); 
//                    _textureList[i] = null;
//                }
//            }
        }
        
        protected function distruct():void
        {
            disposeTexture();
            
            var len:int = _textureCollideList.length;  
            for(var i:int =0; i<len; i++)
            {
                _textureCollideList[i].dispose();
                
                if(_atfDatasList[i] != null)
                {
                    _atfDatasList[i].clear();
                }
            }
            
            _atfDatasList = null;
            _textureCollideList = null;
        }
        
        public function get tpaId():String
        {
            return _tpaId;
        }
        
        public function get act():CACT
        {
            return _cact;
        }
        
        public function getTexture(sprNo:uint):Texture
        {
            return getTextureByName( sprNo.toString() );
        }
    }
}


class SequenceData
{
    private var _action:String;
    private var _source:String;
    private var _frame:int;
    public function SequenceData(source:String, frame:int):void
    {
        //        _action = action;
        _source = source;
        _frame = frame;
    }
    //    public function get action():String { return _action; }
    public function get source():String { return _source; }
    public function get frame():int { return _frame; }
}