# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/view-process/view-process-2.4.ebuild,v 1.7 2005/01/01 14:05:08 eradicator Exp $

inherit elisp

IUSE=""

DESCRIPTION="A Elisp package For viewing and operating on the process list"
HOMEPAGE="http://www.emacswiki.org/cgi-bin/wiki.pl?ViewProcess"
SRC_URI="ftp://sunsite.unc.edu/pub/Linux/apps/editors/emacs/hm--view-process-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="virtual/emacs"

S="${WORKDIR}/view-process-mode"

SITEFILE=50hm--view-process-gentoo.el

src_install() {
	elisp-install ${PN} *.el
	elisp-site-file-install ${FILESDIR}/${SITEFILE}

	dodoc ANNOUNCEMENT INSTALL LSM README
}

pkg_postinst() {
	elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
