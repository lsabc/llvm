//===- unittest/ADT/MapVectorTest.cpp - MapVector unit tests ----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "gtest/gtest.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/iterator_range.h"
#include <utility>

using namespace llvm;

TEST(MapVectorTest, insert_pop) {
  MapVector<int, int> MV;
  std::pair<MapVector<int, int>::iterator, bool> R;

  R = MV.insert(std::make_pair(1, 2));
  ASSERT_EQ(R.first, MV.begin());
  EXPECT_EQ(R.first->first, 1);
  EXPECT_EQ(R.first->second, 2);
  EXPECT_TRUE(R.second);

  R = MV.insert(std::make_pair(1, 3));
  ASSERT_EQ(R.first, MV.begin());
  EXPECT_EQ(R.first->first, 1);
  EXPECT_EQ(R.first->second, 2);
  EXPECT_FALSE(R.second);

  R = MV.insert(std::make_pair(4, 5));
  ASSERT_NE(R.first, MV.end());
  EXPECT_EQ(R.first->first, 4);
  EXPECT_EQ(R.first->second, 5);
  EXPECT_TRUE(R.second);

  EXPECT_EQ(MV.size(), 2u);
  EXPECT_EQ(MV[1], 2);
  EXPECT_EQ(MV[4], 5);

  MV.pop_back();
  EXPECT_EQ(MV.size(), 1u);
  EXPECT_EQ(MV[1], 2);

  R = MV.insert(std::make_pair(4, 7));
  ASSERT_NE(R.first, MV.end());
  EXPECT_EQ(R.first->first, 4);
  EXPECT_EQ(R.first->second, 7);
  EXPECT_TRUE(R.second);  

  EXPECT_EQ(MV.size(), 2u);
  EXPECT_EQ(MV[1], 2);
  EXPECT_EQ(MV[4], 7);
}

TEST(MapVectorTest, erase) {
  MapVector<int, int> MV;

  MV.insert(std::make_pair(1, 2));
  MV.insert(std::make_pair(3, 4));
  MV.insert(std::make_pair(5, 6));
  ASSERT_EQ(MV.size(), 3u);

  MV.erase(MV.find(1));
  ASSERT_EQ(MV.size(), 2u);
  ASSERT_EQ(MV.find(1), MV.end());
  ASSERT_EQ(MV[3], 4);
  ASSERT_EQ(MV[5], 6);

  ASSERT_EQ(MV.erase(3), 1u);
  ASSERT_EQ(MV.size(), 1u);
  ASSERT_EQ(MV.find(3), MV.end());
  ASSERT_EQ(MV[5], 6);

  ASSERT_EQ(MV.erase(79), 0u);
  ASSERT_EQ(MV.size(), 1u);
}

TEST(MapVectorTest, remove_if) {
  MapVector<int, int> MV;

  MV.insert(std::make_pair(1, 11));
  MV.insert(std::make_pair(2, 12));
  MV.insert(std::make_pair(3, 13));
  MV.insert(std::make_pair(4, 14));
  MV.insert(std::make_pair(5, 15));
  MV.insert(std::make_pair(6, 16));
  ASSERT_EQ(MV.size(), 6u);

  MV.remove_if([](const std::pair<int, int> &Val) { return Val.second % 2; });
  ASSERT_EQ(MV.size(), 3u);
  ASSERT_EQ(MV.find(1), MV.end());
  ASSERT_EQ(MV.find(3), MV.end());
  ASSERT_EQ(MV.find(5), MV.end());
  ASSERT_EQ(MV[2], 12);
  ASSERT_EQ(MV[4], 14);
  ASSERT_EQ(MV[6], 16);
}

TEST(MapVectorTest, iteration_test) {
  MapVector<int, int> MV;

  MV.insert(std::make_pair(1, 11));
  MV.insert(std::make_pair(2, 12));
  MV.insert(std::make_pair(3, 13));
  MV.insert(std::make_pair(4, 14));
  MV.insert(std::make_pair(5, 15));
  MV.insert(std::make_pair(6, 16));
  ASSERT_EQ(MV.size(), 6u);

  int count = 1;
  for (auto P : make_range(MV.begin(), MV.end())) {
    ASSERT_EQ(P.first, count);
    count++;
  }

  count = 6;
  for (auto P : make_range(MV.rbegin(), MV.rend())) {
    ASSERT_EQ(P.first, count);
    count--;
  }
}
