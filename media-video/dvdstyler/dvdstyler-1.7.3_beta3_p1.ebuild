# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdstyler/dvdstyler-1.7.3_beta3_p1.ebuild,v 1.2 2009/09/16 11:14:51 ssuominen Exp $

EAPI=2
inherit autotools eutils wxwidgets

#Save the following for stable releases
#MY_P=DVDStyler-${PV}
#The following is for development releases
MY_PV=${PV/_p/_}
MY_P=DVDStyler-${MY_PV/_beta/b}

DESCRIPTION="DVDStyler is a cross-platform DVD authoring System"
HOMEPAGE="http://www.dvdstyler.de"
SRC_URI="mirror://sourceforge/dvdstyler/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug gnome"

COMMON_DEPEND="~media-video/ffmpeg-0.5[encode]
	>=media-video/xine-ui-0.99.1
	x11-libs/wxGTK:2.8
	>=media-libs/wxsvg-1.0[ffmpeg]
	>=media-libs/libexif-0.6.16
	gnome? ( >=gnome-base/libgnomeui-2.0 )"
RDEPEND="${COMMON_DEPEND}
	virtual/cdrtools
	>=media-video/dvdauthor-0.6.14
	>=app-cdr/dvd+rw-tools-7.1"
DEPEND="${COMMON_DEPEND}
	app-text/xmlto
	dev-util/pkgconfig
	>=sys-devel/gettext-0.17"
PDEPEND=">=app-cdr/dvdisaster-0.71.0"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-link_to_wxgtk_adv.patch
	eautoreconf
}

src_configure() {
	export WX_GTK_VER="2.8"
	need-wxwidgets gtk2
	myconf="${myconf} --with-wx-config=${WX_CONFIG} $(use_enable debug)"
	econf ${myconf} || die "Configuration failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	rm -rf "${D}usr/share/doc/${PN}"
	dodoc AUTHORS ChangeLog README TODO || die "Documentation installation failed"
}
