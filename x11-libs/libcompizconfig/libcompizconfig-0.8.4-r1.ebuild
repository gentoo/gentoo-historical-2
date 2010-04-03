# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libcompizconfig/libcompizconfig-0.8.4-r1.ebuild,v 1.1 2010/04/03 04:41:43 jmbsvicetto Exp $

EAPI="2"

DESCRIPTION="Compiz Configuration System (git)"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://releases.compiz.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/libxml2
	>=x11-wm/compiz-${PV}
"
DEPEND="${RDEPEND}
	dev-libs/protobuf
	>=dev-util/intltool-0.41
	>=dev-util/pkgconfig-0.19
"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
