# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/skey/skey-1.1.5.ebuild,v 1.1 2003/09/05 13:15:59 taviso Exp $

inherit flag-o-matic ccc

DESCRIPTION="Linux Port of OpenBSD Single-key Password System"
HOMEPAGE="http://www.sparc.spb.su/solaris/skey/"
SRC_URI="http://www.sparc.spb.su/solaris/skey/${P}.tar.bz2
		doc? ( http://www.ietf.org/rfc/rfc1938.txt )"

LICENSE="BSD X11"
SLOT="0"
KEYWORDS="~x86 ~alpha"

IUSE="doc"
RDEPEND=">=dev-lang/perl-5.8.0
		virtual/mta
		virtual/glibc"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}

src_compile() {

	if use alpha; then
		append-flags -fPIC
		append-ldflags -fPIC
	fi

	econf --sysconfdir=/etc/skey || die
	emake || die
}

src_install() {
	doman skey.1 skeyaudit.1 skeyinfo.1 skeyinit.1 skeyprune.8
	dobin skey skeyinit skeyinfo skeyaudit
	newbin skeyprune.pl skeyprune
	dolib.a libskey.a

	insinto /usr/include
	doins skey.h sha1.h rmd160.h

	insinto /etc/skey
	newins /dev/null skeykeys

	# only root needs to have access to these files.
	fperms g-rx,o-rx /etc/skey/skeykeys /etc/skey

	# skeyinit and skeyinfo must be suid root so users
	# can generate their passwords.
	#
	# probably a good idea to remove read permission to
	# suid binaries.
	fperms u+s,o-r,g-r /usr/bin/skeyinit /usr/bin/skeyinfo

	dodoc README CHANGES md4.copyright md5.copyright
	use doc && dodoc ${DISTDIR}/rfc1938.txt

	prepallman
}

pkg_postinst() {
	einfo "For an introduction into using S/Key authentication with"
	einfo "OpenSSH, SANS has a primer available here"
	einfo
	einfo "http://www.sans.org/rr/paper.php?id=100"
	einfo
	einfo "Please remember, to enable S/Key authentication with"
	einfo "openssh, you must install openssh with the skey USE"
	einfo "flag set."
}
