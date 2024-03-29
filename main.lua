LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_METEOROS = 12
METEOROS_ATINGIDOS = 0
NUM_OBJETIVO_METEOROS = 10

aviao_14bis = {
    src = "imagens/14bis.png",
    largura = 55,
    altura = 63,
    x = LARGURA_TELA/2 -64/2,
    y = ALTURA_TELA - 64/2,
    tiro = {}
}

function daTiro()
    musica_disparo:play()

    local tiro = {
        x = aviao_14bis.x + aviao_14bis.largura/2,
        y = aviao_14bis.y,
        largura = 16,
        altura = 16,
    }
    table.insert(aviao_14bis.tiros, tiro)
end

function moveTiros()
    for i= #aviao_14bis.tiros, 1, -1 do
        if aviao_14bis.tiros[i].y > 0 then
            aviao_14bis.tiros[i].y = aviao_14bis.tiros[i].y -1
        else
            table.remove(aviao_14bis.tiros,i)
        end
    end
end

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

function removeMeteoros()
    for i = #meteoros, 1, -1 do
        if meteoros[i].y > ALTURA_TELA then
            table.remove(meteoros,i)
        end
    end
end

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
    for k, meteoro in pairs(meteoros) do
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
    musica_game_over:play()
end

function checaColisaoComAvio()
    for k, meteoro in pairs(meteoros) do
        if temColisao(meteoro.x, meteoro.y, meteoro.largura, meteoro.altura, 
                        aviao_14bis.x, aviao_14bis.y, aviao_14bis.largura, aviao_14bis.altura) then
            
            trocaMusicaDeFundo()
            destroiAviao()
            FIM_JOGO = true
        end
    end
end

function checaColisaoComTiros()
    for i = #aviao_14bis.tiros, 1, -1 do
        for j = #meteoros, 1, -1 do
            if temColisao(aviao_14bis.tiros[i].x, aviao_14bis.tiros[i].y, aviao_14bis.tiros[i].largura, aviao_14bis.tiros[i].altura,
                            meteoros[j].x, meteoros[j].y, meteoros[j].largura, meteoros[j].altura) then
                METEOROS_ATINGIDOS = METEOROS_ATINGIDOS + 1                
                table.remove(aviao_14bis.tiros, i)
                table.remove(meteoros, j)
                break
            end
        end
    end
end

function checaColisoes()
    checaColisaoComAvio()
    checaColisaoComTiros()
end

function checaObejtivoConcluido()
    if METEOROS_ATINGIDOS >= NUM_OBJETIVO_METEOROS then
        musica_ambiente:stop()
        VENCEDOR = true
        musica_vencedor:play()
    end
end

function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TERA, {resizable = false})
    love.window.setTitle("14bis vs Meteoros")

    math.randomseed(os.time())

    background = love.graphics.newImage("imagens/background.png")
    gameover_img = love.graphics.newImage("imagens/gameover.png")
    vencedor_img = love.graphics.newImage("imagens/vencedor.png")

    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")
    tiro_img = love.graphics.newImage("imagens/tiro.png")

    musica_ambiente = love.audio.newSource("audios/ambiente.wav", "static")
    musica_ambiente:setLooping(true)
    musica_ambiente:play()

    musica_destruicao = love.audio.newSource("audios/destruicao.wav", "static")
    musica_game_over = love.audio.newSource("audios/game_over.wav", "static")
    musica_disparo = love.audio.newSource("audios/disparo.wav", "static")
    musica_vencedor = love.audio.newSource("audios/winner.wav", "static")
end

function love.update(dt)
    if not FIM_JOGO and not VENCEDOR then
        if love.keyboard.isDown('w', 'a', 's', 'd') then
            move14bis()
        end

        criaMeteoro()
        moveMeteoros()
        moveTiros()
        checaColisoes()
        checaObejtivoConcluido()
    end
end

function love.keypressed(tecla)
    if tecla == "escape" then
        love.event.quit()
    elseif tecla == "space" then
        daTiro()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(aviao_14bis.imagem, aviao_14bis.x, aviao_14bis.y)

    love.graphics.print("Meteoros restantes: "..NUM_OBJETIVO_METEOROS-METEOROS_ATINGIDOS, 0, 0)

    for k,meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end

    for k, tiro in pairs(aviao_14bis.tiros) do
        love.graphics.draw(tiro_img, tiro.x, tiro.y)
    end

    if FIM_JOGO then
        love.graphics.draw(gameover_img, LARGURA_TELA/2 -gameover_img:getWidth()/2, ALTURA_TELA/2 -gameover_img:getHeight()/2)
    end

    if VENCEDOR  then
        love.graphics.draw(vencedor_img, LARGURA_TELA/2 -vencedor_img:getWidth()/2, ALTURA_TELA/2 -vencedor_img:getHeight()/2)
    end
end