# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/nvtv/nvtv-0.4.6.ebuild,v 1.7 2007/04/28 11:40:45 tove Exp $

IUSE="X gtk"

DESCRIPTION="TV-Out for NVidia cards"
HOMEPAGE="http://sourceforge.net/projects/nv-tv-out/"
SRC_URI="mirror://sourceforge/nv-tv-out/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

RDEPEND="sys-apps/pciutils
	gtk? ( x11-libs/gtk+ )
	X? ( x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXxf86vm )"

DEPEND="${RDEPEND}
	X? ( x11-proto/xf86vidmodeproto )"

src_compile() {
	local myconf

	if use gtk
	then
		myconf="${myconf} --with-gtk"
	else
		myconf="${myconf} --without-gtk"
	fi

	use X \
		&& myconf="${myconf} --with-x" \
		|| myconf="${myconf} --without-x"

	econf ${myconf} || die

	# The CFLAGS don't seem to make it into the Makefile.
	cd src
	emake CXFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin src/nvtv
	dosbin src/nvtvd

	dodoc ANNOUNCE BUGS FAQ INSTALL README \
		doc/USAGE doc/chips.txt doc/overview.txt \
		doc/timing.txt xine/tvxine

	newinitd ${FILESDIR}/nvtv.start nvtv
}
