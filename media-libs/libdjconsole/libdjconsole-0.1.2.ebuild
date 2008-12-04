# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdjconsole/libdjconsole-0.1.2.ebuild,v 1.6 2008/12/04 22:31:59 maekke Exp $

DESCRIPTION="A driver for the DJ Console, built on top of libusb"
HOMEPAGE="http://djplay.sourceforge.net/"
SRC_URI="mirror://sourceforge/djplay/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="dev-libs/libusb"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	emake install DESTDIR="${D}" || die 'make install failed'
	dodoc ChangeLog NEWS README AUTHORS
}
