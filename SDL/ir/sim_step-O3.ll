; ModuleID = 'ir/.logic-O3.ll'
source_filename = "src/logic/logic.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@v = external hidden unnamed_addr global [600 x [800 x float]], align 16
@u = external hidden unnamed_addr global [600 x [800 x float]], align 16
@u_next = external hidden unnamed_addr global [600 x [800 x float]], align 16
@v_next = external hidden unnamed_addr global [600 x [800 x float]], align 16

; Function Attrs: nofree noinline nosync nounwind uwtable
define hidden fastcc void @sim_step(float noundef %0, float noundef %1) unnamed_addr #0 {
  %3 = fadd float %0, %1
  %4 = fneg float %3
  %5 = insertelement <8 x float> poison, float %0, i64 0
  %6 = shufflevector <8 x float> %5, <8 x float> poison, <8 x i32> zeroinitializer
  %7 = insertelement <8 x float> poison, float %4, i64 0
  %8 = shufflevector <8 x float> %7, <8 x float> poison, <8 x i32> zeroinitializer
  br label %10

9:                                                ; preds = %109
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(1920000) bitcast ([600 x [800 x float]]* @u to i8*), i8* noundef nonnull align 16 dereferenceable(1920000) bitcast ([600 x [800 x float]]* @u_next to i8*), i64 1920000, i1 false), !tbaa !5
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(1920000) bitcast ([600 x [800 x float]]* @v to i8*), i8* noundef nonnull align 16 dereferenceable(1920000) bitcast ([600 x [800 x float]]* @v_next to i8*), i64 1920000, i1 false), !tbaa !5
  ret void

10:                                               ; preds = %109, %2
  %11 = phi i64 [ 0, %2 ], [ %12, %109 ]
  %12 = add nuw nsw i64 %11, 1
  %13 = trunc i64 %12 to i16
  %14 = urem i16 %13, 600
  %15 = trunc i64 %11 to i16
  %16 = add i16 %15, 599
  %17 = urem i16 %16, 600
  %18 = zext i16 %17 to i64
  %19 = zext i16 %14 to i64
  br label %20

20:                                               ; preds = %20, %10
  %21 = phi i64 [ 0, %10 ], [ %105, %20 ]
  %22 = phi <8 x i64> [ <i64 0, i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, i64 7>, %10 ], [ %106, %20 ]
  %23 = phi <8 x i16> [ <i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7>, %10 ], [ %107, %20 ]
  %24 = trunc <8 x i64> %22 to <8 x i16>
  %25 = add <8 x i16> %24, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %26 = urem <8 x i16> %25, <i16 800, i16 800, i16 800, i16 800, i16 800, i16 800, i16 800, i16 800>
  %27 = add <8 x i16> %23, <i16 799, i16 799, i16 799, i16 799, i16 799, i16 799, i16 799, i16 799>
  %28 = urem <8 x i16> %27, <i16 800, i16 800, i16 800, i16 800, i16 800, i16 800, i16 800, i16 800>
  %29 = zext <8 x i16> %28 to <8 x i64>
  %30 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %18, <8 x i64> %29
  %31 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %30, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %32 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %18, i64 %21
  %33 = bitcast float* %32 to <8 x float>*
  %34 = load <8 x float>, <8 x float>* %33, align 16, !tbaa !5
  %35 = fmul <8 x float> %34, <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>
  %36 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %31, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %35)
  %37 = zext <8 x i16> %26 to <8 x i64>
  %38 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %18, <8 x i64> %37
  %39 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %38, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %40 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %39, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %36)
  %41 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %11, <8 x i64> %29
  %42 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %41, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %43 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %42, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %40)
  %44 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %11, i64 %21
  %45 = bitcast float* %44 to <8 x float>*
  %46 = load <8 x float>, <8 x float>* %45, align 16, !tbaa !5
  %47 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %46, <8 x float> <float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00>, <8 x float> %43)
  %48 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %11, <8 x i64> %37
  %49 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %48, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %50 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %49, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %47)
  %51 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %19, <8 x i64> %29
  %52 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %51, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %53 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %52, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %50)
  %54 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %19, i64 %21
  %55 = bitcast float* %54 to <8 x float>*
  %56 = load <8 x float>, <8 x float>* %55, align 16, !tbaa !5
  %57 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %56, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %53)
  %58 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %19, <8 x i64> %37
  %59 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %58, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %60 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %59, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %57)
  %61 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %18, <8 x i64> %29
  %62 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %61, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %63 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %18, i64 %21
  %64 = bitcast float* %63 to <8 x float>*
  %65 = load <8 x float>, <8 x float>* %64, align 16, !tbaa !5
  %66 = fmul <8 x float> %65, <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>
  %67 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %62, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %66)
  %68 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %18, <8 x i64> %37
  %69 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %68, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %70 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %69, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %67)
  %71 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %11, <8 x i64> %29
  %72 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %71, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %73 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %72, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %70)
  %74 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %11, i64 %21
  %75 = bitcast float* %74 to <8 x float>*
  %76 = load <8 x float>, <8 x float>* %75, align 16, !tbaa !5
  %77 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %76, <8 x float> <float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00>, <8 x float> %73)
  %78 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %11, <8 x i64> %37
  %79 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %78, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %80 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %79, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %77)
  %81 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %19, <8 x i64> %29
  %82 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %81, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %83 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %82, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %80)
  %84 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %19, i64 %21
  %85 = bitcast float* %84 to <8 x float>*
  %86 = load <8 x float>, <8 x float>* %85, align 16, !tbaa !5
  %87 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %86, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %83)
  %88 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %19, <8 x i64> %37
  %89 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %88, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %90 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %89, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %87)
  %91 = fmul <8 x float> %46, %76
  %92 = fmul <8 x float> %76, %91
  %93 = fneg <8 x float> %92
  %94 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %60, <8 x float> <float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000>, <8 x float> %93)
  %95 = fsub <8 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, %46
  %96 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %6, <8 x float> %95, <8 x float> %94)
  %97 = fadd <8 x float> %46, %96
  %98 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u_next, i64 0, i64 %11, i64 %21
  %99 = bitcast float* %98 to <8 x float>*
  store <8 x float> %97, <8 x float>* %99, align 16, !tbaa !5
  %100 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %90, <8 x float> <float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000>, <8 x float> %92)
  %101 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %8, <8 x float> %76, <8 x float> %100)
  %102 = fadd <8 x float> %76, %101
  %103 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v_next, i64 0, i64 %11, i64 %21
  %104 = bitcast float* %103 to <8 x float>*
  store <8 x float> %102, <8 x float>* %104, align 16, !tbaa !5
  %105 = add nuw i64 %21, 8
  %106 = add <8 x i64> %22, <i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8>
  %107 = add <8 x i16> %23, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %108 = icmp eq i64 %105, 800
  br i1 %108, label %109, label %20, !llvm.loop !9

109:                                              ; preds = %20
  %110 = icmp eq i64 %12, 600
  br i1 %110, label %9, label %10, !llvm.loop !12
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: nofree nosync nounwind readonly willreturn
declare <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*>, i32 immarg, <8 x i1>, <8 x float>) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare <8 x float> @llvm.fmuladd.v8f32(<8 x float>, <8 x float>, <8 x float>) #3

attributes #0 = { nofree noinline nosync nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="alderlake" "target-features"="+64bit,+adx,+aes,+avx,+avx2,+avxvnni,+bmi,+bmi2,+clflushopt,+clwb,+cmov,+crc32,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+gfni,+hreset,+invpcid,+lzcnt,+mmx,+movbe,+movdir64b,+movdiri,+pclmul,+pku,+popcnt,+prfchw,+ptwrite,+rdpid,+rdrnd,+rdseed,+sahf,+serialize,+sha,+shstk,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+vaes,+vpclmulqdq,+waitpkg,+x87,+xsave,+xsavec,+xsaveopt,+xsaves,-amx-bf16,-amx-int8,-amx-tile,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512fp16,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-cldemote,-clzero,-enqcmd,-fma4,-kl,-lwp,-mwaitx,-pconfig,-prefetchwt1,-rtm,-sgx,-sse4a,-tbm,-tsxldtrk,-uintr,-wbnoinvd,-widekl,-xop" }
attributes #1 = { argmemonly nofree nounwind willreturn }
attributes #2 = { nofree nosync nounwind readonly willreturn }
attributes #3 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{!6, !6, i64 0}
!6 = !{!"float", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.isvectorized", i32 1}
!12 = distinct !{!12, !10}
