# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mosml/mosml-2.01.ebuild,v 1.9 2009/08/17 01:41:25 vostorga Exp $

inherit toolchain-funcs

S="${WORKDIR}/${PN}/src"
DESCRIPTION="Moscow ML - a lightweight implementation of Standard ML (SML)"
SRC_URI="http://www.dina.kvl.dk/~sestoft/mosml/mos201src.tar.gz"
HOMEPAGE="http://www.dina.dk/~sestoft/mosml.html"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc x86"
IUSE=""
SLOT="0"

DEPEND=""
RDEPEND=""

src_compile() {
	emake CC=$(tc-getCC) CPP="$(tc-getCPP) -P -traditional -Dunix -Umsdos" \
	        MOSMLHOME=/opt/mosml world || die
}

src_install () {

	make MOSMLHOME="${D}"/opt/mosml install || die
	rm "${D}"/opt/mosml/lib/camlrunm # This is a bad symlink
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
