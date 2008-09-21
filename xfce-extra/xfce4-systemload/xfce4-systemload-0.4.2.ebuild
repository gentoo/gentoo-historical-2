# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-systemload/xfce4-systemload-0.4.2.ebuild,v 1.18 2008/09/21 18:52:58 angelos Exp $

inherit autotools xfce44

xfce44

DESCRIPTION="System load monitor panel plugin"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"

DEPEND="dev-util/xfce4-dev-tools
	dev-util/intltool"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-libtool.patch
	sed -i -e "/^AC_INIT/s/systemload_version()/systemload_version/" configure.in
	intltoolize --force --copy --automake || die "intltoolize failed."
	AT_M4DIR=/usr/share/xfce4/dev-tools/m4macros eautoreconf
}

DOCS="AUTHORS ChangeLog NEWS README"

xfce44_goodies_panel_plugin
