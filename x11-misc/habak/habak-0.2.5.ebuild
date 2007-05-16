# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/habak/habak-0.2.5.ebuild,v 1.13 2007/05/16 16:52:14 armin76 Exp $

DESCRIPTION="A simple but powerful tool to set desktop wallpaper"
HOMEPAGE="http://lubuska.zapto.org/~hoppke/"
SRC_URI="http://lubuska.zapto.org/~hoppke/yellow_brown/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="media-libs/imlib2
	|| ( x11-libs/libX11 virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( x11-proto/xproto virtual/x11 )"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# fix for as-needed, bug #141709
	sed -e 's/gcc $(LDFLAGS) \(.*\)/gcc \1 $(LDFLAGS)/' -i src/Makefile
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	dobin habak
	dodoc ChangeLog README TODO COPYING ${FILESDIR}/README.en
}
