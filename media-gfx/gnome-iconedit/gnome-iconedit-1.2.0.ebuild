# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Martin Schlemmer <azarah@gentoo.org>

S=${WORKDIR}/${P}
DESCRIPTION="Edits icons, what more can you say?"
SRC_URI="http://210.77.60.218/ftp/ftp.debian.org/pool/main/g/gnome-iconedit/gnome-iconedit_${PV}.orig.tar.gz"
HOMEPAGE="www.advogato.org/proj/GNOME-Iconedit/"

DEPEND=">=gnome-base/gnome-libs-1.4.1.2-r1
	>=x11-libs/gtk+-1.2.10-r4
	>=media-libs/gdk-pixbuf-0.11.0-r1
	media-libs/libpng
	>=gnome-base/gnome-print-0.30"
# Bonobo support is broken
#	bonobo? ( gnome-base/bonobo )"



src_unpack() {

	unpack ${A}

	# Fix some compile / #include errors
	cd ${S}
	patch -p1 <${FILESDIR}/gnome-iconedit.diff || die
	automake
	autoconf
}

src_compile() {
	local myconf

	use nls || myconf="--disable-nls"
	
	CFLAGS="${CFLAGS} `gnome-config --cflags print`"	

	./configure --host=${CHOST} 					\
		    --prefix=/usr					\
		    --with-sysconfdir=/etc				\
		    $myconf || die

	emake || die
}

src_install () {
	make prefix=${D}/usr sysconfdir=/etc install || die

	dodoc ABOUT-NLS AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
}
