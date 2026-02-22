module Main where

import Data.List (group, sort, sortBy)
import Data.Ord  (comparing, Down(..))
import Data.Char (toLower, isAlpha)
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

-- | Count occurrences of each element in a list.
frequency :: (Ord a) => [a] -> Map a Int
frequency = foldr (\x m -> Map.insertWith (+) x 1 m) Map.empty

-- | Return the n most frequent elements, sorted descending by count.
topN :: (Ord a) => Int -> [a] -> [(a, Int)]
topN n xs =
  take n
    . sortBy (comparing (Down . snd))
    . Map.toList
    $ frequency xs

-- | Tokenise a string into lowercase words (letters only).
tokenise :: String -> [String]
tokenise = words . map (\c -> if isAlpha c then toLower c else ' ')

-- | Run-length encoding.
rle :: (Eq a) => [a] -> [(Int, a)]
rle = map (\g -> (length g, head g)) . group

-- | Decode run-length encoded data.
rldecode :: [(Int, a)] -> [a]
rldecode = concatMap (uncurry replicate)

-- | Caesar cipher (shift by n, letters only).
caesar :: Int -> String -> String
caesar n = map shift
  where
    shift c
      | isAlpha c =
          let base  = if toLower c == c then fromEnum 'a' else fromEnum 'A'
              offset = (fromEnum c - base + n) `mod` 26
          in  toEnum (base + offset)
      | otherwise = c

-- | Collect statistics about a corpus of text.
data CorpusStats = CorpusStats
  { csWordCount  :: Int
  , csCharCount  :: Int
  , csUniqueWords:: Int
  , csTopWords   :: [(String, Int)]
  } deriving (Show)

analyseCorpus :: String -> CorpusStats
analyseCorpus text =
  let ws      = tokenise text
      freq    = frequency ws
  in  CorpusStats
        { csWordCount   = length ws
        , csCharCount   = length text
        , csUniqueWords = Map.size freq
        , csTopWords    = topN 5 ws
        }

-- | Pretty-print corpus stats.
printStats :: CorpusStats -> IO ()
printStats cs = do
  putStrLn $ "Words      : " ++ show (csWordCount cs)
  putStrLn $ "Characters : " ++ show (csCharCount cs)
  putStrLn $ "Unique     : " ++ show (csUniqueWords cs)
  putStrLn   "Top 5 words:"
  mapM_ (\(w, c) -> putStrLn $ "  " ++ w ++ " (" ++ show c ++ ")") (csTopWords cs)

main :: IO ()
main = do
  let corpus = "the cold landscape spreads beneath a grey and heavy sky \
               \the cold wind carries the scent of pine and frozen earth \
               \the cold settles into every corner and every shadow"

  putStrLn "=== Corpus Analysis ==="
  printStats (analyseCorpus corpus)

  putStrLn "\n=== Caesar Cipher (shift 3) ==="
  let encoded = caesar 3 "cold landscape"
  putStrLn $ "Encoded : " ++ encoded
  putStrLn $ "Decoded : " ++ caesar (-3) encoded

  putStrLn "\n=== Run-Length Encoding ==="
  let rleInput  = "aaabbbccddddee"
      encoded'  = rle rleInput
      decoded'  = rldecode encoded'
  print encoded'
  putStrLn decoded'
