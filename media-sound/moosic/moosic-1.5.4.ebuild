# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/moosic/moosic-1.5.4.ebuild,v 1.1 2007/07/27 21:45:24 drac Exp $

inherit distutils python

DESCRIPTION="Moosic is a music player that focuses on easy playlist management"
HOMEPAGE="http://www.nanoo.org/~daniel/moosic"
SRC_URI="http://www.nanoo.org/~daniel/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE="doc"

RDEPEND="virtual/python"
DEPEND="${RDEPEND}
	dev-python/setuptools"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:distutils.core:setuptools:' setup.py
}

src_install() {
	distutils_src_install
	rm -rf "${D}"/usr/share/doc/${PN}
	insinto /etc/bash_completion.d
	newins examples/completion ${PN}
	dodoc doc/{Moosic_API.txt,moosic_hackers.txt,Todo}
	dodoc examples/server_config
	use doc && dohtml doc/*.html
}

pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}"/usr/lib*/python${PYVER}/site-packages
}

pkg_postrm() {
	python_version
	python_mod_cleanup "${ROOT}"/usr/lib*/python${PYVER}/site-packages
}
