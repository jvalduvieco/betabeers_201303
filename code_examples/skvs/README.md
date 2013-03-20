# SKVS Server
Simple Key Value Store es un servidor simple implementado en Erlang usando `gen_server`.

El servidor tiene tres métodos:

* `get` para obtener valores mediante una `Key`
* `set` para crear o modificar un registro en el servidor.
* `crash` este método contiene un error irrecuperable que desencadena la muerte del proceso del servidor, obligando al supervisor a actuar.

El sistema se compone de una aplicación, un supervisor y el gen_server que ofrece la funcionalidad especificada anteriormente.
El respositorio de datos está implementado mediante ETS. 

[Documentación sobre ETS](http://www.erlang.org/doc/man/ets.html)

## La aplicación
En este ejemplo se limita a ofrecer una interfaz para iniciar y parar el servidor. En sistemas más complejos puede especificar las dependencias necesarias, indicar versiones, etc..

[Documentación sobre las aplicaciones](http://www.erlang.org/doc/design_principles/applications.html)

## El supervisor
Su misión es asegurarnos que el servicio continua funcionando a pesar de posibles fallos en alguno de sus componentes. En concreto es el responsable de reiniciar todos los procesos que terminen de forma anormal.

[Documentación sobre el supervisor](http://www.erlang.org/doc/man/supervisor.html)

## El skvs_server
Ofrece la funcionalidad del sistema. Está implementado mediante un gen_server. Está dividido en dos partes. 

* Los métodos que se ejecutan en el proceso cliente. Su misión es generar un mensaje que se enviará al proceso servidor.
* Los métodos del servidor. Son los métodos especificados en la behaviour `gen_server` y las callbacks que gestionan los mensajes del cliente.

[Documentación sobre gen_server](http://www.erlang.org/doc/man/gen_server.html)

## Poniéndolo en marcha
Primero debemos situarnos en el directorio raiz del proyecto. Deberemos ver:

    $ ls
    README.md	ebin		rebar		rebar.config	src
Ahora toca compilar:

    ./rebar compile
    
Iniciar el nodo erlang:

    erl -pa ebin

Una vez en la consola de Erlang, iniciar la aplicacón:

    application:start(skvs).

Now you can issue commands:

    skvs_server:set(popo,33).
    skvs_server:get(popo).
    …
    