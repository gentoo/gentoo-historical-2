# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/xemacs-eterm/xemacs-eterm-1.13.ebuild,v 1.6 2004/06/24 23:25:45 agriffis Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Terminal emulation."
PKG_CAT="standard"

MY_PN=${PN/xemacs-/}

SRC_URI="ftp://ftp.xemacs.org/packages/${MY_PN}-${PV}-pkg.tar.gz"

DEPEND="app-xemacs/xemacs-base"
KEYWORDS="x86 ~ppc alpha sparc amd64"

inherit xemacs-packages

