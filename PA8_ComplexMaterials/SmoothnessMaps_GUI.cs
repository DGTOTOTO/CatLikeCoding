using UnityEngine;
using UnityEditor;

public class SmoothnessMaps_GUI: ShaderGUI {
	// STEP 2: 展示存储源选项
	enum SmoothnessSource {
		Uniform, Albedo, Metallic
	}
	static GUIContent staticLabel = new GUIContent();
	Material target;
	MaterialEditor editor;
	MaterialProperty[] properties;

	public override void OnGUI(
		MaterialEditor editor, MaterialProperty[] properties
	) {
		this.target = editor.target as Material;
		this.editor = editor;
		this.properties = properties;
		DoMain();
		DoSecondary();
	}

	void DoMain() {
		GUILayout.Label("Main Maps", EditorStyles.boldLabel);
		MaterialProperty mainTex = FindProperty("_MainTex");
		editor.TexturePropertySingleLine(MakeLabel(mainTex, "Albedo(RGB)"), mainTex, FindProperty("_Tint"));
		DoMetallic();
		DoSmoothness();
		DoNormals();
		editor.TextureScaleOffsetProperty(mainTex);
	}

	void DoNormals() {
		MaterialProperty map = FindProperty("_NormalMap");
		editor.TexturePropertySingleLine(MakeLabel(map), map, map.textureValue ? FindProperty("_BumpScale") : null);
	}
    	
	void DoMetallic() {
		MaterialProperty map = FindProperty("_MetallicMap");
		EditorGUI.BeginChangeCheck();
		editor.TexturePropertySingleLine(MakeLabel(map, "Metallic(R)"), map, map.textureValue ? null : FindProperty("_Metallic"));
		if (EditorGUI.EndChangeCheck()) {
			SetKeyword("_METALLIC_MAP", map.textureValue);
		}
	}

	void DoSmoothness() {
		// STEP 2: 使用当前 smoothness 源
		SmoothnessSource source = SmoothnessSource.Uniform;
		if (IsKeywordEnabled("_SMOOTHNESS_ALBEDO")) {
			source = SmoothnessSource.Albedo;
		} else if (IsKeywordEnabled("_SMOOTHNESS_METALLIC")) {
			source = SmoothnessSource.Metallic;
		}
		MaterialProperty slider = FindProperty("_Smoothness");
		EditorGUI.indentLevel += 2;
		editor.ShaderProperty(slider, MakeLabel(slider));
		EditorGUI.indentLevel += 1;
		// STEP 2: 追踪 GUI control 控制并切换 keyword
		EditorGUI.BeginChangeCheck();
		// STEP 2: 创建 popup list
		source = (SmoothnessSource)EditorGUILayout.EnumPopup(MakeLabel("Source"), source);
		if (EditorGUI.EndChangeCheck()) {
			// STEP 3: 录制 old 动作
			RecordAction("Smoothness Source");
			SetKeyword("_SMOOTHNESS_ALBEDO", source == SmoothnessSource.Albedo);
			SetKeyword("_SMOOTHNESS_METALLIC", source == SmoothnessSource.Metallic);
		}
		EditorGUI.indentLevel -= 3;
	}

	void DoSecondary() {
		GUILayout.Label("Secondary Maps", EditorStyles.boldLabel);
		MaterialProperty detailTex = FindProperty("_DetailTex");
		editor.TexturePropertySingleLine(MakeLabel(detailTex, "Albedo(RGB) multiplied by 2"), detailTex);
		DoSecondaryNormals();
		editor.TextureScaleOffsetProperty(detailTex);
	}

	void DoSecondaryNormals() {
		MaterialProperty map = FindProperty("_DetailNormalMap");
		editor.TexturePropertySingleLine(MakeLabel(map), map, map.textureValue ? FindProperty("_DetailBumpScale") : null);
	}

	MaterialProperty FindProperty(string name) {
		return FindProperty(name, properties);
	}

	static GUIContent MakeLabel(string text, string tooltip = null) {
		staticLabel.text = text;
		staticLabel.tooltip = tooltip;
		return staticLabel;
	}

	static GUIContent MakeLabel(MaterialProperty property, string tooltip = null) {
		staticLabel.text = property.displayName;
		staticLabel.tooltip = tooltip;
		return staticLabel;
	}

	void SetKeyword(string keyword, bool state) {
		if (state) {
			target.EnableKeyword(keyword);
		} else {
			target.DisableKeyword(keyword);
		}
	}

	// 追踪 keyword 选用
	bool IsKeywordEnabled (string keyword) {
		return target.IsKeywordEnabled(keyword);
	}

	void RecordAction (string label) {
		editor.RegisterPropertyChangeUndo(label);
	}
}