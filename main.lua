LARGURA_TELA = 320
ALTURA_TELA = 480
-- MAX_METEOROS = 12

aviao_14bis = {
    src = "imagens/14bis.png",
    largura = 64,
    altura = 64,
    x = LARGURA_TELA/2 -64/2,
    y = ALTURA_TELA - 64/2
}

meteoros = {}

function criaMeteoro()
    meteoro = {
        -- src = "imagens/meteoro.png",
        x = math.random(LARGURA_TELA),
        y = -70,
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

function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TERA, {resizable = false})
    love.window.setTitle("14bis vs Meteoros")

    math.randomseed(os.time())

    background = love.graphics.newImage("imagens/background.png")
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")
end

function love.update(dt)
    if love.keyboard.isDown('w', 'a', 's', 'd') then
        move14bis()
    end

    criaMeteoro()
    moveMeteoros()
end

function love.draw()
    love.graphics.draw(background, 0, 0)

    love.graphics.draw(aviao_14bis.imagem, aviao_14bis.x, aviao_14bis.y)

    for k,meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end
end
