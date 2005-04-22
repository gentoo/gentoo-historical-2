# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/bangexec/bangexec-1.3.0-r1.ebuild,v 1.1 2005/04/22 01:32:24 anarchy Exp $

inherit eutils

DESCRIPTION="GAIM Shell OutPut Plugin"
HOMEPAGE="http://bard.sytes.net/bangexec/"
SRC_URI="http://bard.sytes.net/bangexec/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""

DEPEND=">=net-im/gaim-1.0.1"

GAIMLIBDIR=$(get_libdir)/gaim

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i Makefile.in \
		-e 's:^\(plugindir = $(prefix)\)/lib/gaim:\1/GAIMLIBDIR:' \
		-e "s:GAIMLIBDIR:$GAIMLIBDIR:" \
		|| die "src_unpack failed"
}

src_install() {
	make install DESTDIR=${D} || die "Install failed"
	dodoc ChangeLog INSTALL README AUTHORS
}
