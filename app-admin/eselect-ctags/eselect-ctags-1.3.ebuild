# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-ctags/eselect-ctags-1.3.ebuild,v 1.5 2008/01/17 03:17:43 jer Exp $

MY_P="eselect-emacs-${PV}"
DESCRIPTION="Manages ctags implementations"
HOMEPAGE="http://www.gentoo.org/proj/en/lisp/emacs/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=">=app-admin/eselect-1.0.10
	!<=app-admin/eselect-emacs-1.3"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/eselect/modules
	doins ctags.eselect || die "doins failed"
	doman ctags.eselect.5 || die "doman failed"
}
