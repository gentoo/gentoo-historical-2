# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sudo/sudo-1.6.7_p5-r2.ebuild,v 1.13 2005/03/04 06:17:07 vapier Exp $

inherit eutils

#
# TODO: Fix support for krb4 and krb5
#

DESCRIPTION="Allows certain users/groups to run commands as root"
HOMEPAGE="http://www.sudo.ws/"
SRC_URI="ftp://ftp.sudo.ws/pub/sudo/${P/_/}.tar.gz"

LICENSE="Sudo"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE="pam skey"

DEPEND="pam? ( >=sys-libs/pam-0.73-r1 )
	skey? ( >=app-admin/skey-1.1.5-r1 )"

S=${WORKDIR}/${P/_/}

src_unpack() {
	unpack ${A}
	use skey && epatch ${FILESDIR}/${PN}-skeychallengeargs.diff
	epatch ${FILESDIR}/${P}-strip-bash-functions.diff
}

src_compile() {
	econf \
		--with-all-insults \
		--disable-path-info \
		--with-env-editor \
		$(use_with pam) \
		$(use_with skey) \
		|| die "econf failed"
	emake || die
}

src_install() {
	einstall || die
	dodoc BUGS CHANGES HISTORY PORTING README RUNSON TODO \
		TROUBLESHOOTING UPGRADE sample.*
	dopamd ${FILESDIR}/sudo

	insinto /etc
	doins ${FILESDIR}/sudoers
	fperms 0440 /etc/sudoers
}

pkg_postinst() {
	use skey && use pam && {
		 ewarn "sudo will not use skey authentication when compiled with"
		 ewarn "pam support. to allow users to authenticate with one time"
		 ewarn "passwords, you should unset the pam USE flag for sudo."
	}
}
