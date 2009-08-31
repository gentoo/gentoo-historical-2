# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gphoto2/gphoto2-2.4.5.ebuild,v 1.7 2009/08/31 18:04:33 ranger Exp $

EAPI=2

inherit eutils

DESCRIPTION="free, redistributable digital camera software application"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ppc ppc64 ~sparc ~x86"
IUSE="aalib exif ncurses nls readline"

# aalib -> needs libjpeg
# raise libgphoto to get a proper .pc
RDEPEND="=virtual/libusb-0*
	dev-libs/popt
	>=media-libs/libgphoto2-2.4.5[exif]
	ncurses? ( dev-libs/cdk )
	aalib? (
		media-libs/aalib
		media-libs/jpeg )
	exif? (	media-libs/libexif )
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( >=sys-devel/gettext-0.14 )"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_with aalib) \
		$(use_with aalib jpeg) \
		$(use_with exif) \
		$(use_with ncurses cdk) \
		$(use_enable nls) \
		$(use_with readline)
}

src_install() {
	emake DESTDIR="${D}" \
		HTML_DIR="${D}"/usr/share/doc/${PF}/sgml \
		install || die "installation failed"

	dodoc ChangeLog NEWS* README AUTHORS || die "dodoc failed"
	rm -rf "${D}"/usr/share/doc/${PF}/sgml/gphoto2
}
