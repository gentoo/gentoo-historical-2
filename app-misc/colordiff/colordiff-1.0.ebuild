# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-misc/colordiff/colordiff-1.0.ebuild,v 1.3 2002/12/02 08:23:47 mholzer Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Colorizes output of diff"
SRC_URI="mirror://sourceforge/colordiff/${P}.tar.gz"
HOMEPAGE="http://colordiff.sourceforge.net/"
IUSE=""

DEPEND="sys-apps/diffutils"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~sparc64"

src_install () {

	exeinto /usr/bin
	newexe ${S}/colordiff.pl colordiff
	insinto /etc
	doins ${S}/colordiffrc
	chown root.root ${S}/etc/colordiffrc
	chmod 644 ${S}/etc/colordiffrc
	dodoc BUGS CHANGES COPYING README TODO
}
