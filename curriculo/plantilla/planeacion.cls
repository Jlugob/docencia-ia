% planeacion.cls — Formatos de planeación escolar (docencia-ia). Adaptable a cualquier colegio:
% nombre, logo, leyenda, colores, fuente, estilo de encabezado y perfil pedagógico se leen de
% curriculo/config/colegio.yaml y docente.yaml (vía kit-config.tex, que genera configurar.py).
% Formatos:
%   - MALLA CURRICULAR (por área, grado y periodo)
%   - PARCELACIÓN (por semanas, sin fechas)
% Compilar con XeLaTeX (dos veces, para «Página X de Y»).
%
% Uso mínimo:
%   \documentclass[malla]{planeacion}        % o [parcelacion]
%   \materia{tecnologia}                     % tecnologia | filosofia | etica | emocional | otra
%   \grado{6} \periodo{I} \anio{2027} \docente{Nombre del Docente}  % opcional: por defecto, el de docente.yaml
%   \begin{document}
%   \begin{malla}{<texto de la fila superior (estándares o su equivalente)>}
%     \fila{temas}{componente}{subproceso}{competencias}{referente}
%   \end{malla}
%   \end{document}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{planeacion}[2026/11/25 Formatos de planeacion escolar - docencia-ia]

\newif\if@malla \@mallatrue
\DeclareOption{malla}{\@mallatrue}
\DeclareOption{parcelacion}{\@mallafalse}
% [programa]: programa del periodo para estudiantes (carta vertical).
\newif\if@programa
\DeclareOption{programa}{\@mallafalse\@programatrue}
% [taller] y [habilitacion]: guías para estudiantes con el mismo estilo del programa (carta vertical).
\newif\if@taller \newif\if@habilitacion
\DeclareOption{taller}{\@mallafalse\@programatrue\@tallertrue}
\DeclareOption{habilitacion}{\@mallafalse\@programatrue\@habilitaciontrue}
% [borrador]: marca de agua «BORRADOR» hasta que coordinación apruebe el documento.
\newif\if@borrador
\DeclareOption{borrador}{\@borradortrue}
\ProcessOptions\relax

% ---------- Configuración del colegio (curriculo/config/colegio.yaml → kit-config.tex) ----------
% Si no existe (p. ej. en Overleaf sin el kit), se usan valores neutros.
\InputIfFileExists{kit-config.tex}{}{}
\providecommand{\kitcfg@colegio}{Nombre del colegio}\providecommand{\kitcfg@municipio}{}
\providecommand{\kitcfg@leyenda}{Este documento es propiedad intelectual de la institución educativa}
\providecommand{\kitcfg@firmainst}{Coordinación académica}\providecommand{\kitcfg@logo}{}
\providecommand{\kitcfg@docente}{}\providecommand{\kitcfg@anio}{}
\providecommand{\kitcfg@encabezado}{tabla}\providecommand{\kitcfg@papel}{oficio}
\providecommand{\kitcfg@fuente}{DejaVu Sans}
\providecommand{\kitcfg@colinst}{003366}\providecommand{\kitcfg@colprog}{2E5B40}\providecommand{\kitcfg@colprogdos}{7C8746}
\providecommand{\kitcfg@entregable}{1}
\providecommand{\kitcfg@quizmin}{1}\providecommand{\kitcfg@quizmax}{1}
\providecommand{\kitcfg@tallermin}{1}\providecommand{\kitcfg@tallermax}{3}\providecommand{\kitcfg@evaluaciones}{1}
\def\kit@tmp{sencillo}\newif\ifkit@sencillo\ifx\kitcfg@encabezado\kit@tmp\kit@sencillotrue\fi
\def\kit@tmp{carta}\newif\ifkit@carta\ifx\kitcfg@papel\kit@tmp\kit@cartatrue\fi

\LoadClass[10pt]{article}

% ---------- Página: oficio horizontal, márgenes del formato de Word ----------
% (el programa del periodo para estudiantes va en carta vertical)
\if@programa
\RequirePackage[letterpaper,left=1.7cm,right=1.7cm,top=3.5cm,bottom=1.6cm,headheight=2.65cm,
  headsep=0.4cm,footskip=0.7cm]{geometry}
\else
\RequirePackage[paperwidth=\ifkit@carta 27.94cm\else 35.56cm\fi,paperheight=21.59cm,
  left=1.8cm,right=1.8cm,top=3.6cm,bottom=1.6cm,headheight=2.75cm,headsep=0.35cm,
  footskip=0.7cm]{geometry}
\fi

% ---------- Idioma y fuente (Tahoma si existe; si no, DejaVu Sans) ----------
\RequirePackage{fontspec}
\RequirePackage{polyglossia}
\setdefaultlanguage{spanish}
% Tahoma no viene en TeX Live: DejaVu Sans es de la misma familia de diseño (Verdana/Tahoma).
\def\kit@tmp{DejaVu Sans}
\ifx\kitcfg@fuente\kit@tmp
  \setmainfont{DejaVu Sans}[Scale=0.88,ItalicFont=DejaVu Sans,ItalicFeatures={FakeSlant=0.2},BoldItalicFont=DejaVu Sans Bold,BoldItalicFeatures={FakeSlant=0.2}]
\else
  \IfFontExistsTF{\kitcfg@fuente}{\setmainfont{\kitcfg@fuente}[Scale=0.9]}%
    {\setmainfont{DejaVu Sans}[Scale=0.88]\ClassWarningNoLine{planeacion}{No encuentro la fuente \kitcfg@fuente; uso DejaVu Sans}}
\fi

% ---------- Paquetes ----------
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx,array,tabularx,xltabular,multirow,fancyhdr,lastpage,etoolbox,enumitem}
\RequirePackage{environ,ragged2e,pgfcalendar,refcount,tikz,needspace}
\if@borrador
  \RequirePackage{draftwatermark}
  \SetWatermarkText{BORRADOR}\SetWatermarkScale{1.6}\SetWatermarkColor[gray]{0.935}
\fi
\RequirePackage[hidelinks]{hyperref}
\definecolor{azulcolegio}{HTML}{\kitcfg@colinst}
\definecolor{grisformato}{HTML}{E7E6E6} % «Blanco, fondo 1, oscuro 10 %» de Word
% Reglas de las tablas: negras en malla y parcelación (fieles al Word); en el programa, carbón y
% más finas. Separación entre clases de una misma semana: gris claro.
\definecolor{carbon}{HTML}{3A3D3A}
\if@programa\colorlet{regla}{carbon}\colorlet{reglasuave}{black!16}\else
  \colorlet{regla}{black}\colorlet{reglasuave}{black!30}\fi
% Filas alternas: crema muy leve para distinguir una fila de la siguiente.
\definecolor{cremafila}{HTML}{FBF6EA}
\setlength{\parindent}{0pt}
\renewcommand{\arraystretch}{1.2}
\setlist{nosep,leftmargin=*,label=\textbullet}
% Viñeta para celdas (itemize deja espacio extra arriba): \punto Primera. \punto Segunda.
\newcommand{\punto}{\par\noindent\hangindent=1em\hangafter=1\makebox[1em][l]{\textbullet}}

% ---------- Datos del documento ----------
\newcommand{\colegio}{\MakeUppercase{\kitcfg@colegio\ifdefempty{\kitcfg@municipio}{}{ – \kitcfg@municipio}}}
\newcommand{\@grado}{} \newcommand{\@periodo}{} \newcommand{\@anio}{\ifdefempty{\kitcfg@anio}{\the\year}{\kitcfg@anio}}
\newcommand{\@docente}{\kitcfg@docente} \newcommand{\@area}{}
\newcommand{\grado}[1]{\renewcommand{\@grado}{#1}}
\newcommand{\periodo}[1]{\renewcommand{\@periodo}{#1}}
\newcommand{\anio}[1]{\renewcommand{\@anio}{#1}}
\newcommand{\docente}[1]{\renewcommand{\@docente}{#1}}
\newcommand{\area}[1]{\renewcommand{\@area}{#1}}
\newcommand{\logo}{\kitcfg@logo}
% Logo con su altura; si no hay archivo, un recuadro «LOGO» del mismo tamaño.
\newcommand{\@logo}[1]{\ifdefempty{\logo}{\@logovacio{#1}}{\IfFileExists{\logo}{\includegraphics[height=#1]{\logo}}{\@logovacio{#1}}}}
\newcommand{\@logovacio}[1]{\tikz\draw[gray,dashed](0,0) rectangle (#1,#1) node[midway,font=\tiny\bfseries,text=gray]{LOGO};}

% ---------- Columnas según la materia ----------
% Filosofía, Tecnología, Ética y la Cátedra de Educación Emocional no tienen DBA (y solo Ética tiene estándares). Se conserva la estructura del
% formato y se rotulan las columnas con el referente oficial de cada materia; la nota aclaratoria
% lo explica. Ver curriculo/referentes/.
\newcommand{\@colEst}{ESTÁNDARES}
\newcommand{\@colA}{TEMAS Y SUBTEMAS}
\newcommand{\@colB}{FACTOR O COMPONENTE}
\newcommand{\@colC}{SUBPROCESO}
\newcommand{\@colD}{COMPETENCIAS}
\newcommand{\@colE}{DERECHOS BÁSICOS DE APRENDIZAJE (DBA)}
\newcommand{\@notamateria}{}
\newcommand{\columnas}[6]{%
  \renewcommand{\@colEst}{#1}\renewcommand{\@colA}{#2}\renewcommand{\@colB}{#3}%
  \renewcommand{\@colC}{#4}\renewcommand{\@colD}{#5}\renewcommand{\@colE}{#6}}
\newcommand{\notamateria}[1]{\renewcommand{\@notamateria}{#1}}

% Cualquier otra área (Matemáticas, Lenguaje, Ciencias…) usa las columnas estándar del formato, con estándares y DBA, y sin nota aclaratoria: \materia{Matemáticas}.
\newcommand{\materia}[1]{%
  \area{#1}\notamateria{}%
  \columnas{ESTÁNDARES}{TEMAS Y SUBTEMAS}{FACTOR O COMPONENTE}{SUBPROCESO}{COMPETENCIAS}%
    {DERECHOS BÁSICOS DE APRENDIZAJE (DBA)}%
  \ifstrequal{#1}{tecnologia}{%
    \area{Tecnología e Informática}%
    \columnas{COMPETENCIAS DE REFERENCIA}{TEMAS Y SUBTEMAS}{COMPONENTE}{DESEMPEÑOS}%
      {COMPETENCIAS}{EVIDENCIAS DE APRENDIZAJE (MEN, 2022)}%
    \notamateria{El área de Tecnología e Informática no cuenta con Estándares Básicos de
      Competencias vigentes ni con Derechos Básicos de Aprendizaje (DBA) expedidos por el
      Ministerio de Educación Nacional. Su referente oficial son las \emph{Orientaciones
      curriculares para el área de Tecnología e Informática en la educación básica y media}
      (MEN, 2022), de donde se toman los componentes, las competencias y las evidencias de
      aprendizaje registradas en esta malla.}}{}%
  \ifstrequal{#1}{filosofia}{%
    \area{Filosofía}%
    \columnas{PREGUNTA PROBLEMATIZADORA}{TEMAS Y SUBTEMAS}{NÚCLEO DE PROBLEMAS}{SUBPROCESO}%
      {COMPETENCIAS DEL FILOSOFAR}{DESEMPEÑOS (DOC. 14, MEN)}%
    \notamateria{Filosofía no cuenta con Estándares Básicos de Competencias ni con Derechos
      Básicos de Aprendizaje (DBA) expedidos por el Ministerio de Educación Nacional. Su referente
      oficial es el \emph{Documento n.º 14. Orientaciones pedagógicas para la Filosofía en la
      Educación Media} (MEN, 2010): competencias crítica, dialógica y creativa, y núcleos de
      problemas del conocimiento, la estética y la moral. En la básica secundaria el área se
      ofrece por decisión del PEI y adapta estas orientaciones a la edad de los estudiantes.}}{}%
  \ifstrequal{#1}{etica}{%
    \area{Educación Ética y en Valores Humanos}%
    \columnas{ESTÁNDARES (COMPETENCIAS CIUDADANAS)}{TEMAS Y SUBTEMAS}{COMPONENTE}{SUBPROCESO}%
      {COMPETENCIAS}{ESTÁNDARES ESPECÍFICOS (GUÍA 6, MEN)}%
    \notamateria{El área de Educación Ética y en Valores Humanos no cuenta con Derechos Básicos de
      Aprendizaje (DBA). Sus referentes oficiales son los \emph{Lineamientos curriculares de
      Educación Ética y Valores Humanos} (MEN, 1998), de donde se toman los componentes, y los
      \emph{Estándares Básicos de Competencias Ciudadanas} (Guía n.º 6, MEN, 2004).}}{}%
  \ifstrequal{#1}{emocional}{%
    \area{Cátedra de Educación Emocional}%
    \columnas{FINES DE LA CÁTEDRA (LEY 2503, ART. 7)}{TEMAS Y SUBTEMAS}{COMPETENCIA EMOCIONAL}%
      {SUBPROCESO}{COMPETENCIAS}{DESEMPEÑOS}%
    \notamateria{La Cátedra de Educación Emocional se implementa en cumplimiento de la Ley 2503
      de 2025. A la fecha de este documento el Ministerio de Educación Nacional no ha expedido su
      reglamentación ni lineamientos curriculares, y la cátedra no cuenta con estándares ni DBA.
      Los componentes corresponden a las competencias emocionales definidas en el artículo 2 de la
      ley y los fines, a su artículo 7.}}{}%
}

% ---------- Encabezado: estilo «tabla» (formato tipo Word) o «sencillo» (colegio.yaml) ----------
\newcommand{\@nombreformato}{\if@malla MALLA CURRICULAR\else\if@taller TALLER\else\if@habilitacion PLAN DE HABILITACIÓN\else\if@programa PROGRAMA DEL PERIODO\else PARCELACIÓN\fi\fi\fi\fi\ \@anio}
% Mismas zonas del Word: logo | colegio / formato / propiedad | página. El logo va en su propia
% celda (no con \multirow) para que el encabezado tenga la altura exacta.
\newlength{\@anchoenc}
\newsavebox{\@cajaenc}
% El bloque de texto se compone primero en una caja; el logo va en una caja de la misma altura,
% centrado en horizontal y en vertical (así queda centrado en su celda en todos los formatos).
\newcommand{\@encabezadotabla}{\rowcolors{1}{}{}%
  \arrayrulecolor{azulcolegio}\setlength{\arrayrulewidth}{0.8pt}\renewcommand{\arraystretch}{1.3}%
  \setlength{\@anchoenc}{\dimexpr\linewidth-2.6cm-3\arrayrulewidth-3.6cm-4\tabcolsep-\arrayrulewidth\relax}%
  \sbox{\@cajaenc}{\begin{tabular}[c]{>{\raggedright\arraybackslash}p{\@anchoenc}|>{\centering\arraybackslash}m{3.6cm}}
      \multicolumn{2}{c}{\color{azulcolegio}\bfseries\if@programa\large\else\Large\fi\ \colegio}\\ \hline
      \bfseries NOMBRE DEL FORMATO: \@nombreformato & {\bfseries\footnotesize PÁGINA}\\ \cline{1-1}
      {\bfseries\scriptsize\MakeUppercase{\kitcfg@leyenda}}
        & {\bfseries \thepage\ de \pageref*{LastPage}}
    \end{tabular}}%
  \renewcommand{\arraystretch}{1}%
  \begin{tabular}{|@{}c@{}|@{}c@{}|}
    \hline
    \parbox[c][\dimexpr\ht\@cajaenc+\dp\@cajaenc\relax][c]{2.6cm}{\centering\@logo{1.65cm}} &
    \usebox{\@cajaenc}\\ \hline
  \end{tabular}\arrayrulecolor{black}}
% Estilo sencillo: logo y colegio a la izquierda; formato y página a la derecha; una línea debajo.
\newcommand{\@encabezadosencillo}{%
  \begin{minipage}[b]{\linewidth}
    \begin{minipage}[c]{2.1cm}\@logo{1.7cm}\end{minipage}%
    \begin{minipage}[c]{\dimexpr.66\linewidth-2.1cm\relax}
      {\color{azulcolegio}\bfseries\if@programa\large\else\Large\fi\kitcfg@colegio}\par\vspace{1pt}
      {\small\ifdefempty{\kitcfg@municipio}{}{\kitcfg@municipio\par}}
      {\tiny\color{black!60}\MakeUppercase{\kitcfg@leyenda}}
    \end{minipage}\hfill
    \begin{minipage}[c]{.32\linewidth}\raggedleft
      {\bfseries\@nombreformato}\par\vspace{2pt}
      {\small Página \thepage\ de \pageref*{LastPage}}
    \end{minipage}\par\vspace{5pt}
    {\color{azulcolegio}\hrule height 0.9pt}
  \end{minipage}}
\newcommand{\encabezado}{\ifkit@sencillo\@encabezadosencillo\else\@encabezadotabla\fi}
\pagestyle{fancy}\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[C]{\encabezado}
% Ficha de datos: una fila con bordes, a todo el ancho.
\newcommand{\@ficha}[1]{% #1 = Área o Asignatura
  {\rowcolors{1}{}{}\setlength{\arrayrulewidth}{1pt}\renewcommand{\arraystretch}{1.5}%
  \begin{tabularx}{\linewidth}{|l|>{\hsize=1.25\hsize}X|l|l|l|l|l|l|l|>{\hsize=.75\hsize}X|}
    \hline
    \cellcolor{grisformato}\textbf{#1} & \@area &
    \cellcolor{grisformato}\textbf{GRADO} & \@grado &
    \cellcolor{grisformato}\textbf{PERIODO} & \@periodo &
    \cellcolor{grisformato}\textbf{AÑO} & \@anio &
    \cellcolor{grisformato}\textbf{DOCENTE} & \@docente\\ \hline
  \end{tabularx}}\par\vspace{8pt}}
\fancyfoot[R]{\scriptsize\color{gray}\@area\ · Grado \@grado\ · Periodo \@periodo\ · \@anio}

% ---------- Tabla principal ----------
\newcolumntype{Y}{>{\RaggedRight\arraybackslash}X}
\newcommand{\@titulos}[1]{\textbf{\small #1}}
\setlength{\tabcolsep}{6pt}
% Anchos de columna explícitos (más predecibles que >{\hsize=…}X). \@anchos{fijo}{n}{f1,f2,…} reparte el ancho libre entre n columnas
% proporcionales; la última columna queda como X y toma exactamente lo que sobra.
\newlength{\pl@libre}\newlength{\pl@ca}\newlength{\pl@cb}\newlength{\pl@cc}\newlength{\pl@cd}
\newcommand{\@anchos}[6]{% #1 fijo, #2 columnas totales (con bordes), #3..#6 factores ×100 sobre el total de factores ×100 (#6)
  \setlength{\pl@libre}{\dimexpr\linewidth-#1-2\tabcolsep*#2-\arrayrulewidth*(#2+1)\relax}%
  \setlength{\pl@ca}{\dimexpr\pl@libre*#3/#6\relax}%
  \setlength{\pl@cb}{\dimexpr\pl@libre*#4/#6\relax}%
  \setlength{\pl@cc}{\dimexpr\pl@libre*#5/#6\relax}}
\newcommand{\@anchod}[2]{\setlength{\pl@cd}{\dimexpr\pl@libre*#1/#2\relax}}
\newcolumntype{P}[1]{>{\RaggedRight\arraybackslash}p{#1}}
% Título de columna centrado DENTRO del ancho de su columna (con \multicolumn{1}{c|} el título
% tomaba su ancho natural, ensanchaba la columna y el color de las filas no llegaba a la regla).
\newcommand{\@ct}[1]{\centering\arraybackslash #1}

% MALLA: \begin{malla}{texto de la fila superior} ... \fila{a}{b}{c}{d}{e} ... \end{malla}
\NewEnviron{malla}[1]{%
  \@ficha{ÁREA}
  \begingroup\setlength{\arrayrulewidth}{1pt}\rowcolors{1}{white}{cremafila}%
  \@anchos{0pt}{5}{115}{60}{95}{500}\@anchod{105}{500}%
  \begin{xltabular}{\linewidth}{|P{\pl@ca}|P{\pl@cb}|P{\pl@cc}|P{\pl@cd}|Y|}
    \hline
    \rowcolor{white}\multicolumn{5}{|>{\raggedright\arraybackslash}p{\dimexpr\linewidth-2\tabcolsep-2\arrayrulewidth}|}{\@reiniciafechas\@titulos{\@colEst:}\quad #1}\\ \hline
    \rowcolor{grisformato}\@ct{\@titulos{\@colA}} & \@ct{\@titulos{\@colB}} &
    \@ct{\@titulos{\@colC}} & \@ct{\@titulos{\@colD}} &
    \@ct{\@titulos{\@colE}}\\ \hline
    \endfirsthead
    \hline
    \rowcolor{grisformato}\@ct{\@titulos{\@colA}} & \@ct{\@titulos{\@colB}} &
    \@ct{\@titulos{\@colC}} & \@ct{\@titulos{\@colD}} &
    \@ct{\@titulos{\@colE}}\\ \hline
    \endhead
    \hline\endfoot
    \@piefinal{\@haynota{}{\vspace{4pt}\@textonota}}\endlastfoot
    \BODY
  \end{xltabular}\@cierretabla\endgroup}
\newcommand{\fila}[5]{\small #1\@marcafila & \small #2 & \small #3 & \small #4 & \small #5\@finfila}

% PARCELACIÓN: \begin{parcelacion} ... \semana{n}{temas}{actividad}{recursos}{evaluación} ...
\NewEnviron{parcelacion}{%
  \@ficha{ASIGNATURA}\@tablahilo
  \begingroup\setlength{\arrayrulewidth}{1pt}\rowcolors{1}{white}{cremafila}%
  \@anchos{2cm}{5}{90}{135}{80}{400}%
  \begin{xltabular}{\linewidth}{|>{\centering\arraybackslash}p{2cm}|P{\pl@ca}|P{\pl@cb}|P{\pl@cc}|Y|}
    \hline
    \rowcolor{grisformato}\@reiniciafechas\@reiniciaclases\@titulos{SEMANA\if@modoclases\ifnum\pl@cps>1\newline\scriptsize CLASE\fi\fi\if@fechas\newline\scriptsize FECHA\fi} & \@ct{\@titulos{TEMAS Y SUBTEMAS}} &
    \@ct{\@titulos{ACTIVIDAD}} & \@ct{\@titulos{RECURSOS}} &
    \@ct{\@titulos{EVALUACIÓN}}\\ \hline
    \endhead
    \hline\endfoot
    \@piefinal{\@resumen\@convenciones\@bloquefirmas}\endlastfoot
    \BODY
  \end{xltabular}\@cierretabla\endgroup}
% ---------- Hilo conductor del periodo ----------
% \hiloconductor{cómo avanza el periodo de clase en clase}{punto de llegada}
% Se imprime bajo la ficha en la parcelación y con \mostrarhilo en el programa del periodo.
\newcommand{\@hilocamino}{}\newcommand{\@hilollegada}{}
\newcommand{\hiloconductor}[2]{\renewcommand{\@hilocamino}{#1}\renewcommand{\@hilollegada}{#2}}
\newcommand{\@tablahilo}{\ifdefempty{\@hilocamino}{}{%
  {\rowcolors{1}{}{}\if@programa\estilotabla\def\@anchohilo{2.4cm}\def\@colorhilo{verdeclaro}%
   \def\@textohilo{\leavevmode\color{pinotexto}}\else\setlength{\arrayrulewidth}{1pt}%
   \def\@anchohilo{3.2cm}\def\@colorhilo{grisformato}\def\@textohilo{}\fi
  \renewcommand{\arraystretch}{1.3}\renewcommand{\tabularxcolumn}[1]{m{##1}}%
  \begin{tabularx}{\linewidth}{|>{\bfseries\small\centering\hyphenpenalty=10000\arraybackslash}m{\@anchohilo}|>{\RaggedRight\arraybackslash}X|}
    \hline
    \cellcolor{\@colorhilo}\@textohilo HILO CONDUCTOR & \small\@hilocamino\\ \hline
    \cellcolor{\@colorhilo}\@textohilo PUNTO DE LLEGADA & \small\@hilollegada\\ \hline
  \end{tabularx}\arrayrulecolor{black}}\par\vspace{8pt}}}
\newcommand{\mostrarhilo}{\par\vspace{4pt}\@tablahilo}

% ---------- Fechas opcionales de la parcelación ----------
% La parcelación es reutilizable y por defecto NO lleva fechas. Si se necesita imprimirla con fechas
% (p. ej. porque coordinación pide la columna FECHA), basta indicar el lunes de la primera semana:
%   \fechainicio{2027-01-25}
% y cada \semana muestra bajo su número el rango lunes–viernes («25–29 ene»). Las semanas sin clase
% (Semana Santa, receso de octubre…) se escriben en su lugar con \receso{texto}: ocupan una semana
% del calendario y salen como una fila gris de lado a lado.
\newif\if@fechas
\newcount\@jsem \newcount\@jfin \newcount\@jinicio
\newcommand{\fechainicio}[1]{\global\@fechastrue\pgfcalendardatetojulian{#1}{\@jinicio}}
% La tabla se compone varias veces (para medir columnas): el calendario se reinicia en cada
% pasada desde la fila de títulos.
\newcommand{\@reiniciafechas}{\global\@jsem=\@jinicio\global\@fila=0\relax}
% ---------- Evitar que el pie (nota y firmas) quede solo en una página ----------
% Cada fila deja una etiqueta con su página. Si al compilar el pie quedó en una página sin filas,
% en la siguiente compilación se fuerza un salto antes de la última fila para que lo acompañe
% (por eso se compila tres veces). La decisión se guarda en el .aux para que sea estable.
\newcount\@fila
\newcommand{\pl@romper}{0}
% Va al final de la primera celda (al inicio desplazaría el texto una línea hacia abajo).
\newcommand{\@marcafila}{\global\advance\@fila by 1 \label{pl@fila@\the\@fila}}
% (sin \relax: un \relax tras \hline abriría la fila siguiente y el salto quedaría mal puesto)
\newcommand{\@finfila}{\\ \hline\ifnum\numexpr\@fila+1=\pl@romper\space\pagebreak\fi}
\newcommand{\pl@total}{0}
\newcommand{\@marcapie}{\label{pl@pie}}
% Al cerrar la tabla: guarda cuántas filas hubo y decide (con las páginas de la compilación
% anterior) si hay que mover la última fila junto al pie.
\newcommand{\@cierretabla}{%
  \edef\@decision{\pl@romper}%
  \ifnum\pl@romper=0
    \IfRefUndefinedExpandable{pl@pie}{}{\IfRefUndefinedExpandable{pl@fila@\pl@total}{}{%
      \ifnum\getpagerefnumber{pl@pie}>\getpagerefnumber{pl@fila@\pl@total}\relax
        \edef\@decision{\pl@total}\fi}}%
  \fi
  \immediate\write\@auxout{\gdef\string\pl@total{\the\@fila}\gdef\string\pl@romper{\@decision}%
    \gdef\string\pl@totsem{\the\pl@sem}\gdef\string\pl@totclases{\the\pl@nclases}%
    \gdef\string\pl@totfest{\the\pl@nfest}\gdef\string\pl@totsellos{\the\pl@nsellos}%
    \gdef\string\pl@totfirmas{\the\pl@nfirmas}\gdef\string\pl@totquiz{\the\pl@nquiz}%
    \gdef\string\pl@tottaller{\the\pl@ntaller}\gdef\string\pl@toteval{\the\pl@neval}}%
  \@revisamodo}
\newcommand{\pl@totsem}{0}\newcommand{\pl@totclases}{0}\newcommand{\pl@totfest}{0}
\newcommand{\pl@totsellos}{0}\newcommand{\pl@totfirmas}{0}\newcommand{\pl@totquiz}{0}
\newcommand{\pl@tottaller}{0}\newcommand{\pl@toteval}{0}
% Revisión del modo de trabajo (curriculo/MODO-DE-TRABAJO.md): avisos al compilar.
\newcommand{\@revisamodo}{\if@modoclases
  \ifnum\kitcfg@entregable=1 \ifnum\pl@nsinentrega>0 \PackageWarningNoLine{planeacion}{MODO DE TRABAJO: \the\pl@nsinentrega\space
    clase(s) sin entregable (\string\sello\space o \string\firma):\pl@clasessinentrega}\fi\fi
  \ifnum\pl@nquiz<\kitcfg@quizmin\space\PackageWarningNoLine{planeacion}{MODO DE TRABAJO: hay \the\pl@nquiz\space
    quiz(es); el perfil pide al menos \kitcfg@quizmin}\fi
  \ifnum\pl@nquiz>\kitcfg@quizmax\space\PackageWarningNoLine{planeacion}{MODO DE TRABAJO: hay \the\pl@nquiz\space
    quiz(es); el perfil admite máximo \kitcfg@quizmax}\fi
  \ifnum\pl@ntaller<\kitcfg@tallermin\space\PackageWarningNoLine{planeacion}{MODO DE TRABAJO: hay \the\pl@ntaller\space
    taller(es); el perfil pide al menos \kitcfg@tallermin}\fi
  \ifnum\pl@ntaller>\kitcfg@tallermax\space\PackageWarningNoLine{planeacion}{MODO DE TRABAJO: hay \the\pl@ntaller\space
    talleres; el perfil admite máximo \kitcfg@tallermax}\fi
  \ifnum\pl@neval=\kitcfg@evaluaciones\space\else\PackageWarningNoLine{planeacion}{MODO DE TRABAJO: el perfil pide
    \kitcfg@evaluaciones\space evaluación(es) de periodo (hay \the\pl@neval)}\fi
\fi}
% Resumen bajo la tabla (con los totales de la pasada anterior).
\newcommand{\@resumen}{\if@modoclases\par\vspace{4pt}{\footnotesize\textbf{RESUMEN:}\enspace
  \pl@totsem\ semanas · \the\pl@cps\ clase\ifnum\pl@cps>1 s\fi\ por semana ·
  \pl@totclases\ clases planeadas\ifnum\pl@totfest>0\ · \pl@totfest\ sin clase (festivos o
  actividades)\fi\ · \mbox{\@iconosello}\,\pl@totsellos\ entregables con sello · \mbox{\@iconofirma}\,\pl@totfirmas\ apuntes
  firmados · \pl@tottaller\ taller\ifnum\pl@tottaller=1\else es\fi\ · \pl@totquiz\ quiz ·
  \ifnum\pl@toteval=1 evaluación de periodo\else\pl@toteval\ evaluaciones de periodo\fi}\par\fi}
\newcommand{\@mes}[1]{\ifcase#1\or ene\or feb\or mar\or abr\or may\or jun\or jul\or ago\or sep\or oct\or nov\or dic\fi}
% Escribe el rango lunes–viernes de la semana actual y avanza el calendario 7 días.
\newcommand{\@rangosemana}{%
  \@jfin=\@jsem \advance\@jfin by 4
  \pgfcalendarjuliantodate{\@jsem}{\pl@ai}{\pl@mi}{\pl@di}%
  \pgfcalendarjuliantodate{\@jfin}{\pl@af}{\pl@mf}{\pl@df}%
  \ifnum\pl@mi=\pl@mf\relax
    \number\pl@di–\number\pl@df~\@mes{\pl@mf}%
  \else
    \number\pl@di~\@mes{\pl@mi}~–\ \number\pl@df~\@mes{\pl@mf}%
  \fi
  \global\advance\@jsem by 7\relax}
\newcommand{\receso}[1]{%
  \multicolumn{5}{|c|}{\cellcolor{grisformato}\small\bfseries
    \if@modoclases\global\advance\pl@jlun by 7 \global\pl@ses=\pl@cps\fi #1%
    \if@fechas\ \textmd{(\if@modoclases\begingroup\@jsem=\pl@jlun\@rangosemana\endgroup
      \else\@rangosemana\fi)}\fi}\\ \hline}

% ---------- Código de colores de la parcelación ----------
% \semana[<clave>]{n}{temas}{actividad}{recursos}{evaluación} colorea la fila según el tipo de
% semana. Tonos claros que se distinguen entre sí, del crema de las filas alternas y en
% fotocopia en gris (claridades distintas). Para agregar un tipo: \tiposemana{clave}{HTML}{texto}.
\newcommand{\@tipos}{}
% \tiposemana{clave}{color HTML}{etiqueta corta bajo el número}{texto de la convención}
% La etiqueta corta hace que el código se entienda también en fotocopia en blanco y negro.
\newcommand{\tiposemana}[4]{%
  \definecolor{sem@#1}{HTML}{#2}\csdef{sem@etq@#1}{#3}\csdef{sem@txt@#1}{#4}\listadd{\@tipos}{#1}}
\tiposemana{q}{D6E4F2}{Quiz}{Evaluación corta (quiz, control de lectura)}
\tiposemana{t}{E4DCF0}{Taller}{Taller o actividad evaluativa}
\tiposemana{p}{D5EAD8}{Proyecto}{Entrega o sustentación de proyecto}
\tiposemana{e}{F2D7A6}{Ev.\ periodo}{Evaluación de periodo}
\tiposemana{r}{F2D3D3}{Recup.}{Recuperación o nivelación}
\tiposemana{i}{E3E3E3}{Instit.}{Actividad institucional (sin clase regular)}
\newcommand{\@cc}{}\newcommand{\@etqsem}{}
\newcommand{\semana}[6][]{%
  \gdef\@cc{}\gdef\@etqsem{}%
  \ifstrempty{#1}{}{\ifcsdef{sem@txt@#1}%
    {\gdef\@cc{\cellcolor{sem@#1}}\global\csdef{sem@usado@#1}{}%
     \xdef\@etqsem{\csuse{sem@etq@#1}}}%
    {\PackageWarning{planeacion}{Tipo de semana desconocido: #1}}}%
  \@cc\textbf{#2}\ifdefempty{\@etqsem}{}{\ {\scriptsize\@etqsem}}\if@fechas\par{\scriptsize\@rangosemana}\fi\@marcafila & \@cc\small #3 & \@cc\small #4 & \@cc\small #5 & \@cc\small #6\@finfila}
% ---------- Parcelación por CLASES (sesiones) ----------
% Se planea cada clase, no cada semana. En el preámbulo:
%   \clasesporsemana{2}        % clases semanales del grado (p. ej. Filosofía 10.°: 2; otros: 1)
%   \diasclase{lun,jue}        % opcional: días de clase, para poner la fecha exacta de cada una
% En el cuerpo, las clases se escriben en orden; semana y número de clase se calculan solos:
%   \clase[tipo]{temas}{actividad}{recursos}{evaluación}
%   \festivo{motivo}           % esa clase no se dicta (festivo, salida, jornada): ocupa su lugar
%   \receso{motivo}            % semana completa sin clases (entre semanas)
% Las clases de una misma semana comparten fondo (blanco/crema alternando por semana) y se
% separan con línea gris; entre semanas va línea negra. Al final sale un resumen.
\newif\if@modoclases
\newcount\pl@cps \pl@cps=1
\newcount\pl@sem \newcount\pl@ses \newcount\pl@jlun \newcount\pl@jdia
\newcount\pl@nclases \newcount\pl@nfest \newcount\pl@ndias
\newcommand{\clasesporsemana}[1]{\global\@modoclasestrue\global\pl@cps=#1\relax}
\csdef{pl@off@lun}{0}\csdef{pl@off@mar}{1}\csdef{pl@off@mie}{2}\csdef{pl@off@mié}{2}%
\csdef{pl@off@jue}{3}\csdef{pl@off@vie}{4}\csdef{pl@off@sab}{5}%
\newcommand{\pl@nomdia}[1]{\ifcase#1\relax lun\or mar\or mié\or jue\or vie\or sáb\fi}
\newcommand{\diasclase}[1]{\global\@modoclasestrue\global\pl@ndias=0
  \def\do##1{\global\advance\pl@ndias by 1
    \ifcsdef{pl@off@##1}{\csxdef{pl@dia@\the\pl@ndias}{\csuse{pl@off@##1}}}%
      {\PackageWarning{planeacion}{Día desconocido: ##1 (use lun, mar, mie, jue, vie)}}}%
  \docsvlist{#1}}
% Estado del calendario de clases (se reinicia en cada pasada desde la fila de títulos).
\newcount\pl@nsellos \newcount\pl@nfirmas \newcount\pl@nquiz \newcount\pl@ntaller \newcount\pl@neval
\newcount\pl@nsinentrega
\newif\ifpl@hayentrega
\newcommand{\@reiniciaclases}{%
  \global\pl@sem=0 \global\pl@ses=\pl@cps \global\pl@jlun=\@jinicio
  \global\advance\pl@jlun by -7 \global\pl@nclases=0 \global\pl@nfest=0
  \global\pl@nsellos=0 \global\pl@nfirmas=0 \global\pl@nquiz=0 \global\pl@ntaller=0
  \global\pl@neval=0 \global\pl@nsinentrega=0 \gdef\pl@clasessinentrega{}}
\newcommand{\pl@clasessinentrega}{}
% ---------- Perfil pedagógico (docente.yaml): entregable por clase (sello) y apuntes firmados ----------
% \sello{texto}: entregable corto de la clase (se registra con sello).
% \firma{texto}: los apuntes de una clase de explicación, que el docente firma.
% Las clases de tipo q (quiz), t (taller) y e (evaluación) cuentan como entregable.
\newcommand{\@iconosello}{\tikz[baseline=-0.6ex]{\draw[regla,line width=0.45pt] (0,0) circle (0.68ex);
  \draw[regla,line width=0.3pt] (0,0) circle (0.45ex);
  \draw[regla,line width=0.5pt,line cap=round] (-0.22ex,0) -- (-0.05ex,-0.2ex) -- (0.25ex,0.22ex);}}
\newcommand{\@iconofirma}{\tikz[baseline=-0.6ex]{\draw[regla,line width=0.5pt,line cap=round]
  (-0.7ex,-0.35ex) .. controls (-0.4ex,0.45ex) and (-0.15ex,-0.6ex) .. (0.1ex,0.05ex)
  .. controls (0.25ex,0.4ex) and (0.4ex,-0.3ex) .. (0.75ex,0.15ex);}}
\newcommand{\sello}[1]{\global\pl@hayentregatrue\global\advance\pl@nsellos by 1
  \mbox{\@iconosello}\,#1}
\newcommand{\firma}[1]{\global\pl@hayentregatrue\global\advance\pl@nfirmas by 1
  \mbox{\@iconofirma}\,#1}
% Al iniciar una clase: tipo (cuenta quiz, taller, evaluación) y entregable pendiente.
\newcommand{\@iniciaentrega}[1]{\global\pl@hayentregafalse
  \ifstrequal{#1}{q}{\global\advance\pl@nquiz by 1 \global\pl@hayentregatrue}{}%
  \ifstrequal{#1}{t}{\global\advance\pl@ntaller by 1 \global\pl@hayentregatrue}{}%
  \ifstrequal{#1}{e}{\global\advance\pl@neval by 1 \global\pl@hayentregatrue}{}%
  \ifstrequal{#1}{p}{\global\pl@hayentregatrue}{}%
  \ifstrequal{#1}{r}{\global\pl@hayentregatrue}{}}
% Al terminar la clase: si no tuvo entregable, se anota para el aviso.
\newcommand{\@verificaentrega}{\ifpl@hayentrega\else\global\advance\pl@nsinentrega by 1
  \xdef\pl@clasessinentrega{\pl@clasessinentrega\space S\the\pl@sem-C\the\pl@ses}\fi}
% Pasa a la clase siguiente (y a la semana siguiente si la actual ya se completó).
\newcommand{\@avanzaclase}{%
  \global\advance\pl@ses by 1
  \ifnum\pl@ses>\pl@cps \global\pl@ses=1 \global\advance\pl@sem by 1
    \global\advance\pl@jlun by 7 \fi}
% Fecha de la clase actual: «lun 25 ene» (si hay días de clase) o el rango de la semana.
\newcommand{\@fechaclase}{%
  \ifcsdef{pl@dia@\the\pl@ses}{%
    \pl@jdia=\pl@jlun \advance\pl@jdia by \csuse{pl@dia@\the\pl@ses}\relax
    \pgfcalendarjuliantodate{\pl@jdia}{\pl@ai}{\pl@mi}{\pl@di}%
    \pl@nomdia{\csuse{pl@dia@\the\pl@ses}}~\number\pl@di~\@mes{\pl@mi}}%
   {\ifnum\pl@ses=1 \begingroup\@jsem=\pl@jlun\@rangosemana\endgroup\fi}}
% Fin de fila de una clase: línea gris dentro de la semana, negra al terminar la semana.
\newcommand{\@finclase}{\\ \ifnum\pl@ses<\pl@cps \arrayrulecolor{reglasuave}\hline\arrayrulecolor{regla}%
  \else\hline\fi\ifnum\numexpr\@fila+1=\pl@romper\space\pagebreak\fi}
\newcommand{\@celdasemana}{%
  \ifnum\pl@ses=1 {\textbf{\pl@textosemana}}\fi
  \ifnum\pl@cps>1 \par{\scriptsize Clase \the\pl@ses}\fi
  \if@fechas\par{\scriptsize\@fechaclase}\fi
  \ifdefempty{\@etqsem}{}{\par{\scriptsize\@etqsem}}}
\newcommand{\pl@textosemana}{\ifnum\pl@cps>1 Semana \fi\the\pl@sem}
\newcommand{\clase}[5][]{%
  \@avanzaclase\global\advance\pl@nclases by 1 \@iniciaentrega{#1}%
  \ifodd\pl@sem \gdef\@cc{\cellcolor{cremafila}}\else\gdef\@cc{\cellcolor{white}}\fi
  \gdef\@etqsem{}%
  \ifstrempty{#1}{}{\ifcsdef{sem@txt@#1}%
    {\gdef\@cc{\cellcolor{sem@#1}}\global\csdef{sem@usado@#1}{}%
     \xdef\@etqsem{\csuse{sem@etq@#1}}}%
    {\PackageWarning{planeacion}{Tipo de clase desconocido: #1}}}%
  \@cc\@celdasemana\@marcafila & \@cc\small #2 & \@cc\small #3 & \@cc\small #4 & \@cc\small #5\@verificaentrega\@finclase}
\newcommand{\festivo}[1]{%
  \multicolumn{5}{|l|}{\cellcolor{grisformato}\@avanzaclase\global\advance\pl@nfest by 1
    \small\textbf{\ifnum\pl@cps>1 Semana \the\pl@sem\ · Clase \the\pl@ses\else Semana \the\pl@sem\fi
    \ — SIN CLASE:} #1\if@fechas\ (\@fechaclase)\fi}\@finclase}
% Convenciones: debajo de la tabla, solo con los tipos que se usaron.
\newif\if@hayconv
\newcommand{\@muestra}[1]{\fcolorbox{black!60}{sem@#1}{\rule{0pt}{0.55em}\rule{1.2em}{0pt}}}
\newcommand{\@convenciones}{%
  \@hayconvfalse
  \renewcommand*{\do}[1]{\ifcsdef{sem@usado@##1}{\global\@hayconvtrue}{}}\dolistloop{\@tipos}%
  \ifnum\pl@totsellos>0 \global\@hayconvtrue\fi\ifnum\pl@totfirmas>0 \global\@hayconvtrue\fi
  \if@hayconv
    \par\vspace{4pt}{\raggedright\footnotesize\textbf{CONVENCIONES:}\enspace
    \renewcommand*{\do}[1]{\ifcsdef{sem@usado@##1}{\mbox{\@muestra{##1}\ \textbf{\csuse{sem@etq@##1}}: \csuse{sem@txt@##1}}\hskip 1.5em plus 1em\relax}{}}%
    \dolistloop{\@tipos}%
    \ifnum\pl@totsellos>0 \mbox{\@iconosello\ \textbf{Sello}: entregable corto de la clase}\hskip 1.5em plus 1em\relax\fi
    \ifnum\pl@totfirmas>0 \mbox{\@iconofirma\ \textbf{Firma}: apuntes de la explicación, firmados}\fi\par}
  \fi}

% ---------- Pie del documento ----------
\newcommand{\@notaextra}{}
\newcommand{\nota}[1]{\renewcommand{\@notaextra}{#1}}
\newcommand{\@textonota}{%
  \textbf{NOTA ACLARATORIA:} \@notamateria\ifdefempty{\@notaextra}{}{\ \@notaextra}}
\newcommand{\@haynota}{\ifboolexpr{test {\ifdefempty{\@notamateria}} and test {\ifdefempty{\@notaextra}}}}
\newcommand{\notaaclaratoria}{%
  \@haynota{}{\par\vspace{6pt}\noindent\begin{minipage}{\linewidth}\small\@textonota\end{minipage}\par}}
% Pie final: convenciones, nota aclaratoria y firmas van como última «fila» de la tabla (sin
% bordes ni color). Así longtable las deja siempre en la misma página que las últimas filas y
% nunca quedan solas en una hoja nueva.
\newcommand{\@piefinal}[1]{%
  \rowcolor{white}\multicolumn{5}{@{}>{\raggedright\arraybackslash}p{\linewidth}@{}}{\normalsize\@marcapie #1}\\}
\newcommand{\@firma}[1]{%
  \begin{minipage}[b]{.47\linewidth}\small\vspace{1.1cm}\hrule\vspace{3pt}#1\end{minipage}}
\newcommand{\@bloquefirmas}{%
  \par\vspace{6pt}\noindent
  \begin{minipage}[b]{.64\linewidth}\small\@haynota{}{\@textonota}\end{minipage}\hfill
  \begin{minipage}[b]{.33\linewidth}
    \@firma{\textbf{DOCENTE:} \@docente}\hfill\@firma{\textbf{\MakeUppercase{\kitcfg@firmainst}}}
  \end{minipage}\par}

% =====================================================================================
% PROGRAMA DEL PERIODO (para estudiantes) — opción [programa]
% Hoja que se entrega al inicio de cada periodo: pregunta, aprendizajes, contenidos, metodología,
% cronograma de clases, evaluación, recursos y firmas de recibido. Carta vertical.
% =====================================================================================
% Paleta del programa, taller y habilitación: se deriva de color_programa y color_programa_2
% (colegio.yaml). Con los valores por defecto da la familia verde original (pino y oliva).
\definecolor{bandaprograma}{HTML}{\kitcfg@colinst}
\definecolor{pino}{HTML}{\kitcfg@colprog}
\definecolor{oliva}{HTML}{\kitcfg@colprogdos}
% Familia verde del programa (las franjas usan pino y oliva): cabeceras de tabla en oliva muy claro.
\colorlet{verdeclaro}{oliva!18!white}
\colorlet{pinotexto}{pino!80!black}
% Mayúsculas con un poco de aire entre letras (títulos de franjas y de tablas).
\newcommand{\espaciado}[1]{{\addfontfeatures{LetterSpace=6}#1}}
% Estilo de las tablas del programa: reglas de 0,5 pt en carbón y cabecera en oliva claro.
\newcommand{\estilotabla}{\setlength{\arrayrulewidth}{0.5pt}\arrayrulecolor{regla}}
\newcommand{\cabecera}{\rowcolor{verdeclaro}}
% Ficha de datos en dos filas (la vertical no da para una sola).
\newcommand{\fichaprograma}{%
  {\rowcolors{1}{}{}\estilotabla\renewcommand{\arraystretch}{1.45}%
  \begin{tabularx}{\linewidth}{|l|X|l|l|l|l|}
    \hline
    \cellcolor{verdeclaro}\color{pinotexto}\textbf{ASIGNATURA} & \@area &
    \cellcolor{verdeclaro}\color{pinotexto}\textbf{GRADO} & \@grado &
    \cellcolor{verdeclaro}\color{pinotexto}\textbf{PERIODO} & \@periodo\\ \hline
    \cellcolor{verdeclaro}\color{pinotexto}\textbf{DOCENTE} & \@docente &
    \cellcolor{verdeclaro}\color{pinotexto}\textbf{AÑO} & \@anio &
    \cellcolor{verdeclaro}\color{pinotexto}\textbf{CLASES} & \the\pl@cps\ por semana\\ \hline
  \end{tabularx}\arrayrulecolor{black}}\par\vspace{8pt}}
% Título de sección: franja verde (número en verde pino oscuro; título sobre degradado de pino a
% oliva, letra blanca). Sin filetes decorativos.
\colorlet{pinooscuro}{pino!60!black}
\newlength{\@anchofranja}
% Forma: bloque del número separado por un corte diagonal, extremo derecho con corte inclinado,
% chaflán leve en las esquinas y bisel sutil (brillo arriba, sombra abajo). Relleno con
% transparencia leve para que la franja no pese tanto en la hoja.
% (needspace: un título de sección nunca queda solo al final de una página)
\newcommand{\seccion}[2]{\par\needspace{5\baselineskip}\vspace{5pt}\noindent
  \setlength{\@anchofranja}{\dimexpr\linewidth-0.8pt\relax}%
  \begin{tikzpicture}[x=1cm,y=1cm,baseline=0pt,line join=round]
    \pgfmathsetmacro{\W}{\@anchofranja/1cm}
    \def\H{0.52}\def\c{0.07}
    % contorno: chaflán abajo a la izquierda y arriba a la izquierda; corte inclinado a la derecha
    \def\contorno{(0,\c) -- (\c,0) -- (\W-0.32,0) -- (\W,\H) -- (\c,\H) -- (0,\H-\c) -- cycle}
    \shade[left color=pino,right color=oliva,fill opacity=0.8] \contorno;
    % bloque del número con corte diagonal
    \fill[pinooscuro,fill opacity=0.88] (0,\c) -- (\c,0) -- (0.58,0) -- (0.74,\H) -- (\c,\H) -- (0,\H-\c) -- cycle;
    % bisel: brillo tenue arriba y sombra tenue abajo
    \draw[white,opacity=0.28,line width=0.7pt] (\c+0.02,\H-0.035) -- (\W-0.05,\H-0.035);
    \draw[black,opacity=0.22,line width=0.7pt] (\c+0.02,0.035) -- (\W-0.34,0.035);
    \draw[pinooscuro,draw opacity=0.55,line width=0.6pt] \contorno;
    \node[text=white,font=\bfseries] at (0.31,\H/2) {#1};
    \node[text=white,font=\bfseries,anchor=west] at (0.92,\H/2) {\espaciado{\MakeUppercase{#2}}};
  \end{tikzpicture}\par\vspace{3pt}}
% ---------- QR a la carpeta de Drive de la planeación ----------
% \carpeta{https://drive.google.com/...} en el preámbulo. Si se deja vacío, sale un recuadro
% «QR pendiente»: el QR se genera cuando se crea la carpeta de Drive de esa planeación.
\RequirePackage{qrcode}
\newcommand{\@urlcarpeta}{}
\newcommand{\carpeta}[1]{\renewcommand{\@urlcarpeta}{#1}}
\newcommand{\qrcarpeta}[1][Lecturas y materiales del periodo]{%
  \begin{minipage}[b]{2.6cm}\centering
    \ifdefempty{\@urlcarpeta}%
      {\tikz\draw[pinooscuro!60,dashed,line width=0.6pt,rounded corners=2pt] (0,0) rectangle (1.7cm,1.7cm)
         node[pos=.5,align=center,font=\scriptsize,text=pinooscuro!70]{QR\\pendiente};}%
      {\qrcode[height=1.7cm]{\@urlcarpeta}}\par\vspace{2pt}
    {\scriptsize #1}
  \end{minipage}}
% Recuadro destacado (pregunta del periodo).
\newcommand{\destacado}[2]{%
  {\rowcolors{1}{}{}\estilotabla%
  \begin{tabularx}{\linewidth}{|>{\columncolor{verdeclaro}\bfseries\small\centering\arraybackslash\leavevmode\color{pinotexto}}m{2.4cm}|>{\RaggedRight\arraybackslash}X|}
    \hline #1 & \rule{0pt}{1.2em}\large\itshape #2\\[2pt] \hline
  \end{tabularx}}\par}
% Lista de aprendizajes con su código.
\newenvironment{aprendizajes}{\begin{list}{}{\setlength{\leftmargin}{2.7em}\setlength{\labelwidth}{2.2em}
  \setlength{\labelsep}{0.5em}\setlength{\itemsep}{1pt}\setlength{\parsep}{0pt}\setlength{\topsep}{2pt}}}{\end{list}}
\newcommand{\aprendizaje}[2]{\item[{\setlength{\fboxsep}{1.5pt}\fcolorbox{pino}{white}{\color{pinotexto}\scriptsize\bfseries #1}}] #2}
% Cronograma de clases: misma lógica de \clasesporsemana, \festivo, \receso y código de colores
% que la parcelación, en cuatro columnas y lenguaje para estudiantes:
%   \begin{cronograma} \sesion[tipo]{tema}{qué haremos}{entrega o evaluación} … \end{cronograma}
\NewEnviron{cronograma}{%
  \par\begingroup\small\estilotabla\rowcolors{1}{white}{cremafila}%
  \renewcommand{\arraystretch}{1.15}%
  \def\@ncol{4}\@anchos{1.65cm}{4}{95}{130}{0}{300}%
  \begin{xltabular}{\linewidth}{|>{\centering\arraybackslash}p{1.65cm}|P{\pl@ca}|P{\pl@cb}|Y|}
    \hline
    \cabecera\@reiniciafechas\@reiniciaclases\leavevmode\color{pinotexto}\textbf{\footnotesize\espaciado{SEMANA}}\ifnum\pl@cps>1\newline{\scriptsize\espaciado{CLASE}}\fi\if@fechas\newline{\scriptsize\espaciado{FECHA}}\fi
      & \centering\leavevmode\color{pinotexto}\textbf{\footnotesize\espaciado{TEMA}} & \centering\leavevmode\color{pinotexto}\textbf{\footnotesize\espaciado{¿QUÉ HAREMOS?}}
      & \centering\arraybackslash\leavevmode\color{pinotexto}\textbf{\footnotesize\espaciado{EVALUACIÓN / ENTREGA}}\\ \hline
    \endhead
    \hline\endfoot\endlastfoot
    \BODY
  \end{xltabular}\arrayrulecolor{black}\endgroup
  \immediate\write\@auxout{\gdef\string\pl@totsellos{\the\pl@nsellos}%
    \gdef\string\pl@totfirmas{\the\pl@nfirmas}}\@revisamodo\@convenciones\par}
\newcommand{\sesion}[4][]{%
  \@avanzaclase\global\advance\pl@nclases by 1 \@iniciaentrega{#1}%
  \ifodd\pl@sem \gdef\@cc{\cellcolor{cremafila}}\else\gdef\@cc{\cellcolor{white}}\fi
  \gdef\@etqsem{}%
  \ifstrempty{#1}{}{\ifcsdef{sem@txt@#1}%
    {\gdef\@cc{\cellcolor{sem@#1}}\global\csdef{sem@usado@#1}{}%
     \xdef\@etqsem{\csuse{sem@etq@#1}}}%
    {\PackageWarning{planeacion}{Tipo de clase desconocido: #1}}}%
  \@cc\@celdasemana & \@cc #2 & \@cc #3 & \@cc #4\@verificaentrega\\
  \ifnum\pl@ses<\pl@cps \arrayrulecolor{reglasuave}\hline\arrayrulecolor{regla}\else\hline\fi}
% Firmas de recibido (estudiante, acudiente y docente) con el QR de la carpeta del periodo a la
% derecha (o el recuadro «QR pendiente» mientras no exista la carpeta).
\newcommand{\recibido}{%
  \par\vspace{4pt}\noindent
  \begin{minipage}[b]{\dimexpr\linewidth-2.9cm\relax}
    {\small\textbf{Recibido y leído.} Firmamos como constancia de que conocemos
    \if@habilitacion este plan de habilitación\else el programa del periodo\fi.}\par\vspace{0.8cm}\noindent
    \begin{tabular}{@{}p{4.2cm}@{\hspace{0.7cm}}p{4.2cm}@{\hspace{0.7cm}}p{4.2cm}@{}}
      \hrule\vspace{3pt}\small Estudiante & \hrule\vspace{3pt}\small Acudiente &
      \hrule\vspace{3pt}\small Docente: \@docente
    \end{tabular}
  \end{minipage}\hfill\qrcarpeta[Materiales del periodo]}
% =====================================================================================
% TALLER y PLAN DE HABILITACIÓN (para estudiantes) — opciones [taller] y [habilitacion]
% Mismo estilo del programa del periodo. Los datos del estudiante se llenan a mano (no se guardan
% datos personales en el repositorio).
% =====================================================================================
\newcommand{\@celdaverde}[1]{\cellcolor{verdeclaro}\leavevmode\color{pinotexto}\textbf{#1}}
% Ficha del taller: \fichataller{número}{semana y clase}{duración}{modalidad}
\newcommand{\fichataller}[4]{%
  {\rowcolors{1}{}{}\estilotabla\renewcommand{\arraystretch}{1.45}%
  \begin{tabularx}{\linewidth}{|l|X|l|l|l|l|}
    \hline
    \@celdaverde{ASIGNATURA} & \@area & \@celdaverde{GRADO} & \@grado & \@celdaverde{PERIODO} & \@periodo\\ \hline
    \@celdaverde{TALLER} & #1 · #2 & \@celdaverde{DURACIÓN} & #3 & \@celdaverde{TRABAJO} & #4\\ \hline
    \@celdaverde{NOMBRE(S)} & \multicolumn{3}{l|}{} & \@celdaverde{FECHA} & \\ \hline
  \end{tabularx}\arrayrulecolor{black}}\par\vspace{8pt}}
% Ficha de la habilitación: el estudiante y las fechas se llenan a mano.
\newcommand{\fichahabilitacion}{%
  {\rowcolors{1}{}{}\estilotabla\renewcommand{\arraystretch}{1.45}%
  \begin{tabularx}{\linewidth}{|l|X|l|l|l|l|}
    \hline
    \@celdaverde{ASIGNATURA} & \@area & \@celdaverde{GRADO} & \@grado & \@celdaverde{PERIODO} & \@periodo\\ \hline
    \@celdaverde{ESTUDIANTE} & \multicolumn{3}{l|}{} & \@celdaverde{AÑO} & \@anio\\ \hline
    \@celdaverde{ENTREGA DEL TRABAJO} & & \@celdaverde{EVALUACIÓN} & \multicolumn{3}{l|}{}\\ \hline
  \end{tabularx}\arrayrulecolor{black}}\par\vspace{8pt}}
% Fuente citada: \fuente{texto}{referencia exacta}
\newcommand{\fuente}[2]{\par\vspace{3pt}\noindent
  {\rowcolors{1}{}{}\estilotabla\renewcommand{\arraystretch}{1.2}%
  \begin{tabularx}{\linewidth}{|>{\RaggedRight\arraybackslash}X|}
    \hline \small\itshape #1\par\vspace{2pt}{\raggedleft\upshape\footnotesize\color{pinotexto}#2\par}\\ \hline
  \end{tabularx}\arrayrulecolor{black}}\par\vspace{4pt}}
% Pasos de la clase con su tiempo: \begin{pasos} \paso{10 min}{texto} … \end{pasos}
\newcounter{pl@paso}
\newenvironment{pasos}{\setcounter{pl@paso}{0}\begin{list}{}{\setlength{\leftmargin}{4.1em}
  \setlength{\labelwidth}{3.6em}\setlength{\labelsep}{0.5em}\setlength{\itemsep}{2pt}
  \setlength{\parsep}{0pt}\setlength{\topsep}{2pt}}}{\end{list}}
\newcommand{\paso}[2]{\stepcounter{pl@paso}\item[{\setlength{\fboxsep}{1.5pt}\colorbox{verdeclaro}{\color{pinotexto}\scriptsize\bfseries\,\arabic{pl@paso}\,·\,#1\,}}] #2}
% Líneas para responder a mano: \lineas{n}
\newcommand{\lineas}[1]{\par\vspace{2pt}{\color{black!35}\foreach \pl@i in {1,...,#1}{\noindent\rule{\linewidth}{0.4pt}\par\vspace{0.62cm}}}\vspace{-0.4cm}}
% Rúbrica: \begin{rubrica} \criterio{nombre}{superior}{alto}{básico}{bajo} … \end{rubrica}
\newenvironment{rubrica}{\par\noindent\begingroup\rowcolors{2}{white}{cremafila}\estilotabla
  \renewcommand{\arraystretch}{1.15}\footnotesize
  \tabularx{\linewidth}{|>{\bfseries\RaggedRight\arraybackslash}p{2.7cm}|>{\RaggedRight\arraybackslash}X|>{\RaggedRight\arraybackslash}X|>{\RaggedRight\arraybackslash}X|>{\RaggedRight\arraybackslash}X|}
  \hline\cabecera\leavevmode\color{pinotexto}\textbf{Criterio} & \leavevmode\color{pinotexto}\textbf{Superior} &
  \leavevmode\color{pinotexto}\textbf{Alto} & \leavevmode\color{pinotexto}\textbf{Básico} & \leavevmode\color{pinotexto}\textbf{Bajo}\\ \hline}
  {\endtabularx\arrayrulecolor{black}\endgroup\par}
\newcommand{\criterio}[5]{#1 & #2 & #3 & #4 & #5\\ \hline}
% Casilla para marcar (desempeños a recuperar)
\newcommand{\casilla}{\raisebox{-0.15ex}{\setlength{\fboxsep}{0pt}\setlength{\fboxrule}{0.6pt}\fcolorbox{pino}{white}{\rule{0pt}{1.6ex}\rule{1.6ex}{0pt}}}}
% Tabla de desempeños a recuperar (una sola tabla, como los formatos del colegio):
% \begin{recuperacion}
%   \recuperar{D1}{qué debes demostrar}{actividad}{dónde repasar}
% \end{recuperacion}
\newenvironment{recuperacion}{\par\vspace{3pt}\noindent\begingroup\rowcolors{2}{white}{cremafila}\estilotabla
  \renewcommand{\arraystretch}{1.2}\small\renewcommand{\tabularxcolumn}[1]{m{##1}}%
  \tabularx{\linewidth}{|>{\centering\arraybackslash}m{1.05cm}|>{\RaggedRight\arraybackslash}m{4.6cm}|>{\RaggedRight\arraybackslash}X|}
  \hline\cabecera\leavevmode\color{pinotexto}\footnotesize\bfseries\espaciado{MARCA} &
  \leavevmode\color{pinotexto}\footnotesize\bfseries\espaciado{APRENDIZAJE} &
  \leavevmode\color{pinotexto}\footnotesize\bfseries\espaciado{ACTIVIDAD DE HABILITACIÓN}\\ \hline}
  {\endtabularx\arrayrulecolor{black}\endgroup\par\vspace{2pt}}
\newcommand{\recuperar}[4]{\casilla &
  \textbf{#1.} #2 &
  #3\par\vspace{1pt}{\footnotesize\textit{Repasa:} #4}\\ \hline}
% Recursos de taller (textos, QR, retos, juegos, versión del docente): taller-recursos.sty
\if@programa\RequirePackage{taller-recursos}\fi
\endinput