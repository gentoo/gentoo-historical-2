# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/lwm/lwm-1.2.0.ebuild,v 1.3 2004/06/19 05:31:00 weeve Exp $

IUSE="motif"

S=${WORKDIR}/${P}
DESCRIPTION="The ultimate lightweight window manager"
SRC_URI="ftp://ftp.cs.york.ac.uk/pub/james/${P}.tar.gz"
HOMEPAGE="http://www.jfc.org.uk/software/lwm.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 sparc ppc"

DEPEND="motif? ( x11-libs/openmotif >=sys-apps/sed-4 )
	virtual/x11"

RDEPEND="motif? ( x11-libs/openmotif )
	virtual/x11"

src_compile() {
	use motif && sed -i "s/-DHAVE_MOTIF//" Imakefile
	xmkmf || die
	emake lwm || die
}

src_install() {

	dobin lwm

	newman lwm.man lwm.1
	dodoc AUTHORS BUGS ChangeLog INSTALL README TODO
}
