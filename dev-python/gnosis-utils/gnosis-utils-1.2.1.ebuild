# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnosis-utils/gnosis-utils-1.2.1.ebuild,v 1.1 2007/02/15 21:02:50 dev-zero Exp $

NEED_PYTHON=2.1

inherit distutils

MY_P=Gnosis_Utils-${PV}

DESCRIPTION="XML pickling and objectification with Python."
SRC_URI="http://www.gnosis.cx/download/${MY_P}.tar.gz"
HOMEPAGE="http://www.gnosis.cx/download/"
SLOT="0"
KEYWORDS="~ia64 ~x86"
LICENSE="PYTHON"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_MODNAME="gnosis"

S=${WORKDIR}/${MY_P}

src_install() {
	dodoc README gnosis/doc/{*.txt,readme,GETTING_HELP,*ANNOUNCE}
	newdoc gnosis/anon/README README.anon
	newdoc gnosis/xml/relax/README README.relax.xml

	# This setup.py installs files according to the MANIFEST.
	# README and MANIFEST have to get out, otherwise they may
	# generate collissions because they're directly installed in
	# site-packages.
	sed -i \
		-e '/README/d' \
		-e '/MANIFEST/d' \
		-e '/gnosis\/doc/d' \
		MANIFEST || die "sed failed"

	distutils_src_install
}
