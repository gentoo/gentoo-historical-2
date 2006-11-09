# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/scons/scons-0.96.92-r3.ebuild,v 1.1 2006/11/09 21:54:48 twp Exp $

NEED_PYTHON="1.5.2"

inherit python distutils multilib

DESCRIPTION="Extensible Python-based build utility"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"
HOMEPAGE="http://www.scons.org"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE=""

DOCS="RELEASE.txt CHANGES.txt LICENSE.txt"

src_install () {
	distutils_src_install
	rm -rf ${D}/usr/man
	doman scons.1 sconsign.1
}

pkg_postinst() {
	python_mod_optimize ${ROOT}/usr/$(get_libdir)/${P}
	# clean up stale junk left there by old faulty ebuilds
	# see Bug 118022 and Bug 132448
	if has_version "<dev-util/scons-0.96.92-r1" ; then
		einfo "Cleaning up stale orphaned py[co] files..."
		[[ -d "${ROOT}/usr/$(get_libdir)/scons/SCons" ]] \
		    && rm -rf "${ROOT}/usr/$(get_libdir)/scons/SCons"
		einfo "Done."
	fi
}

pkg_postrm() {
	python_mod_cleanup ${ROOT}/usr/$(get_libdir)/${P}
}
