# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipython/ipython-0.8.1.ebuild,v 1.2 2007/07/26 18:17:54 corsair Exp $

NEED_PYTHON=2.3

inherit distutils elisp-common

DESCRIPTION="An advanced interactive shell for Python."
HOMEPAGE="http://ipython.scipy.org/"
SRC_URI="http://ipython.scipy.org/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~s390 ~x86"
IUSE="doc examples emacs gnuplot"

RDEPEND="gnuplot? ( dev-python/gnuplot-py )
	emacs? ( virtual/emacs
		app-emacs/python-mode )
	dev-python/pexpect"
DEPEND="${RDEPEND}"

PYTHON_MODNAME="IPython"
SITEFILE="62ipython-gentoo.el"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e '/examfiles/d' -e '/examples/d' \
		-e "/'manual'/d" -e '/manfiles)/d' \
		-e 's/^docfiles.*/docfiles=""/' \
		setup.py || die "sed failed"
}

src_compile() {
	distutils_src_compile
	if use emacs ; then
		cd doc
		elisp-comp ipython.el || die "elisp-comp failed"
	fi
}

src_install() {
	DOCS="doc/ChangeLog"
	distutils_src_install

	cd doc
	insinto /usr/share/doc/${PF}

	if use doc ; then
		dohtml manual/*
		doins *.pdf
	fi
	if use examples ; then
		doins -r examples
	fi
	if use emacs ; then
		elisp-install ${PN} ipython.el ipython.elc || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
