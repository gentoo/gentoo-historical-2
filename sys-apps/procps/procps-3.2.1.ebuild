# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/procps/procps-3.2.1.ebuild,v 1.2 2004/03/30 04:15:22 pebenito Exp $

inherit flag-o-matic eutils

DESCRIPTION="Standard informational utilities and process-handling tools"
HOMEPAGE="http://procps.sourceforge.net/"
SRC_URI="http://${PN}.sf.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~hppa ~amd64 ~ia64 ~ppc64"

RDEPEND=">=sys-libs/ncurses-5.2-r2"

src_unpack() {
	unpack ${A}
	cd ${S}

	# add -Z short option to ps for SELinux
	epatch ${FILESDIR}/procps-3.2.0-selinux-Z.diff

	# Use the CFLAGS from /etc/make.conf.
	replace-flags -O3 -O2
	sed -i \
		-e "s:-O2:${CFLAGS}:" \
		-e "/^LDFLAGS/s:$: ${LDFLAGS}:" \
		-e "/install/s: --strip : :" \
		Makefile
}

src_compile() {
	emake || die
}

src_install() {
	einstall DESTDIR="${D}"|| die
	dodoc BUGS NEWS TODO pc/HACKING
}

pkg_postinst() {
	einfo "NOTE: By default \"ps\" and \"top\" no longer"
	einfo "show threads. You can use the '-m' flag"
	einfo "in ps or the 'H' key in top to show them"
}
