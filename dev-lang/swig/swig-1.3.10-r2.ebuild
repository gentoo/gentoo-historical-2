# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Tools Team <tools@gentoo.org>
# Author: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-lang/swig/swig-1.3.10-r2.ebuild,v 1.1 2002/02/21 20:12:16 azarah Exp $

S=${WORKDIR}/SWIG-${PV}
DESCRIPTION="Simplied Wrapper and Interface Generator"
SRC_URI="http://telia.dl.sourceforge.net/swig/swig-${PV}.tar.gz"
HOMEPAGE="http://www.swig.org"

DEPEND="virtual/glibc
	>=sys-devel/gcc-2.95.2
	python? ( >=dev-lang/python-2.0 )
	java? ( virtual/jdk )
	ruby? ( >=dev-lang/ruby-1.6.1 )
	guile? ( >=dev-util/guile-1.4 )
	tcltk? ( >=dev-lang/tk-8.3 )
	perl? ( >=sys-devel/perl-5.6.1 )"
	
RDEPEND=""

src_compile() {
	local myc

	use python && myc="$myc --with-py" \
	           || myc="$myc --without-py"
	use java && myc="$myc --with-java=$JAVA_HOME --with-javaincl=${JAVA_HOME}/include" \
	         || myc="$myc --without-java"
	use ruby && myc="$myc --with-ruby=/usr/bin/ruby" \
	         || myc="$myc --without-ruby"
	use guile && myc="$myc --with-guile" \
	          || myc="$myc --without-guile"
	use tcltk && myc="$myc --with-tcl" \
	          || myc="$myc --without-tcl"
	use perl && myc="$myc --with-perl" \
	         || myc="$myc --without-perl"
	
	unset CXXFLAGS
	unset CFLAGS

	use ruby && local rubyver="`ruby --version | cut -d '.' -f 1,2`"
	use ruby && RUBY="/usr/lib/ruby/${rubyver/ruby /}/"
	
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		$myc || die "./configure failed"

	make || die
}

src_install () {
	make prefix=${D}/usr install || die
}
