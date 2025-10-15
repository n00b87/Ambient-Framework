path_separator$ = "/" : If OS$ = "WINDOWS" : path_separator$ = "\\" : End If


Const SN_MESH_TYPE_NORMAL = 0
Const SN_MESH_TYPE_ZIPPED = 1
Const SN_MESH_TYPE_AN8_SCENE = 2

Const SN_LIGHT_TYPE_POINT = 0
Const SN_LIGHT_TYPE_SPOT = 1
Const SN_LIGHT_TYPE_DIRECTIONAL = 2

Const SN_PARTICLE_TYPE_POINT = 0
Const SN_PARTICLE_TYPE_BOX = 1
Const SN_PARTICLE_TYPE_SPHERE = 2
Const SN_PARTICLE_TYPE_CYLINDER = 3
Const SN_PARTICLE_TYPE_MESH = 4
Const SN_PARTICLE_TYPE_RING = 5

Const SN_PHYSICS_SHAPE_NONE = 0
Const SN_PHYSICS_SHAPE_BOX = 1
Const SN_PHYSICS_SHAPE_SPHERE = 2
Const SN_PHYSICS_SHAPE_CYLINDER = 3
Const SN_PHYSICS_SHAPE_CAPSULE = 4
Const SN_PHYSICS_SHAPE_CONE = 5
Const SN_PHYSICS_SHAPE_CONVEXHULL = 6
Const SN_PHYSICS_SHAPE_TRIMESH = 7

Const SN_ACTOR_TYPE_ANIMATED = 0
Const SN_ACTOR_TYPE_OCTREE = 1
Const SN_ACTOR_TYPE_LIGHT = 2
Const SN_ACTOR_TYPE_BILLBOARD = 3
Const SN_ACTOR_TYPE_TERRAIN = 4
Const SN_ACTOR_TYPE_WATER = 5
Const SN_ACTOR_TYPE_PARTICLE = 6
Const SN_ACTOR_TYPE_CUBE = 7
Const SN_ACTOR_TYPE_SPHERE = 8
Const SN_ACTOR_TYPE_PLANE = 9

Const SN_SKY_TYPE_NONE = 0
Const SN_SKY_TYPE_BOX = 1
Const SN_SKY_TYPE_DOME = 2


Type Serenity_Vector3D
Dim x
Dim y
Dim z
End Type

Type Serenity_Size
Dim Width
Dim Height
Dim Depth
End Type

Function Serenity_CreateVector3D(x, y, z) As Serenity_Vector3D
	Dim v As Serenity_Vector3D
	v.x = x
	v.y = y
	v.z = z
	Return v
End Function

Function Serenity_CreateSize3D(w, h, d) As Serenity_Size
	Dim v As Serenity_Size
	v.width = w
	v.height = h
	v.depth = d
	Return v
End Function

Type Serenity_Texture
Dim ID
Dim Name$
Dim File$ 
Dim UseColorKey
Dim TextureColorKey 
End Type

Type Serenity_Texture_Reference
Dim SN_ID
End Type

Dim Serenity_Global_Texture_List[2] As Serenity_Texture

Type Serenity_Textures_List_Structure
Dim texture_id0 As Serenity_Texture_Reference
Dim texture_id1 As Serenity_Texture_Reference
End Type


Type Serenity_Material
Dim ID
Dim Name$
Dim Texture_Matrix 'Index in Serenity_Global_Texture_List
End Type

Type Serenity_Material_Reference
Dim SN_ID
End Type

Dim Serenity_Global_Material_List[3] As Serenity_Material

Type Serenity_Materials_List_Structure
Dim material_id0 As Serenity_Material_Reference
Dim material_id1 As Serenity_Material_Reference
Dim material_id2 As Serenity_Material_Reference
End Type


Type Serenity_Mesh_Animation
Dim Name$ 
Dim Start_Frame
Dim End_Frame
Dim Speed
End Type

Dim Serenity_Global_Mesh_Animation_List[3] As Serenity_Mesh_Animation

Type Serenity_Mesh
Dim ID 
Dim SN_ID
Dim Name$
Dim MeshType 
Dim AN8_Index 
Dim AN8_Scene$ 
Dim Zip$ 
Dim File$ 
Dim Material_Matrix 
Dim MaterialCount 
Dim Animation_Matrix
Dim AnimationCount 
Dim ColliderMesh_SN_ID 
End Type

Type Serenity_Mesh_Reference
Dim SN_ID
End Type

Dim Serenity_Global_AN8ID_List[1]
Dim Serenity_Global_Mesh_List[3] As Serenity_Mesh


Type Serenity_Meshes_List_Structure 
Dim mesh_id0 As Serenity_Mesh_Reference 
Dim mesh_id1 As Serenity_Mesh_Reference 
Dim mesh_id2 As Serenity_Mesh_Reference 
End Type

Type Serenity_Sky_Dome
Dim Image 
Dim hRes 
Dim vRes 
Dim TexturePCT 
Dim SpherePCT 
Dim Radius 
End Type 

Type Serenity_Sky_Box 
Dim Image_Left 
Dim Image_Right 
Dim Image_Top 
Dim Image_Bottom 
Dim Image_Front 
Dim Image_Back 
End Type 

Type Serenity_Sky_Structure
Dim Shape 
Dim Dome As Serenity_Sky_Dome 
Dim Box As Serenity_Sky_Box 
End Type 


Type Serenity_Actor_Physics
Dim Shape
Dim Mass
Dim isSolid
End Type

Type Serenity_Light_Properties
Dim LightType
Dim CastShadow
Dim InnerCone
Dim OuterCone
Dim Radius
Dim FallOff
Dim Ambient
Dim Diffuse
Dim Specular
Dim Constant
Dim Linear
Dim Quadratic
End Type

Type Serenity_Terrain_Properties
Dim HeightMap$
End Type

Type Serenity_ActorAnimation_Properties
Dim AnimationID
Dim NumLoops
End Type

Type Serenity_Water_Properties
Dim WaveHeight
Dim WaveLength
Dim WaveSpeed
End Type

Type Serenity_Particle_Properties
Dim ParticleType
Dim MinSize As Serenity_Size
Dim MaxSize As Serenity_Size
Dim MinStartColor
Dim MaxStartColor
Dim MinSpeed
Dim MaxSpeed
Dim MinLife
Dim MaxLife
Dim Normal As Serenity_Vector3D
Dim Direction As Serenity_Vector3D
Dim MaxAngle
Dim CircleCenter As Serenity_Vector3D
Dim Radius
Dim UseEveryVertex
Dim UseNormalDirection
Dim NormalDirectionModifier
Dim CylinderLength
Dim UseOutlineOnly
Dim MinBoxSize As Serenity_Size
Dim MaxBoxSize As Serenity_Size
Dim RingThickness
End Type

Type Serenity_Actor
Dim ID 
Dim SN_ID 
Dim Name$
Dim ActorType 
Dim Mesh  'Index in Global Mesh list
Dim Collider_ID 'Collision Actor (NOTE: Will be -1 by default
Dim Position As Serenity_Vector3D
Dim Rotation As Serenity_Vector3D
Dim Scale As Serenity_Vector3D
Dim Material
Dim Shadow
Dim AutoCulling
Dim Physics As Serenity_Actor_Physics
Dim Animation As Serenity_ActorAnimation_Properties
Dim Light As Serenity_Light_Properties
Dim Terrain As Serenity_Terrain_Properties
Dim Water As Serenity_Water_Properties
Dim Particle As Serenity_Particle_Properties
Dim CubeSize
Dim SphereRadius
Dim Visible
End Type 


Dim Textures As Serenity_Textures_List_Structure
'TEXTURES ARE LOADED AND UNLOADED WHEN LOADSTAGE() IS CALLED
Textures.texture_id0.SN_ID = 0
Serenity_Global_Texture_List[Textures.texture_id0.SN_ID].ID = -1
Serenity_Global_Texture_List[Textures.texture_id0.SN_ID].Name$ = "texture_id0"
Serenity_Global_Texture_List[Textures.texture_id0.SN_ID].File$ = "grass2.png"
Serenity_Global_Texture_List[Textures.texture_id0.SN_ID].TextureColorKey = 0

Textures.texture_id1.SN_ID = 1
Serenity_Global_Texture_List[Textures.texture_id1.SN_ID].ID = -1
Serenity_Global_Texture_List[Textures.texture_id1.SN_ID].Name$ = "texture_id1"
Serenity_Global_Texture_List[Textures.texture_id1.SN_ID].File$ = "survivorMaleB.png"
Serenity_Global_Texture_List[Textures.texture_id1.SN_ID].TextureColorKey = 0


Dim Materials As Serenity_Materials_List_Structure
'-----------------DEFINE MATERIALS---------------
'------------MATERIAL[ material_id0 ]---------------
Materials.material_id0.SN_ID = 0
Serenity_Global_Material_List[Materials.material_id0.SN_ID].Name$ = "material_id0"

Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID = CreateMaterial() 
SetMaterialAmbientColor(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, 4294967295) 
SetMaterialDiffuseColor(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, 4294967295) 
SetMaterialEmissiveColor(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, 0) 
SetMaterialSpecularColor(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, 4294967295) 
SetMaterialAntiAliasing(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, AA_MODE_SIMPLE ) 
SetMaterialBackfaceCulling(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, TRUE) 
SetMaterialFrontfaceCulling(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, FALSE) 
SetMaterialBlendFactor(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, 0) 
SetMaterialBlendMode(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, BLEND_MODE_NONE ) 
SetMaterialColorMask(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, COLOR_MASK_ALL ) 
SetMaterialColorMode(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, COLOR_MODE_DIFFUSE ) 
SetMaterialFog(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, FALSE) 
SetMaterialGouraudShading(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, TRUE) 
SetMaterialLighting(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, TRUE) 
SetMaterialType(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, MATERIAL_TYPE_SOLID ) 
SetMaterialNormalize(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, FALSE) 
SetMaterialPointCloud(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, FALSE) 
SetMaterialShininess(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, 0) 
SetMaterialThickness(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, 1) 
SetMaterialWireframe(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, FALSE) 

Serenity_Global_Material_List[Materials.material_id0.SN_ID].Texture_Matrix = DimMatrix(1, 1)

SetMatrixValue(Serenity_Global_Material_List[Materials.material_id0.SN_ID].Texture_Matrix, 0, 0, Textures.texture_id0.SN_ID)


'------------MATERIAL[ material_id1 ]---------------
Materials.material_id1.SN_ID = 1
Serenity_Global_Material_List[Materials.material_id1.SN_ID].Name$ = "material_id1"

Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID = CreateMaterial() 
SetMaterialAmbientColor(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, 4294967295) 
SetMaterialDiffuseColor(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, 4294967295) 
SetMaterialEmissiveColor(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, 0) 
SetMaterialSpecularColor(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, 4294967295) 
SetMaterialAntiAliasing(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, AA_MODE_SIMPLE ) 
SetMaterialBackfaceCulling(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, TRUE) 
SetMaterialFrontfaceCulling(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, FALSE) 
SetMaterialBlendFactor(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, 0) 
SetMaterialBlendMode(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, BLEND_MODE_NONE ) 
SetMaterialColorMask(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, COLOR_MASK_ALL ) 
SetMaterialColorMode(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, COLOR_MODE_DIFFUSE ) 
SetMaterialFog(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, FALSE) 
SetMaterialGouraudShading(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, TRUE) 
SetMaterialLighting(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, FALSE) 
SetMaterialType(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, MATERIAL_TYPE_SOLID ) 
SetMaterialNormalize(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, FALSE) 
SetMaterialPointCloud(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, FALSE) 
SetMaterialShininess(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, 0) 
SetMaterialThickness(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, 1) 
SetMaterialWireframe(Serenity_Global_Material_List[Materials.material_id1.SN_ID].ID, FALSE) 

Serenity_Global_Material_List[Materials.material_id1.SN_ID].Texture_Matrix = DimMatrix(1, 0)



'------------MATERIAL[ material_id2 ]---------------
Materials.material_id2.SN_ID = 2
Serenity_Global_Material_List[Materials.material_id2.SN_ID].Name$ = "material_id2"

Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID = CreateMaterial() 
SetMaterialAmbientColor(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, 4294967295) 
SetMaterialDiffuseColor(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, 4294967295) 
SetMaterialEmissiveColor(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, 0) 
SetMaterialSpecularColor(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, 4294967295) 
SetMaterialAntiAliasing(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, AA_MODE_SIMPLE ) 
SetMaterialBackfaceCulling(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, TRUE) 
SetMaterialFrontfaceCulling(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, FALSE) 
SetMaterialBlendFactor(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, 0) 
SetMaterialBlendMode(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, BLEND_MODE_NONE ) 
SetMaterialColorMask(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, COLOR_MASK_ALL ) 
SetMaterialColorMode(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, COLOR_MODE_DIFFUSE ) 
SetMaterialFog(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, FALSE) 
SetMaterialGouraudShading(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, TRUE) 
SetMaterialLighting(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, TRUE) 
SetMaterialType(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, MATERIAL_TYPE_SOLID ) 
SetMaterialNormalize(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, FALSE) 
SetMaterialPointCloud(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, FALSE) 
SetMaterialShininess(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, 0) 
SetMaterialThickness(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, 1) 
SetMaterialWireframe(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, FALSE) 

Serenity_Global_Material_List[Materials.material_id2.SN_ID].Texture_Matrix = DimMatrix(1, 1)

SetMatrixValue(Serenity_Global_Material_List[Materials.material_id2.SN_ID].Texture_Matrix, 0, 0, Textures.texture_id1.SN_ID)



Dim Meshes As Serenity_Meshes_List_Structure
'-----------------DEFINE MESHES---------------
'-----MESH[ mesh_id0 ]------------
Meshes.mesh_id0.SN_ID = 0
Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].Name$ = "mesh_id0"
Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].ColliderMesh_SN_ID = -1
Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].MeshType = SN_MESH_TYPE_NORMAL
Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].File$ = "level_collision.obj"

Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].AnimationCount = 0
Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].Animation_Matrix = DimMatrix(1, Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].AnimationCount)

Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].MaterialCount = 1
Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].Material_Matrix = DimMatrix(1, Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].MaterialCount)
SetMatrixValue(Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].Material_Matrix, 0, 0, Materials.material_id0.SN_ID)

'-----MESH[ mesh_id1 ]------------
Meshes.mesh_id1.SN_ID = 1
Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].Name$ = "mesh_id1"
Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].ColliderMesh_SN_ID = -1
Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].MeshType = SN_MESH_TYPE_NORMAL
Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].File$ = "Old_T-Pose.obj"

Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].AnimationCount = 0
Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].Animation_Matrix = DimMatrix(1, Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].AnimationCount)

Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].MaterialCount = 1
Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].Material_Matrix = DimMatrix(1, Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].MaterialCount)
SetMatrixValue(Serenity_Global_Mesh_List[Meshes.mesh_id1.SN_ID].Material_Matrix, 0, 0, Materials.material_id1.SN_ID)

'-----MESH[ mesh_id2 ]------------
Meshes.mesh_id2.SN_ID = 2
Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].Name$ = "mesh_id2"
Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].ColliderMesh_SN_ID = -1
Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].MeshType = SN_MESH_TYPE_NORMAL
Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].File$ = "char.ms3d"

Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].AnimationCount = 3
Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].Animation_Matrix = DimMatrix(1, Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].AnimationCount)
Serenity_Global_Mesh_Animation_List[0].Name$ = "IDLE"
Serenity_Global_Mesh_Animation_List[0].Start_Frame = 1
Serenity_Global_Mesh_Animation_List[0].End_Frame = 12
Serenity_Global_Mesh_Animation_List[0].Speed = 8
SetMatrixValue(Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].Animation_Matrix, 0, 0, 0)

Serenity_Global_Mesh_Animation_List[1].Name$ = "RUN"
Serenity_Global_Mesh_Animation_List[1].Start_Frame = 13
Serenity_Global_Mesh_Animation_List[1].End_Frame = 36
Serenity_Global_Mesh_Animation_List[1].Speed = 15
SetMatrixValue(Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].Animation_Matrix, 0, 1, 1)

Serenity_Global_Mesh_Animation_List[2].Name$ = "JUMP"
Serenity_Global_Mesh_Animation_List[2].Start_Frame = 36
Serenity_Global_Mesh_Animation_List[2].End_Frame = 36
Serenity_Global_Mesh_Animation_List[2].Speed = 1
SetMatrixValue(Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].Animation_Matrix, 0, 2, 2)


Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].MaterialCount = 1
Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].Material_Matrix = DimMatrix(1, Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].MaterialCount)
SetMatrixValue(Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].Material_Matrix, 0, 0, Materials.material_id2.SN_ID)



Dim Serenity_Global_Actor_List[3] As Serenity_Actor

Type Serenity_Stage
Dim ID
Dim Name$
Dim ActorCount
Dim Actor_Matrix
Dim Sky As Serenity_Sky_Structure
Dim GroupName$[1]
Dim GroupCount
End Type
Dim Serenity_Global_Stage_List[1] As Serenity_Stage

Type Serenity_Current_Stage_Structure
Dim StageID
Dim HasSky
End Type

Dim Serenity_Current_Stage As Serenity_Current_Stage_Structure

'-----------------DEFINE STAGES---------------
'----------------INIT STAGE: [ st1 ]-----------------------
Serenity_Global_Stage_List[0].ID = 0
Serenity_Global_Stage_List[0].ActorCount = 3

Serenity_Global_Stage_List[0].Actor_Matrix = DimMatrix(2, 3)
'-----------ACTOR [ Serenity_Global_Stage_List[0].Actors.tl ]----------------
Serenity_Global_Actor_List[0].Name$ = "tl"
Serenity_Global_Actor_List[0].SN_ID = 0

SetMatrixValue(Serenity_Global_Stage_List[0].Actor_Matrix, 0, 0, 0)
SetMatrixValue(Serenity_Global_Stage_List[0].Actor_Matrix, 1, 0, -1)
Serenity_Global_Actor_List[0].ID = -1
Serenity_Global_Actor_List[0].ActorType = SN_ACTOR_TYPE_OCTREE
Serenity_Global_Actor_List[0].Mesh = Meshes.mesh_id0.SN_ID
Serenity_Global_Actor_List[0].Position = Serenity_CreateVector3D(0, 0, -2878.3)
Serenity_Global_Actor_List[0].Rotation = Serenity_CreateVector3D(0, 0, 0)
Serenity_Global_Actor_List[0].Scale = Serenity_CreateVector3D(4, 4, 4)
Serenity_Global_Actor_List[0].Shadow = FALSE
Serenity_Global_Actor_List[0].AutoCulling = AUTOCULLING_BOX
Serenity_Global_Actor_List[0].Visible = TRUE
Serenity_Global_Actor_List[0].Physics.isSolid = TRUE
Serenity_Global_Actor_List[0].Physics.Mass = 0
Serenity_Global_Actor_List[0].Physics.Shape = 7

'-----------ACTOR [ Serenity_Global_Stage_List[0].Actors.point_light ]----------------
Serenity_Global_Actor_List[1].Name$ = "point_light"
Serenity_Global_Actor_List[1].SN_ID = 1

SetMatrixValue(Serenity_Global_Stage_List[0].Actor_Matrix, 0, 1, 1)
SetMatrixValue(Serenity_Global_Stage_List[0].Actor_Matrix, 1, 1, -1)
Serenity_Global_Actor_List[1].ID = -1
Serenity_Global_Actor_List[1].ActorType = SN_ACTOR_TYPE_LIGHT
Serenity_Global_Actor_List[1].Position = Serenity_CreateVector3D(134.357, 180, -2288.61)
Serenity_Global_Actor_List[1].Rotation = Serenity_CreateVector3D(29.9621, -135.036, 32.9893)
Serenity_Global_Actor_List[1].Scale = Serenity_CreateVector3D(1, 1, 1)
Serenity_Global_Actor_List[1].Shadow = FALSE
Serenity_Global_Actor_List[1].AutoCulling = AUTOCULLING_BOX
Serenity_Global_Actor_List[1].Visible = TRUE
Serenity_Global_Actor_List[1].Physics.isSolid = FALSE
Serenity_Global_Actor_List[1].Physics.Mass = 0
Serenity_Global_Actor_List[1].Physics.Shape = 2
Serenity_Global_Actor_List[1].Light.LightType = SN_LIGHT_TYPE_POINT
Serenity_Global_Actor_List[1].Light.CastShadow = TRUE
Serenity_Global_Actor_List[1].Light.InnerCone = 20
Serenity_Global_Actor_List[1].Light.OuterCone = 30
Serenity_Global_Actor_List[1].Light.FallOff = 500
Serenity_Global_Actor_List[1].Light.Ambient = 4278212480
Serenity_Global_Actor_List[1].Light.Diffuse = 4284141880
Serenity_Global_Actor_List[1].Light.Specular = 4293998556
Serenity_Global_Actor_List[1].Light.Radius = 250

'-----------ACTOR [ Serenity_Global_Stage_List[0].Actors.gy ]----------------
Serenity_Global_Actor_List[2].Name$ = "gy"
Serenity_Global_Actor_List[2].SN_ID = 2

SetMatrixValue(Serenity_Global_Stage_List[0].Actor_Matrix, 0, 2, 2)
SetMatrixValue(Serenity_Global_Stage_List[0].Actor_Matrix, 1, 2, -1)
Serenity_Global_Actor_List[2].ID = -1
Serenity_Global_Actor_List[2].ActorType = SN_ACTOR_TYPE_ANIMATED
Serenity_Global_Actor_List[2].Mesh = Meshes.mesh_id2.SN_ID
Serenity_Global_Actor_List[2].Position = Serenity_CreateVector3D(77.5425, 86.7411, -2330.23)
Serenity_Global_Actor_List[2].Rotation = Serenity_CreateVector3D(0, 0, 0)
Serenity_Global_Actor_List[2].Scale = Serenity_CreateVector3D(4, 4, 4)
Serenity_Global_Actor_List[2].Shadow = TRUE
Serenity_Global_Actor_List[2].AutoCulling = AUTOCULLING_OFF
Serenity_Global_Actor_List[2].Visible = TRUE
Serenity_Global_Actor_List[2].Physics.isSolid = TRUE
Serenity_Global_Actor_List[2].Physics.Mass = 20
Serenity_Global_Actor_List[2].Physics.Shape = 4


'------------[STAGE LOAD FUNCTIONS]-----------
Sub Load_st1( )
	Serenity_Current_Stage.StageID = 0

	'---------STAGE TEXTURES-------------
	Serenity_Global_Texture_List[ Textures.texture_id0.SN_ID ].ID = LoadImage("textures" + path_separator$ + Serenity_Global_Texture_List[Textures.texture_id0.SN_ID].File$)
	Serenity_Global_Texture_List[ Textures.texture_id1.SN_ID ].ID = LoadImage("textures" + path_separator$ + Serenity_Global_Texture_List[Textures.texture_id1.SN_ID].File$)


	'---------STAGE MATERIALS-------------
	SetMaterialTexture(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, 0, Serenity_Global_Texture_List[Textures.texture_id0.SN_ID].ID ) 
	
	SetMaterialTexture(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, 0, Serenity_Global_Texture_List[Textures.texture_id1.SN_ID].ID ) 
	


	'---------STAGE AN8-------------


	'---------STAGE MESHES-------------
	Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].ID = LoadMesh("models" + path_separator$ + "level_collision.obj")

	Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].ID = LoadMesh("models" + path_separator$ + "char.ms3d")




	Serenity_Global_Actor_List[0].ID =  CreateOctreeActor( Serenity_Global_Mesh_List[Serenity_Global_Actor_List[0].Mesh].ID ) 

	SetActorPosition( Serenity_Global_Actor_List[0].ID, Serenity_Global_Actor_List[0].Position.X, Serenity_Global_Actor_List[0].Position.Y, Serenity_Global_Actor_List[0].Position.Z ) 
	SetActorRotation( Serenity_Global_Actor_List[0].ID, 0, Serenity_Global_Actor_List[0].Rotation.Y, 0 ) 
	RotateActor( Serenity_Global_Actor_List[0].ID, Serenity_Global_Actor_List[0].Rotation.X, 0, 0 ) 
	RotateActor( Serenity_Global_Actor_List[0].ID, 0, 0, Serenity_Global_Actor_List[0].Rotation.Z ) 
	SetActorScale( Serenity_Global_Actor_List[0].ID, Serenity_Global_Actor_List[0].Scale.X, Serenity_Global_Actor_List[0].Scale.Y, Serenity_Global_Actor_List[0].Scale.Z ) 

	SetActorVisible( Serenity_Global_Actor_List[0].ID, Serenity_Global_Actor_List[0].Visible ) 
	SetActorAutoCulling( Serenity_Global_Actor_List[0].ID, Serenity_Global_Actor_List[0].AutoCulling ) 
	RemoveActorShadow( Serenity_Global_Actor_List[0].ID ) 


	SetActorShape( Serenity_Global_Actor_List[0].ID, Serenity_Global_Actor_List[0].Physics.Shape, Serenity_Global_Actor_List[0].Physics.Mass ) 
	SetActorSolid( Serenity_Global_Actor_List[0].ID, Serenity_Global_Actor_List[0].Physics.isSolid ) 



	SetActorMaterial( Serenity_Global_Actor_List[0].ID, 0, Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID ) 

	Serenity_Global_Actor_List[1].ID =  CreateLightActor( ) 

	SetActorPosition( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Position.X, Serenity_Global_Actor_List[1].Position.Y, Serenity_Global_Actor_List[1].Position.Z ) 
	SetActorRotation( Serenity_Global_Actor_List[1].ID, 0, Serenity_Global_Actor_List[1].Rotation.Y, 0 ) 
	RotateActor( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Rotation.X, 0, 0 ) 
	RotateActor( Serenity_Global_Actor_List[1].ID, 0, 0, Serenity_Global_Actor_List[1].Rotation.Z ) 
	SetActorScale( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Scale.X, Serenity_Global_Actor_List[1].Scale.Y, Serenity_Global_Actor_List[1].Scale.Z ) 

	SetActorVisible( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Visible ) 
	SetActorAutoCulling( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].AutoCulling ) 

	SetLightType( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Light.LightType )
	SetLightShadowCast( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Light.CastShadow )
	SetLightInnerCone( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Light.InnerCone )
	SetLightOuterCone( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Light.OuterCone )
	SetLightFallOff( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Light.FallOff )
	SetLightAmbientColor( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Light.Ambient )
	SetLightDiffuseColor( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Light.Diffuse )
	SetLightSpecularColor( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Light.Specular )
	SetLightRadius( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Light.Radius )

	SetActorShape( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Physics.Shape, Serenity_Global_Actor_List[1].Physics.Mass ) 
	SetActorSolid( Serenity_Global_Actor_List[1].ID, Serenity_Global_Actor_List[1].Physics.isSolid ) 


	Serenity_Global_Actor_List[2].ID =  CreateAnimatedActor( Serenity_Global_Mesh_List[Serenity_Global_Actor_List[2].Mesh].ID ) 

	SetActorPosition( Serenity_Global_Actor_List[2].ID, Serenity_Global_Actor_List[2].Position.X, Serenity_Global_Actor_List[2].Position.Y, Serenity_Global_Actor_List[2].Position.Z ) 
	SetActorRotation( Serenity_Global_Actor_List[2].ID, 0, Serenity_Global_Actor_List[2].Rotation.Y, 0 ) 
	RotateActor( Serenity_Global_Actor_List[2].ID, Serenity_Global_Actor_List[2].Rotation.X, 0, 0 ) 
	RotateActor( Serenity_Global_Actor_List[2].ID, 0, 0, Serenity_Global_Actor_List[2].Rotation.Z ) 
	SetActorScale( Serenity_Global_Actor_List[2].ID, Serenity_Global_Actor_List[2].Scale.X, Serenity_Global_Actor_List[2].Scale.Y, Serenity_Global_Actor_List[2].Scale.Z ) 

	SetActorVisible( Serenity_Global_Actor_List[2].ID, Serenity_Global_Actor_List[2].Visible ) 
	SetActorAutoCulling( Serenity_Global_Actor_List[2].ID, Serenity_Global_Actor_List[2].AutoCulling ) 
	AddActorShadow( Serenity_Global_Actor_List[2].ID ) 

	Global_Animation_Index = MatrixValue(Serenity_Global_Mesh_List[Serenity_Global_Actor_List[2].Mesh].Animation_Matrix, 0, 0)
	CreateActorAnimation( Serenity_Global_Actor_List[2].ID, Serenity_Global_Mesh_Animation_List[Global_Animation_Index].Start_Frame, Serenity_Global_Mesh_Animation_List[Global_Animation_Index].End_Frame, Serenity_Global_Mesh_Animation_List[Global_Animation_Index].Speed )
	Global_Animation_Index = MatrixValue(Serenity_Global_Mesh_List[Serenity_Global_Actor_List[2].Mesh].Animation_Matrix, 0, 1)
	CreateActorAnimation( Serenity_Global_Actor_List[2].ID, Serenity_Global_Mesh_Animation_List[Global_Animation_Index].Start_Frame, Serenity_Global_Mesh_Animation_List[Global_Animation_Index].End_Frame, Serenity_Global_Mesh_Animation_List[Global_Animation_Index].Speed )
	Global_Animation_Index = MatrixValue(Serenity_Global_Mesh_List[Serenity_Global_Actor_List[2].Mesh].Animation_Matrix, 0, 2)
	CreateActorAnimation( Serenity_Global_Actor_List[2].ID, Serenity_Global_Mesh_Animation_List[Global_Animation_Index].Start_Frame, Serenity_Global_Mesh_Animation_List[Global_Animation_Index].End_Frame, Serenity_Global_Mesh_Animation_List[Global_Animation_Index].Speed )

	SetActorAnimation( Serenity_Global_Actor_List[2].ID, Serenity_Global_Actor_List[2].Animation.AnimationID, Serenity_Global_Actor_List[2].Animation.NumLoops ) 

	SetActorShape( Serenity_Global_Actor_List[2].ID, Serenity_Global_Actor_List[2].Physics.Shape, Serenity_Global_Actor_List[2].Physics.Mass ) 
	SetActorSolid( Serenity_Global_Actor_List[2].ID, Serenity_Global_Actor_List[2].Physics.isSolid ) 



	SetActorMaterial( Serenity_Global_Actor_List[2].ID, 0, Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID ) 

End Sub





'------------[STAGE CLEAR FUNCTIONS]-----------
Sub Clear_st1( )
	Serenity_Current_Stage.StageID = -1
	'---------STAGE ACTORS-------------
	DeleteActor( Serenity_Global_Actor_List[0].ID )
	Serenity_Global_Actor_List[0].ID = -1
	DeleteActor( Serenity_Global_Actor_List[1].ID )
	Serenity_Global_Actor_List[1].ID = -1
	DeleteActor( Serenity_Global_Actor_List[2].ID )
	Serenity_Global_Actor_List[2].ID = -1
	'---------STAGE MESHES-------------
	DeleteMesh( Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].ID )
	Serenity_Global_Mesh_List[Meshes.mesh_id0.SN_ID].ID = -1

	DeleteMesh( Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].ID )
	Serenity_Global_Mesh_List[Meshes.mesh_id2.SN_ID].ID = -1



	'---------STAGE AN8-------------


	'---------STAGE MATERIALS-------------
	SetMaterialTexture(Serenity_Global_Material_List[Materials.material_id0.SN_ID].ID, 0, -1 ) 
	SetMaterialTexture(Serenity_Global_Material_List[Materials.material_id2.SN_ID].ID, 0, -1 ) 


	'---------STAGE TEXTURES-------------
	DeleteImage( Serenity_Global_Texture_List[ Textures.texture_id0.SN_ID ].ID )
	Serenity_Global_Texture_List[ Textures.texture_id0.SN_ID ].ID = -1
	DeleteImage( Serenity_Global_Texture_List[ Textures.texture_id1.SN_ID ].ID )
	Serenity_Global_Texture_List[ Textures.texture_id1.SN_ID ].ID = -1


End Sub







'------------[API FUNCTIONS]-------------------
'-------TEXTURES-------
Function Serenity_GetTextureIndex(texture_name$)
	For i = 0 To 1
		If Serenity_Global_Texture_List[i].Name$ = texture_name$ Then
			Return i
		End If
	Next
	Return -1
End Function

Function Serenity_GetTextureCount()
	Return 2
End Function

Function Serenity_GetTextureID(texture_index)
	If texture_index < 0 Or texture_index >= 2 Then
		Return -1
	End If
	Return Serenity_Global_Texture_List[texture_index].ID
End Function

Function Serenity_GetTextureFile$(texture_index)
	If texture_index < 0 Or texture_index >= 2 Then
		Return ""
	End If
	Return Serenity_Global_Texture_List[texture_index].File$
End Function

Function Serenity_GetTextureColorKey(texture_index)
	If texture_index < 0 Or texture_index >= 2 Then
		Return 0
	End If
	Return Serenity_Global_Texture_List[texture_index].TextureColorKey
End Function

Function Serenity_GetTextureIsColorKey(texture_index)
	If texture_index < 0 Or texture_index >= 2 Then
		Return FALSE
	End If
	Return Serenity_Global_Texture_List[texture_index].UseColorKey
End Function

'-------MATERIALS-------
Function Serenity_GetMaterialIndex(material_name$)
	For i = 0 To 2
		If Serenity_Global_Material_List[i].Name$ = material_name$ Then
			Return i
		End If
	Next
	Return -1
End Function

Function Serenity_GetMaterialCount()
	Return 3
End Function

Function Serenity_GetMaterialID(material_index)
	If material_index < 0 Or material_index >= 3 Then
		Return -1
	End If
	Return Serenity_Global_Material_List[material_index].ID
End Function

Function Serenity_GetMaterialTextureIndex(material_index, texture_level)
	If material_index < 0 Or material_index >= 3 Then
		Return -1
	End If
	Dim r, c
	GetMatrixSize(Serenity_Global_Material_List[material_index].Texture_Matrix, r, c)
	If texture_level < 0 Or texture_level >= c Then
		Return -1
	End If
	Return MatrixValue(Serenity_Global_Material_List[material_index].Texture_Matrix, 0, texture_level)
End Function

'-------AN8-------
Function Serenity_GetAN8Count()
	Return 0
End Function

Function Serenity_GetAN8ID(an8_index)
	If an8_index < 0 Or an8_index >= 0 Then
		Return -1
	End If
	Return Serenity_Global_AN8ID_List[an8_index]
End Function

'-------MESHES-------
Function Serenity_GetMeshIndex(mesh_name$)
	For i = 0 To 2
		If Serenity_Global_Mesh_List[i].Name$ = mesh_name$ Then
			Return i
		End If
	Next
	Return -1
End Function

Function Serenity_GetMeshCount()
	Return 3
End Function

Function Serenity_GetMeshID(mesh_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return -1
	End If
	Return Serenity_Global_Mesh_List[mesh_index].ID
End Function

Function Serenity_GetMeshName$(mesh_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return ""
	End If
	Return Serenity_Global_Mesh_List[mesh_index].Name$
End Function

Function Serenity_GetMeshType(mesh_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return -1
	End If
	Return Serenity_Global_Mesh_List[mesh_index].MeshType
End Function

Function Serenity_GetMeshAN8Index(mesh_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return -1
	End If
	Return Serenity_Global_Mesh_List[mesh_index].AN8_Index
End Function

Function Serenity_GetMeshAN8Scene$(mesh_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return ""
	End If
	Return Serenity_Global_Mesh_List[mesh_index].AN8_Scene$
End Function

Function Serenity_GetMeshArchiveName$(mesh_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return ""
	End If
	Return Serenity_Global_Mesh_List[mesh_index].Zip$
End Function

Function Serenity_GetMeshFile$(mesh_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return ""
	End If
	Return Serenity_Global_Mesh_List[mesh_index].File$
End Function

Function Serenity_GetMeshMaterialCount(mesh_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return 0
	End If
	Return Serenity_Global_Mesh_List[mesh_index].MaterialCount
End Function

Function Serenity_GetMeshMaterialIndex(mesh_index, material_num)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return -1
	End If
	If material_num < 0 Or material_num >= Serenity_Global_Mesh_List[mesh_index].MaterialCount Then
		Return -1
	End If
	Return MatrixValue(Serenity_Global_Mesh_List[mesh_index].Material_Matrix, 0, material_num)
End Function

Function Serenity_GetMeshAnimationCount(mesh_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return 0
	End If
	Return Serenity_Global_Mesh_List[mesh_index].AnimationCount
End Function

Function Serenity_GetMeshAnimationID(mesh_index, animation_num)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return -1
	End If
	If animation_num < 0 Or animation_num >= Serenity_Global_Mesh_List[mesh_index].AnimationCount Then
		Return -1
	End If
	Return MatrixValue(Serenity_Global_Mesh_List[mesh_index].Animation_Matrix, 0, animation_num)+1
End Function

Function Serenity_GetMeshAnimationIDByName(mesh_index, animation_name$)
	If mesh_index < 0 Or mesh_index >= ArraySize(Serenity_Global_Mesh_List, 1) Then
		Return -1
	End If
	ani_name$ = Trim$(UCase$(animation_name$))
	For i = 0 To ArraySize(Serenity_Global_Mesh_Animation_List, 1) - 1
		If Trim$(UCase$(Serenity_Global_Mesh_Animation_List[i].Name$)) = ani_name$ Then
			Return MatrixValue(Serenity_Global_Mesh_List[mesh_index].Animation_Matrix, 0, i)+1
		End If
	Next
	Return -1
End Function

Function Serenity_GetMeshColliderIndex(mesh_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return -1
	End If
	Return Serenity_Global_Mesh_List[mesh_index].ColliderMesh_SN_ID
End Function

Sub Serenity_SetMeshColliderIndex(mesh_index, collider_index)
	If mesh_index < 0 Or mesh_index >= 3 Then
		Return
	End If
	Serenity_Global_Mesh_List[mesh_index].ColliderMesh_SN_ID = collider_index
End Sub

'-------SKY-------
Function Serenity_GetSkyShape()
	If Serenity_Current_Stage.StageID < 0 Then
		Return -1
	End If
	Return Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].Sky.Shape
End Function

Function Serenity_GetSkyBox() As Serenity_Sky_Box
	If Serenity_Current_Stage.StageID < 0 Then
		Dim tmp_sky As Serenity_Sky_Box
		Return tmp_sky
	End If
	Return Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].Sky.Box
End Function

Function Serenity_GetSkyDome() As Serenity_Sky_Dome
	If Serenity_Current_Stage.StageID < 0 Then
		Dim tmp_sky As Serenity_Sky_Dome
		Return tmp_sky
	End If
	Return Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].Sky.Dome
End Function

Function Serenity_StageHasSky()
	If Serenity_Current_Stage.StageID < 0 Then
		Return FALSE
	End If
	Return Serenity_Current_Stage.HasSky
End Function

'-------ACTORS-------
Function Serenity_GetActorIndex(actor_name$)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return -1
	End If
	For i = 0 To Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount-1
		If Serenity_Global_Actor_List[i].Name$ = actor_name$ Then
			Return i
		End If
	Next
	Return -1
End Function

Function Serenity_GetActorCount()
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return 0
	End If
	Return Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount
End Function

Function Serenity_GetActorID(actor_index)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return -1
	End If
	If actor_index < 0 Or actor_index >= Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount Then
		Return -1
	End If
	Return Serenity_Global_Actor_List[actor_index].ID
End Function

Function Serenity_GetActorName$(actor_index)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return ""
	End If
	If actor_index < 0 Or actor_index >= Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount Then
		Return ""
	End If
	Return Serenity_Global_Actor_List[actor_index].Name$
End Function

Function Serenity_GetActorType(actor_index)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return -1
	End If
	If actor_index < 0 Or actor_index >= Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount Then
		Return -1
	End If
	Return Serenity_Global_Actor_List[actor_index].ActorType
End Function

Function Serenity_GetActorMeshIndex(actor_index)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return -1
	End If
	If actor_index < 0 Or actor_index >= Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount Then
		Return -1
	End If
	Return Serenity_Global_Actor_List[actor_index].Mesh
End Function

Function Serenity_GetActorOverrideMaterialIndex(actor_index)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return -1
	End If
	If actor_index < 0 Or actor_index >= Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount Then
		Return -1
	End If
	Return Serenity_Global_Actor_List[actor_index].Material
End Function

Function Serenity_GetActorTerrainHeightMap$(actor_index)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return ""
	End If
	If actor_index < 0 Or actor_index >= Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount Then
		Return ""
	End If
	Return Serenity_Global_Actor_List[actor_index].Terrain.HeightMap$
End Function

Function Serenity_GetActorCubeSize(actor_index)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return -1
	End If
	If actor_index < 0 Or actor_index >= Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount Then
		Return -1
	End If
	Return Serenity_Global_Actor_List[actor_index].CubeSize
End Function

Function Serenity_GetActorSphereRadius(actor_index)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return -1
	End If
	If actor_index < 0 Or actor_index >= Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount Then
		Return -1
	End If
	Return Serenity_Global_Actor_List[actor_index].SphereRadius
End Function

Function Serenity_GetActorGroupIndex(actor_index)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return -1
	End If
	If actor_index < 0 Or actor_index >= Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].ActorCount Then
		Return -1
	End If
	Return MatrixValue(Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].Actor_Matrix, 1, actor_index)
End Function

'-------STAGES-------
Function Serenity_GetStageIndex(stage_name$)
	For i = 0 To 0
		If Serenity_Global_Stage_List[i].Name$ = stage_name$ Then
			Return i
		End If
	Next
	Return -1
End Function

Function Serenity_GetStageName$(stage_index)
	If stage_index < 0 Or stage_index >= 1 Then
		Return ""
	End If
	Return Serenity_Global_Stage_List[stage_index].Name$
End Function

Function Serenity_GetStageCount()
	Return 1
End Function

Sub Serenity_ClearStage()
	Select Case Serenity_Current_Stage.StageID
	Case 0 : Clear_st1()
	End Select
End Sub

Sub Serenity_LoadStage(stage_name$)
	Serenity_ClearStage()
	Select Case stage_name$
	Case "st1" : Load_st1()
	End Select
End Sub

Function Serenity_GetCurrentStageIndex()
	Return Serenity_Current_Stage.StageID
End Function

'-------GROUPS-------
Function Serenity_GetGroupCount()
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return 0
	End If
	Return Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].GroupCount
End Function

Function Serenity_GetGroupIndex(group_name$)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return 0
	End If
	For i = 0 To Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].GroupCount-1
		If UCase$(Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].GroupName$[i]) = UCase$(group_name) Then
			Return i
		End If
	Next
	Return -1
End Function

Function Serenity_GetGroupName$(group_index)
	If Serenity_Current_Stage.StageID < 0 Or Serenity_Current_Stage.StageID >= 1 Then
		Return ""
	End If
	If group_index < 0 Or group_index >= Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].GroupCount Then
		Return ""
	End If
	Return Serenity_Global_Stage_List[Serenity_Current_Stage.StageID].GroupName$[group_index]
End Function



Include Once
