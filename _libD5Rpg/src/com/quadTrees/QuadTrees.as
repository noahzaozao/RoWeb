package com.quadTrees {
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.geom.Rectangle;
    
    import __AS3__.vec.Vector;
    
    public class QuadTrees
    {
        
        public var nodes:Hash;
        private var _node:Node;
        private var hash:Hash;
        private var vo:Vo;
        public var graphics:Graphics;
        private var _minSize:uint = 10;
        private var _rect:Rectangle;
        
        public function QuadTrees()
        {
            super();
            hash = new Hash();
            nodes = new Hash();
            vo = new Vo();
        }
        public function set minSize(value:int):void
        {
            if ((value < 5))
            {
                value = 5;
            };
            _minSize = value;
            node.project(_minSize);
        }
        public function get node():Node
        {
            return (_node);
        }
        public function get rect():Rectangle
        {
            return (_rect);
        }
        public function setUP(x:Number, y:Number, rect:Rectangle, source:Vector.<INoder>, keys:Vector.<String>):void
        {
            var i:int;
            var target:DisplayObject;
            _node = new Node();
            _rect = rect;
            _node.setUp(this, x, y, rect, null);
            _node.level = 0;
            if (source){
                i = 0;
                while (i < source.length) {
                    target = (source[i] as DisplayObject);
                    if (target){
                        node.addChild(target, keys[i]);
                    };
                    i++;
                };
            };
        }
        public function minWidth():Number
        {
            return (cycleValue(rect.width));
        }
        public function minHeight():Number
        {
            return (cycleValue(rect.height));
        }
        private function cycleValue(value:Number):Number
        {
            if ((value / 2) > _minSize){
                value = cycleValue((value / 4));
                if (value != -1){
                    return (value);
                };
            } else {
                return (value);
            };
            return (-1);
        }
        public function find(node:Node, rect:Rectangle, definition:Number=20):Vector.<INoder>
        {
            var array:Vector.<INoder> = new Vector.<INoder>();
            cyclefind(array, node, rect, definition);
            return (array);
        }
        private function cyclefind(array:Vector.<INoder>, node:Node, rect:Rectangle, definition:Number=20):Vector.<INoder>{
            var k:String;
            if (definition < _minSize){
                definition = _minSize;
            };
            if (node){
                if (((rect.intersects(node.rect)) && ((node.length > 0)))){
                    if (node.cellSize <= definition){
                        node.drawBound(graphics, node.rect, 0xFF);
                        for (k in node.hash.hashMap) {
                            array.push(node.hash.hashMap[k]);
                        };
                    } else {
                        if (node.nodeA){
                            cyclefind(array, node.nodeA, rect, definition);
                        };
                        if (node.nodeB){
                            cyclefind(array, node.nodeB, rect, definition);
                        };
                        if (node.nodeC){
                            cyclefind(array, node.nodeC, rect, definition);
                        };
                        if (node.nodeD){
                            cyclefind(array, node.nodeD, rect, definition);
                        };
                    };
                };
            };
            return (null);
        }
        
    }
}//package com.quadTrees 