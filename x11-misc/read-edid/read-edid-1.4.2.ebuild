# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/read-edid/read-edid-1.4.2.ebuild,v 1.1 2008/11/11 15:10:02 yngwin Exp $

DESCRIPTION="Program that can get information from a PnP monitor"
HOMEPAGE="http://www.polypux.org/projects/read-edid/"
SRC_URI="http://www.polypux.org/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""
DEPEND="amd64? ( >=dev-libs/libx86-1.1 )
	x86? ( >=dev-libs/libx86-1.1 )"
RDEPEND=""

src_compile() {
	econf --mandir=/usr/share/man || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
