# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libdrm/libdrm-2.0.ebuild,v 1.5 2006/01/31 13:48:35 killerfox Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org libdrm library"
HOMEPAGE="http://dri.freedesktop.org/"
SRC_URI="http://dri.freedesktop.org/libdrm/${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~s390 ~sh ~sparc ~x86"
RDEPEND=""
DEPEND="${RDEPEND}"

pkg_preinst() {
	x-modular_pkg_preinst

	if [[ -e ${ROOT}/usr/$(get_libdir)/libdrm.so.1 ]] ; then
		cp -pPR "${ROOT}"/usr/$(get_libdir)/libdrm.so.{1,1.0.0} "${IMAGE}"/usr/$(get_libdir)/
	fi
}

pkg_postinst() {
	x-modular_pkg_postinst

	if [[ -e ${ROOT}/usr/$(get_libdir)/libdrm.so.1 ]] ; then
		ewarn "You must re-compile all packages that are linked against"
		ewarn "libdrm 1 by using revdep-rebuild from gentoolkit:"
		ewarn "# revdep-rebuild --soname libdrm.so.1"
		ewarn "After this, you can delete /usr/$(get_libdir)/libdrm.so.1"
		ewarn "and /usr/$(get_libdir)/libdrm.so.1.0.0 ."
		epause
	fi
}
