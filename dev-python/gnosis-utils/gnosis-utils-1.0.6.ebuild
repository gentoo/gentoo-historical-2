# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnosis-utils/gnosis-utils-1.0.6.ebuild,v 1.7 2004/06/25 01:30:40 agriffis Exp $

inherit distutils

IUSE=""
MY_P=${P/gnosis-utils/Gnosis_Utils}

S=${WORKDIR}/${MY_P}

DESCRIPTION="XML pickling and objectification with Python."
SRC_URI="http://www.gnosis.cx/download/Gnosis_Utils.OLD/${MY_P}.tar.gz"
HOMEPAGE="http://www.gnosis.cx/download/"

DEPEND="virtual/python"

SLOT="0"
KEYWORDS="x86"
LICENSE="PYTHON"

src_compile() {
	python setup_gnosis.py build || die
}

src_install() {
	distutils_python_version

	python setup_gnosis.py install --root=${D} || die

	dodir /usr/share/doc/${PF}
	dodoc README MANIFEST PKG-INFO

	if [ -e "${D}/usr/lib/python${PYVER}/site-packages/gnosis/doc" ] ; then
		einfo "Moving documentation to correct location"
		mv ${D}/usr/lib/python${PYVER}/site-packages/gnosis/doc ${D}/usr/share/doc/${PF}/doc
	fi

	rm -f ${D}/usr/lib/python${PYVER}/site-packages/gnosis/{README,MANIFEST}
	rm -f ${D}/usr/lib/python${PYVER}/site-packages/{README,MANIFEST}
}
