# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dbus-python/dbus-python-0.83.2.ebuild,v 1.1 2010/12/24 13:10:39 ssuominen Exp $

EAPI="3"
PYTHON_DEPEND="2"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
SUPPORT_PYTHON_ABIS="1"

inherit eutils multilib python

DESCRIPTION="Python bindings for the D-Bus messagebus."
HOMEPAGE="http://www.freedesktop.org/wiki/Software/DBusBindings \
http://dbus.freedesktop.org/doc/dbus-python/"
SRC_URI="http://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	>=dev-libs/dbus-glib-0.88
	>=sys-apps/dbus-1.4.1"
DEPEND="${RDEPEND}
	doc? ( =dev-python/epydoc-3* )
	test? ( dev-python/pygobject )
	dev-util/pkgconfig"
RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	# Disable compiling of .pyc files.
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	# Workaround testsuite issues
	epatch "${FILESDIR}/${PN}-0.83.1-workaround-broken-test.patch"

	python_src_prepare
}

src_configure() {
	configuration() {
		econf \
			--docdir="${EPREFIX}/usr/share/doc/${PF}" \
			$(use_enable doc api-docs)
	}
	python_execute_function -s configuration
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	python_src_test
}

src_install() {
	python_src_install

	if use doc; then
		install_documentation() {
			dohtml api/* || return 1
		}
		python_execute_function -f -q -s install_documentation
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r examples || die
	fi

	python_clean_installation_image
}

pkg_postinst() {
	python_mod_optimize dbus dbus_bindings.py
}

pkg_postrm() {
	python_mod_cleanup dbus dbus_bindings.py
}
