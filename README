
#Korora Package (KP)
A Korora package can be considered a high level package that often (but not
always) manages all Korora specific modifications to upstream packages. Some
packages are entirely new projects which Korora has baked itself but they are
treated much the same.

The Korora packages are stored completely within git and are best managed with
the Korora packaging utility called “kp”. The kp utility allows you to reproduce
the entire Korora ecosystem, as well as contribute easier to the project through
submission of patches and pull requests.

In order to allow for the various use cases involved in the endeavour, the tool
uses a number of options and flags that are controlled via a global config file,
with the option to override these flags using local package options. This gives
us the freedom as well as flexibility to set up and use the kp tool, to build
korora from scratch.

To begin with, here's an annotated global config file (usually stored in the
same dir as the kp tool) to specify the options needed by git and kp.
```bash
##### BEGIN -----------8< ---- kp.conf --- >8----------   ##########
# A heavily annotated kp.conf file for illustration purposes Name as 'kp.conf'
# and store this file in the same dir as "kp" tool.  Who to build packages as
# (defaults to anonymous).  Substitute with username to use developer account

KP_DEV_ACCOUNT=""  # if using for first time, leave blank
KP_DEV_EMAIL=""    #   ======"======DITTO======"========

# Protocol for git (can be 'git' or 'https' or 'ssh')
GIT_PROTOCOL="http" # again, first timers, use this
# https or ssh can be used, if you aready have GH experience
# but first time user doing anonymous fetches is better off with http

# URLs for git
GIT_URL_GIT="git://github.com/kororaproject"
GIT_URL_HTTP="https://github.com/kororaproject"
GIT_URL_SSH="git@github.com:kororaproject"

# location of git repo holding packages
GIT_URL=git://github.com/kororaproject
GIT_URL_DEV=git@github.com:kororaproject

# Temporary location for building packages
TMP_DIR=/var/lib/kp

# Enable debug
#DEBUG=1

# N.B: Keep the dir containing the kp tool separate from the dir containing all
# the korora packages. See above. Both dirs are actually different locations
# within the "korora" dir tree.
#  /home/jackychan
#     |--- projects
#           |--- kpchan #<== here be all fedora/korora packages
#           |--- kp.git #<== and the "kp" tool, cloned from git
# keep reading below to get the idea behind the above dir structure

## working dirs
_CODE="/home/jackychan/projects/kpchan"
WORKING_DIR="${_CODE}/kp"
# ^^ these dirs contain all packages needed for building korora
#CONFIG_DIR="${_CODE}/kp/conf/"

# dir below refers to a dir containing kp tool checked out from repos
LIB_DIR="${_CODE}/kp.git/lib/"
LOG_DIR=/tmp

# Set the key to use for a release version, e.g. 18 and 19
KEY_ID[18]=30B55DCA
KEY_ID[19]=DCBE2AC3

### -----8<-------  EOF   kp.conf ------>8--------- EOF  ##########
```
As a first step, copy the contents above into the kp.conf file that is present
in the kp tool dir. Keep a copy of the original, if you wish. Initially get
comfortable with the tool by typing

    ./kp --help,   followed by
    ./kp [command] --help

respectively, where `[command]` is the list of available options that the tool can
handle for building korora packages.

The next step is to do some tool "housekeeping". This sets up the dir structure
and other config files needed for the tool to pull the upstream repos for the
korora build. To do this type
```
    ./kp  init  {or} ./kp --init
```
and you are ready to do business...


Now, get a feel for the various packages needed for kororification of your
system by typing
```
    ./kp  list  {or}  ./kp --list
```
lists all the packages/kickstarts that are relevant for the process.  Initially
the packages will come with a '-' next to them. This means, the package in
question is available, but not checked out.  As you start working with packages,
the '-' will be replaced by other symbols. The help command will provide you
with details on the various symbols and their meanings. (Hint: `./kp list --help`)

Once you can see the list of korora packages, you can issue a bulk checkout
which will pull all the upstream repos to your local machine. For example, in
the above example (from kp. conf above), when you issue a checkout, the
individual packages checked out from the repositories will reside in the
following directory:
   `/home/jackychan/projects/kpchan/packages/`

To checkout all or a specific [package], issue
```
    ./kp checkout [package]   {or} ./kp --checkout [package]
```
Examples:

    ./kp checkout handbrake # pulls handbrake tool from repos
    ./kp checkout jockey # drivers support from ubuntu's stable
    ./kp checkout  # get the full kaboodle

Note that the build operation fetches information from online repositories and
therefore requires a working internet connection.  If all this went smoothly,
congratulations. The only thing left is to build korora on your machine.The next
few steps show you how.

The first thing you do is to turn off selinux to "permissive" mode,
from its default mode of "enforcing". A discussion on this is beyond
the scope of this document; however you are referred to many
excellent resources available on the internet. For example:
```
http://wiki.centos.org/HowTos/SELinux
http://en.wikipedia.org/wiki/Security-Enhanced_Linux
  ```

On the terminal, type
```
    getenforce        # You *should* get "Enforcing" as response
    sudo setenforce 0 #  set mode to permissive
    ./kp build [package]  {or}  ./kp --build [package]
    # like checkout, omitting a package builds everything, and
    # specifying a package name builds only that package
    sudo setenforce 1 #  set mode to enforcing again
    ```

Copy any errors that you may encounter, as it will assist in troubleshooting
issues.

If you are satisfied with all the actions so far, and wish to deploy a korora
ISO of your own, type this (as sudo) in your terminal.

    sudo ./kp release [gnome/kde] # self-explanatory

Now to briefly look at local(ised) configuration files that provide
package-level granularity in controlling the kp tool. As always, here's an
annotated file for the jockey proprietary driver support tool, shown below:
```
---8<--- jockey.conf --->8---

KP_NAME=jockey
KP_VERSION=0.9.1

# indicate what the upstream source is wrapped in, and where to get it
KP_UPSTREAM_SRC_TYPE=git,svn,rpm,tarball
KP_UPSTREAM_SRC_URL=

# GIT specific - what branch/commit should all package builds be built relative
# to
KP_UPSTREAM_SRC_GIT_COMMIT=
KP_UPSTREAM_SRC_GIT_BRANCH=

# SVN specific - what revision number should all package builds be built
# relative to
KP_UPSTREAM_SRC_SVN_REVISION


# RPM specific - what’s the reference upstream spec
KP_UPSTREAM_SPEC=%upstream%/spec


# if undefined uses upstream spec (if defined) otherwise errors if missing
KP_BUILD_SPEC=

# the build spec will be dynamically built via the build spec template. Patch,
# source and build numbers will be dynamically updated based on the template.
KP_BUILD_SPEC_TEMPLATE=
KP_BUILD_ARCH=i686,x86_64

# defines the commit of the latest stable release from the korora package tree
KP_RELEASE_GIT_COMMIT=


---8<--- end jockey.conf --->8---
```
**File Tree**
```
./upstream
```
Contains the primary source relating to the package, could be a GIT, SVN url or
the extracted source from an RPM (ie akin to extracted files from
rpmbuild/SOURCES)
```
./build
```
Contains the necessary files to build the release RPM. If the upstream is GIT it
will contain the necessary patches (based on appropriate git diff). SVN would be
similar. The package spec file would be dynamically updated based on the
```
./release
```
Contains built RPMs
