# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/compiz-fusion-plugins-extra/compiz-fusion-plugins-extra-0.6.0.ebuild,v 1.3 2007/10/24 10:39:26 hanno Exp $

DESCRIPTION="Compiz Fusion extra plugins"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI="http://releases.compiz-fusion.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="test"

DEPEND="x11-plugins/compiz-fusion-plugins-main"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS || die "dodoc failed"
}
