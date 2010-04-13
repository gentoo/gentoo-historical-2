# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkhotkey/gtkhotkey-0.2.1.ebuild,v 1.2 2010/04/13 19:36:34 hwoarang Exp $

EAPI="2"

inherit versionator

MY_CRV=$(get_version_component_range 1-2)

RESTRICT="test"
# Tests try to access live filesystem
# See http://bugs.gentoo.org/show_bug.cgi?id=259052#c3

DESCRIPTION="Cross platform library for using desktop wide hotkeys"
HOMEPAGE="http://launchpad.net/gtkhotkey"
SRC_URI="http://launchpad.net/${PN}/${MY_CRV}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=dev-libs/glib-2.16
	>=x11-libs/gtk+-2.12"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl"

DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0
	sys-devel/gettext"

src_prepare() {
	sed -i -e "s: install-gtkhotkeydocDATA ::" Makefile.in || die "Patching Makefile.in failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
