# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pornview/pornview-0.2.0_pre1.ebuild,v 1.2 2003/10/18 19:15:50 mholzer Exp $

IUSE="avi gtk2 jpeg mpeg nls static"

DESCRIPTION="Image viewer/manager with optional support for MPEG movies."
HOMEPAGE="http://pornview.sourceforge.net"
LICENSE="GPL-2"

DEPEND=">=media-libs/gdk-pixbuf-0.16
	media-libs/libpng
	=x11-libs/gtk+-1.2*
	avi? ( media-video/mplayer )
	jpeg? ( media-libs/jpeg )
	gtk2? ( >=x11-libs/gtk+-2.0 )
	mpeg? ( =media-libs/xine-lib-1* )
	nls? ( sys-devel/gettext )"

SLOT="0"
KEYWORDS="x86 ~ppc"
SRC_URI="mirror://sourceforge/${PN}/${P/_/}.tar.gz"

S="${WORKDIR}/${P/_/}"

src_compile() {
	local myflags="--with-gnu-ld"
	# --with-normal-paned     Use standard gtk+ paned

	# This is considered experimental but appears to work fine
	use gtk2 && myflags="${myflags} --with-gtk2"

	use jpeg || myflags="${myflags} --disable-exif"

	# mplayer and xine movie support cannot be installed at the same
	# time so prefer xine support over mplayer if both are available
	if [ "`use mpeg`" ]; then
		myflags="${myflags} --enable-xine"
	elif [ "`use avi`"]; then
		myflags="${myflags} --disable-xinetest --enable-mplayer"
	else
		myflags="${myflags} --disable-xinetest"
	fi

	use nls || myflags="${myflags} --disable-nls"

	use static && myflags="${myflags} --enable-static"

	econf ${myflags} || die "./configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS NEWS README
}

