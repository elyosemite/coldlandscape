# Guia de Criação de Tema para Visual Studio Code

## Objetivo

Este documento orienta a criação de um tema visual para o VS Code com identidade própria, derivado de uma curadoria de imagens de paisagens frias e nubladas. O tema combina a estrutura de slots de cor do Catppuccin com os tons neutros de background do VS Code Dark Modern, substituindo os accent colors por uma paleta extraída organicamente de fotografias.

O público-alvo são engenheiros de software e profissionais que passam muitas horas diante do monitor. As decisões de cor, contraste e distribuição visual foram pensadas para reduzir a fadiga ocular, manter o foco cognitivo e evitar distração desnecessária durante sessões longas de trabalho.

---

## Fundamentos de Design para Temas de Editor

### Por que o tema importa para quem trabalha muitas horas

O olho humano processa cor de forma não linear. O sistema visual é mais sensível ao verde, moderadamente sensível ao vermelho e significativamente menos sensível ao azul. Isso tem implicações diretas para temas escuros:

- Backgrounds com tom levemente azulado ou verde-acinzentado causam menos tensão do que cinzas puros ou neutros
- Cores de syntax em verde puro saturado causam fadiga mais rápido do que verdes dessaturados ou levemente amarelados
- Vermelho saturado sobre fundo escuro tem contraste físico alto, mas causa desconforto em uso prolongado
- Azul escuro puro como background interfere na percepção de profundidade e pode causar sensação de "achatamento" visual

### Princípios que guiam este tema

1. **Hierarquia visual clara**: o olho deve saber instantaneamente o que é código ativo, o que é comentário e o que é background, sem esforco consciente
2. **Saturacao controlada**: accent colors vivos mas nao saturados ao maximo — saturacao entre 40% e 70% e suficiente para destacar sem agredir
3. **Temperatura consistente**: toda a paleta deve ter temperatura de cor coerente (fria), evitando misturas que causam dissonância visual
4. **Contraste funcional, não decorativo**: cada escolha de contraste tem uma função — legibilidade, hierarquia ou delimitação de área — nunca é ornamental

---

## Paleta de Referência

### Backgrounds (derivados do VS Code Dark Modern)

Estes tons são os mais importantes do tema. São neutros, ligeiramente frios e formam a base sobre a qual toda a hierarquia visual é construída.

| Papel | Hex | RGB | Descrição |
|---|---|---|---|
| Editor (fundo principal) | `#1e1e1e` | 30, 30, 30 | Quase preto neutro, ponto de ancoragem |
| Sidebar / painéis laterais | `#252526` | 37, 37, 38 | Um degrau acima do editor |
| Activity Bar | `#2c2c2c` | 44, 44, 44 | Separação sutil da sidebar |
| Title Bar / Status Bar | `#1a1a1a` | 26, 26, 26 | Levemente mais escuro que o editor |
| Hover / seleção suave | `#2d2d30` | 45, 45, 48 | Tom com leve viés frio para hover states |
| Input / campos | `#3c3c3c` | 60, 60, 60 | Claramente distinto do background |

Observação: a diferença entre cada degrau de background é intencional e pequena. O objetivo é criar profundidade sem usar sombras pesadas. A UI deve parecer estratificada, não plana.

### Paleta de Accent Colors (extraída de paisagens frias)

A seguir estao os tons sugeridos como ponto de partida, baseados em caracteristicas visuais comuns em fotografias de paisagens frias: lagos gelados, céus nublados, florestas de coniferas, neve com sobra azulada, musgo sobre pedra.

Apos extrair as cores das suas proprias fotografias, use esta tabela como referencia de papel e criterio de selecao.

| Papel / Uso | Hex sugerido | Tom | Criterio de selecao |
|---|---|---|---|
| Keywords (`if`, `for`, `class`) | `#7cb7d4` | Azul glacial medio | Deve ser a cor mais imediatamente reconhecivel |
| Strings | `#a8c7a0` | Verde musgo claro | Strings sao frequentes; a cor nao pode ser agressiva |
| Funcoes / metodos | `#c8aee0` | Lavanda enevoada | Distingue chamadas de funcao dos operadores |
| Tipos e classes | `#9ecfd4` | Ciano frio | Proximo ao azul mas distinto o suficiente |
| Numeros e constantes | `#d4b896` | Bege areia fria | Quente dentro de uma paleta fria — cria contraste de temperatura |
| Comentarios | `#5c6370` | Cinza medio | Deve recuar visualmente — nao competir com codigo ativo |
| Texto base (variaveis, operadores) | `#cdd1d4` | Branco frio | A cor mais presente; deve ser confortavel em leitura continua |
| Erros | `#c17c7c` | Vermelho dessaturado | Sinaliza problema sem agredir |
| Avisos | `#c4a76a` | Amarelo ocre frio | Distingue de erro sem usar amarelo neon |
| Delimitadores (chaves, parenteses) | `#6c7a80` | Cinza azulado | Devem existir mas nao chamar atencao |

### Cores de UI complementares

| Papel | Hex sugerido | Observacao |
|---|---|---|
| Cursor (caret) | `#7cb7d4` | Mesma cor de keyword — ancora visual |
| Selecao de texto | `#2d4a5a` | Azul muito escuro — nao compete com texto |
| Linha atual (highlight) | `#232a2d` | Diferenca minima do background, apenas perceptivel |
| Indentation guides | `#383838` | Quase invisivel — deve guiar, nao distrair |
| Bracket match highlight | `#4a6270` | Levemente mais vivo que o delimitador normal |
| Git modified (gutter) | `#7cb7d4` | Azul, consistente com a temperatura |
| Git added (gutter) | `#a8c7a0` | Verde musgo, consistente |
| Git deleted (gutter) | `#c17c7c` | Vermelho dessaturado, consistente |

---

## Contraste e Legibilidade

### O padrao WCAG

WCAG (Web Content Accessibility Guidelines) define razoes de contraste minimas entre cor de primeiro plano e cor de fundo:

| Nivel | Razao minima | Aplicacao |
|---|---|---|
| AA | 4.5:1 | Texto de tamanho normal |
| AA | 3.0:1 | Texto grande (acima de 18px ou negrito acima de 14px) |
| AAA | 7.0:1 | Texto normal com maxima acessibilidade |

Para um tema de editor onde o usuario le codigo por horas, **o nivel AA (4.5:1) e o minimo absoluto**. O ideal e buscar entre 5:1 e 7:1 para as cores mais usadas (texto base, keywords, strings), e aceitar razoes menores apenas para elementos que devem recuar visualmente (comentarios, indentation guides).

### Como calcular a razao de contraste

A formula usa luminancia relativa:

```
Contraste = (L_clara + 0.05) / (L_escura + 0.05)
```

Onde a luminancia relativa de uma cor RGB e:

```
L = 0.2126 * R_lin + 0.7152 * G_lin + 0.0722 * B_lin
```

Cada canal linear e calculado a partir do valor normalizado (0–1):

```
se c <= 0.04045: c_lin = c / 12.92
se c >  0.04045: c_lin = ((c + 0.055) / 1.055) ^ 2.4
```

Nao e necessario calcular manualmente. Existem ferramentas que fazem isso em segundos (listadas na secao de ferramentas).

### Verificacao dos pares criticos

Sempre verifique os pares mais importantes antes de finalizar o tema:

| Par | Razao esperada | Prioridade |
|---|---|---|
| Texto base sobre editor background | >= 7.0:1 | Critica |
| Keywords sobre editor background | >= 5.0:1 | Alta |
| Strings sobre editor background | >= 5.0:1 | Alta |
| Funcoes sobre editor background | >= 4.5:1 | Alta |
| Comentarios sobre editor background | 2.5:1 a 3.5:1 | Intencional (recuo visual) |
| Texto de UI sobre sidebar | >= 4.5:1 | Alta |
| Status bar text sobre status bar bg | >= 4.5:1 | Media |
| Erros sobre editor background | >= 4.5:1 | Alta |

Comentarios ter razao menor que 4.5:1 e uma decisao de design deliberada: eles devem ser lidos quando o usuario quer, nao chamar atencao enquanto o usuario le o codigo ativo.

### Armadilhas comuns de contraste

- **Cores proximas em matiz mas diferentes em brilho**: podem passar no teste numericamente mas causar vibração visual (efeito especialmente ruim entre azul e roxo)
- **Verde saturado sobre fundo escuro**: tem contraste alto, mas o olho humano e muito sensível ao verde — evite saturação acima de 60% para cores de uso frequente
- **Vermelho sobre fundo com viés vermelho**: mesmo com razao de contraste adequada, a similitude de temperatura reduz a percepção de distinção
- **Accent colors muito proximos entre si**: dois tons de azul com funcoes diferentes (keyword vs tipo) precisam de distância perceptível, nao apenas razao de contraste adequada em relação ao background

---

## Processo de Criacao

### Passo 1 — Selecao de fotografias

Selecione entre 3 e 5 fotografias que representem o mood desejado. Criterios para uma boa fotografia-fonte:

- Predominancia de tons frios (azuis, cinzas, verdes dessaturados)
- Cenas nubladas ou de luz difusa (evita cores muito saturadas)
- Presenca de pelo menos um ponto de cor quente (por exemplo, um reflexo de luz ou elemento organico) — esse sera o candidato a accent color de contraste de temperatura

Evite fotografias com muita luz direta do sol ou com gamas muito limitadas (todo branco de neve, por exemplo).

### Passo 2 — Extracao de paleta

Para cada fotografia, extraia entre 8 e 12 cores usando uma das ferramentas abaixo. Prefira ferramentas que permitam ajuste manual do ponto de amostragem:

- **coolors.co** — "Create Palette from Photo", permite arrastar os pontos de amostragem
- **Adobe Color** — "Extract from Image", modo "Muted" e mais adequado para este objetivo
- **imagecolorpicker.com** — permite clicar em pontos especificos da imagem, util para capturar tons que seriam ignorados por extracao automatica

### Passo 3 — Curadoria manual

Com as paletas extraidas das 3 a 5 fotografias em mao, faca uma curadoria:

1. Separe as cores em tres grupos: escuras (candidates a background), medias (candidates a UI elements) e claras/vivas (candidates a syntax highlighting)
2. Descarte duplicatas e tons muito similares — mantenha diversidade de matiz
3. Verifique se ha representantes de pelo menos quatro matizes distintos nos candidates a accent color. Um tema com quatro tons de azul e insuficiente para diferenciar tipos de token
4. Identifique o candidato a "cor quente" que vai servir como contraste de temperatura (geralmente um bege, ocre ou amber frio)

### Passo 4 — Mapeamento de roles

Com a paleta curada, mapeie cada cor para um papel usando a tabela de accent colors desta documentacao como referencia. Criterios de decisao:

- A cor mais azulada e neutra vai para keywords — e o elemento mais universal e reconhecivel
- A cor mais verde e suave vai para strings — sao longas e frequentes, precisam ser confortaveis
- A cor mais roxa ou lavanda vai para funcoes — e um matiz que a paleta do Catppuccin consagrou para este papel
- A cor quente (bege/ocre) vai para numeros e constantes — cria contraste de temperatura dentro da paleta fria

### Passo 5 — Verificacao de contraste

Para cada par (cor de token, background do editor), verifique a razao de contraste usando uma das ferramentas de contraste. Se alguma cor nao atingir 4.5:1:

- Primeiro, tente aumentar o brilho (valor HSL) em pequenos incrementos (5% a 10%)
- Segundo, se aumentar o brilho desnaturar demais, aceite a cor para elementos secundarios e escolha outra para os papeis criticos
- Nao force uma cor que nao funciona tecnicamente — o processo de curadoria deve gerar candidatos suficientes para substituicao

### Passo 6 — Geração do arquivo de tema

Use o gerador oficial do VS Code:

```bash
npm install -g yo generator-code
yo code
# Selecione: New Color Theme > No, start fresh
```

Isso cria a estrutura correta com `package.json`, `README.md` e o arquivo `.json` do tema com todos os slots comentados.

Alternativamente, use o repositorio do Catppuccin para VS Code como base estrutural:

- Repositorio: `github.com/catppuccin/vscode`
- Copie o arquivo `.json` do Catppuccin Mocha
- Substitua os backgrounds pelos tons do VS Code Dark Modern listados nesta documentacao
- Substitua os accent colors pela sua paleta curada

### Passo 7 — Iteracao visual

Com o tema carregado no VS Code (`Developer: Install Extension from Location...`), abra arquivos em diferentes linguagens e avalie:

- TypeScript / JavaScript — verifique keywords, strings, tipos, funcoes
- YAML / JSON — verifique chaves, valores, strings
- Markdown — verifique headings, inline code, links
- Shell script — verifique variaveis, comandos, comentarios

Use `Developer: Inspect Editor Tokens and Scopes` para identificar o scope exato de qualquer token e ajustar com precisao.

---

## Ferramentas

### Extracao de paleta de imagens

| Ferramenta | URL | Melhor para |
|---|---|---|
| Coolors Photo | coolors.co | Interface visual, arraste de pontos |
| Adobe Color | color.adobe.com | Modo "Muted" para paletas sutis |
| Image Color Picker | imagecolorpicker.com | Amostragem manual pixel a pixel |
| ImageMagick | CLI local | Automacao em lote de multiplas imagens |

### Verificacao de contraste

| Ferramenta | URL | Destaque |
|---|---|---|
| WebAIM Contrast Checker | webaim.org/resources/contrastchecker | O mais referenciado, mostra AA e AAA |
| Coolors Contrast | coolors.co/contrast-checker | Interface visual clara |
| Colour Contrast Analyser | App desktop (TPGi) | Permite usar eyedropper direto na tela |
| accesslint via npx | `npx @accesslint/color-contrast` | Uso em linha de comando e automacao |

### Desenvolvimento do tema

| Ferramenta | Tipo | Uso |
|---|---|---|
| yo code (Yeoman) | CLI | Scaffolding da extensao |
| Catppuccin for VS Code | Repositorio | Base estrutural de token scopes |
| VS Code Theme Color Reference | Documentacao | Lista completa de slots de cor da UI |
| Developer: Inspect Tokens | Comando VS Code | Identifica scope de qualquer token |
| Color Highlight (extensao) | VS Code | Preview inline de hex codes no editor |

---

## Lista de Verificacao Final

Antes de considerar o tema pronto, confirme cada item:

- [ ] Texto base sobre editor background com razao >= 7.0:1
- [ ] Keywords, strings e funcoes com razao >= 5.0:1
- [ ] Erros e avisos com razao >= 4.5:1
- [ ] Comentarios visivelmente mais escuros que o codigo ativo (recuo intencional)
- [ ] Nenhum par de accent colors de papeis diferentes e confundivel entre si
- [ ] Sidebar e editor visivelmente distintos sem borda explicita
- [ ] Cursor (caret) visivelmente destacado sobre qualquer background
- [ ] Highlight de selecao de texto nao esconde o texto selecionado
- [ ] Linha atual minimamente distinta do background sem ser intrusiva
- [ ] Tema testado em pelo menos quatro linguagens diferentes
- [ ] Tema testado com fonte mono de tamanho 13px, 14px e 16px
- [ ] Tema testado em monitor com brilho reduzido (condicao de trabalho noturno)

---

## Referencias

- WCAG 2.1 — Understanding Success Criterion 1.4.3 (Contrast Minimum): w3.org/WAI/WCAG21/Understanding/contrast-minimum
- VS Code Theme Color Reference: code.visualstudio.com/api/references/theme-color
- VS Code Syntax Highlight Guide: code.visualstudio.com/api/language-extensions/syntax-highlight-guide
- Catppuccin Color Palette: github.com/catppuccin/catppuccin
- Catppuccin for VS Code (source): github.com/catppuccin/vscode
- WebAIM: Understanding Web Accessibility Color Contrast Guidelines: webaim.org/articles/contrast
