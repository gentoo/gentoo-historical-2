# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mup/mup-4.4.ebuild,v 1.6 2004/06/08 00:39:06 agriffis Exp $

MY_P="${PN}44"

DESCRIPTION="Program for printing music scores."
SRC_URI="ftp://ftp.arkkra.com/pub/unix/${MY_P}src.tar.gz
	ftp://ftp.arkkra.com/pub/unix/${MY_P}doc.tar.gz"
HOMEPAGE="http://www.arkkra.com"
LICENSE="Arkkra"
SLOT="0"
KEYWORDS="x86"
IUSE="X svga"

DEPEND=">=sys-apps/sed-4"
RDEPEND="X? ( virtual/x11 )
	svga? ( >=media-libs/svgalib-1.4.3 )"

S="${WORKDIR}"

src_unpack() {
	mkdir doc

	unpack ${MY_P}src.tar.gz

	cd doc
	unpack ${MY_P}doc.tar.gz
}

src_compile() {
	local param

	cd mup
	cc -O2 -o mup *.c -lm || die "compile mup failed"

	cd ../mkmupfnt
	cc -o mkmupfnt *.c || die "compile mkmupfnt failed"

	if use X || use svga; then
		cd ../mupdisp
		if use X ; then
			param="-lX11 -L/usr/X11R6/lib"
		else
			sed -i '/^#define XWINDOW/d' dispttyp.h || die "sed failed"
		fi
		if use svga ; then
			param="${param} -lvga"
		else
			param="${param} -DNO_VGA_LIB"
		fi
		cc -o mupdisp *.c -lm ${param} || die "compile mupdisp failed"
	fi
}

src_install () {
	dobin mup/mup
	dobin mkmupfnt/mkmupfnt
	dobin mupprnt
	if [ -n "`use X`" -o -n "`use svga`" ] ; then
		dobin mupdisp/mupdisp
	fi

	dodoc license.txt README0
	cd doc
	dodoc faq.txt mupfeat.txt overview.txt register.txt README1 \
		mkmupfnt.ps mupdisp.ps mupprnt.ps mup.ps mupqref.ps oddeven.ps uguide.ps

	doman mup.1 mupprnt.1 mkmupfnt.1
	if use X || use svga; then
		doman mupdisp.1
	fi

	dohtml uguide/*

	docinto sample
	dodoc sample.mup sample.ps star.mup star.ps template.mup
}

pkg_postinst() {
	if use svga ; then
		einfo "Please note that using mupdisp in SVGA mode on the console"
		einfo "requires that it can write to the console device. To allow"
		einfo "this, make mupdisp setuid to root, like this:"
		einfo ""
		einfo "\tchown root:root /usr/bin/mupdisp"
		einfo "\tchmod u+s /usr/bin/mupdisp"
	fi
	if use X || use svga; then
		echo
		einfo "If you want to use mupdisp, make sure you also install ghostscript."
	fi
}
