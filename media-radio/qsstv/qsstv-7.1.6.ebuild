# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/qsstv/qsstv-7.1.6.ebuild,v 1.2 2012/01/09 16:04:18 tomjbe Exp $

EAPI=4

inherit multilib qt4-r2

MY_P=${P/-/_}

DESCRIPTION="Amateur radio SSTV software"
HOMEPAGE="http://users.telenet.be/on4qz/"
SRC_URI="http://users.telenet.be/on4qz/qsstv/downloads/${MY_P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-core[qt3support]
	media-libs/hamlib
	media-libs/alsa-lib
	sci-libs/fftw:3.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# fix docdirectory, install path and hamlib search path
	sed -i -e "s:/doc/\$\$TARGET:/doc/${PF}:" \
	    -e "s:local/bin:/bin:" \
		-e "s:target.extra:#target.extra:" \
		-e "s:-lhamlib:-L/usr/$(get_libdir)/hamlib -lhamlib:g" src/src.pro
	sed -i -e "s:doc/qsstv:doc/${PF}:" src/configdialog.cpp
}
