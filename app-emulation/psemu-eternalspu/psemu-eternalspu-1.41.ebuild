# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/psemu-eternalspu/psemu-eternalspu-1.41.ebuild,v 1.1 2003/07/13 08:41:33 vapier Exp $

DESCRIPTION="PSEmu Eternal SPU"
HOMEPAGE="http://www1.odn.ne.jp/psx-alternative/"
SRC_URI="http://www1.odn.ne.jp/psx-alternative/download/spuEternal${PV//.}_linux.tgz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86"

DEPEND="media-libs/libsdl"

S=${WORKDIR}

src_install() {
	exeinto /usr/lib/psemu/plugins
	doexe libspuEternal.so.*
	dodoc *.txt
}
