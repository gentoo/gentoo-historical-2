# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/uptimed/uptimed-0.3.0-r1.ebuild,v 1.6 2004/06/14 08:45:42 kloeri Exp $

DESCRIPTION="Standard informational utilities and process-handling tools"
SRC_URI="mirror://sourceforge/uptimed/${P}.tar.bz2"
RESTRICT="nomirror"
HOMEPAGE="http://unixcode.org/uptimed/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
IUSE=""

src_compile() {
	sed -i "s:-d /var/:-d ${D}/var/:g" ${S}/Makefile.am
	sed -i "s:-d /var/:-d ${D}/var/:g" ${S}/Makefile.in

	econf || die "econf failed"
	emake || die
}

src_install() {
	dodir /usr/bin
	dodir /usr/sbin
	dodir /var/spool/uptimed

	make DESTDIR=${D} install || die

	dodoc README NEWS TODO AUTHORS COPYING CREDITS
	exeinto /etc/init.d ; newexe ${FILESDIR}/uptimed uptimed
}

pkg_postinst() {
	einfo "To start uptimed, you must enable the /etc/init.d/uptimed rc file"
	einfo "You may start uptimed now with:"
	einfo "/etc/init.d/uptimed start"
	einfo "To view your uptimes, use the command 'uprecords'."
}
