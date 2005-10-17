# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/bangexec/bangexec-1.3.0.2.ebuild,v 1.4 2005/10/17 03:45:38 gothgirl Exp $

inherit eutils

DESCRIPTION="GAIM Shell OutPut Plugin"
HOMEPAGE="http://ignorance.sourceforge.net/bangexec"
SRC_URI="mirror:sourceforge/ignorance/bangexec/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""

DEPEND=">=net-im/gaim-1.0.1"

src_unpack() {
	unpack ${A}
	# Set correct plugindir
	sed -i -e "s:^\(plugindir = \$(prefix)/\)lib/:\1$(get_libdir)/:" \
		"${S}"/Makefile.in || die "sed failed"
}

src_install() {
	make install DESTDIR="${D}" || die "Install failed"
	dodoc ChangeLog INSTALL README AUTHORS
}
