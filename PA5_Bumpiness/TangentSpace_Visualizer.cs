// 可视化切线空间。normal-green, targent-red, binormal-blue.
using UnityEngine;

public class TangentSpace_Visualizer : MonoBehaviour {
    // 调整可视化 lines 的长度和位置偏移（不会紧贴在表面）
    public float offset = 0.01f;
    public float scale = 0.1f;

    void OnDrawGizmos () {
        MeshFilter filter = GetComponent<MeshFilter>();
        if (filter) {
            Mesh mesh = filter.sharedMesh;
            if (mesh) {
                ShowTangentSpace(mesh);
            }
        }
    }

    void ShowTangentSpace (Mesh mesh) {
        Vector3[] vertices = mesh.vertices;
        Vector3[] normals = mesh.normals;
        Vector4[] tangents = mesh.tangents;
        for (int i = 0; i < vertices.Length; i++) {
            ShowTangentSpace(
                             transform.TransformPoint(vertices[i]),
                             transform.TransformDirection(normals[i]),
                             transform.TransformDirection(tangents[i]),
                             tangents[i].w
                            );
        }
    }

    void ShowTangentSpace (
        Vector3 vertex, Vector3 normal, Vector3 tangent, float binormalSign
    ) {
        vertex += normal * offset;
        Gizmos.color = Color.green;
        Gizmos.DrawLine(vertex, vertex + normal * scale);
        Gizmos.color = Color.red;
        Gizmos.DrawLine(vertex, vertex + tangent * scale);
        Vector3 binormal = Vector3.Cross(normal, tangent) * binormalSign;
        Gizmos.color = Color.blue;
        Gizmos.DrawLine(vertex, vertex + binormal * scale);
    }
}