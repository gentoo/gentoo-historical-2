# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/inform-mode/inform-mode-1.5.8.ebuild,v 1.1.1.1 2005/11/30 09:41:14 chriswhite Exp $

inherit elisp

IUSE=""

DESCRIPTION="A major mode for editing Inform programs."
HOMEPAGE="http://rupert-lane.org/inform-mode/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc ~amd64"

S="${WORKDIR}/${PN}"

SITEFILE='50inform-mode-gentoo.el'
