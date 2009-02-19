# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/outline-magic/outline-magic-0.9.ebuild,v 1.3 2009/02/19 22:19:45 tcunha Exp $

inherit elisp

DESCRIPTION="Outline mode extensions for Emacs"
HOMEPAGE="http://staff.science.uva.nl/~dominik/Tools/outline-magic.el"
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

SITEFILE=50${PN}-gentoo.el
