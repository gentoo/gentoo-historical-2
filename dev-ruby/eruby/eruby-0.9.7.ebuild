# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintaner: Tools Team <tools@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/eruby/eruby-0.9.7.ebuild,v 1.4 2002/07/11 06:30:24 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="eRuby interprets a Ruby code embedded text file."
SRC_URI="http://www.modruby.net/archive/eruby-${PV}.tar.gz"
HOMEPAGE="http://www.modruby.net"
LICENSE="GPL-2/LGPL-2.1"
KEYWORDS="x86"
SLOT="0"

DEPEND="virtual/glibc
	>=dev-lang/ruby-1.6.1"

src_compile() {
	ruby ./configure.rb --with-charset=iso-8859-15 || die	
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README.* ChangeLog COPYING
}

pkg_postinst() {
	einfo "Run ebuild ruby-${PV}.ebuild config to update httpd.conf"
}

pkg_config() {
	if [ -f "${ROOT}/etc/httpd/httpd.conf" ] ; then
		einfo "Activating ruby interpretation for /ruby location"
		cp ${ROOT}/etc/httpd/httpd.conf ${ROOT}/etc/httpd/httpd.conf.orig
		echo "		
<IfModule mod_ruby.c>
RubyRequire apache/ruby-run

# Excucute files under /ruby as Ruby scripts
<Location /ruby>
	SetHandler ruby-object
	RubyHandler Apache::RubyRun.instance
</Location>

# Execute *.rbx files as Ruby scripts
<Files *.rbx>
	SetHandler ruby-object
	RubyHandler Apache::RubyRun.instance
</Files>
</IfModule>" >> ${ROOT}/etc/httpd/httpd.conf
	fi
}
