# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmgrabimage/wmgrabimage-0.72-r1.ebuild,v 1.5 2007/07/11 20:39:23 mr_bones_ Exp $

inherit eutils

IUSE=""

MY_P=${PN/grabi/GrabI}
S=${WORKDIR}/${MY_P}-${PV}/${MY_P}

DESCRIPTION="wmGrabImage grabs an image from the WWW and displays it"
SRC_URI="http://www.dockapps.com/download.php/id/19/${MY_P}-${PV}.tgz"
HOMEPAGE="http://www.dockapps.com/file.php/id/12"

RDEPEND=">=net-misc/wget-1.9-r2
	>=media-gfx/imagemagick-5.5.7.15
	>=sys-apps/sed-4
	|| ( (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm )
	virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( (
		x11-proto/xproto
		x11-proto/xextproto )
	virtual/x11 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

src_unpack()
{
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-noman.patch
}

src_compile()
{
	sed -i -e 's/-geom /-geometry /' GrabImage
	emake clean || die "clean failed"
	emake CFLAGS="${CFLAGS} -Wall" || die "make failed"
}

src_install()
{
	cd ${S}
	dodir /usr/bin
	einstall DESTDIR="${D}/usr" || die "make install failed"

	doman wmGrabImage.1

	cd ..
	dodoc BUGS CHANGES HINTS TODO

	insinto /usr/share/applications
	doins ${FILESDIR}/${PN}.desktop
}
