# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Donny Davies <woodchip@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-ftp/vsftpd/vsftpd-1.0.1.ebuild,v 1.1 2001/11/21 05:44:08 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Very Secure FTP Daemon written with speed, size and security in mind"
SRC_URI="ftp://ferret.lmh.ox.ac.uk/pub/linux/${P}.tar.gz"

DEPEND="virtual/glibc >=sys-libs/pam-0.75"
RDEPEND="${DEPEND} sys-apps/xinetd"

src_unpack() {

	unpack ${A} ; cd ${S}
	patch -p1 < ${FILESDIR}/${PF}-gentoo.diff || die "bad patchfile"
}

src_compile() {

	make CFLAGS="${CFLAGS}" || die "compile problem"
}

src_install () {

	dodir /home/ftp /usr/share/vsftpd/empty /var/log/vsftpd
	doman vsftpd.conf.5 vsftpd.8
	dosbin vsftpd

	dodoc AUDIT BENCHMARKS BUGS Changelog FAQ INSTALL KERNEL-2.4.0-WARNING
	dodoc LICENSE README README.security REWARD SIZE SPEED TODO TUNING
	docinto security ; dodoc SECURITY/*
	newdoc ${FILESDIR}/vsftpd.conf vsftpd.conf.sample
	newdoc vsftpd.conf vsftpd.conf.dist.sample

	insinto /etc ; doins ${FILESDIR}/ftpusers
	insinto /etc/vsftpd ; newins ${FILESDIR}/vsftpd.conf vsftpd.conf.sample
	insinto /etc/xinetd.d ; newins ${FILESDIR}/vsftpd.xinetd vsftpd
	insinto /etc/pam.d ; newins ${FILESDIR}/vsftpd.pam vsftpd
}
