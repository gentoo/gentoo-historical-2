# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/rasmol/rasmol-2.6_beta2.ebuild,v 1.9 2003/10/09 08:07:29 brandy Exp $

DESCRIPTION="Free program that displays molecular structure."
HOMEPAGE="http://www.umass.edu/microbio/rasmol/index2.htm"
KEYWORDS="x86"
SLOT="0"
LICENSE="public-domain"
DEPEND="virtual/x11"

PATCHVER="6"
P0=rasmol_2.6b2
SRC_URI="mirror://debian/pool/main/r/rasmol/${P0}.orig.tar.gz
	mirror://debian/pool/main/r/rasmol/${P0}-${PATCHVER}.diff.gz"

S="${WORKDIR}/RasMol2"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${P0}-${PATCHVER}.diff
}

src_compile() {
	xmkmf || die "xmkmf failed"
	make DEPTHDEF=-DEIGHTBIT=1 CC=${CC} \
		CDEBUGFLAGS="${CFLAGS} -DLINUX" \
		|| die "8-bit make failed"
	mv rasmol rasmol.8
	make clean
	make DEPTHDEF=-DSIXTEENBIT=1 CC=${CC} \
		CDEBUGFLAGS="${CFLAGS} -DLINUX" \
		|| die "16-bit make failed"
	mv rasmol rasmol.16
	make clean
	make DEPTHDEF=-DTHIRTYTWOBIT=1 CC=${CC} \
		CDEBUGFLAGS="${CFLAGS} -DLINUX" \
		|| die "32-bit make failed"
	mv rasmol rasmol.32
	make clean
}

src_install () {
	newbin debian/rasmol.sh.debian rasmol
	insinto /usr/lib/${PN}
	doins rasmol.{8,16,32} rasmol.hlp
	chmod a+x ${D}/usr/lib/${PN}/rasmol.{8,16,32}
	dodoc INSTALL Announce PROJECTS README TODO doc/manual.ps doc/rasmol.txt
	dodoc doc/refcard.doc doc/refcard.ps
	doman debian/rasmol.1
	insinto /usr/lib/${PN}/databases
	doins data/*
}
