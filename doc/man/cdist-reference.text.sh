#!/bin/sh
#
# 2010-2011 Nico Schottelius (nico-cdist at schottelius.org)
#
# This file is part of cdist.
#
# cdist is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# cdist is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with cdist. If not, see <http://www.gnu.org/licenses/>.
#
#
# Generate manpage that lists available types
#

__cdist_pwd="$(pwd -P)"
__cdist_mydir="${0%/*}";
__cdist_abs_mydir="$(cd "$__cdist_mydir" && pwd -P)"
__cdist_myname=${0##*/};
__cdist_abs_myname="$__cdist_abs_mydir/$__cdist_myname"

filename="${__cdist_myname%.sh}"
dest="$__cdist_abs_mydir/$filename"

cd "$__cdist_abs_mydir"

exec > "$dest"
cat << eof 
cdist-reference(7)
==================
Nico Schottelius <nico-cdist--@--schottelius.org>

NAME
----
cdist-reference - Variable, path and type reference for cdist $(git describe)


DESCRIPTION
-----------
Various scripts which are not in the core need information on how
to find information. This manpage summarises the available environment
variables, types and paths and clearifies with part may access which variables.


PATHS
-----
If not specified otherwise, all paths are relative to the checkout directory.

conf/::
   Contains the (static) configuration like manifests, types and explorers.  

conf/manifest/init::
   This is the central entry point used by cdist-manifest-init(1).
   It is an executable (+x bit set) shell script that can use
   values from the explorers to decide which configuration to create
   for the specified target host.

   It should be primary used to define mapping from configurations to hosts.

conf/manifest/*::
   All other files in this directory are not directly used by cdist, but you
   can seperate configuration mappings, if you have a lot of code in the
   manifest/init file. This may also be very helpful to have different admins
   maintain different groups of hosts.

conf/explorer/<name>::
   Contains explorers to be run on the target hosts, see cdist-explorer(7).

conf/type/::
   Contains all available types, which are used to provide
   some kind of functionality. See cdist-type(7).

conf/type/<name>/::
   Home of the type <name>.

   This directory is referenced by the variable __type (see below).

conf/type/<name>/manifest::
   Used to generate additional objects from a type.

conf/type/<name>/gencode::
   Used to generate code to be executed on the client.

conf/type/<name>/parameters/required::
   Parameters required by type, \n seperated list.

conf/type/<name>/parameters/optional::
   Parameters optionally accepted by type, \n seperated list.

conf/type/<name>/explorer::
   Location of the type specific explorers.

   This directory is referenced by the variable __type_explorer (see below).

   See cdist-explorer(7).

out/::
   This directory contains output of cdist and is usually located
   in a temporary directory and thus will be removed after the run.

   This directory is referenced by the variable __global (see below).

out/explorer::
   Output of general explorers.

out/object::
   Objects created for the host.

out/object/<object>::
   Contains all object specific information.

   This directory is referenced by the variable __object (see below).

out/object/<object>/explorers::
   Output of type specific explorers, per object.

tmp_dir::
   A tempdir and a tempfile is used by cdist internally,
   which will be removed when the scripts end automatically.
   See cdist-config(1).

TYPES
-----
The following types are available:

eof
for type in cdist-type__*.text; do
   name_1="${type#cdist-type}"
   name_2="${name_1%.text}"

   name="$name_2"
   echo "- $name"
done

cat << eof


VARIABLES
---------
__explorer::
   Directory that contains all explorers.
   Available for: explorer
__manifest::
   Directory that contains the initial manifest.
   Available for: initial manifest
__global::
   Directory that contains generic output like explorer.
   Available for: initial manifest, type manifest, type explorer, type codegen
__object::
   Directory that contains the current object.
   Available for: type manifest, type explorer, type codegen
__object_id::
   The type unique object id.
   Available for: type manifest, type explorer, type codegen
__target_host::
   The host we are deploying to.
   Available for: initial manifest, type manifest, type codegen
__type::
   Path to the current type.
   Available for: type manifest
__type_explorers::
   Directory that contains the type explorers.
   Available for: type explorer


SEE ALSO
--------
- cdist(7)
eof
for type in cdist-type__*.text; do
   name_2="${type%.text}"

   name="$name_2"
   echo "- ${name}(7)"
done

cat <<eof

COPYING
-------
Copyright \(C) 2011 Nico Schottelius. Free use of this software is
granted under the terms of the GNU General Public License version 3 (GPLv3).
eof
