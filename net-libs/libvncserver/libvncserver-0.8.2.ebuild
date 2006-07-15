# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libvncserver/libvncserver-0.8.2.ebuild,v 1.1 2006/07/15 01:40:25 vapier Exp $

inherit eutils

DESCRIPTION="library for creating vnc servers"
HOMEPAGE="http://libvncserver.sourceforge.net/"
SRC_URI="http://libvncserver.sourceforge.net/LibVNCServer-${PV/_}.tar.gz
	mirror://sourceforge/libvncserver/LibVNCServer-${PV/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="nobackchannel no24bpp zlib jpeg"

DEPEND="zlib? ( sys-libs/zlib )
	jpeg? ( media-libs/jpeg )"

S=${WORKDIR}/LibVNCServer-${PV/_}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/^SUBDIRS/s:x11vnc::' \
		-e '/^CFLAGS =/d' \
		Makefile.in || die "sed foo"
	sed -i \
		-e '/^AM_CFLAGS/s: -g : :' \
		*/Makefile.in || die
}

src_compile() {
	econf \
		$(use_with !nobackchannel backchannel) \
		$(use_with !no24bpp 24bpp) \
		$(use_with zlib) \
		$(use_with jpeg) \
		|| die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dobin examples/storepasswd
	dodoc AUTHORS ChangeLog NEWS README TODO
}
