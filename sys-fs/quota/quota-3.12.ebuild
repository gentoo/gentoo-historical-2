# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/quota/quota-3.12.ebuild,v 1.1 2004/10/03 10:28:05 vapier Exp $

inherit eutils

DESCRIPTION="Linux quota tools"
HOMEPAGE="http://sourceforge.net/projects/linuxquota/"
SRC_URI="mirror://sourceforge/linuxquota/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE="nls tcpd"

DEPEND="virtual/libc
	tcpd? ( sys-apps/tcp-wrappers )"

S=${WORKDIR}/quota-tools

src_unpack() {
	unpack ${A}
	cd ${S}

	# patch to prevent quotactl.2 manpage from being installed
	# that page is provided by man-pages instead
	epatch ${FILESDIR}/${PN}-no-quotactl-manpage.patch

	sed -i -e "s:,LIBS=\"\$saved_LIBS=\":;LIBS=\"\$saved_LIBS\":" configure
}

src_install() {
	dodir {sbin,etc,usr/sbin,usr/bin,usr/share/man/man{1,3,8}}
	make ROOTDIR=${D} install || die
#	install -m 644 warnquota.conf ${D}/etc
	insinto /etc
	insopts -m0644
	doins warnquota.conf quotatab
	dodoc doc/*

	exeinto /etc/init.d
	newexe ${FILESDIR}/quota.rc6 quota

	# NLS bloat reduction
	use nls || rm -rf ${D}/usr/share/locale
}

pkg_postinst() {
	einfo "with this release, you can configure the used"
	einfo "ports through /etc/services"
	einfo
	einfo "eg. use the default"
	einfo "rquotad               4003/tcp                        # quota"
	einfo "rquotad               4003/udp                        # quota"
}
