#Based on Procedural Toolkit by Syomus (https://github.com/Syomus/ProceduralToolkit)
@tool
extends PrimitiveMesh
class_name TetrahedronMesh

@export var radius : float = 1.0 :
	get:
		return radius
	set(p_value):
		radius = p_value
		request_update()

func PointOnSpheroid(p_radius : float, p_height: float, p_horizontal_angle : float, p_vertical_angle : float) -> Vector3:
	var h_radians := deg_to_rad(p_horizontal_angle)
	var v_radians := deg_to_rad(p_vertical_angle)
	var cos_vertical := cos(v_radians)

	var x := p_radius * sin(h_radians) * cos_vertical
	var y := p_height * sin(v_radians)
	var z := p_radius * cos(h_radians) * cos_vertical

	return Vector3(x, y, z)


func PointOnSphere(p_radius : float, p_horizontal_angle : float, p_vertical_angle : float) -> Vector3:
	return PointOnSpheroid(p_radius, p_radius, p_horizontal_angle, p_vertical_angle)


func AddTriangleVertices(p_vert_array : PackedVector3Array, p_v0 : Vector3, p_v1 : Vector3, p_v2 : Vector3) -> void:
	p_vert_array.push_back(p_v0)
	p_vert_array.push_back(p_v1)
	p_vert_array.push_back(p_v2)


func AddTriangleNormals(p_normal_array : PackedVector3Array, p_v0 : Vector3, p_v1 : Vector3, p_v2 : Vector3) -> void:
	var normal := (p_v2 - p_v0).cross(p_v1 - p_v0).normalized()

	p_normal_array.push_back(normal)
	p_normal_array.push_back(normal)
	p_normal_array.push_back(normal)


func AddTriangleUV(p_vert_array : PackedVector2Array, p_uv0 : Vector2, p_uv1 : Vector2, p_uv2 : Vector2) -> void:
	p_vert_array.push_back(p_uv0)
	p_vert_array.push_back(p_uv1)
	p_vert_array.push_back(p_uv2)

func _create_mesh_array() -> Array:
	const tetra_angle : float = -19.471220333

	var verts := PackedVector3Array()
	var vertex0 := Vector3(0, radius, 0)
	var vertex1 = PointOnSphere(radius, 0, tetra_angle)
	var vertex2 = PointOnSphere(radius, 120, tetra_angle)
	var vertex3 = PointOnSphere(radius, 240, tetra_angle)

	AddTriangleVertices(verts, vertex0, vertex2, vertex1)
	AddTriangleVertices(verts, vertex0, vertex3, vertex2)
	AddTriangleVertices(verts, vertex0, vertex1, vertex3)
	AddTriangleVertices(verts, vertex2, vertex3, vertex1)		#bottom

#region UV gen
	var uvs := PackedVector2Array()
	var uv0 := Vector2(0, 0)
	var uv1 := Vector2(0.5, 1)
	var uv2 := Vector2(1, 0)

	AddTriangleUV(uvs, uv0, uv1, uv2)
	AddTriangleUV(uvs, uv0, uv1, uv2)
	AddTriangleUV(uvs, uv0, uv1, uv2)
	AddTriangleUV(uvs, uv0, uv1, uv2)
#endregion

	var normals := PackedVector3Array()
	var i : int = 0
	while i < verts.size():
		AddTriangleNormals(normals, verts[i], verts[i + 1], verts[i + 2])
		i += 3

	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_NORMAL] = normals

	return arrays
