# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/cryptplug/cryptplug-0.3.16.ebuild,v 1.1 2004/05/05 03:56:27 lv Exp $

DESCRIPTION="GPG and S/MIME encryption plugins.  Use by KMail v1.5 (KDE 3.1) and Mutt"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="ftp://ftp.gnupg.org/gcrypt/alpha/cryptplug/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~hppa amd64 ~alpha ~ia64"

DEPEND="=app-crypt/gpgme-0.3.14"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/cryptplug-0.3.16-64bit.dif
	epatch ${FILESDIR}/cryptplug-0.3.16-initialize-fix.diff
}

src_install() {
	einstall || die
}
