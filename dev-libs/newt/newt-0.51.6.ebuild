# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/newt/newt-0.51.6.ebuild,v 1.1 2005/04/01 13:43:46 xmerlin Exp $

inherit python toolchain-funcs eutils flag-o-matic

DESCRIPTION="Redhat's Newt windowing toolkit development files"
SRC_URI="mirror://gentoo/${P}.tar.gz
	http://dev.gentoo.org/~xmerlin/misc/${P}.tar.gz"
HOMEPAGE="http://www.redhat.com"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~hppa ~amd64 ~alpha ppc64"
IUSE="uclibc gpm"
DEPEND=">=sys-libs/slang-1.4
	>=dev-libs/popt-1.6
	dev-lang/python
	uclibc? ( sys-libs/ncurses )
	gpm? ( sys-libs/gpm )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/newt-gpm-fix.diff || die
	epatch ${FILESDIR}/newt-0.51.4-fix-wstrlen-for-non-utf8-strings.patch || die

	# bug 73850 
	if use uclibc; then
		sed -i -e 's:-lslang:-lslang -lncurses:g' ${S}/Makefile.in
	fi

	# use the correct compiler...
	sed -i -e 's:gcc:$(CC):g' ${S}/Makefile.in

	# avoid make cleaning up some intermediate files
	# as it would rebuild them during install :-(
	echo >>${S}/Makefile.in
	echo '$(LIBNEWT): $(LIBOBJS)' >>${S}/Makefile.in
}

src_compile() {
	python_version

	econf \
		$(use_with gpm gpm-support) \
		|| die

	# not parallel safe
	emake -j1 PYTHONVERS="python${PYVER}" RPM_OPT_FLAGS="${CFLAGS}" CC="$(tc-getCC)" || die "make failure"
}

src_install () {
	python_version
	# the RPM_OPT_FLAGS="ERROR" is there to catch a build error
	# if it fails, that means something in src_compile() didn't build properly
	# not parallel safe
	emake -j1 prefix="${D}/usr" PYTHONVERS="python${PYVER}" RPM_OPT_FLAGS="ERROR" install || die "make install failed"
	dodoc CHANGES COPYING peanuts.py popcorn.py tutorial.sgml
	dosym libnewt.so.${PV} /usr/lib/libnewt.so.0.50
}
