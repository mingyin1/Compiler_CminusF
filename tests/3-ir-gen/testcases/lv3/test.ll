; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local float @get(float* %0, i32 %1, i32 %2, i32 %3) #0 {
  %5 = alloca float*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store float* %0, float** %5, align 8
  store i32 %1, i32* %6, align 4
  store i32 %2, i32* %7, align 4
  store i32 %3, i32* %8, align 4
  %9 = load float*, float** %5, align 8
  %10 = load i32, i32* %6, align 4
  %11 = load i32, i32* %8, align 4
  %12 = mul nsw i32 %10, %11
  %13 = load i32, i32* %7, align 4
  %14 = add nsw i32 %12, %13
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds float, float* %9, i64 %15
  %17 = load float, float* %16, align 4
  ret float %17
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local float @abs(float %0) #0 {
  %2 = alloca float, align 4
  %3 = alloca float, align 4
  store float %0, float* %3, align 4
  %4 = load float, float* %3, align 4
  %5 = fcmp ogt float %4, 0.000000e+00
  br i1 %5, label %6, label %8

6:                                                ; preds = %1
  %7 = load float, float* %3, align 4
  store float %7, float* %2, align 4
  br label %11

8:                                                ; preds = %1
  %9 = load float, float* %3, align 4
  %10 = fsub float 0.000000e+00, %9
  store float %10, float* %2, align 4
  br label %11

11:                                               ; preds = %8, %6
  %12 = load float, float* %2, align 4
  ret float %12
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local float @isZero(float %0) #0 {
  %2 = alloca float, align 4
  store float %0, float* %2, align 4
  %3 = load float, float* %2, align 4
  %4 = call float @abs(float %3)
  %5 = fpext float %4 to double
  %6 = fcmp olt double %5, 0x3EB0C6F7A0B5ED8D
  %7 = zext i1 %6 to i32
  %8 = sitofp i32 %7 to float
  ret float %8
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @gauss(float* %0, float* %1, i32 %2) #0 {
  %4 = alloca float*, align 8
  %5 = alloca float*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca float, align 4
  store float* %0, float** %4, align 8
  store float* %1, float** %5, align 8
  store i32 %2, i32* %6, align 4
  %14 = load i32, i32* %6, align 4
  %15 = add nsw i32 %14, 1
  store i32 %15, i32* %10, align 4
  store i32 0, i32* %7, align 4
  br label %16

16:                                               ; preds = %20, %3
  %17 = load i32, i32* %7, align 4
  %18 = load i32, i32* %6, align 4
  %19 = icmp slt i32 %17, %18
  br i1 %19, label %20, label %27

20:                                               ; preds = %16
  %21 = load float*, float** %4, align 8
  %22 = load i32, i32* %7, align 4
  %23 = sext i32 %22 to i64
  %24 = getelementptr inbounds float, float* %21, i64 %23
  store float 0.000000e+00, float* %24, align 4
  %25 = load i32, i32* %7, align 4
  %26 = add nsw i32 %25, 1
  store i32 %26, i32* %7, align 4
  br label %16

27:                                               ; preds = %16
  store i32 0, i32* %12, align 4
  store i32 0, i32* %9, align 4
  br label %28

28:                                               ; preds = %177, %27
  %29 = load i32, i32* %9, align 4
  %30 = load i32, i32* %6, align 4
  %31 = icmp slt i32 %29, %30
  br i1 %31, label %32, label %182

32:                                               ; preds = %28
  %33 = load i32, i32* %9, align 4
  store i32 %33, i32* %11, align 4
  %34 = load i32, i32* %9, align 4
  %35 = add nsw i32 %34, 1
  store i32 %35, i32* %7, align 4
  br label %36

36:                                               ; preds = %56, %32
  %37 = load i32, i32* %7, align 4
  %38 = load i32, i32* %6, align 4
  %39 = icmp slt i32 %37, %38
  br i1 %39, label %40, label %59

40:                                               ; preds = %36
  %41 = load float*, float** %5, align 8
  %42 = load i32, i32* %7, align 4
  %43 = load i32, i32* %12, align 4
  %44 = load i32, i32* %10, align 4
  %45 = call float @get(float* %41, i32 %42, i32 %43, i32 %44)
  %46 = call float @abs(float %45)
  %47 = load float*, float** %5, align 8
  %48 = load i32, i32* %11, align 4
  %49 = load i32, i32* %12, align 4
  %50 = load i32, i32* %10, align 4
  %51 = call float @get(float* %47, i32 %48, i32 %49, i32 %50)
  %52 = call float @abs(float %51)
  %53 = fcmp ogt float %46, %52
  br i1 %53, label %54, label %56

54:                                               ; preds = %40
  %55 = load i32, i32* %7, align 4
  store i32 %55, i32* %11, align 4
  br label %56

56:                                               ; preds = %54, %40
  %57 = load i32, i32* %7, align 4
  %58 = add nsw i32 %57, 1
  store i32 %58, i32* %7, align 4
  br label %36

59:                                               ; preds = %36
  %60 = load i32, i32* %11, align 4
  %61 = load i32, i32* %9, align 4
  %62 = icmp ne i32 %60, %61
  br i1 %62, label %63, label %100

63:                                               ; preds = %59
  %64 = load i32, i32* %9, align 4
  store i32 %64, i32* %8, align 4
  br label %65

65:                                               ; preds = %69, %63
  %66 = load i32, i32* %8, align 4
  %67 = load i32, i32* %10, align 4
  %68 = icmp slt i32 %66, %67
  br i1 %68, label %69, label %99

69:                                               ; preds = %65
  %70 = load float*, float** %5, align 8
  %71 = load i32, i32* %9, align 4
  %72 = load i32, i32* %8, align 4
  %73 = load i32, i32* %10, align 4
  %74 = call float @get(float* %70, i32 %71, i32 %72, i32 %73)
  store float %74, float* %13, align 4
  %75 = load float*, float** %5, align 8
  %76 = load i32, i32* %11, align 4
  %77 = load i32, i32* %8, align 4
  %78 = load i32, i32* %10, align 4
  %79 = call float @get(float* %75, i32 %76, i32 %77, i32 %78)
  %80 = load float*, float** %5, align 8
  %81 = load i32, i32* %9, align 4
  %82 = load i32, i32* %10, align 4
  %83 = mul nsw i32 %81, %82
  %84 = load i32, i32* %8, align 4
  %85 = add nsw i32 %83, %84
  %86 = sext i32 %85 to i64
  %87 = getelementptr inbounds float, float* %80, i64 %86
  store float %79, float* %87, align 4
  %88 = load float, float* %13, align 4
  %89 = load float*, float** %5, align 8
  %90 = load i32, i32* %11, align 4
  %91 = load i32, i32* %10, align 4
  %92 = mul nsw i32 %90, %91
  %93 = load i32, i32* %8, align 4
  %94 = add nsw i32 %92, %93
  %95 = sext i32 %94 to i64
  %96 = getelementptr inbounds float, float* %89, i64 %95
  store float %88, float* %96, align 4
  %97 = load i32, i32* %8, align 4
  %98 = add nsw i32 %97, 1
  store i32 %98, i32* %8, align 4
  br label %65

99:                                               ; preds = %65
  br label %100

100:                                              ; preds = %99, %59
  %101 = load float*, float** %5, align 8
  %102 = load i32, i32* %9, align 4
  %103 = load i32, i32* %12, align 4
  %104 = load i32, i32* %10, align 4
  %105 = call float @get(float* %101, i32 %102, i32 %103, i32 %104)
  %106 = call float @isZero(float %105)
  %107 = fcmp une float %106, 0.000000e+00
  br i1 %107, label %108, label %111

108:                                              ; preds = %100
  %109 = load i32, i32* %9, align 4
  %110 = sub nsw i32 %109, 1
  store i32 %110, i32* %9, align 4
  br label %177

111:                                              ; preds = %100
  %112 = load i32, i32* %9, align 4
  %113 = add nsw i32 %112, 1
  store i32 %113, i32* %7, align 4
  br label %114

114:                                              ; preds = %173, %111
  %115 = load i32, i32* %7, align 4
  %116 = load i32, i32* %6, align 4
  %117 = icmp slt i32 %115, %116
  br i1 %117, label %118, label %176

118:                                              ; preds = %114
  %119 = load float*, float** %5, align 8
  %120 = load i32, i32* %7, align 4
  %121 = load i32, i32* %12, align 4
  %122 = load i32, i32* %10, align 4
  %123 = call float @get(float* %119, i32 %120, i32 %121, i32 %122)
  %124 = call float @isZero(float %123)
  %125 = fsub float 1.000000e+00, %124
  %126 = fcmp une float %125, 0.000000e+00
  br i1 %126, label %127, label %173

127:                                              ; preds = %118
  %128 = load float*, float** %5, align 8
  %129 = load i32, i32* %7, align 4
  %130 = load i32, i32* %12, align 4
  %131 = load i32, i32* %10, align 4
  %132 = call float @get(float* %128, i32 %129, i32 %130, i32 %131)
  %133 = load float*, float** %5, align 8
  %134 = load i32, i32* %9, align 4
  %135 = load i32, i32* %12, align 4
  %136 = load i32, i32* %10, align 4
  %137 = call float @get(float* %133, i32 %134, i32 %135, i32 %136)
  %138 = fdiv float %132, %137
  store float %138, float* %13, align 4
  %139 = load i32, i32* %12, align 4
  store i32 %139, i32* %8, align 4
  br label %140

140:                                              ; preds = %144, %127
  %141 = load i32, i32* %8, align 4
  %142 = load i32, i32* %10, align 4
  %143 = icmp slt i32 %141, %142
  br i1 %143, label %144, label %172

144:                                              ; preds = %140
  %145 = load float*, float** %5, align 8
  %146 = load i32, i32* %7, align 4
  %147 = load i32, i32* %10, align 4
  %148 = mul nsw i32 %146, %147
  %149 = load i32, i32* %8, align 4
  %150 = add nsw i32 %148, %149
  %151 = sext i32 %150 to i64
  %152 = getelementptr inbounds float, float* %145, i64 %151
  %153 = load float, float* %152, align 4
  %154 = load float*, float** %5, align 8
  %155 = load i32, i32* %9, align 4
  %156 = load i32, i32* %8, align 4
  %157 = load i32, i32* %10, align 4
  %158 = call float @get(float* %154, i32 %155, i32 %156, i32 %157)
  %159 = load float, float* %13, align 4
  %160 = fmul float %158, %159
  %161 = fsub float %153, %160
  %162 = load float*, float** %5, align 8
  %163 = load i32, i32* %7, align 4
  %164 = load i32, i32* %10, align 4
  %165 = mul nsw i32 %163, %164
  %166 = load i32, i32* %8, align 4
  %167 = add nsw i32 %165, %166
  %168 = sext i32 %167 to i64
  %169 = getelementptr inbounds float, float* %162, i64 %168
  store float %161, float* %169, align 4
  %170 = load i32, i32* %8, align 4
  %171 = add nsw i32 %170, 1
  store i32 %171, i32* %8, align 4
  br label %140

172:                                              ; preds = %140
  br label %173

173:                                              ; preds = %172, %118
  %174 = load i32, i32* %7, align 4
  %175 = add nsw i32 %174, 1
  store i32 %175, i32* %7, align 4
  br label %114

176:                                              ; preds = %114
  br label %177

177:                                              ; preds = %176, %108
  %178 = load i32, i32* %9, align 4
  %179 = add nsw i32 %178, 1
  store i32 %179, i32* %9, align 4
  %180 = load i32, i32* %12, align 4
  %181 = add nsw i32 %180, 1
  store i32 %181, i32* %12, align 4
  br label %28

182:                                              ; preds = %28
  %183 = load i32, i32* %6, align 4
  %184 = sub nsw i32 %183, 1
  store i32 %184, i32* %7, align 4
  br label %185

185:                                              ; preds = %226, %182
  %186 = load i32, i32* %7, align 4
  %187 = icmp sge i32 %186, 0
  br i1 %187, label %188, label %240

188:                                              ; preds = %185
  %189 = load float*, float** %5, align 8
  %190 = load i32, i32* %7, align 4
  %191 = load i32, i32* %6, align 4
  %192 = load i32, i32* %10, align 4
  %193 = call float @get(float* %189, i32 %190, i32 %191, i32 %192)
  store float %193, float* %13, align 4
  %194 = load i32, i32* %7, align 4
  %195 = add nsw i32 %194, 1
  store i32 %195, i32* %8, align 4
  br label %196

196:                                              ; preds = %223, %188
  %197 = load i32, i32* %8, align 4
  %198 = load i32, i32* %6, align 4
  %199 = icmp slt i32 %197, %198
  br i1 %199, label %200, label %226

200:                                              ; preds = %196
  %201 = load float*, float** %5, align 8
  %202 = load i32, i32* %7, align 4
  %203 = load i32, i32* %8, align 4
  %204 = load i32, i32* %10, align 4
  %205 = call float @get(float* %201, i32 %202, i32 %203, i32 %204)
  %206 = call float @isZero(float %205)
  %207 = fsub float 1.000000e+00, %206
  %208 = fcmp une float %207, 0.000000e+00
  br i1 %208, label %209, label %223

209:                                              ; preds = %200
  %210 = load float, float* %13, align 4
  %211 = load float*, float** %5, align 8
  %212 = load i32, i32* %7, align 4
  %213 = load i32, i32* %8, align 4
  %214 = load i32, i32* %10, align 4
  %215 = call float @get(float* %211, i32 %212, i32 %213, i32 %214)
  %216 = load float*, float** %4, align 8
  %217 = load i32, i32* %8, align 4
  %218 = sext i32 %217 to i64
  %219 = getelementptr inbounds float, float* %216, i64 %218
  %220 = load float, float* %219, align 4
  %221 = fmul float %215, %220
  %222 = fsub float %210, %221
  store float %222, float* %13, align 4
  br label %223

223:                                              ; preds = %209, %200
  %224 = load i32, i32* %8, align 4
  %225 = add nsw i32 %224, 1
  store i32 %225, i32* %8, align 4
  br label %196

226:                                              ; preds = %196
  %227 = load float, float* %13, align 4
  %228 = load float*, float** %5, align 8
  %229 = load i32, i32* %7, align 4
  %230 = load i32, i32* %7, align 4
  %231 = load i32, i32* %10, align 4
  %232 = call float @get(float* %228, i32 %229, i32 %230, i32 %231)
  %233 = fdiv float %227, %232
  %234 = load float*, float** %4, align 8
  %235 = load i32, i32* %7, align 4
  %236 = sext i32 %235 to i64
  %237 = getelementptr inbounds float, float* %234, i64 %236
  store float %233, float* %237, align 4
  %238 = load i32, i32* %7, align 4
  %239 = sub nsw i32 %238, 1
  store i32 %239, i32* %7, align 4
  br label %185

240:                                              ; preds = %185
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x float], align 4
  %3 = alloca [12 x float], align 16
  %4 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 0
  store float 1.000000e+00, float* %4, align 16
  %5 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 1
  store float 2.000000e+00, float* %5, align 4
  %6 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 2
  store float 1.000000e+00, float* %6, align 8
  %7 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 3
  store float 1.000000e+00, float* %7, align 4
  %8 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 4
  store float 2.000000e+00, float* %8, align 16
  %9 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 5
  store float 3.000000e+00, float* %9, align 4
  %10 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 6
  store float 4.000000e+00, float* %10, align 8
  %11 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 7
  store float 3.000000e+00, float* %11, align 4
  %12 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 8
  store float 1.000000e+00, float* %12, align 16
  %13 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 9
  store float 1.000000e+00, float* %13, align 4
  %14 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 10
  store float -2.000000e+00, float* %14, align 8
  %15 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 11
  store float 0.000000e+00, float* %15, align 4
  %16 = getelementptr inbounds [3 x float], [3 x float]* %2, i64 0, i64 0
  %17 = getelementptr inbounds [12 x float], [12 x float]* %3, i64 0, i64 0
  %18 = call i32 @gauss(float* %16, float* %17, i32 3)
  store i32 0, i32* %1, align 4
  br label %19

19:                                               ; preds = %22, %0
  %20 = load i32, i32* %1, align 4
  %21 = icmp slt i32 %20, 3
  br i1 %21, label %22, label %31

22:                                               ; preds = %19
  %23 = load i32, i32* %1, align 4
  %24 = sext i32 %23 to i64
  %25 = getelementptr inbounds [3 x float], [3 x float]* %2, i64 0, i64 %24
  %26 = load float, float* %25, align 4
  %27 = fpext float %26 to double
  %28 = call i32 (double, ...) bitcast (i32 (...)* @outputFloat to i32 (double, ...)*)(double %27)
  %29 = load i32, i32* %1, align 4
  %30 = add nsw i32 %29, 1
  store i32 %30, i32* %1, align 4
  br label %19

31:                                               ; preds = %19
  ret void
}

declare dso_local i32 @outputFloat(...) #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.1 "}
