#include "dirmark.h"

static const unsigned char dir128[] = {
    0xFF, 0xFF, 0xFF, 0xFF,  0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF,  0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF,  0xFF, 0xFF, 0xFF, 0x5F,
    0xFF, 0xFF, 0xFF, 0xFF,  0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF,  0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF,  0xFF, 0xFF, 0x5F, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x3F, 0x8A, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x45, 0x5F, 0x8A,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x0A, 0x5F, 0x55,
    0x5F, 0x8A, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x00, 0xAA, 0x8A,
    0x5F, 0x55, 0x5F, 0x8A,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x00, 0xAA, 0xAA,
    0xAA, 0x8A, 0x5F, 0x55,  0x5F, 0x8A, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x00, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0x8A,  0x5F, 0x55, 0x5F, 0x8A,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x00, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0x8A, 0x5F, 0x55,
    0x5F, 0x8A, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x00, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0x8A,
    0x5F, 0x55, 0x5F, 0x8A,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x00, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xC9,
    0xF4, 0xFF, 0xF4, 0xC9,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x00, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xC9, 0xF4, 0xFF,
    0xF4, 0xC9, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x00, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xC9,  0xF4, 0xFF, 0xF4, 0xC9,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x00, 0xAA, 0xAA,
    0xAA, 0xC9, 0xF4, 0xFF,  0xF4, 0xC9, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x00, 0xAA, 0xC9,
    0xF4, 0xFF, 0xF4, 0xC9,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0x1F, 0xF4, 0xFF,
    0xF4, 0xC9, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x00, 0xCF, 0xF4, 0xC9,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0x94, 0xC9, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0xFF, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0xAA, 0xAA,
    0xAA, 0xAA, 0xAA, 0xAA,  0xAA, 0xAA, 0x00, 0x00,
    0xFF, 0x5F, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
    0x5F, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00, 
};

static const unsigned char dir32[] = {
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x86,
    0xFF, 0x2B, 0x80, 0xAA, 0xAA, 0x00,
    0xFF, 0x2B, 0xAA, 0x55, 0x80, 0x00,
    0xFF, 0x2B, 0xB7, 0xD5, 0xD5, 0x00,
    0xFF, 0x8C, 0xD5, 0xAA, 0xAA, 0x00,
    0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 
};

static const unsigned char dir16[] = {
    0xFF, 0xD5, 0x98,
    0xD5, 0xC7, 0x55,
    0x98, 0x55, 0x00, 
};

static const fourElements dm_color = { 0, 123, 189, 255 };
#define  dmtrans	0x80
#define  dmgray		0xAA

void attachDirMarkToThumb(fourElements *img, unsigned char *mask, int posx, int posy)
{
	int y, wid, hgt, idx, i, mx, v;

	mx = 0;
	for (y = posy, hgt = DM_SIZE; hgt > 0; y++, hgt--) {
	    idx = y * ThumbSIZE + posx;
	    for (wid = DM_SIZE; wid > 0; wid--) {
	        v = dir128[mx++];
		if (v == dmgray) {
		    if (mask[idx] == 0x00) { /* Trans. */
			for (i = 1; i <= 3; i++)
				img[idx][i] = dm_color[i];
			mask[idx] = dmtrans;
		    }else {
			for (i = 1; i <= 3; i++)
				img[idx][i] = (img[idx][i] + dm_color[i]) / 2;
			if (mask[idx] < dmtrans)
				mask[idx] = dmtrans;
		    }
		}else {
		    for (i = 1; i <= 3; i++)
			img[idx][i] = v;
		    mask[idx] = 0xFF;	// Opaque
		}
		idx++;
	    }
	}
}

void attachDirMarkToLarge(fourElements *img, UInt32 *mask, int posx, int posy)
{
	const int largeMaskBytes = LargeSIZE * LargeSIZE / 4;
	int y, wid, hgt, idx, i, mx, v;
	UInt32 dmask;

	mask += largeMaskBytes;
	dmask = ~(~0 << DM_SIZE_L) << (32 - DM_SIZE_L - posx);
	mx = 0;
	for (y = posy, hgt = DM_SIZE_L; hgt > 0; y++, hgt--) {
		idx = y * LargeSIZE + posx;
		for (wid = DM_SIZE_L; wid > 0; wid--) {
			v = dir32[mx++];
			for (i = 1; i <= 3; i++)
				img[idx][i] = v;
			idx++;
		}
		mask[y] |= dmask;
	}
}

void attachDirMarkToSmall(fourElements *img, UInt16 *mask, int posx, int posy)
{
	const int smallMaskBytes = SmallSIZE * SmallSIZE / 4;
	int y, wid, hgt, idx, i, mx, v;
	UInt16 dmask;

	mask += smallMaskBytes;
	dmask = ~(~0 << DM_SIZE_S) << (16 - DM_SIZE_S - posx);
	mx = 0;
	for (y = posy, hgt = DM_SIZE_S; hgt > 0; y++, hgt--) {
		idx = y * SmallSIZE + posx;
		for (wid = DM_SIZE_S; wid > 0; wid--) {
			v = dir16[mx++];
			for (i = 1; i <= 3; i++)
				img[idx][i] = v;
			idx++;
		}
		mask[y] |= dmask;
	}
}
