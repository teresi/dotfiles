#include <gtest/gtest.h>

#include "my_project/my_lib.hpp"

TEST(MathTest, AddsPositiveNumbers) { EXPECT_EQ(add(2, 3), 5); }

TEST(MathTest, AddsNegativeNumbers) { EXPECT_EQ(add(-2, -3), -5); }

TEST(MathTest, AddsZero) { EXPECT_EQ(add(5, 0), 5); }
