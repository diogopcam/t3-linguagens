module Main where
import System.Random (randomRIO)
import System.IO (hFlush, stdout)

data Move = Pedra | Papel | Tesoura | Fogo | Agua deriving (Show, Read, Eq, Enum, Bounded)

data Mode = Normal | Deus | Tonto deriving (Eq)

allMoves :: [Move]
allMoves = [minBound .. maxBound]

-- Determina se o primeiro movimento vence o segundo
vence :: Move -> Move -> Bool
vence Pedra Tesoura = True
vence Tesoura Papel = True
vence Papel Pedra = True
vence Fogo Pedra = True
vence Fogo Papel = True
vence Fogo Tesoura = True
vence Pedra Agua = True
vence Papel Agua = True
vence Tesoura Agua = True
vence Agua Fogo = True
vence _ _ = False

resultado :: Move -> Move -> String
resultado jogador cpu
    | jogador == cpu = "Empate!"
    | jogador `vence` cpu = "Você ganhou!"
    | otherwise = "Você perdeu!"

-- CPU joga aleatoriamente
cpuNormal :: IO Move
cpuNormal = do
    i <- randomRIO (0, length allMoves - 1)
    return (allMoves !! i)

-- CPU sempre vence
cpuDeus :: Move -> Move
cpuDeus m = head [x | x <- allMoves, x `vence` m]

-- CPU sempre perde
cpuTonto :: Move -> Move
cpuTonto m = head [x | x <- allMoves, m `vence` x]

lerMovimento :: IO Move
lerMovimento = do
    putStr "Escolha (Pedra, Papel, Tesoura, Fogo, Agua): "
    hFlush stdout
    entrada <- getLine
    case reads entrada of
        [(mov, "")] -> return mov
        _ -> putStrLn "Entrada inválida!" >> lerMovimento

lerModo :: IO Mode
lerModo = do
    putStr "Modo (Normal, Deus, Tonto): "
    hFlush stdout
    entrada <- getLine
    case entrada of
        "Normal" -> return Normal
        "Deus" -> return Deus
        "Tonto" -> return Tonto
        _ -> putStrLn "Modo inválido!" >> lerModo

jogar :: Mode -> IO ()
jogar modo = do
    jogador <- lerMovimento
    cpu <- case modo of
        Normal -> cpuNormal
        Deus   -> return (cpuDeus jogador)
        Tonto  -> return (cpuTonto jogador)

    putStrLn $ "Você jogou: " ++ show jogador
    putStrLn $ "CPU jogou: " ++ show cpu
    putStrLn (resultado jogador cpu)
    putStrLn "---"
    jogar modo

main :: IO ()
main = do
    putStrLn "Jogo Pedra, Papel, Tesoura, Fogo e Água"
    putStrLn "Autores: DIOGO CAMARGO, ANTHONY ANDRADE E SAMUEL BITDINGER"
    modo <- lerModo
    jogar modo
