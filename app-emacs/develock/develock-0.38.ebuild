# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/develock/develock-0.38.ebuild,v 1.3 2009/07/12 16:17:43 armin76 Exp $

inherit elisp

DESCRIPTION="An Emacs minor mode for highlighting broken formatting rules"
HOMEPAGE="http://www.jpl.org/ftp/pub/elisp/"
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

SITEFILE=50${PN}-gentoo.el
