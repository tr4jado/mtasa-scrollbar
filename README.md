# Biblioteca Scroll

Scroll é uma biblioteca Lua projetada para fornecer uma funcionalidade de barra de rolagem interativa para facilitar a navegação em listas ou interfaces de usuário com conteúdo extenso. Com o Scroll, você pode integrar facilmente uma barra de rolagem em suas aplicações ou jogos Lua.

## Recursos

- **Navegação de Conteúdo**: Permite navegar por conteúdo extenso através de uma barra de rolagem.
- **Controle de Arrastar e Soltar**: Arraste a barra de rolagem para percorrer o conteúdo facilmente.
- **Controle de Teclado e Mouse**: Use o teclado e o mouse para interagir com a barra de rolagem.

## Instalação

1. Adicione o arquivo `scrollbar.lua` em seu sript;
2. Caso o método `oop` não esteja habilitado, use adicione o código abaixo:
```xml
<oop>true</oop>
```
3. Em meta.xml adicione o código para seu script reconhecer a biblioteca:
```xml
<script src='scrollbar.lua' type='client' cache='false' />
```

## Uso

### Criando um Objeto Scroll

```lua
local minVisibleItems = 5 -- Número mínimo de itens visíveis
local totalItems = 20 -- Total de itens na lista
local scroll = Scroll.new(minVisibleItems, totalItems)
```

### Desenhando o Scroll

```lua
function onRender()
    scroll:draw(x, y, largura, altura, corDoFundo, corDaBarra)
end
```

### Obtendo o Valor Atual

```lua
local value = scroll:getValue()
```

### Definindo o Valor

```lua
scroll:setValue(novoValor)
```

### Definindo uma Posição Raiz

```lua
scroll:setParent(x, y, largura, altura)
```

### Destruindo o Scroll

```lua
scroll:destroy()
```

## Exemplo

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

## Licença

Esta biblioteca é licenciada sob a Licença MIT. Consulte o arquivo [LICENSE](LICENSE) para obter detalhes.

---

Sinta-se à vontade para personalizar e integrar a biblioteca Scroll em seus projetos. Se encontrar problemas ou tiver sugestões para melhorias, não hesite em [reportá-los](https://github.com/yourusername/Scroll/issues).
