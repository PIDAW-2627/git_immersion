# Git Immersion Labs

Estos son los labs de la formación Git Immersion, una serie de
ejercicios para hacer a tu ritmo que te enseñan lo básico para usar git.

Esta es una traducción al español del
[proyecto original](https://github.com/edgecase/git_immersion). Se ha
traducido la prosa de los labs y las plantillas. Los comandos, el
código, las salidas de git y los mensajes de commit se mantienen en
inglés, porque la generación de los labs los ejecuta y hace referencia a
ellos.

## Online

Puedes consultar los labs originales (en inglés) en
[https://gitimmersion.com](https://gitimmersion.com).

## Generar los labs

Los labs se generan a partir de un único fichero fuente que describe
cada uno de ellos. La generación se hace en dos pasos.

Antes de ejecutar los labs, asegúrate de tener el siguiente alias en
tu fichero .gitconfig. El comando `hist` se usa mucho a lo largo del
tutorial.

    [alias]
      hist = log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short

Primero, el comando `rake run` recorre todos los labs, ejecuta los
comandos indicados y captura su salida. El directorio `auto` se usa
para la ejecución automática y la salida se guarda en el directorio
`samples`.

Segundo, el comando `rake labs` genera los labs en HTML a partir del
texto del fichero `src/labs.txt` y de la salida real capturada en el
directorio `samples`. Las plantillas del índice principal, de las
páginas de los labs y de los divs de navegación están en el directorio
`templates`.

El HTML generado se guarda en `git_tutorial/html`. Abre el fichero
`git_tutorial/html/index.html` en el navegador para ver el tutorial.

## Publicar los labs

Para publicar los labs en la web, ejecuta el comando `rake publish`.
Este comando copia el directorio `git_tutorial/html` a la rama
`gh-pages`. Después se hace push de la rama `gh-pages`, y GitHub la
publica automáticamente.

Modificar a mano los ficheros de la rama `gh-pages` casi nunca es buena
idea. Modifica la plantilla o el fichero css que corresponda en la rama
main y después ejecuta `rake publish`.

## Directivas de formato de los labs

El fichero `labs.txt` contiene todo el texto de los labs. Es un fichero
de texto con directivas adicionales que se interpretan tanto en la fase
de ejecución (al generar las salidas de ejemplo) como en la de formato
(al generar el HTML).

Las directivas de formato son:

### h1. _\<nombre del lab\>_

Empieza un nuevo lab con el nombre _\<nombre del lab\>_.

Ejemplo:

    h1. Using Revert

### pre(_\<nombre de clase\>_).

Una sección de código predefinido que usa la clase HTML _\<nombre de
clase\>_. El bloque de código predefinido llega hasta la siguiente línea
en blanco.

Ejemplo:

    pre(instructions).
    git log --pretty=oneline --max-count=2
    git log --pretty=oneline --since='5 minutes ago'
    git log --pretty=oneline --until='5 minutes ago'

La clase *instructions* da a los comandos el mismo formato que la
sección Execute, pero no los ejecuta en la fase de ejecución.

### p. _\<texto...\>_

Un párrafo de texto. El texto del párrafo continúa en las líneas
siguientes hasta encontrar una línea en blanco.

Ejemplo:

    p. If you have never used git before, you need to do some setup
    first.  Run the following commands so that git knows your name and
    email.  If you have git already setup, you can skip down to the
    line ending section.

### Execute:

Ejecuta los comandos de shell siguientes hasta encontrar una línea en
blanco. Los comandos se ejecutan tal como aparecen, con estas
excepciones:

* +_\<línea de comando\>_

  Ejecuta esta _\<línea de comando\>_ en silencio, sin incluirla en el
  lab.

* -_\<línea de comando\>_

  No ejecuta esta _\<línea de comando\>_, pero la incluye en el lab.

* =*\<nombre_de_muestra\>*

  Guarda la salida del comando anterior como una muestra con ese nombre.

Por ejemplo, lo siguiente ejecuta el comando `git status` y guarda su
salida en la muestra `status` del lab. El primer `git commit` se ignora
en la fase de ejecución (pero aparece en el lab). El segundo `git
commit`, con mensaje, sí se ejecuta (pero no aparece en el lab). Aun
así, la salida del segundo comando se guarda en una muestra.

    Execute:
    git status
    =status
    -git commit
    +git commit -m 'Using ARGV'
    =commit

### File: _\<nombre de fichero\>_

Da formato a las líneas siguientes (hasta encontrar la cadena "EOF")
como el contenido de un fichero llamado _\<nombre de fichero\>_.

Ejemplo:

    File: hello.rb
    # This is the hello world program in Ruby.

    puts "Hello, World!"
    EOF

### Output:

Da formato a las líneas siguientes (hasta encontrar la cadena "EOF")
como la salida de los comandos.

Las líneas de Output que empiezan por = sirven para incluir las
muestras generadas durante la fase de ejecución.

Ejemplo:

    Output:
    git commit
    Waiting for Emacs...
    [main 569aa96] Using ARGV
     1 files changed, 1 insertions(+), 1 deletions(-)
    EOF

A menudo se incluyen líneas de muestra en la salida. Si has capturado
la salida de un comando status y de un comando commit, podrías usar lo
siguiente:

    Output:
    =status
    =commit
    EOF

### Set: _\<clave\>_=_\<expresión ruby\>_

Evalúa la _\<expresión ruby\>_ y asigna ese valor a la _\<clave\>_. Se
suele usar para obtener datos dinámicos de la fase de ejecución y
usarlos en comandos posteriores.

Por ejemplo, lo siguiente obtiene el hash de git del commit con el
mensaje "First Commit" y lo guarda en _\<hash\>_. Cuando se ejecuta el
comando `git checkout`, usa el valor de _\<hash\>_.

    Set: hash=hash_for("First Commit")
    Execute:
    git checkout <hash>

### =_\<nombre de muestra\>_

Define o usa una salida de muestra.

Las salidas de muestra se generan durante la fase de ejecución de la
generación de los labs de Git Immersion. Cada una es la salida de una
única línea de comando de la sección Execute de un lab.

Ejemplo:

    Execute:
    git checkout main
    =checkout
    git status
    =status

Las dos líneas de muestra anteriores capturan la salida de los comandos
checkout y status de git, respectivamente. La salida se guarda (en el
directorio `samples`) hasta que se ejecuta la fase de generación del
HTML.

Durante la generación del HTML, las muestras se pueden "reproducir"
incluyéndolas en la sección Output de un lab.

Ejemplo:

    Output:
    =checkout
    =status
    EOF

Los nombres de las muestras deben ser únicos dentro de un mismo lab,
pero no hace falta que lo sean en todo el proyecto.

# Licencia

![CC by-nc-sa](http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png)

GitImmersion se publica bajo una licencia
[Creative Commons Reconocimiento-NoComercial-CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/).
Esta traducción es una obra derivada y se distribuye bajo la misma
licencia.
