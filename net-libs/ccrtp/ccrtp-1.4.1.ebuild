# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/ccrtp/ccrtp-1.4.1.ebuild,v 1.1 2006/07/11 14:23:34 dragonheart Exp $

DESCRIPTION="GNU ccRTP is an implementation of RTP, the real-time transport protocol from the IETF"
HOMEPAGE="http://www.gnu.org/software/ccrtp/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
IUSE=""
SLOT="0"

DEPEND=">=dev-cpp/commoncpp2-1.3.0"
RDEPEND="${DEPEND}"


src_install() {
	emake DESTDIR=${D} install || die
	dodoc README ChangeLog AUTHORS NEWS TODO
}

pkg_postinst() {
	if [[ -e ${ROOT}/usr/lib/libccrtp1-1.3.so.0 ]] ; then
		ewarn
		ewarn "Please run: revdep-rebuild --library libccrtp1-1.3.so.0"
		ewarn
	fi
}

