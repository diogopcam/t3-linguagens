module Main where
import System.Random (randomRIO)
import System.IO (hFlush, stdout)

data Move = Pedra | Papel | Tesoura | Fogo | Agua deriving (Show, Read, Eq, Enum, Bounded)
data Mode = Normal | Deus | Tonto deriving (Eq, Show)

allMoves :: [Move]
allMoves = [minBound .. maxBound]

-- Verifica se um movimento vence outro
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
    | jogador == cpu        = "Empate!"
    | jogador `vence` cpu   = "Você ganhou!"
    | otherwise             = "Você perdeu!"

cpuNormal :: IO Move
cpuNormal = do
    i <- randomRIO (0, length allMoves - 1)
    return (allMoves !! i)

cpuDeus :: Move -> Move
cpuDeus m = head [x | x <- allMoves, x `vence` m]

cpuTonto :: Move -> Move
cpuTonto m = head [x | x <- allMoves, m `vence` x]

-- Converte entrada do usuário
interpretaMove :: String -> Maybe Move
interpretaMove s =
    case map toLower s of
        "pedra"   -> Just Pedra
        "p"       -> Just Pedra
        "papel"   -> Just Papel
        "pa"      -> Just Papel
        "tesoura" -> Just Tesoura
        "t"       -> Just Tesoura
        "fogo"    -> Just Fogo
        "f"       -> Just Fogo
        "agua"    -> Just Agua
        "a"       -> Just Agua
        _         -> Nothing

    where toLower c 
            | 'A' <= c && c <= 'Z' = toEnum (fromEnum c + 32)
            | otherwise            = c


lerMovimento :: IO (Maybe Move)
lerMovimento = do
    putStr "\nEscolha (Pedra/Papel/Tesoura/Fogo/Agua)\nou digite 'voltar' ou 'sair': "
    hFlush stdout
    entrada <- getLine

    case map toLower entrada of
        "sair"   -> return Nothing
        "voltar" -> return Nothing
        _        -> return (interpretaMove entrada)

    where toLower c 
            | 'A' <= c && c <= 'Z' = toEnum (fromEnum c + 32)
            | otherwise            = c


lerModo :: IO (Maybe Mode)
lerModo = do
    putStrLn "\n=== SELECIONAR MODO ==="
    putStrLn "1 - Normal (CPU aleatória)"
    putStrLn "2 - Deus (CPU sempre vence)"
    putStrLn "3 - Tonto (CPU sempre perde)"
    putStrLn "0 - Sair"
    putStr   "Escolha: "
    hFlush stdout
    entrada <- getLine
    case entrada of
        "1" -> return (Just Normal)
        "2" -> return (Just Deus)
        "3" -> return (Just Tonto)
        "0" -> return Nothing
        _   -> putStrLn "Opção inválida!" >> lerModo


jogoLoop :: Mode -> IO ()
jogoLoop modo = do
    mov <- lerMovimento
    case mov of
        Nothing -> return ()  -- voltar ou sair
        Just jogador -> do
            cpu <- case modo of
                Normal -> cpuNormal
                Deus   -> return (cpuDeus jogador)
                Tonto  -> return (cpuTonto jogador)

            putStrLn $ "\nVocê jogou: " ++ show jogador
            putStrLn $ "CPU jogou: " ++ show cpu
            putStrLn $ resultado jogador cpu
            putStrLn "\n---"
            jogoLoop modo


main :: IO ()
main = do
    putStrLn "Jogo Pedra, Papel, Tesoura, Fogo e Água"
    putStrLn "Autores: DIOGO CAMARGO, ANTHONY ANDRADE E SAMUEL BITDINGER"

    let loop = do
            modoEscolhido <- lerModo
            case modoEscolhido of
                Nothing -> putStrLn "\nSaindo... Até mais!"
                Just modo -> do
                    putStrLn $ "\nModo escolhido: " ++ show modo
                    putStrLn "Digite 'voltar' para retornar ao menu."
                    putStrLn "Digite 'sair' para encerrar o jogo."
                    jogoLoop modo
                    loop

    loop