# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/zvbi/zvbi-0.2.1-r1.ebuild,v 1.4 2002/12/09 04:26:14 manson Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="VBI Decoding Library for Zapping"
SRC_URI="mirror://sourceforge/zapping/${P}.tar.bz2"
HOMEPAGE="http://zapping.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

DEPEND="virtual/x11
	nls? ( sys-devel/gettext )"

src_compile() {
	
	local myconf

	use nls || myconf="${myconf} --disable-nls"
	
	econf ${myconf} || die

	cp doc/zdoc-scan doc/zdoc-scan.orig 
	sed -e 's:usr/local/share/gtk-doc:usr/share/gtk-doc:' \
		doc/zdoc-scan.orig > doc/zdoc-scan 
	emake || die
}

src_install () {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
