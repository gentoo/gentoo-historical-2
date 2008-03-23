# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gxmessage/gxmessage-2.6.2.ebuild,v 1.7 2008/03/23 21:52:40 coldwind Exp $

DESCRIPTION="A GTK2 based xmessage clone"
HOMEPAGE="http://homepages.ihug.co.nz/~trmusson/programs.html#gxmessage"
SRC_URI="http://homepages.ihug.co.nz/~trmusson/stuff/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog README

	docinto examples
	dodoc examples/gxaddress examples/gxdialup examples/gxdict examples/gxman \
		examples/gxview
}

pkg_postinst() {
	echo
	einfo "A few example usage scripts have been installed into"
	einfo "/usr/share/doc/${PF}/examples."
	echo
}
