# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/distel/distel-3.2_p20071103.ebuild,v 1.2 2008/06/15 15:11:58 ulm Exp $

inherit elisp eutils

DESCRIPTION="Distributed Emacs Lisp for Erlang"
HOMEPAGE="http://fresh.homeunix.net/~luke/distel/"
# svn snapshot from http://distel.googlecode.com/svn/trunk/
SRC_URI="mirror://gentoo/${P}.tar.bz2"

# "New BSD License" according to http://code.google.com/p/distel/
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/erlang-11.2.5"
RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

pkg_setup() {
	built_with_use dev-lang/erlang emacs \
		|| die "${PN} requires dev-lang/erlang built with USE=emacs"
}

src_compile() {
	emake base info || die "emake failed"
	cd elisp
	elisp-comp *.el || die "elisp-comp failed"
}

src_install() {
	emake prefix="${D}"/usr install || die "emake install failed"
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
		|| die "elisp-site-file-install failed"
	doinfo doc/distel.info || die "doinfo failed"
	dodoc AUTHORS ChangeLog NEWS README* || die "dodoc failed"
}
