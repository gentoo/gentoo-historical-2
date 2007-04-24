# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gnopaster/gnopaster-0.0.6.ebuild,v 1.1 2007/04/24 10:44:52 jurek Exp $

DESCRIPTION="A submitter for gnopaste, a nopaste service like http://nopaste.info"
HOMEPAGE="http://gnopaste.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.pl.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lang/perl
	dev-perl/libwww-perl
	dev-perl/ConfigReader"

src_install() {
	dobin ${WORKDIR}/${P}.pl
	dosym ${P}.pl /usr/bin/${PN}
}
