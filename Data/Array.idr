module Data.Array

%include C "Array.h"
%link C "Array.o"

%access private
%default covering

-- conId : TTName -> Elab Int

data Prim_Array = Prim_MkArray

-- This creates an uninitialized array because it allocates, which would ruin any pointers to Idris values passed in.
prim_makeArray : Int -> IO Prim_Array
prim_makeArray len = do
  MkRaw arr <- foreign FFI_C "idris_makeArray" (Int -> IO (Raw Prim_Array)) len
  pure arr

prim_indexArray : Int -> Prim_Array -> IO a
prim_indexArray {a} ix arr = do
  MkRaw elem <- foreign FFI_C "idris_indexArray" (Int -> Raw Prim_Array -> IO (Raw a)) ix (MkRaw arr)
  pure elem

prim_setAtArray : Int -> a -> Prim_Array -> IO ()
prim_setAtArray {a} ix elem arr =
  foreign FFI_C "idris_setAtArray" (Int -> Raw a -> Raw (Prim_Array) -> IO ()) ix (MkRaw elem) (MkRaw arr)

-- ###

%access export

namespace IOArray
  data IOArray : Type -> Type where
    MkIOArray : (len : Int) -> (prim_Array : Prim_Array) -> IOArray a

  %used MkIOArray prim_Array

  length : IOArray a -> Int
  length (MkIOArray len parr) = len

  fromList : List a -> IO (IOArray a)
  fromList xs = do
    let len = cast $ length xs
    parr <- prim_makeArray len
    for_ {b = ()} (zip [0 .. len - 1] xs) $ \(ix, elem) => prim_setAtArray ix elem parr
    pure $ MkIOArray len parr

  index : Int -> IOArray a -> IO a
  index ix (MkIOArray len parr) = prim_indexArray ix parr

  setAt : Int -> a -> IOArray a -> IO ()
  setAt ix elem (MkIOArray len parr) = prim_setAtArray ix elem parr

