# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/emacspeak/emacspeak-29.0.ebuild,v 1.1 2008/12/13 22:51:15 williamh Exp $

inherit eutils

DESCRIPTION="the emacspeak audio desktop"
HOMEPAGE="http://emacspeak.sourceforge.net/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2
	mirror://gentoo/${P}-patches.tar.bz2"
LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=">=virtual/emacs-22"
RDEPEND="${DEPEND}
	>=dev-tcltk/tclx-8.4"

src_unpack() {
	unpack ${A}
	EPATCH_SUFFIX="patch" \
	epatch
}

src_compile() {
	make config || die
	make emacspeak || die
}

src_install() {
	make prefix="${D}"/usr install || die
	dodoc README etc/NEWS* etc/FAQ etc/COPYRIGHT
	dohtml -r install-guide user-guide
	dosed "s:/.*image/::" /usr/bin/emacspeak
}
