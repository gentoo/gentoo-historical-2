# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/twolame/twolame-0.3.10.ebuild,v 1.1 2007/04/18 19:53:23 beandog Exp $

DESCRIPTION="TwoLAME is an optimised MPEG Audio Layer 2 (MP2) encoder"
HOMEPAGE="http://www.twolame.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=media-libs/libsndfile-1.0.11"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README TODO
}
