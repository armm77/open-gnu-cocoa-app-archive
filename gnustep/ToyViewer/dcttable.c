/*
 *  dcttable.c
 *  ToyViewer
 *
 *  Created by OGIHARA Takeshi on Thu Jan 31 2002.
 *  Copyright (c) 2001 OGIHARA Takeshi. All rights reserved.
 *
 */

#include "dcttable.h"

const DCT_ratioCell DCT_ratioTable[] = {
	{-100.0,  1,  1,  0 },
#if (DCTMAXSIZE >= 20)
	{  5.000, 1, 20,  1 },
	{  5.556, 1, 18,  1 },
#endif
	{  6.250, 1, 16,  1 },
	{  6.667, 1, 15,  1 },
	{  7.143, 1, 14,  1 },
	{  8.333, 1, 12,  1 },
	{  9.091, 1, 11,  1 },
	{ 10.000, 1, 10,  1 },
	{ 12.500, 1,  8,  1 }, /* 2 & 16 */
	{ 13.333, 2, 15,  0 },
	{ 14.286, 2, 14,  1 },
	{ 15.385, 2, 13,  0 },
	{ 16.667, 2, 12,  1 },
	{ 18.182, 2, 11,  0 },
	{ 18.750, 3, 16,  4 },
	{ 20.000, 2, 10,  1 },
	{ 22.222, 2,  9,  0 },
	{ 25.000, 2,  8,  1 }, /* 3 & 12 */
	{ 27.273, 3, 11,  0 },
	{ 30.000, 3, 10,  2 },
	{ 31.250, 5, 16,  0 },
	{ 33.333, 3,  9,  1 }, /* 4 & 12 */
	{ 37.500, 3,  8,  0 }, /* 6 & 16 */
#if (DCTMAXSIZE >= 18)
	{ 38.889, 7, 18,  0 },
#endif
	{ 40.000, 4, 10,  2 },
#if (DCTMAXSIZE >= 18)
	{ 41.176, 7, 17,  0 },
#endif
	{ 43.750, 7, 16,  2 },
	{ 46.154, 6, 13,  0 },
	{ 50.000, 4,  8,  1 }, /* 5&10, 6&12, 7&14, 8&16 */
	{ 53.333, 8, 15,  0 },
	{ 55.556, 5,  9,  1 },
	{ 57.143, 8, 14,  0 },
	{ 60.000, 6, 10,  1 },
	{ 62.500, 5,  8,  0 }, /* 10 & 16 */
#if (DCTMAXSIZE >= 18)
	{ 64.706, 11, 17,  0 },
#endif
	{ 66.667, 6,  9,  1 }, /* 8 & 12 */
#if (DCTMAXSIZE >= 20)
	{ 68.421, 13, 19,  0 },
#endif
	{ 70.000, 7, 10,  1 },
	{ 71.429, 10, 14,  0 },
	{ 75.000, 6,  8,  1 }, /* 12 & 16, 9 & 12 */
	{ 77.778, 7,  9,  1 },
	{ 80.000, 8, 10,  1 },
	{ 83.333, 10, 12,  1 },
	{ 86.667, 13, 15,  0 },
	{ 88.889, 8,  9,  1 },
	{ 90.000, 9, 10,  1 },
	{ 93.750, 15, 16,  1 },
	{ 100.000, 8, 8,  0 },
#if (DCTMAXSIZE >= 20)
	{ 105.263, 20, 19,  0 },
#endif
	{ 106.667, 16, 15,  0 },
	{ 110.000, 11, 10,  0 },
	{ 116.667, 14, 12,  0 },
	{ 120.000, 12, 10,  0 },
	{ 125.000, 10,  8,  0 },
	{ 130.000, 13, 10,  0 },
	{ 133.333, 12,  9,  0 },
	{ 140.000, 14, 10,  0 },
	{ 144.444, 13,  9,  0 },
	{ 150.000, 12,  8,  0 },
	{ 160.000, 16, 10,  0 },
	{ 166.667, 15,  9,  0 },
	{ 175.000, 14,  8,  0 },
	{ 180.000,  9,  5,  0 },
	{ 187.500, 15,  8,  0 },
	{ 200.000, 16,  8,  0 },
	{ 214.286, 15,  7,  0 },
	{ 225.000,  9,  4,  0 },
	{ 233.333, 14,  6,  0 },
	{ 240.000, 12,  5,  0 },
	{ 250.000, 15,  6,  0 },
	{ 260.000, 13,  5,  0 },
	{ 280.000, 14,  5,  0 },
	{ 300.000, 15,  5,  0 },
	{ 320.000, 16,  5,  0 },
	{ 333.333, 10,  3,  0 },
	{ 350.000, 14,  4,  0 },
	{ 375.000, 15,  4,  0 },
	{ 400.000, 16,  4,  0 },
	{ 433.333, 13,  3,  0 },
	{ 450.000,  9,  2,  0 },
	{ 466.667, 14,  3,  0 },
	{ 500.000, 15,  3,  0 },
	{ 533.333, 16,  3,  0 },
	{ 550.000, 11,  2,  0 },
	{ 600.000, 12,  2,  0 },
	{ 650.000, 13,  2,  0 },
	{ 700.000, 14,  2,  0 },
	{ 750.000, 15,  2,  0 },
	{ 800.000, 16,  2,  0 },
	{ 99999.000, 1, 1,  0 }
};

int DCT_TableIndex(int x, float ratio)
{
	int	i;

	if (DCT_ratioTable[x].r == ratio)
		return x;
	if (DCT_ratioTable[x].r < ratio) {
		for (i = x; DCT_ratioTable[i].r < ratio; i++)
			;
		if (DCT_ratioTable[i].r - ratio > ratio - DCT_ratioTable[i-1].r)
			--i;
	}else {
		for (i = x; DCT_ratioTable[i].r > ratio; i--)
			;
		if (ratio - DCT_ratioTable[i].r > DCT_ratioTable[i+1].r - ratio)
			++i;
	}
	return i;
}

int DCT_TableIndexForThumb(float ratio)
{
	int	x;

	ratio *= 100.0;
	for (x = 1; DCT_ratioTable[x].r < ratio
		 || DCT_ratioTable[x].thumb == 0; x++)
		;
	return x;
}

