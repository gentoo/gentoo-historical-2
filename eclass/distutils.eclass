# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/distutils.eclass,v 1.17 2003/10/09 15:11:24 liquidx Exp $
#
# Author: Jon Nelson <jnelson@gentoo.org>
# Current Maintainer: Alastair Tse <liquidx@gentoo.org>
#
# The distutils eclass is designed to allow easier installation of
# distutils-based python modules and their incorporation into 
# the Gentoo Linux system.
#
# - Features:
# distutils_src_compile()    - does python setup.py build
# distutils_src_install()    - does python setup.py install and install docs
# distutils_python_version() - sets PYVER/PYVER_MAJOR/PYVER_MINOR
# distutils_python_tkinter() - checks for tkinter support in python
#
# - Variables:
# PYTHON_SLOT_VERSION     - for Zope support
# DOCS                    - additional DOCS

inherit python

ECLASS=distutils
INHERITED="$INHERITED $ECLASS"

# This helps make it possible to add extensions to python slots.
# Normally only a -py21- ebuild would set PYTHON_SLOT_VERSION.
if [ "${PYTHON_SLOT_VERSION}" = 2.1 ] ; then 
	newdepend "=dev-lang/python-2.1*"
	python="python2.1"
else
	newdepend "virtual/python"
	python="python"
fi

distutils_src_compile() {
	${python} setup.py build "$@" || die "compilation failed"
}

distutils_src_install() {
	${python} setup.py install --root=${D} --no-compile "$@" || die
	
	dodoc CHANGELOG COPYRIGHT KNOWN_BUGS MAINTAINERS PKG-INFO
	dodoc CONTRIBUTORS LICENSE COPYING*
	dodoc Change* MANIFEST* README*
	
	[ -n "${DOCS}" ] && dodoc ${DOCS}
	
	# deprecated! please use DOCS instead.
	[ -n "${mydoc}" ] && dodoc ${mydoc}
}

distutils_pkg_postrm() {
	python_mod_cleanup
}

distutils_pkg_postinst() {
	python_mod_optimize
}

# e.g. insinto ${ROOT}/usr/include/python${PYVER}

distutils_python_version() {
	local tmpstr="$(${python} -V 2>&1 )"
	export PYVER_ALL="${tmpstr#Python }"

	export PYVER_MAJOR=$(echo ${PYVER_ALL} | cut -d. -f1)
	export PYVER_MINOR=$(echo ${PYVER_ALL} | cut -d. -f2)
	export PYVER_MICRO=$(echo ${PYVER_ALL} | cut -d. -f3-)
	export PYVER="${PYVER_MAJOR}.${PYVER_MINOR}"
}

# checks for if tkinter support is compiled into python
distutils_python_tkinter() {
	if ! python -c "import Tkinter" >/dev/null 2>&1; then
		eerror "You need to recompile python with Tkinter support."
		eerror "That means: USE='tcltk' emerge python"
		echo
		die "missing tkinter support with installed python"
	fi
}


EXPORT_FUNCTIONS src_compile src_install pkg_postinst pkg_postrm

