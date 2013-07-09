package com.D5Power.core
{
    /**
     * ...
     * @author sliz	http://game-develop.net/
     */
    import com.D5Power.map.WorldMap;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    
    public class SilzAstar{
        
        /**
         * 寻路方式，8方向和4方向，有效值为8和4
         */ 
        private static var WorkMode:uint = 8;
        
        private var _grid:Grid;
        private var _index:int;
        private var _path:Array;
        private var astar:AStar;
        
        /**
         * 地图显示尺寸
         */ 
        private var _cellSize:int = 5;
        /**
         * 路径显示器
         */ 
        private var path:Sprite = new Sprite();
        /**
         * 地图显示器
         */ 
        private var image:Bitmap = new Bitmap(new BitmapData(1, 1));
        /**
         * 显示容器
         */ 
        private var imageWrapper:Sprite = new Sprite();
        
        /**
         * 显示模式
         */ 
        private var isDisplayMode:Boolean=false;
        
        /**
         * @param	mapdata		地图数据
         * @param	container	显示容器，若为null则不显示地图
         */ 
        public function SilzAstar(mapdata:Array,container:DisplayObjectContainer=null)
        {
            if(container!=null)
            {
                isDisplayMode = true;
                imageWrapper.addChild(image);
                
                container.addChild(imageWrapper);
                
                imageWrapper.addChild(path);
            }else{
                isDisplayMode = false;
            }
            
            makeGrid(mapdata);
        }
        
        public function set WORKMODE(v:uint):void
        {
            if(v!=8 && v!=4) throw new Error('仅支持8方向或4方向寻路');
        }
        
        /**
         * @param		xnow	当前坐标X(世界坐标)
         * @param		ynow	当前坐标Y(世界坐标)
         * @param		xpos	目标点X(世界坐标)
         * @param		ypos	目标点Y(世界坐标)
         */ 
        public function find(xnow:uint,ynow:uint,xpos:uint,ypos:uint):Array {
            xpos = int(xpos / WorldMap.tileWidth);
            ypos = int(ypos / WorldMap.tileHeight);
            xpos = Math.min(xpos, _grid.numCols - 1);
            ypos = Math.min(ypos, _grid.numRows - 1);
            _grid.setEndNode(xpos, ypos); //1
            
            xnow = int(xnow / WorldMap.tileWidth);
            ynow = int(ynow / WorldMap.tileHeight);
            
            _grid.setStartNode(xnow, ynow); //2
            
            if(isDisplayMode)
            {
                var time:int = getTimer();
            }
            
            
            if (astar.findPath()){ //3
                _index = 0;
                
                astar.floyd();
                _path = astar.floydPath;
                
                if(isDisplayMode)
                {
                    time = getTimer() - time;
                    trace("[SilzAstar]",time + "ms   length:" + astar.path.length);
                    trace("[SilzAstar]",astar.floydPath);
                    path.graphics.clear();
                    for (var i:int = 0; i < astar.floydPath.length; i++){
                        var p:Node = astar.floydPath[i];
                        path.graphics.lineStyle(0, 0xff0000);
                        path.graphics.drawCircle((p.x + 0.5) * _cellSize, (p.y + 0.5) * _cellSize, 2);
                        
                        path.graphics.lineStyle(0, 0xff0000, 0.5);
                        path.graphics.moveTo(xnow,ynow);
                    }
                }
                
                return _path;
            }else if(isDisplayMode){
                _grid.setEndNode(xpos-1, ypos-1);
                time = getTimer() - time;
                trace("[SilzAstar]",time + "ms 找不到");
            }
            
            return null;
        }
        
        private function makeGrid(data:Array):void {
            var rows:int = data.length;
            var cols:int = data[0].length;
            _grid = new Grid(cols, rows);
            
            var px:uint;
            var py:uint;
            
            for(py=0;py<rows;py++)
            {
                for(px=0;px<cols;px++)
                {
                    _grid.setWalkable(px,py,data[py][px]==0);
                }
            }
            
            if (WorkMode==4)
                _grid.calculateLinks(1);
            else
                _grid.calculateLinks();
            
            astar = new AStar(_grid);
            
            if(isDisplayMode)
            {
                drawGrid();
                path.graphics.clear();
            }
        }
        
        private function drawGrid():void {
            image.bitmapData = new BitmapData(_grid.numCols * _cellSize, _grid.numRows * _cellSize, false, 0xffffff);
            for (var i:int = 0; i < _grid.numCols; i++){
                for (var j:int = 0; j < _grid.numRows; j++){
                    var node:Node = _grid.getNode(i, j);
                    if (!node.walkable){
                        image.bitmapData.fillRect(new Rectangle(i * _cellSize, j * _cellSize, _cellSize, _cellSize), getColor(node));
                    }
                }
            }
        }
        
        private function getColor(node:Node):uint {
            if (!node.walkable)
                return 0;
            if (node == _grid.startNode)
                return 0xcccccc;
            if (node == _grid.endNode)
                return 0xcccccc;
            return 0xffffff;
        }
        
    }
}

import flash.geom.Point;

class AStar {
    //private var _open:Array;
    private var _open:BinaryHeap;
    private var _grid:Grid;
    private var _endNode:Node;
    private var _startNode:Node;
    private var _path:Array;
    private var _floydPath:Array;
    public var heuristic:Function;
    private var _straightCost:Number = 1.0;
    private var _diagCost:Number = Math.SQRT2;
    private var nowversion:int = 1;
    
    
    public function AStar(grid:Grid){
        this._grid = grid;
        heuristic = euclidian2;
        
    }
    
    private function justMin(x:Object, y:Object):Boolean {
        return x.f < y.f;
    }
    
    public function findPath():Boolean {
        _endNode = _grid.endNode;
        nowversion++;
        _startNode = _grid.startNode;
        //_open = [];
        _open = new BinaryHeap(justMin);
        _startNode.g = 0;
        return search();
    }
    
    public function floyd():void {
        if (path == null)
            return;
        _floydPath = path.concat();
        var len:int = _floydPath.length;
        if (len > 2){
            var vector:Node = new Node(0, 0);
            var tempVector:Node = new Node(0, 0);
            floydVector(vector, _floydPath[len - 1], _floydPath[len - 2]);
            for (var i:int = _floydPath.length - 3; i >= 0; i--){
                floydVector(tempVector, _floydPath[i + 1], _floydPath[i]);
                if (vector.x == tempVector.x && vector.y == tempVector.y){
                    _floydPath.splice(i + 1, 1);
                } else {
                    vector.x = tempVector.x;
                    vector.y = tempVector.y;
                }
            }
        }
        len = _floydPath.length;
        for (i = len - 1; i >= 0; i--){
            for (var j:int = 0; j <= i - 2; j++){
                if (floydCrossAble(_floydPath[i], _floydPath[j])){
                    for (var k:int = i - 1; k > j; k--){
                        _floydPath.splice(k, 1);
                    }
                    i = j;
                    len = _floydPath.length;
                    break;
                }
            }
        }
    }
    
    private function floydCrossAble(n1:Node, n2:Node):Boolean {
        var ps:Array = bresenhamNodes(new Point(n1.x, n1.y), new Point(n2.x, n2.y));
        for (var i:int = ps.length - 2; i > 0; i--){
            if (!_grid.getNode(ps[i].x, ps[i].y).walkable){
                return false;
            }
        }
        return true;
    }
    
    private function bresenhamNodes(p1:Point, p2:Point):Array {
        var steep:Boolean = Math.abs(p2.y - p1.y) > Math.abs(p2.x - p1.x);
        if (steep){
            var temp:int = p1.x;
            p1.x = p1.y;
            p1.y = temp;
            temp = p2.x;
            p2.x = p2.y;
            p2.y = temp;
        }
        var stepX:int = p2.x > p1.x ? 1 : (p2.x < p1.x ? -1 : 0);
        var stepY:int = p2.y > p1.y ? 1 : (p2.y < p1.y ? -1 : 0);
        var deltay:Number = (p2.y - p1.y) / Math.abs(p2.x - p1.x);
        var ret:Array = [];
        var nowX:Number = p1.x + stepX;
        var nowY:Number = p1.y + deltay;
        if (steep){
            ret.push(new Point(p1.y, p1.x));
        } else {
            ret.push(new Point(p1.x, p1.y));
        }
        while (nowX != p2.x){
            var fy:int = Math.floor(nowY)
            var cy:int = Math.ceil(nowY);
            if (steep){
                ret.push(new Point(fy, nowX));
            } else {
                ret.push(new Point(nowX, fy));
            }
            if (fy != cy){
                if (steep){
                    ret.push(new Point(cy, nowX));
                } else {
                    ret.push(new Point(nowX, cy));
                }
            }
            nowX += stepX;
            nowY += deltay;
        }
        if (steep){
            ret.push(new Point(p2.y, p2.x));
        } else {
            ret.push(new Point(p2.x, p2.y));
        }
        return ret;
    }
    
    private function floydVector(target:Node, n1:Node, n2:Node):void {
        target.x = n1.x - n2.x;
        target.y = n1.y - n2.y;
    }
    
    public function search():Boolean {
        var node:Node = _startNode;
        node.version = nowversion;
        while (node != _endNode){
            var len:int = node.links.length;
            for (var i:int = 0; i < len; i++){
                var test:Node = node.links[i].node;
                var cost:Number = node.links[i].cost;
                var g:Number = node.g + cost;
                var h:Number = heuristic(test);
                var f:Number = g + h;
                if (test.version == nowversion){
                    if (test.f > f){
                        test.f = f;
                        test.g = g;
                        test.h = h;
                        test.parent = node;
                    }
                } else {
                    test.f = f;
                    test.g = g;
                    test.h = h;
                    test.parent = node;
                    _open.ins(test);
                    test.version = nowversion;
                }
                
            }
            if (_open.a.length == 1){
                return false;
            }
            node = _open.pop() as Node;
        }
        buildPath();
        return true;
    }
    
    private function buildPath():void {
        _path = [];
        var node:Node = _endNode;
        _path.push(node);
        while (node != _startNode){
            node = node.parent;
            _path.unshift(node);
        }
    }
    
    public function get path():Array {
        return _path;
    }
    
    public function get floydPath():Array {
        return _floydPath;
    }
    
    public function manhattan(node:Node):Number {
        return Math.abs(node.x - _endNode.x) + Math.abs(node.y - _endNode.y);
    }
    
    public function manhattan2(node:Node):Number {
        var dx:Number = Math.abs(node.x - _endNode.x);
        var dy:Number = Math.abs(node.y - _endNode.y);
        return dx + dy + Math.abs(dx - dy) / 1000;
    }
    
    public function euclidian(node:Node):Number {
        var dx:Number = node.x - _endNode.x;
        var dy:Number = node.y - _endNode.y;
        return Math.sqrt(dx * dx + dy * dy);
    }
    
    private var TwoOneTwoZero:Number = 2 * Math.cos(Math.PI / 3);
    
    public function chineseCheckersEuclidian2(node:Node):Number {
        var y:int = node.y / TwoOneTwoZero;
        var x:int = node.x + node.y / 2;
        var dx:Number = x - _endNode.x - _endNode.y / 2;
        var dy:Number = y - _endNode.y / TwoOneTwoZero;
        return sqrt(dx * dx + dy * dy);
    }
    
    private function sqrt(x:Number):Number {
        return Math.sqrt(x);
    }
    
    public function euclidian2(node:Node):Number {
        var dx:Number = node.x - _endNode.x;
        var dy:Number = node.y - _endNode.y;
        return dx * dx + dy * dy;
    }
    
    public function diagonal(node:Node):Number {
        var dx:Number = Math.abs(node.x - _endNode.x);
        var dy:Number = Math.abs(node.y - _endNode.y);
        var diag:Number = Math.min(dx, dy);
        var straight:Number = dx + dy;
        return _diagCost * diag + _straightCost * (straight - 2 * diag);
    }
}

class BinaryHeap {
    public var a:Array = [];
    public var justMinFun:Function = function(x:Object, y:Object):Boolean {
        return x < y;
    };
    
    public function BinaryHeap(justMinFun:Function = null){
        a.push(-1);
        if (justMinFun != null)
            this.justMinFun = justMinFun;
    }
    
    public function ins(value:Object):void {
        var p:int = a.length;
        a[p] = value;
        var pp:int = p >> 1;
        while (p > 1 && justMinFun(a[p], a[pp])){
            var temp:Object = a[p];
            a[p] = a[pp];
            a[pp] = temp;
            p = pp;
            pp = p >> 1;
        }
    }
    
    public function pop():Object {
        var min:Object = a[1];
        a[1] = a[a.length - 1];
        a.pop();
        var p:int = 1;
        var l:int = a.length;
        var sp1:int = p << 1;
        var sp2:int = sp1 + 1;
        while (sp1 < l){
            if (sp2 < l){
                var minp:int = justMinFun(a[sp2], a[sp1]) ? sp2 : sp1;
            } else {
                minp = sp1;
            }
            if (justMinFun(a[minp], a[p])){
                var temp:Object = a[p];
                a[p] = a[minp];
                a[minp] = temp;
                p = minp;
                sp1 = p << 1;
                sp2 = sp1 + 1;
            } else {
                break;
            }
        }
        return min;
    }
}

class Grid {
    
    private var _startNode:Node;
    private var _endNode:Node;
    private var _nodes:Array;
    private var _numCols:int;
    private var _numRows:int;
    
    private var type:int;
    
    private var _straightCost:Number = 1.0;
    private var _diagCost:Number = Math.SQRT2;
    
    public function Grid(numCols:int, numRows:int){
        _numCols = numCols;
        _numRows = numRows;
        _nodes = new Array();
        
        for (var i:int = 0; i < _numCols; i++){
            _nodes[i] = new Array();
            for (var j:int = 0; j < _numRows; j++){
                _nodes[i][j] = new Node(i, j);
            }
        }
    }
    
    /**
     *
     * @param   type    0四方向 1八方向 2跳棋
     */
    public function calculateLinks(type:int = 0):void {
        this.type = type;
        for (var i:int = 0; i < _numCols; i++){
            for (var j:int = 0; j < _numRows; j++){
                initNodeLink(_nodes[i][j], type);
            }
        }
    }
    
    public function getType():int {
        return type;
    }
    
    /**
     *
     * @param   node
     * @param   type    0八方向 1四方向 2跳棋
     */
    private function initNodeLink(node:Node, type:int):void {
        var startX:int = Math.max(0, node.x - 1);
        var endX:int = Math.min(numCols - 1, node.x + 1);
        var startY:int = Math.max(0, node.y - 1);
        var endY:int = Math.min(numRows - 1, node.y + 1);
        node.links = [];
        for (var i:int = startX; i <= endX; i++){
            for (var j:int = startY; j <= endY; j++){
                var test:Node = getNode(i, j);
                if (test == node || !test.walkable){
                    continue;
                }
                if (type != 2 && i != node.x && j != node.y){
                    var test2:Node = getNode(node.x, j);
                    if (!test2.walkable){
                        continue;
                    }
                    test2 = getNode(i, node.y);
                    if (!test2.walkable){
                        continue;
                    }
                }
                var cost:Number = _straightCost;
                if (!((node.x == test.x) || (node.y == test.y))){
                    if (type == 1){
                        continue;
                    }
                    if (type == 2 && (node.x - test.x) * (node.y - test.y) == 1){
                        continue;
                    }
                    if (type == 2){
                        cost = _straightCost;
                    } else {
                        cost = _diagCost;
                    }
                }
                node.links.push(new Link(test, cost));
            }
        }
    }
    
    public function getNode(x:int, y:int):Node {
        return _nodes[x][y];
    }
    
    public function setEndNode(x:int, y:int):void {
        _endNode = _nodes[x][y];
    }
    
    public function setStartNode(x:int, y:int):void {
        _startNode = _nodes[x][y];
    }
    
    public function setWalkable(x:int, y:int, value:Boolean):void {
        _nodes[x][y].walkable = value;
    }
    
    public function get endNode():Node {
        return _endNode;
    }
    
    public function get numCols():int {
        return _numCols;
    }
    
    public function get numRows():int {
        return _numRows;
    }
    
    public function get startNode():Node {
        return _startNode;
    }
    
}

class Link {
    public var node:Node;
    public var cost:Number;
    
    public function Link(node:Node, cost:Number){
        this.node = node;
        this.cost = cost;
    }
    
}

class Node {
    public var x:int;
    public var y:int;
    public var f:Number;
    public var g:Number;
    public var h:Number;
    public var walkable:Boolean = true;
    public var parent:Node;
    //public var costMultiplier:Number = 1.0;
    public var version:int = 1;
    public var links:Array;
    
    //public var index:int;
    public function Node(x:int, y:int){
        this.x = x;
        this.y = y;
    }
    
    public function toString():String {
        return "x:" + x + " y:" + y;
    }
}
