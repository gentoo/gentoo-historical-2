# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/asterisk-sccp/asterisk-sccp-0.2.ebuild,v 1.6 2004/09/29 17:30:37 stkn Exp $

inherit eutils

IUSE="debug"

DESCRIPTION="SCCP plugin for the Asterisk soft PBX"
HOMEPAGE="http://www.zozo.org.uk/pages.shtml?page=sccp"
SRC_URI="http://www.zozo.org.uk/downloads/chan_sccp-${PV}.tar.gz"
S="${WORKDIR}/chan_sccp-${PV}"

SLOT="0"
KEYWORDS="~x86"
LICENSE="GPL-2"

DEPEND=">=net-misc/asterisk-0.5.0
	! >=net-misc/asterisk-1.0.0"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-makefile.diff

	if ! use debug; then
		sed -i -e "s:^\(DEBUG=-g\):#\1:" Makefile
	fi

	# set cflags
	sed -i -e "s:^CFLAG=\(.*\)\$(DEBUG):CFLAG=${CFLAGS} \$(DEBUG):" \
		Makefile
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die

	dodoc README conf/*.xml
}
