using UnityEngine;
using UnityEditor;

public class MixMetalAndNonMetal_GUI: ShaderGUI {
	static GUIContent staticLabel = new GUIContent();
	// STEP 3: 声明 Material 类型对象
	Material target;
	MaterialEditor editor;
	MaterialProperty[] properties;

	public override void OnGUI(
		MaterialEditor editor, MaterialProperty[] properties
	) {
		// STEP 3: 将 Material 类型 target 赋值为 MaterialEditor.target 方法获取的材质
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
		// STEP 3: BeginChangeCheck & EndChangeCheck 函数监控调用 SetKeyword 函数
		EditorGUI.BeginChangeCheck();
		// STEP 3: 添加材质选择窗口，调整 slider 与 map 逻辑为 “OR”
		editor.TexturePropertySingleLine(MakeLabel(map, "Metallic(R)"), map, map.textureValue ? null : FindProperty("_Metallic"));
		if (EditorGUI.EndChangeCheck()) {
			SetKeyword("_METALLIC_MAP", map.textureValue);
		}
	}

	void DoSmoothness() {
		MaterialProperty slider = FindProperty("_Smoothness");
		EditorGUI.indentLevel += 2;
		editor.ShaderProperty(slider, MakeLabel(slider));
		EditorGUI.indentLevel -= 2;
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

	// STEP 3: SetKeyword 函数设置关键字启用状态
	void SetKeyword(string keyword, bool state) {
		if (state) {
			target.EnableKeyword(keyword);
		} else {
			target.DisableKeyword(keyword);
		}
	}
}