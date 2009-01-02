# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-server/cyphesis/cyphesis-0.5.17.ebuild,v 1.2 2009/01/02 03:59:55 mr_bones_ Exp $

EAPI=1
inherit eutils autotools games

DESCRIPTION="WorldForge server running small games"
HOMEPAGE="http://worldforge.org/dev/eng/servers/cyphesis"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/skstream-0.3.6
	>=dev-games/wfmath-0.3
	=dev-games/mercator-0.2*
	dev-libs/libgcrypt
	dev-libs/libsigc++:2
	=media-libs/atlas-c++-0.6*
	>=media-libs/varconf-0.6.4
	virtual/postgresql-base"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Patching to disable howl and avahi discovery
	# To be removed when upstream will provide a way to selectively
	# enable/disable supoort for it
	epatch "${FILESDIR}/${P}"-gentoo.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog FIXME NEWS README THANKS TODO
	prepgamesdirs
}
