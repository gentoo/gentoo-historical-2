# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/python.eclass,v 1.2 2003/10/09 08:41:40 liquidx Exp $
#
# Author: Alastair Tse <liquidx@gentoo.org>
#
# A Utility Eclass that should be inherited by anything that deals with
# Python or Python modules.
#
# - Features:
# python_version()        - sets PYVER/PYVER_MAJOR/PYVER_MINOR
# python_tkinter_exists() - Checks for tkinter support in python
# python_mod_exists()     - Checks if a python module exists
# python_mod_compile()    - Compiles a .py file to a .pyc/.pyo
# python_mod_optimize()   - Generates .pyc/.pyo precompiled scripts
# python_mod_cleanup()    - Goes through /usr/lib/python* to remove
#                           orphaned *.pyc *.pyo
# python_makesym()        - Makes /usr/bin/python symlinks

inherit alternatives

ECLASS="python"
INHERITED="$INHERITED $ECLASS"

python_disable_pyc() {
	PYTHON_DONTCOMPILE=1
}

#
# name:   python_version
# desc:   run without arguments and it will export the version of python
#         currently in use as $PYVER
#
python_version() {
	local tmpstr
	python=${python:-/usr/bin/python}
	tmpstr="$(${python} -V 2>&1 )"
	export PYVER_ALL="${tmpstr#Python }"

	export PYVER_MAJOR=$(echo ${PYVER_ALL} | cut -d. -f1)
	export PYVER_MINOR=$(echo ${PYVER_ALL} | cut -d. -f2)
	export PYVER_MICRO=$(echo ${PYVER_ALL} | cut -d. -f3-)
	export PYVER="${PYVER_MAJOR}.${PYVER_MINOR}"
}

#
# name:   python_makesym
# desc:   run without arguments, it will create the /usr/bin/python symlinks
#         to the latest installed version
#
python_makesym() {
	alternatives_auto_makesym "/usr/bin/python" "/usr/bin/python[0-9].[0-9]"
	alternatives_auto_makesym "/usr/bin/python2" "/usr/bin/python[0-9].[0-9]"
}

#
# name:   python_tkinter_exists
# desc:   run without arguments, it will return TRUE(0) if python is compiled
#         with tkinter or FALSE(1) if python is compiled without tkinter.
#
python_tkinter_exists() {
	if ! python -c "import Tkinter" >/dev/null 2>&1; then
		eerror "You need to recompile python with Tkinter support."
		eerror "That means: USE='tcltk' emerge python"
		echo
		die "missing tkinter support with installed python"
	fi
}

#
# name:   python_mod_exists
# desc:   run with the module name as an argument. it will check if a 
#         python module is installed and loadable. it will return
#         TRUE(0) if the module exists, and FALSE(1) if the module does
#         not exist.
# exam:   
#         if python_mod_exists gtk; then
#             echo "gtk support enabled
#         fi
#
python_mod_exists() {
	if ! python -c "import $1" >/dev/null 2>&1; then
		return 1
	fi
	return 0
}

#
# name:   python_mod_compile
# desc:   given a filename, it will pre-compile the module's .pyc and .pyo.
#         should only be run in pkg_postinst()
# exam:
#         python_mod_compile ${ROOT}usr/lib/python2.3/site-packages/pygoogle.py
#
python_mod_compile() {
	if [ -f "$1" ]; then
		python -c "import py_compile; py_compile.compile('${1}')" || \
			ewarn "Failed to compile ${1}"
		python -O -c "import py_compile; py_compile.compile('${1}')" || \
			ewarn "Failed to compile ${1}"			
	else
		ewarn "Unable to find ${1}"
	fi		
}

#
# name:   python_mod_optimize
# desc:   if no arguments supplied, it will recompile all modules under
#         sys.path (eg. /usr/lib/python2.3, /usr/lib/python2.3/site-packages/ ..)
#         no recursively
# 
#         if supplied with arguments, it will recompile all modules recursively
#         in the supplied directory
# exam:
#         python_mod_optimize ${ROOT}usr/share/codegen
#
python_mod_optimize() {
	einfo "Byte Compiling Python modules .."
	python_version
	echo ${PYVER}
	python ${ROOT}usr/lib/python${PYVER}/compileall.py $@
}

#
# name:   python_mod_cleanup
# desc:   run with optional arguments, where arguments are directories of
#         python modules. if none given, it will look in /usr/lib/python[0-9].[0-9]
#         
#         it will recursively scan all compiled python modules in the directories
#         and determine if they are orphaned (eg. their corresponding .py is missing.)
#         if they are, then it will remove their corresponding .pyc and .pyo
#
python_mod_cleanup() {
	local SEARCH_PATH

	for path in $@; do
		SEARCH_PATH="${SEARCH_PATH} ${ROOT}${dir}"
	done		

	for path in ${ROOT}usr/lib/python*/site-packages; do
		SEARCH_PATH="${SEARCH_PATH} ${path}"
	done
	
	for path in ${SEARCH_PATH}; do
		einfo "Searching ${path} .."
		for obj in $(find ${path} -name *.pyc); do
			src_py="$(echo $obj | sed 's:c$::')"
			if [ ! -f "${src_py}" ]; then
				einfo "Purging ${src_py}[co]"
				rm -f ${src_py}[co]
			fi
		done
	done		
}


