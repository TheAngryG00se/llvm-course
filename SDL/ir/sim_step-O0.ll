; ModuleID = 'ir/.logic-O0.ll'
source_filename = "src/logic/logic.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@v = external hidden global [600 x [800 x float]], align 16
@u = external hidden global [600 x [800 x float]], align 16
@u_next = external hidden global [600 x [800 x float]], align 16
@v_next = external hidden global [600 x [800 x float]], align 16

; Function Attrs: noinline nounwind optnone uwtable
define hidden void @sim_step(float noundef %0, float noundef %1) #0 {
  %3 = alloca float, align 4
  %4 = alloca float, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca float, align 4
  %12 = alloca float, align 4
  %13 = alloca float, align 4
  %14 = alloca float, align 4
  %15 = alloca float, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  store float %0, float* %3, align 4
  store float %1, float* %4, align 4
  store i32 0, i32* %5, align 4
  br label %18

18:                                               ; preds = %240, %2
  %19 = load i32, i32* %5, align 4
  %20 = icmp ult i32 %19, 600
  br i1 %20, label %21, label %243

21:                                               ; preds = %18
  %22 = load i32, i32* %5, align 4
  %23 = add i32 %22, 1
  %24 = urem i32 %23, 600
  store i32 %24, i32* %6, align 4
  %25 = load i32, i32* %5, align 4
  %26 = add i32 %25, 600
  %27 = sub i32 %26, 1
  %28 = urem i32 %27, 600
  store i32 %28, i32* %7, align 4
  store i32 0, i32* %8, align 4
  br label %29

29:                                               ; preds = %236, %21
  %30 = load i32, i32* %8, align 4
  %31 = icmp ult i32 %30, 800
  br i1 %31, label %32, label %239

32:                                               ; preds = %29
  %33 = load i32, i32* %8, align 4
  %34 = add i32 %33, 1
  %35 = urem i32 %34, 800
  store i32 %35, i32* %9, align 4
  %36 = load i32, i32* %8, align 4
  %37 = add i32 %36, 800
  %38 = sub i32 %37, 1
  %39 = urem i32 %38, 800
  store i32 %39, i32* %10, align 4
  %40 = load i32, i32* %7, align 4
  %41 = zext i32 %40 to i64
  %42 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %41
  %43 = load i32, i32* %10, align 4
  %44 = zext i32 %43 to i64
  %45 = getelementptr inbounds [800 x float], [800 x float]* %42, i64 0, i64 %44
  %46 = load float, float* %45, align 4
  %47 = load i32, i32* %7, align 4
  %48 = zext i32 %47 to i64
  %49 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %48
  %50 = load i32, i32* %8, align 4
  %51 = zext i32 %50 to i64
  %52 = getelementptr inbounds [800 x float], [800 x float]* %49, i64 0, i64 %51
  %53 = load float, float* %52, align 4
  %54 = fmul float %53, 0x3FC99999A0000000
  %55 = call float @llvm.fmuladd.f32(float %46, float 0x3FA99999A0000000, float %54)
  %56 = load i32, i32* %7, align 4
  %57 = zext i32 %56 to i64
  %58 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %57
  %59 = load i32, i32* %9, align 4
  %60 = zext i32 %59 to i64
  %61 = getelementptr inbounds [800 x float], [800 x float]* %58, i64 0, i64 %60
  %62 = load float, float* %61, align 4
  %63 = call float @llvm.fmuladd.f32(float %62, float 0x3FA99999A0000000, float %55)
  %64 = load i32, i32* %5, align 4
  %65 = zext i32 %64 to i64
  %66 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %65
  %67 = load i32, i32* %10, align 4
  %68 = zext i32 %67 to i64
  %69 = getelementptr inbounds [800 x float], [800 x float]* %66, i64 0, i64 %68
  %70 = load float, float* %69, align 4
  %71 = call float @llvm.fmuladd.f32(float %70, float 0x3FC99999A0000000, float %63)
  %72 = load i32, i32* %5, align 4
  %73 = zext i32 %72 to i64
  %74 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %73
  %75 = load i32, i32* %8, align 4
  %76 = zext i32 %75 to i64
  %77 = getelementptr inbounds [800 x float], [800 x float]* %74, i64 0, i64 %76
  %78 = load float, float* %77, align 4
  %79 = call float @llvm.fmuladd.f32(float %78, float -1.000000e+00, float %71)
  %80 = load i32, i32* %5, align 4
  %81 = zext i32 %80 to i64
  %82 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %81
  %83 = load i32, i32* %9, align 4
  %84 = zext i32 %83 to i64
  %85 = getelementptr inbounds [800 x float], [800 x float]* %82, i64 0, i64 %84
  %86 = load float, float* %85, align 4
  %87 = call float @llvm.fmuladd.f32(float %86, float 0x3FC99999A0000000, float %79)
  %88 = load i32, i32* %6, align 4
  %89 = zext i32 %88 to i64
  %90 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %89
  %91 = load i32, i32* %10, align 4
  %92 = zext i32 %91 to i64
  %93 = getelementptr inbounds [800 x float], [800 x float]* %90, i64 0, i64 %92
  %94 = load float, float* %93, align 4
  %95 = call float @llvm.fmuladd.f32(float %94, float 0x3FA99999A0000000, float %87)
  %96 = load i32, i32* %6, align 4
  %97 = zext i32 %96 to i64
  %98 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %97
  %99 = load i32, i32* %8, align 4
  %100 = zext i32 %99 to i64
  %101 = getelementptr inbounds [800 x float], [800 x float]* %98, i64 0, i64 %100
  %102 = load float, float* %101, align 4
  %103 = call float @llvm.fmuladd.f32(float %102, float 0x3FC99999A0000000, float %95)
  %104 = load i32, i32* %6, align 4
  %105 = zext i32 %104 to i64
  %106 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %105
  %107 = load i32, i32* %9, align 4
  %108 = zext i32 %107 to i64
  %109 = getelementptr inbounds [800 x float], [800 x float]* %106, i64 0, i64 %108
  %110 = load float, float* %109, align 4
  %111 = call float @llvm.fmuladd.f32(float %110, float 0x3FA99999A0000000, float %103)
  store float %111, float* %11, align 4
  %112 = load i32, i32* %7, align 4
  %113 = zext i32 %112 to i64
  %114 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %113
  %115 = load i32, i32* %10, align 4
  %116 = zext i32 %115 to i64
  %117 = getelementptr inbounds [800 x float], [800 x float]* %114, i64 0, i64 %116
  %118 = load float, float* %117, align 4
  %119 = load i32, i32* %7, align 4
  %120 = zext i32 %119 to i64
  %121 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %120
  %122 = load i32, i32* %8, align 4
  %123 = zext i32 %122 to i64
  %124 = getelementptr inbounds [800 x float], [800 x float]* %121, i64 0, i64 %123
  %125 = load float, float* %124, align 4
  %126 = fmul float %125, 0x3FC99999A0000000
  %127 = call float @llvm.fmuladd.f32(float %118, float 0x3FA99999A0000000, float %126)
  %128 = load i32, i32* %7, align 4
  %129 = zext i32 %128 to i64
  %130 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %129
  %131 = load i32, i32* %9, align 4
  %132 = zext i32 %131 to i64
  %133 = getelementptr inbounds [800 x float], [800 x float]* %130, i64 0, i64 %132
  %134 = load float, float* %133, align 4
  %135 = call float @llvm.fmuladd.f32(float %134, float 0x3FA99999A0000000, float %127)
  %136 = load i32, i32* %5, align 4
  %137 = zext i32 %136 to i64
  %138 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %137
  %139 = load i32, i32* %10, align 4
  %140 = zext i32 %139 to i64
  %141 = getelementptr inbounds [800 x float], [800 x float]* %138, i64 0, i64 %140
  %142 = load float, float* %141, align 4
  %143 = call float @llvm.fmuladd.f32(float %142, float 0x3FC99999A0000000, float %135)
  %144 = load i32, i32* %5, align 4
  %145 = zext i32 %144 to i64
  %146 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %145
  %147 = load i32, i32* %8, align 4
  %148 = zext i32 %147 to i64
  %149 = getelementptr inbounds [800 x float], [800 x float]* %146, i64 0, i64 %148
  %150 = load float, float* %149, align 4
  %151 = call float @llvm.fmuladd.f32(float %150, float -1.000000e+00, float %143)
  %152 = load i32, i32* %5, align 4
  %153 = zext i32 %152 to i64
  %154 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %153
  %155 = load i32, i32* %9, align 4
  %156 = zext i32 %155 to i64
  %157 = getelementptr inbounds [800 x float], [800 x float]* %154, i64 0, i64 %156
  %158 = load float, float* %157, align 4
  %159 = call float @llvm.fmuladd.f32(float %158, float 0x3FC99999A0000000, float %151)
  %160 = load i32, i32* %6, align 4
  %161 = zext i32 %160 to i64
  %162 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %161
  %163 = load i32, i32* %10, align 4
  %164 = zext i32 %163 to i64
  %165 = getelementptr inbounds [800 x float], [800 x float]* %162, i64 0, i64 %164
  %166 = load float, float* %165, align 4
  %167 = call float @llvm.fmuladd.f32(float %166, float 0x3FA99999A0000000, float %159)
  %168 = load i32, i32* %6, align 4
  %169 = zext i32 %168 to i64
  %170 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %169
  %171 = load i32, i32* %8, align 4
  %172 = zext i32 %171 to i64
  %173 = getelementptr inbounds [800 x float], [800 x float]* %170, i64 0, i64 %172
  %174 = load float, float* %173, align 4
  %175 = call float @llvm.fmuladd.f32(float %174, float 0x3FC99999A0000000, float %167)
  %176 = load i32, i32* %6, align 4
  %177 = zext i32 %176 to i64
  %178 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %177
  %179 = load i32, i32* %9, align 4
  %180 = zext i32 %179 to i64
  %181 = getelementptr inbounds [800 x float], [800 x float]* %178, i64 0, i64 %180
  %182 = load float, float* %181, align 4
  %183 = call float @llvm.fmuladd.f32(float %182, float 0x3FA99999A0000000, float %175)
  store float %183, float* %12, align 4
  %184 = load i32, i32* %5, align 4
  %185 = zext i32 %184 to i64
  %186 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %185
  %187 = load i32, i32* %8, align 4
  %188 = zext i32 %187 to i64
  %189 = getelementptr inbounds [800 x float], [800 x float]* %186, i64 0, i64 %188
  %190 = load float, float* %189, align 4
  store float %190, float* %13, align 4
  %191 = load i32, i32* %5, align 4
  %192 = zext i32 %191 to i64
  %193 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %192
  %194 = load i32, i32* %8, align 4
  %195 = zext i32 %194 to i64
  %196 = getelementptr inbounds [800 x float], [800 x float]* %193, i64 0, i64 %195
  %197 = load float, float* %196, align 4
  store float %197, float* %14, align 4
  %198 = load float, float* %13, align 4
  %199 = load float, float* %14, align 4
  %200 = fmul float %198, %199
  %201 = load float, float* %14, align 4
  %202 = fmul float %200, %201
  store float %202, float* %15, align 4
  %203 = load float, float* %13, align 4
  %204 = load float, float* %11, align 4
  %205 = load float, float* %15, align 4
  %206 = fneg float %205
  %207 = call float @llvm.fmuladd.f32(float 0x3FCAD77320000000, float %204, float %206)
  %208 = load float, float* %3, align 4
  %209 = load float, float* %13, align 4
  %210 = fsub float 1.000000e+00, %209
  %211 = call float @llvm.fmuladd.f32(float %208, float %210, float %207)
  %212 = call float @llvm.fmuladd.f32(float %211, float 1.000000e+00, float %203)
  %213 = load i32, i32* %5, align 4
  %214 = zext i32 %213 to i64
  %215 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u_next, i64 0, i64 %214
  %216 = load i32, i32* %8, align 4
  %217 = zext i32 %216 to i64
  %218 = getelementptr inbounds [800 x float], [800 x float]* %215, i64 0, i64 %217
  store float %212, float* %218, align 4
  %219 = load float, float* %14, align 4
  %220 = load float, float* %12, align 4
  %221 = load float, float* %15, align 4
  %222 = call float @llvm.fmuladd.f32(float 0x3FBAE147A0000000, float %220, float %221)
  %223 = load float, float* %3, align 4
  %224 = load float, float* %4, align 4
  %225 = fadd float %223, %224
  %226 = load float, float* %14, align 4
  %227 = fneg float %225
  %228 = call float @llvm.fmuladd.f32(float %227, float %226, float %222)
  %229 = call float @llvm.fmuladd.f32(float %228, float 1.000000e+00, float %219)
  %230 = load i32, i32* %5, align 4
  %231 = zext i32 %230 to i64
  %232 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v_next, i64 0, i64 %231
  %233 = load i32, i32* %8, align 4
  %234 = zext i32 %233 to i64
  %235 = getelementptr inbounds [800 x float], [800 x float]* %232, i64 0, i64 %234
  store float %229, float* %235, align 4
  br label %236

236:                                              ; preds = %32
  %237 = load i32, i32* %8, align 4
  %238 = add i32 %237, 1
  store i32 %238, i32* %8, align 4
  br label %29, !llvm.loop !6

239:                                              ; preds = %29
  br label %240

240:                                              ; preds = %239
  %241 = load i32, i32* %5, align 4
  %242 = add i32 %241, 1
  store i32 %242, i32* %5, align 4
  br label %18, !llvm.loop !8

243:                                              ; preds = %18
  store i32 0, i32* %16, align 4
  br label %244

244:                                              ; preds = %282, %243
  %245 = load i32, i32* %16, align 4
  %246 = icmp ult i32 %245, 600
  br i1 %246, label %247, label %285

247:                                              ; preds = %244
  store i32 0, i32* %17, align 4
  br label %248

248:                                              ; preds = %278, %247
  %249 = load i32, i32* %17, align 4
  %250 = icmp ult i32 %249, 800
  br i1 %250, label %251, label %281

251:                                              ; preds = %248
  %252 = load i32, i32* %16, align 4
  %253 = zext i32 %252 to i64
  %254 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u_next, i64 0, i64 %253
  %255 = load i32, i32* %17, align 4
  %256 = zext i32 %255 to i64
  %257 = getelementptr inbounds [800 x float], [800 x float]* %254, i64 0, i64 %256
  %258 = load float, float* %257, align 4
  %259 = load i32, i32* %16, align 4
  %260 = zext i32 %259 to i64
  %261 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @u, i64 0, i64 %260
  %262 = load i32, i32* %17, align 4
  %263 = zext i32 %262 to i64
  %264 = getelementptr inbounds [800 x float], [800 x float]* %261, i64 0, i64 %263
  store float %258, float* %264, align 4
  %265 = load i32, i32* %16, align 4
  %266 = zext i32 %265 to i64
  %267 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v_next, i64 0, i64 %266
  %268 = load i32, i32* %17, align 4
  %269 = zext i32 %268 to i64
  %270 = getelementptr inbounds [800 x float], [800 x float]* %267, i64 0, i64 %269
  %271 = load float, float* %270, align 4
  %272 = load i32, i32* %16, align 4
  %273 = zext i32 %272 to i64
  %274 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* @v, i64 0, i64 %273
  %275 = load i32, i32* %17, align 4
  %276 = zext i32 %275 to i64
  %277 = getelementptr inbounds [800 x float], [800 x float]* %274, i64 0, i64 %276
  store float %271, float* %277, align 4
  br label %278

278:                                              ; preds = %251
  %279 = load i32, i32* %17, align 4
  %280 = add i32 %279, 1
  store i32 %280, i32* %17, align 4
  br label %248, !llvm.loop !9

281:                                              ; preds = %248
  br label %282

282:                                              ; preds = %281
  %283 = load i32, i32* %16, align 4
  %284 = add i32 %283, 1
  store i32 %284, i32* %16, align 4
  br label %244, !llvm.loop !10

285:                                              ; preds = %244
  ret void
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.fmuladd.f32(float, float, float) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
