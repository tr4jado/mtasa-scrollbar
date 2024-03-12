# Biblioteca ScrollBar para MTA Lua

## Introdução

Esta biblioteca Lua fornece funcionalidades simples e versáteis para listas em grade (Grid List) no Multi Theft Auto (MTA) scripting. A biblioteca foi projetada para lidar com interações do cursor, entrada de teclado e rolagem dentro de uma área específica.

## Recursos

- **Rolagem**: Incorpora uma barra de rolagem flexível e personalizável para navegar por listas.

## Uso

### Funções

- **Scroll.new(min, total)**: Cria uma nova instância de Scroll com um número especificado de itens visíveis e totais.
- **Scroll:draw(x, y, largura, altura, corDoFundo, corDoGrip):** Desenha a barra de rolagem na tela.
- **Scroll:getValue():** Obtém o valor atual da rolagem.
- **Scroll:setValue(value):** Define o valor da rolagem.
- **Scroll:setParent(x, y, largura, altura):** Define a área para interação.
- **Scroll:destroy():** Destrói a instância de Scroll.

### Exemplo

```lua
local total = 50
local visible = 5

local scroll = Scroll.new(visible, total)
scroll:setParent(30, 10, 50, 100)

local test = {}
for i = 1, total do
    table.insert(test, 'Test ' .. i)
end

addEventHandler('onClientRender', root, function()
    scroll:draw(10, 10, 10, 100, tocolor(255, 255, 255), tocolor(0, 0, 0))

    for i = 1, visible do
        local index = i + scroll:getValue()
        dxDrawText(test[index], 30, 10 + ((i - 1) * 20), 0, 0, tocolor(255, 255, 255))
    end
end)
```

Sinta-se à vontade para personalizar a biblioteca de acordo com suas necessidades específicas. Se tiver dúvidas ou encontrar problemas, consulte a documentação fornecida ou me chame no Discord. Boa programação!

#### Meu Discord: **tr4jado.**
