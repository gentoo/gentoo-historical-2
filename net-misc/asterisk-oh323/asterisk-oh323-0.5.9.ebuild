# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/asterisk-oh323/asterisk-oh323-0.5.9.ebuild,v 1.4 2005/03/10 01:44:19 stkn Exp $

IUSE=""

inherit eutils

DESCRIPTION="H.323 Channel plugin for the Asterisk soft PBX"
HOMEPAGE="http://www.inaccessnetworks.com/projects/asterisk-oh323/"
SRC_URI="http://www.inaccessnetworks.com/projects/asterisk-oh323/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=">=dev-libs/pwlib-1.5.2-r2
	>=net-libs/openh323-1.12.2-r2
	>=net-misc/asterisk-0.5.0
	!>=net-libs/openh323-1.13.0"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-Makefile.patch
	epatch ${FILESDIR}/${P}-asterisk-driver-Makefile.patch
}

src_compile() {
	# NOTRACE=1 is required (atm)
	# plugin won't work if this isn't set!
	make NOTRACE=1 || die
}

src_install() {
	make DESTDIR=${D} install || die
}
