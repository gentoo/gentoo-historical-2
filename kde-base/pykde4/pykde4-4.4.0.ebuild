# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/pykde4/pykde4-4.4.0.ebuild,v 1.1 2010/02/09 00:21:02 alexxy Exp $

EAPI="2"

KMNAME="kdebindings"
KMMODULE="python/pykde4"
OPENGL_REQUIRED="always"
PYTHON_USE_WITH="threads"
SUPPORT_PYTHON_ABIS="1"
inherit python kde4-meta

DESCRIPTION="Python bindings for KDE4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="akonadi debug doc examples semantic-desktop"

# blocker added due to compatibility issues and error during compile time
DEPEND="
	!dev-python/pykde
	$(add_kdebase_dep kdelibs 'opengl,semantic-desktop?')
	akonadi? ( $(add_kdebase_dep kdepimlibs) )
	aqua? ( >=dev-python/PyQt4-4.7[dbus,sql,svg,webkit,aqua] )
	!aqua? ( >=dev-python/PyQt4-4.7[dbus,sql,svg,webkit,X] )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_pkg_setup
	kde4-meta_pkg_setup
}

src_prepare() {
	kde4-meta_src_prepare

	if ! use examples; then
		sed -e '/^ADD_SUBDIRECTORY(examples)/s/^/# DISABLED /' -i python/${PN}/CMakeLists.txt \
			|| die "Failed to disable examples"
	fi

	python_copy_sources
}

src_configure() {
	savedcmakeargs=(
		-DWITH_QScintilla=OFF
		-DWITH_PolkitQt=OFF
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with akonadi KdepimLibs)
	)

	do_src_configure() {
		mycmakeargs=("${savedcmakeargs[@]}")

		CMAKE_USE_DIR="${S}-${PYTHON_ABI}"
		kde4-meta_src_configure

		local value=$(declare -p mycmakeargs)
		value=${value#*=}
		declare -a "savedcmakeargs_${PYTHON_ABI//./_}=$value"
	}

	python_execute_function -s do_src_configure
}

src_compile() {
	do_src_compile() {
		CMAKE_USE_DIR="${S}-${PYTHON_ABI}"
		kde4-meta_src_compile
	}

	python_execute_function -s do_src_compile
}

src_test() {
	do_src_test() {
		local var=savedcmakeargs_${PYTHON_ABI//./_}
		local value=$(declare -p $var)
		value=${value#*=}
		declare -a "mycmakeargs=$value"

		CMAKE_USE_DIR="${S}-${PYTHON_ABI}"
		kde4-meta_src_test
		export ${var}="${mycmakeargs}"
	}

	python_execute_function -s do_src_test
}

src_install() {
	if use doc; then
		dohtml -r "${S}"/python/pykde4/docs/html/* || die 'dohtml failed'
	fi

	do_src_install() {
		CMAKE_USE_DIR="${S}-${PYTHON_ABI}"
		kde4-meta_src_install

		rm -f "${ED}$(python_get_sitedir)"/PyKDE4/*.py[co]
	}

	python_execute_function -s do_src_install
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	python_mod_optimize PyKDE4

	if use examples; then
		echo
		elog "PyKDE4 examples have been installed to"
		elog "${EKDEDIR}/share/apps/${PN}/examples"
		echo
	fi
}

pkg_postrm() {
	kde4-meta_pkg_postrm

	python_mod_cleanup PyKDE4
}
