# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gxmessage/gxmessage-2.4.4.ebuild,v 1.10 2006/01/12 22:53:41 nelchael Exp $

DESCRIPTION="A GTK2 based xmessage clone"
HOMEPAGE="http://homepages.ihug.co.nz/~trmusson/programs.html#gxmessage"
SRC_URI="http://homepages.ihug.co.nz/~trmusson/stuff/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND=">=x11-libs/gtk+-2.2"

IUSE=""

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ABOUT-NLS ChangeLog README

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
