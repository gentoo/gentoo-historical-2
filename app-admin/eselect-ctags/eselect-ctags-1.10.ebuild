# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-ctags/eselect-ctags-1.10.ebuild,v 1.5 2009/06/09 14:51:17 armin76 Exp $

MY_P="eselect-emacs-${PV}"
DESCRIPTION="Manages ctags implementations"
HOMEPAGE="http://www.gentoo.org/proj/en/lisp/emacs/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 m68k ~mips ppc ~ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=">=app-admin/eselect-1.0.10
	!<=app-admin/eselect-emacs-1.3"

S="${WORKDIR}/${MY_P}"

src_compile() { :; }

src_install() {
	insinto /usr/share/eselect/modules
	doins ctags.eselect || die
	doman ctags.eselect.5 || die
}
