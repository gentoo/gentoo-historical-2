# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/nvtv/nvtv-0.4.0.ebuild,v 1.7 2002/11/06 15:29:16 vapier Exp $

DESCRIPTION="TV-Out for NVidia cards"
HOMEPAGE="http://sourceforge.net/projects/nv-tv-out/"
SRC_URI="mirror://sourceforge/nv-tv-out/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE="X gtk"

DEPEND="sys-apps/pciutils
	gtk? ( =x11-libs/gtk+-1.2* )
	X? ( >=x11-base/xfree-4.0 )"
S="${WORKDIR}/${PN}"

src_compile() {
	local myconf
	cd src

	use gtk && myconf="${myconf} --with-gtk" || myconf="${myconf} --without-gtk"
	use X && myconf="${myconf} --with-x" || myconf="${myconf} --without-x"

	econf ${myconf}

	# The CFLAGS don't seem to make it into the Makefile.
	emake CXFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin src/nvtv
	dosbin src/nvtvd

	dodoc ANNOUNCE BUGS FAQ INSTALL README \
		doc/USAGE doc/XFREE doc/chips.txt \
		doc/overview.txt  doc/timing.txt xine/tvxine

	exeinto /etc/init.d
	newexe ${FILESDIR}/nvtv.start nvtv
}
