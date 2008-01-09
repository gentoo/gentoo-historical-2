# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/ecryptfs-utils/ecryptfs-utils-36.ebuild,v 1.2 2008/01/09 21:17:26 swegener Exp $

DESCRIPTION="eCryptfs userspace utilities"
HOMEPAGE="http://www.ecryptfs.org/"
SRC_URI="mirror://sourceforge/ecryptfs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="suid pam gtk openssl pkcs11 gpg doc"

RDEPEND=">=sys-apps/keyutils-1.0
	>=dev-libs/libgcrypt-1.2.0
	pam? ( sys-libs/pam )
	openssl? ( >=dev-libs/openssl-0.9.7 )
	pkcs11? (
		>=dev-libs/openssl-0.9.7
		>=dev-libs/pkcs11-helper-1.04
	)
	gpg? ( app-crypt/gpgme )
	gtk? ( x11-libs/gtk+ )"
# perl required for man generation
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0
	dev-lang/perl"

src_compile() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		$(use_enable pam) \
		$(use_enable openssl) \
		$(use_enable pkcs11 pkcs11-helper) \
		$(use_enable gpg) \
		$(use_enable gtk gui) \
		$(use_enable doc docs) \
		|| die
	emake || die
}

src_install(){
	emake DESTDIR="${D}" install || die
	use suid && fperms u+s /sbin/mount.ecryptfs
}

pkg_postinst() {
	if use suid; then
		ewarn
		ewarn "You have chosen to install ${PN} with the binary setuid root. This"
		ewarn "means that if there any undetected vulnerabilities in the binary,"
		ewarn "then local users may be able to gain root access on your machine."
		ewarn
	fi
}
