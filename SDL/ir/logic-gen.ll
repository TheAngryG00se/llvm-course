; ModuleID = 'src/logic/logic.c'
source_filename = "src/logic/logic.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@PRESET_F = internal unnamed_addr constant [5 x float] [float 0x3FABA5E360000000, float 0x3F926E9780000000, float 0x3F9A9FBE80000000, float 0x3F9DB22D00000000, float 0x3F8CAC0840000000], align 16
@PRESET_K = internal unnamed_addr constant [5 x float] [float 0x3FAFBE76C0000000, float 0x3FAA1CAC00000000, float 0x3FAA1CAC00000000, float 0x3FAD2F1AA0000000, float 0x3FA70A3D80000000], align 16

; Function Attrs: nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
entry:
  %u = alloca [600 x [800 x float]], align 16
  %v = alloca [600 x [800 x float]], align 16
  %u_next = alloca [600 x [800 x float]], align 16
  %v_next = alloca [600 x [800 x float]], align 16
  %0 = bitcast [600 x [800 x float]]* %u to i8*
  call void @llvm.lifetime.start.p0i8(i64 1920000, i8* nonnull %0) #7
  %1 = bitcast [600 x [800 x float]]* %v to i8*
  call void @llvm.lifetime.start.p0i8(i64 1920000, i8* nonnull %1) #7
  %2 = bitcast [600 x [800 x float]]* %u_next to i8*
  call void @llvm.lifetime.start.p0i8(i64 1920000, i8* nonnull %2) #7
  %3 = bitcast [600 x [800 x float]]* %v_next to i8*
  call void @llvm.lifetime.start.p0i8(i64 1920000, i8* nonnull %3) #7
  tail call void @llvm.experimental.noalias.scope.decl(metadata !5)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !8)
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(1920000) %1, i8 0, i64 1920000, i1 false) #7, !tbaa !10, !alias.scope !8, !noalias !5
  br label %for.cond1.preheader.i

for.cond1.preheader.i:                            ; preds = %for.cond.cleanup3.i, %entry
  %indvar.i = phi i64 [ 0, %entry ], [ %indvar.next.i, %for.cond.cleanup3.i ]
  br label %for.body4.i

for.cond.cleanup3.i:                              ; preds = %for.body4.i
  %indvar.next.i = add nuw nsw i64 %indvar.i, 1
  %exitcond91.not.i = icmp eq i64 %indvar.next.i, 600
  br i1 %exitcond91.not.i, label %for.cond21.preheader.i, label %for.cond1.preheader.i, !llvm.loop !14

for.body4.i:                                      ; preds = %for.body4.i, %for.cond1.preheader.i
  %indvars.iv.i = phi i64 [ 0, %for.cond1.preheader.i ], [ %indvars.iv.next.i, %for.body4.i ]
  %arrayidx6.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %indvar.i, i64 %indvars.iv.i
  store float 1.000000e+00, float* %arrayidx6.i, align 4, !tbaa !10, !alias.scope !5, !noalias !8
  %indvars.iv.next.i = add nuw nsw i64 %indvars.iv.i, 1
  %exitcond.not.i = icmp eq i64 %indvars.iv.next.i, 800
  br i1 %exitcond.not.i, label %for.cond.cleanup3.i, label %for.body4.i, !llvm.loop !17

for.cond21.preheader.i:                           ; preds = %for.cond.cleanup3.i, %for.cond.cleanup24.i
  %indvars.iv99.i = phi i64 [ %indvars.iv.next100.i, %for.cond.cleanup24.i ], [ 250, %for.cond.cleanup3.i ]
  %4 = add nsw i64 %indvars.iv99.i, -300
  %5 = mul nsw i64 %4, %4
  br label %for.body25.i

for.cond.cleanup24.i:                             ; preds = %if.end.i
  %indvars.iv.next100.i = add nuw nsw i64 %indvars.iv99.i, 1
  %exitcond104.not.i = icmp eq i64 %indvars.iv.next100.i, 350
  br i1 %exitcond104.not.i, label %while.cond.preheader, label %for.cond21.preheader.i, !llvm.loop !18

while.cond.preheader:                             ; preds = %for.cond.cleanup24.i
  %call115 = tail call zeroext i1 @should_quit() #7
  br i1 %call115, label %while.end, label %while.body

for.body25.i:                                     ; preds = %if.end.i, %for.cond21.preheader.i
  %indvars.iv92.i = phi i64 [ 350, %for.cond21.preheader.i ], [ %indvars.iv.next93.i, %if.end.i ]
  %6 = add nsw i64 %indvars.iv92.i, -400
  %7 = mul nsw i64 %6, %6
  %8 = add nuw nsw i64 %7, %5
  %9 = trunc i64 %8 to i32
  %cmp31.i = icmp ult i32 %9, 2501
  br i1 %cmp31.i, label %if.then.i, label %if.end.i

if.then.i:                                        ; preds = %for.body25.i
  %arrayidx35.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %indvars.iv99.i, i64 %indvars.iv92.i
  store float 5.000000e-01, float* %arrayidx35.i, align 4, !tbaa !10, !alias.scope !5, !noalias !8
  %arrayidx39.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %indvars.iv99.i, i64 %indvars.iv92.i
  store float 2.500000e-01, float* %arrayidx39.i, align 4, !tbaa !10, !alias.scope !8, !noalias !5
  br label %if.end.i

if.end.i:                                         ; preds = %if.then.i, %for.body25.i
  %indvars.iv.next93.i = add nuw nsw i64 %indvars.iv92.i, 1
  %exitcond98.not.i = icmp eq i64 %indvars.iv.next93.i, 450
  br i1 %exitcond98.not.i, label %for.cond.cleanup24.i, label %for.body25.i, !llvm.loop !19

while.body:                                       ; preds = %while.cond.preheader, %for.cond.cleanup49
  %preset_index.0119 = phi i32 [ %preset_index.1, %for.cond.cleanup49 ], [ 0, %while.cond.preheader ]
  %paused.0118 = phi i8 [ %paused.1, %for.cond.cleanup49 ], [ 0, %while.cond.preheader ]
  %prev_r.0117 = phi i1 [ %call9, %for.cond.cleanup49 ], [ false, %while.cond.preheader ]
  %prev_space.0116 = phi i1 [ %call2, %for.cond.cleanup49 ], [ false, %while.cond.preheader ]
  %call2 = tail call zeroext i1 @is_key_pressed(i32 noundef 0) #7
  %call2.not = xor i1 %call2, true
  %brmerge = or i1 %prev_space.0116, %call2.not
  %10 = and i8 %paused.0118, 1
  %11 = xor i8 %10, 1
  %paused.1 = select i1 %brmerge, i8 %paused.0118, i8 %11
  %call9 = tail call zeroext i1 @is_key_pressed(i32 noundef 1) #7
  %call9.not = xor i1 %call9, true
  %brmerge81 = or i1 %prev_r.0117, %call9.not
  br i1 %brmerge81, label %if.end17, label %if.then14

if.then14:                                        ; preds = %while.body
  tail call void @llvm.experimental.noalias.scope.decl(metadata !20)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !23)
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(1920000) %1, i8 0, i64 1920000, i1 false) #7, !tbaa !10, !alias.scope !23, !noalias !20
  br label %for.cond1.preheader.i84

for.cond1.preheader.i84:                          ; preds = %for.cond.cleanup3.i87, %if.then14
  %indvar.i83 = phi i64 [ 0, %if.then14 ], [ %indvar.next.i85, %for.cond.cleanup3.i87 ]
  br label %for.body4.i92

for.cond.cleanup3.i87:                            ; preds = %for.body4.i92
  %indvar.next.i85 = add nuw nsw i64 %indvar.i83, 1
  %exitcond91.not.i86 = icmp eq i64 %indvar.next.i85, 600
  br i1 %exitcond91.not.i86, label %for.cond21.preheader.i94, label %for.cond1.preheader.i84, !llvm.loop !14

for.body4.i92:                                    ; preds = %for.body4.i92, %for.cond1.preheader.i84
  %indvars.iv.i88 = phi i64 [ 0, %for.cond1.preheader.i84 ], [ %indvars.iv.next.i90, %for.body4.i92 ]
  %arrayidx6.i89 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %indvar.i83, i64 %indvars.iv.i88
  store float 1.000000e+00, float* %arrayidx6.i89, align 4, !tbaa !10, !alias.scope !20, !noalias !23
  %indvars.iv.next.i90 = add nuw nsw i64 %indvars.iv.i88, 1
  %exitcond.not.i91 = icmp eq i64 %indvars.iv.next.i90, 800
  br i1 %exitcond.not.i91, label %for.cond.cleanup3.i87, label %for.body4.i92, !llvm.loop !17

for.cond21.preheader.i94:                         ; preds = %for.cond.cleanup3.i87, %for.cond.cleanup24.i97
  %indvars.iv99.i93 = phi i64 [ %indvars.iv.next100.i95, %for.cond.cleanup24.i97 ], [ 250, %for.cond.cleanup3.i87 ]
  %12 = add nsw i64 %indvars.iv99.i93, -300
  %13 = mul nsw i64 %12, %12
  br label %for.body25.i100

for.cond.cleanup24.i97:                           ; preds = %if.end.i106
  %indvars.iv.next100.i95 = add nuw nsw i64 %indvars.iv99.i93, 1
  %exitcond104.not.i96 = icmp eq i64 %indvars.iv.next100.i95, 350
  br i1 %exitcond104.not.i96, label %if.end17, label %for.cond21.preheader.i94, !llvm.loop !18

for.body25.i100:                                  ; preds = %if.end.i106, %for.cond21.preheader.i94
  %indvars.iv92.i98 = phi i64 [ 350, %for.cond21.preheader.i94 ], [ %indvars.iv.next93.i104, %if.end.i106 ]
  %14 = add nsw i64 %indvars.iv92.i98, -400
  %15 = mul nsw i64 %14, %14
  %16 = add nuw nsw i64 %15, %13
  %17 = trunc i64 %16 to i32
  %cmp31.i99 = icmp ult i32 %17, 2501
  br i1 %cmp31.i99, label %if.then.i103, label %if.end.i106

if.then.i103:                                     ; preds = %for.body25.i100
  %arrayidx35.i101 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %indvars.iv99.i93, i64 %indvars.iv92.i98
  store float 5.000000e-01, float* %arrayidx35.i101, align 4, !tbaa !10, !alias.scope !20, !noalias !23
  %arrayidx39.i102 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %indvars.iv99.i93, i64 %indvars.iv92.i98
  store float 2.500000e-01, float* %arrayidx39.i102, align 4, !tbaa !10, !alias.scope !23, !noalias !20
  br label %if.end.i106

if.end.i106:                                      ; preds = %if.then.i103, %for.body25.i100
  %indvars.iv.next93.i104 = add nuw nsw i64 %indvars.iv92.i98, 1
  %exitcond98.not.i105 = icmp eq i64 %indvars.iv.next93.i104, 450
  br i1 %exitcond98.not.i105, label %for.cond.cleanup24.i97, label %for.body25.i100, !llvm.loop !19

if.end17:                                         ; preds = %for.cond.cleanup24.i97, %while.body
  %call20 = tail call zeroext i1 @is_key_pressed(i32 noundef 2) #7
  br i1 %call20, label %if.end37, label %if.else

if.else:                                          ; preds = %if.end17
  %call22 = tail call zeroext i1 @is_key_pressed(i32 noundef 3) #7
  br i1 %call22, label %if.end37, label %if.else24

if.else24:                                        ; preds = %if.else
  %call25 = tail call zeroext i1 @is_key_pressed(i32 noundef 4) #7
  br i1 %call25, label %if.end37, label %if.else27

if.else27:                                        ; preds = %if.else24
  %call28 = tail call zeroext i1 @is_key_pressed(i32 noundef 5) #7
  br i1 %call28, label %if.end37, label %if.else30

if.else30:                                        ; preds = %if.else27
  %call31 = tail call zeroext i1 @is_key_pressed(i32 noundef 6) #7
  %spec.select = select i1 %call31, i32 4, i32 %preset_index.0119
  br label %if.end37

if.end37:                                         ; preds = %if.else30, %if.else27, %if.else24, %if.else, %if.end17
  %preset_index.1 = phi i32 [ 0, %if.end17 ], [ 1, %if.else ], [ 2, %if.else24 ], [ 3, %if.else27 ], [ %spec.select, %if.else30 ]
  %18 = and i8 %paused.1, 1
  %tobool38.not = icmp eq i8 %18, 0
  br i1 %tobool38.not, label %for.cond.preheader, label %for.cond51.preheader.preheader

for.cond.preheader:                               ; preds = %if.end37
  %idxprom = zext i32 %preset_index.1 to i64
  %arrayidx = getelementptr inbounds [5 x float], [5 x float]* @PRESET_F, i64 0, i64 %idxprom
  %19 = load float, float* %arrayidx, align 4, !tbaa !10
  %arrayidx45 = getelementptr inbounds [5 x float], [5 x float]* @PRESET_K, i64 0, i64 %idxprom
  %20 = load float, float* %arrayidx45, align 4, !tbaa !10
  %add102.i = fadd float %19, %20
  %neg104.i = fneg float %add102.i
  br label %for.body

for.body:                                         ; preds = %for.cond.preheader, %sim_step.exit
  %s.0112 = phi i32 [ 0, %for.cond.preheader ], [ %inc, %sim_step.exit ]
  tail call void @llvm.experimental.noalias.scope.decl(metadata !25)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !28)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !30)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !32)
  br label %for.body.i

for.cond.loopexit.i:                              ; preds = %for.body6.i
  %exitcond255.not.i = icmp eq i64 %indvars.iv.next253.i, 600
  br i1 %exitcond255.not.i, label %sim_step.exit, label %for.body.i, !llvm.loop !34

for.body.i:                                       ; preds = %for.cond.loopexit.i, %for.body
  %indvars.iv252.i = phi i64 [ 0, %for.body ], [ %indvars.iv.next253.i, %for.cond.loopexit.i ]
  %indvars.iv.next253.i = add nuw nsw i64 %indvars.iv252.i, 1
  %21 = trunc i64 %indvars.iv.next253.i to i16
  %rem243.i = urem i16 %21, 600
  %22 = trunc i64 %indvars.iv252.i to i16
  %rem2.lhs.trunc.i = add i16 %22, 599
  %rem2244.i = urem i16 %rem2.lhs.trunc.i, 600
  %idxprom.i = zext i16 %rem2244.i to i64
  %idxprom35.i = zext i16 %rem243.i to i64
  br label %for.body6.i

for.body6.i:                                      ; preds = %for.body6.i, %for.body.i
  %indvars.iv.i108 = phi i64 [ 0, %for.body.i ], [ %indvars.iv.next.i109, %for.body6.i ]
  %indvars.iv.next.i109 = add nuw nsw i64 %indvars.iv.i108, 1
  %23 = trunc i64 %indvars.iv.next.i109 to i16
  %rem8245.i = urem i16 %23, 800
  %24 = trunc i64 %indvars.iv.i108 to i16
  %rem11.lhs.trunc.i = add i16 %24, 799
  %rem11246.i = urem i16 %rem11.lhs.trunc.i, 800
  %idxprom12.i = zext i16 %rem11246.i to i64
  %arrayidx13.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %idxprom.i, i64 %idxprom12.i
  %25 = load float, float* %arrayidx13.i, align 4, !tbaa !10, !alias.scope !25, !noalias !35
  %arrayidx17.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %idxprom.i, i64 %indvars.iv.i108
  %26 = load float, float* %arrayidx17.i, align 4, !tbaa !10, !alias.scope !25, !noalias !35
  %mul18.i = fmul float %26, 0x3FC99999A0000000
  %27 = tail call float @llvm.fmuladd.f32(float %25, float 0x3FA99999A0000000, float %mul18.i) #7
  %idxprom21.i = zext i16 %rem8245.i to i64
  %arrayidx22.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %idxprom.i, i64 %idxprom21.i
  %28 = load float, float* %arrayidx22.i, align 4, !tbaa !10, !alias.scope !25, !noalias !35
  %29 = tail call float @llvm.fmuladd.f32(float %28, float 0x3FA99999A0000000, float %27) #7
  %arrayidx26.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %indvars.iv252.i, i64 %idxprom12.i
  %30 = load float, float* %arrayidx26.i, align 4, !tbaa !10, !alias.scope !25, !noalias !35
  %31 = tail call float @llvm.fmuladd.f32(float %30, float 0x3FC99999A0000000, float %29) #7
  %arrayidx30.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %indvars.iv252.i, i64 %indvars.iv.i108
  %32 = load float, float* %arrayidx30.i, align 4, !tbaa !10, !alias.scope !25, !noalias !35
  %33 = tail call float @llvm.fmuladd.f32(float %32, float -1.000000e+00, float %31) #7
  %arrayidx34.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %indvars.iv252.i, i64 %idxprom21.i
  %34 = load float, float* %arrayidx34.i, align 4, !tbaa !10, !alias.scope !25, !noalias !35
  %35 = tail call float @llvm.fmuladd.f32(float %34, float 0x3FC99999A0000000, float %33) #7
  %arrayidx38.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %idxprom35.i, i64 %idxprom12.i
  %36 = load float, float* %arrayidx38.i, align 4, !tbaa !10, !alias.scope !25, !noalias !35
  %37 = tail call float @llvm.fmuladd.f32(float %36, float 0x3FA99999A0000000, float %35) #7
  %arrayidx42.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %idxprom35.i, i64 %indvars.iv.i108
  %38 = load float, float* %arrayidx42.i, align 4, !tbaa !10, !alias.scope !25, !noalias !35
  %39 = tail call float @llvm.fmuladd.f32(float %38, float 0x3FC99999A0000000, float %37) #7
  %arrayidx46.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u, i64 0, i64 %idxprom35.i, i64 %idxprom21.i
  %40 = load float, float* %arrayidx46.i, align 4, !tbaa !10, !alias.scope !25, !noalias !35
  %41 = tail call float @llvm.fmuladd.f32(float %40, float 0x3FA99999A0000000, float %39) #7
  %arrayidx50.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %idxprom.i, i64 %idxprom12.i
  %42 = load float, float* %arrayidx50.i, align 4, !tbaa !10, !alias.scope !28, !noalias !36
  %arrayidx54.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %idxprom.i, i64 %indvars.iv.i108
  %43 = load float, float* %arrayidx54.i, align 4, !tbaa !10, !alias.scope !28, !noalias !36
  %mul55.i = fmul float %43, 0x3FC99999A0000000
  %44 = tail call float @llvm.fmuladd.f32(float %42, float 0x3FA99999A0000000, float %mul55.i) #7
  %arrayidx59.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %idxprom.i, i64 %idxprom21.i
  %45 = load float, float* %arrayidx59.i, align 4, !tbaa !10, !alias.scope !28, !noalias !36
  %46 = tail call float @llvm.fmuladd.f32(float %45, float 0x3FA99999A0000000, float %44) #7
  %arrayidx63.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %indvars.iv252.i, i64 %idxprom12.i
  %47 = load float, float* %arrayidx63.i, align 4, !tbaa !10, !alias.scope !28, !noalias !36
  %48 = tail call float @llvm.fmuladd.f32(float %47, float 0x3FC99999A0000000, float %46) #7
  %arrayidx67.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %indvars.iv252.i, i64 %indvars.iv.i108
  %49 = load float, float* %arrayidx67.i, align 4, !tbaa !10, !alias.scope !28, !noalias !36
  %50 = tail call float @llvm.fmuladd.f32(float %49, float -1.000000e+00, float %48) #7
  %arrayidx71.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %indvars.iv252.i, i64 %idxprom21.i
  %51 = load float, float* %arrayidx71.i, align 4, !tbaa !10, !alias.scope !28, !noalias !36
  %52 = tail call float @llvm.fmuladd.f32(float %51, float 0x3FC99999A0000000, float %50) #7
  %arrayidx75.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %idxprom35.i, i64 %idxprom12.i
  %53 = load float, float* %arrayidx75.i, align 4, !tbaa !10, !alias.scope !28, !noalias !36
  %54 = tail call float @llvm.fmuladd.f32(float %53, float 0x3FA99999A0000000, float %52) #7
  %arrayidx79.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %idxprom35.i, i64 %indvars.iv.i108
  %55 = load float, float* %arrayidx79.i, align 4, !tbaa !10, !alias.scope !28, !noalias !36
  %56 = tail call float @llvm.fmuladd.f32(float %55, float 0x3FC99999A0000000, float %54) #7
  %arrayidx83.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %idxprom35.i, i64 %idxprom21.i
  %57 = load float, float* %arrayidx83.i, align 4, !tbaa !10, !alias.scope !28, !noalias !36
  %58 = tail call float @llvm.fmuladd.f32(float %57, float 0x3FA99999A0000000, float %56) #7
  %mul.i = fmul float %32, %49
  %mul92.i = fmul float %49, %mul.i
  %neg.i = fneg float %mul92.i
  %59 = tail call float @llvm.fmuladd.f32(float %41, float 0x3FCAD77320000000, float %neg.i) #7
  %sub94.i = fsub float 1.000000e+00, %32
  %60 = tail call float @llvm.fmuladd.f32(float %19, float %sub94.i, float %59) #7
  %61 = fadd float %32, %60
  %arrayidx100.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %u_next, i64 0, i64 %indvars.iv252.i, i64 %indvars.iv.i108
  store float %61, float* %arrayidx100.i, align 4, !tbaa !10, !alias.scope !30, !noalias !37
  %62 = tail call float @llvm.fmuladd.f32(float %58, float 0x3FBAE147A0000000, float %mul92.i) #7
  %63 = tail call float @llvm.fmuladd.f32(float %neg104.i, float %49, float %62) #7
  %64 = fadd float %49, %63
  %arrayidx109.i = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v_next, i64 0, i64 %indvars.iv252.i, i64 %indvars.iv.i108
  store float %64, float* %arrayidx109.i, align 4, !tbaa !10, !alias.scope !32, !noalias !38
  %exitcond.not.i110 = icmp eq i64 %indvars.iv.next.i109, 800
  br i1 %exitcond.not.i110, label %for.cond.loopexit.i, label %for.body6.i, !llvm.loop !39

sim_step.exit:                                    ; preds = %for.cond.loopexit.i
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(1920000) %0, i8* noundef nonnull align 16 dereferenceable(1920000) %2, i64 1920000, i1 false) #7, !tbaa !10, !alias.scope !40, !noalias !41
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(1920000) %1, i8* noundef nonnull align 16 dereferenceable(1920000) %3, i64 1920000, i1 false) #7, !tbaa !10, !alias.scope !41, !noalias !40
  %inc = add nuw nsw i32 %s.0112, 1
  %exitcond.not = icmp eq i32 %inc, 8
  br i1 %exitcond.not, label %for.cond51.preheader.preheader, label %for.body, !llvm.loop !42

for.cond51.preheader.preheader:                   ; preds = %sim_step.exit, %if.end37
  br label %for.cond51.preheader

for.cond51.preheader:                             ; preds = %for.cond51.preheader.preheader, %for.cond.cleanup53
  %indvars.iv122 = phi i64 [ %indvars.iv.next123, %for.cond.cleanup53 ], [ 0, %for.cond51.preheader.preheader ]
  %65 = trunc i64 %indvars.iv122 to i32
  br label %for.body54

for.cond.cleanup49:                               ; preds = %for.cond.cleanup53
  tail call void @flush() #7
  %call = tail call zeroext i1 @should_quit() #7
  br i1 %call, label %while.end, label %while.body, !llvm.loop !43

for.cond.cleanup53:                               ; preds = %colormap.exit
  %indvars.iv.next123 = add nuw nsw i64 %indvars.iv122, 1
  %exitcond125.not = icmp eq i64 %indvars.iv.next123, 600
  br i1 %exitcond125.not, label %for.cond.cleanup49, label %for.cond51.preheader, !llvm.loop !44

for.body54:                                       ; preds = %for.cond51.preheader, %colormap.exit
  %indvars.iv = phi i64 [ 0, %for.cond51.preheader ], [ %indvars.iv.next, %colormap.exit ]
  %arrayidx58 = getelementptr inbounds [600 x [800 x float]], [600 x [800 x float]]* %v, i64 0, i64 %indvars.iv122, i64 %indvars.iv
  %66 = load float, float* %arrayidx58, align 4, !tbaa !10
  %mul.i111 = fmul float %66, 3.000000e+00
  %cmp.i = fcmp olt float %mul.i111, 0.000000e+00
  br i1 %cmp.i, label %colormap.exit, label %if.else.i

if.else.i:                                        ; preds = %for.body54
  %cmp1.i = fcmp ogt float %mul.i111, 1.000000e+00
  br i1 %cmp1.i, label %if.then2.i, label %colormap.exit

if.then2.i:                                       ; preds = %if.else.i
  br label %colormap.exit

colormap.exit:                                    ; preds = %for.body54, %if.else.i, %if.then2.i
  %t.0.i = phi float [ 1.000000e+00, %if.then2.i ], [ %mul.i111, %if.else.i ], [ 0.000000e+00, %for.body54 ]
  %mul4.i = fmul float %t.0.i, %t.0.i
  %mul5.i = fmul float %mul4.i, 2.550000e+02
  %conv.i = fptoui float %mul5.i to i32
  %mul6.i = fmul float %t.0.i, 2.550000e+02
  %conv7.i = fptoui float %mul6.i to i32
  %sub.i = fsub float 2.000000e+00, %t.0.i
  %mul8.i = fmul float %t.0.i, %sub.i
  %mul9.i = fmul float %mul8.i, 2.550000e+02
  %conv10.i = fptoui float %mul9.i to i32
  %shl.i = shl i32 %conv.i, 16
  %shl11.i = shl i32 %conv7.i, 8
  %or.i = or i32 %shl11.i, %shl.i
  %or12.i = or i32 %or.i, %conv10.i
  %or13.i = or i32 %or12.i, -16777216
  %67 = trunc i64 %indvars.iv to i32
  tail call void @put_pixel(i32 noundef %65, i32 noundef %67, i32 noundef %or13.i) #7
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond121.not = icmp eq i64 %indvars.iv.next, 800
  br i1 %exitcond121.not, label %for.cond.cleanup53, label %for.body54, !llvm.loop !45

while.end:                                        ; preds = %for.cond.cleanup49, %while.cond.preheader
  call void @llvm.lifetime.end.p0i8(i64 1920000, i8* nonnull %3) #7
  call void @llvm.lifetime.end.p0i8(i64 1920000, i8* nonnull %2) #7
  call void @llvm.lifetime.end.p0i8(i64 1920000, i8* nonnull %1) #7
  call void @llvm.lifetime.end.p0i8(i64 1920000, i8* nonnull %0) #7
  ret void
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

declare zeroext i1 @should_quit() local_unnamed_addr #2

declare zeroext i1 @is_key_pressed(i32 noundef) local_unnamed_addr #2

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

declare void @put_pixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

declare void @flush() local_unnamed_addr #2

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.fmuladd.f32(float, float, float) #3

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #4

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #5

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.experimental.noalias.scope.decl(metadata) #6

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { argmemonly nofree nounwind willreturn writeonly }
attributes #5 = { argmemonly nofree nounwind willreturn }
attributes #6 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #7 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{!6}
!6 = distinct !{!6, !7, !"init_grid: %u"}
!7 = distinct !{!7, !"init_grid"}
!8 = !{!9}
!9 = distinct !{!9, !7, !"init_grid: %v"}
!10 = !{!11, !11, i64 0}
!11 = !{!"float", !12, i64 0}
!12 = !{!"omnipotent char", !13, i64 0}
!13 = !{!"Simple C/C++ TBAA"}
!14 = distinct !{!14, !15, !16}
!15 = !{!"llvm.loop.mustprogress"}
!16 = !{!"llvm.loop.unroll.disable"}
!17 = distinct !{!17, !15, !16}
!18 = distinct !{!18, !15, !16}
!19 = distinct !{!19, !15, !16}
!20 = !{!21}
!21 = distinct !{!21, !22, !"init_grid: %u"}
!22 = distinct !{!22, !"init_grid"}
!23 = !{!24}
!24 = distinct !{!24, !22, !"init_grid: %v"}
!25 = !{!26}
!26 = distinct !{!26, !27, !"sim_step: %u"}
!27 = distinct !{!27, !"sim_step"}
!28 = !{!29}
!29 = distinct !{!29, !27, !"sim_step: %v"}
!30 = !{!31}
!31 = distinct !{!31, !27, !"sim_step: %u_next"}
!32 = !{!33}
!33 = distinct !{!33, !27, !"sim_step: %v_next"}
!34 = distinct !{!34, !15, !16}
!35 = !{!29, !31, !33}
!36 = !{!26, !31, !33}
!37 = !{!26, !29, !33}
!38 = !{!26, !29, !31}
!39 = distinct !{!39, !15, !16}
!40 = !{!26, !31}
!41 = !{!29, !33}
!42 = distinct !{!42, !15, !16}
!43 = distinct !{!43, !15, !16}
!44 = distinct !{!44, !15, !16}
!45 = distinct !{!45, !15, !16}
