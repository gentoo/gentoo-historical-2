# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gdkpixbuf/ruby-gdkpixbuf-0.26.ebuild,v 1.2 2002/05/27 17:27:37 drobbins Exp $

S=${WORKDIR}/ruby-gnome-${PV}/gdkpixbuf
DESCRIPTION="Ruby Gnome bindings"
SRC_URI="mirror://sourceforge/ruby-gnome/ruby-gnome-${PV}.tar.gz"
HOMEPAGE="http://ruby-gnome.sourceforge.net/"

DEPEND=">=dev-lang/ruby-1.6.4-r1
		>=dev-ruby/ruby-gtk-${PV}"

src_compile() {
	ruby extconf.rb || die "ruby extconf.rb failed"
	emake || die "emake failed"
}

src_install () {
	make site-install DESTDIR=${D}
	dodoc [A-Z]*
	cp -dr sample ${D}/usr/share/doc/${PF}
}
