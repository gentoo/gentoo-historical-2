# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/consolekit/consolekit-0.3.0-r2.ebuild,v 1.1 2009/09/12 19:46:18 nirbheek Exp $

EAPI="2"

inherit autotools eutils multilib pam

MY_PN="ConsoleKit"
MY_PV="${PV//_pre*/}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Framework for defining and tracking users, login sessions and seats."
HOMEPAGE="http://www.freedesktop.org/wiki/Software/ConsoleKit"
SRC_URI="http://people.freedesktop.org/~mccann/dist/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc pam policykit"

RDEPEND=">=dev-libs/glib-2.16
	>=dev-libs/dbus-glib-0.61
	>=x11-libs/libX11-1.0.0
	pam? ( virtual/pam )
	policykit? ( >=sys-auth/policykit-0.7 )
	elibc_glibc? ( !=sys-libs/glibc-2.4* )
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-libs/libxslt
	doc? ( app-text/xmlto )"

S=${WORKDIR}/${MY_PN}-${MY_PV}

src_prepare() {
	# Fix directory leaks, bug #258685
	epatch "${FILESDIR}/${PN}-0.2.10-directory-leak.patch"

	# Clean up at_console compat files, bug #257761
	epatch "${FILESDIR}/${PN}-0.2.10-cleanup_console_tags.patch"

	# Add nox11 option to no interfere with Xsession script, bug #257763
	epatch "${FILESDIR}/${PN}-0.2.10-pam-add-nox11.patch"

	# Fix automagic dependency on policykit
	epatch "${FILESDIR}/${PN}-0.2.10-polkit-automagic.patch"

	# Fix inability to shutdown/restart
	epatch "${FILESDIR}/${P}-shutdown.patch"

	# Add SetIdleHint policy to handle new default deny on dbus
	epatch "${FILESDIR}/${P}-allow-setidle.patch"

	epatch "${FILESDIR}"/${P}-skip_xmlto_validation.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable doc docbook-docs) \
		$(use_enable pam pam-module) \
		$(use_enable policykit polkit) \
		--with-pam-module-dir=/$(getpam_mod_dir) \
		--with-dbus-services=/usr/share/dbus-1/services/ \
		--localstatedir=/var
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# crappy Redhat init script
	rm -f "${D}/etc/rc.d/init.d/ConsoleKit"

	# Portage barfs on .la files
	rm -f "${D}/$(get_libdir)/security/pam_ck_connector.la"

	# Gentoo style init script
	newinitd "${FILESDIR}"/${PN}-0.1.rc consolekit

	# Some PM drop empty dirs, bug #257164
	keepdir /usr/$(get_libdir)/ConsoleKit/run-session.d
	keepdir /etc/ConsoleKit/run-session.d
	keepdir /var/run/ConsoleKit
	keepdir /var/log/ConsoleKit

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/90-consolekit" || die "doexe failed"

	exeinto /usr/$(get_libdir)/ConsoleKit/run-session.d/
	doexe "${FILESDIR}/pam-foreground-compat.ck" || die "doexe failed"
}

pkg_postinst() {
	ewarn
	ewarn "You need to restart ConsoleKit to get the new features."
	ewarn "This can be done with /etc/init.d/consolekit restart"
	ewarn "but make sure you do this and then restart your session"
	ewarn "otherwise you will get access denied for certain actions"
}
