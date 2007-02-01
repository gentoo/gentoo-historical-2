# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/audacious-docklet/audacious-docklet-0.1.1-r1.ebuild,v 1.9 2007/02/01 18:52:53 gustavoz Exp $

inherit eutils

DESCRIPTION="Audacious plugin that displays an icon in your systemtray"
HOMEPAGE="http://nedudu.hu/index.php?page=downloads&id=2"
SRC_URI="http://nedudu.hu/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE="nls"

RDEPEND=">=media-sound/audacious-0.2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( dev-util/intltool )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-includes.patch
}

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README TODO
}
