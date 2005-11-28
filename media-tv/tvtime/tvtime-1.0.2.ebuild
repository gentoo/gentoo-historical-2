# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/tvtime/tvtime-1.0.2.ebuild,v 1.1 2005/11/28 22:37:15 hanno Exp $

inherit eutils

DESCRIPTION="High quality television application for use with video capture cards"
HOMEPAGE="http://tvtime.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND="virtual/x11
	>=media-libs/freetype-2
	>=sys-libs/zlib-1.1.4
	>=media-libs/libpng-1.2
	>=dev-libs/libxml2-2.5.11"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch ${FILESDIR}/tvtime-1.0.2-gcc41.patch

	# use 'tvtime' for the application icon see bug #66293
	sed -i -e "s/tvtime.png/tvtime/" docs/net-tvtime.desktop

	# patch to adapt to PIC or __PIC__ for pic support
	epatch "${FILESDIR}"/${PN}-pic.patch #74227
}

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "compile problem"

}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dohtml docs/html/*
	dodoc ChangeLog AUTHORS NEWS README
}

pkg_postinst() {
	einfo "A default setup for ${PN} has been saved as"
	einfo "/etc/tvtime/tvtime.xml. You may need to modify it"
	einfo "for your needs."
	einfo
	einfo "Detailed information on ${PN} setup can be"
	einfo "found at ${HOMEPAGE}help.html"
	echo
}
