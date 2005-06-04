# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/pam_passwdqc/pam_passwdqc-0.7.5.ebuild,v 1.6 2005/06/04 19:12:56 flameeyes Exp $

inherit pam

DESCRIPTION="Password strength checking for PAM aware password changing programs"
HOMEPAGE="http://www.openwall.com/passwdqc/"
SRC_URI="http://www.openwall.com/pam/modules/pam_passwdqc/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ~alpha ~hppa ~mips ~amd64"

DEPEND=">=sys-libs/pam-0.72"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dopammod pam_passwdqc.so

	doman pam_passwdqc.8
	dodoc README

	echo
	einfo "To activate pam_passwdqc use pam_passwdqc.so instead"
	einfo "of pam_cracklib.so in /etc/pam.d/system-auth."
	einfo "Also, if you want to change the parameters, read up"
	einfo "on the man page."
	echo
}
