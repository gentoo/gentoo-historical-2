# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/bochs/bochs-2.0.ebuild,v 1.9 2004/06/27 23:01:44 vapier Exp $

DESCRIPTION="a pc emulator"
HOMEPAGE="http://bochs.sourceforge.net/"
SRC_URI="mirror://sourceforge/bochs/${P}.tar.gz
	 http://bochs.sourceforge.net/guestos/dlxlinux3.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ~ppc ~alpha"
IUSE="sdl"

DEPEND="virtual/libc
	virtual/x11
	sdl? ( media-libs/libsdl )"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}
	sed -i \
		-e "s:\$(WGET) \$(DLXLINUX_TAR_URL):cp ${DISTDIR}/dlxlinux3.tar.gz .:" \
		-e 's:BOCHSDIR=:BOCHSDIR=/usr/lib/bochs#:' \
		-e 's: $(BOCHSDIR): $(DESTDIR)$(BOCHSDIR):g' \
		Makefile.in
}

src_compile() {
	[ "$ARCH" == "x86" ] && myconf="--enable-idle-hack"
	use sdl && myconf="${myconf} --with-sdl" \
		|| myconf="${myconf} --without-sdl"
	./configure --enable-fpu --enable-cdrom --enable-control-panel \
	--enable-ne2000 --enable-sb16=linux --enable-slowdown --prefix=/usr \
	--infodir=/usr/share/info --mandir=/usr/share/man --host=${CHOST} --with-x11 $myconf || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc CHANGES CVS README TESTFORM.txt
}
