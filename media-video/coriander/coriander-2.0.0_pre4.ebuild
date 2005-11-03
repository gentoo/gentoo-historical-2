# Copyright 1999-2005 Gentoo Foundation and Pieter Van den Abeele
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/coriander/coriander-2.0.0_pre4.ebuild,v 1.1 2005/11/03 16:12:50 seemant Exp $

MY_P=${P/_/-}

DESCRIPTION="A Gnome2 GUI for firewire camera control and capture"
HOMEPAGE="http://sourceforge.net/projects/coriander/"

SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="ffmpeg"

S=${WORKDIR}/${MY_P}


RDEPEND=">=media-libs/libdc1394-2.0.0_pre5
	ffmpeg? ( media-video/ffmpeg )
	media-libs/libsdl
	gnome-base/libgnomeui
	gnome-base/libbonoboui
	gnome-base/libgnomecanvas
	gnome-base/libgnome
	gnome-base/orbit"

DEPEND="${RDEPEND}
	sys-devel/libtool"

src_compile() {
	export SSE_CFLAGS="${CFLAGS}"
	econf || die
	emake SSE_CFLAGS="${CFLAGS}" || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc NEWS README AUTHORS
}
