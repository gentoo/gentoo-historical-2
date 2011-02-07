# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/augustus/augustus-2.4.ebuild,v 1.4 2011/02/07 08:06:05 weaver Exp $

EAPI="2"

inherit base eutils

DESCRIPTION="Eukaryotic gene predictor"
HOMEPAGE="http://augustus.gobics.de/"
SRC_URI="http://augustus.gobics.de/binaries/old/${PN}.${PV}.src.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_prepare() {
	sed -i 's/${CFLAGS}/${CFLAGS} ${LDFLAGS}/' src/Makefile || die
	sed -i -e 's/CFLAGS :=/CFLAGS +=/' -e 's/gcc $(CFLAGS)/gcc $(CFLAGS) $(LDFLAGS)/' scripts/*/Makefile || die
}

src_compile() {
	emake -C src clean || die
	emake -C src || die
}

src_install() {
	dobin src/{augustus,etraining,consensusFinder,curve2hints} || die
	insinto /usr/share/${PN}
	doins -r config examples scripts docs || die
	echo "AUGUSTUS_CONFIG_PATH=\"/usr/share/${PN}/config\"" > "${S}/99${PN}"
	doenvd "${S}/99${PN}" || die
	dodoc README.TXT HISTORY.TXT docs/*
}
