# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/poppler-qt3/poppler-qt3-0.11.3.ebuild,v 1.1 2009/08/22 21:29:49 loki_val Exp $

EAPI=2

POPPLER_MODULE=qt
POPPLER_PKGCONFIG=poppler-qt.pc
POPPLER_CONF="--enable-poppler-qt"

inherit qt3 poppler

DESCRIPTION="Qt3 bindings for poppler"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	~dev-libs/poppler-${PV}
	>=x11-libs/qt-3.3:3
	"
DEPEND="
	${RDEPEND}
	"

src_compile() {
	poppler_src_compile POPPLER_QT_LIBS="$(pkg-config --libs qt-mt)"
}
