# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/qrq/qrq-0.2.0.ebuild,v 1.1 2011/10/31 14:05:52 tomjbe Exp $

EAPI="2"

DESCRIPTION="Yet another CW trainer for Linux/Unix"
HOMEPAGE="http://fkurz.net/ham/qrq.html"
SRC_URI="http://fkurz.net/ham/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pulseaudio"

DEPEND="sys-libs/ncurses
	pulseaudio? ( media-sound/pulseaudio )"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix ordering of compiler options
	sed -i -e "s/g++ -pth/g++ \$^ -pth/" \
		-e "s/\$@ \$^/\$@/" Makefile || die
	# avoid prestripping of 'qrq' binary
	sed -i -e "s/install -s -m/install -m/" Makefile || die
}

src_compile() {
	CONF="USE_PA=NO USE_OSS=YES"
	if use pulseaudio; then
		CONF="USE_PA=YES USE_OSS=NO"
	fi
	emake $CONF
}

src_install() {
	emake $CONF DESTDIR="${D}/usr" install || die
	dodoc AUTHORS ChangeLog README || die
}
