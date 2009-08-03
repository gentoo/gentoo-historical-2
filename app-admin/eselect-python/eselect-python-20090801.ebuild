# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-python/eselect-python-20090801.ebuild,v 1.3 2009/08/03 15:07:14 flameeyes Exp $

DESCRIPTION="Manages multiple Python versions"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="mirror://gentoo/python.eselect-${PVR}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=">=app-admin/eselect-1.0.2"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/python.eselect-${PVR}" python.eselect || die "newins python.eselect failed"

	# Fix shebang (bug #279875).
	sed -e 's:/bin/sh:/bin/bash:' -i "${D}/usr/share/eselect/modules/python.eselect" || die "sed failed"
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-20090801"; then
		run_eselect_python_update="1"
	fi
}

pkg_postinst() {
	if [[ "${run_eselect_python_update}" == "1" ]]; then
		ebegin "Running \`eselect python update\`"
		eselect python update --ignore 3.0 --ignore 3.1 --ignore 3.2 > /dev/null
		eend "$?"
	fi
}
