# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mosml/mosml-2.01.ebuild,v 1.4 2004/06/24 22:52:15 agriffis Exp $

S="${WORKDIR}/${PN}/src"
DESCRIPTION="Moscow ML - a lightweight implementation of Standard ML (SML)"
SRC_URI="http://www.dina.kvl.dk/~sestoft/mosml/mos201src.tar.gz"
HOMEPAGE="http://www.dina.dk/~sestoft/mosml.html"
LICENSE="GPL-2"
DEPEND=""
KEYWORDS="x86 ~ppc"
SLOT="0"

src_compile() {
	emake MOSMLHOME=/opt/mosml world || die
}

src_install () {

	make MOSMLHOME=${D}/opt/mosml install || die
	rm ${D}/opt/mosml/lib/camlrunm # This is a bad symlink
	echo "#!/opt/mosml/bin/camlrunm" > ${D}/opt/mosml/lib/header

	dodoc  ../README
	into   /usr/bin
	dosym  /opt/mosml/bin/mosml     /usr/bin/mosml
	dosym  /opt/mosml/bin/mosmlc    /usr/bin/mosmlc
	dosym  /opt/mosml/bin/mosmllex  /usr/bin/mosmllex
	dosym  /opt/mosml/bin/mosmlyac  /usr/bin/mosmlyac
	dosym  /opt/mosml/bin/camlrunm  /usr/bin/camlrunm
	dosym  /opt/mosml/bin/camlrunm  /opt/mosml/lib/camlrunm

}
