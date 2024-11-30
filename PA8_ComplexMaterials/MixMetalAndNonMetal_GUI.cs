using UnityEngine;
using UnityEditor;

public class MixMetalAndNonMetal_GUI: ShaderGUI {
	static GUIContent staticLabel = new GUIContent();
	// STEP 3: Custom Shader Keywords
	// To add custom keywords to a material, access the maerial directly in GUI
	Material target;
	MaterialEditor editor;
	MaterialProperty[] properties;

	public override void OnGUI(
		MaterialEditor editor, MaterialProperty[] properties
	) {
		// STEP 3: Custom Shader Keywords
		// cast type to Material
		this.target = editor.target as Material;
		this.editor = editor;
		this.properties = properties;
		DoMain();
		DoSecondary();
	}

	void DoMain() {
		GUILayout.Label("Main Maps", EditorStyles.boldLabel);

		MaterialProperty mainTex = FindProperty("_MainTex");
		editor.TexturePropertySingleLine(MakeLabel("Albedo", "Albedo(RGB)"), mainTex, FindProperty("_Tint"));
		DoMetallic();
		DoSmoothness();
		DoNormals();
		editor.TextureScaleOffsetProperty(mainTex);
	}

	void DoNormals() {
		MaterialProperty map = FindProperty("_NormalMap");
		editor.TexturePropertySingleLine(MakeLabel("Normals"), map, map.textureValue ? FindProperty("_BumpScale") : null);
	}
    	
    	// STEP 2: Custom GUI
	void DoMetallic() {
		MaterialProperty map = FindProperty("_MetallicMap");
		// STEP 4: Setting Keywords When Needed
		// setting the material's keyword when the map property has been edited
		EditorGUI.BeginChangeCheck();
		// STEP 2: Custom GUI
		// 无 texture 时显示 slider
		editor.TexturePropertySingleLine(MakeLabel("Metallic", "Metallic(R)"), map, map.textureValue ? null : FindProperty("_Metallic"));
		// STEP 4: Setting Keywords When Needed
		if (EditorGUI.EndChangeCheck()) {
			// STEP 3: Custom Shader Keywords
			// toggle our custom keyword
			SetKeyword("_METALLIC_MAP", map.textureValue);
		}
	}

	void DoSmoothness() {
		MaterialProperty slider = FindProperty("_Smoothness");
		EditorGUI.indentLevel += 2;
		editor.ShaderProperty(slider, MakeLabel("Smoothness"));
		EditorGUI.indentLevel -= 2;
	}

	void DoSecondary() {
		GUILayout.Label("Secondary Maps", EditorStyles.boldLabel);
		MaterialProperty detailTex = FindProperty("_DetailTex");
		editor.TexturePropertySingleLine(MakeLabel("Detail Albedo", "Albedo(RGB) multiplied by 2"), detailTex);
		DoSecondaryNormals();
		editor.TextureScaleOffsetProperty(detailTex);
	}

	void DoSecondaryNormals() {
		MaterialProperty map = FindProperty("_DetailNormalMap");
		editor.TexturePropertySingleLine(MakeLabel("Detail Normals"), map, map.textureValue ? FindProperty("_DetailBumpScale") : null);
	}

	MaterialProperty FindProperty(string name) {
		return FindProperty(name, properties);
	}

	static GUIContent MakeLabel(string text, string tooltip = null) {
		staticLabel.text = text;
		staticLabel.tooltip = tooltip;
		return staticLabel;
	}

	static GUIContent MakeLabel(
		MaterialProperty property, string tooltip = null
	) {
		staticLabel.text = property.displayName;
		staticLabel.tooltip = tooltip;
		return staticLabel;
	}

	// STEP 3: Custom Shader Keywords
	// Material.EnableKeyword & Material.DisableKeyword: enable / disable a keyword to a shader
	void SetKeyword(string keyword, bool state) {
		if (state) {
			target.EnableKeyword(keyword);
		} else {
			target.DisableKeyword(keyword);
		}
	}
}