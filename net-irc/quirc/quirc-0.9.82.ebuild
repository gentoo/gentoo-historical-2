# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dmitriy Kropivnitskiy <nigde@mitechki.net> aka Jeld The Dark Elf
# $Header: /var/cvsroot/gentoo-x86/net-irc/quirc/quirc-0.9.82.ebuild,v 1.2 2002/05/22 14:12:29 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A GUI IRC client scriptable in Tcl/Tk"
SRC_URI="http://quirc.org/${P}.tar.gz"
HOMEPAGE="http://quirc.org/"

DEPEND="dev-lang/tcl 
	dev-lang/tk"


src_compile() {

	econf \
		--datadir=/usr/share/quirc \
		|| die "./configure failed"

	emake || die
}

src_install () {

	exeinto /usr/bin
	doexe quirc

	insinto /usr/share/quirc
	doins data/*.tcl data/quedit data/fontsel data/servers data/VERSION

	insinto /usr/share/quirc/common
	doins ${S}/data/common/*.tcl

	insinto /usr/share/quirc/themes
	doins ${S}/data/themes/*.tcl

	# this package installs docs, but we would rather do that ourselves
	dodoc README NEWS INSTALL FAQ ChangeLog* COPYING AUTHORS
	dodoc doc/*.txt
}
