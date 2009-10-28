# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dbus-python/dbus-python-0.83.0-r1.ebuild,v 1.12 2009/10/28 18:27:32 armin76 Exp $

EAPI="2"
PYTHON_DEFINE_DEFAULT_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"

inherit multilib python

DESCRIPTION="Python bindings for the D-Bus messagebus."
HOMEPAGE="http://www.freedesktop.org/wiki/Software/DBusBindings \
http://dbus.freedesktop.org/doc/dbus-python/"
SRC_URI="http://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="doc examples test"

RDEPEND=">=dev-lang/python-2.4.4-r5
	>=dev-python/pyrex-0.9.3-r2
	>=dev-libs/dbus-glib-0.71
	>=sys-apps/dbus-1.1.1"
DEPEND="${RDEPEND}
	doc? ( =dev-python/epydoc-3* )
	test? ( dev-python/pygobject )
	dev-util/pkgconfig"
RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	# Disable compiling of .pyc files.
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile

	python_src_prepare
}

src_configure() {
	configuration() {
		econf \
			--docdir=/usr/share/doc/dbus-python-${PV} \
			$(use_enable doc api-docs)
	}
	python_execute_function -s configuration
}

src_install() {
	python_need_rebuild

	python_src_install

	if use doc; then
		# Install documentation only once.
		documentation_installed="0"
		install_documentation() {
			[[ "${documentation_installed}" == "1" ]] && return
			dohtml api/* || return 1
			documentation_installed="1"
		}
		python_execute_function -q -s install_documentation
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r examples || die
	fi
}

pkg_postinst() {
	python_mod_optimize dbus
}

pkg_postrm() {
	python_mod_cleanup
}
