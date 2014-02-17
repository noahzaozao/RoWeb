package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.core.PropertyProxy;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Exclude(name="layout",kind="property")]
	[Exclude(name="footer",kind="property")]
	[Exclude(name="footerFactory",kind="property")]
	[Exclude(name="footerProperties",kind="property")]
	[Exclude(name="customFooterName",kind="property")]
	[Exclude(name="createFooter",kind="method")]

	/**
	 * Dispatched when the alert is closed. The <code>data</code> property of
	 * the event object will contain the item from the <code>ButtonGroup</code>
	 * data provider for the button that is triggered. If no button is
	 * triggered, then the <code>data</code> property will be <code>null</code>.
	 *
	 * @eventType starling.events.Event.CLOSE
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * Displays a message in a modal pop-up with a title and a set of buttons.
	 *
	 * <p>In general, an <code>Alert</code> isn't instantiated directly.
	 * Instead, you will typically call the static function
	 * <code>Alert.show()</code>. This is not required, but it result in less
	 * code and no need to manually manage calls to the <code>PopUpManager</code>.</p>
	 *
	 * <p>In the following example, an alert is shown when a <code>Button</code>
	 * is triggered:</p>
	 *
	 * <listing version="3.0">
	 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
	 *
	 * function button_triggeredHandler( event:Event ):void
	 * {
	 *     var alert:Alert = Alert.show( "This is an alert!", "Hello World", new ListCollection(
	 *     [
	 *         { label: "OK" }
	 *     ]);
	 * }</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/alert
	 */
	public class Alert extends Panel
	{
		/**
		 * The default value added to the <code>nameList</code> of the header.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_HEADER:String = "feathers-alert-header";

		/**
		 * The default value added to the <code>nameList</code> of the button group.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_BUTTON_GROUP:String = "feathers-alert-button-group";

		/**
		 * The default value added to the <code>nameList</code> of the message.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_MESSAGE:String = "feathers-alert-message";

		/**
		 * Returns a new <code>Alert</code> instance when <code>Alert.show()</code>
		 * is called. If one wishes to skin the alert manually, a custom factory
		 * may be provided.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Alert</pre>
		 *
		 * <p>The following example shows how to create a custom alert factory:</p>
		 *
		 * <listing version="3.0">
		 * Alert.alertFactory = function():Alert
		 * {
		 *     var alert:Alert = new Alert();
		 *     //set properties here!
		 *     return alert;
		 * };</listing>
		 *
		 * @see #show()
		 */
		public static var alertFactory:Function = defaultAlertFactory;

		/**
		 * Returns an overlay to display with a alert that is modal. Uses the
		 * standard <code>overlayFactory</code> of the <code>PopUpManager</code>
		 * by default, but you can use this property to provide your own custom
		 * overlay, if you prefer.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 *
		 * <p>The following example uses a semi-transparent <code>Quad</code> as
		 * a custom overlay:</p>
		 *
		 * <listing version="3.0">
		 * Alert.overlayFactory = function():Quad
		 * {
		 *     var quad:Quad = new Quad(10, 10, 0x000000);
		 *     quad.alpha = 0.75;
		 *     return quad;
		 * };</listing>
		 *
		 * @see feathers.core.PopUpManager#overlayFactory
		 *
		 * @see #show()
		 */
		public static var overlayFactory:Function;

		/**
		 * The default factory that creates alerts when <code>Alert.show()</code>
		 * is called. To use a different factory, you need to set
		 * <code>Alert.alertFactory</code> to a <code>Function</code>
		 * instance.
		 *
		 * @see #show()
		 * @see #alertFactory
		 */
		public static function defaultAlertFactory():Alert
		{
			return new Alert();
		}

		/**
		 * Creates an alert, sets common properties, and adds it to the
		 * <code>PopUpManager</code> with the specified modal and centering
		 * options.
		 *
		 * <p>In the following example, an alert is shown when a
		 * <code>Button</code> is triggered:</p>
		 *
		 * <listing version="3.0">
		 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
		 *
		 * function button_triggeredHandler( event:Event ):void
		 * {
		 *     var alert:Alert = Alert.show( "This is an alert!", "Hello World", new ListCollection(
		 *     [
		 *         { label: "OK" }
		 *     ]);
		 * }</listing>
		 */
		public static function show(message:String, title:String = null, buttons:ListCollection = null,
			isModal:Boolean = true, isCentered:Boolean = true,
			customAlertFactory:Function = null, customOverlayFactory:Function = null):Alert
		{
			var factory:Function = customAlertFactory;
			if(factory == null)
			{
				factory = alertFactory != null ? alertFactory : defaultAlertFactory;
			}
			var alert:Alert = Alert(factory());
			alert.title = title;
			alert.message = message;
			alert.buttonsDataProvider = buttons;
			factory = customOverlayFactory;
			if(factory == null)
			{
				factory = overlayFactory;
			}
			PopUpManager.addPopUp(alert, isModal, isCentered, factory);
			return alert;
		}

		/**
		 * @private
		 */
		protected static function defaultButtonGroupFactory():ButtonGroup
		{
			return new ButtonGroup();
		}

		/**
		 * Constructor.
		 */
		public function Alert()
		{
			super();
			this.headerName = DEFAULT_CHILD_NAME_HEADER;
			this.footerName = DEFAULT_CHILD_NAME_BUTTON_GROUP;
			this.buttonGroupFactory = defaultButtonGroupFactory;
		}

		/**
		 * The value added to the <code>nameList</code> of the alert's message
		 * text renderer. This variable is <code>protected</code> so that
		 * sub-classes can customize the message name in their constructors
		 * instead of using the default name defined by
		 * <code>DEFAULT_CHILD_NAME_MESSAGE</code>.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var messageName:String = DEFAULT_CHILD_NAME_MESSAGE;

		/**
		 * The header sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var headerHeader:Header;

		/**
		 * The button group sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var buttonGroupFooter:ButtonGroup;

		/**
		 * The message text renderer sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var messageTextRenderer:ITextRenderer;

		/**
		 * @private
		 */
		protected var _title:String = null;

		/**
		 * The title text displayed in the alert's header.
		 */
		public function get title():String
		{
			return this._title;
		}

		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			if(this._title == value)
			{
				return;
			}
			this._title = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _message:String = null;

		/**
		 * The alert's main text content.
		 */
		public function get message():String
		{
			return this._message;
		}

		/**
		 * @private
		 */
		public function set message(value:String):void
		{
			if(this._message == value)
			{
				return;
			}
			this._message = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _buttonsDataProvider:ListCollection;

		/**
		 * The data provider of the alert's <code>ButtonGroup</code>.
		 */
		public function get buttonsDataProvider():ListCollection
		{
			return this._buttonsDataProvider;
		}

		/**
		 * @private
		 */
		public function set buttonsDataProvider(value:ListCollection):void
		{
			if(this._buttonsDataProvider == value)
			{
				return;
			}
			this._buttonsDataProvider = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _messageFactory:Function;

		/**
		 * A function used to instantiate the alert's message text renderer
		 * sub-component. By default, the alert will use the global text
		 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
		 * to create the message text renderer. The message text renderer must
		 * be an instance of <code>ITextRenderer</code>. This factory can be
		 * used to change properties on the message text renderer when it is
		 * first created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to style the message text
		 * renderer.
		 *
		 * <p>If you are not using a theme, the message factory can be used to
		 * provide skin the message text renderer with appropriate text styles.</p>
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, a custom message factory is passed to
		 * the alert:</p>
		 *
		 * <listing version="3.0">
		 * header.messageFactory = function():ITextRenderer
		 * {
		 *     var messageRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
		 *     messageRenderer.textFormat = new TextFormat( "_sans", 12, 0xff0000 );
		 *     return messageRenderer;
		 * }</listing>
		 *
		 * @default null
		 *
		 * @see #message
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
		 */
		public function get messageFactory():Function
		{
			return this._messageFactory;
		}

		/**
		 * @private
		 */
		public function set messageFactory(value:Function):void
		{
			if(this._messageFactory == value)
			{
				return;
			}
			this._messageFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _messageProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the alert's message
		 * text renderer. The message text renderer is an <code>ITextRenderer</code>
		 * instance. The available properties depend on which
		 * <code>ITextRenderer</code> implementation is returned by
		 * <code>messageFactory</code>. The most common implementations are
		 * <code>BitmapFontTextRenderer</code> and <code>TextFieldTextRenderer</code>.
		 *
		 * <p>In the following example, some properties are set for the alert's
		 * message text renderer (this example assumes that the message text
		 * renderer is a <code>BitmapFontTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * header.messageProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
		 * header.messageProperties.wordWrap = true;</listing>
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>messageFactory</code> function instead
		 * of using <code>messageProperties</code> will result in better
		 * performance.</p>
		 *
		 * @default null
		 *
		 * @see #titleFactory
		 * @see feathers.core.ITextRenderer
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
		 */
		public function get messageProperties():Object
		{
			if(!this._messageProperties)
			{
				this._messageProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._messageProperties;
		}

		/**
		 * @private
		 */
		public function set messageProperties(value:Object):void
		{
			if(this._messageProperties == value)
			{
				return;
			}
			if(value && !(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._messageProperties)
			{
				this._messageProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._messageProperties = PropertyProxy(value);
			if(this._messageProperties)
			{
				this._messageProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * A function used to generate the alerts's button group sub-component.
		 * The button group must be an instance of <code>ButtonGroup</code>.
		 * This factory can be used to change properties on the button group
		 * when it is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on the button group.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():ButtonGroup</pre>
		 *
		 * <p>In the following example, a custom button group factory is
		 * provided to the alert:</p>
		 *
		 * <listing version="3.0">
		 * alert.buttonGroupFactory = function():ButtonGroup
		 * {
		 *     return new ButtonGroup();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ButtonGroup
		 * @see #buttonGroupProperties
		 */
		public function get buttonGroupFactory():Function
		{
			return super.footerFactory;
		}

		/**
		 * @private
		 */
		public function set buttonGroupFactory(value:Function):void
		{
			super.footerFactory = value;
		}

		/**
		 * A name to add to the alert's button group sub-component. Typically
		 * used by a theme to provide different skins to different alerts.
		 *
		 * <p>In the following example, a custom button group name is passed to
		 * the alert:</p>
		 *
		 * <listing version="3.0">
		 * alert.customButtonGroupName = "my-custom-button-group";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * setInitializerForClass( ButtonGroup, customButtonGroupInitializer, "my-custom-button-group");</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_NAME_BUTTON_GROUP
		 * @see feathers.core.FeathersControl#nameList
		 * @see feathers.core.DisplayListWatcher
		 * @see #buttonGroupFactory
		 * @see #buttonGroupProperties
		 */
		public function get customButtonGroupName():String
		{
			return super.customFooterName;
		}

		/**
		 * @private
		 */
		public function set customButtonGroupName(value:String):void
		{
			super.customFooterName = value;
		}

		/**
		 * A set of key/value pairs to be passed down to the alert's button
		 * group sub-component. The button must be a
		 * <code>feathers.core.ButtonGroup</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>buttonGroupFactory</code> function
		 * instead of using <code>buttonGroupProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the button group properties are customized:</p>
		 *
		 * <listing version="3.0">
		 * alert.buttonGroupProperties.gap = 20;</listing>
		 *
		 * @default null
		 *
		 * @see #buttonGroupFactory
		 * @see feathers.controls.ButtonGroup
		 */
		public function get buttonGroupProperties():Object
		{
			return super.footerProperties;
		}

		/**
		 * @private
		 */
		public function set buttonGroupProperties(value:Object):void
		{
			super.footerProperties = value;
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.layout)
			{
				var layout:VerticalLayout = new VerticalLayout();
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
				this.layout = layout;
			}
			super.initialize();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES)
			var textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

			if(textRendererInvalid)
			{
				const oldDisplayListBypassEnabled:Boolean = this.displayListBypassEnabled;
				this.displayListBypassEnabled = true;
				this.createMessage();
				this.displayListBypassEnabled = oldDisplayListBypassEnabled;
			}

			if(textRendererInvalid || dataInvalid)
			{
				this.messageTextRenderer.text = this._message;
			}

			if(textRendererInvalid || stylesInvalid)
			{
				this.refreshMessageStyles();
			}

			super.draw();
		}

		/**
		 * Creates and adds the <code>header</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #header
		 * @see #headerFactory
		 * @see #customHeaderName
		 */
		override protected function createHeader():void
		{
			super.createHeader();
			this.headerHeader = Header(this.header);
		}

		/**
		 * Creates and adds the <code>buttonGroupFooter</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #buttonGroupFooter
		 * @see #buttonGroupFactory
		 * @see #customButtonGroupName
		 */
		protected function createButtonGroup():void
		{
			if(this.buttonGroupFooter)
			{
				this.buttonGroupFooter.removeEventListener(Event.TRIGGERED, buttonsFooter_triggeredHandler);
			}
			super.createFooter();
			this.buttonGroupFooter = ButtonGroup(this.footer);
			this.buttonGroupFooter.addEventListener(Event.TRIGGERED, buttonsFooter_triggeredHandler);
		}

		/**
		 * @private
		 */
		override protected function createFooter():void
		{
			this.createButtonGroup();
		}

		/**
		 * Creates and adds the <code>messageTextRenderer</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #message
		 * @see #messageTextRenderer
		 * @see #messageFactory
		 */
		protected function createMessage():void
		{
			if(this.messageTextRenderer)
			{
				this.removeChild(DisplayObject(this.messageTextRenderer), true);
				this.messageTextRenderer = null;
			}

			const factory:Function = this._messageFactory != null ? this._messageFactory : FeathersControl.defaultTextRendererFactory;
			this.messageTextRenderer = ITextRenderer(factory());
			const uiTextRenderer:IFeathersControl = IFeathersControl(this.messageTextRenderer);
			uiTextRenderer.nameList.add(this.messageName);
			uiTextRenderer.touchable = false;
			this.addChild(DisplayObject(this.messageTextRenderer));
		}

		/**
		 * @private
		 */
		override protected function refreshHeaderStyles():void
		{
			super.refreshHeaderStyles();
			this.headerHeader.title = this._title;
		}

		/**
		 * @private
		 */
		override protected function refreshFooterStyles():void
		{
			super.refreshFooterStyles();
			this.buttonGroupFooter.dataProvider = this._buttonsDataProvider;
		}

		/**
		 * @private
		 */
		protected function refreshMessageStyles():void
		{
			const displayMessageRenderer:DisplayObject = DisplayObject(this.messageTextRenderer);
			for(var propertyName:String in this._messageProperties)
			{
				if(displayMessageRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._messageProperties[propertyName];
					displayMessageRenderer[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function buttonsFooter_triggeredHandler(event:Event, data:Object):void
		{
			this.removeFromParent();
			this.dispatchEventWith(Event.CLOSE, false, data);
			this.dispose();
		}

	}
}
