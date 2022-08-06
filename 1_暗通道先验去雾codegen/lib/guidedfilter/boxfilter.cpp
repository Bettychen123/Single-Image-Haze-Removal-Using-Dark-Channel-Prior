//
// File: boxfilter.cpp
//
// MATLAB Coder version            : 4.2
// C/C++ source code generated on  : 14-Mar-2022 10:14:45
//

// Include Files
#include "guidedfilter.h"
#include "boxfilter.h"
#include "guidedfilter_emxutil.h"
#include "repmat.h"
#include "useConstantDim.h"

// Function Definitions

//
// BOXFILTER   O(1) time box filtering using cumulative sum
//
//    - Definition imDst(x, y)=sum(sum(imSrc(x-r:x+r,y-r:y+r)));
//    - Running time independent of r;
//    - Equivalent to the function: colfilt(imSrc, [2*r+1, 2*r+1], 'sliding', @sum);
//    - But much faster.
// Arguments    : const emxArray_real32_T *imSrc
//                float r
//                emxArray_real_T *imDst
// Return Type  : void
//
void b_boxfilter(const emxArray_real32_T *imSrc, float r, emxArray_real_T *imDst)
{
  unsigned int unnamed_idx_0;
  unsigned int unnamed_idx_1;
  int i6;
  int loop_ub;
  emxArray_real32_T *imCum;
  int k;
  float f4;
  int i7;
  int subsb_idx_1;
  int ibmat;
  float f5;
  int i8;
  float f6;
  float f7;
  emxArray_real32_T *a;
  emxArray_real32_T *r2;
  emxArray_real_T *b_imCum;
  emxArray_real_T *c_imCum;
  emxArray_real_T *r3;
  float varargin_1[2];
  unnamed_idx_0 = static_cast<unsigned int>(imSrc->size[0]);
  unnamed_idx_1 = static_cast<unsigned int>(imSrc->size[1]);
  i6 = imDst->size[0] * imDst->size[1];
  imDst->size[0] = static_cast<int>(unnamed_idx_0);
  imDst->size[1] = static_cast<int>(unnamed_idx_1);
  emxEnsureCapacity_real_T(imDst, i6);
  loop_ub = static_cast<int>(unnamed_idx_0) * static_cast<int>(unnamed_idx_1);
  for (i6 = 0; i6 < loop_ub; i6++) {
    imDst->data[i6] = 0.0;
  }

  emxInit_real32_T(&imCum, 2);

  // cumulative sum over Y axis
  i6 = imCum->size[0] * imCum->size[1];
  imCum->size[0] = imSrc->size[0];
  imCum->size[1] = imSrc->size[1];
  emxEnsureCapacity_real32_T(imCum, i6);
  loop_ub = imSrc->size[0] * imSrc->size[1];
  for (i6 = 0; i6 < loop_ub; i6++) {
    imCum->data[i6] = imSrc->data[i6];
  }

  if ((imSrc->size[0] != 0) && (imSrc->size[1] != 0)) {
    i6 = imSrc->size[1];
    for (k = 0; k < i6; k++) {
      i7 = imCum->size[0];
      if (0 <= i7 - 2) {
        subsb_idx_1 = k + 1;
      }

      for (ibmat = 0; ibmat <= i7 - 2; ibmat++) {
        imCum->data[(ibmat + imCum->size[0] * (subsb_idx_1 - 1)) + 1] +=
          imCum->data[ibmat + imCum->size[0] * k];
      }
    }
  }

  // difference over Y axis
  f4 = 2.0F * r + 1.0F;
  if (1.0F + r > f4) {
    i6 = 1;
    i7 = 0;
  } else {
    i6 = static_cast<int>((1.0F + r));
    i7 = static_cast<int>(f4);
  }

  loop_ub = imCum->size[1];
  for (k = 0; k < loop_ub; k++) {
    subsb_idx_1 = i7 - i6;
    for (i8 = 0; i8 <= subsb_idx_1; i8++) {
      imDst->data[i8 + imDst->size[0] * k] = imCum->data[((i6 + i8) +
        imCum->size[0] * k) - 1];
    }
  }

  f5 = 2.0F * r + 2.0F;
  if (f5 > imSrc->size[0]) {
    i6 = 1;
    i7 = 0;
  } else {
    i6 = static_cast<int>(f5);
    i7 = static_cast<int>(static_cast<float>(imSrc->size[0]));
  }

  f6 = static_cast<float>(imSrc->size[0]) - r;
  if (r + 2.0F > f6) {
    k = 1;
  } else {
    k = static_cast<int>((r + 2.0F));
  }

  loop_ub = imCum->size[1];
  for (i8 = 0; i8 < loop_ub; i8++) {
    subsb_idx_1 = i7 - i6;
    for (ibmat = 0; ibmat <= subsb_idx_1; ibmat++) {
      imDst->data[((k + ibmat) + imDst->size[0] * i8) - 1] = imCum->data[((i6 +
        ibmat) + imCum->size[0] * i8) - 1] - imCum->data[ibmat + imCum->size[0] *
        i8];
    }
  }

  f6 = static_cast<float>(imSrc->size[0]) - 2.0F * r;
  f7 = (static_cast<float>(imSrc->size[0]) - r) - 1.0F;
  if (f6 > f7) {
    i6 = 1;
  } else {
    i6 = static_cast<int>(f6);
  }

  emxInit_real32_T(&a, 2);
  loop_ub = imCum->size[1];
  k = imSrc->size[0];
  i7 = a->size[0] * a->size[1];
  a->size[0] = 1;
  a->size[1] = loop_ub;
  emxEnsureCapacity_real32_T(a, i7);
  for (i7 = 0; i7 < loop_ub; i7++) {
    a->data[i7] = imCum->data[(k + imCum->size[0] * i7) - 1];
  }

  emxInit_real32_T(&r2, 2);
  i7 = imCum->size[1];
  k = r2->size[0] * r2->size[1];
  i8 = static_cast<int>(r);
  r2->size[0] = i8;
  r2->size[1] = i7;
  emxEnsureCapacity_real32_T(r2, k);
  i7 = imCum->size[1];
  for (k = 0; k < i7; k++) {
    ibmat = k * i8;
    for (subsb_idx_1 = 0; subsb_idx_1 < i8; subsb_idx_1++) {
      r2->data[ibmat + subsb_idx_1] = a->data[k];
    }
  }

  emxFree_real32_T(&a);
  f6 = (static_cast<float>(imSrc->size[0]) - r) + 1.0F;
  if (f6 > imSrc->size[0]) {
    i7 = 1;
  } else {
    i7 = static_cast<int>(f6);
  }

  loop_ub = r2->size[1];
  for (k = 0; k < loop_ub; k++) {
    subsb_idx_1 = r2->size[0];
    for (i8 = 0; i8 < subsb_idx_1; i8++) {
      imDst->data[((i7 + i8) + imDst->size[0] * k) - 1] = r2->data[i8 + r2->
        size[0] * k] - imCum->data[((i6 + i8) + imCum->size[0] * k) - 1];
    }
  }

  emxFree_real32_T(&r2);
  emxFree_real32_T(&imCum);
  emxInit_real_T(&b_imCum, 2);

  // cumulative sum over X axis
  i6 = b_imCum->size[0] * b_imCum->size[1];
  b_imCum->size[0] = imDst->size[0];
  b_imCum->size[1] = imDst->size[1];
  emxEnsureCapacity_real_T(b_imCum, i6);
  loop_ub = imDst->size[0] * imDst->size[1];
  for (i6 = 0; i6 < loop_ub; i6++) {
    b_imCum->data[i6] = imDst->data[i6];
  }

  useConstantDim(b_imCum, 2);

  // difference over Y axis
  if (1.0F + r > f4) {
    i6 = 1;
    i7 = 0;
  } else {
    i6 = static_cast<int>((1.0F + r));
    i7 = static_cast<int>((2.0F * r + 1.0F));
  }

  loop_ub = b_imCum->size[0];
  subsb_idx_1 = i7 - i6;
  for (i7 = 0; i7 <= subsb_idx_1; i7++) {
    for (k = 0; k < loop_ub; k++) {
      imDst->data[k + imDst->size[0] * i7] = b_imCum->data[k + b_imCum->size[0] *
        ((i6 + i7) - 1)];
    }
  }

  if (f5 > imSrc->size[1]) {
    i6 = 1;
    i7 = 0;
  } else {
    i6 = static_cast<int>((2.0F * r + 2.0F));
    i7 = static_cast<int>(static_cast<float>(imSrc->size[1]));
  }

  f4 = static_cast<float>(imSrc->size[1]) - r;
  if (r + 2.0F > f4) {
    k = 1;
  } else {
    k = static_cast<int>((r + 2.0F));
  }

  loop_ub = b_imCum->size[0];
  subsb_idx_1 = i7 - i6;
  for (i7 = 0; i7 <= subsb_idx_1; i7++) {
    for (i8 = 0; i8 < loop_ub; i8++) {
      imDst->data[i8 + imDst->size[0] * ((k + i7) - 1)] = b_imCum->data[i8 +
        b_imCum->size[0] * ((i6 + i7) - 1)] - b_imCum->data[i8 + b_imCum->size[0]
        * i7];
    }
  }

  f4 = static_cast<float>(imSrc->size[1]) - 2.0F * r;
  f5 = (static_cast<float>(imSrc->size[1]) - r) - 1.0F;
  if (f4 > f5) {
    i6 = 1;
  } else {
    i6 = static_cast<int>(f4);
  }

  emxInit_real_T(&c_imCum, 1);
  loop_ub = b_imCum->size[0];
  k = imSrc->size[1];
  i7 = c_imCum->size[0];
  c_imCum->size[0] = loop_ub;
  emxEnsureCapacity_real_T(c_imCum, i7);
  for (i7 = 0; i7 < loop_ub; i7++) {
    c_imCum->data[i7] = b_imCum->data[i7 + b_imCum->size[0] * (k - 1)];
  }

  emxInit_real_T(&r3, 2);
  varargin_1[0] = 1.0F;
  varargin_1[1] = r;
  repmat(c_imCum, varargin_1, r3);
  f4 = (static_cast<float>(imSrc->size[1]) - r) + 1.0F;
  emxFree_real_T(&c_imCum);
  if (f4 > imSrc->size[1]) {
    i7 = 1;
  } else {
    i7 = static_cast<int>(f4);
  }

  loop_ub = r3->size[1];
  for (k = 0; k < loop_ub; k++) {
    subsb_idx_1 = r3->size[0];
    for (i8 = 0; i8 < subsb_idx_1; i8++) {
      imDst->data[i8 + imDst->size[0] * ((i7 + k) - 1)] = r3->data[i8 + r3->
        size[0] * k] - b_imCum->data[i8 + b_imCum->size[0] * ((i6 + k) - 1)];
    }
  }

  emxFree_real_T(&r3);
  emxFree_real_T(&b_imCum);
}

//
// BOXFILTER   O(1) time box filtering using cumulative sum
//
//    - Definition imDst(x, y)=sum(sum(imSrc(x-r:x+r,y-r:y+r)));
//    - Running time independent of r;
//    - Equivalent to the function: colfilt(imSrc, [2*r+1, 2*r+1], 'sliding', @sum);
//    - But much faster.
// Arguments    : const emxArray_real_T *imSrc
//                float r
//                emxArray_real_T *imDst
// Return Type  : void
//
void boxfilter(const emxArray_real_T *imSrc, float r, emxArray_real_T *imDst)
{
  unsigned int unnamed_idx_0;
  unsigned int unnamed_idx_1;
  int i1;
  int loop_ub;
  emxArray_real_T *imCum;
  float f0;
  int i2;
  int b_imSrc;
  float f1;
  int ibmat;
  int i3;
  float f2;
  float f3;
  int itilerow;
  emxArray_real_T *a;
  emxArray_real_T *r1;
  emxArray_real_T *b_imCum;
  float varargin_1[2];
  unnamed_idx_0 = static_cast<unsigned int>(imSrc->size[0]);
  unnamed_idx_1 = static_cast<unsigned int>(imSrc->size[1]);
  i1 = imDst->size[0] * imDst->size[1];
  imDst->size[0] = static_cast<int>(unnamed_idx_0);
  imDst->size[1] = static_cast<int>(unnamed_idx_1);
  emxEnsureCapacity_real_T(imDst, i1);
  loop_ub = static_cast<int>(unnamed_idx_0) * static_cast<int>(unnamed_idx_1);
  for (i1 = 0; i1 < loop_ub; i1++) {
    imDst->data[i1] = 0.0;
  }

  emxInit_real_T(&imCum, 2);

  // cumulative sum over Y axis
  i1 = imCum->size[0] * imCum->size[1];
  imCum->size[0] = imSrc->size[0];
  imCum->size[1] = imSrc->size[1];
  emxEnsureCapacity_real_T(imCum, i1);
  loop_ub = imSrc->size[0] * imSrc->size[1];
  for (i1 = 0; i1 < loop_ub; i1++) {
    imCum->data[i1] = imSrc->data[i1];
  }

  useConstantDim(imCum, 1);

  // difference over Y axis
  f0 = 2.0F * r + 1.0F;
  if (1.0F + r > f0) {
    i1 = 1;
    i2 = 0;
  } else {
    i1 = static_cast<int>((1.0F + r));
    i2 = static_cast<int>(f0);
  }

  loop_ub = imCum->size[1];
  for (b_imSrc = 0; b_imSrc < loop_ub; b_imSrc++) {
    ibmat = i2 - i1;
    for (i3 = 0; i3 <= ibmat; i3++) {
      imDst->data[i3 + imDst->size[0] * b_imSrc] = imCum->data[((i1 + i3) +
        imCum->size[0] * b_imSrc) - 1];
    }
  }

  f1 = 2.0F * r + 2.0F;
  if (f1 > imSrc->size[0]) {
    i1 = 1;
    i2 = 0;
  } else {
    i1 = static_cast<int>(f1);
    i2 = static_cast<int>(static_cast<float>(imSrc->size[0]));
  }

  f2 = static_cast<float>(imSrc->size[0]) - r;
  if (r + 2.0F > f2) {
    b_imSrc = 1;
  } else {
    b_imSrc = static_cast<int>((r + 2.0F));
  }

  loop_ub = imCum->size[1];
  for (i3 = 0; i3 < loop_ub; i3++) {
    ibmat = i2 - i1;
    for (itilerow = 0; itilerow <= ibmat; itilerow++) {
      imDst->data[((b_imSrc + itilerow) + imDst->size[0] * i3) - 1] =
        imCum->data[((i1 + itilerow) + imCum->size[0] * i3) - 1] - imCum->
        data[itilerow + imCum->size[0] * i3];
    }
  }

  f2 = static_cast<float>(imSrc->size[0]) - 2.0F * r;
  f3 = (static_cast<float>(imSrc->size[0]) - r) - 1.0F;
  if (f2 > f3) {
    i1 = 1;
  } else {
    i1 = static_cast<int>(f2);
  }

  emxInit_real_T(&a, 2);
  loop_ub = imCum->size[1];
  b_imSrc = imSrc->size[0];
  i2 = a->size[0] * a->size[1];
  a->size[0] = 1;
  a->size[1] = loop_ub;
  emxEnsureCapacity_real_T(a, i2);
  for (i2 = 0; i2 < loop_ub; i2++) {
    a->data[i2] = imCum->data[(b_imSrc + imCum->size[0] * i2) - 1];
  }

  emxInit_real_T(&r1, 2);
  i2 = imCum->size[1];
  b_imSrc = r1->size[0] * r1->size[1];
  i3 = static_cast<int>(r);
  r1->size[0] = i3;
  r1->size[1] = i2;
  emxEnsureCapacity_real_T(r1, b_imSrc);
  i2 = imCum->size[1];
  for (b_imSrc = 0; b_imSrc < i2; b_imSrc++) {
    ibmat = b_imSrc * i3;
    for (itilerow = 0; itilerow < i3; itilerow++) {
      r1->data[ibmat + itilerow] = a->data[b_imSrc];
    }
  }

  emxFree_real_T(&a);
  f2 = (static_cast<float>(imSrc->size[0]) - r) + 1.0F;
  if (f2 > imSrc->size[0]) {
    i2 = 1;
  } else {
    i2 = static_cast<int>(f2);
  }

  loop_ub = r1->size[1];
  for (b_imSrc = 0; b_imSrc < loop_ub; b_imSrc++) {
    ibmat = r1->size[0];
    for (i3 = 0; i3 < ibmat; i3++) {
      imDst->data[((i2 + i3) + imDst->size[0] * b_imSrc) - 1] = r1->data[i3 +
        r1->size[0] * b_imSrc] - imCum->data[((i1 + i3) + imCum->size[0] *
        b_imSrc) - 1];
    }
  }

  // cumulative sum over X axis
  i1 = imCum->size[0] * imCum->size[1];
  imCum->size[0] = imDst->size[0];
  imCum->size[1] = imDst->size[1];
  emxEnsureCapacity_real_T(imCum, i1);
  loop_ub = imDst->size[0] * imDst->size[1];
  for (i1 = 0; i1 < loop_ub; i1++) {
    imCum->data[i1] = imDst->data[i1];
  }

  useConstantDim(imCum, 2);

  // difference over Y axis
  if (1.0F + r > f0) {
    i1 = 1;
    i2 = 0;
  } else {
    i1 = static_cast<int>((1.0F + r));
    i2 = static_cast<int>((2.0F * r + 1.0F));
  }

  loop_ub = imCum->size[0];
  ibmat = i2 - i1;
  for (i2 = 0; i2 <= ibmat; i2++) {
    for (b_imSrc = 0; b_imSrc < loop_ub; b_imSrc++) {
      imDst->data[b_imSrc + imDst->size[0] * i2] = imCum->data[b_imSrc +
        imCum->size[0] * ((i1 + i2) - 1)];
    }
  }

  if (f1 > imSrc->size[1]) {
    i1 = 1;
    i2 = 0;
  } else {
    i1 = static_cast<int>((2.0F * r + 2.0F));
    i2 = static_cast<int>(static_cast<float>(imSrc->size[1]));
  }

  f0 = static_cast<float>(imSrc->size[1]) - r;
  if (r + 2.0F > f0) {
    b_imSrc = 1;
  } else {
    b_imSrc = static_cast<int>((r + 2.0F));
  }

  loop_ub = imCum->size[0];
  ibmat = i2 - i1;
  for (i2 = 0; i2 <= ibmat; i2++) {
    for (i3 = 0; i3 < loop_ub; i3++) {
      imDst->data[i3 + imDst->size[0] * ((b_imSrc + i2) - 1)] = imCum->data[i3 +
        imCum->size[0] * ((i1 + i2) - 1)] - imCum->data[i3 + imCum->size[0] * i2];
    }
  }

  f0 = static_cast<float>(imSrc->size[1]) - 2.0F * r;
  f1 = (static_cast<float>(imSrc->size[1]) - r) - 1.0F;
  if (f0 > f1) {
    i1 = 1;
  } else {
    i1 = static_cast<int>(f0);
  }

  emxInit_real_T(&b_imCum, 1);
  loop_ub = imCum->size[0];
  b_imSrc = imSrc->size[1];
  i2 = b_imCum->size[0];
  b_imCum->size[0] = loop_ub;
  emxEnsureCapacity_real_T(b_imCum, i2);
  for (i2 = 0; i2 < loop_ub; i2++) {
    b_imCum->data[i2] = imCum->data[i2 + imCum->size[0] * (b_imSrc - 1)];
  }

  varargin_1[0] = 1.0F;
  varargin_1[1] = r;
  repmat(b_imCum, varargin_1, r1);
  f0 = (static_cast<float>(imSrc->size[1]) - r) + 1.0F;
  emxFree_real_T(&b_imCum);
  if (f0 > imSrc->size[1]) {
    i2 = 1;
  } else {
    i2 = static_cast<int>(f0);
  }

  loop_ub = r1->size[1];
  for (b_imSrc = 0; b_imSrc < loop_ub; b_imSrc++) {
    ibmat = r1->size[0];
    for (i3 = 0; i3 < ibmat; i3++) {
      imDst->data[i3 + imDst->size[0] * ((i2 + b_imSrc) - 1)] = r1->data[i3 +
        r1->size[0] * b_imSrc] - imCum->data[i3 + imCum->size[0] * ((i1 +
        b_imSrc) - 1)];
    }
  }

  emxFree_real_T(&r1);
  emxFree_real_T(&imCum);
}

//
// File trailer for boxfilter.cpp
//
// [EOF]
//
