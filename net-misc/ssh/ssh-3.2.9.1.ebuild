# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ssh/ssh-3.2.9.1.ebuild,v 1.5 2004/06/21 01:04:41 humpback Exp $

inherit gnuconfig

DESCRIPTION="SSH.COM free for Non-Comercial Use ssh version"
HOMEPAGE="http://www.ssh.com/"
SRC_URI="ftp://ftp.ssh.com/pub/ssh/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="ssh"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE="X ipv6 crypt openssh"

DEPEND="X? ( virtual/x11 )
	!openssh? ( !virtual/ssh )"
PROVIDE="virtual/ssh"

src_compile() {
	gnuconfig_update

	econf \
		`use_with ipv6 ipv6` \
		`use_with X` \
		`use_with crypt gpg` \
		|| die "configure failed"
	make || die "make failed"
}

src_install() {
	if [ -e ${ROOT}/etc/ssh2/hostkey ] ; then
		# this keeps the install from generating these keys again
		insinto /etc/ssh2
		doins ${ROOT}/etc/ssh2/hostkey{,.pub}
		fperms go-rwx /etc/ssh2/hostkey
	fi

	make install DESTDIR=${D} || die "install failed"
	chmod 600 ${D}/etc/ssh2/sshd2_config
	dodoc CHANGES FAQ HOWTO.anonymous.sftp README* SSH2.QUICKSTART

	insinto /etc/pam.d
	newins ${FILESDIR}/pamd.sshd2 sshd2
	exeinto /etc/init.d
	newexe ${FILESDIR}/sshd2 sshd2

	cd ${D}/usr
	use openssh && find bin sbin share/man -type l -exec rm '{}' \;
}
