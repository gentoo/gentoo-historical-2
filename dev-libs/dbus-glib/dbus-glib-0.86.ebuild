# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dbus-glib/dbus-glib-0.86.ebuild,v 1.3 2010/05/25 21:18:05 pacho Exp $

EAPI="2"

inherit bash-completion

DESCRIPTION="D-Bus bindings for glib"
HOMEPAGE="http://dbus.freedesktop.org/"
SRC_URI="http://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 AFL-2.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="bash-completion debug doc test"

RDEPEND=">=sys-apps/dbus-1.1
	>=dev-libs/glib-2.10
	>=dev-libs/expat-1.95.8"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	doc? (
		app-doc/doxygen
		app-text/xmlto
		>=dev-util/gtk-doc-1.4 )"

# out of sources build directory
BD=${WORKDIR}/${P}-build
# out of sources build dir for make check
TBD=${WORKDIR}/${P}-tests-build

BASHCOMPLETION_NAME="dbus"

src_configure() {
	local my_conf

	my_conf="--localstatedir=/var
		$(use_enable bash-completion)
		$(use_enable debug verbose-mode)
		$(use_enable debug asserts)
		$(use_enable doc doxygen-docs)
		$(use_enable doc gtk-doc)"

	mkdir "${BD}"
	cd "${BD}"
	einfo "Running configure in ${BD}"
	ECONF_SOURCE="${S}" econf ${my_conf}

	if use test; then
		mkdir "${TBD}"
		cd "${TBD}"
		einfo "Running configure in ${TBD}"
		ECONF_SOURCE="${S}" econf \
			${my_conf} \
			$(use_enable test checks) \
			$(use_enable test tests) \
			$(use_enable test asserts) \
			$(use_with test test-socket-dir "${T}"/dbus-test-socket)
	fi
}

src_compile() {
	cd "${BD}"
	einfo "Running make in ${BD}"
	emake || die "make failed"

	if use test; then
		cd "${TBD}"
		einfo "Running make in ${TBD}"
		emake || die "make failed"
	fi
}

src_test() {
	cd "${TBD}"
	emake check || die "make check failed"
}

src_install() {
	dodoc AUTHORS ChangeLog HACKING NEWS README || die "dodoc failed."

	cd "${BD}"
	emake DESTDIR="${D}" install || die "make install failed"

	# FIXME: We need --with-bash-completion-dir
	if use bash-completion ; then
		dobashcompletion "${D}"/etc/bash_completion.d/dbus-bash-completion.sh
		rm -rf "${D}"/etc/bash_completion.d || die "rm failed"
	fi
}
