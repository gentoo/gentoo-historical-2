# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdtool/cdtool-2.1.5.ebuild,v 1.9 2004/09/14 07:25:25 eradicator Exp $

IUSE=""
DESCRIPTION="A package of command-line utilities to play and catalog cdroms."
HOMEPAGE=""
SRC_URI="http://www.ibiblio.org/pub/linux/apps/sound/cdrom/cli/cdtool-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc amd64"
DEPEND=""

src_compile() {
	emake || die
}

src_install() {
	dobin cdadd
	dobin cdctrl
	dobin cdown
	dobin cdloop
	dobin cdtool

	dosym cdtool /usr/bin/cdpause
	dosym cdtool /usr/bin/cdeject
	dosym cdtool /usr/bin/cdinfo
	dosym cdtool /usr/bin/cdir
	dosym cdtool /usr/bin/cdreset
	dosym cdtool /usr/bin/cdshuffle
	dosym cdtool /usr/bin/cdstart
	dosym cdtool /usr/bin/cdstop

	doman cdctrl.1 cdown.1 cdtool.1

	dodoc COPYING INSTALL README
}
