# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rar/rar-3.4.1.ebuild,v 1.3 2005/01/20 18:14:09 eradicator Exp $

S=${WORKDIR}/${PN}
MY_P=${PN}linux-${PV}
DESCRIPTION="RAR compressor/uncompressor"
HOMEPAGE="http://www.rarsoft.com/"
SRC_URI="http://www.rarlab.com/rar/rarlinux-${PV}.tar.gz"
IUSE=""
LICENSE="RAR"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"

RDEPEND="amd64? ( app-emulation/emul-linux-x86-baselibs )"

src_compile() {
	return 0
}

src_install() {
	exeinto /opt/rar/bin
	doexe rar unrar
	insinto /opt/rar/lib
	doins default.sfx
	insinto /opt/rar/etc
	doins rarfiles.lst
	dodoc *.{txt,diz}
	dodir /opt/bin
	dosym /opt/rar/bin/rar /opt/bin/rar
	dosym /opt/rar/bin/unrar /opt/bin/unrar
}
