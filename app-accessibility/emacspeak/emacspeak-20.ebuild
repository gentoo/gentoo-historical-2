# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/emacspeak/emacspeak-20.ebuild,v 1.1 2004/05/15 22:22:03 williamh Exp $

DESCRIPTION="the emacspeak audio desktop"
HOMEPAGE="http://emacspeak.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
RESTRICT="nomirror"
LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/emacs
	>=dev-tcltk/tclx-8.3"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4.0.7"

S=${WORKDIR}/${P}.0

src_compile() {
	make config SRC=`pwd` || die
	make emacspeak || die
}

src_install() {
	make \
		prefix=${D}/usr \
		install || die
	dodoc README etc/NEWS* etc/FAQ etc/COPYRIGHT
	dohtml -r install-guide user-guide
	sed -i -e "s@/.*image/@@" ${D}/usr/bin/emacspeak
}
