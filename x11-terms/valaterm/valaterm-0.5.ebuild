# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/valaterm/valaterm-0.5.ebuild,v 1.1 2012/06/22 08:54:05 ssuominen Exp $

EAPI=4
inherit waf-utils

PN_vala_slt=0.16
PN_vala_ver=0.13.2

DESCRIPTION="A lightweight vala based terminal"
HOMEPAGE="http://gitorious.org/valaterm"
SRC_URI="http://gitorious.org/${PN}/${PN}/archive-tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:3
	x11-libs/vte:2.90"
DEPEND="${RDEPEND}
	>=dev-lang/vala-${PN_vala_ver}:${PN_vala_slt}
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
		)"

DOCS="AUTHORS ChangeLog README TODO"

S=${WORKDIR}/${PN}-${PN}

src_prepare() {
	sed -i \
		-e '/CFLAGS.extend.*ggdb3/d' \
		-e '/CFLAGS.extend.*O2/d' \
		-e '/LINKFLAGS.extend.*O1/d' \
		wscript || die
}

src_configure() {
	export VALAC="$(type -P valac-${PN_vala_slt})"
	local myconf
	use nls || myconf="--disable-nls"
	waf-utils_src_configure --with-gtk3 ${myconf}
}
