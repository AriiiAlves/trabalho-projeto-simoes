#set page(paper: "a4", margin: 2.5cm) // Configurações globais
#set text(font: "Libertinus Serif", size: 12pt) 
#set heading(numbering: "1.1") // Isso numera as seções (1, 1.1, etc.)
#show link: it => box(
  stroke: green + 1pt, // Define a borda verde de 1pt
  radius: 0pt,         // Arredonda levemente os cantos (opcional)
  inset: 0pt,          // Espaçamento entre o texto e a borda
  it                   // O conteúdo do link 
)
#show ref: it => box(
  stroke: orange + 1pt, // Define a borda verde de 1pt
  radius: 0pt,         // Arredonda levemente os cantos (opcional)
  inset: 0pt,          // Espaçamento entre o texto e a borda
  it                   // O conteúdo do link 
)
#set bibliography(title: "Referências", style: "ieee") // Define
#show figure.where(kind: image): set figure(supplement: [Figura])

// --- Capa ---
#align(center)[
  #v(2cm) // Espaço no topo
  
  #text(size: 24pt, weight: "bold")[Projeto 2: Circuito Somador com Amp-Ops]
  
  #v(1cm)
  
  #text(size: 14pt, style: "italic")[Disciplina: SSC0180 - Eletrônica para Computação]
  
  #v(2cm)
  
// Lista de Autores
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 10pt,
    [
      *Ariel Alves da Silva* \
      8847378 \
    ],
    [
      *Rodrigo Haruo Takihi* \
      17922406 \
    ],
    [
      *Fabio Czenszel Sanematsu* \
      16864491 \
    ]
  )
  #grid(
    columns: (1fr, 1fr),
    gutter: 10pt,
    [
      *Demétrio Nunes Canuto* \
      17885722 \
    ],
    [
      *Fernando Sato* \
      17889855 \
    ]
  )

  #v(4cm)
  
  // Data e Local
  #text(size: 12pt)[São Carlos, SP \ 2026]
]

#pagebreak() // Quebra para começar o conteúdo na página seguinte
// --- Fim da Capa ---

#outline(title: "Sumário")

#pagebreak()

= Introdução

O projeto consiste em um circuito somador com pesos ajustáveis. É uma calculadora analógica simples. Optamos por não colocar operações como derivação e integração para simplificar a apresentação do circuito a qualquer tipo de público.

== Amp-ops

Um Amplificador Operacional (Amp-Op) é um circuito integrado projetado para amplificar sinais elétricos. Ele possui duas entradas e uma saída.

#figure(
  image("./images/amp-op.png", width: 80%),
  caption: [Buffer],
)

- *Entrada inversora* ($-$): O sinal inserido aqui sai com a fase invertida (entra positivo, sai negativo)
- *Entrada Não-Inversora* ($+$): O sinal inserido aqui mantém a sua fase na saída

O funcionamento do amp-op é o seguinte: Ele possui *impedância de entrada infinita*. Nenhuma corrente entra nas portas $+$ ou $-$. Elas apenas "lêem" a tensão. E possui *impedância de saída zero*: A saída pode fornecer tanta corrente quanto a carga precisar, sem perder tensão.

== Amp-Op na Configuração de Somador inversor

Na configuração Somador Inversor, aterramos a entrada não inversora ($+$). Assim, o amp-op iguala a tensão das entradas, de modo que a entrada ($-$) também fica mantida em 0V.

#figure(
  image("./images/somador-inversor.png", width: 80%),
  caption: [Somador Inversor],
)

Em cada tensão de entrada, temos uma corrente sendo gerada.

$ I_1 = V_1/R_1, I_2 = V_2/R_2, I_3=V_3/R_3 $

Como nenhuma corrente entra nos terminais do amp-op (Impedância infinita), todas essas correntes se somam e são forçadas a passar pelo único caminho restante: o resistor de realimentação $R_f$

$ I_"total" = I_1+I_2+I_3 $

A passagem dessa corrente por $R_f$ gera uma queda de tensão. Como a corrente flui do nó de 0V para a saída, a tensão de saída torna-se negativa em relação aos 0V (a tensão flui do $+$ para o $-$):

$ V_"out" = -(I_"total" dot R_f) $

Substituindo as correntes na fórmula final, temos a fórmula do Amp-Op na configuração Somador Inversor:

$ V_"out" = -R_f dot (V_1/R_1 + V_2/R_2 + V_3/R_3) $

Quando todos os resistores são iguais, temos:

$ V_"out" = -(V_1 + V_2 + V_3) $

E se tirarmos o amp-op? Sem o Amp-Op, o nó central não é mais um terra. Ele assume uma tensão variável ($V_"nó"$) que depende de todas as entradas.

Como o nó tem uma tensão $!=0$, a corrente de uma entrada "enxerga" a tensão das outras entradas. Isso causa interferência entre os canais (o canal 1 altera a corrente do canal 2) e faz com que a matemática de soma vira na verdade uma média (para resistores de valores iguais):

$ V_"out" = (V_1 + V_2 + V_3)/3 $

== Amp-Op na Configuração de Buffer (seguidor de tensão)

Um amp-op pode ser colocado na configuração de Buffer, como mostra a figura abaixo.

#figure(
  image("./images/buffer.png", width: 80%),
  caption: [Buffer],
)

Nessa configuração, a saída é conectada diretamente à entrada inversora ($-$), enquanto o sinal de entrada é injetado na entrada não=inversora ($+$).

Devido ao ganho infinito e à realimentação, o amp-op ajusta a sua tensão em $-$ para que seja exatamente igual à tensão em $+$. Assim, *a tensão na entrada é igual à da saída*.

Mas pra quê isso serve?

O buffer *"copia" a tensão de entrada sem puxar nenhuma corrente dela*, e usa sua própria fonte de alimentação para fornecer a corrente que a carga precisa.

No nosso projeto, vamos usar os potenciômetros para controlar a tensão, mas não queremos que a resistência do potenciômetro afete o resultado final. Então, eliminamos essa "influência da resistência" com um Buffer!

== Terra virtual

Quando se conecta os terminais de um componente a uma fonte de tensão, tudo que importa é a diferença de potencial. Se temos:

- 10V e -10V
- 20V e 0V

A diferença de potencial de ambos é a mesma.

No nosso projeto, um amp-op na configuração somador inversor devolve uma tensão negativa na saída. O grande problema é que não temos fonte simétrica ($plus.minus 10 V$), e esta custa caro.

Então, utilizamos o Terra Virtual: Ao usar 20V como positivo e 10V como negativo, nosso 0V será lido pelo voltímetro como $-10V$, pois a nossa referência zero agora é 10V.

Isso permite utilizar uma fonte comum de 20V, 0V no projeto.

= Projeto

Primeiro, temos 3 potenciômetros. As tensões de saída deles são as entradas numéricas do circuito. Assim, se ajustamos um potenciômetro para que entre 5V, teremos o número 5 sendo somado.

#figure(
  image("./images/1.png", width: 80%),
  caption: [Potenciômetros],
)

A saída de cada potenciômetro está ligado a um buffer exclusivo para cada um. O intuito desse buffer é manter a d.d.p. do potenciômetro, mas eliminar a influência da resistência nos próximos passos. Isso pois qualquer resistência é contabilizada como peso, assim, o buffer permite tender essa resistência inicial a zero, de modo que criamos uma nova fonte de tensão “pura”.

#figure(
  image("./images/2.png", width: 80%),
  caption: [Buffers],
)

Isso tudo foi para o ajuste dos valores iniciais. Agora, temos os pesos: chaves seletoras que permitem selecionar resistores.

#figure(
  image("./images/3.png", width: 80%),
  caption: [Chaves seletoras HH],
)

Pra que isso serve? Bom, a equação de soma do amplificador operacional na configuração inversora é esta:

$ V_"out" = -R_f dot (V_1/R_1 + V_2/R_2 + V_3/R_3) $

Assim, se temos apenas $V_1\neq 0$ e apenas o resistor de 5k selecionado, teremos:

$ V_"out" = (10k)/(5k)V_1 = 2 V_1$

Ou seja, multiplicamos por 2 a entrada! O mesmo vale para todos os outros potenciômetros.

Para cada linha, os resistores estão em série. Então cada resistor selecionado será somado. Isso permite várias combinações diferentes de pesos para cada entrada:

$ 2,1,1/2,1/3,1/15,1/25 $

Após o processamento pelo amp-op, ele inverte o sinal. Se a entrada for 5V, ele devolve $-5V$. Isso foi um problema, pois para trabalhar como somador inversor, o amp-op precisava de uma fonte simétrica ($plus.minus 20V$, por exemplo, ao invés de $20V,0V$ como as fontes comuns). O problema é que esse tipo de fonte é cara. Então, fizemos um terra virtual, onde dividimos a tensão no meio, e o ponto “zero” será $10V$, de modo que $0V$ será lido como $-10V$.

Segue abaixo o projeto completo. A parte de baixo não foi feita, pois é a mesma coisa que o circuito principal, mas utiliza uma tensão fixa de entrada ao invés de um potenciômetro.

#figure(
  image("./images/4.png", width: 100%),
  caption: [Circuito Completo],
)

No nosso projeto, a d.d.p. que os potenciômetros podem assumir está entre 20V e 10V (ou seja, até 10V efetivos de ajuste). O Amp-Op será alimentado com $+20V$ e um terra virtual de $+10V$ (ou seja, terra virtual). Como o Amp-Op está na configuração inversora, ele só poderá entregar na saída entre $0V~10V$, que é nosso "negativo" (terra virtual).

Portanto, o voltímetro, ao ter seu negativo conectado em $+10V$, enxergará $0V$ como $-10V$, que é exatamente o que queremos. Isso evita ter que usar uma fonte simétrica.

O problema é que, como o Amp-Op só entrega $0V~10V$ ($-10V~0V$ para o voltímetro), temos um intervalo bastante curto de visualização de resultados. Experimentalmente, só conseguimos visualizar somas de 0 a 8, aproximadamente. É um projeto bem simples e enxuto, mas demonstra bem o princípio de funcionamento do Amp-Op e uma aplicação prática: A soma.

= Componentes utilizados

- 3 Potenciômetros lineares de 10k
- Jumpers
- 2 Amp-Ops LM324N
- 1 Voltímetro
- 1 Fonte de Notebook 20V, 0V
- 9 Chaves HH
- 16 Resistores 1k
- 1 Placa Ilhada de cobre