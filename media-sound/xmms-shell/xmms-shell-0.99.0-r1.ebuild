# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-sound/xmms-shell/xmms-shell-0.99.0-r1.ebuild,v 1.3 2002/07/22 00:48:14 seemant Exp $


S=${WORKDIR}/${P}
DESCRIPTION="XMMS-Shell is a simple utility to control XMMS externally."
SRC_URI="http://download.sourceforge.net/xmms-shell/${P}.tar.gz"
HOMEPAGE="http://www.loganh.com/xmms-shell/"
DEPEND=">=media-sound/xmms-1.2.7
	readline? ( >=sys-libs/readline-4.1 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_unpack() {
	unpack ${A}
	if [ -n "`readlink /etc/make.profile |grep gcc3`" ] 
	then
		# shall be sent upstream
		patch -p0 <${FILESDIR}/${PN}-gcc3.patch
	fi
}

src_compile() {
	local myconf

	use readline \
		&& myconf="${myconf} --with-readline" \
		|| myconf="${myconf} --without-readline"

	econf ${myconf} || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc AUTHORS README
}
