; RUN: llc -march=r600 -mcpu=SI < %s | FileCheck -check-prefix=SI -check-prefix=FUNC %s

declare float @llvm.maxnum.f32(float, float) #0
declare <2 x float> @llvm.maxnum.v2f32(<2 x float>, <2 x float>) #0
declare <4 x float> @llvm.maxnum.v4f32(<4 x float>, <4 x float>) #0
declare <8 x float> @llvm.maxnum.v8f32(<8 x float>, <8 x float>) #0
declare <16 x float> @llvm.maxnum.v16f32(<16 x float>, <16 x float>) #0

declare double @llvm.maxnum.f64(double, double)

; FUNC-LABEL: @test_fmax_f32
; SI: V_MAX_F32_e32
define void @test_fmax_f32(float addrspace(1)* %out, float %a, float %b) nounwind {
  %val = call float @llvm.maxnum.f32(float %a, float %b) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @test_fmax_v2f32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
define void @test_fmax_v2f32(<2 x float> addrspace(1)* %out, <2 x float> %a, <2 x float> %b) nounwind {
  %val = call <2 x float> @llvm.maxnum.v2f32(<2 x float> %a, <2 x float> %b) #0
  store <2 x float> %val, <2 x float> addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: @test_fmax_v4f32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
define void @test_fmax_v4f32(<4 x float> addrspace(1)* %out, <4 x float> %a, <4 x float> %b) nounwind {
  %val = call <4 x float> @llvm.maxnum.v4f32(<4 x float> %a, <4 x float> %b) #0
  store <4 x float> %val, <4 x float> addrspace(1)* %out, align 16
  ret void
}

; FUNC-LABEL: @test_fmax_v8f32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
define void @test_fmax_v8f32(<8 x float> addrspace(1)* %out, <8 x float> %a, <8 x float> %b) nounwind {
  %val = call <8 x float> @llvm.maxnum.v8f32(<8 x float> %a, <8 x float> %b) #0
  store <8 x float> %val, <8 x float> addrspace(1)* %out, align 32
  ret void
}

; FUNC-LABEL: @test_fmax_v16f32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
; SI: V_MAX_F32_e32
define void @test_fmax_v16f32(<16 x float> addrspace(1)* %out, <16 x float> %a, <16 x float> %b) nounwind {
  %val = call <16 x float> @llvm.maxnum.v16f32(<16 x float> %a, <16 x float> %b) #0
  store <16 x float> %val, <16 x float> addrspace(1)* %out, align 64
  ret void
}

; FUNC-LABEL: @constant_fold_fmax_f32
; SI-NOT: V_MAX_F32_e32
; SI: V_MOV_B32_e32 [[REG:v[0-9]+]], 2.0
; SI: BUFFER_STORE_DWORD [[REG]]
define void @constant_fold_fmax_f32(float addrspace(1)* %out) nounwind {
  %val = call float @llvm.maxnum.f32(float 1.0, float 2.0) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @constant_fold_fmax_f32_nan_nan
; SI-NOT: V_MAX_F32_e32
; SI: V_MOV_B32_e32 [[REG:v[0-9]+]], 0x7fc00000
; SI: BUFFER_STORE_DWORD [[REG]]
define void @constant_fold_fmax_f32_nan_nan(float addrspace(1)* %out) nounwind {
  %val = call float @llvm.maxnum.f32(float 0x7FF8000000000000, float 0x7FF8000000000000) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @constant_fold_fmax_f32_val_nan
; SI-NOT: V_MAX_F32_e32
; SI: V_MOV_B32_e32 [[REG:v[0-9]+]], 1.0
; SI: BUFFER_STORE_DWORD [[REG]]
define void @constant_fold_fmax_f32_val_nan(float addrspace(1)* %out) nounwind {
  %val = call float @llvm.maxnum.f32(float 1.0, float 0x7FF8000000000000) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @constant_fold_fmax_f32_nan_val
; SI-NOT: V_MAX_F32_e32
; SI: V_MOV_B32_e32 [[REG:v[0-9]+]], 1.0
; SI: BUFFER_STORE_DWORD [[REG]]
define void @constant_fold_fmax_f32_nan_val(float addrspace(1)* %out) nounwind {
  %val = call float @llvm.maxnum.f32(float 0x7FF8000000000000, float 1.0) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @constant_fold_fmax_f32_p0_p0
; SI-NOT: V_MAX_F32_e32
; SI: V_MOV_B32_e32 [[REG:v[0-9]+]], 0
; SI: BUFFER_STORE_DWORD [[REG]]
define void @constant_fold_fmax_f32_p0_p0(float addrspace(1)* %out) nounwind {
  %val = call float @llvm.maxnum.f32(float 0.0, float 0.0) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @constant_fold_fmax_f32_p0_n0
; SI-NOT: V_MAX_F32_e32
; SI: V_MOV_B32_e32 [[REG:v[0-9]+]], 0
; SI: BUFFER_STORE_DWORD [[REG]]
define void @constant_fold_fmax_f32_p0_n0(float addrspace(1)* %out) nounwind {
  %val = call float @llvm.maxnum.f32(float 0.0, float -0.0) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @constant_fold_fmax_f32_n0_p0
; SI-NOT: V_MAX_F32_e32
; SI: V_MOV_B32_e32 [[REG:v[0-9]+]], 0x80000000
; SI: BUFFER_STORE_DWORD [[REG]]
define void @constant_fold_fmax_f32_n0_p0(float addrspace(1)* %out) nounwind {
  %val = call float @llvm.maxnum.f32(float -0.0, float 0.0) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @constant_fold_fmax_f32_n0_n0
; SI-NOT: V_MAX_F32_e32
; SI: V_MOV_B32_e32 [[REG:v[0-9]+]], 0x80000000
; SI: BUFFER_STORE_DWORD [[REG]]
define void @constant_fold_fmax_f32_n0_n0(float addrspace(1)* %out) nounwind {
  %val = call float @llvm.maxnum.f32(float -0.0, float -0.0) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @fmax_var_immediate_f32
; SI: V_MAX_F32_e64 {{v[0-9]+}}, 2.0, {{s[0-9]+}}
define void @fmax_var_immediate_f32(float addrspace(1)* %out, float %a) nounwind {
  %val = call float @llvm.maxnum.f32(float %a, float 2.0) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @fmax_immediate_var_f32
; SI: V_MAX_F32_e64 {{v[0-9]+}}, 2.0, {{s[0-9]+}}
define void @fmax_immediate_var_f32(float addrspace(1)* %out, float %a) nounwind {
  %val = call float @llvm.maxnum.f32(float 2.0, float %a) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @fmax_var_literal_f32
; SI: V_MOV_B32_e32 [[REG:v[0-9]+]], 0x42c60000
; SI: V_MAX_F32_e32 {{v[0-9]+}}, {{s[0-9]+}}, [[REG]]
define void @fmax_var_literal_f32(float addrspace(1)* %out, float %a) nounwind {
  %val = call float @llvm.maxnum.f32(float %a, float 99.0) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @fmax_literal_var_f32
; SI: V_MOV_B32_e32 [[REG:v[0-9]+]], 0x42c60000
; SI: V_MAX_F32_e32 {{v[0-9]+}}, {{s[0-9]+}}, [[REG]]
define void @fmax_literal_var_f32(float addrspace(1)* %out, float %a) nounwind {
  %val = call float @llvm.maxnum.f32(float 99.0, float %a) #0
  store float %val, float addrspace(1)* %out, align 4
  ret void
}

attributes #0 = { nounwind readnone }
