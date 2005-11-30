# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rar/rar-3.3.0.ebuild,v 1.1 2004/04/27 16:11:49 aliz Exp $

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
