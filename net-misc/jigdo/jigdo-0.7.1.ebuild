# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/jigdo/jigdo-0.7.1.ebuild,v 1.3 2004/10/14 03:57:24 weeve Exp $

inherit eutils

DESCRIPTION="Jigsaw Download, or short jigdo, is a tool designed to ease the distribution of very large files over the internet, for example CD or DVD images."
HOMEPAGE="http://atterer.net/jigdo/"
SRC_URI="http://atterer.net/jigdo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ~ppc ~amd64"

IUSE="gtk nls berkdb libwww"

DEPEND="gtk? ( >=gtk+-2.0.6 )
	nls? ( sys-devel/gettext )
	berkdb? ( =sys-libs/db* )
	libwww? ( >=libwww-5.3.2 )"

src_compile() {
	local myconf

	use nls || myconf="${myconf} --disable-nls"
	use gtk && use libwww || myconf="${myconf} --without-gui"
	use berkdb || myconf="${myconf} --without-libdb"

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man ${myconf} \
		--datadir=/usr/share || die "./configure failed"

	# Patch the Makefile so that when jidgo is installed, jigdo-lite has
	# the correct path to the debian mirrors file.
	epatch ${FILESDIR}/makefile.patch

	emake || die
}

src_install() {
	einstall || die
	dodoc COPYING README THANKS VERSION changelog
	dodoc doc/*.txt
	dohtml doc/*.html
}
