# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtk/ruby-gtk-0.27.ebuild,v 1.6 2002/07/11 06:30:24 drobbins Exp $

S=${WORKDIR}/ruby-gnome-all-${PV}/gtk
DESCRIPTION="Ruby Gtk+ bindings"
SRC_URI="mirror://sourceforge/ruby-gnome/ruby-gnome-all-${PV}.tar.gz"
HOMEPAGE="http://ruby-gnome.sourceforge.net/"
LICENSE="Ruby"
KEYWORDS="x86"
SLOT="0"

DEPEND=">=dev-lang/ruby-1.6.4-r1
        =x11-libs/gtk+-1.2*"

src_compile() {
	ruby extconf.rb || die "ruby extconf.rb failed"
	emake || die "emake failed"
}

src_install () {
	make install DESTDIR=${D}
	dodoc [A-Z]*
	cp -dr sample doc ${D}/usr/share/doc/${PF}
}
