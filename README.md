# Scroll para MTA em Lua
Este código implementa uma classe de rolagem (Scroll) para Multi Theft Auto (MTA) em Lua. A classe permite criar barras de rolagem que facilitam a navegação em listas de itens.

## Exemplo de Uso
Para criar uma nova instância do Scroll e desenhá-la na tela, utilize o seguinte código:

```lua
local tbl = {}

local scroll = Scroll.new({
    visible = 5,
    total = #tbl,
    animation = true
})

addEventHandler("onClientRender", root, function()
    scroll:draw(10, 10, 4, 200, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255))

    for i = 1, 5 do
        local index = scroll.value + i
        local v = tbl[index]

        if v then
            local margin = (i - 1) * 20
            dxDrawText(tbl[index].name, 20, 10 + margin, 0, 0, tocolor(0, 0, 0, 255))
        end
    end
end)

local function generateString()
    return string.rep(string.char(math.random(65, 90)), 6)
end

bindKey("k", "down", function()
    table.insert(tbl, {name = generateString()})
    scroll.total = #tbl
end)
```

## Funções Principais
### ``Scroll.new(properties)``
Cria uma nova instância de Scroll com as propriedades fornecidas.

**Parâmetros:**
- properties ``(tabela)``: Propriedades da barra de rolagem, como value, visible, total, etc.

**Retorno:**
- Instância de Scroll

## ``Scroll:draw(x, y, width, height, backgroundColor, foregroundColor)``
Desenha a barra de rolagem na tela.

**Parâmetros:**
- x (número): Coordenada X da barra de rolagem.
- y (número): Coordenada Y da barra de rolagem.
- width (número): Largura da barra de rolagem.
- height (número): Altura da barra de rolagem.
- backgroundColor (cor): Cor de fundo da barra.
- foregroundColor (cor): Cor do indicador de rolagem.

## Propriedades Disponíveis
- ``value``: Posição atual da rolagem.
  - Tipo: number
  - Exemplo: 0

- ``visible``: Número de itens visíveis na rolagem.
  - Tipo: number
  - Exemplo: 5

- ``total``: Total de itens disponíveis na rolagem.
  - Tipo: number
  - Exemplo: 100

- ``box``: Área da tela onde o cursor deve estar para usar o scroll.
  - Tipo: table
  - Exemplo: {x, y, width, height}

- ``animation``: Define se a rolagem deve ter animação.
  - Tipo: boolean
  - Exemplo: true

## Contribuições
Sinta-se à vontade para fazer melhorias ou enviar pull requests.

## Licença
Este código é fornecido sob a Licença MIT.
