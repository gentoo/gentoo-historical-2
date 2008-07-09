# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/lv2core/lv2core-2.0.ebuild,v 1.1 2008/07/09 10:15:09 aballier Exp $

DESCRIPTION="LV2 is a simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"
SRC_URI="http://lv2plug.in/spec/${P}.tar.gz"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="!<media-libs/slv2-0.4.2"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README
}
