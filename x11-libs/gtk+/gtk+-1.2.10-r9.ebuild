# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtk+/gtk+-1.2.10-r9.ebuild,v 1.7 2003/02/04 06:01:48 spider Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="The GIMP Toolkit"
HOMEPAGE="http://www.gtk.org/"
SRC_URI="ftp://ftp.gtk.org/pub/gtk/v1.2/${P}.tar.gz
	ftp://ftp.gnome.org/pub/GNOME/stable/sources/gtk+/${P}.tar.gz
	http://ftp.gnome.org/pub/GNOME/stable/sources/gtk+/${P}.tar.gz
	http://www.ibiblio.org/gentoo/distfiles/gtk+-1.2.10-r8-gentoo.diff.bz2"

DEPEND="virtual/x11
	=dev-libs/glib-1.2*
	nls? ( sys-devel/gettext
	dev-util/intltool )"

SLOT="1"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc sparc alpha"

src_unpack() {

	unpack ${P}.tar.gz
	
	cd ${S}/..
	bzcat ${DISTDIR}/gtk+-1.2.10-r8-gentoo.diff.bz2 | patch -p0
	
}

src_compile() {

	libtoolize --copy --force

	local myconf
	use nls || myconf="${myconf} --disable-nls"

	if [ "${DEBUGBUILD}" ]
	then
		myconf="${myconf} --enable-debug=yes"
	else
		myconf="${myconf} --enable-debug=minimum"
	fi

	econf \
		--sysconfdir=/etc/X11 \
		--with-xinput=xfree \
		--with-x \
		${myconf} || die

	emake || die
}

src_install() {

	make install DESTDIR=${D} || die

	preplib /usr

	dodoc AUTHORS COPYING ChangeLog* HACKING
	dodoc NEWS* README* TODO
	docinto docs
	cd docs
	dodoc *.txt *.gif text/*
	dohtml -r html

	#install nice, clean-looking gtk+ style
	insinto /usr/share/themes/Gentoo/gtk
	doins ${FILESDIR}/gtkrc
}

pkg_postinst() {
	ewarn "Older versions added /etc/X11/gtk/gtkrc which changed settings for"
	ewarn "all themes it seems.  Please remove it manually as it will not due"
	ewarn "to /env protection."
	echo ""
	einfo "The old gtkrc is available through the new Gentoo gtk theme."
}
