# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libggi/libggi-2.1.0.ebuild,v 1.4 2005/04/10 00:56:30 josejx Exp $

inherit eutils libtool

DESCRIPTION="Fast and safe graphics and drivers for about any graphics card to the Linux kernel (sometimes)"
HOMEPAGE="http://www.ggi-project.org/"
SRC_URI="http://www.ggi-project.org/ftp/ggi/v2.1/${P}.src.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc"
IUSE="X aalib svga fbcon directfb dga 3dfx debug mmx vis"

DEPEND=">=media-libs/libgii-0.9.0
	X? ( virtual/x11 )
	svga? ( >=media-libs/svgalib-1.4.2 )
	aalib? ( >=media-libs/aalib-1.2-r1 )
	dga? (virtual/x11)"

src_compile() {
	elibtoolize

	local myconf=""

	use svga \
		|| myconf="${myconf} --disable-svga --disable-vgagl"

	if use !fbcon && use !directfb; then
		myconf="${myconf} --disable-fbdev --disable-directfb"
	elif use directfb; then
		myconf="${myconf} --enable-fbdev --enable-directfb"
	else
		myconf="${myconf} --enable-fbdev"
	fi

	if use amd64 || use ppc64 || use ia64 ; then
		myconf="${myconf} --enable-64bitc"
	else
		myconf="${myconf} --disable-64bitc"
	fi

	econf \
	$(use_with X x) \
	$(use_enable aalib aa) \
	$(use_enable vis) \
	$(use_enable mmx) \
	$(use_enable debug) \
	$(use_enable 3dfx glide) \
	${myconf} \
	|| die
	emake || die
}

src_install () {

	make \
		DESTDIR=${D} \
		install || die

	# This la file seems to bug mesa.
# Hopefully libtoolize will fix for mesa-3.5.  The *.la needed
# for mesa-5.0 in the works - <azarah@gentoo.org> (28 Dec 2002)
#	rm ${D}/usr/$(get_libdir)/*.la

	dodoc ChangeLog* FAQ NEWS README TODO
	docinto txt
	dodoc doc/*.txt
	docinto docbook
	dodoc doc/docbook/*.{dsl,sgml}
}
