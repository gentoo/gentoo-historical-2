# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/easygit/easygit-0.85.ebuild,v 1.1 2008/08/30 19:34:24 jokey Exp $

MY_P=eg-${PV}
DESCRIPTION="Easy GIT is a wrapper for git, designed to make git easy to learn and use."
HOMEPAGE="http://www.gnome.org/~newren/eg/"
SRC_URI="mirror://gentoo/${MY_P}.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

RDEPEND=">=dev-util/git-1.5.4
	dev-lang/perl"

src_install() {
	newbin "${WORKDIR}/${MY_P}" eg
}
