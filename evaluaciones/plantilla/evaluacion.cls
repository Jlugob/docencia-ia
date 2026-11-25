% =====================================================================
%  evaluacion.cls — Evaluaciones escolares con el formato del generador
%  de SistemAcadémico (membrete del colegio, metadatos, preguntas A–D,
%  abiertas con líneas, contextos, tablas, código, Venn, silogismos y
%  clave de respuestas). Compila con pdfLaTeX, XeLaTeX o LuaLaTeX.
%
%  Opciones de clase:
%    carta | a4                     papel (carta por defecto)
%    doscolumnas | unacolumna       columnas de las preguntas (2 por defecto)
%    normal | compacta | muycompacta   densidad (compacta por defecto)
%    solucion                       marca la respuesta correcta en el examen
%    sinautoevaluacion              no imprime el recuadro de autoevaluación
%
%  Guía de uso: README.md (misma carpeta).
% =====================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{evaluacion}[2026/11/12 Evaluaciones escolares v1.0]

% ---------- Opciones ----------
\newif\if@eval@a     \@eval@afalse
\newif\if@eval@dos   \@eval@dostrue
\newif\if@eval@sol   \@eval@solfalse
\newif\if@eval@auto  \@eval@autotrue
\def\eval@densidad{compacta}

\DeclareOption{carta}{\@eval@afalse}
\DeclareOption{a4}{\@eval@atrue}
\DeclareOption{doscolumnas}{\@eval@dostrue}
\DeclareOption{unacolumna}{\@eval@dosfalse}
\DeclareOption{normal}{\def\eval@densidad{normal}}
\DeclareOption{compacta}{\def\eval@densidad{compacta}}
\DeclareOption{muycompacta}{\def\eval@densidad{muycompacta}}
\DeclareOption{solucion}{\@eval@soltrue}
\DeclareOption{sinautoevaluacion}{\@eval@autofalse}
\ProcessOptions\relax

\LoadClass[10pt]{article}

% ---------- Paquetes ----------
\RequirePackage{iftex}
\ifPDFTeX
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[scaled=0.92]{helvet}
\else
  \RequirePackage{fontspec}
  \IfFontExistsTF{DejaVu Sans}{\setsansfont{DejaVu Sans}[Scale=0.9]}{}
\fi
\renewcommand{\familydefault}{\sfdefault}
\RequirePackage[spanish,es-noshorthands,es-tabla]{babel}
\RequirePackage{amsmath,amssymb}
\RequirePackage{etoolbox}
\RequirePackage{calc}
\if@eval@a
  \RequirePackage[a4paper,top=3.25cm,bottom=1.4cm,left=1.3cm,right=1.3cm,headheight=2.65cm,headsep=0.45cm]{geometry}
\else
  \RequirePackage[letterpaper,top=3.25cm,bottom=1.4cm,left=1.3cm,right=1.3cm,headheight=2.65cm,headsep=0.45cm]{geometry}
\fi
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{array,tabularx,multirow}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{listings}
\RequirePackage{tikz}
\usetikzlibrary{patterns,calc}
\RequirePackage[most]{tcolorbox}
\RequirePackage[hidelinks]{hyperref}

% ---------- Colores ----------
\definecolor{acento}{HTML}{166534}      % color del colegio (cambiar con \colorcolegio)
\definecolor{bordemembrete}{HTML}{89A4C1}
\definecolor{grisnota}{HTML}{7A7A7A}
\definecolor{lineaabierta}{HTML}{9AA4B2}
\definecolor{fondocontexto}{HTML}{F7F8FA}
\definecolor{fondocodigo}{HTML}{F3F4F6}
\definecolor{bordecodigo}{HTML}{D1D5DB}
\definecolor{numcodigo}{HTML}{9AA4B2}
\definecolor{cod@kw}{HTML}{0550AE}
\definecolor{cod@str}{HTML}{0A7B34}
\definecolor{cod@com}{HTML}{6A737D}
\definecolor{cod@num}{HTML}{9A6700}
\definecolor{bordetabla}{HTML}{9AA4B2}
\definecolor{encabezadotabla}{HTML}{EEF1F4}
\definecolor{bordeclave}{HTML}{BFC7D1}
\newcommand{\colorcolegio}[1]{\definecolor{acento}{HTML}{#1}}

% ---------- Densidad ----------
\newlength{\eval@gap}
\def\eval@set#1#2#3#4#5{% tamaño pregunta, interlínea, tamaño opción, interlínea opción, separación
  \def\eval@fq{\fontsize{#1}{#2}\selectfont}%
  \def\eval@fo{\fontsize{#3}{#4}\selectfont}%
  \setlength{\eval@gap}{#5}}
\def\eval@tmp{normal}\ifx\eval@densidad\eval@tmp \eval@set{10.5pt}{14pt}{10pt}{13pt}{9pt}\fi
\def\eval@tmp{compacta}\ifx\eval@densidad\eval@tmp \eval@set{9.6pt}{11.8pt}{9.2pt}{11.2pt}{6pt}\fi
\def\eval@tmp{muycompacta}\ifx\eval@densidad\eval@tmp \eval@set{8.6pt}{9.8pt}{8.2pt}{9.4pt}{4pt}\fi
\AtBeginDocument{\eval@fq}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\setlength{\columnsep}{0.55cm}

% ---------- Metadatos ----------
\def\eval@colegio{Institución educativa}
\def\eval@logo{}
\def\eval@hoja{Evaluación general}
\def\eval@asignatura{}
\def\eval@grado{}
\def\eval@periodo{}
\def\eval@anio{}
\def\eval@docente{}
\def\eval@fecha{}
\def\eval@estudiante{}
\def\eval@nota{}
\def\eval@titulo{}
\def\eval@instrucciones{}
\newcommand{\colegio}[1]{\def\eval@colegio{#1}}
\newcommand{\logo}[1]{\def\eval@logo{#1}}
\newcommand{\tipohoja}[1]{\def\eval@hoja{#1}}
\newcommand{\asignatura}[1]{\def\eval@asignatura{#1}}
\newcommand{\grado}[1]{\def\eval@grado{#1}}
\newcommand{\periodo}[1]{\def\eval@periodo{#1}}
\newcommand{\anio}[1]{\def\eval@anio{#1}}
\newcommand{\docente}[1]{\def\eval@docente{#1}}
\newcommand{\fecha}[1]{\def\eval@fecha{#1}}
\newcommand{\estudiante}[1]{\def\eval@estudiante{#1}}
\newcommand{\nota}[1]{\def\eval@nota{#1}}
\newcommand{\titulo}[1]{\def\eval@titulo{#1}}
\newcommand{\instrucciones}[1]{\def\eval@instrucciones{#1}}

% ---------- Configuración del colegio (curriculo/config/colegio.yaml → kit-config.tex) ----------
% Si existe, da los valores por defecto de colegio, logo, color y docente; \colegio{}, \logo{},
% \colorcolegio{} y \docente{} en el documento los reemplazan.
\InputIfFileExists{kit-config.tex}{}{}
\ifdefined\kitcfg@colegio
  \def\eval@colegio{\kitcfg@colegio}%
  \ifx\kitcfg@logo\@empty\else\def\eval@logo{\kitcfg@logo}\fi
  \ifx\kitcfg@docente\@empty\else\def\eval@docente{\kitcfg@docente}\fi
  \definecolor{acento}{HTML}{\kitcfg@coleval}%
\fi
\providecommand{\kitcfg@leyenda}{Este documento es propiedad intelectual de la institución educativa}

% ---------- Membrete (se repite en cada página) ----------
\newcommand{\eval@logobox}{%
  \ifx\eval@logo\@empty
    \eval@logovacio
  \else
    \IfFileExists{\eval@logo}{\includegraphics[width=1.75cm,height=1.75cm,keepaspectratio]{\eval@logo}}{\eval@logovacio}%
  \fi}
\newcommand{\eval@logovacio}{%
  \tikz\draw[bordemembrete,dashed](0,0) rectangle (1.75cm,1.75cm) node[midway,font=\tiny\bfseries,text=grisnota]{LOGO};}

\newcommand{\eval@membrete}{%
  \begingroup
  \arrayrulecolor{bordemembrete}%
  \renewcommand{\arraystretch}{1.25}%
  \setlength{\tabcolsep}{4pt}%
  \begin{tabularx}{\textwidth}{|>{\centering\arraybackslash}m{2.1cm}|X|>{\centering\arraybackslash}m{1.3cm}|}
    \hline
    \multirow{3}{*}{\eval@logobox} &
      \multicolumn{2}{>{\centering\arraybackslash}m{\dimexpr\textwidth-2.1cm-6\tabcolsep-4\arrayrulewidth\relax}|}{%
        \color{acento}\fontsize{12}{14}\selectfont\bfseries\MakeUppercase{\eval@colegio}} \\
    \cline{2-3}
    & \multicolumn{2}{>{\centering\arraybackslash}m{\dimexpr\textwidth-2.1cm-6\tabcolsep-4\arrayrulewidth\relax}|}{%
        \color{grisnota}\fontsize{8}{10}\selectfont\bfseries\MakeUppercase{\eval@hoja}} \\
    \cline{2-3}
    & \fontsize{5}{6}\selectfont\bfseries \MakeUppercase{\kitcfg@leyenda}
    & {\fontsize{6.5}{7.5}\selectfont\bfseries\color{black!75}Página\newline \thepage\ de \pageref*{LastPage}} \\
    \hline
  \end{tabularx}%
  \endgroup}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[C]{\eval@membrete}

% ---------- Encabezado: título y datos ----------
\newcommand{\eval@raya}[2]{\ifx#1\@empty\rule[-1pt]{#2}{0.4pt}\else#1\fi}
\newcommand{\encabezado}{%
  \begin{center}
    {\fontsize{14}{17}\selectfont\bfseries
      \ifx\eval@titulo\@empty\MakeUppercase{Evaluación general de \eval@asignatura}\else\MakeUppercase{\eval@titulo}\fi\par}
    \vspace{2pt}
    {\fontsize{10.5}{12}\selectfont\bfseries\MakeUppercase{\eval@periodo}%
      \ifx\eval@anio\@empty\else\ \textperiodcentered\ \eval@anio\fi\par}
  \end{center}
  \vspace{2pt}
  {\fontsize{9}{11}\selectfont\bfseries
  \begin{tabularx}{\textwidth}{@{}X@{\hspace{1em}}l@{\hspace{1.5em}}l@{}}
    NOMBRE ESTUDIANTE: \eval@raya\eval@estudiante{6.2cm} & GRADO: \eval@grado &
      NOTA: \ifx\eval@nota\@empty(\hspace{1.2cm})\else\eval@nota\fi \\[1pt]
    DOCENTE: \eval@docente & FECHA: \ifx\eval@fecha\@empty\eval@raya\eval@fecha{2.4cm}\else\eval@fecha\fi & \\
  \end{tabularx}\par}
  \ifx\eval@instrucciones\@empty\else
    \vspace{5pt}{\fontsize{8.6}{10.4}\selectfont\itshape\eval@instrucciones\par}
  \fi
  \vspace{8pt}}

% ---------- Bloque de preguntas (1 o 2 columnas) ----------
\newenvironment{preguntas}{%
  \if@eval@dos\begin{multicols}{2}\raggedcolumns\fi\eval@fq}{%
  \if@eval@dos\end{multicols}\fi}

% ---------- Clave de respuestas (se va llenando sola) ----------
\newcounter{pregunta}
\def\eval@clave{}      % \eval@cl{n}{letra}
\def\eval@plano{}      % "1-B, 2-A, ..."
\def\eval@modelos{}    % \eval@md{n}{texto}
\def\eval@correcta{}
\newcommand{\eval@registrar}[1]{%
  \edef\eval@n{\thepregunta}%
  \xappto\eval@clave{\noexpand\eval@cl{\eval@n}{#1}}%
  \ifx\eval@plano\@empty\else\gappto\eval@plano{, }\fi
  \xappto\eval@plano{\eval@n-#1}}

% \begin{pregunta}[B] ... \end{pregunta}  (selección; B = respuesta correcta)
% \begin{pregunta}[abierta] ... \end{pregunta}
% La pregunta nunca se parte entre columnas ni páginas.
\NewDocumentEnvironment{pregunta}{O{?}}{%
  \refstepcounter{pregunta}%
  \def\eval@correcta{#1}%
  \def\eval@tmp{abierta}\def\eval@arg{#1}%
  \ifx\eval@arg\eval@tmp\eval@registrar{abierta}\else\eval@registrar{#1}\fi
  \par\noindent\begin{minipage}[t]{\linewidth}\eval@fq
  \textbf{\thepregunta.}\ \ignorespaces}{%
  \end{minipage}\par\vspace{\eval@gap}}

% Respuesta modelo de una pregunta abierta (solo sale en la clave)
\newcommand{\modelo}[1]{\xappto\eval@modelos{\noexpand\eval@md{\thepregunta}{\unexpanded{#1}}}}

% ---------- Opciones A–D ----------
\DeclareRobustCommand{\eval@letra}[1]{%
  \if@eval@sol
    \edef\eval@x{#1}%
    \ifx\eval@x\eval@correcta
      \tikz[baseline=(L.base)]\node[circle,draw=acento,fill=acento!15,inner sep=0.6pt,font=\bfseries](L){#1};.%
    \else\textbf{#1.}\fi
  \else\textbf{#1.}\fi}

% Rejilla 2×2 para opciones cortas
\newcommand{\opciones}[4]{%
  \par\vspace{2pt}{\eval@fo
  \setlength{\tabcolsep}{0pt}\renewcommand{\arraystretch}{1.1}%
  \begin{tabularx}{\linewidth}{@{\hspace{1.4em}}>{\raggedright\arraybackslash}X@{\hspace{0.8em}}>{\raggedright\arraybackslash}X@{}}
    \eval@letra{A}~#1 & \eval@letra{B}~#2 \\
    \eval@letra{C}~#3 & \eval@letra{D}~#4 \\
  \end{tabularx}\par}}

% Una opción por renglón (opciones largas)
\newcommand{\opcioneslargas}[4]{%
  \begin{opcioneslista}\item #1 \item #2 \item #3 \item #4\end{opcioneslista}}

% Entorno con \item (admite código, tablas, Venn, imágenes)
\newenvironment{opcioneslista}{%
  \eval@fo
  \begin{enumerate}[label=\eval@letra{\Alph*},leftmargin=2.6em,labelsep=0.4em,
    itemsep=1pt,topsep=2pt,parsep=0pt,partopsep=0pt]}{\end{enumerate}}

% Rejilla 2×2 centrada para opciones que son diagramas
\newcommand{\opcionesdiagrama}[4]{%
  \par\vspace{2pt}{\eval@fo
  \setlength{\tabcolsep}{2pt}%
  \begin{tabularx}{\linewidth}{>{\centering\arraybackslash}X>{\centering\arraybackslash}X}
    \eval@letra{A}\par #1 & \eval@letra{B}\par #2 \\[3pt]
    \eval@letra{C}\par #3 & \eval@letra{D}\par #4 \\
  \end{tabularx}\par}}

% ---------- Pregunta abierta: líneas para responder ----------
\newcommand{\abierta}[1][4]{%
  \par\vspace{0.1cm}%
  \begin{tikzpicture}
    \foreach \i in {1,...,#1}
      \draw[lineaabierta,line width=0.5pt] (0,-\i*0.58cm) -- (\linewidth,-\i*0.58cm);
  \end{tikzpicture}\par}

% ---------- Contexto / lectura compartida ----------
% \begin{contexto}[Título]  ...  \end{contexto}
% \grupo{Responda las preguntas 1 a 3 con base en...}
\newtcolorbox{contexto}[1][]{%
  enhanced, colback=fondocontexto, colframe=acento,
  boxrule=0pt, leftrule=2.5pt, arc=0pt, outer arc=0pt,
  left=6pt, right=6pt, top=4pt, bottom=4pt,
  before skip=0pt, after skip=\eval@gap,
  fontupper=\eval@fq,
  before upper={\def\eval@t{#1}\ifx\eval@t\@empty\else{\bfseries #1\par}\vspace{2pt}\fi}}
\newcommand{\grupo}[1]{{\eval@fo\bfseries #1\par}\vspace{2pt}}

% ---------- Tablas ----------
% \begin{tabla}[Título]{|l|c|c|}  \encabezados  A & B & C \\  1 & 2 & 3 \\  \end{tabla}
\newenvironment{tabla}[2][]{%
  \par\vspace{3pt}{\ifx\relax#1\relax\else\eval@fo\bfseries#1\par\vspace{1pt}\fi}%
  \begin{center}\eval@fo
  \arrayrulecolor{bordetabla}\renewcommand{\arraystretch}{1.15}%
  \begin{tabular}{#2}\hline}{%
  \end{tabular}\end{center}\vspace{-6pt}}
\newcommand{\encabezados}{\rowcolor{encabezadotabla}}
\newcommand{\fila}{\\\hline}

% ---------- Código ----------
\lstdefinestyle{evaluacion}{
  basicstyle=\ttfamily\fontsize{7.8}{9.2}\selectfont,
  backgroundcolor=\color{fondocodigo},
  frame=single, rulecolor=\color{bordecodigo}, framesep=3pt, framerule=0.4pt,
  numbers=left, numberstyle=\ttfamily\tiny\color{numcodigo}, numbersep=6pt,
  xleftmargin=1.6em, framexleftmargin=1.6em,
  keywordstyle=\color{cod@kw}\bfseries, stringstyle=\color{cod@str},
  commentstyle=\color{cod@com}\itshape,
  showstringspaces=false, columns=fullflexible, keepspaces=true,
  breaklines=true, tabsize=4, aboveskip=3pt, belowskip=3pt,
  extendedchars=true,
  literate={á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
           {Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
           {ñ}{{\~n}}1 {Ñ}{{\~N}}1 {ü}{{\"u}}1 {¿}{{?`}}1 {¡}{{!`}}1
}
\lstset{style=evaluacion}
% Pseudocódigo en español (estilo PSeInt)
\lstdefinelanguage{pseint}{
  morekeywords={Algoritmo,FinAlgoritmo,Proceso,FinProceso,Definir,Como,Entero,Real,
    Caracter,Logico,Leer,Escribir,Si,Entonces,SiNo,FinSi,Mientras,Hacer,FinMientras,
    Para,Hasta,Con,Paso,FinPara,Repetir,Segun,FinSegun,Funcion,FinFuncion,Y,O,NO},
  sensitive=false, morecomment=[l]{//}, morestring=[b]"}
% \begin{codigo}[language=Python] ... \end{codigo}
\lstnewenvironment{codigo}[1][]{\lstset{#1}}{}
% Código en línea:  \cod{x = 3}
\newcommand{\cod}[1]{\begingroup\setlength{\fboxsep}{1pt}\colorbox{fondocodigo}{\ttfamily\small#1}\endgroup}

% ---------- Imágenes ----------
% \imagen[0.8]{archivo}  ancho como fracción del ancho de columna; si el
% archivo no existe deja un recuadro con el nombre (el documento compila igual).
\newcommand{\imagen}[2][0.8]{%
  \par\vspace{2pt}{\centering
  \IfFileExists{#2}{\includegraphics[width=#1\linewidth]{#2}}{%
    \tikz\draw[lineaabierta,dashed](0,0) rectangle (#1\linewidth,0.45*#1\linewidth)
      node[midway,font=\scriptsize,text=grisnota,align=center]{Imagen pendiente:\\\detokenize{#2}};}%
  \par}\vspace{2pt}}

% ---------- Diagramas de Venn ----------
% \venn[sombreado={SM,S}, marcas={SP, SP|SMP}, titulo={...}, escala=0.8]{S,M,P}
%  · 2 o 3 conjuntos de una letra. Con 3, el 1.º va arriba a la izquierda,
%    el 2.º abajo y el 3.º arriba a la derecha (S,M,P = silogismo).
%  · Región = letras que están DENTRO, en el orden de los conjuntos:
%    "S" (solo S), "SM" (S y M, no P), "SMP" (las tres)...
%  · sombreado = regiones vacías (trama diagonal); marcas = ×;
%    "SP|SMP" pone la × sobre la línea entre dos regiones.
\pgfkeys{/venn/.is family, /venn,
  sombreado/.store in=\venn@somb, marcas/.store in=\venn@marcas,
  titulo/.store in=\venn@titulo, escala/.store in=\venn@escala,
  sombreado={}, marcas={}, titulo={}, escala={0.75}}
\def\venn@pos{}% posición (1,2,3) de cada letra
\newcommand{\venn@codigo}[1]{% región "SM" -> "110"
  \gdef\venn@cod{}%
  \xdef\venn@reg{#1}%
  \foreach \L in \venn@lista{%
    \edef\venn@t{\noexpand\in@{\L}{\venn@reg}}\venn@t
    \ifin@\xappto\venn@cod{1}\else\xappto\venn@cod{0}\fi}%
}
\newcommand{\venn}[2][]{%
  \pgfkeys{/venn,sombreado={},marcas={},titulo={},escala={0.75},#1}%
  \def\venn@lista{#2}%
  \def\venn@n{0}%
  \foreach \L in {#2}{\xdef\venn@n{\the\numexpr\venn@n+1\relax}}%
  \par\vspace{2pt}{\centering
  \ifx\venn@titulo\@empty\else{\eval@fo\bfseries\venn@titulo\par}\vspace{1pt}\fi
  \begin{tikzpicture}[scale=\venn@escala,every node/.style={font=\small\bfseries}]
    \ifnum\venn@n=2
      \useasboundingbox (-1.75,-1.15) rectangle (1.75,1.2);
      \coordinate (c1) at (-0.55,0); \coordinate (c2) at (0.55,0);
      \coordinate (r10) at (-0.95,0); \coordinate (r01) at (0.95,0); \coordinate (r11) at (0,0);
      \coordinate (l1) at (-1.45,1.0); \coordinate (l2) at (1.45,1.0);
    \else
      \useasboundingbox (-1.8,-2.1) rectangle (1.8,1.5);
      \coordinate (c1) at (-0.6,0.4); \coordinate (c2) at (0,-0.6); \coordinate (c3) at (0.6,0.4);
      \coordinate (r100) at (-1.05,0.75); \coordinate (r010) at (0,-1.15); \coordinate (r001) at (1.05,0.75);
      \coordinate (r110) at (-0.62,-0.32); \coordinate (r101) at (0,0.88); \coordinate (r011) at (0.62,-0.32);
      \coordinate (r111) at (0,0.07);
      \coordinate (l1) at (-1.55,1.3); \coordinate (l2) at (0,-1.9); \coordinate (l3) at (1.55,1.3);
    \fi
    % Sombreado
    \ifx\venn@somb\@empty\else
    \foreach \R in \venn@somb{%
      \venn@codigo{\R}%
      \gdef\venn@clips{}%
      \foreach [count=\k] \L in \venn@lista{%
        \venn@bit{\k}%
        \ifnum\venn@b=1
          \xappto\venn@clips{\noexpand\clip (c\k) circle (1);}%
        \else
          \xappto\venn@clips{\noexpand\clip (c\k) circle (1) (-4,-4) -- (4,-4) -- (4,4) -- (-4,4) -- cycle;}%
        \fi}%
      \begin{scope}
        \venn@clips
        \fill[pattern=north east lines,pattern color=black!70] (-4,-4) rectangle (4,4);
      \end{scope}}\fi
    % Círculos y letras
    \foreach [count=\k] \L in \venn@lista{%
      \draw[line width=0.8pt] (c\k) circle (1);
      \node at (l\k) {\L};}
    % Marcas ×
    \ifx\venn@marcas\@empty\else
    \foreach \M in \venn@marcas{%
      \expandafter\venn@marca\expandafter{\M}}\fi
  \end{tikzpicture}\par}\vspace{2pt}}
\def\venn@bit#1{\edef\venn@b{\expandafter\venn@nth\venn@cod xxx\@nil{#1}}}
\def\venn@nth#1#2#3#4\@nil#5{\ifcase#5\or#1\or#2\or#3\fi}
\def\venn@x#1{\node[font=\large\bfseries] at (#1) {$\times$};}
\newcommand{\venn@marca}[1]{\venn@marcaaux#1||\@nil}
\def\venn@marcaaux#1|#2|#3\@nil{%
  \venn@codigo{#1}\edef\venn@ca{r\venn@cod}%
  \ifx\relax#2\relax
    \venn@x{\venn@ca}%
  \else
    \venn@codigo{#2}\edef\venn@cb{r\venn@cod}%
    \venn@x{$(\venn@ca)!0.5!(\venn@cb)$}%
  \fi}

% ---------- Silogismos ----------
% \silogismo{Todo M es P}{Todo S es M}{Todo S es P}
\newcommand{\silogismo}[3]{%
  \par\vspace{2pt}{\eval@fo
  \begin{tabular}{@{\hspace{1.2em}}l@{\hspace{0.6em}}l@{}}
    & #1 \\
    & #2 \\ \cline{2-2}
    $\therefore$ & #3 \\
  \end{tabular}\par}\vspace{2pt}}

% ---------- Autoevaluación ----------
\newcommand{\autoevaluacion}{%
  \if@eval@auto
  \par\vspace{10pt}\noindent
  \begin{tcolorbox}[enhanced,colback=white,colframe=black!80,boxrule=1.2pt,arc=0pt,
    left=8pt,right=8pt,top=4pt,bottom=4pt,fontupper=\fontsize{8.6}{10.4}\selectfont]
    \begin{center}\fontsize{11}{13}\selectfont\bfseries AUTOEVALUACIÓN\end{center}\vspace{-6pt}
    De acuerdo con el desempeño presentado durante el período académico y teniendo en cuenta:
    mi responsabilidad, compromiso, disciplina, respeto, participación, desempeño y demás
    aspectos que forman mi SER. Mi nota de Autoevaluación es: \rule{1.2cm}{0.4pt} que equivale
    al 5\,\% de la asignatura.
  \end{tcolorbox}
  \fi}

% ---------- Clave de respuestas (página aparte, al final) ----------
\def\eval@cl#1#2{%
  \def\eval@y{#2}\def\eval@z{abierta}%
  \fcolorbox{bordeclave}{white}{\makebox[1.45cm]{\fontsize{10}{12}\selectfont #1.\ \ifx\eval@y\eval@z\textit{abierta}\else\textbf{#2}\fi}}\hspace{2pt}\allowbreak}
\def\eval@md#1#2{\par\vspace{4pt}\noindent\textbf{#1.}\ #2\par}
\newcommand{\imprimirclave}{%
  \clearpage
  \tipohoja{Clave de respuestas — uso exclusivo del docente}%
  \begin{center}
    {\fontsize{14}{17}\selectfont\bfseries CLAVE DE RESPUESTAS\par}\vspace{2pt}
    {\fontsize{10.5}{12}\selectfont\bfseries\MakeUppercase{\eval@asignatura\ — \eval@grado\ — \eval@periodo}\par}
    \vspace{12pt}
    {\fontsize{11}{14}\selectfont\bfseries\eval@plano\par}
    \vspace{12pt}
    \begin{minipage}{0.92\textwidth}\centering\setlength{\fboxsep}{4pt}\eval@clave\end{minipage}
  \end{center}
  \ifx\eval@modelos\@empty\else
    \vspace{10pt}
    \begin{minipage}{0.9\textwidth}\fontsize{9.5}{12}\selectfont
      {\bfseries\fontsize{10.5}{12}\selectfont RESPUESTAS MODELO — PREGUNTAS ABIERTAS\par}
      \vspace{1pt}{\color{bordeclave}\rule{\linewidth}{0.6pt}}\par
      \eval@modelos
    \end{minipage}
  \fi}

\endinput
