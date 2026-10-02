; ModuleID = 'ir/.logic-O3.ll'
source_filename = "src/logic/logic.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree noinline nosync nounwind uwtable
define hidden fastcc void @sim_step([800 x float]* noalias nocapture noundef %0, [800 x float]* noalias nocapture noundef %1, [800 x float]* noalias nocapture noundef %2, [800 x float]* noalias nocapture noundef %3, float noundef %4, float noundef %5) unnamed_addr #0 {
  %7 = fadd float %4, %5
  %8 = fneg float %7
  %9 = insertelement <8 x float> poison, float %4, i64 0
  %10 = shufflevector <8 x float> %9, <8 x float> poison, <8 x i32> zeroinitializer
  %11 = insertelement <8 x float> poison, float %8, i64 0
  %12 = shufflevector <8 x float> %11, <8 x float> poison, <8 x i32> zeroinitializer
  br label %18

13:                                               ; preds = %117
  %14 = bitcast [800 x float]* %3 to i8*
  %15 = bitcast [800 x float]* %1 to i8*
  %16 = bitcast [800 x float]* %2 to i8*
  %17 = bitcast [800 x float]* %0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(1920000) %17, i8* noundef nonnull align 4 dereferenceable(1920000) %16, i64 1920000, i1 false), !tbaa !5
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(1920000) %15, i8* noundef nonnull align 4 dereferenceable(1920000) %14, i64 1920000, i1 false), !tbaa !5
  ret void

18:                                               ; preds = %117, %6
  %19 = phi i64 [ 0, %6 ], [ %20, %117 ]
  %20 = add nuw nsw i64 %19, 1
  %21 = trunc i64 %20 to i16
  %22 = urem i16 %21, 600
  %23 = trunc i64 %19 to i16
  %24 = add i16 %23, 599
  %25 = urem i16 %24, 600
  %26 = zext i16 %25 to i64
  %27 = zext i16 %22 to i64
  br label %28

28:                                               ; preds = %28, %18
  %29 = phi i64 [ 0, %18 ], [ %113, %28 ]
  %30 = phi <8 x i64> [ <i64 0, i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, i64 7>, %18 ], [ %114, %28 ]
  %31 = phi <8 x i16> [ <i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7>, %18 ], [ %115, %28 ]
  %32 = trunc <8 x i64> %30 to <8 x i16>
  %33 = add <8 x i16> %32, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %34 = urem <8 x i16> %33, <i16 800, i16 800, i16 800, i16 800, i16 800, i16 800, i16 800, i16 800>
  %35 = add <8 x i16> %31, <i16 799, i16 799, i16 799, i16 799, i16 799, i16 799, i16 799, i16 799>
  %36 = urem <8 x i16> %35, <i16 800, i16 800, i16 800, i16 800, i16 800, i16 800, i16 800, i16 800>
  %37 = zext <8 x i16> %36 to <8 x i64>
  %38 = getelementptr inbounds [800 x float], [800 x float]* %0, i64 %26, <8 x i64> %37
  %39 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %38, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %40 = getelementptr inbounds [800 x float], [800 x float]* %0, i64 %26, i64 %29
  %41 = bitcast float* %40 to <8 x float>*
  %42 = load <8 x float>, <8 x float>* %41, align 4, !tbaa !5
  %43 = fmul <8 x float> %42, <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>
  %44 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %39, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %43)
  %45 = zext <8 x i16> %34 to <8 x i64>
  %46 = getelementptr inbounds [800 x float], [800 x float]* %0, i64 %26, <8 x i64> %45
  %47 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %46, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %48 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %47, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %44)
  %49 = getelementptr inbounds [800 x float], [800 x float]* %0, i64 %19, <8 x i64> %37
  %50 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %49, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %51 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %50, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %48)
  %52 = getelementptr inbounds [800 x float], [800 x float]* %0, i64 %19, i64 %29
  %53 = bitcast float* %52 to <8 x float>*
  %54 = load <8 x float>, <8 x float>* %53, align 4, !tbaa !5
  %55 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %54, <8 x float> <float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00>, <8 x float> %51)
  %56 = getelementptr inbounds [800 x float], [800 x float]* %0, i64 %19, <8 x i64> %45
  %57 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %56, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %58 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %57, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %55)
  %59 = getelementptr inbounds [800 x float], [800 x float]* %0, i64 %27, <8 x i64> %37
  %60 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %59, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %61 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %60, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %58)
  %62 = getelementptr inbounds [800 x float], [800 x float]* %0, i64 %27, i64 %29
  %63 = bitcast float* %62 to <8 x float>*
  %64 = load <8 x float>, <8 x float>* %63, align 4, !tbaa !5
  %65 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %64, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %61)
  %66 = getelementptr inbounds [800 x float], [800 x float]* %0, i64 %27, <8 x i64> %45
  %67 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %66, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %68 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %67, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %65)
  %69 = getelementptr inbounds [800 x float], [800 x float]* %1, i64 %26, <8 x i64> %37
  %70 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %69, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %71 = getelementptr inbounds [800 x float], [800 x float]* %1, i64 %26, i64 %29
  %72 = bitcast float* %71 to <8 x float>*
  %73 = load <8 x float>, <8 x float>* %72, align 4, !tbaa !5
  %74 = fmul <8 x float> %73, <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>
  %75 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %70, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %74)
  %76 = getelementptr inbounds [800 x float], [800 x float]* %1, i64 %26, <8 x i64> %45
  %77 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %76, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %78 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %77, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %75)
  %79 = getelementptr inbounds [800 x float], [800 x float]* %1, i64 %19, <8 x i64> %37
  %80 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %79, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %81 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %80, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %78)
  %82 = getelementptr inbounds [800 x float], [800 x float]* %1, i64 %19, i64 %29
  %83 = bitcast float* %82 to <8 x float>*
  %84 = load <8 x float>, <8 x float>* %83, align 4, !tbaa !5
  %85 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %84, <8 x float> <float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00>, <8 x float> %81)
  %86 = getelementptr inbounds [800 x float], [800 x float]* %1, i64 %19, <8 x i64> %45
  %87 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %86, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %88 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %87, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %85)
  %89 = getelementptr inbounds [800 x float], [800 x float]* %1, i64 %27, <8 x i64> %37
  %90 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %89, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %91 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %90, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %88)
  %92 = getelementptr inbounds [800 x float], [800 x float]* %1, i64 %27, i64 %29
  %93 = bitcast float* %92 to <8 x float>*
  %94 = load <8 x float>, <8 x float>* %93, align 4, !tbaa !5
  %95 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %94, <8 x float> <float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000, float 0x3FC99999A0000000>, <8 x float> %91)
  %96 = getelementptr inbounds [800 x float], [800 x float]* %1, i64 %27, <8 x i64> %45
  %97 = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %96, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef), !tbaa !5
  %98 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %97, <8 x float> <float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000, float 0x3FA99999A0000000>, <8 x float> %95)
  %99 = fmul <8 x float> %54, %84
  %100 = fmul <8 x float> %84, %99
  %101 = fneg <8 x float> %100
  %102 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %68, <8 x float> <float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000, float 0x3FCAD77320000000>, <8 x float> %101)
  %103 = fsub <8 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, %54
  %104 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %10, <8 x float> %103, <8 x float> %102)
  %105 = fadd <8 x float> %54, %104
  %106 = getelementptr inbounds [800 x float], [800 x float]* %2, i64 %19, i64 %29
  %107 = bitcast float* %106 to <8 x float>*
  store <8 x float> %105, <8 x float>* %107, align 4, !tbaa !5
  %108 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %98, <8 x float> <float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000, float 0x3FBAE147A0000000>, <8 x float> %100)
  %109 = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %12, <8 x float> %84, <8 x float> %108)
  %110 = fadd <8 x float> %84, %109
  %111 = getelementptr inbounds [800 x float], [800 x float]* %3, i64 %19, i64 %29
  %112 = bitcast float* %111 to <8 x float>*
  store <8 x float> %110, <8 x float>* %112, align 4, !tbaa !5
  %113 = add nuw i64 %29, 8
  %114 = add <8 x i64> %30, <i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8>
  %115 = add <8 x i16> %31, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %116 = icmp eq i64 %113, 800
  br i1 %116, label %117, label %28, !llvm.loop !9

117:                                              ; preds = %28
  %118 = icmp eq i64 %20, 600
  br i1 %118, label %13, label %18, !llvm.loop !12
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
