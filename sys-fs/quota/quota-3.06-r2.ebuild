# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/quota/quota-3.06-r2.ebuild,v 1.2 2005/01/03 00:11:56 ciaranm Exp $

inherit eutils

IUSE="nls tcpd"

S=${WORKDIR}/quota-tools
DESCRIPTION="Linux quota tools"
HOMEPAGE="http://sourceforge.net/projects/linuxquota/"
SRC_URI="mirror://sourceforge/linuxquota/${P}.tar.gz"

RESTRICT="nomirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha ~hppa ~mips amd64 ~ia64"

DEPEND="virtual/libc
	tcpd? ( sys-apps/tcp-wrappers )"

src_unpack() {
	unpack ${A}
	cd ${S}

	# patch to prevent quotactl.2 manpage from being installed
	# that page is provided by man-pages instead
	epatch ${FILESDIR}/${PN}-no-quotactl-manpage.patch

	sed -i -e "s:,LIBS=\"\$saved_LIBS=\":;LIBS=\"\$saved_LIBS\":" configure
}

src_install() {
	dodir {sbin,etc,usr/sbin,usr/bin,usr/share/man/man{1,2,3,8}}

	rm -f quotactl.2
	make ROOTDIR=${D} install || die
#	install -m 644 warnquota.conf ${D}/etc
	insinto /etc
	insopts -m0644
	doins warnquota.conf quotatab
	dodoc doc/*

	exeinto /etc/init.d
	newexe ${FILESDIR}/quota.rc quota

	# NLS bloat reduction
	use nls || rm -rf ${D}/usr/share/locale
}
