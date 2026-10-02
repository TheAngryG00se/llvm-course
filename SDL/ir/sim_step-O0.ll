; ModuleID = 'ir/.logic-O0.ll'
source_filename = "src/logic/logic.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define hidden void @sim_step([800 x float]* noalias noundef %0, [800 x float]* noalias noundef %1, [800 x float]* noalias noundef %2, [800 x float]* noalias noundef %3, float noundef %4, float noundef %5) #0 {
  %7 = alloca [800 x float]*, align 8
  %8 = alloca [800 x float]*, align 8
  %9 = alloca [800 x float]*, align 8
  %10 = alloca [800 x float]*, align 8
  %11 = alloca float, align 4
  %12 = alloca float, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca float, align 4
  %20 = alloca float, align 4
  %21 = alloca float, align 4
  %22 = alloca float, align 4
  %23 = alloca float, align 4
  %24 = alloca i32, align 4
  %25 = alloca i32, align 4
  store [800 x float]* %0, [800 x float]** %7, align 8
  store [800 x float]* %1, [800 x float]** %8, align 8
  store [800 x float]* %2, [800 x float]** %9, align 8
  store [800 x float]* %3, [800 x float]** %10, align 8
  store float %4, float* %11, align 4
  store float %5, float* %12, align 4
  store i32 0, i32* %13, align 4
  br label %26

26:                                               ; preds = %270, %6
  %27 = load i32, i32* %13, align 4
  %28 = icmp ult i32 %27, 600
  br i1 %28, label %29, label %273

29:                                               ; preds = %26
  %30 = load i32, i32* %13, align 4
  %31 = add i32 %30, 1
  %32 = urem i32 %31, 600
  store i32 %32, i32* %14, align 4
  %33 = load i32, i32* %13, align 4
  %34 = add i32 %33, 600
  %35 = sub i32 %34, 1
  %36 = urem i32 %35, 600
  store i32 %36, i32* %15, align 4
  store i32 0, i32* %16, align 4
  br label %37

37:                                               ; preds = %266, %29
  %38 = load i32, i32* %16, align 4
  %39 = icmp ult i32 %38, 800
  br i1 %39, label %40, label %269

40:                                               ; preds = %37
  %41 = load i32, i32* %16, align 4
  %42 = add i32 %41, 1
  %43 = urem i32 %42, 800
  store i32 %43, i32* %17, align 4
  %44 = load i32, i32* %16, align 4
  %45 = add i32 %44, 800
  %46 = sub i32 %45, 1
  %47 = urem i32 %46, 800
  store i32 %47, i32* %18, align 4
  %48 = load [800 x float]*, [800 x float]** %7, align 8
  %49 = load i32, i32* %15, align 4
  %50 = zext i32 %49 to i64
  %51 = getelementptr inbounds [800 x float], [800 x float]* %48, i64 %50
  %52 = load i32, i32* %18, align 4
  %53 = zext i32 %52 to i64
  %54 = getelementptr inbounds [800 x float], [800 x float]* %51, i64 0, i64 %53
  %55 = load float, float* %54, align 4
  %56 = load [800 x float]*, [800 x float]** %7, align 8
  %57 = load i32, i32* %15, align 4
  %58 = zext i32 %57 to i64
  %59 = getelementptr inbounds [800 x float], [800 x float]* %56, i64 %58
  %60 = load i32, i32* %16, align 4
  %61 = zext i32 %60 to i64
  %62 = getelementptr inbounds [800 x float], [800 x float]* %59, i64 0, i64 %61
  %63 = load float, float* %62, align 4
  %64 = fmul float %63, 0x3FC99999A0000000
  %65 = call float @llvm.fmuladd.f32(float %55, float 0x3FA99999A0000000, float %64)
  %66 = load [800 x float]*, [800 x float]** %7, align 8
  %67 = load i32, i32* %15, align 4
  %68 = zext i32 %67 to i64
  %69 = getelementptr inbounds [800 x float], [800 x float]* %66, i64 %68
  %70 = load i32, i32* %17, align 4
  %71 = zext i32 %70 to i64
  %72 = getelementptr inbounds [800 x float], [800 x float]* %69, i64 0, i64 %71
  %73 = load float, float* %72, align 4
  %74 = call float @llvm.fmuladd.f32(float %73, float 0x3FA99999A0000000, float %65)
  %75 = load [800 x float]*, [800 x float]** %7, align 8
  %76 = load i32, i32* %13, align 4
  %77 = zext i32 %76 to i64
  %78 = getelementptr inbounds [800 x float], [800 x float]* %75, i64 %77
  %79 = load i32, i32* %18, align 4
  %80 = zext i32 %79 to i64
  %81 = getelementptr inbounds [800 x float], [800 x float]* %78, i64 0, i64 %80
  %82 = load float, float* %81, align 4
  %83 = call float @llvm.fmuladd.f32(float %82, float 0x3FC99999A0000000, float %74)
  %84 = load [800 x float]*, [800 x float]** %7, align 8
  %85 = load i32, i32* %13, align 4
  %86 = zext i32 %85 to i64
  %87 = getelementptr inbounds [800 x float], [800 x float]* %84, i64 %86
  %88 = load i32, i32* %16, align 4
  %89 = zext i32 %88 to i64
  %90 = getelementptr inbounds [800 x float], [800 x float]* %87, i64 0, i64 %89
  %91 = load float, float* %90, align 4
  %92 = call float @llvm.fmuladd.f32(float %91, float -1.000000e+00, float %83)
  %93 = load [800 x float]*, [800 x float]** %7, align 8
  %94 = load i32, i32* %13, align 4
  %95 = zext i32 %94 to i64
  %96 = getelementptr inbounds [800 x float], [800 x float]* %93, i64 %95
  %97 = load i32, i32* %17, align 4
  %98 = zext i32 %97 to i64
  %99 = getelementptr inbounds [800 x float], [800 x float]* %96, i64 0, i64 %98
  %100 = load float, float* %99, align 4
  %101 = call float @llvm.fmuladd.f32(float %100, float 0x3FC99999A0000000, float %92)
  %102 = load [800 x float]*, [800 x float]** %7, align 8
  %103 = load i32, i32* %14, align 4
  %104 = zext i32 %103 to i64
  %105 = getelementptr inbounds [800 x float], [800 x float]* %102, i64 %104
  %106 = load i32, i32* %18, align 4
  %107 = zext i32 %106 to i64
  %108 = getelementptr inbounds [800 x float], [800 x float]* %105, i64 0, i64 %107
  %109 = load float, float* %108, align 4
  %110 = call float @llvm.fmuladd.f32(float %109, float 0x3FA99999A0000000, float %101)
  %111 = load [800 x float]*, [800 x float]** %7, align 8
  %112 = load i32, i32* %14, align 4
  %113 = zext i32 %112 to i64
  %114 = getelementptr inbounds [800 x float], [800 x float]* %111, i64 %113
  %115 = load i32, i32* %16, align 4
  %116 = zext i32 %115 to i64
  %117 = getelementptr inbounds [800 x float], [800 x float]* %114, i64 0, i64 %116
  %118 = load float, float* %117, align 4
  %119 = call float @llvm.fmuladd.f32(float %118, float 0x3FC99999A0000000, float %110)
  %120 = load [800 x float]*, [800 x float]** %7, align 8
  %121 = load i32, i32* %14, align 4
  %122 = zext i32 %121 to i64
  %123 = getelementptr inbounds [800 x float], [800 x float]* %120, i64 %122
  %124 = load i32, i32* %17, align 4
  %125 = zext i32 %124 to i64
  %126 = getelementptr inbounds [800 x float], [800 x float]* %123, i64 0, i64 %125
  %127 = load float, float* %126, align 4
  %128 = call float @llvm.fmuladd.f32(float %127, float 0x3FA99999A0000000, float %119)
  store float %128, float* %19, align 4
  %129 = load [800 x float]*, [800 x float]** %8, align 8
  %130 = load i32, i32* %15, align 4
  %131 = zext i32 %130 to i64
  %132 = getelementptr inbounds [800 x float], [800 x float]* %129, i64 %131
  %133 = load i32, i32* %18, align 4
  %134 = zext i32 %133 to i64
  %135 = getelementptr inbounds [800 x float], [800 x float]* %132, i64 0, i64 %134
  %136 = load float, float* %135, align 4
  %137 = load [800 x float]*, [800 x float]** %8, align 8
  %138 = load i32, i32* %15, align 4
  %139 = zext i32 %138 to i64
  %140 = getelementptr inbounds [800 x float], [800 x float]* %137, i64 %139
  %141 = load i32, i32* %16, align 4
  %142 = zext i32 %141 to i64
  %143 = getelementptr inbounds [800 x float], [800 x float]* %140, i64 0, i64 %142
  %144 = load float, float* %143, align 4
  %145 = fmul float %144, 0x3FC99999A0000000
  %146 = call float @llvm.fmuladd.f32(float %136, float 0x3FA99999A0000000, float %145)
  %147 = load [800 x float]*, [800 x float]** %8, align 8
  %148 = load i32, i32* %15, align 4
  %149 = zext i32 %148 to i64
  %150 = getelementptr inbounds [800 x float], [800 x float]* %147, i64 %149
  %151 = load i32, i32* %17, align 4
  %152 = zext i32 %151 to i64
  %153 = getelementptr inbounds [800 x float], [800 x float]* %150, i64 0, i64 %152
  %154 = load float, float* %153, align 4
  %155 = call float @llvm.fmuladd.f32(float %154, float 0x3FA99999A0000000, float %146)
  %156 = load [800 x float]*, [800 x float]** %8, align 8
  %157 = load i32, i32* %13, align 4
  %158 = zext i32 %157 to i64
  %159 = getelementptr inbounds [800 x float], [800 x float]* %156, i64 %158
  %160 = load i32, i32* %18, align 4
  %161 = zext i32 %160 to i64
  %162 = getelementptr inbounds [800 x float], [800 x float]* %159, i64 0, i64 %161
  %163 = load float, float* %162, align 4
  %164 = call float @llvm.fmuladd.f32(float %163, float 0x3FC99999A0000000, float %155)
  %165 = load [800 x float]*, [800 x float]** %8, align 8
  %166 = load i32, i32* %13, align 4
  %167 = zext i32 %166 to i64
  %168 = getelementptr inbounds [800 x float], [800 x float]* %165, i64 %167
  %169 = load i32, i32* %16, align 4
  %170 = zext i32 %169 to i64
  %171 = getelementptr inbounds [800 x float], [800 x float]* %168, i64 0, i64 %170
  %172 = load float, float* %171, align 4
  %173 = call float @llvm.fmuladd.f32(float %172, float -1.000000e+00, float %164)
  %174 = load [800 x float]*, [800 x float]** %8, align 8
  %175 = load i32, i32* %13, align 4
  %176 = zext i32 %175 to i64
  %177 = getelementptr inbounds [800 x float], [800 x float]* %174, i64 %176
  %178 = load i32, i32* %17, align 4
  %179 = zext i32 %178 to i64
  %180 = getelementptr inbounds [800 x float], [800 x float]* %177, i64 0, i64 %179
  %181 = load float, float* %180, align 4
  %182 = call float @llvm.fmuladd.f32(float %181, float 0x3FC99999A0000000, float %173)
  %183 = load [800 x float]*, [800 x float]** %8, align 8
  %184 = load i32, i32* %14, align 4
  %185 = zext i32 %184 to i64
  %186 = getelementptr inbounds [800 x float], [800 x float]* %183, i64 %185
  %187 = load i32, i32* %18, align 4
  %188 = zext i32 %187 to i64
  %189 = getelementptr inbounds [800 x float], [800 x float]* %186, i64 0, i64 %188
  %190 = load float, float* %189, align 4
  %191 = call float @llvm.fmuladd.f32(float %190, float 0x3FA99999A0000000, float %182)
  %192 = load [800 x float]*, [800 x float]** %8, align 8
  %193 = load i32, i32* %14, align 4
  %194 = zext i32 %193 to i64
  %195 = getelementptr inbounds [800 x float], [800 x float]* %192, i64 %194
  %196 = load i32, i32* %16, align 4
  %197 = zext i32 %196 to i64
  %198 = getelementptr inbounds [800 x float], [800 x float]* %195, i64 0, i64 %197
  %199 = load float, float* %198, align 4
  %200 = call float @llvm.fmuladd.f32(float %199, float 0x3FC99999A0000000, float %191)
  %201 = load [800 x float]*, [800 x float]** %8, align 8
  %202 = load i32, i32* %14, align 4
  %203 = zext i32 %202 to i64
  %204 = getelementptr inbounds [800 x float], [800 x float]* %201, i64 %203
  %205 = load i32, i32* %17, align 4
  %206 = zext i32 %205 to i64
  %207 = getelementptr inbounds [800 x float], [800 x float]* %204, i64 0, i64 %206
  %208 = load float, float* %207, align 4
  %209 = call float @llvm.fmuladd.f32(float %208, float 0x3FA99999A0000000, float %200)
  store float %209, float* %20, align 4
  %210 = load [800 x float]*, [800 x float]** %7, align 8
  %211 = load i32, i32* %13, align 4
  %212 = zext i32 %211 to i64
  %213 = getelementptr inbounds [800 x float], [800 x float]* %210, i64 %212
  %214 = load i32, i32* %16, align 4
  %215 = zext i32 %214 to i64
  %216 = getelementptr inbounds [800 x float], [800 x float]* %213, i64 0, i64 %215
  %217 = load float, float* %216, align 4
  store float %217, float* %21, align 4
  %218 = load [800 x float]*, [800 x float]** %8, align 8
  %219 = load i32, i32* %13, align 4
  %220 = zext i32 %219 to i64
  %221 = getelementptr inbounds [800 x float], [800 x float]* %218, i64 %220
  %222 = load i32, i32* %16, align 4
  %223 = zext i32 %222 to i64
  %224 = getelementptr inbounds [800 x float], [800 x float]* %221, i64 0, i64 %223
  %225 = load float, float* %224, align 4
  store float %225, float* %22, align 4
  %226 = load float, float* %21, align 4
  %227 = load float, float* %22, align 4
  %228 = fmul float %226, %227
  %229 = load float, float* %22, align 4
  %230 = fmul float %228, %229
  store float %230, float* %23, align 4
  %231 = load float, float* %21, align 4
  %232 = load float, float* %19, align 4
  %233 = load float, float* %23, align 4
  %234 = fneg float %233
  %235 = call float @llvm.fmuladd.f32(float 0x3FCAD77320000000, float %232, float %234)
  %236 = load float, float* %11, align 4
  %237 = load float, float* %21, align 4
  %238 = fsub float 1.000000e+00, %237
  %239 = call float @llvm.fmuladd.f32(float %236, float %238, float %235)
  %240 = call float @llvm.fmuladd.f32(float %239, float 1.000000e+00, float %231)
  %241 = load [800 x float]*, [800 x float]** %9, align 8
  %242 = load i32, i32* %13, align 4
  %243 = zext i32 %242 to i64
  %244 = getelementptr inbounds [800 x float], [800 x float]* %241, i64 %243
  %245 = load i32, i32* %16, align 4
  %246 = zext i32 %245 to i64
  %247 = getelementptr inbounds [800 x float], [800 x float]* %244, i64 0, i64 %246
  store float %240, float* %247, align 4
  %248 = load float, float* %22, align 4
  %249 = load float, float* %20, align 4
  %250 = load float, float* %23, align 4
  %251 = call float @llvm.fmuladd.f32(float 0x3FBAE147A0000000, float %249, float %250)
  %252 = load float, float* %11, align 4
  %253 = load float, float* %12, align 4
  %254 = fadd float %252, %253
  %255 = load float, float* %22, align 4
  %256 = fneg float %254
  %257 = call float @llvm.fmuladd.f32(float %256, float %255, float %251)
  %258 = call float @llvm.fmuladd.f32(float %257, float 1.000000e+00, float %248)
  %259 = load [800 x float]*, [800 x float]** %10, align 8
  %260 = load i32, i32* %13, align 4
  %261 = zext i32 %260 to i64
  %262 = getelementptr inbounds [800 x float], [800 x float]* %259, i64 %261
  %263 = load i32, i32* %16, align 4
  %264 = zext i32 %263 to i64
  %265 = getelementptr inbounds [800 x float], [800 x float]* %262, i64 0, i64 %264
  store float %258, float* %265, align 4
  br label %266

266:                                              ; preds = %40
  %267 = load i32, i32* %16, align 4
  %268 = add i32 %267, 1
  store i32 %268, i32* %16, align 4
  br label %37, !llvm.loop !6

269:                                              ; preds = %37
  br label %270

270:                                              ; preds = %269
  %271 = load i32, i32* %13, align 4
  %272 = add i32 %271, 1
  store i32 %272, i32* %13, align 4
  br label %26, !llvm.loop !8

273:                                              ; preds = %26
  store i32 0, i32* %24, align 4
  br label %274

274:                                              ; preds = %316, %273
  %275 = load i32, i32* %24, align 4
  %276 = icmp ult i32 %275, 600
  br i1 %276, label %277, label %319

277:                                              ; preds = %274
  store i32 0, i32* %25, align 4
  br label %278

278:                                              ; preds = %312, %277
  %279 = load i32, i32* %25, align 4
  %280 = icmp ult i32 %279, 800
  br i1 %280, label %281, label %315

281:                                              ; preds = %278
  %282 = load [800 x float]*, [800 x float]** %9, align 8
  %283 = load i32, i32* %24, align 4
  %284 = zext i32 %283 to i64
  %285 = getelementptr inbounds [800 x float], [800 x float]* %282, i64 %284
  %286 = load i32, i32* %25, align 4
  %287 = zext i32 %286 to i64
  %288 = getelementptr inbounds [800 x float], [800 x float]* %285, i64 0, i64 %287
  %289 = load float, float* %288, align 4
  %290 = load [800 x float]*, [800 x float]** %7, align 8
  %291 = load i32, i32* %24, align 4
  %292 = zext i32 %291 to i64
  %293 = getelementptr inbounds [800 x float], [800 x float]* %290, i64 %292
  %294 = load i32, i32* %25, align 4
  %295 = zext i32 %294 to i64
  %296 = getelementptr inbounds [800 x float], [800 x float]* %293, i64 0, i64 %295
  store float %289, float* %296, align 4
  %297 = load [800 x float]*, [800 x float]** %10, align 8
  %298 = load i32, i32* %24, align 4
  %299 = zext i32 %298 to i64
  %300 = getelementptr inbounds [800 x float], [800 x float]* %297, i64 %299
  %301 = load i32, i32* %25, align 4
  %302 = zext i32 %301 to i64
  %303 = getelementptr inbounds [800 x float], [800 x float]* %300, i64 0, i64 %302
  %304 = load float, float* %303, align 4
  %305 = load [800 x float]*, [800 x float]** %8, align 8
  %306 = load i32, i32* %24, align 4
  %307 = zext i32 %306 to i64
  %308 = getelementptr inbounds [800 x float], [800 x float]* %305, i64 %307
  %309 = load i32, i32* %25, align 4
  %310 = zext i32 %309 to i64
  %311 = getelementptr inbounds [800 x float], [800 x float]* %308, i64 0, i64 %310
  store float %304, float* %311, align 4
  br label %312

312:                                              ; preds = %281
  %313 = load i32, i32* %25, align 4
  %314 = add i32 %313, 1
  store i32 %314, i32* %25, align 4
  br label %278, !llvm.loop !9

315:                                              ; preds = %278
  br label %316

316:                                              ; preds = %315
  %317 = load i32, i32* %24, align 4
  %318 = add i32 %317, 1
  store i32 %318, i32* %24, align 4
  br label %274, !llvm.loop !10

319:                                              ; preds = %274
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
