# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gnuconfig/gnuconfig-20030708.ebuild,v 1.9 2004/06/24 22:46:59 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Updated config.sub and config.guess file from GNU"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="ftp://ftp.gnu.org/pub/gnu/config"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="mips sparc x86 ppc alpha hppa amd64 ia64 ppc64 s390"

src_install() {
	insinto /usr/share/${PN}
	doins ${WORKDIR}/ChangeLog ${WORKDIR}/index.html ${WORKDIR}/config.sub ${WORKDIR}/config.guess
}
