# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/atlas-c++/atlas-c++-0.5.92.ebuild,v 1.6 2009/07/06 08:13:03 tupone Exp $

inherit eutils

MY_PN="Atlas-C++"
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Atlas protocol, used in role playing games at worldforge."
HOMEPAGE="http://www.worldforge.org/dev/eng/libraries/atlas_cpp"
SRC_URI="mirror://sourceforge/worldforge/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~ppc ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc
	>=dev-libs/libsigc++-1.2"
RDEPEND=${DEPEND}

src_install() {
	make DESTDIR="${D}" install || die
	#dodoc will install all these docs and a few more
	rm -rf "${D}"/usr/share/doc/${My_P}
	#PR=r0 in this case, but don't fprget to add ${PR} here for non-zero revisions!

	dodoc AUTHORS ChangeLog NEWS README ROADMAP THANKS TODO
}
