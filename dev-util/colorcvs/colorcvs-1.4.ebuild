# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/colorcvs/colorcvs-1.4.ebuild,v 1.10 2009/10/12 20:07:06 ssuominen Exp $

DESCRIPTION="A tool based on colorgcc to beautify cvs output"
HOMEPAGE="http://www.hakubi.us/colorcvs/"
SRC_URI="http://www.hakubi.us/colorcvs/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE=""
DEPEND=""
RDEPEND="dev-lang/perl
	dev-util/cvs"

src_install() {
	exeinto /usr/bin
	doexe colorcvs
	dodoc colorcvsrc-sample
}
