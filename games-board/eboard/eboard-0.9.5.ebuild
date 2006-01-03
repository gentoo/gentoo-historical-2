# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/eboard/eboard-0.9.5.ebuild,v 1.11 2006/01/03 02:32:45 mr_bones_ Exp $

inherit eutils games

EXTRAS1="eboard-extras-1pl2"
EXTRAS2="eboard-extras-2"
DESCRIPTION="chess interface for POSIX systems"
HOMEPAGE="http://eboard.sourceforge.net/"
SRC_URI="mirror://sourceforge/eboard/${P}.tar.gz
	mirror://sourceforge/eboard/${EXTRAS1}.tar.gz
	mirror://sourceforge/eboard/${EXTRAS2}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="nls"

RDEPEND="=x11-libs/gtk+-1*
	>=media-libs/imlib-1.9.7
	dev-lang/perl
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gcc4.patch

	sed -i \
		-e "/DATADIR/ s:\$prefix/share:${GAMES_DATADIR}:" \
		-e "s:(\"-O6\"):split(' ', \"${CXXFLAGS}\"):" configure \
		|| die "sed configure failed"
}

src_compile() {
	egamesconf $(use_enable nls) || die
	emake || die "emake failed"
}

src_install() {
	make \
		prefix="${D}/${GAMES_PREFIX}" \
		bindir="${D}/${GAMES_BINDIR}" \
		mandir="${D}/usr/share/man" \
		datadir="${D}/${GAMES_DATADIR}/${PN}" \
			install || die "make install failed"
	dodoc README AUTHORS ChangeLog TODO Documentation/* || die "dodoc failed"

	cd "${WORKDIR}/${EXTRAS1}"
	insinto "${GAMES_DATADIR}/eboard"
	doins *.png *.wav || die "doins failed (extra1)"
	newins extras1.conf themeconf.extras1 || die "newins failed (extra1)"
	newdoc ChangeLog Changelog.extras || die "newdoc failed (extra1.1)"
	newdoc README README.extras || die "newdoc failed (extra1.2)"
	dodoc CREDITS || die "dodoc failed (extra1)"

	cd "${WORKDIR}/${EXTRAS2}"
	doins *.png *.wav || die "doins failed (extra2)"
	newins extras2.conf themeconf.extras2 || die "newins failed (extra2)"

	prepgamesdirs
}
