/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class charCreateViewUI extends View {
		public var txtName:TextInput;
		public var labStr:Label;
		public var labAgi:Label;
		public var labVit:Label;
		public var labInt:Label;
		public var labDex:Label;
		public var labLuk:Label;
		protected var uiXML:XML =
			<View>
			  <Image url="png.login_interface.win_make" x="0" y="0"/>
			  <Image url="png.login_interface.arw-agi0" x="192" y="107"/>
			  <Image url="png.login_interface.arw-dex0" x="192" y="192"/>
			  <Image url="png.login_interface.arw-int0" x="271" y="245"/>
			  <Image url="png.login_interface.arw-luk0" x="349" y="189"/>
			  <Image url="png.login_interface.arw-str0" x="270" y="50"/>
			  <Image url="png.login_interface.arw-vit0" x="348" y="104"/>
			  <TextInput text="TextInput" skin="png.comp.textinput" x="61" y="244" var="txtName" name="txtName"/>
			  <Label text="label" x="459" y="36" width="80" var="labStr" name="labStr"/>
			  <Label text="label" x="459" y="52" width="80" var="labAgi" name="labAgi"/>
			  <Label text="label" x="459" y="69" width="80" var="labVit" name="labVit"/>
			  <Label text="label" x="459" y="85" width="80" var="labInt" name="labInt"/>
			  <Label text="label" x="459" y="101" width="80" var="labDex" name="labDex"/>
			  <Label text="label" x="459" y="118" width="80" var="labLuk" name="labLuk"/>
			  <Button skin="png.basic_interface.btn_ok" x="6" y="318"/>
			  <Button skin="png.basic_interface.btn_cancel" x="54" y="318"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}