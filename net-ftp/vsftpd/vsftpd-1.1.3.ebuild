# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/vsftpd/vsftpd-1.1.3.ebuild,v 1.1 2003/02/15 16:43:43 woodchip Exp $

IUSE="pam tcpd"

DESCRIPTION="Very Secure FTP Daemon written with speed, size and security in mind"
SRC_URI="ftp://vsftpd.beasts.org/users/cevans/${P}.tar.gz"
HOMEPAGE="http://vsftpd.beasts.org/"
DEPEND="pam? ( >=sys-libs/pam-0.75 ) tcpd? ( >=sys-apps/tcp-wrappers-7.6 )"
RDEPEND="|| ( sys-apps/xinetd >=sys-apps/ucspi-tcp-0.88-r3 )"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"

src_unpack() {
	unpack ${A} || die
	cd ${S} || die
	patch -p1 <${FILESDIR}/${P}-gentoo.diff || die
	use tcpd && echo '#define VSF_BUILD_TCPWRAPPERS' >> builddefs.h
}

src_compile() {
	if use pam; then
		emake CFLAGS="${CFLAGS} -DUSE_PAM" || die
	else
		emake CFLAGS="${CFLAGS}" \
		LIBS='`./vsf_findlibs.sh | sed "/[/-]\<.*pam.*\>/d"`' || die
	fi
}

src_install() {
	into /usr
	doman vsftpd.conf.5 vsftpd.8
	dosbin vsftpd

	dodoc AUDIT BENCHMARKS BUGS Changelog FAQ INSTALL \
		LICENSE README README.security REWARD SIZE \
		SPEED TODO TUNING
	newdoc ${FILESDIR}/vsftpd.conf vsftpd.conf.sample
	newdoc vsftpd.conf vsftpd.conf.dist.sample
	docinto security ; dodoc SECURITY/*
	cp -a EXAMPLE ${D}/usr/share/doc/${PF}/examples
	chown -R root.root ${D}/usr/share/doc/${PF} # :\

	insinto /etc ; doins ${FILESDIR}/ftpusers
	insinto /etc/vsftpd ; newins ${FILESDIR}/vsftpd.conf vsftpd.conf.sample
	insinto /etc/xinetd.d ; newins ${FILESDIR}/vsftpd.xinetd vsftpd
	insinto /etc/pam.d ; newins ${FILESDIR}/vsftpd.pam vsftpd
}

pkg_postinst() {
	# empty dirs...
	install -m0755 -o root -g root -d ${ROOT}/home/ftp
	install -m0755 -o root -g root -d ${ROOT}/usr/share/vsftpd/empty
	install -m0755 -o root -g root -d ${ROOT}/var/log/vsftpd
}
