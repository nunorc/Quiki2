
# Quiki2

A revamp of the [Quiki](https://github.com/ambs/Quiki) tool.

After installing the module use the `quiki2` command line tool to create
a new wiki:

    $ quiki2 create myquiki

Your new wiki is a [Dancer](http://perldancer.org/) application. You
can run your new wiki using a development server, for example:

    $ cd myquiki
    myquiki$ perl bin/app.pl
    >> Dancer2 v0.163000 server 86514 listening on http://0.0.0.0:3000

Or using [Plack](http://plackperl.org/):

    myquiki$ plackup bin/app.psgi
    HTTP::Server::PSGI: Accepting connections at http://0:5000/

Or deploy it, as any other Dancer application.

