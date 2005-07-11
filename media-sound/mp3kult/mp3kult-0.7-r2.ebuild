# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3kult/mp3kult-0.7-r2.ebuild,v 1.1 2005/07/11 20:22:07 fvdpol Exp $

IUSE=""

DESCRIPTION="Mp3Kult organizes your mp3/ogg collection in a Mysql database."
HOMEPAGE="http://mp3kult.sourceforge.net"
SRC_URI="mirror://sourceforge/mp3kult/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc ~amd64"

DEPEND=">=dev-db/mysql-3.22.32
	kde-base/kdelibs
	>=media-libs/id3lib-3.7.13
	>=media-libs/libogg-1.0
	>=media-libs/libvorbis-1.0"

src_compile() {
	export CXXFLAGS="${CXXFLAGS} -DUSE_OLD_FUNCTIONS=1"
	# For whatever reason defining USE_OLD_FUNCTIONS causes
	# link errors for ssl; the next line fixes it.

	### borrowed from kde.eclass #
	#
	# fix the sandbox errors "can't writ to .kde or .qt" problems.
	# this is a fake homedir that is writeable under the sandbox,
	# so that the build process can do anything it wants with it.
	REALHOME="$HOME"
	mkdir -p $T/fakehome/.kde
	mkdir -p $T/fakehome/.qt
	export HOME="$T/fakehome"
	addwrite "${QTDIR}/etc/settings"

	# things that should access the real homedir
	[ -d "$REALHOME/.ccache" ] && ln -sf "$REALHOME/.ccache" "$HOME/"

	export LDFLAGS="-lssl"
	econf || die
	emake || die
}

src_install () {
	einstall || die
	dodoc ABOUT-NLS AUTHORS COPYING INSTALL MANUAL NEWS README
}
