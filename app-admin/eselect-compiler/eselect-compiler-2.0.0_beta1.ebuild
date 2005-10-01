# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-compiler/eselect-compiler-2.0.0_beta1.ebuild,v 1.1 2005/10/01 03:25:44 eradicator Exp $

DESCRIPTION="Utility to configure the active toolchain compiler"
HOMEPAGE="http://www.gentoo.org/"

MY_PN="compiler-config"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

SRC_URI=" http://dev.gentoo.org/~eradicator/toolchain/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND="app-admin/eselect"

pkg_postinst() {
	# Migrate from the old configs
	if [[ ! -f "${ROOT}/eselect/compiler/selection.conf" ]] ; then
		eselect compiler migrate
	fi

	# Update the wrappers
	eselect compiler update
}

src_install() {
	dodoc README
	make DESTDIR="${D}" install || die

	# This is installed by sys-devel/gcc-config
	rm ${D}/usr/bin/gcc-config
}
