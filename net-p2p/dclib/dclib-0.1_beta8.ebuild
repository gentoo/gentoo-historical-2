# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/dclib/dclib-0.1_beta8.ebuild,v 1.3 2002/07/06 06:32:14 seemant Exp $


MY_P=${P/_/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Library for the Qt client for DirectConnect"
HOMEPAGE="http://dc.ketelhot.de/"

LICENSE="GPL-2"
SLOT="0"

SRC_URI="http://dc.ketelhot.de/files/dcgui/unstable/source/${MY_P}.tar.bz2"

DEPEND=">=sys-apps/bzip2-1.0.2
        >=dev-libs/libxml2-2.4.22"

src_compile() {

	export CPPFLAGS="${CPPFLAGS} -I/usr/include/libxml2/libxml"

	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}
