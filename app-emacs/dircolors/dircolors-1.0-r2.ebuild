# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/dircolors/dircolors-1.0-r2.ebuild,v 1.2 2007/11/04 08:33:56 ulm Exp $

inherit elisp

DESCRIPTION="Provide the same facility of ls --color inside Emacs"
HOMEPAGE="http://lfs.irisa.fr/~pad/rawaccess.query/hacks/dircolors.el"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE=""

SITEFILE=51${PN}-gentoo.el
