LARGURA_TELA = 320
ALTURA_TELA = 480
-- MAX_METEOROS = 12

aviao_14bis = {
    src = "imagens/14bis.png",
    largura = 55,
    altura = 63,
    x = LARGURA_TELA/2 -64/2,
    y = ALTURA_TELA - 64/2
}

function destroiAviao()
    musica_destruicao:play()
    
    aviao_14bis.src = "imagens/explosao_nave.png",
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    aviao_14bis.largura = 67
    aviao_14bis.altura = 77
end

function temColisao(X1, Y1, L1, A1, X2, Y2, L2, A2 )
   return X2 < X1 + L1 and
          X1 < X2 + L2 and
          Y1 < Y2 + A2 and
          Y2 < Y1 + A1 
end

meteoros = {}

function criaMeteoro()
    meteoro = {
        -- src = "imagens/meteoro.png",
        x = math.random(LARGURA_TELA),
        y = -70,
        largura = 50,
        altura = 44,
        peso = math.random(3), 
        deslocamento_horizontal = math.random(-1,1)
    }
    table.insert(meteoros, meteoro)
    
end

function moveMeteoros()
    for k, v in ipairs(meteoros) do
        meteoro.y = meteoro.y + meteoro.peso
        meteoro.x = meteoro.x + meteoro.deslocamento_horizontal
    end
end

function move14bis()
    if love.keyboard.isDown('w') then
        aviao_14bis.y = aviao_14bis.y -3
    end
    if love.keyboard.isDown('s') then
        aviao_14bis.y = aviao_14bis.y +3
    end
    if love.keyboard.isDown('a') then
        aviao_14bis.x = aviao_14bis.x -3
    end
    if love.keyboard.isDown('d') then
        aviao_14bis.x = aviao_14bis.x +3
    end
end

function trocaMusicaDeFundo()
    musica_ambiente:stop()
    musica_game_over:play
end

function checaColisoes()
    for k, meteoro in pairs(meteoros) do
        if temColisao(meteoro.x, meteoro.y, meteoro.largura, meteoro.altura, 
                        aviao_14bis.x, aviao_14bis.y, aviao_14bis.largura, aviao_14bis.altura) then
            
            trocaMusicaDeFundo()
            destroiAviao()
            FIM_JOGO = true
        end
    end
end

function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TERA, {resizable = false})
    love.window.setTitle("14bis vs Meteoros")

    math.randomseed(os.time())

    background = love.graphics.newImage("imagens/background.png")
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")

    musica_ambiente = love.audio.newSource("audios/ambiente.wav")
    musica_ambiente:setLooping(true)
    musica_ambiente:play()

    musica_destruicao = love.audio.newSource("audios/ambiente.wav")
    musica_game_over = love.audio.newSource("audios/game_over.wav")
end

function love.update(dt)
    if not FIM_JOGO then
        if love.keyboard.isDown('w', 'a', 's', 'd') then
            move14bis()
        end

        criaMeteoro()
        moveMeteoros()
        
        checaColisoes()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)

    love.graphics.draw(aviao_14bis.imagem, aviao_14bis.x, aviao_14bis.y)

    for k,meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end
end
