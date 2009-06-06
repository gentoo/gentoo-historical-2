# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-docs/python-docs-2.4.4-r1.ebuild,v 1.1 2009/06/06 18:48:21 arfrever Exp $

DESCRIPTION="HTML documentation for Python"
HOMEPAGE="http://www.python.org/doc/"
SRC_URI="http://www.python.org/ftp/python/doc/${PV}/html-${PV}.tar.bz2
http://www.python.org/ftp/python/doc/${PV}/info-${PV}.tar.bz2"

LICENSE="PSF-2.2"
SLOT="2.4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=app-admin/eselect-python-20090606"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack() {
	unpack html-${PV}.tar.bz2
	mkdir "${S}/info"
	cd "${S}/info"
	unpack info-${PV}.tar.bz2
	rm -f README python.dir
}

src_install() {
	docinto html
	cp -R "${S}/Python-Docs-${PV}/"* "${D}/usr/share/doc/${PF}/html"

	insinto /usr/share/info
	doins "${S}/info/"*

	echo "PYTHONDOCS_${SLOT//./_}=\"/usr/share/doc/${PF}/html/lib\"" > "60python-docs-${SLOT}"
	doenvd "60python-docs-${SLOT}"
}

pkg_postinst() {
	eselect python update --ignore 3.0 --ignore 3.1
}

pkg_postrm() {
	eselect python update --ignore 3.0 --ignore 3.1

	if ! has_version "<dev-python/python-docs-${SLOT}_alpha" && ! has_version ">=dev-python/python-docs-${SLOT%.*}.$((${SLOT#*.}+1))_alpha"; then
		rm -f "${ROOT}etc/env.d/65python-docs"
	fi

	rm -f "${ROOT}etc/env.d/50python-docs"
}
