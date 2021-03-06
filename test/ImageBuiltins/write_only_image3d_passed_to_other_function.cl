// RUN: clspv %s -S -o %t.spvasm
// RUN: FileCheck %s < %t.spvasm
// RUN: clspv %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

#pragma OPENCL EXTENSION cl_khr_3d_image_writes : enable

// CHECK: ; SPIR-V
// CHECK: ; Version: 1.0
// CHECK: ; Generator: Codeplay; 0
// CHECK: ; Bound: 34
// CHECK: ; Schema: 0
// CHECK: OpCapability Shader
// CHECK: OpCapability VariablePointers
// CHECK: OpExtension "SPV_KHR_variable_pointers"
// CHECK: OpMemoryModel Logical GLSL450
// CHECK: OpEntryPoint GLCompute %[[FOO_ID:[a-zA-Z0-9_]*]] "foo"
// CHECK: OpExecutionMode %[[FOO_ID]] LocalSize 1 1 1

// CHECK: OpMemberDecorate %[[ARG1_STRUCT_TYPE_ID:[a-zA-Z0-9_]*]] 0 Offset 0
// CHECK: OpDecorate %[[ARG1_STRUCT_TYPE_ID]] BufferBlock

// CHECK: OpDecorate %[[ARG2_DYNAMIC_ARRAY_TYPE_ID:[a-zA-Z0-9_]*]] ArrayStride 16

// CHECK: OpMemberDecorate %[[ARG2_STRUCT_TYPE_ID:[a-zA-Z0-9_]*]] 0 Offset 0
// CHECK: OpDecorate %[[ARG2_STRUCT_TYPE_ID]] BufferBlock

// CHECK: OpDecorate %[[ARG0_ID:[a-zA-Z0-9_]*]] DescriptorSet 0
// CHECK: OpDecorate %[[ARG0_ID]] Binding 0
// CHECK: OpDecorate %[[ARG0_ID]] NonReadable

// CHECK: OpDecorate %[[ARG1_ID:[a-zA-Z0-9_]*]] DescriptorSet 0
// CHECK: OpDecorate %[[ARG1_ID]] Binding 1

// CHECK: OpDecorate %[[ARG2_ID:[a-zA-Z0-9_]*]] DescriptorSet 0
// CHECK: OpDecorate %[[ARG2_ID]] Binding 2

// CHECK: %[[FLOAT_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFloat 32
// CHECK: %[[WRITE_ONLY_IMAGE_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeImage %[[FLOAT_TYPE_ID]] 3D 0 0 0 2 Unknown
// CHECK: %[[ARG0_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer UniformConstant %[[WRITE_ONLY_IMAGE_TYPE_ID]]
// CHECK: %[[UINT_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeInt 32 0
// CHECK: %[[UINT4_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVector %[[UINT_TYPE_ID]] 4
// CHECK: %[[ARG1_STRUCT_TYPE_ID]] = OpTypeStruct %[[UINT4_TYPE_ID]]
// CHECK: %[[ARG1_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer StorageBuffer %[[ARG1_STRUCT_TYPE_ID]]
// CHECK: %[[UINT4_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer StorageBuffer %[[UINT4_TYPE_ID]]
// CHECK: %[[FLOAT4_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVector %[[FLOAT_TYPE_ID]] 4
// CHECK: %[[FLOAT4_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer StorageBuffer %[[FLOAT4_TYPE_ID]]
// CHECK: %[[ARG2_DYNAMIC_ARRAY_TYPE_ID]] = OpTypeRuntimeArray %[[FLOAT4_TYPE_ID]]
// CHECK: %[[ARG2_STRUCT_TYPE_ID]] = OpTypeStruct %[[ARG2_DYNAMIC_ARRAY_TYPE_ID]]
// CHECK: %[[ARG2_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer StorageBuffer %[[ARG2_STRUCT_TYPE_ID]]
// CHECK: %[[VOID_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVoid
// CHECK: %[[FOO_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFunction %[[VOID_TYPE_ID]]
// CHECK: %[[BAR_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFunction %[[VOID_TYPE_ID]] %[[WRITE_ONLY_IMAGE_TYPE_ID]] %[[UINT4_TYPE_ID]] %[[FLOAT4_TYPE_ID]]

// CHECK: %[[CONSTANT_0_ID:[a-zA-Z0-9_]*]] = OpConstant %[[UINT_TYPE_ID]] 0

// CHECK: %[[ARG0_ID]] = OpVariable %[[ARG0_POINTER_TYPE_ID]] UniformConstant
// CHECK: %[[ARG1_ID]] = OpVariable %[[ARG1_POINTER_TYPE_ID]] StorageBuffer
// CHECK: %[[ARG2_ID]] = OpVariable %[[ARG2_POINTER_TYPE_ID]] StorageBuffer

// CHECK: %[[BAR_ID:[a-zA-Z0-9_]*]] = OpFunction %[[VOID_TYPE_ID]] None %[[BAR_TYPE_ID]]
// CHECK: %[[I_ID:[a-zA-Z0-9_]*]] = OpFunctionParameter %[[WRITE_ONLY_IMAGE_TYPE_ID]]
// CHECK: %[[C_ID:[a-zA-Z0-9_]*]] = OpFunctionParameter %[[UINT4_TYPE_ID]]
// CHECK: %[[A_ID:[a-zA-Z0-9_]*]] = OpFunctionParameter %[[FLOAT4_TYPE_ID]]
// CHECK: %[[BAR_LABEL_ID:[a-zA-Z0-9_]*]] = OpLabel
// CHECK: OpImageWrite %[[I_ID]] %[[C_ID]] %[[A_ID]]
// CHECK: OpReturn
// CHECK: OpFunctionEnd

void bar(write_only image3d_t i, int4 c, float4 a)
{
  write_imagef(i, c, a);
}

// CHECK: %[[FOO_ID]] = OpFunction %[[VOID_TYPE_ID]] None %[[FOO_TYPE_ID]]
// CHECK: %[[LABEL_ID:[a-zA-Z0-9_]*]] = OpLabel
// CHECK: %[[I_LOAD_ID:[a-zA-Z0-9_]*]] = OpLoad %[[WRITE_ONLY_IMAGE_TYPE_ID]] %[[ARG0_ID]]
// CHECK: %[[C_ACCESS_CHAIN_ID:[a-zA-Z0-9_]*]] = OpAccessChain %[[UINT4_POINTER_TYPE_ID]] %[[ARG1_ID]] %[[CONSTANT_0_ID]]
// CHECK: %[[C_LOAD_ID:[a-zA-Z0-9_]*]] = OpLoad %[[UINT4_TYPE_ID]] %[[C_ACCESS_CHAIN_ID]]
// CHECK: %[[A_ACCESS_CHAIN_ID:[a-zA-Z0-9_]*]] = OpAccessChain %[[FLOAT4_POINTER_TYPE_ID]] %[[ARG2_ID]] %[[CONSTANT_0_ID]] %[[CONSTANT_0_ID]]
// CHECK: %[[A_LOAD_ID:[a-zA-Z0-9_]*]] = OpLoad %[[FLOAT4_TYPE_ID]] %[[A_ACCESS_CHAIN_ID]]
// CHECK: %[[CALL_ID:[a-zA-Z0-9_]*]] = OpFunctionCall %[[VOID_TYPE_ID]] %[[BAR_ID]] %[[I_LOAD_ID]] %[[C_LOAD_ID]] %[[A_LOAD_ID]]
// CHECK: OpReturn
// CHECK: OpFunctionEnd

void kernel __attribute__((reqd_work_group_size(1, 1, 1))) foo(write_only image3d_t i, int4 c, global float4* a)
{
  bar(i, c, *a);
}
