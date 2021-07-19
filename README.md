# Swift TCP Socket

*© Israel Pereira Tavares da Silva*

> The new Network.framework API gives you direct access to the same high-performance user-space networking stack used by URLSession. If you're considering using Berkeley Sockets in your app or library, learn what better options are available to you.

* [Introducing Network.framework: A modern alternative to Sockets](https://developer.apple.com/videos/play/wwdc2018/715/)
* [Network](https://developer.apple.com/documentation/network)

`client.swift` is a program that is able to connect, send to and receive messages from a server socket. This program runs a server socket found in [C TCP Socket](https://github.com/israelptdasilva/C-TCP-Socket). However, a swift version of the server socket will be created in the near future.

To run the program, clone the project first.

```bash
$ git clone git@github.com:israelptdasilva/Swift-TCP-Socket.git
```
Start the program and pass the required arguments - hostname, port, min buffer and max buffer.

```bash
$ swift client.c ::1 4390 1 1024
```
> Eram pardos, todos nus, sem coisa alguma que lhes cobrisse suas vergonhas. Nas mãos traziam arcos com suas setas. Vinham todos rijos sobre o batel; e Nicolau Coelho lhes fez sinal que pousassem os arcos. E eles os pousaram. [A carta de Pero Vaz de Caminha](http://objdigital.bn.br/Acervo_Digital/livros_eletronicos/carta.pdf)
