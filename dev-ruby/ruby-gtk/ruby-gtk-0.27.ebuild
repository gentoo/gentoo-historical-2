# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Thom Harp <thomharp@charter.net>
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtk/ruby-gtk-0.27.ebuild,v 1.2 2002/04/22 01:07:15 agriffis Exp $

S=${WORKDIR}/ruby-gnome-all-${PV}/gtk
DESCRIPTION="Ruby Gtk+ bindings"
SRC_URI="http://prdownloads.sourceforge.net/ruby-gnome/ruby-gnome-all-${PV}.tar.gz"
HOMEPAGE="http://ruby-gnome.sourceforge.net/"

DEPEND=">=dev-lang/ruby-1.6.4-r1
        >=x11-libs/gtk+-1.2.10-r4"

src_compile() {
	ruby extconf.rb || die "ruby extconf.rb failed"
	emake || die "emake failed"
}

src_install () {
	make install DESTDIR=${D}
	dodoc [A-Z]*
	cp -dr sample doc ${D}/usr/share/doc/${PF}
}
