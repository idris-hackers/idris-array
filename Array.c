
#include "Array.h"

VAL idris_makeArray(int len) {
	VAL arr;
	allocCon(arr, 0, 0, len, 0);
	return arr;
}

VAL idris_indexArray(int ix, VAL arr) {
	return GETARG(arr, ix);
}

void idris_setAtArray(int ix, VAL elem, VAL arr) {
	SETARG(arr, ix, elem);
}

