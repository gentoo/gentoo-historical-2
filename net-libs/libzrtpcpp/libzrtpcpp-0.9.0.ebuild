# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libzrtpcpp/libzrtpcpp-0.9.0.ebuild,v 1.6 2006/11/10 22:28:45 lu_zero Exp $

DESCRIPTION="GNU RTP stack for the zrtp protocol specification developed by Phil Zimmermen"
HOMEPAGE="http://www.gnu.org/software/ccrtp/"
SRC_URI="mirror://gnu/ccrtp/${P}.tar.gz"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
LICENSE="GPL-2"
IUSE=""
SLOT="0"

RDEPEND=">=net-libs/ccrtp-1.5.0
	>=dev-cpp/commoncpp2-1.5.1
	|| ( dev-libs/libgcrypt
		>=dev-libs/openssl-0.9.8 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README AUTHORS
}
