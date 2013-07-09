package com.quadTrees {
    import flash.display.Sprite;
    import flash.geom.Point;
    
    public class Noder extends Sprite implements INoder {
        
        private var tree:QuadTrees;
        private var _node:Node;
        private var _vo:Vo;
        public var a:int = 1;
        public var b:int = 1;
        public var vx:int;
        public var vy:int;
        private var stop:Boolean = false;
        
        public function Noder(tree:QuadTrees){
            this.vx = (((Math.random() * 3) >> 0) + 1);
            this.vy = (((Math.random() * 3) >> 0) + 1);
            super();
            this.tree = tree;
            this._vo = new Vo();
        }
        public function get vo():Vo{
            return (this._vo);
        }
        override public function set y(value:Number):void{
            super.y = value;
            if (((!(this.stop)) && (this.tree))){
                this.updata();
            };
        }
        override public function set x(value:Number):void{
            super.x = value;
            if (((!(this.stop)) && (this.tree))){
                this.updata();
            };
        }
        private function updata():void{
            var xx:Number;
            var xy:Number;
            var key:String;
            var nodex:Node;
            if (this.node){
                if (this.node.owner){
                    if (!(this.node.rect.containsPoint(new Point(this.x, this.y)))){
                        xx = int((this.x / this.node.rect.width));
                        xy = int((this.y / this.node.rect.height));
                        key = ((xx + "-") + xy);
                        nodex = (this.tree.nodes.take(key) as Node);
                        this.reset(this.node, nodex);
                        this.node = nodex;
                    };
                };
            };
        }
        private function reset(node:Node, newNode:Node):void{
            if (((node) && (newNode))){
                if (node != newNode){
                    node.hash.remove(this.vo.id);
                    newNode.hash.put(this, this.vo.id);
                    this.reset(node.owner, newNode.owner);
                };
            };
        }
        private function remove(node:Node):void{
            if (node){
                node.hash.remove(this.vo.id);
                if (node.owner){
                    this.remove(node.owner);
                };
            };
        }
        private function push(node:Node):void{
            if (node){
                node.hash.put(this, this.vo.id);
                this.push(node.owner);
            };
        }
        public function insert():void{
            this.stop = false;
            var vw:Number = this.tree.minWidth();
            var vh:Number = this.tree.minHeight();
            var xx:Number = int((this.x / vw));
            var xy:Number = int((this.y / vh));
            var key:String = ((xx + "-") + xy);
            var node:Node = (this.tree.nodes.take(key) as Node);
            this.node = node;
            this.push(node);
        }
        public function unload():void{
            this.stop = true;
            this.remove(this.node);
            this.tree = null;
        }
        override public function get x():Number{
            return (super.x);
        }
        override public function get y():Number{
            return (super.y);
        }
        public function get node():Node{
            return (this._node);
        }
        public function set node(value:Node):void{
            this._node = value;
        }
        
    }
}//package com.quadTrees 