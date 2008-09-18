# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-emacs/eselect-emacs-1.5-r1.ebuild,v 1.3 2008/09/18 20:02:05 maekke Exp $

DESCRIPTION="Manages Emacs versions"
HOMEPAGE="http://www.gentoo.org/proj/en/lisp/emacs/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=">=app-admin/eselect-1.0.10
	~app-admin/eselect-ctags-${PV}"

src_install() {
	insinto /usr/share/eselect/modules
	doins {emacs,etags}.eselect || die "doins failed"
	doman {emacs,etags}.eselect.5 || die "doman failed"
	dodoc ChangeLog || die "dodoc failed"
}

pkg_postinst() {
	elog "emacs-updater is now a stand-alone package, app-admin/emacs-updater"
}
