-- **********************************
-- * Maquinas agricolas versus alien
-- **********************************

-- * Declaração de variaveis globais INI
larguraTela = 320
alturaTela = 480
maxAlien = 10

trator = {
	src = "imagens/trator.png",
	largura = 30,
	altura = 65,
	x = larguraTela / 2 - 30,
	y = alturaTela - 100,

	tiro = {}
}

x, y = 0, 0;
-- * Declaração de variaveis globais FIM

function atira()
	
	disparo:play()

	local cana = {
		x = trator.x + trator.largura / 2,
		y = trator.y ,
		largura = 16,
		altura = 30
	}

	table.insert(trator.tiro, cana)
end

function moveTiro()
	for i = #trator.tiro,1,-1 do
		if trator.tiro[i].y > 0 then 
			trator.tiro[i].y = trator.tiro[i].y - 1
		else
			table.remove(trator.tiro, i)
		end
	end 
end

function destruirTrator()
	explode:play()
	
	trator.src = 'imagens/boom.png'
	trator.imagem = love.graphics.newImage(trator.src)
end

function colidiu(X1, Y1, L1, A1, X2, Y2, L2, A2)
	return 	X2 < X1 + L1 and
			X1 < X2 + L2 and
			Y1 < Y2 + A2 and
			Y2 < Y1 + A1
end
 

naves = {}
function novaNave()
	nave = {
		x = math.random(320),
		y = -70,
		peso = math.random(1,5), 
		deslocamento_horizontal = math.random(-1,1),
		altura = 5,
		largura = 10
	}

	table.insert(naves, nave)
end

function moveNave()
	for i,nave in pairs(naves) do
		nave.y = nave.y + nave.peso
		nave.x = nave.x + nave.deslocamento_horizontal
	end 
end

function mataNave() 
	for i = #naves, 1, -1 do
		if naves[i].y > alturaTela then
			table.remove(naves, i)
		end 
	end
end

-- * Funcao de movimentacao do personagem INI
function moveTrator()
	if (love.keyboard.isDown('w') or love.keyboard.isDown('up')) then
		trator.y = trator.y - 2
	end

	if (love.keyboard.isDown('s') or love.keyboard.isDown('down')) then
		trator.y = trator.y + 2
	end

	if (love.keyboard.isDown('a') or love.keyboard.isDown('left')) then
		trator.x = trator.x - 2
	end

	if (love.keyboard.isDown('d') or love.keyboard.isDown('right')) then
		trator.x = trator.x + 2
	end
end
-- * Funcao de movimentacao do personagem INI

function trocaMusicaFundo()
	ambiente:stop()
	fim:play()
end

function checaColisoes() 
	for k,nave in pairs(naves) do 
		if colidiu(nave.x, nave.y, nave.largura, nave.altura, 
			trator.x, trator.y, trator.largura, trator.altura
			) then
			trocaMusicaFundo()
			destruirTrator()
			fimJogo = true
		end 
	end

	for i = #trator.tiro,1, -1 do 
		for j = #naves,1, -1 do 
			if colidiu(trator.tiro[i].x, trator.tiro[i].y, trator.tiro[i].altura, trator.tiro[i].largura, 
						naves[j].x, naves[j].y, naves[j].largura, naves[j].altura) then 
				table.remove(naves, j) 
				table.remove(trator.tiro, i)
				break
			end
		end
	end
end

-- * Funcao principal de carregamento INI 
function love.load()
	love.window.setMode(larguraTela, alturaTela, {resizable = true})
	love.window.setTitle('Maquinas agricolas x Aliens')
		
	math.randomseed(os.time())	

	fundoImg = love.graphics.newImage('imagens/fundo.png')
	trator.imagem = love.graphics.newImage(trator.src)
	oNave = love.graphics.newImage('imagens/nave.png')
	oTiro = love.graphics.newImage('imagens/cana.png')
	
	ambiente = love.audio.newSource('audios/ambiente.wav', 'stream')
	ambiente:setLooping(true)
	ambiente:play()

	explode = love.audio.newSource('audios/destruicao.wav', 'stream')
	fim = love.audio.newSource('audios/game_over.wav', 'stream')

	disparo = love.audio.newSource('audios/disparo.wav', 'stream')
end 
-- * Funcao principal FIM

-- * Funcao de atualizacao frame-a-frame INI
function love.update(dt)
	if not fimJogo then 
		if love.keyboard.isDown('w', 's', 'a', 'd', 'right', 'up', 'left', 'down') then
		moveTrator()
		end 

		mataNave()  

		if #naves < maxAlien then
			novaNave()
		end

	  	moveNave()
	  	moveTiro()  

	  	checaColisoes()


	end
end
-- * Funcao de atualizacao frame-a-frame FIM

function love.keypressed(tecla)
	if tecla == "escape" then
		love.event.quit()
	elseif tecla == 'space' then
		atira()
	end
end 

-- * Funcao de desenho na tela INI
function love.draw()
    love.graphics.draw(fundoImg, 0,0)
    love.graphics.draw(trator.imagem, trator.x, trator.y, 0, 0.1, 0.1)
    love.graphics.print('vacar')

    for i,nave in pairs(naves) do 
    	love.graphics.draw(oNave, nave.x, nave.y, 0, 0.1 , 0.1)
    end

    for k, canas in pairs(trator.tiro) do
    	love.graphics.draw(oTiro, canas.x, canas.y, 0, 0.1, 0.1)
    end
end 
-- * Funcao de desenho na tela FIM