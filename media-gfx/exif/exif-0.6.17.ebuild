# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/exif/exif-0.6.17.ebuild,v 1.1 2008/12/21 09:30:37 maekke Exp $

IUSE="nls"

DESCRIPTION="Small CLI util to show EXIF infos hidden in JPEG files"
SRC_URI="mirror://sourceforge/libexif/${P}.tar.gz"
HOMEPAGE="http://libexif.sf.net"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
SLOT="0"

RDEPEND="dev-libs/popt
	 >=media-libs/libexif-0.6.15"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf $(use_enable nls)
	emake || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README
}
