# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/skey/skey-1.1.5-r4.ebuild,v 1.1 2004/09/23 10:22:21 taviso Exp $

inherit flag-o-matic ccc eutils

DESCRIPTION="Linux Port of OpenBSD Single-key Password System"
HOMEPAGE="http://www.sparc.spb.su/solaris/skey/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD X11"
SLOT="0"
KEYWORDS="~alpha ~arm ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND="sys-libs/cracklib
	sys-apps/shadow
	dev-lang/perl
	virtual/libc"
# XXX: skeyaudit requires mailx.

src_unpack() {
	unpack ${A} ; cd ${S}

	# porting some updates to this skey implementation from the
	# NetBSD project, some other updates and fixes, and the addition
	# of some new features like shadow password and cracklib support.
	# 	(05 Nov 2003) -taviso@gentoo.org
	epatch ${FILESDIR}/skey-1.1.5-gentoo.diff.gz

	# glibc 2.2.x does not define LOGIN_NAME_MAX #33315
	# 	(12 Nov 2003) -taviso@gentoo.org
	epatch ${FILESDIR}/skey-login_name_max.diff

	epatch ${FILESDIR}/${P}-fPIC.patch

	# set the default hash function to md5, #63995
	# 	(14 Sep 2004) -taviso
	append-flags -DSKEY_HASH_DEFAULT=1

	# avoid suid related security issues.
	append-ldflags -Wl,-z,now
}

src_compile() {
	# skeyprune wont honour @sysconfdir@
	sed -i 's#/etc/skeykeys#/etc/skey/skeykeys#g' skeyprune.pl skeyprune.8

	econf --sysconfdir=/etc/skey || die
	emake || die
}

src_install() {
	doman skey.1 skeyaudit.1 skeyinfo.1 skeyinit.1 skeyprune.8
	dobin skey skeyinit skeyinfo || die
	newbin skeyprune.pl skeyprune
	newbin skeyaudit.sh skeyaudit
	dolib.a libskey.a
	dolib.so libskey.so.1.1.5 libskey.so.1.1 libskey.so.1 libskey.so

	insinto /usr/include
	doins skey.h

	dodir /etc/skey

	# only root needs to have access to these files.
	fperms g-rx,o-rx /etc/skey

	# skeyinit and skeyinfo must be suid root so users
	# can generate their passwords.
	fperms u+s,og-r /usr/bin/skeyinit /usr/bin/skeyinfo

	dodoc README CHANGES md4.copyright md5.copyright

	prepallman
}

pkg_postinst() {
	# do not include /etc/skey/skeykeys in the package, as quickpkg
	# may package personal files.
	# This also fixes the etc-update issue with #64974.
	touch /etc/skey/skeykeys && chmod 0600 /etc/skey/skeykeys || {
		ewarn "Please verify the permissions of /etc/skey/skeykeys are 0600."
	}

	einfo "For an instroduction into using s/key authentication, take"
	einfo "a look at the EXAMPLES section from the skey(1) manpage."
}
