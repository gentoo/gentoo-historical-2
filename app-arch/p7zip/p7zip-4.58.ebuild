# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/p7zip/p7zip-4.58.ebuild,v 1.4 2008/11/07 04:28:27 jer Exp $

inherit eutils toolchain-funcs multilib

DESCRIPTION="Port of 7-Zip archiver for Unix"
HOMEPAGE="http://p7zip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_src_all.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ia64 ~ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE="static doc"

DEPEND=""

S=${WORKDIR}/${PN}_${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "/^CXX=/s:g++:$(tc-getCXX):" \
		-e "/^CC=/s:gcc:$(tc-getCC):" \
		-e "s:OPTFLAGS=-O:OPTFLAGS=${CXXFLAGS}:" \
		-e 's:-s ::' \
		-e '/Rar/d' \
		makefile* || die "changing makefiles"

	if use amd64; then
		ewarn "Using suboptimal -fPIC upstream makefile due to amd64 being detected. See #126722"
		cp -f makefile.linux_amd64 makefile.machine
	elif [[ ${CHOST} == *-darwin* ]] ; then
		# Mac OS X needs this special makefile, because it has a non-GNU linker
		cp -f makefile.macosx makefile.machine
	elif use x86-fbsd; then
		# FreeBSD needs this special makefile, because it hasn't -ldl
		sed -e 's/-lc_r/-pthread/' makefile.freebsd > makefile.machine
	fi
	use static && sed -i -e '/^LOCAL_LIBS=/s/LOCAL_LIBS=/&-static /' makefile.machine

	# patching to not included nonfree RAR decompression code is higher a sed call
	# But we're removing nonfree code just in case sed wasnt enough
	rm -rf CPP/7zip/Compress/Rar
}

src_compile() {
	emake all3 || die "compilation error"
}

src_install() {
	# this wrappers can not be symlinks, p7zip should be called with full path
	make_wrapper 7zr "/usr/lib/${PN}/7zr"
	make_wrapper 7za "/usr/lib/${PN}/7za"
	make_wrapper 7z "/usr/lib/${PN}/7z"

	dobin "${FILESDIR}/p7zip" || die

	# gzip introduced in 4.42, so beware :)
	newbin contrib/gzip-like_CLI_wrapper_for_7z/p7zip 7zg || die

	exeinto /usr/$(get_libdir)/${PN}
	doexe bin/7z bin/7za bin/7zr bin/7zCon.sfx || die "doexe bins"
	exeinto /usr/$(get_libdir)/${PN}
	doexe bin/*.so || die "doexe *.so files"

	doman man1/7z.1 man1/7za.1 man1/7zr.1
	dodoc ChangeLog README TODO

	if use doc ; then
		dodoc DOCS/*.txt
		dohtml -r DOCS/MANUAL/*
	fi

	einfo "Please be aware that rar support was removed (it's nonfree)"
	einfo "You can use app-arch/rar for rar support"
}
