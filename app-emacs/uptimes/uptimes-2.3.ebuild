# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/uptimes/uptimes-2.3.ebuild,v 1.8 2004/06/24 22:26:47 agriffis Exp $

inherit elisp

IUSE=""

DESCRIPTION="Track and display emacs session uptimes."
HOMEPAGE="http://www.davep.org/emacs/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"

DEPEND="virtual/emacs
	app-emacs/boxquote"

SITEFILE=50uptimes-gentoo.el
