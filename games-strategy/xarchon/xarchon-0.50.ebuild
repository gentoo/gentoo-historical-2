# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/xarchon/xarchon-0.50.ebuild,v 1.7 2006/03/12 23:43:50 mr_bones_ Exp $

inherit games

DESCRIPTION="modelled after the golden oldie Archon game"
HOMEPAGE="http://xarchon.seul.org/"
SRC_URI="ftp://ftp.seul.org/pub/xarchon/${P}.tar.gz
	http://xarchon.seul.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE="esd joystick"

DEPEND="=x11-libs/gtk+-1*
	esd? ( media-sound/esound )"

src_compile() {
	local mysndconf
	use esd \
		&& mysndconf="--with-esd-prefix=/usr" \
		|| mysndconf="--disable-sound"
	egamesconf \
		--enable-network \
		$(use_enable joystick) \
		${mysndconf} \
		|| die
	emake || die
}

src_install() {
	egamesinstall || die
	dodoc AUTHORS ChangeLog NEWS README
	prepgamesdirs
}
