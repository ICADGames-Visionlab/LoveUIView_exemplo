-- Classe representa uma tela (Screen) e sua implementacao logica

local ui = require('lib/LoveUIView')

local uScreen = ui.extends(ui.Screen,'UsersScreen')
local uView = require'src/UsersView'

-- Dados usados na logica
local names = {
	'Pietro',
	'Felipe',
	'JP'
}

-- Caminho para a pasta onde se carregar as imagens
local imgsPath = 'assets/'

local addNewPerson --referencia pra funcao (implementada ao fim)

function uScreen.new(...) -- Cria uma nova screen
	local self = uScreen.newObject(...)

	-- Carrega a view do arquivo UsersView
	local uv = uView.new(0,0,self.view.width,self.view.height)
	self.view:addSubView(uv) -- Adiciona à hierarquia
	self.uView = uv -- Guarda referencia

	-- Configurando logica de acao para o botao (criado dentro do UsersView)
	uv.addButton.target = function(but)
		-- Todas as funcoes chamadas a partir do clique de funcao recebem como
		-- parametro o proprio botao (que nesse caso nao nos eh util)
		addNewPerson(self) -- Chamamos funcao para adicionar um card novo
	end

	addNewPerson(self) --ja comecamos adicionando um card

	return self
end

function addNewPerson(self)
	local uv = self.uView
	local idx = #uv.cards+1
	if idx<=#names then -- Verificando se ainda ha cards a se adicionar
		-- Carregamos imagem, texto e chamamos a funcao de UsersView para criar o card
		local img = love.graphics.newImage(imgsPath..names[idx]..'.png')
		local text = 'Ola, sou o '..names[idx]..' e ... (clique nessa caixa para inserir uma mensagem)'
		uv:createCard(img,text)
	end
end

return uScreen