# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/quanta/quanta-3.2.0_beta2.ebuild,v 1.1 2003/12/08 15:39:35 caleb Exp $

inherit kde

need-kde 3.2
S=${WORKDIR}/quanta-3.1.94

DESCRIPTION="A superb web development tool for KDE 3.x"
HOMEPAGE="http://quanta.sourceforge.net/"
SRC_URI="mirror://kde/unstable/3.1.94/src/quanta-3.1.94.tar.bz2"
IUSE="doc"

newdepend "doc? ( app-doc/quanta-docs )"

LICENSE="GPL-2"
KEYWORDS="~x86"

src_install() {
	kde_src_install
}
