# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Spider  <spider@gentoo.org>
# Maintainer: Spider <spider@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-wm/sawfish/sawfish-20020502-r1.ebuild,v 1.1 2002/05/22 22:45:18 spider Exp $

# Do _NOT_ strip symbols in the build! Need both lines for Portage 1.8.9+
DEBUG="yes"
RESTRICT="nostrip"
# force debug information
CFLAGS="${CFLAGS} -g"
CXXFLAGS="${CXXFLAGS} -g"

MY_P=${PN}-2002-05-02

S=${WORKDIR}/${MY_P}
DESCRIPTION="Extensible window manager using a Lisp-based scripting language"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/${PN}/${MY_P}.tar.bz2"
HOMEPAGE="http://sawmill.sourceforge.net/"

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=x11-libs/rep-gtk-20020419
	>=dev-libs/librep-20020419
	>=media-libs/imlib-1.9.10-r1
	esd? ( >=media-sound/esound-0.2.22 )
	readline? ( >=sys-libs/readline-4.1 )
	nls? ( sys-devel/gettext )"

src_compile() {
	# hack around source bug
	echo "(eval-when-compile (require 'sawfish.wm.commands.xterm))" >>lisp/sawfish/wm/defaults.jl 
	local myconf
	myconf="${myconf} --with-gnome-prefix=/usr"
	myconf="${myconf} --enable-gnome-widgets "
	myconf="${myconf} --enable-capplet"
	myconf="${myconf} --enable-themer"
		
	use esd && 	myconf="${myconf} --with-esd" ||myconf="${myconf} --without-esd"
	use readline && myconf="${myconf} --with-readline" || myconf="${myconf} --without-readline"
	use nls ||	myconf="${myconf} --disable-linguas"
		./configure --host=${CHOST} \
			--prefix=/usr  \
			--infodir=/usr/share/info \
			--libexecdir=/usr/lib \
			--with-audiofile ${myconf} || die
	mkdir ${S}/src/.libs
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS COPYING ChangeLog DOC FAQ NEWS README THANKS TODO
	
	# Add to Gnome CC's Window Manager list
	insinto /usr/share/gnome/wm-properties
	doins ${FILESDIR}/Sawfish.desktop

}



