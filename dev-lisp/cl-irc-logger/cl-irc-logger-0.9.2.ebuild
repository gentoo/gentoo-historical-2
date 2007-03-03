# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-irc-logger/cl-irc-logger-0.9.2.ebuild,v 1.5 2007/03/03 23:23:54 genone Exp $

inherit common-lisp eutils

DESCRIPTION="A Common Lisp IRC logger library"
HOMEPAGE="http://b9.com/"
SRC_URI="http://files.b9.com/irc-logger/irc-logger-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""
DEPEND="dev-lisp/cl-irc
	dev-lisp/cl-ppcre
	dev-lisp/cl-acl-compat"

CLPACKAGE=irc-logger

S=${WORKDIR}/irc-logger-${PV}

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PV}-acl-compat-gentoo.patch || die
}

src_install() {
	common-lisp-install *.asd *.lisp
	common-lisp-system-symlink
	dodoc LICENSE ${FILESDIR}/README.Gentoo
}

pkg_postinst() {
	common-lisp_pkg_postinst
	while read line; do elog "${line}"; done <${FILESDIR}/README.Gentoo
}
