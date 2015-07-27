Getting started
===============

A working installation of Julia (version 0.2 or greater) is required, which can be downloaded from [here](http://julialang.org/downloads/).

As *NumPy* and *SciPy* from Python are also dependencies, a working Python installation along with these libraries are required. If these are not yet available, the easiest way to get them is to install the Anaconda software, which can be downloaded [here](http://www.continuum.io/downloads), or they can be installed manually otherwise.

To start the Julia REPL, run the `julia` binary from a console:

```
$ julia
	       _
   _       _ _(_)_     |  A fresh approach to technical computing
  (_)     | (_) (_)    |  Documentation: http://docs.julialang.org
   _ _   _| |_  __ _   |  Type "help()" to list help topics
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 0.2.0-2643.rbab3d1e3d
 _/ |\__'_|_|_|\__'_|  |  Commit bab3d1e3d 2013-07-15 23:12:09
|__/                   |  x86_64-unknown-linux-gnu

julia>
```

To get the latest list of Julia packages, run the `Pkg.update()` command:

```
julia> Pkg.update()
```

As the toolbox is still in development, this package and its dependencies will need to be retrieved manually from this repository. To do so, change directory to the Julia package directory at the command line. This will be located at `~/.julia/<version>` for Linux and OS X, or `%APPDATA%/julia/packages` for Windows by default.

From the package directory, issue the following command:

```
$ git clone https://github.com/taheris/BRML.jl.git
```

From the Julia REPL, issue another `Pkg.update()` command from to retrieve the toolbox dependencies.  After this, issue the following command to import the package:

```
julia> using BRML
```

Following that command, the BRML package has now been imported into the current Julia environment and is ready to use. In future Julia sessions, only this command needs to be issued to make the BRML toolbox available.
