/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class loginViewUI extends View {
		public var txtID:TextInput;
		public var txtPass:TextInput;
		public var btnLogin:Button;
		public var btnReg:Button;
		private var uiXML:XML =
			<View>
			  <Image url="png.login_interface.win_login" x="320" y="380"/>
			  <CheckBox label="存档" skin="png.comp.checkbox" x="550" y="412"/>
			  <TextInput text="TextInput" skin="png.comp.textinput" x="411" y="408" var="txtID" name="txtID"/>
			  <TextInput text="TextInput" skin="png.comp.textinput" x="411" y="439" var="txtPass" name="txtPass" asPassword="true"/>
			  <Button skin="png.login_interface.btn_connect" x="553" y="476" var="btnLogin" name="btnLogin"/>
			  <Button skin="png.login_interface.btn_request" x="325" y="476" var="btnReg" name="btnReg"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}