# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/emerald-themes/emerald-themes-0.1.4.ebuild,v 1.2 2007/02/24 20:05:25 tsunam Exp $

inherit eutils

DESCRIPTION="Beryl Window Decorator Themes"
HOMEPAGE="http://beryl-project.org"
SRC_URI="http://releases.beryl-project.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
RESTRICT="mirror binchecks strip"

DEPEND="~x11-wm/emerald-${PV}"

src_compile() {
	econf || die "econf failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
