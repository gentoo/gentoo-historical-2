# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/autoconf-mode/autoconf-mode-2.61.ebuild,v 1.4 2007/07/06 16:14:44 corsair Exp $

inherit elisp

DESCRIPTION="Emacs major modes for editing autoconf and autotest input"
HOMEPAGE="http://www.gnu.org/software/autoconf/autoconf.html"
SRC_URI="mirror://gnu/autoconf/autoconf-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~ia64 ~ppc64 ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

SITEFILE=50${PN}-gentoo.el
S="${WORKDIR}/autoconf-${PV}/lib/emacs"
