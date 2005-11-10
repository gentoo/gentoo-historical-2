# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcalc/wmcalc-0.4.ebuild,v 1.8 2005/11/10 08:44:13 s4t4n Exp $

inherit eutils

DESCRIPTION="A WindowMaker DockApp calculator"
HOMEPAGE="http://dockapps.org/file.php/id/130"
SRC_URI="mirror://gentoo/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ppc ppc64 ~sparc"
DEPEND="virtual/x11"

IUSE=""

src_unpack()
{
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/wmcalc-0.4-Makefile.patch
}

src_compile()
{
	emake || die
}

src_install ()
{
	dobin wmcalc

	dodoc README

	newman ${FILESDIR}/wmcalc.man wmcalc.1

	insinto /etc
	newins .wmcalc wmcalc.conf

	insinto /etc/skel
	doins .wmcalc
}
