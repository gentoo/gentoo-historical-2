# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gconf/ruby-gconf-0.1.ebuild,v 1.3 2002/05/27 17:27:37 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Ruby Gconf bindings"
SRC_URI="mirror://sourceforge/ruby-gnome/${P}.tar.gz"
HOMEPAGE="http://ruby-gnome.sourceforge.net/"

DEPEND=">=dev-lang/ruby-1.6.4-r1
		=x11-libs/gtk+-1.2*
		>=gnome-base/gconf-1.0.7-r2"

src_compile() {
	ruby extconf.rb || die "ruby extconf.rb failed"
	emake || die "emake failed"
}

src_install () {
	make install DESTDIR=${D}
	dodoc [A-Z]*
}
