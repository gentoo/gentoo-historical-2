# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/twolame/twolame-0.3.12.ebuild,v 1.6 2008/03/23 13:47:25 ranger Exp $

inherit libtool

DESCRIPTION="TwoLAME is an optimised MPEG Audio Layer 2 (MP2) encoder"
HOMEPAGE="http://www.twolame.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ~ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=media-libs/libsndfile-1"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:-O3::' configure
	# Needed for FreeBSD to get a sane .so versioning.
	elibtoolize
}

src_install() {
	emake DESTDIR="${D}" pkgdocdir="/usr/share/doc/${PF}" \
		install || die "emake install failed."
	dodoc AUTHORS ChangeLog README TODO
	prepalldocs
}
