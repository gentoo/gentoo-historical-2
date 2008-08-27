# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/fff/fff-20050517.ebuild,v 1.4 2008/08/27 07:14:56 ulm Exp $

inherit elisp

DESCRIPTION="Fast file finder for Emacs"
HOMEPAGE="http://www.splode.com/~friedman/software/emacs-lisp/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="|| (
		sys-apps/slocate
		sys-apps/mlocate
		sys-apps/rlocate
	)"

SITEFILE=50${PN}-gentoo.el
