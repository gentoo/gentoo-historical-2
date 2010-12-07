# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tclpython/tclpython-4.1-r2.ebuild,v 1.3 2010/12/07 19:43:12 jlec Exp $

PYTHON_DEPEND="2"

inherit distutils multilib toolchain-funcs

DESCRIPTION="Python package for Tcl"
HOMEPAGE="http://jfontain.free.fr/tclpython.htm"
SRC_URI="http://jfontain.free.fr/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-lang/tcl"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_compile() {
	cfile="tclpython tclthread"
	for src in ${cfile}; do
		compile="$(tc-getCC) -shared -fPIC ${CFLAGS} -I$(python_get_includedir) -c ${src}.c"
		einfo "${compile}"
		eval "${compile}" || die
	done

	link="$(tc-getCC) -fPIC -shared ${LDFLAGS} -o tclpython.so.${PV} tclpython.o tclthread.o -lpthread -lutil $(python_get_library -l) -ltcl"
	einfo "${link}"
	eval "${link}" || die
}

src_install() {
	insinto /usr/$(get_libdir)/tclpython
	doins tclpython.so.${PV} pkgIndex.tcl || die "tcl"
	fperms 775 /usr/$(get_libdir)/tclpython/tclpython.so.${PV}
	dosym tclpython.so.${PV} /usr/$(get_libdir)/tclpython/tclpython.so || die

	dodoc CHANGES INSTALL README || die
	dohtml tclpython.htm || die
}
