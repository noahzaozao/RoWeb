package com.D5Power.graphicsManager
{
    import com.D5Power.loader.MutiLoader;
    import com.D5Power.ns.NSGraphics;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.IBitmapDrawable;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Timer;
    
    use namespace NSGraphics;
    
    internal class GraphicsBasic
    {
        internal static const RENDER_RES_NAME:String = 'RenderVector:';
        
        internal static const MIRROR:String = '_mirror';
        
        internal static var _DEFAULT_BD:BitmapData;
        
        [Embed(source="../../../images/default.png" , mimeType="image/png")]
        private static var defaultBD:Class;
        
        /**
         * 位图
         */ 
        protected var _bitmap:BitmapData;
        
        protected var bitmap_data:Vector.<Vector.<BitmapData>>;
        
        
        /**
         * 镜像位图
         */
        protected var _mirrorBitmapData:BitmapData;
        
        protected var mirror_data:Vector.<Vector.<BitmapData>>;
        
        protected var _resourceList:Vector.<GraphicsData>;
        
        /**
         * 当前的动作
         */ 
        protected var _nowAction:uint=0;
        /**
         * 是否主资源
         */ 
        protected var _isMaster:Boolean=false;
        
        /**
         * 帧 数 动画的宽
         */ 
        public var framesTotal:int = 1;
        
        /**
         * 动画的层(高)数，对于角色就是方向
         */ 
        public var framesLayer:int=1;
        
        /**
         * 速度
         */ 
        protected var _fps:Number = 0;
        
        /**
         * 距形
         */ 
        private var drawRect2:Rectangle;
        
        /**
         * 实际现实的单元宽度
         */ 
        private var _frameWidth:uint=0;
        
        /**
         * 实际现实的单元高度
         */ 
        private var _frameHeight:uint=0;
        
        /**
         * 
         */ 
        private var _lineFrame:Array;
        
        
        /**
         * 是否需要镜像
         */ 
        private var _needMirror:Boolean;
        
        /**
         * 当前动作的资源是否准备完成
         */ 
        private var _nowActionRes:Boolean = false;
        
        public static function get DEFAULT_BD():BitmapData
        {
            if(_DEFAULT_BD==null)
            {
                _DEFAULT_BD = (new defaultBD() as Bitmap).bitmapData;
            }
            return _DEFAULT_BD;
        }
        
        /**
         * 创建图形资源
         * @param	mirror	是否需要镜像
         */ 
        public function GraphicsBasic(mirror:Boolean=false)
        {
            _needMirror = mirror;
        }
        
        public function get RenderResName():String
        {
            return RENDER_RES_NAME;
        }
        
        public function get bitmap():Vector.<Vector.<BitmapData>>
        {
            return bitmap_data;
        }
        
        public function get mirrorBitmapData():Vector.<Vector.<BitmapData>>
        {
            return mirror_data;
        }
        
        public function get frameWidth():uint
        {
            return _frameWidth;
        }
        
        public function get frameHeight():uint
        {
            return _frameHeight;
        }
        
        /**
         * 通过数据数组来增加图形资源
         */ 
        public function addResource(data:BitmapData,frame:uint=1,line:uint=1,fps:uint=1):void
        {
            framesLayer = line;
            framesTotal = frame;
            _frameWidth = int(data.width/frame);
            _frameHeight = int(data.height/line);
            _fps = fps;
            
            bitmap_data = makeVector(data);
            _nowActionRes = true;
        }
        
        /**
         * 通过现有二进制资源转换图形资源
         */ 
        public function addByteArrayResource(list:Array,resname:String,action:uint=0,frame:uint=1,line:uint=1,fps:uint=1):void
        {
            if(_resourceList==null)_resourceList = new Vector.<GraphicsData>;
            
            var reslist:Vector.<String> = new Vector.<String>;
            reslist.push(resname);
            
            var renderResname:String = resname+',';		
            
            var loadResource:Array = new Array();
            
            var gd:GraphicsData = new GraphicsData();
            gd.action = action;
            gd.resNameList = reslist;
            gd.frame = frame;
            gd.line = line;
            gd.fps = fps;
            _resourceList.push(gd);
            
            
            // 当前动作所需要的渲染资源在资源池中已经存在，则直接进行获取
            if(_nowAction==action && Global.resPool.getResource(renderResname)!=null)
            {
                bitmap_data = Global.resPool.getResource(renderResname);
                mirror_data = Global.resPool.getResource(renderResname+MIRROR);
                _frameWidth = bitmap_data[0][0].width;
                _frameHeight = bitmap_data[0][0].height;
                framesLayer = gd.line;
                framesTotal = gd.frame;
                _fps = gd.fps;
                _nowActionRes=true;
                return;
            }
            
            var mloader:MutiLoader = new MutiLoader(loadResource);
            mloader.takeData = gd;
            mloader.addEventListener(Event.COMPLETE,onResourceLoaded);
            mloader.loadDoc(list);
        }
        
        /**
         * 直接通过URL地址数组来增加图形资源
         * @param	list	包含URL地址的资源数组
         */ 
        public function addLoadResource(list:Array,action:uint=0,frame:uint=1,line:uint=1,fps:uint=1):void//list: [asset/utils/unit/soldiers/marine_stop.png]
        {
            if(_resourceList==null) _resourceList = new Vector.<GraphicsData>;
            
            var loadResource:Array = new Array();
            
            // 生成资源名
            var reslist:Vector.<String> = new Vector.<String>;
            var tempArr:Array;
            var resname:String;
            var needload:Boolean;
            
            var render_resname:String = RENDER_RES_NAME;
            for each(var url:String in list)
            {
                needload = true;
                tempArr = url.split('/');
                
                resname = tempArr.length<=1 ? tempArr[tempArr.length-1] : (tempArr[tempArr.length-2]+"/"+tempArr[tempArr.length-1]);
                reslist.push(resname);
                render_resname+=resname+',';
                if(Global.resPool.getResource(resname)!=null) continue;
                if(Global.LOADWAIT.indexOf(resname)==-1)
                {
                    Global.LOADWAIT.push(resname);
                    _isMaster = true;
                }else{
                    needload=false;
                    // 等待资源加载完成
                    var timer:GraphicsTimer = new GraphicsTimer(500);
                    timer.resname = resname;
                    timer.addEventListener(TimerEvent.TIMER,rootComplate);
                    timer.start();
                }
            }
            
            var gd:GraphicsData = new GraphicsData();
            gd.action = action;
            gd.resNameList = reslist;
            gd.frame = frame;
            gd.line = line;
            gd.fps = fps;
            _resourceList.push(gd);
            
            // 当前动作所需要的渲染资源在资源池中已经存在，则直接进行获取
            if(_nowAction==action && Global.resPool.getResource(render_resname)!=null)
            {
                bitmap_data = Global.resPool.getResource(render_resname);
                mirror_data = Global.resPool.getResource(render_resname+MIRROR);
                _frameWidth = bitmap_data[0][0].width;
                _frameHeight = bitmap_data[0][0].height;
                framesLayer = gd.line;
                framesTotal = gd.frame;
                _fps = gd.fps;
                _nowActionRes=true;
                return;
            }
            
            if(!needload) return;
            
            var mloader:MutiLoader = new MutiLoader(loadResource);
            mloader.takeData = gd;
            mloader.addEventListener(Event.COMPLETE,onResourceLoaded);
            mloader.loadDoc(list);
        }
        
        public function clear():void
        {
            _bitmap = null;
            _mirrorBitmapData=null;
        }
        
        /**
         * 获取某特定动作的最大帧数
         */ 
        public function getFrameTotal(act:int=-1):uint
        {
            if(_resourceList==null)return framesTotal;
            if(act==-1) act = _nowAction;
            return getGD(act).frame;
        }
        
        /**
         * 获取开始帧数，专门用于镜像计算
         */ 
        public function getStartFrame(line:uint):uint
        {
            if(_lineFrame==null || _lineFrame[line]==null)
                return 0;		
            else
                return framesTotal-_lineFrame[line];
        }
        
        /**
         * 设置各行最大帧数
         */ 
        public function set lineFrame(arr:Array):void
        {
            _lineFrame = new Array();
            // 将数据复制过来
            for(var i:uint = 0;i<arr.length;i++)
            {
                _lineFrame.push(arr[i]);
            }
        }
        
        NSGraphics function render(target:Bitmap,line:uint,frame:uint):void
        {
            if(bitmap_data==null || !_nowActionRes)
            {
                target.bitmapData = _DEFAULT_BD;
            }else{
                target.bitmapData = bitmap_data[line][frame];
            }
        }
        
        NSGraphics function renderMirror(target:Bitmap,line:uint,frame:uint):void
        {
            if(mirror_data==null || !_nowActionRes)
            {
                target.bitmapData = _DEFAULT_BD;
            }
            else if(mirror_data.length>line&&mirror_data[line].length>frame)
            {				
                target.bitmapData = mirror_data[line][frame];
            }
            
        }
        
        /**
         * 当前的渲染动作
         */ 
        NSGraphics function set nowAction(act:uint):void
        {
            // 检查目标动作的素材是否存在
            if(actionResAllOK(act))
            {
                if(_nowAction!=act)
                {
                    _nowActionRes = false;
                    updateBuffer(act);
                }
            }else{
                var timer:GraphicsTimer = new GraphicsTimer(500);
                timer.resname = act.toString();
                timer.addEventListener(TimerEvent.TIMER,waitLoadActionRes);
                timer.start();
            }
            
            _nowAction = act;
            _fps = getGD(_nowAction).fps;
        }
        
        public function get fps():uint
        {
            return _fps;
        }
        
        /**
         * 获取某指定动作的资源名
         */ 
        protected function getGD(act:uint):GraphicsData
        {
            for each(var data:GraphicsData in _resourceList)
            {
                if(data.action==act) return data;
            }
            
            return null;
        }
        
        /**
         * 检查某个动作的资源是否完全准备完毕
         */ 
        protected function actionResAllOK(act:uint):Boolean
        {
            for each(var gd:GraphicsData in _resourceList)
            {
                if(gd.action==act) break;
            }
            for each(var res:String in gd.resNameList)
            {
                if(Global.resPool.getResource(res)==null) return false;
                if(_needMirror && Global.resPool.getResource(res+MIRROR)==null) return false;
            }
            return true;
        }
        
        /**
         * 创建位图
         */ 
        protected function createBitmapData(image:IBitmapDrawable,w:uint,h:uint):BitmapData
        {
            var bitmap2:BitmapData = new BitmapData(w, h,true,0x00000000);
            bitmap2.draw(image);
            return bitmap2;
        }
        
        /**
         * 从显示对象创建镜像
         */ 
        protected function createMirror(image:IBitmapDrawable,w:uint,h:uint):BitmapData
        {
            var matrix:Matrix=new Matrix(-1,0,0,1,w);
            
            var bitmap2:BitmapData = new BitmapData(w, h,true,0x00000000);
            bitmap2.draw(image,matrix, null);
            return bitmap2;
        }
        
        /**
         * 等待资源动作加载
         */ 
        private function waitLoadActionRes(e:TimerEvent):void
        {
            var timer:GraphicsTimer = e.target as GraphicsTimer;
            if(int(timer.resname)!=_nowAction)
            {
                // 已更换动作
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER,waitLoadActionRes);
                return;
            }
            
            if(actionResAllOK(_nowAction))
            {
                updateBuffer(_nowAction);
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER,waitLoadActionRes);
            }
        }
        
        private function initBitmap(data:*):void
        {
            // 无匹配资源，开始构建
            if(data is MovieClip && (data as MovieClip).currentFrameLabel=='wait')
            {
                // 影片剪辑，且符合绘制规则
                var tempD:MovieClip = data as MovieClip;
                _bitmap = new BitmapData(tempD.width*framesTotal,tempD.height*framesLayer,true,0x00000000);
                
                tempD.gotoAndStop("walk");
                var tempBitmap:BitmapData = new BitmapData(tempD.width,tempD.height,true,0x00000000);
                
                for(var i:uint = 0;i<framesTotal;i++)
                {
                    tempBitmap.fillRect(tempBitmap.rect,0x00000000);
                    tempBitmap.draw(tempD);
                    _bitmap.copyPixels(tempBitmap,tempBitmap.rect,new Point(i*tempD.width,0),null,null,true);
                    tempD.nextFrame();
                }
                
                tempBitmap.dispose();
                tempBitmap = null;
                tempD = null;
            }else if(data is IBitmapDrawable){
                _bitmap = createBitmapData(data,data.width,data.height);
            }
        }
        
        /**
         *	将位图转成渲染用位图序列
         * 	@param	res			源素材
         * 	@param	isMirror	是否镜像，镜像的素材要经过序列反转处理
         */ 
        private function makeVector(res:BitmapData,isMirror:Boolean=false):Vector.<Vector.<BitmapData>>
        {
            if(res==null) return null;
            var data:Vector.<Vector.<BitmapData>> = new Vector.<Vector.<BitmapData>>;
            var y:uint;
            var x:uint;
            for(y=0;y<framesLayer;y++)
            {
                var line:Vector.<BitmapData>=new Vector.<BitmapData>;
                for(x=0;x<framesTotal;x++)
                {
                    var b:BitmapData = new BitmapData(_frameWidth,_frameHeight,true,0x00000000);
                    b.copyPixels(res,new Rectangle(x*_frameWidth,y*_frameHeight,_frameWidth,_frameHeight),new Point(),null,null,true);
                    line.push(b);
                }
                if(isMirror) line.reverse();
                data.push(line);
            }
            
            return data;
        }
        
        /**
         * 等待调用资源加载完成
         * 
         */ 
        private function rootComplate(e:TimerEvent):void
        {
            var resname:String = (e.target as GraphicsTimer).resname;
            if(resname=='') throw new Error("A no resname GraphicsTimer founded.");
            
            var gd:GraphicsData = getGD(_nowAction);
            if(gd==null) throw new Error("A no exist GraphicsData");
            
            if(!actionResAllOK(_nowAction)) return;
            
            updateBuffer(_nowAction);
            
            var timer:Timer = e.target as Timer;
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,rootComplate);
        }
        
        /**
         * 更新动作缓冲区
         */ 
        private function updateBuffer(act:uint):void
        {
            // 获取资源名，并从资源池中取出对应的资源
            var gd:GraphicsData = getGD(act);
            if(gd==null) throw new Error("Can not find this action's resname ("+act+").");
            
            var resname:String = RENDER_RES_NAME;
            for each(var s:String in gd.resNameList) resname+=s+',';
            
            // 从资源池中检查拼合资源
            
            if(Global.resPool.getResource(resname)==null)
            {
                var resList:Vector.<BitmapData> =  new Vector.<BitmapData>;
                var resMirList:Vector.<BitmapData> = new Vector.<BitmapData>;
                for each(var res:String in gd.resNameList)
                {
                    var resData:BitmapData = Global.resPool.getResource(res);
                    if(resData==null)
                    {
                        trace("Notice:a null resource founded.");
                    }else{
                        resList.push(resData);
                    }
                    
                    if(_needMirror)
                    {
                        var resMirData:BitmapData = Global.resPool.getResource(res+MIRROR);
                        if(resMirData==null)
                        {
                            trace("Notice:a null resource mirror founded.");
                        }else{
                            resMirList.push(resMirData);
                        }
                    }
                    
                }
                if(resList==null)
                {
                    trace("No resource can be used.");
                    return;
                }
                
                
                _bitmap = resList[0].clone();
                if(resMirList.length>0) _mirrorBitmapData = resMirList[0].clone();
                
                framesLayer = gd.line;
                framesTotal = gd.frame;
                _frameWidth = int(_bitmap.width/gd.frame);
                _frameHeight = int(_bitmap.height/gd.line);
                _fps = gd.fps;
                
                
                // 构建主渲染序列
                var i:int;
                var j:int;
                for(i=1,j= resList.length;i<j;i++)
                {
                    _bitmap.draw(resList[i]);
                }
                resList.splice(0,resList.length);
                resList=null;
                
                bitmap_data = makeVector(_bitmap);
                
                // 构建镜像渲染序列
                if(_mirrorBitmapData)
                {
                    for(i=1,j= resMirList.length;i<j;i++)
                    {
                        _mirrorBitmapData.draw(resMirList[i]);
                    }
                    resMirList.splice(0,resMirList.length);
                    resMirList = null;
                    
                    mirror_data = makeVector(_mirrorBitmapData,true);
                    Global.resPool.addResource(resname+MIRROR,mirror_data);
                }
                Global.resPool.addResource(resname,bitmap_data);
                
            }else{
                bitmap_data = Global.resPool.getResource(resname);
                mirror_data = Global.resPool.getResource(resname+MIRROR);
                
                framesLayer = gd.line;
                framesTotal = gd.frame;
                _frameWidth = bitmap_data[0][0].width;
                _frameHeight = bitmap_data[0][0].height;
                _fps = gd.fps;
            }
            
            _bitmap=null;
            _mirrorBitmapData=null;
            _nowActionRes=true;
        }
        
        
        private function onResourceLoaded(e:Event):void
        {
            var breakZero:Boolean=false;
            
            var target:MutiLoader = e.target as MutiLoader;
            
            var gd:GraphicsData = target.takeData;
            
            var i:uint;
            var id:int;
            var j:int;
            
            for(i=0,j=gd.resNameList.length;i<j;i++)
            {
                Global.resPool.addResource(gd.resNameList[i],(target.Data[i] as Bitmap).bitmapData);
                
                if(_needMirror)
                {
                    var mirror:BitmapData = createMirror(target.Data[i],target.Data[i].width,target.Data[i].height);
                    Global.resPool.addResource(gd.resNameList[i]+MIRROR,mirror);
                }
                
                id = Global.LOADWAIT.indexOf(gd.resNameList[i]);
                if(id!=-1) Global.LOADWAIT.splice(id,1);
            }
            
            target.removeEventListener(Event.COMPLETE,onResourceLoaded);
            target.clear();
            
            if(gd.action==_nowAction)
            {
                updateBuffer(_nowAction);
            }
        }
        
    }
    
}