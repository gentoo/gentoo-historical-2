# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/seq24/seq24-0.4.3.ebuild,v 1.3 2004/03/01 05:37:16 eradicator Exp $

IUSE=""

DESCRIPTION="Small alsa sequencer"
HOMEPAGE="http://www.filter24.org/seq24/"
SRC_URI="http://www.filter24.org/seq24/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=media-libs/alsa-lib-0.9.0
	=gtkmm-1.2*"

S=${WORKDIR}/${P}

src_compile() {
	econf
	emake || die "build failed"
}

src_install() {
	einstall || die "install failed"
}

