# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/distutils.eclass,v 1.56 2009/08/01 22:36:20 arfrever Exp $

# @ECLASS: distutils.eclass
# @MAINTAINER:
# <python@gentoo.org>
#
# Original author: Jon Nelson <jnelson@gentoo.org>
# @BLURB: This eclass allows easier installation of distutils-based python modules
# @DESCRIPTION:
# The distutils eclass is designed to allow easier installation of
# distutils-based python modules and their incorporation into
# the Gentoo Linux system.
#
# It inherits python, multilib, and eutils

inherit python multilib eutils

case "${EAPI:-0}" in
	0|1)
		EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst pkg_postrm
		;;
	*)
		EXPORT_FUNCTIONS src_unpack src_prepare src_compile src_install pkg_postinst pkg_postrm
		;;
esac

# @ECLASS-VARIABLE: PYTHON_SLOT_VERSION
# @DESCRIPTION:
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

# @ECLASS-VARIABLE: DOCS
# @DESCRIPTION:
# Additional DOCS

# @FUNCTION: distutils_src_unpack
# @DESCRIPTION:
# The distutils src_unpack function, this function is exported
distutils_src_unpack() {
	unpack ${A}
	cd "${S}"

	has "${EAPI:-0}" 0 1 && distutils_src_prepare
}

# @FUNCTION: distutils_src_prepare
# @DESCRIPTION:
# The distutils src_prepare function, this function is exported
distutils_src_prepare() {
	# remove ez_setup stuff to prevent packages
	# from installing setuptools on their own
	rm -rf ez_setup*
	echo "def use_setuptools(*args, **kwargs): pass" > ez_setup.py
}

# @FUNCTION: distutils_src_compile
# @DESCRIPTION:
# The distutils src_compile function, this function is exported
distutils_src_compile() {
	if ! has "${EAPI:-0}" 0 1 2 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		build_modules() {
			${python} setup.py build -b "build-${PYTHON_ABI}" "$@"
		}
		python_execute_function build_modules "$@"
	else
		${python} setup.py build "$@" || die "compilation failed"
	fi
}

# @FUNCTION: distutils_src_install
# @DESCRIPTION:
# The distutils src_install function, this function is exported.
# It also installs the "standard docs" (CHANGELOG, Change*, KNOWN_BUGS, MAINTAINERS,
# PKG-INFO, CONTRIBUTORS, TODO, NEWS, MANIFEST*, README*, and AUTHORS)
distutils_src_install() {

	# Mark the package to be rebuilt after a python upgrade.
	python_need_rebuild

	if ! has "${EAPI:-0}" 0 1 2 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		install_modules() {
			# need this for python-2.5 + setuptools in cases where
			# a package uses distutils but does not install anything
			# in site-packages. (eg. dev-java/java-config-2.x)
			# - liquidx (14/08/2006)
			pylibdir="$(${python} -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')"
			[[ -n "${pylibdir}" ]] && dodir "${pylibdir}"

			echo ${python} setup.py build -b "build-${PYTHON_ABI}" install --root="${D}" --no-compile "$@"
			${python} setup.py build -b "build-${PYTHON_ABI}" install --root="${D}" --no-compile "$@"
		}
		python_execute_function install_modules "$@"
	else
		# need this for python-2.5 + setuptools in cases where
		# a package uses distutils but does not install anything
		# in site-packages. (eg. dev-java/java-config-2.x)
		# - liquidx (14/08/2006)
		pylibdir="$(${python} -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')"
		[[ -n "${pylibdir}" ]] && dodir "${pylibdir}"

		${python} setup.py install --root="${D}" --no-compile "$@" || die "python setup.py install failed"
	fi

	DDOCS="CHANGELOG KNOWN_BUGS MAINTAINERS PKG-INFO CONTRIBUTORS TODO NEWS"
	DDOCS="${DDOCS} Change* MANIFEST* README* AUTHORS"

	local doc
	for doc in ${DDOCS}; do
		[[ -s "$doc" ]] && dodoc $doc
	done

	[[ -n "${DOCS}" ]] && dodoc ${DOCS}
}

# @FUNCTION: distutils_pkg_postrm
# @DESCRIPTION:
# Generic pyc/pyo cleanup script. This function is exported.
distutils_pkg_postrm() {
	local pylibdir pymod
	if [[ -z "${PYTHON_MODNAME}" ]]; then
		for pylibdir in "${ROOT}"/usr/$(get_libdir)/python*; do
			if [[ -d "${pylibdir}/site-packages/${PN}" ]]; then
				PYTHON_MODNAME="${PN}"
			fi
		done
	fi

	ebegin "Performing cleanup of Python modules..."
	if [[ -n "${PYTHON_MODNAME}" ]]; then
		for pymod in ${PYTHON_MODNAME}; do
			for pylibdir in "${ROOT}"/usr/$(get_libdir)/python*; do
				if [[ -d "${pylibdir}/site-packages/${pymod}" ]]; then
					if ! has "${EAPI:-0}" 0 1 2 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
						python_mod_cleanup "${pymod}"
					else
						python_mod_cleanup "${pylibdir#${ROOT}}/site-packages/${pymod}"
					fi
				fi
			done
		done
	else
		python_mod_cleanup
	fi
	eend 0
}

# @FUNCTION: distutils_pkg_postinst
# @DESCRIPTION:
# This is a generic optimization, you should override it if your package
# installs modules in another directory. This function is exported.
distutils_pkg_postinst() {
	local pylibdir pymod
	if [[ -z "${PYTHON_MODNAME}" ]]; then
		for pylibdir in "${ROOT}"/usr/$(get_libdir)/python*; do
			if [[ -d "${pylibdir}/site-packages/${PN}" ]]; then
				PYTHON_MODNAME="${PN}"
			fi
		done
	fi

	if ! has "${EAPI:-0}" 0 1 2 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		for pymod in ${PYTHON_MODNAME}; do
			python_mod_optimize "${pymod}"
		done
	else
		python_version
		for pymod in ${PYTHON_MODNAME}; do
			python_mod_optimize "/usr/$(get_libdir)/python${PYVER}/site-packages/${pymod}"
		done
	fi
}

# @FUNCTION: distutils_python_version
# @DESCRIPTION:
# Calls python_version, so that you can use something like
#  e.g. insinto ${ROOT}/usr/include/python${PYVER}
distutils_python_version() {
	python_version
}

# @FUNCTION: distutils_python_tkinter
# @DESCRIPTION:
# Checks for if tkinter support is compiled into python
distutils_python_tkinter() {
	python_tkinter_exists
}
