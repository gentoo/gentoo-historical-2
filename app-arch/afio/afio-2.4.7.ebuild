# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later

S=${WORKDIR}/${P}
DESCRIPTION="makes cpio-format archives and deals somewhat gracefully with \
input data corruption."
SRC_URI="http://www.ibiblio.org/pub/linux/system/backup/${P}.tgz"
SLOT="0"
HOMEPAGE="http://freshmeat.net/projects/afio/"
LICENSE="Artistic|LGPL"

DEPEND="virtual/glibc"
RDEPEND="$DEPEND sys-apps/gzip"

src_compile() {
    emake || die

}

src_install () {
	cd ${S}
	dobin afio
	dodoc README SCRIPTS HISTORY INSTALLATION PORTING
	for i in 1 2 3 4 5 ; do
		insinto /usr/share/doc/${P}/script$i
		doins script$i/*
	done
	#prepalldocs
	doman afio.1
}

