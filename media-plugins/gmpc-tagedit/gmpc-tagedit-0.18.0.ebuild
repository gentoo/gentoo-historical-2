# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-tagedit/gmpc-tagedit-0.18.0.ebuild,v 1.1 2009/03/13 12:10:20 angelos Exp $

DESCRIPTION="This plugin allows you to edit tags in your library"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_TAGEDIT"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-sound/gmpc-${PV}
	media-libs/taglib
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install () {
	emake DESTDIR="${D}" install || die "emake failed"
}
