# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-liveice/xmms-liveice-1.0.0.ebuild,v 1.1 2003/02/12 12:50:37 seemant Exp $

MY_P=LiveIce-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Stream your XMMS playlist to Shout/Icecast server"
HOMEPAGE="http://star.arm.ac.uk/~spm/software/liveice.html"
SRC_URI="http://star.arm.ac.uk/~spm/software/liveice-xmms.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="net-misc/icecast
	media-sound/xmms"

src_compile() {
	econf || die
	make CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	make DESTDIR=${D} install || die
}
