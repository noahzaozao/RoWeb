/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.GroupedList;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.data.HierarchicalCollection;
	import feathers.events.CollectionEventType;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.errors.IllegalOperationError;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * @private
	 * Used internally by GroupedList. Not meant to be used on its own.
	 */
	public final class GroupedListDataViewPort extends FeathersControl implements IViewPort
	{
		private static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";

		private static const HELPER_POINT:Point = new Point();
		private static const HELPER_VECTOR:Vector.<int> = new <int>[];

		public function GroupedListDataViewPort()
		{
			super();
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private var touchPointID:int = -1;

		private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

		private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

		private var _minVisibleWidth:Number = 0;

		public function get minVisibleWidth():Number
		{
			return this._minVisibleWidth;
		}

		public function set minVisibleWidth(value:Number):void
		{
			if(this._minVisibleWidth == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("minVisibleWidth cannot be NaN");
			}
			this._minVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _maxVisibleWidth:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleWidth():Number
		{
			return this._maxVisibleWidth;
		}

		public function set maxVisibleWidth(value:Number):void
		{
			if(this._maxVisibleWidth == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("maxVisibleWidth cannot be NaN");
			}
			this._maxVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var actualVisibleWidth:Number = NaN;

		private var explicitVisibleWidth:Number = NaN;

		public function get visibleWidth():Number
		{
			return this.actualVisibleWidth;
		}

		public function set visibleWidth(value:Number):void
		{
			if(this.explicitVisibleWidth == value || (isNaN(value) && isNaN(this.explicitVisibleWidth)))
			{
				return;
			}
			this.explicitVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _minVisibleHeight:Number = 0;

		public function get minVisibleHeight():Number
		{
			return this._minVisibleHeight;
		}

		public function set minVisibleHeight(value:Number):void
		{
			if(this._minVisibleHeight == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("minVisibleHeight cannot be NaN");
			}
			this._minVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _maxVisibleHeight:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleHeight():Number
		{
			return this._maxVisibleHeight;
		}

		public function set maxVisibleHeight(value:Number):void
		{
			if(this._maxVisibleHeight == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("maxVisibleHeight cannot be NaN");
			}
			this._maxVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var actualVisibleHeight:Number;

		private var explicitVisibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			return this.actualVisibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this.explicitVisibleHeight == value || (isNaN(value) && isNaN(this.explicitVisibleHeight)))
			{
				return;
			}
			this.explicitVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		protected var _contentX:Number = 0;

		public function get contentX():Number
		{
			return this._contentX;
		}

		protected var _contentY:Number = 0;

		public function get contentY():Number
		{
			return this._contentY;
		}

		public function get horizontalScrollStep():Number
		{
			var renderers:Vector.<IGroupedListItemRenderer> = this._activeItemRenderers;
			if(!renderers || renderers.length == 0)
			{
				renderers = this._activeFirstItemRenderers;
			}
			if(!renderers || renderers.length == 0)
			{
				renderers = this._activeLastItemRenderers;
			}
			if(!renderers || renderers.length == 0)
			{
				renderers = this._activeSingleItemRenderers;
			}
			if(!renderers || renderers.length == 0)
			{
				return 0;
			}
			var itemRenderer:IGroupedListItemRenderer = renderers[0];
			var itemRendererWidth:Number = itemRenderer.width;
			var itemRendererHeight:Number = itemRenderer.height;
			if(itemRendererWidth < itemRendererHeight)
			{
				return itemRendererWidth;
			}
			return itemRendererHeight;
		}

		public function get verticalScrollStep():Number
		{
			var renderers:Vector.<IGroupedListItemRenderer> = this._activeItemRenderers;
			if(!renderers || renderers.length == 0)
			{
				renderers = this._activeFirstItemRenderers;
			}
			if(!renderers || renderers.length == 0)
			{
				renderers = this._activeLastItemRenderers;
			}
			if(!renderers || renderers.length == 0)
			{
				renderers = this._activeSingleItemRenderers;
			}
			if(!renderers || renderers.length == 0)
			{
				return 0;
			}
			var itemRenderer:IGroupedListItemRenderer = renderers[0];
			var itemRendererWidth:Number = itemRenderer.width;
			var itemRendererHeight:Number = itemRenderer.height;
			if(itemRendererWidth < itemRendererHeight)
			{
				return itemRendererWidth;
			}
			return itemRendererHeight;
		}

		private var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];

		private var _typicalItemIsInDataProvider:Boolean = false;
		private var _typicalItemRenderer:IGroupedListItemRenderer;

		private var _unrenderedItems:Vector.<int> = new <int>[];
		private var _inactiveItemRenderers:Vector.<IGroupedListItemRenderer> = new <IGroupedListItemRenderer>[];
		private var _activeItemRenderers:Vector.<IGroupedListItemRenderer> = new <IGroupedListItemRenderer>[];
		private var _itemRendererMap:Dictionary = new Dictionary(true);

		private var _unrenderedFirstItems:Vector.<int>;
		private var _inactiveFirstItemRenderers:Vector.<IGroupedListItemRenderer>;
		private var _activeFirstItemRenderers:Vector.<IGroupedListItemRenderer>;
		private var _firstItemRendererMap:Dictionary = new Dictionary(true);

		private var _unrenderedLastItems:Vector.<int>;
		private var _inactiveLastItemRenderers:Vector.<IGroupedListItemRenderer>;
		private var _activeLastItemRenderers:Vector.<IGroupedListItemRenderer>;
		private var _lastItemRendererMap:Dictionary;

		private var _unrenderedSingleItems:Vector.<int>;
		private var _inactiveSingleItemRenderers:Vector.<IGroupedListItemRenderer>;
		private var _activeSingleItemRenderers:Vector.<IGroupedListItemRenderer>;
		private var _singleItemRendererMap:Dictionary;

		private var _unrenderedHeaders:Vector.<int> = new <int>[];
		private var _inactiveHeaderRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new <IGroupedListHeaderOrFooterRenderer>[];
		private var _activeHeaderRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new <IGroupedListHeaderOrFooterRenderer>[];
		private var _headerRendererMap:Dictionary = new Dictionary(true);

		private var _unrenderedFooters:Vector.<int> = new <int>[];
		private var _inactiveFooterRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new <IGroupedListHeaderOrFooterRenderer>[];
		private var _activeFooterRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new <IGroupedListHeaderOrFooterRenderer>[];
		private var _footerRendererMap:Dictionary = new Dictionary(true);

		private var _headerIndices:Vector.<int> = new <int>[];
		private var _footerIndices:Vector.<int> = new <int>[];

		private var _isScrolling:Boolean = false;

		private var _owner:GroupedList;

		public function get owner():GroupedList
		{
			return this._owner;
		}

		public function set owner(value:GroupedList):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner)
			{
				this._owner.removeEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
			}
			this._owner = value;
			if(this._owner)
			{
				this._owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
			}
		}

		private var _dataProvider:HierarchicalCollection;

		public function get dataProvider():HierarchicalCollection
		{
			return this._dataProvider;
		}

		public function set dataProvider(value:HierarchicalCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
				this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
			}
			if(this._layout is IVariableVirtualLayout)
			{
				IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _isSelectable:Boolean = true;

		public function get isSelectable():Boolean
		{
			return this._isSelectable;
		}

		public function set isSelectable(value:Boolean):void
		{
			if(this._isSelectable == value)
			{
				return;
			}
			this._isSelectable = value;
			if(!this._isSelectable)
			{
				this.setSelectedLocation(-1, -1);
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		private var _selectedGroupIndex:int = -1;

		public function get selectedGroupIndex():int
		{
			return this._selectedGroupIndex;
		}

		private var _selectedItemIndex:int = -1;

		public function get selectedItemIndex():int
		{
			return this._selectedItemIndex;
		}

		private var _itemRendererType:Class;

		public function get itemRendererType():Class
		{
			return this._itemRendererType;
		}

		public function set itemRendererType(value:Class):void
		{
			if(this._itemRendererType == value)
			{
				return;
			}

			this._itemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _itemRendererFactory:Function;

		public function get itemRendererFactory():Function
		{
			return this._itemRendererFactory;
		}

		public function set itemRendererFactory(value:Function):void
		{
			if(this._itemRendererFactory === value)
			{
				return;
			}

			this._itemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _itemRendererName:String;

		public function get itemRendererName():String
		{
			return this._itemRendererName;
		}

		public function set itemRendererName(value:String):void
		{
			if(this._itemRendererName == value)
			{
				return;
			}
			this._itemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _typicalItem:Object = null;

		public function get typicalItem():Object
		{
			return this._typicalItem;
		}

		public function set typicalItem(value:Object):void
		{
			if(this._typicalItem == value)
			{
				return;
			}
			this._typicalItem = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _itemRendererProperties:PropertyProxy;

		public function get itemRendererProperties():PropertyProxy
		{
			return this._itemRendererProperties;
		}

		public function set itemRendererProperties(value:PropertyProxy):void
		{
			if(this._itemRendererProperties == value)
			{
				return;
			}
			if(this._itemRendererProperties)
			{
				this._itemRendererProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._itemRendererProperties = PropertyProxy(value);
			if(this._itemRendererProperties)
			{
				this._itemRendererProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _firstItemRendererType:Class;

		public function get firstItemRendererType():Class
		{
			return this._firstItemRendererType;
		}

		public function set firstItemRendererType(value:Class):void
		{
			if(this._firstItemRendererType == value)
			{
				return;
			}

			this._firstItemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _firstItemRendererFactory:Function;

		public function get firstItemRendererFactory():Function
		{
			return this._firstItemRendererFactory;
		}

		public function set firstItemRendererFactory(value:Function):void
		{
			if(this._firstItemRendererFactory === value)
			{
				return;
			}

			this._firstItemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _firstItemRendererName:String;

		public function get firstItemRendererName():String
		{
			return this._firstItemRendererName;
		}

		public function set firstItemRendererName(value:String):void
		{
			if(this._firstItemRendererName == value)
			{
				return;
			}
			this._firstItemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _lastItemRendererType:Class;

		public function get lastItemRendererType():Class
		{
			return this._lastItemRendererType;
		}

		public function set lastItemRendererType(value:Class):void
		{
			if(this._lastItemRendererType == value)
			{
				return;
			}

			this._lastItemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _lastItemRendererFactory:Function;

		public function get lastItemRendererFactory():Function
		{
			return this._lastItemRendererFactory;
		}

		public function set lastItemRendererFactory(value:Function):void
		{
			if(this._lastItemRendererFactory === value)
			{
				return;
			}

			this._lastItemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _lastItemRendererName:String;

		public function get lastItemRendererName():String
		{
			return this._lastItemRendererName;
		}

		public function set lastItemRendererName(value:String):void
		{
			if(this._lastItemRendererName == value)
			{
				return;
			}
			this._lastItemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _singleItemRendererType:Class;

		public function get singleItemRendererType():Class
		{
			return this._singleItemRendererType;
		}

		public function set singleItemRendererType(value:Class):void
		{
			if(this._singleItemRendererType == value)
			{
				return;
			}

			this._singleItemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _singleItemRendererFactory:Function;

		public function get singleItemRendererFactory():Function
		{
			return this._singleItemRendererFactory;
		}

		public function set singleItemRendererFactory(value:Function):void
		{
			if(this._singleItemRendererFactory === value)
			{
				return;
			}

			this._singleItemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _singleItemRendererName:String;

		public function get singleItemRendererName():String
		{
			return this._singleItemRendererName;
		}

		public function set singleItemRendererName(value:String):void
		{
			if(this._singleItemRendererName == value)
			{
				return;
			}
			this._singleItemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _headerRendererType:Class;

		public function get headerRendererType():Class
		{
			return this._headerRendererType;
		}

		public function set headerRendererType(value:Class):void
		{
			if(this._headerRendererType == value)
			{
				return;
			}

			this._headerRendererType = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _headerRendererFactory:Function;

		public function get headerRendererFactory():Function
		{
			return this._headerRendererFactory;
		}

		public function set headerRendererFactory(value:Function):void
		{
			if(this._headerRendererFactory === value)
			{
				return;
			}

			this._headerRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _headerRendererName:String;

		public function get headerRendererName():String
		{
			return this._headerRendererName;
		}

		public function set headerRendererName(value:String):void
		{
			if(this._headerRendererName == value)
			{
				return;
			}
			this._headerRendererName = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _headerRendererProperties:PropertyProxy;

		public function get headerRendererProperties():PropertyProxy
		{
			return this._headerRendererProperties;
		}

		public function set headerRendererProperties(value:PropertyProxy):void
		{
			if(this._headerRendererProperties == value)
			{
				return;
			}
			if(this._headerRendererProperties)
			{
				this._headerRendererProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._headerRendererProperties = PropertyProxy(value);
			if(this._headerRendererProperties)
			{
				this._headerRendererProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _footerRendererType:Class;

		public function get footerRendererType():Class
		{
			return this._footerRendererType;
		}

		public function set footerRendererType(value:Class):void
		{
			if(this._footerRendererType == value)
			{
				return;
			}

			this._footerRendererType = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _footerRendererFactory:Function;

		public function get footerRendererFactory():Function
		{
			return this._footerRendererFactory;
		}

		public function set footerRendererFactory(value:Function):void
		{
			if(this._footerRendererFactory === value)
			{
				return;
			}

			this._footerRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _footerRendererName:String;

		public function get footerRendererName():String
		{
			return this._footerRendererName;
		}

		public function set footerRendererName(value:String):void
		{
			if(this._footerRendererName == value)
			{
				return;
			}
			this._footerRendererName = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _footerRendererProperties:PropertyProxy;

		public function get footerRendererProperties():PropertyProxy
		{
			return this._footerRendererProperties;
		}

		public function set footerRendererProperties(value:PropertyProxy):void
		{
			if(this._footerRendererProperties == value)
			{
				return;
			}
			if(this._footerRendererProperties)
			{
				this._footerRendererProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._footerRendererProperties = PropertyProxy(value);
			if(this._footerRendererProperties)
			{
				this._footerRendererProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _ignoreLayoutChanges:Boolean = false;
		private var _ignoreRendererResizing:Boolean = false;

		private var _layout:ILayout;

		public function get layout():ILayout
		{
			return this._layout;
		}

		public function set layout(value:ILayout):void
		{
			if(this._layout == value)
			{
				return;
			}
			if(this._layout)
			{
				this._layout.removeEventListener(Event.CHANGE, layout_changeHandler);
			}
			this._layout = value;
			if(this._layout)
			{
				if(this._layout is IVariableVirtualLayout)
				{
					const variableVirtualLayout:IVariableVirtualLayout = IVariableVirtualLayout(this._layout)
					variableVirtualLayout.hasVariableItemDimensions = true;
					variableVirtualLayout.resetVariableVirtualCache();
				}
				this._layout.addEventListener(Event.CHANGE, layout_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		private var _horizontalScrollPosition:Number = 0;

		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		private var _verticalScrollPosition:Number = 0;

		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		private var _minimumItemCount:int;
		private var _minimumHeaderCount:int;
		private var _minimumFooterCount:int;
		private var _minimumFirstAndLastItemCount:int;
		private var _minimumSingleItemCount:int;

		private var _ignoreSelectionChanges:Boolean = false;

		public function setSelectedLocation(groupIndex:int, itemIndex:int):void
		{
			if(this._selectedGroupIndex == groupIndex && this._selectedItemIndex == itemIndex)
			{
				return;
			}
			if((groupIndex < 0 && itemIndex >= 0) || (groupIndex >= 0 && itemIndex < 0))
			{
				throw new ArgumentError("To deselect items, group index and item index must both be < 0.");
			}
			this._selectedGroupIndex = groupIndex;
			this._selectedItemIndex = itemIndex;

			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		public function getScrollPositionForIndex(groupIndex:int, itemIndex:int, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			const displayIndex:int = this.locationToDisplayIndex(groupIndex, itemIndex);
			return this._layout.getScrollPositionForIndex(displayIndex, this._layoutItems, 0, 0, this.actualVisibleWidth, this.actualVisibleHeight, result);
		}

		override public function dispose():void
		{
			this.owner = null;
			this.dataProvider = null;
			this.layout = null;
			super.dispose();
		}

		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const itemRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);

			var oldIgnoreRendererResizing:Boolean = this._ignoreRendererResizing;
			this._ignoreRendererResizing = true;
			var oldIgnoreLayoutChanges:Boolean = this._ignoreLayoutChanges;
			this._ignoreLayoutChanges = true;
			var oldIgnoreSelectionChanges:Boolean = this._ignoreSelectionChanges;
			this._ignoreSelectionChanges = true;

			if(scrollInvalid || sizeInvalid)
			{
				this.refreshViewPortBounds();
			}
			if(scrollInvalid || sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshInactiveRenderers(itemRendererInvalid);
			}
			if(stylesInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshLayoutTypicalItem();
			}
			if(scrollInvalid || sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshRenderers();
			}
			if(scrollInvalid || stylesInvalid || sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshHeaderRendererStyles();
				this.refreshFooterRendererStyles();
				this.refreshItemRendererStyles();
			}
			if(scrollInvalid || selectionInvalid || sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshSelection();
			}

			if(scrollInvalid || stateInvalid || sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshEnabled();
			}

			this._ignoreLayoutChanges = oldIgnoreLayoutChanges;
			this._ignoreSelectionChanges = oldIgnoreSelectionChanges;

			this._layout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);

			this._ignoreRendererResizing = oldIgnoreRendererResizing;

			this._contentX = this._layoutResult.contentX;
			this._contentY = this._layoutResult.contentY;
			this.setSizeInternal(this._layoutResult.contentWidth, this._layoutResult.contentHeight, false);
			this.actualVisibleWidth = this._layoutResult.viewPortWidth;
			this.actualVisibleHeight = this._layoutResult.viewPortHeight;

			//final validation to avoid juggler next frame issues
			this.validateRenderers();
		}

		private function validateRenderers():void
		{
			var rendererCount:int = this._activeFirstItemRenderers ? this._activeFirstItemRenderers.length : 0;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var renderer:IGroupedListItemRenderer = this._activeFirstItemRenderers[i];
				renderer.validate();
			}
			rendererCount = this._activeLastItemRenderers ? this._activeLastItemRenderers.length : 0;
			for(i = 0; i < rendererCount; i++)
			{
				renderer = this._activeLastItemRenderers[i];
				renderer.validate();
			}
			rendererCount = this._activeSingleItemRenderers ? this._activeSingleItemRenderers.length : 0;
			for(i = 0; i < rendererCount; i++)
			{
				renderer = this._activeSingleItemRenderers[i];
				renderer.validate();
			}
			rendererCount = this._activeItemRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				renderer = this._activeItemRenderers[i];
				renderer.validate();
			}
			rendererCount = this._activeHeaderRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer = this._activeHeaderRenderers[i];
				headerOrFooterRenderer.validate();
			}
			rendererCount = this._activeFooterRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				headerOrFooterRenderer = this._activeFooterRenderers[i];
				headerOrFooterRenderer.validate();
			}
		}

		private function refreshEnabled():void
		{
			var rendererCount:int = this._activeItemRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var renderer:DisplayObject = DisplayObject(this._activeItemRenderers[i]);
				if(renderer is FeathersControl)
				{
					FeathersControl(renderer).isEnabled = this._isEnabled;
				}
			}
			if(this._activeFirstItemRenderers)
			{
				rendererCount = this._activeFirstItemRenderers.length;
				for(i = 0; i < rendererCount; i++)
				{
					renderer = DisplayObject(this._activeFirstItemRenderers[i]);
					if(renderer is FeathersControl)
					{
						FeathersControl(renderer).isEnabled = this._isEnabled;
					}
				}
			}
			if(this._activeLastItemRenderers)
			{
				rendererCount = this._activeLastItemRenderers.length;
				for(i = 0; i < rendererCount; i++)
				{
					renderer = DisplayObject(this._activeLastItemRenderers[i]);
					if(renderer is FeathersControl)
					{
						FeathersControl(renderer).isEnabled = this._isEnabled;
					}
				}
			}
			if(this._activeSingleItemRenderers)
			{
				rendererCount = this._activeSingleItemRenderers.length;
				for(i = 0; i < rendererCount; i++)
				{
					renderer = DisplayObject(this._activeSingleItemRenderers[i]);
					if(renderer is FeathersControl)
					{
						FeathersControl(renderer).isEnabled = this._isEnabled;
					}
				}
			}
			rendererCount = this._activeHeaderRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				renderer = DisplayObject(this._activeHeaderRenderers[i]);
				if(renderer is FeathersControl)
				{
					FeathersControl(renderer).isEnabled = this._isEnabled;
				}
			}
			rendererCount = this._activeFooterRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				renderer = DisplayObject(this._activeFooterRenderers[i]);
				if(renderer is FeathersControl)
				{
					FeathersControl(renderer).isEnabled = this._isEnabled;
				}
			}
		}

		private function invalidateParent(flag:String = INVALIDATION_FLAG_ALL):void
		{
			Scroller(this.parent).invalidate(flag);
		}

		private function refreshLayoutTypicalItem():void
		{
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			if(!virtualLayout || !virtualLayout.useVirtualLayout)
			{
				if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
				{
					//the old layout was virtual, but this one isn't
					this.destroyItemRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
				}
				return;
			}

			const hasCustomFirstItemRenderer:Boolean = this._firstItemRendererType || this._firstItemRendererFactory != null || this._firstItemRendererName;
			const hasCustomSingleItemRenderer:Boolean = this._singleItemRendererType || this._singleItemRendererFactory != null || this._singleItemRendererName;

			var newTypicalItemIsInDataProvider:Boolean = false;
			var typicalItem:Object = this._typicalItem;
			var groupCount:int = 0;
			var firstGroupLength:int = 0;
			var typicalItemGroupIndex:int = 0;
			var typicalItemItemIndex:int = 0;
			if(this._dataProvider)
			{
				if(!typicalItem)
				{
					groupCount = this._dataProvider.getLength();
					if(groupCount > 0)
					{
						firstGroupLength = this._dataProvider.getLength(0);
						if(firstGroupLength > 0)
						{
							newTypicalItemIsInDataProvider = true;
							typicalItem = this._dataProvider.getItemAt(0, 0);
						}
					}
				}
				else if(typicalItem)
				{
					this._dataProvider.getItemLocation(typicalItem, HELPER_VECTOR);
					if(HELPER_VECTOR.length > 1)
					{
						newTypicalItemIsInDataProvider = true;
						typicalItemGroupIndex = HELPER_VECTOR[0];
						typicalItemItemIndex = HELPER_VECTOR[1];
					}
				}
			}
			if(!typicalItem)
			{
				virtualLayout.typicalItem = null;
				return;
			}

			var isFirst:Boolean = false;
			var isSingle:Boolean = false;
			var typicalItemRenderer:IGroupedListItemRenderer;
			if(hasCustomSingleItemRenderer && firstGroupLength == 1)
			{
				if(this._singleItemRendererMap)
				{
					typicalItemRenderer = this._singleItemRendererMap[typicalItem];
				}
				isSingle = true;
			}
			else if(hasCustomFirstItemRenderer && firstGroupLength > 1)
			{
				if(this._firstItemRendererMap)
				{
					typicalItemRenderer = this._firstItemRendererMap[typicalItem];
				}
				isFirst = true;
			}
			else
			{
				typicalItemRenderer = this._itemRendererMap[typicalItem];
			}
			if(!typicalItemRenderer && !newTypicalItemIsInDataProvider && this._typicalItemRenderer)
			{
				//can use reuse the old item renderer instance
				typicalItemRenderer = this._typicalItemRenderer;
				typicalItemRenderer.data = typicalItem;
				typicalItemRenderer.groupIndex = typicalItemGroupIndex;
				typicalItemRenderer.itemIndex = typicalItemItemIndex;
			}
			if(!typicalItemRenderer)
			{
				if(isFirst)
				{
					var activeRenderers:Vector.<IGroupedListItemRenderer> = this._activeFirstItemRenderers;
					var inactiveRenderers:Vector.<IGroupedListItemRenderer> = this._inactiveFirstItemRenderers;
					var type:Class = this._firstItemRendererType ? this._firstItemRendererType : this._itemRendererType;
					var factory:Function = this._firstItemRendererFactory != null ? this._firstItemRendererFactory : this._itemRendererFactory;
					var name:String = this._firstItemRendererName ? this._firstItemRendererName : this._itemRendererName;
					typicalItemRenderer = this.createItemRenderer(inactiveRenderers,
						activeRenderers, this._firstItemRendererMap, type, factory,
						name, typicalItem, 0, 0, 0, false, !newTypicalItemIsInDataProvider);
				}
				else if(isSingle)
				{
					activeRenderers = this._activeSingleItemRenderers;
					inactiveRenderers = this._inactiveSingleItemRenderers;
					type = this._singleItemRendererType ? this._singleItemRendererType : this._itemRendererType;
					factory = this._singleItemRendererFactory != null ? this._singleItemRendererFactory : this._itemRendererFactory;
					name = this._singleItemRendererName ? this._singleItemRendererName : this._itemRendererName;
					typicalItemRenderer = this.createItemRenderer(inactiveRenderers,
						activeRenderers, this._singleItemRendererMap, type, factory,
						name, typicalItem, 0, 0, 0, false, !newTypicalItemIsInDataProvider);
				}
				else
				{
					activeRenderers = this._activeItemRenderers;
					inactiveRenderers = this._inactiveItemRenderers;
					typicalItemRenderer = this.createItemRenderer(inactiveRenderers,
						activeRenderers, this._itemRendererMap, this._itemRendererType, this._itemRendererFactory,
						this._itemRendererName, typicalItem, 0, 0, 0, false, !newTypicalItemIsInDataProvider);
				}
				//can't be in a last item renderer

				if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
				{
					//get rid of the old one if it isn't needed anymore
					this.destroyItemRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
				}
			}

			this.refreshOneItemRendererStyles(typicalItemRenderer);
			virtualLayout.typicalItem = DisplayObject(typicalItemRenderer);
			this._typicalItemRenderer = typicalItemRenderer;
			this._typicalItemIsInDataProvider = newTypicalItemIsInDataProvider;
		}

		private function refreshItemRendererStyles():void
		{
			for each(var renderer:IGroupedListItemRenderer in this._activeItemRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
			for each(renderer in this._activeFirstItemRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
			for each(renderer in this._activeLastItemRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
			for each(renderer in this._activeSingleItemRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
		}

		private function refreshHeaderRendererStyles():void
		{
			for each(var renderer:IGroupedListHeaderOrFooterRenderer in this._activeHeaderRenderers)
			{
				this.refreshOneHeaderRendererStyles(renderer);
			}
		}

		private function refreshFooterRendererStyles():void
		{
			for each(var renderer:IGroupedListHeaderOrFooterRenderer in this._activeFooterRenderers)
			{
				this.refreshOneFooterRendererStyles(renderer);
			}
		}

		private function refreshOneItemRendererStyles(renderer:IGroupedListItemRenderer):void
		{
			const displayRenderer:DisplayObject = DisplayObject(renderer);
			for(var propertyName:String in this._itemRendererProperties)
			{
				if(displayRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._itemRendererProperties[propertyName];
					displayRenderer[propertyName] = propertyValue;
				}
			}
		}

		private function refreshOneHeaderRendererStyles(renderer:IGroupedListHeaderOrFooterRenderer):void
		{
			const displayRenderer:DisplayObject = DisplayObject(renderer);
			for(var propertyName:String in this._headerRendererProperties)
			{
				if(displayRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._headerRendererProperties[propertyName];
					displayRenderer[propertyName] = propertyValue;
				}
			}
		}

		private function refreshOneFooterRendererStyles(renderer:IGroupedListHeaderOrFooterRenderer):void
		{
			const displayRenderer:DisplayObject = DisplayObject(renderer);
			for(var propertyName:String in this._footerRendererProperties)
			{
				if(displayRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._footerRendererProperties[propertyName];
					displayRenderer[propertyName] = propertyValue;
				}
			}
		}

		private function refreshSelection():void
		{
			for each(var renderer:IGroupedListItemRenderer in this._activeItemRenderers)
			{
				renderer.isSelected = renderer.groupIndex == this._selectedGroupIndex &&
					renderer.itemIndex == this._selectedItemIndex;
			}
			for each(renderer in this._activeFirstItemRenderers)
			{
				renderer.isSelected = renderer.groupIndex == this._selectedGroupIndex &&
					renderer.itemIndex == this._selectedItemIndex;
			}
			for each(renderer in this._activeLastItemRenderers)
			{
				renderer.isSelected = renderer.groupIndex == this._selectedGroupIndex &&
					renderer.itemIndex == this._selectedItemIndex;
			}
			for each(renderer in this._activeSingleItemRenderers)
			{
				renderer.isSelected = renderer.groupIndex == this._selectedGroupIndex &&
					renderer.itemIndex == this._selectedItemIndex;
			}
		}

		private function refreshViewPortBounds():void
		{
			this._viewPortBounds.x = this._viewPortBounds.y = 0;
			this._viewPortBounds.scrollX = this._horizontalScrollPosition;
			this._viewPortBounds.scrollY = this._verticalScrollPosition;
			this._viewPortBounds.explicitWidth = this.explicitVisibleWidth;
			this._viewPortBounds.explicitHeight = this.explicitVisibleHeight;
			this._viewPortBounds.minWidth = this._minVisibleWidth;
			this._viewPortBounds.minHeight = this._minVisibleHeight;
			this._viewPortBounds.maxWidth = this._maxVisibleWidth;
			this._viewPortBounds.maxHeight = this._maxVisibleHeight;
		}

		private function refreshInactiveRenderers(itemRendererTypeIsInvalid:Boolean):void
		{
			var temp:Vector.<IGroupedListItemRenderer> = this._inactiveItemRenderers;
			this._inactiveItemRenderers = this._activeItemRenderers;
			this._activeItemRenderers = temp;
			this._activeItemRenderers.length = 0;
			if(this._inactiveFirstItemRenderers)
			{
				temp = this._inactiveFirstItemRenderers;
				this._inactiveFirstItemRenderers = this._activeFirstItemRenderers;
				this._activeFirstItemRenderers = temp;
				this._activeFirstItemRenderers.length = 0;
			}
			if(this._inactiveLastItemRenderers)
			{
				temp = this._inactiveLastItemRenderers;
				this._inactiveLastItemRenderers = this._activeLastItemRenderers;
				this._activeLastItemRenderers = temp;
				this._activeLastItemRenderers.length = 0;
			}
			if(this._inactiveSingleItemRenderers)
			{
				temp = this._inactiveSingleItemRenderers;
				this._inactiveSingleItemRenderers = this._activeSingleItemRenderers;
				this._activeSingleItemRenderers = temp;
				this._activeSingleItemRenderers.length = 0;
			}
			var temp2:Vector.<IGroupedListHeaderOrFooterRenderer> = this._inactiveHeaderRenderers;
			this._inactiveHeaderRenderers = this._activeHeaderRenderers;
			this._activeHeaderRenderers = temp2;
			this._activeHeaderRenderers.length = 0;
			temp2 = this._inactiveFooterRenderers;
			this._inactiveFooterRenderers = this._activeFooterRenderers;
			this._activeFooterRenderers = temp2;
			this._activeFooterRenderers.length = 0;
			if(itemRendererTypeIsInvalid)
			{
				this.recoverInactiveRenderers();
				this.freeInactiveRenderers();
				if(this._typicalItemRenderer)
				{
					if(this._typicalItemIsInDataProvider)
					{
						delete this._itemRendererMap[this._typicalItemRenderer.data];
						delete this._firstItemRendererMap[this._typicalItemRenderer.data];
						delete this._singleItemRendererMap[this._typicalItemRenderer.data];
						//can't be in last item renderers
					}
					this.destroyItemRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
					this._typicalItemIsInDataProvider = false;
				}
			}

			this._headerIndices.length = 0;
			this._footerIndices.length = 0;
		}

		private function refreshRenderers():void
		{
			if(this._typicalItemRenderer && this._typicalItemIsInDataProvider)
			{
				//this renderer is special and doesn't need to appear in the
				//inactive renderers cache. in fact, if it did, it could be
				//reused for other data, which we definitely don't want!

				var inactiveIndex:int = this._inactiveItemRenderers.indexOf(this._typicalItemRenderer);
				if(inactiveIndex >= 0)
				{
					this._inactiveItemRenderers.splice(inactiveIndex, 1);
				}
				else
				{
					if(this._inactiveSingleItemRenderers)
					{
						inactiveIndex = this._inactiveSingleItemRenderers.indexOf(this._typicalItemRenderer);
					}
					else
					{
						inactiveIndex = -1;
					}
					if(inactiveIndex >= 0)
					{
						this._inactiveSingleItemRenderers.splice(inactiveIndex, 1);
					}
					else
					{
						if(this._inactiveFirstItemRenderers)
						{
							inactiveIndex = this._inactiveFirstItemRenderers.indexOf(this._typicalItemRenderer);
						}
						else
						{
							inactiveIndex = -1;
						}
						if(inactiveIndex >= 0)
						{
							this._inactiveFirstItemRenderers.splice(inactiveIndex, 1);
						}
						//no else... can't be in inactive last item renderers
					}
				}
			}

			this.findUnrenderedData();
			this.recoverInactiveRenderers();
			this.renderUnrenderedData();
			this.freeInactiveRenderers();
		}

		private function findUnrenderedData():void
		{
			const hasCustomFirstItemRenderer:Boolean = this._firstItemRendererType || this._firstItemRendererFactory != null || this._firstItemRendererName;
			const hasCustomLastItemRenderer:Boolean = this._lastItemRendererType || this._lastItemRendererFactory != null || this._lastItemRendererName;
			const hasCustomSingleItemRenderer:Boolean = this._singleItemRendererType || this._singleItemRendererFactory != null || this._singleItemRendererName;

			if(hasCustomFirstItemRenderer)
			{
				if(!this._firstItemRendererMap)
				{
					this._firstItemRendererMap = new Dictionary(true);
				}
				if(!this._inactiveFirstItemRenderers)
				{
					this._inactiveFirstItemRenderers = new <IGroupedListItemRenderer>[];
				}
				if(!this._activeFirstItemRenderers)
				{
					this._activeFirstItemRenderers = new <IGroupedListItemRenderer>[];
				}
				if(!this._unrenderedFirstItems)
				{
					this._unrenderedFirstItems = new <int>[];
				}
			}
			else
			{
				this._firstItemRendererMap = null;
				this._inactiveFirstItemRenderers = null;
				this._activeFirstItemRenderers = null;
				this._unrenderedFirstItems = null;
			}
			if(hasCustomLastItemRenderer)
			{
				if(!this._lastItemRendererMap)
				{
					this._lastItemRendererMap = new Dictionary(true);
				}
				if(!this._inactiveLastItemRenderers)
				{
					this._inactiveLastItemRenderers = new <IGroupedListItemRenderer>[];
				}
				if(!this._activeLastItemRenderers)
				{
					this._activeLastItemRenderers = new <IGroupedListItemRenderer>[];
				}
				if(!this._unrenderedLastItems)
				{
					this._unrenderedLastItems = new <int>[];
				}
			}
			else
			{
				this._lastItemRendererMap = null;
				this._inactiveLastItemRenderers = null;
				this._activeLastItemRenderers = null;
				this._unrenderedLastItems = null;
			}
			if(hasCustomSingleItemRenderer)
			{
				if(!this._singleItemRendererMap)
				{
					this._singleItemRendererMap = new Dictionary(true);
				}
				if(!this._inactiveSingleItemRenderers)
				{
					this._inactiveSingleItemRenderers = new <IGroupedListItemRenderer>[];
				}
				if(!this._activeSingleItemRenderers)
				{
					this._activeSingleItemRenderers = new <IGroupedListItemRenderer>[];
				}
				if(!this._unrenderedSingleItems)
				{
					this._unrenderedSingleItems = new <int>[];
				}
			}
			else
			{
				this._singleItemRendererMap = null;
				this._inactiveSingleItemRenderers = null;
				this._activeSingleItemRenderers = null;
				this._unrenderedSingleItems = null;
			}

			const groupCount:int = this._dataProvider ? this._dataProvider.getLength() : 0;
			var totalLayoutCount:int = 0;
			var totalHeaderCount:int = 0;
			var totalFooterCount:int = 0;
			var totalSingleItemCount:int = 0;
			var averageItemsPerGroup:int = 0;
			for(var i:int = 0; i < groupCount; i++)
			{
				var group:Object = this._dataProvider.getItemAt(i);
				if(this._owner.groupToHeaderData(group) !== null)
				{
					this._headerIndices.push(totalLayoutCount);
					totalLayoutCount++;
					totalHeaderCount++;
				}
				var currentItemCount:int = this._dataProvider.getLength(i);
				totalLayoutCount += currentItemCount;
				averageItemsPerGroup += currentItemCount;
				if(currentItemCount == 0)
				{
					totalSingleItemCount++;
				}
				if(this._owner.groupToFooterData(group) !== null)
				{
					this._footerIndices.push(totalLayoutCount);
					totalLayoutCount++;
					totalFooterCount++;
				}
			}
			this._layoutItems.length = totalLayoutCount;
			const virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			const useVirtualLayout:Boolean = virtualLayout && virtualLayout.useVirtualLayout;
			if(useVirtualLayout)
			{
				virtualLayout.measureViewPort(totalLayoutCount, this._viewPortBounds, HELPER_POINT);
				var viewPortWidth:Number = HELPER_POINT.x;
				var viewPortHeight:Number = HELPER_POINT.y;
				virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, viewPortWidth, viewPortHeight, totalLayoutCount, HELPER_VECTOR);

				averageItemsPerGroup /= groupCount;

				var typicalItemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(virtualLayout.typicalItem);
				var minimumTypicalItemEdge:Number = typicalItemRenderer.height;
				if(typicalItemRenderer.width < minimumTypicalItemEdge)
				{
					minimumTypicalItemEdge = typicalItemRenderer.width;
				}

				var maximumViewPortEdge:Number = viewPortWidth;
				if(viewPortHeight > viewPortWidth)
				{
					maximumViewPortEdge = viewPortHeight;
				}
				this._minimumFirstAndLastItemCount = this._minimumSingleItemCount = this._minimumHeaderCount = this._minimumFooterCount = Math.ceil(maximumViewPortEdge / (minimumTypicalItemEdge * averageItemsPerGroup));
				this._minimumHeaderCount = Math.min(this._minimumHeaderCount, totalHeaderCount);
				this._minimumFooterCount = Math.min(this._minimumFooterCount, totalFooterCount);
				this._minimumSingleItemCount = Math.min(this._minimumSingleItemCount, totalSingleItemCount);

				//assumes that zero headers/footers might be visible
				this._minimumItemCount = Math.ceil(maximumViewPortEdge / minimumTypicalItemEdge) + 1;
			}
			var currentIndex:int = 0;
			var unrenderedHeadersLastIndex:int = this._unrenderedHeaders.length;
			var unrenderedFootersLastIndex:int = this._unrenderedFooters.length;
			for(i = 0; i < groupCount; i++)
			{
				group = this._dataProvider.getItemAt(i);
				var header:Object = this._owner.groupToHeaderData(group);
				if(header !== null)
				{
					//the end index is included in the visible items
					if(useVirtualLayout && HELPER_VECTOR.indexOf(currentIndex) < 0)
					{
						this._layoutItems[currentIndex] = null;
					}
					else
					{
						var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer = IGroupedListHeaderOrFooterRenderer(this._headerRendererMap[header]);
						if(headerOrFooterRenderer)
						{
							headerOrFooterRenderer.layoutIndex = currentIndex;
							headerOrFooterRenderer.groupIndex = i;
							this._activeHeaderRenderers.push(headerOrFooterRenderer);
							this._inactiveHeaderRenderers.splice(this._inactiveHeaderRenderers.indexOf(headerOrFooterRenderer), 1);
							headerOrFooterRenderer.visible = true;
							this._layoutItems[currentIndex] = DisplayObject(headerOrFooterRenderer);
						}
						else
						{
							this._unrenderedHeaders[unrenderedHeadersLastIndex] = i;
							unrenderedHeadersLastIndex++;
							this._unrenderedHeaders[unrenderedHeadersLastIndex] = currentIndex;
							unrenderedHeadersLastIndex++;
						}
					}
					currentIndex++;
				}
				currentItemCount = this._dataProvider.getLength(i);
				var currentGroupLastIndex:int = currentItemCount - 1;
				for(var j:int = 0; j < currentItemCount; j++)
				{
					if(useVirtualLayout && HELPER_VECTOR.indexOf(currentIndex) < 0)
					{
						this._layoutItems[currentIndex] = null;
					}
					else
					{
						var item:Object = this._dataProvider.getItemAt(i, j);
						if(hasCustomSingleItemRenderer && j == 0 && j == currentGroupLastIndex)
						{
							this.findRendererForItem(item, i, j, currentIndex, this._singleItemRendererMap, this._inactiveSingleItemRenderers,
								this._activeSingleItemRenderers, this._unrenderedSingleItems);
						}
						else if(hasCustomFirstItemRenderer && j == 0)
						{
							this.findRendererForItem(item, i, j, currentIndex, this._firstItemRendererMap, this._inactiveFirstItemRenderers,
								this._activeFirstItemRenderers, this._unrenderedFirstItems);
						}
						else if(hasCustomLastItemRenderer && j == currentGroupLastIndex)
						{
							this.findRendererForItem(item, i, j, currentIndex, this._lastItemRendererMap, this._inactiveLastItemRenderers,
								this._activeLastItemRenderers, this._unrenderedLastItems);
						}
						else
						{
							this.findRendererForItem(item, i, j, currentIndex, this._itemRendererMap, this._inactiveItemRenderers,
								this._activeItemRenderers, this._unrenderedItems);
						}
					}
					currentIndex++;
				}
				var footer:Object = this._owner.groupToFooterData(group);
				if(footer !== null)
				{
					if(useVirtualLayout && HELPER_VECTOR.indexOf(currentIndex) < 0)
					{
						this._layoutItems[currentIndex] = null;
					}
					else
					{
						headerOrFooterRenderer = IGroupedListHeaderOrFooterRenderer(this._footerRendererMap[footer]);
						if(headerOrFooterRenderer)
						{
							headerOrFooterRenderer.groupIndex = i;
							headerOrFooterRenderer.layoutIndex = currentIndex;
							this._activeFooterRenderers.push(headerOrFooterRenderer);
							this._inactiveFooterRenderers.splice(this._inactiveFooterRenderers.indexOf(headerOrFooterRenderer), 1);
							headerOrFooterRenderer.visible = true;
							this._layoutItems[currentIndex] = DisplayObject(headerOrFooterRenderer);
						}
						else
						{
							this._unrenderedFooters[unrenderedFootersLastIndex] = i;
							unrenderedFootersLastIndex++;
							this._unrenderedFooters[unrenderedFootersLastIndex] = currentIndex;
							unrenderedFootersLastIndex++;
						}
					}
					currentIndex++;
				}
			}
			//update the typical item renderer's visibility
			if(this._typicalItemRenderer)
			{
				if(useVirtualLayout && this._typicalItemIsInDataProvider)
				{
					var index:int = HELPER_VECTOR.indexOf(this._typicalItemRenderer.layoutIndex);
					if(index >= 0)
					{
						this._typicalItemRenderer.visible = true;
					}
					else
					{
						this._typicalItemRenderer.visible = false;

						//uncomment these lines to see a hidden typical item for
						//debugging purposes...
						/*this._typicalItemRenderer.visible = true;
						this._typicalItemRenderer.x = this._horizontalScrollPosition;
						this._typicalItemRenderer.y = this._verticalScrollPosition;*/
					}
				}
				else
				{
					this._typicalItemRenderer.visible = this._typicalItemIsInDataProvider;
				}
			}
			HELPER_VECTOR.length = 0;
		}

		private function findRendererForItem(item:Object, groupIndex:int, itemIndex:int, layoutIndex:int,
			rendererMap:Dictionary, inactiveRenderers:Vector.<IGroupedListItemRenderer>,
			activeRenderers:Vector.<IGroupedListItemRenderer>, unrenderedItems:Vector.<int>):void
		{
			var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(rendererMap[item]);
			if(itemRenderer)
			{
				itemRenderer.groupIndex = groupIndex;
				itemRenderer.itemIndex = itemIndex;
				itemRenderer.layoutIndex = layoutIndex;
				activeRenderers.push(itemRenderer);
				var inactiveIndex:int = inactiveRenderers.indexOf(itemRenderer);
				if(inactiveIndex >= 0)
				{
					inactiveRenderers.splice(inactiveIndex, 1);
				}
				else if(itemRenderer != this._typicalItemRenderer)
				{
					//the typicalItemRenderer may not be in the inactiveRenderers
					throw new IllegalOperationError("This List is in an unrecoverable state.");
				}
				itemRenderer.visible = true;
				this._layoutItems[layoutIndex] = DisplayObject(itemRenderer);
			}
			else
			{
				unrenderedItems.push(groupIndex);
				unrenderedItems.push(itemIndex);
				unrenderedItems.push(layoutIndex);
			}
		}

		private function renderUnrenderedData():void
		{
			var rendererCount:int = this._unrenderedItems.length;
			for(var i:int = 0; i < rendererCount; i += 3)
			{
				var groupIndex:int = this._unrenderedItems.shift();
				var itemIndex:int = this._unrenderedItems.shift();
				var layoutIndex:int = this._unrenderedItems.shift();
				var item:Object = this._dataProvider.getItemAt(groupIndex, itemIndex);
				var itemRenderer:IGroupedListItemRenderer = this.createItemRenderer(this._inactiveItemRenderers,
					this._activeItemRenderers, this._itemRendererMap, this._itemRendererType, this._itemRendererFactory,
					this._itemRendererName, item, groupIndex, itemIndex, layoutIndex, true, false);
				this._layoutItems[layoutIndex] = DisplayObject(itemRenderer);
			}

			if(this._unrenderedFirstItems)
			{
				rendererCount = this._unrenderedFirstItems.length;
				for(i = 0; i < rendererCount; i += 3)
				{
					groupIndex = this._unrenderedFirstItems.shift();
					itemIndex = this._unrenderedFirstItems.shift();
					layoutIndex = this._unrenderedFirstItems.shift();
					item = this._dataProvider.getItemAt(groupIndex, itemIndex);
					var type:Class = this._firstItemRendererType ? this._firstItemRendererType : this._itemRendererType;
					var factory:Function = this._firstItemRendererFactory != null ? this._firstItemRendererFactory : this._itemRendererFactory;
					var name:String = this._firstItemRendererName ? this._firstItemRendererName : this._itemRendererName;
					itemRenderer = this.createItemRenderer(this._inactiveFirstItemRenderers, this._activeFirstItemRenderers,
						this._firstItemRendererMap, type, factory, name, item, groupIndex, itemIndex, layoutIndex, true, false);
					this._layoutItems[layoutIndex] = DisplayObject(itemRenderer);
				}
			}

			if(this._unrenderedLastItems)
			{
				rendererCount = this._unrenderedLastItems.length;
				for(i = 0; i < rendererCount; i += 3)
				{
					groupIndex = this._unrenderedLastItems.shift();
					itemIndex = this._unrenderedLastItems.shift();
					layoutIndex = this._unrenderedLastItems.shift();
					item = this._dataProvider.getItemAt(groupIndex, itemIndex);
					type = this._lastItemRendererType ? this._lastItemRendererType : this._itemRendererType;
					factory = this._lastItemRendererFactory != null ? this._lastItemRendererFactory : this._itemRendererFactory;
					name = this._lastItemRendererName ? this._lastItemRendererName : this._itemRendererName;
					itemRenderer = this.createItemRenderer(this._inactiveLastItemRenderers, this._activeLastItemRenderers,
						this._lastItemRendererMap, type,  factory,  name, item, groupIndex, itemIndex, layoutIndex, true, false);
					this._layoutItems[layoutIndex] = DisplayObject(itemRenderer);
				}
			}

			if(this._unrenderedSingleItems)
			{
				rendererCount = this._unrenderedSingleItems.length;
				for(i = 0; i < rendererCount; i += 3)
				{
					groupIndex = this._unrenderedSingleItems.shift();
					itemIndex = this._unrenderedSingleItems.shift();
					layoutIndex = this._unrenderedSingleItems.shift();
					item = this._dataProvider.getItemAt(groupIndex, itemIndex);
					type = this._singleItemRendererType ? this._singleItemRendererType : this._itemRendererType;
					factory = this._singleItemRendererFactory != null ? this._singleItemRendererFactory : this._itemRendererFactory;
					name = this._singleItemRendererName ? this._singleItemRendererName : this._itemRendererName;
					itemRenderer = this.createItemRenderer(this._inactiveSingleItemRenderers, this._activeSingleItemRenderers,
						this._singleItemRendererMap, type,  factory,  name, item, groupIndex, itemIndex, layoutIndex, true, false);
					this._layoutItems[layoutIndex] = DisplayObject(itemRenderer);
				}
			}

			rendererCount = this._unrenderedHeaders.length;
			for(i = 0; i < rendererCount; i += 2)
			{
				groupIndex = this._unrenderedHeaders.shift();
				layoutIndex = this._unrenderedHeaders.shift();
				item = this._dataProvider.getItemAt(groupIndex);
				item = this._owner.groupToHeaderData(item);
				var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer = this.createHeaderRenderer(item, groupIndex, layoutIndex, false);
				this._layoutItems[layoutIndex] = DisplayObject(headerOrFooterRenderer);
			}

			rendererCount = this._unrenderedFooters.length;
			for(i = 0; i < rendererCount; i += 2)
			{
				groupIndex = this._unrenderedFooters.shift();
				layoutIndex = this._unrenderedFooters.shift();
				item = this._dataProvider.getItemAt(groupIndex);
				item = this._owner.groupToFooterData(item);
				headerOrFooterRenderer = this.createFooterRenderer(item, groupIndex, layoutIndex, false);
				this._layoutItems[layoutIndex] = DisplayObject(headerOrFooterRenderer);
			}
		}

		private function recoverInactiveRenderers():void
		{
			var rendererCount:int = this._inactiveItemRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var itemRenderer:IGroupedListItemRenderer = this._inactiveItemRenderers[i];
				if(!itemRenderer)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
				delete this._itemRendererMap[itemRenderer.data];
			}

			if(this._inactiveFirstItemRenderers)
			{
				rendererCount = this._inactiveFirstItemRenderers.length;
				for(i = 0; i < rendererCount; i++)
				{
					itemRenderer = this._inactiveFirstItemRenderers[i];
					if(!itemRenderer)
					{
						continue;
					}
					this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
					delete this._firstItemRendererMap[itemRenderer.data];
				}
			}

			if(this._inactiveLastItemRenderers)
			{
				rendererCount = this._inactiveLastItemRenderers.length;
				for(i = 0; i < rendererCount; i++)
				{
					itemRenderer = this._inactiveLastItemRenderers[i];
					if(!itemRenderer)
					{
						continue;
					}
					this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
					delete this._lastItemRendererMap[itemRenderer.data];
				}
			}

			if(this._inactiveSingleItemRenderers)
			{
				rendererCount = this._inactiveSingleItemRenderers.length;
				for(i = 0; i < rendererCount; i++)
				{
					itemRenderer = this._inactiveSingleItemRenderers[i];
					if(!itemRenderer)
					{
						continue;
					}
					this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
					delete this._singleItemRendererMap[itemRenderer.data];
				}
			}

			rendererCount = this._inactiveHeaderRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer = this._inactiveHeaderRenderers[i];
				if(!headerOrFooterRenderer)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, headerOrFooterRenderer);
				delete this._headerRendererMap[headerOrFooterRenderer.data];
			}

			rendererCount = this._inactiveFooterRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				headerOrFooterRenderer = this._inactiveFooterRenderers[i];
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, headerOrFooterRenderer);
				delete this._footerRendererMap[headerOrFooterRenderer.data];
			}
		}

		private function freeInactiveRenderers():void
		{
			//we may keep around some extra renderers to avoid too much
			//allocation and garbage collection. they'll be hidden.
			var keepCount:int = Math.min(this._minimumItemCount - this._activeItemRenderers.length, this._inactiveItemRenderers.length);
			for(var i:int = 0; i < keepCount; i++)
			{
				var itemRenderer:IGroupedListItemRenderer = this._inactiveItemRenderers.shift();
				itemRenderer.data = null;
				itemRenderer.visible = false;
				this._activeItemRenderers.push(itemRenderer);
			}
			var rendererCount:int = this._inactiveItemRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				itemRenderer = this._inactiveItemRenderers.shift();
				if(!itemRenderer)
				{
					continue;
				}
				this.destroyItemRenderer(itemRenderer);
			}

			if(this._activeFirstItemRenderers)
			{
				keepCount = Math.min(this._minimumFirstAndLastItemCount - this._activeFirstItemRenderers.length, this._inactiveFirstItemRenderers.length);
				for(i = 0; i < keepCount; i++)
				{
					itemRenderer = this._inactiveFirstItemRenderers.shift();
					itemRenderer.data = null;
					itemRenderer.visible = false;
					this._activeFirstItemRenderers.push(itemRenderer);
				}
				rendererCount = this._inactiveFirstItemRenderers.length;
				for(i = 0; i < rendererCount; i++)
				{
					itemRenderer = this._inactiveFirstItemRenderers.shift();
					if(!itemRenderer)
					{
						continue;
					}
					this.destroyItemRenderer(itemRenderer);
				}
			}

			if(this._activeLastItemRenderers)
			{
				keepCount = Math.min(this._minimumFirstAndLastItemCount - this._activeLastItemRenderers.length, this._inactiveLastItemRenderers.length);
				for(i = 0; i < keepCount; i++)
				{
					itemRenderer = this._inactiveLastItemRenderers.shift();
					itemRenderer.data = null;
					itemRenderer.visible = false;
					this._activeLastItemRenderers.push(itemRenderer);
				}
				rendererCount = this._inactiveLastItemRenderers.length;
				for(i = 0; i < rendererCount; i++)
				{
					itemRenderer = this._inactiveLastItemRenderers.shift();
					if(!itemRenderer)
					{
						continue;
					}
					this.destroyItemRenderer(itemRenderer);
				}
			}

			if(this._activeSingleItemRenderers)
			{
				keepCount = Math.min(this._minimumSingleItemCount - this._activeSingleItemRenderers.length, this._inactiveSingleItemRenderers.length);
				for(i = 0; i < keepCount; i++)
				{
					itemRenderer = this._inactiveSingleItemRenderers.shift();
					itemRenderer.data = null;
					itemRenderer.visible = false;
					this._activeSingleItemRenderers.push(itemRenderer);
				}
				rendererCount = this._inactiveSingleItemRenderers.length;
				for(i = 0; i < rendererCount; i++)
				{
					itemRenderer = this._inactiveSingleItemRenderers.shift();
					if(!itemRenderer)
					{
						continue;
					}
					this.destroyItemRenderer(itemRenderer);
				}
			}

			keepCount = Math.min(this._minimumHeaderCount - this._activeHeaderRenderers.length, this._inactiveHeaderRenderers.length);
			for(i = 0; i < keepCount; i++)
			{
				var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer = this._inactiveHeaderRenderers.shift();
				headerOrFooterRenderer.visible = false;
				headerOrFooterRenderer.data = null;
				this._activeHeaderRenderers.push(headerOrFooterRenderer);
			}
			rendererCount = this._inactiveHeaderRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				headerOrFooterRenderer = this._inactiveHeaderRenderers.shift();
				if(!headerOrFooterRenderer)
				{
					continue;
				}
				this.destroyHeaderRenderer(headerOrFooterRenderer);
			}

			keepCount = Math.min(this._minimumFooterCount - this._activeFooterRenderers.length, this._inactiveFooterRenderers.length);
			for(i = 0; i < keepCount; i++)
			{
				headerOrFooterRenderer = this._inactiveFooterRenderers.shift();
				headerOrFooterRenderer.visible = false;
				headerOrFooterRenderer.data = null;
				this._activeFooterRenderers.push(headerOrFooterRenderer);
			}
			rendererCount = this._inactiveFooterRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				headerOrFooterRenderer = this._inactiveFooterRenderers.shift();
				if(!headerOrFooterRenderer)
				{
					continue;
				}
				this.destroyFooterRenderer(headerOrFooterRenderer);
			}
		}

		private function createItemRenderer(inactiveRenderers:Vector.<IGroupedListItemRenderer>,
			activeRenderers:Vector.<IGroupedListItemRenderer>, rendererMap:Dictionary,
			type:Class, factory:Function, name:String, item:Object, groupIndex:int, itemIndex:int,
			layoutIndex:int, useCache:Boolean, isTemporary:Boolean):IGroupedListItemRenderer
		{
			if(!useCache || isTemporary || inactiveRenderers.length == 0)
			{
				var renderer:IGroupedListItemRenderer;
				if(factory != null)
				{
					renderer = IGroupedListItemRenderer(factory());
				}
				else
				{
					renderer = new type();
				}
				var uiRenderer:IFeathersControl = IFeathersControl(renderer);
				if(name && name.length > 0)
				{
					uiRenderer.nameList.add(name);
				}
				this.addChild(DisplayObject(renderer));
			}
			else
			{
				renderer = inactiveRenderers.shift();
			}
			renderer.data = item;
			renderer.groupIndex = groupIndex;
			renderer.itemIndex = itemIndex;
			renderer.layoutIndex = layoutIndex;
			renderer.owner = this._owner;
			renderer.visible = true;

			if(!isTemporary)
			{
				rendererMap[item] = renderer;
				activeRenderers.push(renderer);
				renderer.addEventListener(Event.CHANGE, renderer_changeHandler);
				renderer.addEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, renderer);
			}

			return renderer;
		}

		private function createHeaderRenderer(header:Object, groupIndex:int, layoutIndex:int, isTemporary:Boolean = false):IGroupedListHeaderOrFooterRenderer
		{
			if(isTemporary || this._inactiveHeaderRenderers.length == 0)
			{
				var renderer:IGroupedListHeaderOrFooterRenderer;
				if(this._headerRendererFactory != null)
				{
					renderer = IGroupedListHeaderOrFooterRenderer(this._headerRendererFactory());
				}
				else
				{
					renderer = new this._headerRendererType();
				}
				var uiRenderer:IFeathersControl = IFeathersControl(renderer);
				if(this._headerRendererName && this._headerRendererName.length > 0)
				{
					uiRenderer.nameList.add(this._headerRendererName);
				}
				this.addChild(DisplayObject(renderer));
			}
			else
			{
				renderer = this._inactiveHeaderRenderers.shift();
			}
			renderer.data = header;
			renderer.groupIndex = groupIndex;
			renderer.layoutIndex = layoutIndex;
			renderer.owner = this._owner;
			renderer.visible = true;

			if(!isTemporary)
			{
				this._headerRendererMap[header] = renderer;
				this._activeHeaderRenderers.push(renderer);
				renderer.addEventListener(FeathersEventType.RESIZE, headerOrFooterRenderer_resizeHandler);
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, renderer);
			}

			return renderer;
		}

		private function createFooterRenderer(footer:Object, groupIndex:int, layoutIndex:int, isTemporary:Boolean = false):IGroupedListHeaderOrFooterRenderer
		{
			if(isTemporary || this._inactiveFooterRenderers.length == 0)
			{
				var renderer:IGroupedListHeaderOrFooterRenderer;
				if(this._footerRendererFactory != null)
				{
					renderer = IGroupedListHeaderOrFooterRenderer(this._footerRendererFactory());
				}
				else
				{
					renderer = new this._footerRendererType();
				}
				var uiRenderer:IFeathersControl = IFeathersControl(renderer);
				if(this._footerRendererName && this._footerRendererName.length > 0)
				{
					uiRenderer.nameList.add(this._footerRendererName);
				}
				this.addChild(DisplayObject(renderer));
			}
			else
			{
				renderer = this._inactiveFooterRenderers.shift();
			}
			renderer.data = footer;
			renderer.groupIndex = groupIndex;
			renderer.layoutIndex = layoutIndex;
			renderer.owner = this._owner;
			renderer.visible = true;

			if(!isTemporary)
			{
				this._footerRendererMap[footer] = renderer;
				this._activeFooterRenderers.push(renderer);
				renderer.addEventListener(FeathersEventType.RESIZE, headerOrFooterRenderer_resizeHandler);
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, renderer);
			}

			return renderer;
		}

		private function destroyItemRenderer(renderer:IGroupedListItemRenderer):void
		{
			renderer.removeEventListener(Event.CHANGE, renderer_changeHandler);
			renderer.removeEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
			renderer.owner = null;
			renderer.data = null;
			this.removeChild(DisplayObject(renderer), true);
		}

		private function destroyHeaderRenderer(renderer:IGroupedListHeaderOrFooterRenderer):void
		{
			renderer.removeEventListener(FeathersEventType.RESIZE, headerOrFooterRenderer_resizeHandler);
			renderer.owner = null;
			renderer.data = null;
			this.removeChild(DisplayObject(renderer), true);
		}

		private function destroyFooterRenderer(renderer:IGroupedListHeaderOrFooterRenderer):void
		{
			renderer.removeEventListener(FeathersEventType.RESIZE, headerOrFooterRenderer_resizeHandler);
			renderer.owner = null;
			renderer.data = null;
			this.removeChild(DisplayObject(renderer), true);
		}

		private function groupToHeaderDisplayIndex(groupIndex:int):int
		{
			var group:Object = this._dataProvider.getItemAt(groupIndex);
			var header:Object = this._owner.groupToHeaderData(group);
			if(!header)
			{
				return -1;
			}
			var displayIndex:int = 0;
			const groupCount:int = this._dataProvider.getLength();
			for(var i:int = 0; i < groupCount; i++)
			{
				group = this._dataProvider.getItemAt(i);
				header = this._owner.groupToHeaderData(group);
				if(header)
				{
					if(groupIndex == i)
					{
						return displayIndex;
					}
					displayIndex++;
				}
				var groupLength:int = this._dataProvider.getLength(i);
				for(var j:int = 0; j < groupLength; j++)
				{
					displayIndex++;
				}
				var footer:Object = this._owner.groupToFooterData(group);
				if(footer)
				{
					displayIndex++;
				}
			}
			return -1;
		}

		private function groupToFooterDisplayIndex(groupIndex:int):int
		{
			var group:Object = this._dataProvider.getItemAt(groupIndex);
			var footer:Object = this._owner.groupToFooterData(group);
			if(!footer)
			{
				return -1;
			}
			var displayIndex:int = 0;
			const groupCount:int = this._dataProvider.getLength();
			for(var i:int = 0; i < groupCount; i++)
			{
				group = this._dataProvider.getItemAt(i);
				var header:Object = this._owner.groupToHeaderData(group);
				if(header)
				{
					displayIndex++;
				}
				var groupLength:int = this._dataProvider.getLength(i);
				for(var j:int = 0; j < groupLength; j++)
				{
					displayIndex++;
				}
				footer = this._owner.groupToFooterData(group);
				if(footer)
				{
					if(groupIndex == i)
					{
						return displayIndex;
					}
					displayIndex++;
				}
			}
			return -1;
		}

		private function locationToDisplayIndex(groupIndex:int, itemIndex:int):int
		{
			var displayIndex:int = 0;
			const groupCount:int = this._dataProvider.getLength();
			for(var i:int = 0; i < groupCount; i++)
			{
				var group:Object = this._dataProvider.getItemAt(i);
				var header:Object = this._owner.groupToHeaderData(group);
				if(header)
				{
					displayIndex++;
				}
				var groupLength:int = this._dataProvider.getLength(i);
				for(var j:int = 0; j < groupLength; j++)
				{
					if(groupIndex == i && itemIndex == j)
					{
						return displayIndex;
					}
					displayIndex++;
				}
				var footer:Object = this._owner.groupToFooterData(group);
				if(footer)
				{
					displayIndex++;
				}
			}
			return -1;
		}

		private function childProperties_onChange(proxy:PropertyProxy, name:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private function owner_scrollStartHandler(event:Event):void
		{
			this._isScrolling = true;
		}

		private function dataProvider_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private function dataProvider_addItemHandler(event:Event, indices:Array):void
		{
			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			const groupIndex:int = indices[0] as int;
			if(indices.length > 1) //adding an item
			{
				const itemIndex:int = indices[1] as int;
				const itemDisplayIndex:int = this.locationToDisplayIndex(groupIndex, itemIndex);
				layout.addToVariableVirtualCacheAtIndex(itemDisplayIndex);
			}
			else //adding a whole group
			{
				const headerDisplayIndex:int = this.groupToHeaderDisplayIndex(groupIndex);
				if(headerDisplayIndex >= 0)
				{
					layout.addToVariableVirtualCacheAtIndex(headerDisplayIndex);
				}
				var groupLength:int = this._dataProvider.getLength(groupIndex);
				if(groupLength > 0)
				{
					var displayIndex:int = headerDisplayIndex;
					if(displayIndex < 0)
					{
						displayIndex = this.locationToDisplayIndex(groupIndex, 0);
					}
					groupLength += displayIndex;
					for(var i:int = displayIndex; i < groupLength; i++)
					{
						layout.addToVariableVirtualCacheAtIndex(displayIndex);
					}
				}
				const footerDisplayIndex:int = this.groupToFooterDisplayIndex(groupIndex);
				if(footerDisplayIndex >= 0)
				{
					layout.addToVariableVirtualCacheAtIndex(footerDisplayIndex);
				}
			}
		}

		private function dataProvider_removeItemHandler(event:Event, indices:Array):void
		{
			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			const groupIndex:int = indices[0] as int;
			if(indices.length > 1) //removing an item
			{
				const itemIndex:int = indices[1] as int;
				const displayIndex:int = this.locationToDisplayIndex(groupIndex, itemIndex);
				layout.removeFromVariableVirtualCacheAtIndex(displayIndex);
			}
			else //removing a whole group
			{
				//TODO: figure out the length of the previous group so that we
				//don't need to reset the whole cache
				layout.resetVariableVirtualCache();
			}
		}

		private function dataProvider_replaceItemHandler(event:Event, indices:Array):void
		{
			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			const groupIndex:int = indices[0] as int;
			if(indices.length > 1) //replacing an item
			{
				const itemIndex:int = indices[1] as int;
				const displayIndex:int = this.locationToDisplayIndex(groupIndex, itemIndex);
				layout.resetVariableVirtualCacheAtIndex(displayIndex);
			}
			else //replacing a whole group
			{
				//TODO: figure out the length of the previous group so that we
				//don't need to reset the whole cache
				layout.resetVariableVirtualCache();
			}
		}

		private function dataProvider_resetHandler(event:Event):void
		{
			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			layout.resetVariableVirtualCache();
		}

		private function dataProvider_updateItemHandler(event:Event, indices:Array):void
		{
			const groupIndex:int = indices[0] as int;
			if(indices.length > 1) //updating a whole group
			{
				const itemIndex:int = indices[1] as int;
				const item:Object = this._dataProvider.getItemAt(groupIndex, itemIndex);
				var renderer:IGroupedListItemRenderer = IGroupedListItemRenderer(this._itemRendererMap[item]);
				if(!renderer)
				{
					if(this._firstItemRendererMap)
					{
						renderer = IGroupedListItemRenderer(this._firstItemRendererMap[item]);
					}
					if(!renderer)
					{
						if(this._lastItemRendererMap)
						{
							renderer = IGroupedListItemRenderer(this._lastItemRendererMap[item]);
						}
						if(!renderer)
						{
							if(this._singleItemRendererMap)
							{
								renderer = IGroupedListItemRenderer(this._singleItemRendererMap[item]);
							}
							if(!renderer)
							{
								return;
							}
						}
					}
				}
				renderer.data = null;
				renderer.data = item;
			}
			else //updating a whole group
			{
				const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
				if(!layout || !layout.hasVariableItemDimensions)
				{
					return;
				}
				//TODO: figure out the length of the previous group so that we
				//don't need to reset the whole cache
				layout.resetVariableVirtualCache();
			}
		}

		private function layout_changeHandler(event:Event):void
		{
			if(this._ignoreLayoutChanges)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
		}

		private function itemRenderer_resizeHandler(event:Event):void
		{
			if(this._ignoreRendererResizing)
			{
				return;
			}
			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			const renderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.currentTarget);
			layout.resetVariableVirtualCacheAtIndex(renderer.layoutIndex, DisplayObject(renderer));
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
		}

		private function headerOrFooterRenderer_resizeHandler(event:Event):void
		{
			if(this._ignoreRendererResizing)
			{
				return;
			}
			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			const renderer:IGroupedListHeaderOrFooterRenderer = IGroupedListHeaderOrFooterRenderer(event.currentTarget);
			layout.resetVariableVirtualCacheAtIndex(renderer.layoutIndex, DisplayObject(renderer));
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
		}

		private function renderer_changeHandler(event:Event):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			const renderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.currentTarget);
			const isAlreadySelected:Boolean = this._selectedGroupIndex == renderer.groupIndex &&
				this._selectedItemIndex == renderer.itemIndex;
			if(!this._isSelectable || this._isScrolling || isAlreadySelected)
			{
				//reset to the old value
				renderer.isSelected = isAlreadySelected;
				return;
			}
			this.setSelectedLocation(renderer.groupIndex, renderer.itemIndex);
		}

		private function removedFromStageHandler(event:Event):void
		{
			this.touchPointID = -1;
		}

		private function touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this.touchPointID = -1;
				return;
			}

			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, TouchPhase.ENDED, this.touchPointID);
				if(!touch)
				{
					return;
				}
				this.touchPointID = -1;
			}
			else
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this.touchPointID = touch.id;
				this._isScrolling = false;
			}
		}
	}
}
