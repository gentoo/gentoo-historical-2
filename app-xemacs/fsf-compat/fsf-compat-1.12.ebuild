# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/fsf-compat/fsf-compat-1.12.ebuild,v 1.1.1.1 2005/11/30 09:38:54 chriswhite Exp $

SLOT="0"
IUSE=""
DESCRIPTION="FSF Emacs compatibility files."
PKG_CAT="standard"

DEPEND="app-xemacs/xemacs-base
"
KEYWORDS="amd64 x86 ppc alpha sparc ppc64"

inherit xemacs-packages
