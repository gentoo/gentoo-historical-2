# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/procps/procps-3.1.15.ebuild,v 1.14 2004/07/15 02:26:37 agriffis Exp $

inherit flag-o-matic eutils

DESCRIPTION="Standard informational utilities and process-handling tools -ps top tload snice vmstat free w watch uptime pmap skill pkill kill pgrep sysctl"
HOMEPAGE="http://procps.sourceforge.net/"
SRC_URI="http://${PN}.sf.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha hppa amd64 ia64 ppc64"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.2-r2"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/procps-3.1.15-fix_attr.diff

	# Use the CFLAGS from /etc/make.conf.
	replace-flags "-O3" "-O2"
	for file in `find . -iname "Makefile"`;do
		sed -i "s:-O2:${CFLAGS}:" ${file}
	done
}

src_compile() {
	emake || die
}

src_install() {
	einstall DESTDIR="${D}"|| die

	dodoc BUGS COPYING COPYING.LIB NEWS TODO
	docinto proc
	dodoc proc/COPYING
	docinto ps
	dodoc ps/COPYING ps/HACKING
}

pkg_postinst() {
	einfo "NOTE: By default \"ps\" and \"top\" no longer"
	einfo "show threads. You can use the '-m' flag"
	einfo "in ps or the 'H' key in top to show them"
}
