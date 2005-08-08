# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mailbase/mailbase-1.ebuild,v 1.8 2005/08/08 14:46:51 corsair Exp $

DESCRIPTION="MTA layout package"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ~ia64 ~mips ~ppc ~ppc-macos ppc64 s390 sh sparc x86"
IUSE="pam"

RDEPEND="pam? ( virtual/pam )"

S=${WORKDIR}

src_install() {
	dodir /etc/mail
	insinto /etc/mail
	doins ${FILESDIR}/aliases
	insinto /etc/
	doins ${FILESDIR}/mailcap

	keepdir /var/spool/mail
	fowners root:mail /var/spool/mail
	fperms 0775 /var/spool/mail
	dosym /var/spool/mail /var/mail

	if use pam;
	then
		insinto /etc/pam.d/

		# pop file and its symlinks
		newins ${FILESDIR}/common-pamd-include pop
		dosym /etc/pam.d/pop /etc/pam.d/pop3
		dosym /etc/pam.d/pop /etc/pam.d/pop3s
		dosym /etc/pam.d/pop /etc/pam.d/pops

		# imap file and its symlinks
		newins ${FILESDIR}/common-pamd-include imap
		dosym /etc/pam.d/imap /etc/pam.d/imap4
		dosym /etc/pam.d/imap /etc/pam.d/imap4s
		dosym /etc/pam.d/imap /etc/pam.d/imaps
	fi
}

pkg_postinst() {
	if [ "$(stat -c%a ${ROOT}/var/spool/mail/)" != "775" ] ; then
		echo
		ewarn
		ewarn "Your ${ROOT}/var/spool/mail/ directory permissions differ from"
		ewarn "  those which mailbase set when you first installed it (0775)."
		ewarn "  If you did not change them on purpose, consider running:"
		ewarn
		echo -e "\tchmod 0775 ${ROOT}/var/spool/mail/"
		echo
	fi
}
