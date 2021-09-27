LARGURA_TELA = 320
ALTURA_TELA = 480

aviao_14bis = {
    src = "imagens/14bis.png",
    largura = 64,
    altura = 64,
    x = LARGURA_TELA/2 -64/2,
    y = ALTURA_TELA - 64/2
}

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
    -- love.window.setTitle("14bis vs Meteoros")
    love.window.setTitle("14bis vs Meteoros")

    background = love.graphics.newImage("imagens/background.png")
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
    if love.keyboard.isDown('w', 'a', 's', 'd') then
        move14bis()
    end
end
 
-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(background, 0, 0)

    love.graphics.draw(aviao_14bis.imagem, aviao_14bis.x, aviao_14bis.y)
end
