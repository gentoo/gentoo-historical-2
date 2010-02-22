# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/latex-base/latex-base-1.0.ebuild,v 1.9 2010/02/22 20:39:58 ulm Exp $

DESCRIPTION="Virtual for basic LaTeX binaries"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="|| (
	( dev-texlive/texlive-latexrecommended dev-texlive/texlive-fontutils )
	<dev-texlive/texlive-latexrecommended-2009
	app-text/ptex
)"
