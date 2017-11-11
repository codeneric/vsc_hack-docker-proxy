# Readme

This is simple bash proxy which pipes the requests of the 
[VSCode Hack extension](https://marketplace.visualstudio.com/items?itemName=pranayagarwal.vscode-hack) 
to a Hack client (`hh_client`) running inside a docker container. 
You'll want to configure your IDE settings in such a way that it points to this file instead of the `hh_client` binary on the host.

We are ignoring the `--format` command, since it breaks the code in the used Hack version. 
