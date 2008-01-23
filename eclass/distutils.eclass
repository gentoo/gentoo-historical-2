# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/distutils.eclass,v 1.45 2008/01/23 22:19:04 hawking Exp $
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

inherit python multilib eutils

# This helps make it possible to add extensions to python slots.
# Normally only a -py21- ebuild would set PYTHON_SLOT_VERSION.
if [ "${PYTHON_SLOT_VERSION}" = "2.1" ] ; then
	DEPEND="=dev-lang/python-2.1*"
	python="python2.1"
elif [ "${PYTHON_SLOT_VERSION}" = "2.3" ] ; then
	DEPEND="=dev-lang/python-2.3*"
	python="python2.3"
else
	DEPEND="virtual/python"
	python="python"
fi

distutils_src_unpack() {
	unpack ${A}
	cd "${S}"

	# remove ez_setup stuff to prevent packages
	# from installing setuptools on their own
	rm -rf ez_setup*
	echo "def use_setuptools(*args, **kwargs): pass" > ez_setup.py
}

distutils_src_compile() {
	${python} setup.py build "$@" || die "compilation failed"
}

distutils_src_install() {

	# need this for python-2.5 + setuptools in cases where
	# a package uses distutils but does not install anything
	# in site-packages. (eg. dev-java/java-config-2.x)
	# - liquidx (14/08/2006)
	pylibdir="$(${python} -c 'from distutils.sysconfig import get_python_lib; print get_python_lib()')"
	[ -n "${pylibdir}" ] && dodir "${pylibdir}"

	if has_version ">=dev-lang/python-2.3"; then
		${python} setup.py install --root=${D} --no-compile "$@" || die
	else
		${python} setup.py install --root=${D} "$@" || die
	fi

	DDOCS="CHANGELOG KNOWN_BUGS MAINTAINERS PKG-INFO CONTRIBUTORS TODO NEWS"
	DDOCS="${DDOCS} Change* MANIFEST* README* AUTHORS"

	for doc in ${DDOCS}; do
		[ -s "$doc" ] && dodoc $doc
	done

	[ -n "${DOCS}" ] && dodoc ${DOCS}
}

# generic pyc/pyo cleanup script.

distutils_pkg_postrm() {
	PYTHON_MODNAME=${PYTHON_MODNAME:-${PN}}

	if has_version ">=dev-lang/python-2.3"; then
		ebegin "Performing Python Module Cleanup .."
		if [ -n "${PYTHON_MODNAME}" ]; then
			for pymod in ${PYTHON_MODNAME}; do
				for moddir in "`ls -d --color=none -1 ${ROOT}usr/$(get_libdir)/python*/site-packages/${pymod} 2> /dev/null`"; do
					python_mod_cleanup ${moddir}
				done
			done
		else
			python_mod_cleanup
		fi
		eend 0
	fi
}

# this is a generic optimization, you should override it if your package
# installs things in another directory

distutils_pkg_postinst() {
	PYTHON_MODNAME=${PYTHON_MODNAME:-${PN}}

	# strip trailing slash
	myroot="${ROOT%/}"

	if has_version ">=dev-lang/python-2.3"; then
		python_version
		for pymod in ${PYTHON_MODNAME}; do
			if [ -d "${myroot}/usr/$(get_libdir)/python${PYVER}/site-packages/${pymod}" ]; then
				python_mod_optimize ${myroot}/usr/$(get_libdir)/python${PYVER}/site-packages/${pymod}
			fi
		done
	fi
}

# e.g. insinto ${ROOT}/usr/include/python${PYVER}

distutils_python_version() {
	python_version
}

# checks for if tkinter support is compiled into python
distutils_python_tkinter() {
	python_tkinter_exists
}

EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst pkg_postrm
