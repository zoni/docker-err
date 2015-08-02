errbot/err
==========

Docker images for [Err](http://errbot.net), a chat-bot designed to be easily deployable, extensible and maintainable.


Available tags
--------------

* ___python3pypi:___ A Ubuntu 15.04 image with Python 3 and the latest stable release of Err from [PyPI](https://pypi.python.org/pypi/err/).
* ___python3master:___ A Ubuntu 15.04 image with Python 3 and the latest development snapshot of Err from [GitHub](https://github.com/gbin/err) (master).
* ___python2pypi:___ A Ubuntu 15.04 image with Python 2 and the latest stable release of Err from [PyPI](https://pypi.python.org/pypi/err/).
* ___python2master:___ A Ubuntu 15.04 image with Python 2 and the latest development snapshot of Err from [GitHub](https://github.com/gbin/err) (master).


Usage
-----

This container can be started in three different modes:

* ___shell:___ Start a bash session as the bot account (*err*).
* ___rootshell:___ Start a bash session as the root account.
* ___err:___ Start the bot itself. Any additional arguments passed here will be passed on to `err.py`.

For example, try: `docker run --rm -it errbot/err:python3pypi err --help`

To successfully run the bot, you will have to mount a [config.py](http://errbot.net/_downloads/config-template.py) into the `/err/` directory (`--volume` option to docker run).

Inside the container, `/err/data/` has already been set aside for data storage. You should mount this directory as a data volume as well in order to de-couple your bot data from the container itself.


Installing dependencies
-----------------------

Some plugins require additional dependencies that may not be installed in the virtualenv by default. There are three ways to deal with this, listed from best practice to worst:

1. Build your own image. Write a `Dockerfile` with `FROM errbot/err:python3pypi` (or one of the other available tags in place of *python3pypi*) and install dependencies as part of the container build process with `RUN runas err /err/virtualenv/bin/pip install somepkg`.
2. Let Err install dependencies automatically by setting `AUTOINSTALL_DEPS = True` in `setting.py`.
3. Enter a running container manually (`docker exec --interactive --tty <container-name> /bin/sh -c "TERM=$TERM exec /bin/bash --login"` where `<container-name>` is the name listed by `docker ps`) and install with pip as in step 2 above (`runas err /err/virtualenv/bin/pip install somepkg`).


Container layout
----------------

* `/err`: Home directory of the user account for Err. `config.py` is expected to go here.
* `/err/.ssh/`: The `.ssh` directory of the bot user (you can mount private SSH keys into this directory if you need to install plugins from private repositories).
* `/err/virtualenv/`: The virtualenv containing the Python interpreter and installed packages.
* `/err/data/`: A volume intended to store bot data (`BOT_DATA_DIR` setting of `config.py`).
