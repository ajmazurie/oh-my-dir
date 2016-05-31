# oh-my-dir

**oh-my-dir** is a set of configuration files for [direnv](http://direnv.net/) that add high-level functions to create isolated, per-directory virtual environments for various software stacks such as programming languages and package managers.

**oh-my-dir** automatically set up your stack(s) whenever you enter your project directory, taking care of several otherwise time consuming steps:
1. Installation of a stack-specific manager *if not already present*
2. Installation of the requested version of the stack *if not already present*
3. Creation of a named environment *if not already present*
4. Modification of environment variables to use this stack and environment

If you are familiar with tools such as [virtualenv](https://virtualenv.pypa.io/en/stable/), [rbenv](https://github.com/rbenv/rbenv) or [perlbrew](https://perlbrew.pl/) then **oh-my-dir** is a higher-level environment manager. In fact, it probably uses these tools behind the scene.

## Installation

There are only three steps involved in the installation of **oh-my-dir**:

1. Install **direnv** if not done already (various platform-specific [binaries](https://github.com/direnv/direnv/releases) are available)
1. Download and unzip the [latest archive](https://github.com/ajmazurie/oh-my-dir/archive/master.zip) from the **oh-my-dir** repository, or clone it
2. Once in the **oh-my-dir** source folder, run `make install`

> **Note** `make install` will overwrite any existing `~/.direnvrc` file; if you want to manually merge your file with the **oh-my-dir** functions, you can run `make build` instead and copy all or part of the newly created file `dist/direnvrc` in your existing `~/.direnvrc`.

## Quickstart

1. In your project directory, create a `.envrc` file with your favorite editor and add one or more `use stack` instructions, with `stack` being the name of the stack optionally followed by a version number and an environment name (not all stacks support these options; please refer to the table in the last section).
2. Then tell **direnv** to use your file by typing `direnv allow`, and **oh-my-dir** will switch to your stack and environment (or install/create it if needed).

> **Note** a shortcut to the `.envrc` editing/allow cycle is to type `direnv edit .`, which will launch [$EDITOR](https://en.wikibooks.org/wiki/Guide_to_Unix/Environment_Variables#EDITOR) and automatically allow the resulting content.

For example if you want your project to use the version 2.7.10 of the Python interpreter just add `use python 2.7.10` in your `.envrc` file. **oh-my-dir** will check (and install if needed) the presence of a Python-specific manager (here [pyenv](https://github.com/yyuu/pyenv)), this specific version of the Python interpreter, and a named environment in `.env/` (since no name was provided, `default` is used). The relevant environment variables will be set for you to use this environment:

```console
$ cd my_project
$ direnv edit .  # added 'use python 2.7.10'
direnv: loading ~/.direnvrc                                                                         
direnv: loading .envrc
direnv: using python 2.7.10
preparing Python environment 'default'
New python executable in my_project/.env/pyenv-2.7.10-default/bin/python2.7
Also creating executable in my_project/.env/pyenv-2.7.10-default/bin/python
Installing setuptools, pip, wheel...
done.
direnv: export +PYENV_ROOT +PYENV_VERSION +PYENV_VIRTUALENV_DISABLE_PROMPT +VIRTUAL_ENV ~PATH
$ which python
my_project/.env/pyenv-2.7.10-default/bin/python
```

If you want to maintain multiple named environments in your project, just add a name (e.g., `use python 2.7.10 production`). For those stacks that support named environments, the default name is `default`.

> **Note** the various **oh-my-dir** functions will use (and create if needed) a `~/.direnv` folder to store the stack-specific managers, and a `<project>/.env` folder to store the various named environments you created.

## Supported stacks

Stack | Underlying<br>manager | Enforce<br>stack version?<sup>1</sup> | Allow named<br>environments?<sup>2</sup> | Supported<br>platforms
--- | --- | --- | --- | ---
[Julia](http://julialang.org/) | [playground.jl](https://github.com/Rory-Finnegan/Playground.jl) | :heavy_check_mark: | :heavy_check_mark: | Unix, OSX
[Perl](https://www.perl.org/) | [perlbrew](http://perlbrew.pl/) | :heavy_check_mark: | :heavy_check_mark: | Unix, OSX
[Python](https://www.python.org/) | [pyenv](https://github.com/yyuu/pyenv) | :heavy_check_mark: | :heavy_check_mark: | Unix, OSX
[Rust](https://www.rust-lang.org/) | [rsvm](http://sdepold.github.io/rsvm/) | :heavy_check_mark: | :x: | Unix, OSX
[Conda](http://conda.pydata.org/docs/) | | :x: | :heavy_check_mark: | Unix, OSX

<sup>1</sup>: means that the underlying manager can switch to, and install if necessary, a specific version of the stack
<sup>2</sup>: means that the underlying manager can switch to, and created if necessary, a named environment for the current stack and version
