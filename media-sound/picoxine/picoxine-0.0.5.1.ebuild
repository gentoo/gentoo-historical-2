# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/picoxine/picoxine-0.0.5.1.ebuild,v 1.1 2006/06/09 17:01:28 flameeyes Exp $

inherit toolchain-funcs

DESCRIPTION="Very small xine frontend for playing audio events"
HOMEPAGE="http://www.kde-apps.org/content/download.php?content=39596"
SRC_URI="http://www.kde-apps.org/content/files/39596-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/xine-lib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm -f "${S}/${PN}"
}

doecho() {
	echo "$@"
	exec "$@"
}

src_compile() {
	doecho $(tc-getCC) -o ${PN} \
		${CFLAGS} $(pkg-config --cflags libxine) ${LDFLAGS} \
		${PN}.c -lm $(pkg-config --libs libxine) \
		|| die "build failed"
}

src_install() {
	dobin ${PN}
	dodoc CHANGELOG AUTHORS INSTALL
}

