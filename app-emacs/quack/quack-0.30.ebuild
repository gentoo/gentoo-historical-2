# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/quack/quack-0.30.ebuild,v 1.2 2008/06/14 23:29:12 ulm Exp $

inherit elisp

DESCRIPTION="Enhances Emacs support for Scheme"
HOMEPAGE="http://www.neilvandyke.org/quack/"
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

SITEFILE=50${PN}-gentoo.el
