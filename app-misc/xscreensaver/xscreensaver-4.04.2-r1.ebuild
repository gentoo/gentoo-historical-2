# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Martin Schlemmer <azarah@gentoo.org> 
# $Header: /var/cvsroot/gentoo-x86/app-misc/xscreensaver/xscreensaver-4.04.2-r1.ebuild,v 1.1 2002/06/06 22:19:53 seemant Exp $

S="${WORKDIR}/${P/.2/}"
DESCRIPTION="a modular screensaver for X11"
SRC_URI="http://www.jwz.org/xscreensaver/${P}.tar.gz"
HOMEPAGE="http://www.jwz.org/xscreensaver/"

DEPEND="virtual/x11 sys-devel/bc
	gtk? ( x11-libs/gtk+ )
	motif? ( >=x11-libs/openmotif-2.1.30 )
	opengl? ( virtual/opengl >=media-libs/gle-3.0.1 )
	gnome? ( media-libs/gdk-pixbuf
		>=gnome-base/control-center-1.4.0.1-r1 )
	pam? ( >=sys-libs/pam-0.75 )
	dev-libs/libxml2"

src_unpack() {

	unpack ${A}
	cd ${S}

	use nls && ( \
		cd po
		patch -p0 < ${FILESDIR}/${P}-gentoo.diff
	) || ( \
		cp Makefile.in Makefile.in.orig
		sed "s:hacks/glx po:hacks/glx:" \
			Makefile.in.orig > Makefile.in
	)
}

src_compile() {
	local myconf=""
	use gnome && myconf="${myconf} --with-gnome" || myconf="${myconf} --without-gnome"
	use gtk && 	myconf="${myconf} --with-gtk" || myconf="${myconf} --without-gtk"
	use motif && myconf="${myconf} --with-motif" || myconf="${myconf} --without-motif"
	use pam && myconf="${myconf} --with-pam" || myconf="${myconf} --without-pam"
	use opengl myconf="${myconf} --with-gl --with-gle" || myconf="${myconf} --without-gl --without-gle"
	export C_INCLUDE_PATH="/usr/include/libxml2/libxml/"
	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--host="${CHOST}" \
		--enable-hackdir=/usr/lib/xscreensaver \
		--with-mit-ext \
		--with-dpms-ext \
		--with-xinerama-ext \
		--with-xf86vmode-ext \
		--with-xf86gamma-ext \
		--with-proc-interrupts \
		--with-xpm \
		--with-xshm-ext \
		--with-xdbe-ext \
		--enable-locking \
		${myconf} || die
		
	emake || die
}

src_install() {

	[ -n "$KDEDIR" ] && dodir "$KDEDIR/bin"
	
	make install_prefix="${D}" install || die

	if [ "`use pam`" ]
	then
		insinto /etc/pam.d
		doins "${FILESDIR}/pam.d/xscreensaver"
	fi
}
