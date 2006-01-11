# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/synce-rra/synce-rra-0.9.1.ebuild,v 1.1 2006/01/11 06:31:06 chriswhite Exp $

inherit eutils autotools

DESCRIPTION="Synchronize Windows CE devices with computers running GNU/Linux, like MS ActiveSync."
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=dev-libs/check-0.8.2
	>=dev-libs/libmimedir-0.4
	>=app-pda/synce-libsynce-0.9.1
	>=app-pda/synce-librapi2-0.9.1"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-textrel.patch
	sed -i -e \
	"s:libtoolize --copy --automake:libtoolize --copy --force	--automake:g" \
	bootstrap
	./bootstrap
}

src_install() {
	make DESTDIR="${D}" install || die
}
