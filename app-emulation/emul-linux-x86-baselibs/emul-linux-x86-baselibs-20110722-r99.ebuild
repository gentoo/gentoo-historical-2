# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-baselibs/emul-linux-x86-baselibs-20110722-r99.ebuild,v 1.1 2011/07/22 19:08:59 pacho Exp $

EAPI="4"

inherit emul-linux-x86

SRC_URI="${SRC_URI}
	http://dev.gentoo.org/~pacho/emul-linux-x86-${PV}/llvm-2.9-r2.tbz2
	http://dev.gentoo.org/~pacho/emul-linux-x86-${PV}/libffi-3.0.9-r2.tbz2"

LICENSE="|| ( Artistic GPL-2 ) || ( BSD GPL-2 ) BZIP2 CRACKLIB DB
		GPL-2 || ( GPL-2 AFL-2.1 ) LGPL-2 LGPL-2.1 GPL-3 LGPL-3
		MIT MPL-1.1 OPENLDAP OpenSoftware openssl OracleDB ZLIB
		tcp_wrappers_license as-is UoI-NCSA"
KEYWORDS="-* ~amd64"

DEPEND=""
RDEPEND="!<app-emulation/emul-linux-x86-medialibs-10.2" # bug 168507

QA_DT_HASH="usr/lib32/.*"

src_prepare() {
	export ALLOWED="(${S}/lib32/security/pam_filter/upperLOWER|${S}/etc/env.d|${S}/lib32/security/pam_ldap.so)"
	emul-linux-x86_src_prepare
	rm -rf "${S}/etc/env.d/binutils/" \
			"${S}/usr/i686-pc-linux-gnu/lib" \
			"${S}/usr/lib32/engines/" \
			"${S}/usr/lib32/openldap/" || die

	ln -s ../share/terminfo "${S}/usr/lib32/terminfo" || die
}
