# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-psutils/texlive-psutils-2008.ebuild,v 1.12 2010/01/15 09:16:56 fauli Exp $

TEXLIVE_MODULE_CONTENTS="dvipsconfig bin-getafm bin-pstools bin-psutils bin-t1utils collection-psutils
"
TEXLIVE_MODULE_DOC_CONTENTS="bin-getafm.doc bin-pstools.doc bin-psutils.doc bin-t1utils.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit texlive-module
DESCRIPTION="TeXLive Extra font utilities"

LICENSE="GPL-2 GPL-1 LPPL-1.3 public-domain "
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"
