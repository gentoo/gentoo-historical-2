# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/latex-base/latex-base-1.0.ebuild,v 1.6 2009/05/05 07:21:53 fauli Exp $

DESCRIPTION="Virtual for basic LaTeX binaries"
HOMEPAGE="http://www.latex-project.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| (
	dev-texlive/texlive-latexrecommended
	app-text/ptex
)"
