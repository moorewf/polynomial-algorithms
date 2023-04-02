{-# LANGUAGE StrictData #-}
-----------------------------------------------------------------------------------------
-- |
-- Authors : Tommy Meek and Frank Moore
--
-- This is a module for coefficients in a polynomial ring. The types here
-- should be rings at least. Most will likely be fields.
-----------------------------------------------------------------------------------------
module Coefficient ( Coefficient ) where

import Data.Ratio ((%), numerator, denominator)
--import Control.DeepSeq (NFData, rnf)
import qualified RingParams as RP
import PolyParsers (Readable(..), ratFromString, ratToString)

-- | A coefficient in a polynomial ring
data Coefficient :: RP.Ring -> * where
    Q       :: Rational -> Coefficient r
    Zero    :: Coefficient r
    FTwo    :: Integer -> Coefficient r
    FThree  :: Integer -> Coefficient r
    FFive   :: Integer -> Coefficient r
    deriving Eq

-- Type synonyms
type Q      = Coefficient RP.Q
type Zero   = Coefficient RP.Zero
type FTwo   = Coefficient RP.FTwo
type FThree = Coefficient RP.FThree
type FFive  = Coefficient RP.FFive

instance Show Q where
    show (Q r) = ratToString r

--instance NFData Field where
--    rnf (Q a) = rnf a

instance Num Q where
    (Q r) + (Q s) = Q (r + s)
    (Q r) - (Q s) = Q (r - s)
    (Q r) * (Q s) = Q (r * s)
    abs (Q r)     = Q (abs r)
    signum (Q r)  = Q (signum r)
    fromInteger n = Q $ n % 1

instance Fractional Q where
    recip (Q r)  = Q (denominator r % numerator r)
    fromRational = Q

instance Readable Q where
    fromString = Q . ratFromString

instance Show Zero where
    show _ = show RP.Zero

instance Num Zero where
    _ + _         = Zero
    _ - _         = Zero
    _ * _         = Zero
    abs _         = Zero
    signum _      = Zero
    fromInteger _ = Zero

instance Fractional Zero where
    recip _        = error "Cannot divide by zero."
    fromRational _ = Zero

instance Readable Zero where
    fromString _ = Zero

instance Show FTwo where
    show (FTwo n) = show n

instance Num FTwo where
    (FTwo n) + (FTwo m) = FTwo ((n + m) `mod` 2)
    (FTwo n) - (FTwo m) = FTwo ((n - m) `mod` 2)
    (FTwo n) * (FTwo m) = FTwo ((n * m) `mod` 2)
    abs (FTwo n)        = FTwo (abs n)
    signum (FTwo n)     = FTwo (signum n)
    fromInteger n       = FTwo $ n `mod` 2

instance Fractional FTwo where
    recip 0        = error "Cannot divide by zero."
    recip 1        = FTwo 1
    fromRational a = fromInteger (numerator a) * recip (fromInteger (denominator a))

instance Readable FTwo where
    fromString = FTwo . read

instance Show FThree where
    show (FThree n) = show n

instance Num FThree where
    (FThree n) + (FThree m) = FThree ((n + m) `mod` 3)
    (FThree n) - (FThree m) = FThree ((n - m) `mod` 3)
    (FThree n) * (FThree m) = FThree ((n * m) `mod` 3)
    abs (FThree n)          = FThree (abs n)
    signum (FThree n)       = FThree (signum n)
    fromInteger n           = FThree $ n `mod` 3

instance Fractional FThree where
    recip 0        = error "Cannot divide by zero."
    recip 1        = FThree 1
    recip 2        = FThree 2
    fromRational a = fromInteger (numerator a) * recip (fromInteger (denominator a))

instance Readable FThree where
    fromString = FThree . read

instance Show FFive where
    show (FFive n) = show n

instance Num FFive where
    (FFive n) + (FFive m)   = FFive ((n + m) `mod` 5)
    (FFive n) - (FFive m)   = FFive ((n - m) `mod` 5)
    (FFive n) * (FFive m)   = FFive ((n * m) `mod` 5)
    abs (FFive n)           = FFive (abs n)
    signum (FFive n)        = FFive (signum n)
    fromInteger n           = FFive $ n `mod` 5

instance Fractional FFive where
    recip 0        = error "Cannot divide by zero."
    recip 1        = FFive 1
    recip 2        = FFive 3
    recip 3        = FFive 2
    recip 4        = FFive 4
    fromRational a = fromInteger (numerator a) * recip (fromInteger (denominator a))

instance Readable FFive where
    fromString = FFive . read
