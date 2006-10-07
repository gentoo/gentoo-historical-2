# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/metakit/metakit-2.4.9.3-r2.ebuild,v 1.20 2006/10/07 13:19:32 blubb Exp $

inherit python multilib eutils

DESCRIPTION="Embedded database library"
HOMEPAGE="http://www.equi4.com/metakit/"
SRC_URI="http://www.equi4.com/pub/mk/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 hppa ia64 ppc s390 sparc x86"
IUSE="python tcltk"

DEPEND=">=sys-apps/sed-4
	python? ( >=dev-lang/python-2.2.1 )
	tcltk? ( >=dev-lang/tcl-8.3.3-r2 )"

RESTRICT="test"

src_unpack() {
	python_version

	unpack ${A} ; cd ${S}
	# Fix all hardcoded python2.3 paths
	for name in python/scxx/PWOBase.h python/PyHead.h python/PyStorage.cpp ; do
		sed -i -e "s:Python.h:python${PYVER}/Python.h:" ${name}
	done
	sed -i -e "s:python2.3:python${PYVER}:" unix/configure
	sed -i -e "s:^\(CXXFLAGS = \).*:\1${CXXFLAGS}:" unix/Makefile.in

	epatch "${FILESDIR}"/${P}-64bit.patch
}

src_compile() {
	local myconf
	use python && myconf="--with-python=/usr/include/python${PYVER},/usr/$(get_libdir)/python${PYVER}/site-packages"
	use tcltk && myconf="${myconf} --with-tcl=/usr/include,/usr/$(get_libdir)"

	CXXFLAGS="${CXXFLAGS}" unix/configure \
		${myconf} \
		--host=${CHOST} \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"

	emake || die
}

src_install () {
	python_version

	use python && dodir /usr/$(get_libdir)/python${PYVER}/site-packages
	make DESTDIR=${D} install || die

	dodoc CHANGES README WHATSNEW
	dohtml MetaKit.html
	dohtml -a html,gif,png,jpg -r doc/*
}
