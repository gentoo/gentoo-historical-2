# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libevent/libevent-1.4.7.ebuild,v 1.3 2008/11/12 13:23:52 fmccor Exp $

inherit libtool

MY_P="${P}-stable"

DESCRIPTION="A library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="http://monkey.org/~provos/libevent/"
SRC_URI="http://monkey.org/~provos/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="!dev-libs/9libs"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	prevver=$(best_version ${CATEGORY}/${PN})
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# don't waste time building tests/samples
	sed -i \
		-e 's|^\(SUBDIRS =.*\)sample test\(.*\)$|\1\2|' \
		Makefile.in || die "sed Makefile.in failed"

	elibtoolize
}

src_test() {
	einfo "Building tests"
	cd test
	make test || die "failed to build tests"

	einfo "Running tests"
	./test.sh > "${T}"/tests
	cat "${T}"/tests
	grep FAILED "${T}"/tests &>/dev/null && die "1 or more tests failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README
}
