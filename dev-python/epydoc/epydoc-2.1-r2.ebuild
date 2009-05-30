# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/epydoc/epydoc-2.1-r2.ebuild,v 1.19 2009/05/30 09:02:45 ulm Exp $

inherit distutils

DESCRIPTION="tool for generating API documentation for Python modules, based on their docstrings"
HOMEPAGE="http://epydoc.sourceforge.net/"
SRC_URI="mirror://sourceforge/epydoc/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="doc latex"

RDEPEND="latex? ( virtual/latex-base
		|| ( dev-texlive/texlive-latexextra app-text/ptex ) )"

src_install() {
	distutils_src_install

	doman "${S}"/man/*
	use doc && dohtml -r "${S}"/doc/*
}
