# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/fsf-compat/fsf-compat-1.15.ebuild,v 1.2 2007/01/18 07:08:13 jer Exp $

SLOT="0"
IUSE=""
DESCRIPTION="FSF Emacs compatibility files."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base"

KEYWORDS="~alpha ~amd64 hppa ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages
