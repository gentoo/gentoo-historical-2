# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/va-systemimager-server/va-systemimager-server-1.4.0.ebuild,v 1.13 2003/03/28 10:18:30 pvdabeel Exp $

DESCRIPTION="VA SystemImager software automates the installation of Linux to masses of similar machines."
SRC_URI="mirror://sourceforge/systemimager/${P}.tar.bz2"
HOMEPAGE="http://systemimager.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ~ppc"

src_install() {
	DESTDIR=${D} ./install --no-afterburner --quiet || die
	insinto /etc/rsync
	newins ${FILESDIR}/${P}-rsyncd.conf rsyncd.conf
	dosed "s:/etc/rsyncd\.conf:/etc/rsyncd/rsyncd.conf:" /usr/sbin/getimage
	dodir /var/{log/systemimager,spool/systemimager}
	rm -r ${D}/etc/rc.d
}
