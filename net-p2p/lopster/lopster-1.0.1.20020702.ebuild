# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-p2p/lopster/lopster-1.0.1.20020702.ebuild,v 1.1 2002/07/02 13:10:38 seemant Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="A Napster Client using GTK"
SRC_URI="http://www.ibiblio.org/pub/Linux/distributions/gentoo/distfiles/${P}.tar.bz2"
HOMEPAGE="http://lopster.sourceforge.net"
SLOT="0"
LICENSE="GPL-2"

DEPEND="=x11-libs/gtk+-1.2*"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	./autogen.sh
	autoconf
	cp configure.in configure.in.orig
	sed -e "s:^intl/Makefile::" \
		-e "s:AM_GNU_GETTEXT::" \
		configure.in.orig > configure.in
	
	cp Makefile.am Makefile.am.orig
	sed "s:SUBDIR.*:SUBDIRS = m4 src:" \
		Makefile.am.orig > Makefile.am

	automake
	
	econf || die

	emake || die

}

src_install () {

	einstall || die
	dodoc AUTHORS BUGS README ChangeLog NEWS TODO
}

