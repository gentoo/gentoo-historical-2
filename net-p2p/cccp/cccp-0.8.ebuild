# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/cccp/cccp-0.8.ebuild,v 1.4 2004/03/01 06:26:58 eradicator Exp $

DESCRIPTION="Scriptable console frontend to Direct Connect"
HOMEPAGE="http://members.chello.se/hampasfirma/cccp"
SRC_URI="http://members01.chello.se/hampasfirma/cccp/${PN}.${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=net-p2p/dctc-0.83"

S="${WORKDIR}/${PN}.${PV}"

src_compile() {

	gcc ${CFLAGS} -o cccp cccp.c

}

src_install () {

	dobin cccp
	doman cccp.1
	dodoc README TODO GETTING_STARTED scripts/SCRIPTS
	insinto /usr/share/cccp/scripts
	doins scripts/*
	chmod 755 ${D}/usr/share/cccp/scripts/[a-z]*

}
