-- Classe que representa a View (conteudo visual) da tela Users

local ui = require('lib/LoveUIView')

-- Definimos a classe como subclasse de View
local uView = ui.extends(ui.View,'UsersScreen')

-- Numero maximo de cards que podem aparecer
local nCards = 3

function uView.new(x,y,width,height)
	local self = uView.newObject(x,y,width,height)

	-- Tamanho de cada card de acordo com o tamanho da view
	self.cardWidth = 0.8*width
	self.cardHeight = 0.25*height

	-- Colecao de cards
	self.cards = {}

	-- Definindo o botao de adicao
	local butSize = 0.08*width
	local but = ui.Button.new(0.91*width,0.1*height,butSize,butSize)
	but.image = love.graphics.newImage('assets/addButton.png')
	self:addSubView(but)
	self.addButton = but -- Guardando referencia ao botao

	return self
end

-- Cria um card, que é uma view com uma foto de usuario e um campo de texto
-- Perceba que poderiamos ter feito uma classe CardView por exemplo, mas
-- definir genericamente a partir de uma funcao tambem eh uma opcao, caso
-- pareça exagero modularizar. Logo, como exemplo, essa View tem essa
-- funcao que automaticamente cria um novo card e encaixa ele em sequencia.
-- Perceba tambem que ela nao tem "logica", ela so recebe os dados e monta
-- o VISUAL. Quem é responsavel por chamar a funcao como quiser é de fato
-- a Screen.
function uView:createCard(img,text)
	local w,h = self.cardWidth,self.cardHeight

	-- v é a View que representa o Card
	local v = ui.View.new(0,0,w,h)
	v.borderColor[4] = 255 --Borda preta visivel

	-- Posicionamento do card
	local idx = #self.cards
	v:setCenter(self.width/2,self.height/nCards*(idx*2+1)/2)

	--Criando foto e inserindo no card
	local imgV = ui.ImageView.new(0.05*w,0.05*h,0.3*w,0.9*h)
	imgV.backgroundColor = {120,120,120,255} --fundo cinza
	imgV.image = img
	v:addSubView(imgV)

	--Criando campo de texto e inserindo no card
	local remW = w - imgV.width
	local textV = ui.TextField.new(imgV:maxX()+remW*0.1,0.1*h,remW*0.8,0.8*h)
	textV.borderColor = {0,0,120,255} --borda azul
	textV.text = text
	v:addSubView(textV)
	table.insert(self.cards, v)
	self:addSubView(v)

	if idx+1 >= nCards then --remove botao de add caso tenha alcancado o maximo de cards
		self.addButton:removeFromSuperView()
	else -- se nao, reposiciona o botao somente
		self.addButton.y = v.y+(h-self.addButton.height)/2
	end 
end

return uView