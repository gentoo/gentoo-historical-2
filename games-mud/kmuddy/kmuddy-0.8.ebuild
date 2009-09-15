# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/kmuddy/kmuddy-0.8.ebuild,v 1.10 2009/09/15 19:20:07 mr_bones_ Exp $

EAPI=2
inherit base eutils kde-functions autotools

DESCRIPTION="MUD client for KDE"
HOMEPAGE="http://www.kmuddy.com/"
SRC_URI="http://www.kmuddy.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="sdl"

DEPEND="sdl? ( media-libs/sdl-mixer )"

need-kde 3

PATCHES=(	"${FILESDIR}/${P}-nocrash.patch"
		"${FILESDIR}/${P}-gcc43.patch"
		"${FILESDIR}/${P}-idle-crash.patch"
		"${FILESDIR}/${P}-libtool.patch"
	)

src_prepare() {
	base_src_prepare
	sed -i \
		-e '/kmuddyscriptingplugin_la_LDFLAGS/ s/$(LIB_QT)/$(LIB_QT) $(LIB_KIO)/' \
		plugins/scripting/Makefile.am \
		|| die "sed failed"
	mv admin/acinclude.m4.in acinclude.m4
	eautoreconf
	find . -name Makefile.in -exec perl admin/am_edit ';'
}

src_configure() {
	econf \
		--without-arts \
		--with-extra-includes=$(kde-config --expandvars --install include) \
		$(use_with sdl)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS CHANGELOG DESIGN README README.MIDI Scripting-HOWTO TODO
}
