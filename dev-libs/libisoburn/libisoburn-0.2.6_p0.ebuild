# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libisoburn/libisoburn-0.2.6_p0.ebuild,v 1.2 2008/11/05 21:09:25 maekke Exp $

inherit base

DESCRIPTION="Enables creation and expansion of ISO-9660 filesystems on all CD/DVD media supported by libburn"
HOMEPAGE="http://libburnia-project.org/"
SRC_URI="http://files.libburnia-project.org/releases/${P/_p/.pl0}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/libburn-0.5.2
	>=dev-libs/libisofs-0.6.8"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${P/_p0}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS README TODO
}
