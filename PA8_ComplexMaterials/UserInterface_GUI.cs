using UnityEngine;
using UnityEditor;

// STEP1
// how to create a custom inspector: extends(继承) "UnityEditor.ShaderGUI"
public class UserInterface_GUI : ShaderGUI {

	// STEP6-1
	// To show the properties of our material, have to access them in our methods
	MaterialEditor editor;
	MaterialProperty[] properties;

	// STEP11-1
	// Creat a method to configure the contents of label
	static GUIContent staticLabel = new GUIContent();
	
	// STEP3
	// To replace the default inspector: override the ShaderGUI.OnGUI method
	// Two parameters: inspector of currently selected material & properties
	public override void OnGUI (
		MaterialEditor editor, MaterialProperty[] properties
	) {
		// STEP6-2
		// put them in fields
		this.editor = editor;
		this.properties = properties;
		// STEP4
		// standard GUI is split into two sections
		// one for the main maps, and another for the sencondary maps
		DoMain();
		// STEP14-1
		// Secondary maps
		DoSecondary();
	}

	void DoMain () {
		// STEP5
		// bold style label
		GUILayout.Label("Main Maps", EditorStyles.boldLabel);

		// STEP7
		// use FindProperty method, given a name and property array
		// STEP10-2
		// use our own FindProperty
		MaterialProperty mainTex = FindProperty("_MainTex");

		// STEP8 - ?
		// ?: what does this mean
		// define the contents of a label, done with GUIContent
		// GUIContent albedoLabel= new GUIContent(mainTex.displayName, "Albedo(RGB)");

		// TexturePropertySingleLine methods: has vairiants with more than one property, up to three
		// first should be a texture, others can be something else
		editor.TexturePropertySingleLine(
			MakeLabel(mainTex, "Albedo (RGB)"), mainTex, FindProperty("_Tint")
		);

		// STEP13-1
		DoMetallic();
		DoSmoothness();
		// STEP12-1
		DoNormals();

		// STEP9
		// tilling and offset values of the mainTex are shown
		editor.TextureScaleOffsetProperty(mainTex);
	}

	// STEP12-2
	// new DoNormals method simply retrieves the map property and display it
	void DoNormals () {
		MaterialProperty map = FindProperty("_NormalMap");
		editor.TexturePropertySingleLine(
			MakeLabel(map), map,
			map.textureValue ? FindProperty("_BumpScale") : null
		);
	}

	// STEP13-2
	// Show them via the general-purpose MaterialEditor.ShaderProperty methed
	// Adjust indent level by EditorGUI.indentLevel property, make sure to reset it afterwards
	void DoMetallic () {
		MaterialProperty slider = FindProperty("_Metallic");
		EditorGUI.indentLevel += 2;
		editor.ShaderProperty(slider, MakeLabel(slider));
		EditorGUI.indentLevel -= 2;
	}

	// STEP13-3
	void DoSmoothness () {
		MaterialProperty slider = FindProperty("_Smoothness");
		EditorGUI.indentLevel += 2;
		editor.ShaderProperty(slider, MakeLabel(slider));
		EditorGUI.indentLevel -= 2;
	}

	// STEP14-2
	// adjust detailTex display name(Detail Albedo) to match the defualt editor
	void DoSecondary () {
		GUILayout.Label("Secondary Maps", EditorStyles.boldLabel);
		MaterialProperty detailTex = FindProperty("_DetailTex");
		editor.TexturePropertySingleLine(
			MakeLabel(detailTex, "Albedo (RGB) multiplied by 2"), detailTex
		);
		DoSecondaryNormals();
		editor.TextureScaleOffsetProperty(detailTex);
	}

	// STEP15
	// hide detail bump scale when there's no detail bump map
	void DoSecondaryNormals () {
		MaterialProperty map = FindProperty("_DetailNormalMap");
		editor.TexturePropertySingleLine(
			MakeLabel(map), map,
			map.textureValue ? FindProperty("_DetailBumpScale") : null
		);
	}


	// STEP10-1
	// create our own FindProperty
	MaterialProperty FindProperty (string name) {
		return FindProperty(name, properties);
	}

	// STEP11-2
	// Creat a method to configure the contents of label
	// Make the tooltip optional
	static GUIContent MakeLabel (string text, string tooltip = null) {
		staticLabel.text = text;
		staticLabel.tooltip = tooltip;
		return staticLabel;
	}

	// STEP11-3
	// Creat a MakeLabel variant
	static GUIContent MakeLabel (
		MaterialProperty property, string tooltip = null
	) {
		staticLabel.text = property.displayName;
		staticLabel.tooltip = tooltip;
		return staticLabel;
	}
}