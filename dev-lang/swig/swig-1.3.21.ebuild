# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/swig/swig-1.3.21.ebuild,v 1.34 2007/01/10 17:51:21 hkbst Exp $

inherit flag-o-matic mono #48511

DESCRIPTION="Simplified Wrapper and Interface Generator"
HOMEPAGE="http://www.swig.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64 s390 sh ppc64"
IUSE="doc java guile python tcl tk ruby perl php"

DEPEND="virtual/libc
	python? ( >=dev-lang/python-2.0 )
	java? ( virtual/jdk )
	ruby? ( virtual/ruby )
	guile? ( >=dev-scheme/guile-1.4 )
	tcl? ( dev-lang/tcl )
	tk? ( dev-lang/tk )
	perl? ( >=dev-lang/perl-5.6.1 )
	php? ( virtual/php )"

S=${WORKDIR}/SWIG-${PV}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:$(M4_INSTALL_DIR):$(DESTDIR)$(M4_INSTALL_DIR):g' Makefile.in
}

src_compile() {
	strip-flags

	local myconf
	if use ruby ; then
		local rubyver="`ruby --version | cut -d '.' -f 1,2`"
		export RUBY="/usr/lib/ruby/${rubyver/ruby /}/"
	fi

	econf \
		`use_with python py` \
		`use_with java java "${JAVA_HOME}"` \
		`use_with java javaincl "${JAVA_HOME}/include"` \
		`use_with ruby ruby /usr/bin/ruby` \
		`use_with guile` \
		`use_with tcl` \
		`use_with perl perl5 /usr/bin/perl` \
		`use_with php php4` \
		|| die

	# fix the broken configure script
	use tcl || sed -i -e "s:am__append_1 =:#am__append_1 =:" Runtime/Makefile

	`has_version dev-lisp/plt` && PLT=/usr/share/plt/collects
	`has_version dev-lisp/mzscheme` && PLT=/usr/share/mzscheme/collects

	emake || die
	emake runtime PLTCOLLECTS=$PLT || die
}

src_install() {
	make install install-runtime DESTDIR=${D} || die
	dodoc ANNOUNCE CHANGES FUTURE NEW README TODO
	use doc && dohtml -r Doc/{Devel,Manual}
}

src_test() {
	einfo "FEATURES=\"maketest\" has been disabled for dev-lang/swig"
}
