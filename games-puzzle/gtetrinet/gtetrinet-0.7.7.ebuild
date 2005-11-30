# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/gtetrinet/gtetrinet-0.7.7.ebuild,v 1.1 2004/07/25 01:02:42 mr_bones_ Exp $

# games after gnome2 so games' functions will override gnome2's
inherit gnome2 games

DESCRIPTION="Tetrinet Clone for GNOME 2"
HOMEPAGE="http://gtetrinet.sourceforge.net/"
SRC_URI="${SRC_URI}
	mirror://gentoo/gtetrinet-gentoo-theme-0.1.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 sparc ~ppc"
IUSE="nls ipv6"

RDEPEND="dev-libs/libxml2
	>=media-sound/esound-0.2.5
	>=gnome-base/gconf-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}
	return 0
	sed -i \
		-e "s:\$(datadir)/pixmaps:/usr/share/pixmaps:" \
		-e "/DISABLE_DEPRECATED/d" \
		{.,icons,src}/Makefile.in \
		|| die "sed Makefile.in failed"
}

src_compile() {
	egamesconf \
		$(use_enable ipv6) \
		--sysconfdir=/etc \
		|| die
	emake || die "emake failed"
}

src_install() {
	USE_DESTDIR=1
	gnome2_src_install
	dodoc AUTHORS ChangeLog NEWS README TODO

	# move some stuff around
	cd ${D}/${GAMES_PREFIX}
	mkdir bin && mv games/gtetrinet bin/
	rm -rf games && cd ${D}/${GAMES_DATADIR} && mv applications locale ../
	use nls || rm -rf ../locale
	mv ${WORKDIR}/gentoo ${D}/${GAMES_DATADIR}/${PN}/themes/
	prepgamesdirs
}

pkg_postinst() {
	SCROLLKEEPER_UPDATE=0
	gnome2_pkg_postinst
	games_pkg_postinst
}
