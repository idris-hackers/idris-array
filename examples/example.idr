module Main

import Data.String

import Data.Array

main : IO ()
main = do
    (cmd::args) <- getArgs
    arr <- fromList $ map unpack args
    printLn (length arr)
    main' arr
  where main' : IOArray (List Char) -> IO ()
        main' arr = do
          putStr "> "
          line <- getLine
          Just ix <- pure $ parsePositive {a = Int} line | pure ()
          True <- pure $ ix < length arr | pure ()
          printLn !(index ix arr)
          main' arr

